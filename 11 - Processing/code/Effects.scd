////////////////////////////////////////////////////////////////
//
//                          Effects
//
////////////////////////////////////////////////////////////////

Effects, buses and routing. Delay-based effects, distortion/
waveshaping, spectral processing, filtering and more.


( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


// If needed to increase memory use server options
(
o = ServerOptions();
o.memSize = (16384 * 4);
s.reboot
)

// Add SynthDefs
(
    SynthDef(\pulse, {|out=0, freq=5|
		Out.ar(out, Pan2.ar(Impulse.ar(freq)));
	}).add;

    SynthDef(\reverb, {|in=0, out=0|
		var signal, rev;
		signal = In.ar(in, 2);
		rev = Mix(signal);
		6.do({ rev = LPF.ar(AllpassN.ar(rev, 1.0, [0.05.rand, 0.05.rand], 2.0), 7000)});
		ReplaceOut.ar(out, (signal * 0.6) + (rev * 0.3))
	}).add;
)


// Play them
(
    Synth("reverb");
    Synth("pulse");
)


// Load Samples to use later
(
    ~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
    ~path = ~path ++ "sounds/";
	~voice = Buffer.read(s, ~path ++ "vocal.wav");
	~trumpet = Buffer.read(s, ~path ++ "trumpet.wav");
	~sequence = Buffer.read(s, ~path ++ "sequence.wav");
)


// Create Synths to use with processing methods below.
(
    SynthDef(\buzz, {|out=0, freq=500, harmonics=25, dur=4|
		var env = EnvGen.kr(Env([0,1,0],[dur*0.5,dur*0.5]).circle);
		var signal = Blip.ar(freq, harmonics, 0.4) * env;
		Out.ar(out, Pan2.ar(signal));
	}).add;

    SynthDef(\sampler, {|out=0, bufnum=0|
		var signal = PlayBuf.ar(1, bufnum, loop:1);
		Out.ar(out, Pan2.ar(signal));
	}).add;
)



/////////////////////////// Delays /////////////////////////////

(
	// Simple delay. MouseY for delay time.
	SynthDef(\delay, { |in=0, out=0, mix=0.5|
		var source, delay;
		source = In.ar(in, 2);
		delay = DelayL.ar(source, 0.5, MouseY.kr(0.01, 0.5).poll);
		ReplaceOut.ar(out, (source * (1 - mix)) + (delay * mix));
	}).add;

	// Comb delay. MouseY for delay time, MouseX for decay time.
	SynthDef(\comb, { |in=0, out=0, mix=0.5|
		var source, delay;
		source = In.ar(in, 2);
		delay = CombL.ar(source, 0.5, MouseY.kr(0.01, 0.5), MouseX.kr(1,4));
		ReplaceOut.ar(out, (source * (1 - mix)) + (delay * mix));
	}).add;

	// AllpassL delay. MouseY for delay time, MouseX for decay time.
	SynthDef(\allpass, { |in=0, out=0, mix=0.5|
		var source, delay;
		source = In.ar(in, 2);
		delay = AllpassL.ar(source, 0.5, MouseY.kr(0.01, 0.5), MouseX.kr(1,4));
		ReplaceOut.ar(out, (source * (1 - mix)) + (delay * mix));
	}).add;

	// Feedback echo using local in for feedback.
	SynthDef(\echo,{|in=0, out=0, length = 0.5, fb = 0.8, sep = 0.012|
		var source, feedback, echo;
		source = In.ar(in, 2);
		feedback = LocalIn.ar(2);
		echo = LeakDC.ar(feedback*fb + source);
		LocalOut.ar(DelayC.ar(echo, 1, LFNoise2.ar(12).range([length,length+sep],[length+sep,length])));
		ReplaceOut.ar(out, echo);
	}).add;
)

~delay = Synth("delay")
~synth = Synth("pulse", [\freq, 1])


~delay = Synth("comb")
~synth = Synth("pulse", [\freq, 1])


~delay = Synth("allpass")
~synth = Synth("pulse", [\freq, 1])


~delay = Synth("echo", [\length, 0.1, \fb, 0.9 ])
~synth = Synth("pulse", [\freq, 1])

(
    SynthDef(\reverb, {|in=0, out=0|
		var signal, rev;
		signal = In.ar(in, 2);
	    rev =
	    Mix.fill(8, { rev = LPF.ar(AllpassN.ar(signal, 1.0, [0.05.rand, 0.05.rand], 2.0), 7000)});
		ReplaceOut.ar(out, (signal * 0.6) + (rev * 0.3))
	}).add;
)

Synth(\reverb)
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])




