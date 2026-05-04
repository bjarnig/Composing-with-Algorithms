////////////////////////////////////////////////////////////////
//
//                     SC Cross
//
////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////

// Sounds to use for processing
~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
~testBuffer = Buffer.read(s, ~path ++ "sounds/concrete/cb.wav");

// Set the default server
s = Server.default;

// Add a test sampler
(

SynthDef(\testSampler, {|out=0, buf=0|
var signal;
signal = PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop:1, doneAction:2);
Out.ar(out, signal ! 2);
}).add;

)

(

// Create a function that will add an effect and then play a sample
~testEffect = {|effect, args|
	var bus, effectArgs;

	Routine({

		// Add the synthedef and call sync to wait until its done
		effect.add;
		s.sync;

		// Allocate a bus, play the effect and finally the sampler
		bus = Bus.audio(Server.local, 2);
		effectArgs = [\in, bus, \out, 0].addAll(args);
		effectArgs.postln;
		Synth(effect.name, effectArgs);
		Synth(\testSampler, [\out, bus, \buf, ~testBuffer]);

	}).play
};

)

//////////////////////// Processing /////////////////////////


/* 1. Simple Cross-synthesis by modulating oscillator amplitude using
the incoming sound as the source of control. Fed into a comb network. */

(

~testEffect.value(

	SynthDef(\crossPulse,
	{| in=0, out=0, freq=500|
	var sig, osc, verb, thres;
	sig = In.ar(in, 2);
	thres = Lag.kr(Amplitude.kr(sig), 0.1);
	osc = Splay.ar(Pulse.ar(Array.series(10, freq, 5))) * thres;
	verb = Mix.ar(Array.fill(10,{ CombL.ar(osc, 0.05, rrand(0.02, 0.04), 10.rand) }));
	Out.ar(out, osc + (verb * 0.5))}));
)



(

/* 2. Pitch tracking cross-synthesis with slight delay for stereo effect */

~testEffect.value(

	SynthDef(\test,
	{| in=0, out=0|
	var sig, effect, amp, freq, hasFreq;
	sig = In.ar(in, 1) * 2;
	amp = Amplitude.kr(sig, 0.05, 0.05);
    #freq, hasFreq = Tartini.kr(sig, 0.93, 1024, 512, 512);
    effect = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));
    6.do({ effect = AllpassN.ar(effect, 0.040, [0.040.rand,0.040.rand], 2) });
	effect = [DelayC.ar(effect, 0.01, 0.01);
		   , DelayC.ar(effect, 0.08, 0.08)];
	Out.ar(out, effect)}));

)



/* 3. Granulated input with Convolution reverb */

~pulsePath = ~path ++ "sounds/impulse.wav";
~irbuffer= Buffer.read(Server.default, ~pulsePath);
~fftsize = 2048;
~bufsize= PartConv.calcBufSize(~fftsize, ~irbuffer);
~irspectrum= Buffer.alloc(Server.default, ~bufsize, 1);
~irspectrum.preparePartConv(~irbuffer, ~fftsize);

(

~testEffect.value(

	SynthDef(\grainConv,
	{| in=0, out=0, fftsize=2048, specBufNum=8|
	var sig, verb;
	sig = GrainIn.ar(2, Dust.kr(120), 0.01, In.ar(in, 2));
	verb = PartConv.ar(SineShaper.ar(sig, 0.1), fftsize, specBufNum);
	Out.ar(out, (sig * 0.6) +  (verb * 0.4))}), [\specBufNum, ~irspectrum.bufnum]);
)