/////////////////////////// Reverb /////////////////////////////

(

	SynthDef(\bigverb, {|in=0, out=0, predelay=0.1, decay=2, mix=0.5|
		var signal, predelayed, reflections, reverb;
		signal = In.ar(in, 2);
		predelayed = DelayN.ar(signal, 0.1, predelay);

	    reverb = Mix.ar(Array.fill(7,
		{ CombL.ar(predelayed, 0.05, rrand(0.03, 0.05), decay * 10) }));
		16.do({ reverb = AllpassN.ar(reverb, 0.050, rrand(0.03, 0.05), decay) * 0.8});

	    Out.ar(out, (signal * (1 - mix)) + (reverb * mix));
	}).add;

	SynthDef(\gverb, {|in=0, out=0, roomsize=10, revtime=3, damping=0.5, inputbw=0.5, spread = 15, drylevel=0.5, earlylevel=0.7, taillevel=0.5, mix=0.5|
		var signal, reverb;
		signal = In.ar(in, 2);
		reverb = GVerb.ar(signal, roomsize, revtime, damping, inputbw, spread, drylevel, earlylevel, taillevel, roomsize);
		Out.ar(out, (signal * (1 - mix)) + (reverb * mix));
	}).add;
)

~reverb = Synth("bigverb")
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])


~reverb = Synth("gverb")
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])



// Convolution

~pulsePath = ~path ++ "impulse.wav";
~irbuffer= Buffer.read(Server.default, ~pulsePath);
~fftsize = 2048;
~bufsize= PartConv.calcBufSize(~fftsize, ~irbuffer);
~irspectrum= Buffer.alloc(Server.default, ~bufsize, 1);
~irspectrum.preparePartConv(~irbuffer, ~fftsize);

(
	SynthDef(\conv,
	{| in=0, out=0, fftsize=2048, specBufNum=8|
		var sig, verb;
		sig = In.ar(in, 2);
		verb = PartConv.ar(sig, fftsize, specBufNum);
		Out.ar(out, (sig * 0.6) +  (verb * 0.4))}).add;

)

Synth(\conv,  [\specBufNum, ~irspectrum.bufnum])
Synth("sampler", [\bufnum, ~voice.bufnum])



///////////////////////// Modulation ///////////////////////////

(
    SynthDef(\vibrato, { arg in=0, out=0, speed=2;
		var signal, wet;
		signal = In.ar(in);
		wet = DelayN.ar(signal, 0.01, SinOsc.ar(speed,0,0.0025,0.0075));
		ReplaceOut.ar(out, wet);
    }).add;

    SynthDef(\chorus, { arg in=0, out=0;
		var signal, wet, times=10;
		signal = In.ar(in);
		wet = Mix.fill(times, {
			var maxdelaytime= rrand(0.01,0.03);
			var half= maxdelaytime*0.5;
			var quarter= maxdelaytime*0.25;
			DelayC.ar(signal, maxdelaytime, LFNoise1.kr(Rand(5,10),0.01,0.02)) * 0.8;});
		ReplaceOut.ar(out, wet);
    }).add;
)

// Greate groups
(
    ~src = Group(s);
    ~fx = Group.after(~src);
)


// Add and remove from groups
~synth = Synth("buzz", [\out, 0], ~src);
~synth.set(\freq, 150)

~vibrato = Synth("vibrato", target: ~fx)
~chorus = Synth("chorus", target: ~fx)

~chorus.run(false)
~vibrato.run(false)
~chorus.run(true)

~fx.run(false)




///////////////////////// Distortion ///////////////////////////

(
	SynthDef(\reduce, { |in=0, out=0, mix=0.5, bits=7|
		var signal, distortion;
		signal = In.ar(in, 2);
		distortion = signal.round(2**(bits * -1));
		distortion = distortion.clip(-0.2,0.3).distort.pow(0.5) * 0.5;
		Out.ar(out, (signal * (1 - mix)) + (distortion * mix));
	}).add;

	SynthDef(\square, { |in=0, out=0, mix=0.5, gain=50|
		var signal, distortion;
		signal = In.ar(in, 2);
		distortion = (signal.squared + (gain*signal))/(signal.squared + ((gain-1)*signal) + 1) * 0.01;
		Out.ar(out, (signal * (1 - mix)) + (distortion * mix));
	}).add;

	SynthDef(\crunch, { |in=0, out=0, mix=0.5, samplerate=5000, bitsize=5|
		var signal, distortion, downsamp;
		signal = In.ar(in, 2);
		downsamp = Latch.ar(signal, LFTri.ar(samplerate*0.5));
		distortion = downsamp.round(0.5 ** bitsize);
		Out.ar(0, LeakDC.ar((signal * (1 - mix)) + (distortion * mix)));
	}).add;
)

~dist= Synth("crunch")
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])


~dist = Synth("square")
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])


~dist = Synth("reduce")
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])





/////////////////////// Waveshaping ////////////////////////////

~shape = Buffer.alloc(s, 1024, 1);
~shape.sine1([1, 0.5]);
~shape.plot

(
	SynthDef(\wshaper, { |in=0, out=0, mix=1.0, bufnum=0, amp=10|
		var signal, shaper;
		signal = In.ar(in, 2);
		shaper = HPF.ar(Shaper.ar(bufnum, signal), 40) * amp;
		ReplaceOut.ar(out, (signal * (1 - mix)) + (shaper * mix));
	}).add;
)

~shaper = Synth("wshaper", [\bufnum, ~shape.bufnum])
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])






////////////////////// Dynamics ////////////////////////////////

(
	SynthDef(\compressor, { |in=0, out=0, mix=1.0, threshold= 0.01|
		var signal, compressor;
		signal = In.ar(in, 2);
		compressor = Compander.ar(signal, signal, threshold, 1, 0.1, 0.01, 0.01);
		Out.ar(out, (signal * (1 - mix)) + (compressor * mix));
	}).add;

	SynthDef(\limiter, { |in=0, out=0, mix=1.0, threshold= 0.01, dur=0.01|
		var signal, limiter;
		signal = In.ar(in, 2);
		limiter = Limiter.ar (signal, threshold, dur);
		Out.ar(out, (signal * (1 - mix)) + (limiter * mix));
	}).add;

	SynthDef(\sustainer, { |in=0, out=0, mix=1.0, threshold= 0.01|
		var signal, sustainer;
		signal = In.ar(in, 2);
		sustainer = Compander.ar(signal, signal, threshold, 0.1, 1, 0.01, 0.01);
		Out.ar(out, (signal * (1 - mix)) + (sustainer * mix));
	}).add;
)

~sustainer = Synth("sustainer")
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])




////////////////////// Phase Vocoder ///////////////////////////

(
	SynthDef(\freeze, { |in=0, out=0, mix=1.0|
		var signal, chain;
		signal = In.ar(in, 2);
		chain = FFT(LocalBuf(2048), signal);
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5);
		Out.ar(out, (signal * (1 - mix)) + (IFFT(chain).dup * mix));
	}).add;

	SynthDef(\brickwall, { |in=0, out=0, mix=1.0, freq=0.05, amp=4, frames = 2048|
		var signal, chain, bw;
		signal = In.ar(in, 2);
		chain = FFT(LocalBuf(2048), signal);
		chain = PV_BrickWall(chain, freq);
		Out.ar(out, (signal * (1 - mix)) + (IFFT(chain).dup * mix));
	}).add;
)

~effect = Synth("freeze", [\in, 4])
~sampler = Synth("sampler", [\bufnum, ~trumpet.bufnum, \out, 4])

~effect = Synth("brickwall", [\in, 4])
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum, \out, 4])






//////////////////////// Resonators ////////////////////////////

(
	SynthDef(\klanky, { |in=0, out=0, mix=1.0, amp=0.5|
		var signal, klank;
		signal = In.ar(in, 2);
		klank = Klank.ar(`[Array.series(8,101,100), Array.rand(8, 0.1, 0.4).normalizeSum], signal) * amp;
		ReplaceOut.ar(out, (signal * (1 - mix)) + (klank * mix));
	}).add;

	SynthDef(\dynklanky, { |in=0, out=0, mix=0.7, amp=0.1|
		var signal, resonate, freqs;
		freqs = Control.names([\freqs]).kr([400, 800, 1200, 1800]);
		signal = In.ar(in, 2);
		resonate = DynKlank.ar(`[freqs, [0.1, 0.2, 0.1, 0.2]], signal) * amp;
		ReplaceOut.ar(out, (signal * (1 - mix)) + (resonate * mix));
	}).add;

	SynthDef(\formlet, { |in=0, out=0, mix=1.0, freq=1000, attack=0.01, decay=0.1|
		var signal, formlet;
		signal = In.ar(in, 2);
		formlet = Formlet.ar(signal, freq, attack, decay);
		ReplaceOut.ar(out, (signal * (1 - mix)) + (formlet * mix));
	}).add;
)

~effect = Synth("dynklanky")
~sampler = Synth("sampler", [\bufnum, ~voice.bufnum])
~effect.setn(\freqs, Array.rand(4, 100, 1500))





////////////////////// Buses and Groups ////////////////////////

/* use Buses and Groups */

(
	SynthDef("saw", { arg out=0, freq=100, amp=0.3;
		var sig;
		sig = Saw.ar(freq, amp);
		Out.ar(out, sig);
	}).add;

	SynthDef("noise", { arg out=0, amp=0.3;
		var sig;
		sig = Crackle.ar(1.99, mul: amp);
		Out.ar(out, sig);
	}).add;

	SynthDef("reson", { arg in=0, out=0;
		var sig;
		sig = In.ar(in);
		sig = Resonz.ar(sig, LFNoise2.kr(2.6).range(100, 1000), 0.2, 5);
		ReplaceOut.ar(out, sig);
	}).add;

	SynthDef("chop", { arg in=0, out=0;
		var sig;
		sig = In.ar(in);
		sig = LFPulse.ar(5, mul: sig);
		ReplaceOut.ar(out, sig);
	}).add;
)

~saw = Synth("saw");

// new nodes get placed before the others (by default):
~res = Synth("reson")

// but a node can be moved somewhere else:
~res.moveAfter(~saw)

// nodes can be un/muted:
~res.run(false)
~res.run(true)

~saw.free;  ~res.free;

// this node reads from bus 1 and (over)writes to bus 0:
~chop = Synth("chop", [\in, 1, \out, 0])

// this writes to bus 1:
~noise = Synth("noise", [\out, 1])

// create this node in the right position:
~res = Synth.after(~chop, "reson")

// and set its busses:
~res.set(\in, 1, \out, 1)

~res.free; ~noise.free; ~chop.free;


~src = Group(s);
~fx = Group.after(~src);

~saw = Synth("saw", [\out, 1], ~src);
~noise = Synth("noise", target: ~src);

~chop = Synth("chop", [\in, 1, \out, 1], ~fx)
~res = Synth("reson", target: ~fx)

~fx.run(false)
~fx.run(true)

~fx.moveBefore(~src)
~src.moveBefore(~fx)
