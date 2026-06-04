////////////////////////////////////////////////////////////////
//
//                      Feedback
//
////////////////////////////////////////////////////////////////


A demand-rate non-standard synthesis source routed into a
4-channel frequency-shifting feedback loop, recombined through
a comb filter.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


// Synthesis model: demand waveform shaped by atan distortion

(
Ndef(\stdn, {
	var sd = SampleDur.ir * 0.5;
	DemandEnvGen.ar(
		Dseq([1, [-1, 0.5]], inf),
		Dseq(Array.rand(5, 1, 25), inf) * sd
	).atan(SinOsc.ar(LFNoise0.ar(10).range(5, 7))) * 0.5;
});
)


// Feedback processor: freq-shift, mutual influence, comb recombine

(
Ndef(\fb, {|out=0, feedback=0.98|
	var sig, input, first, second;

	sig = Ndef(\stdn).ar;
	input = sig + LocalIn.ar(4);

	first = input.clump(2)[0];
	first = FreqShift.ar(first, LFNoise1.ar(0.7).range(10, 30));

	second = input.clump(2)[1];
	second = MostChange.ar(first, FreqShift.ar(first, LFNoise1.ar(20).range(10, 40)));

	first = DelayC.ar(first, 1, LFNoise1.ar(0.1).range(0.04, 0.09));
	second = DelayC.ar(second, 1, LFNoise1.ar(0.1).range(0.08, 0.11));

	LocalOut.ar((first ++ second) * feedback);
	Out.ar(out, CombC.ar(Splay.ar(first ++ second), 0.1, 0.1, 0.2));
}).play;
)



//////////////////// OnePole Feedback ///////////////////////////


// Lorenz source through signal-dependent one-pole filters + delay

(
SynthDef(\fb, {|feedback=1.0001, delay=0.000945|
	var sig, input, first, second;

	sig = LorenzL.ar(9000);
	input = sig + LocalIn.ar(4);
	first = input.clump(2)[0];
	second = input.clump(2)[1];

	first = OnePole.ar(first, first.linlin(-1.0, 1.0, 0.0, 1.0));
	second = OnePole.ar(second, second.linlin(-1.0, 1.0, 1.0, 0.0));
	first = OnePole.ar(first, 0.9);
	second = OnePole.ar(second, 0.9);

	first = DelayC.ar(first, 1, LFNoise2.ar(0.13).range(delay, delay * 1.1));
	second = DelayC.ar(second, 1, LFNoise2.ar(0.17).range(delay * 1.2, delay * 1.3));

	LocalOut.ar((first ++ second) * feedback * rrand(0.99, 0.99999));
	Out.ar(0, Limiter.ar(Splay.ar(first ++ second)));
}).play;
)


//////////////////// Folded Feedback ////////////////////////////


// 8-channel saw folded against random sines, delayed, varied

(
Ndef(\fb).fadeTime = 2;
Ndef(\fb, {|feedback=1.0001, delay=0.01|
	var sig, input, snd;

	sig = Saw.ar(10);
	input = sig + LocalIn.ar(8);

	snd = input.fold2(SinOsc.ar({ 1000.rand } ! 8));
	snd = DelayC.ar(snd, 1, LFNoise2.ar({ 20.rand } ! 8).range(delay, delay * 1.1));

	LocalOut.ar(snd * feedback * rrand(0.99, 0.99999));
	Limiter.ar(Splay.ar(snd) * 0.1);
}).play;

{
	inf.do {
		" ** vary".postln;
		Ndef(\fb).set(\feedback, rrand(1.001, 1.01));
		rrand(3, 6).wait;
		Ndef(\fb).set(\feedback, rrand(0.6, 0.8));
		rrand(1, 3).wait;
	};
}.fork;
)


//////////////////// Bandpass Feedback //////////////////////////


// Soft-clipped bandpass network with crossfaded feedback amounts

(
Ndef(\fb).fadeTime = 0.8;
Ndef(\fb, {|feedback=1.0001, delay=0.02|
	var sig, input, snd;

	sig = Saw.ar(80);
	input = sig + LocalIn.ar(8);

	snd = SoftClipAmp8.ar(BBandPass.ar(input, { 2000.rand } ! 8), sig.linlin(-1.0, 1.0, 14.rand, 18.rand));
	snd = DelayC.ar(snd, 1, LFNoise2.ar({ 20.rand } ! 8).range(delay, delay * 1.1));

	LocalOut.ar(snd * feedback * rrand(0.9999, 0.999999));
	Limiter.ar(Splay.ar(snd) * 0.1);
}).play;

{
	inf.do {
		Ndef(\fb).xset(\feedback, rrand(1.001, 1.01));
		rrand(3, 6).wait;
		Ndef(\fb).xset(\feedback, rrand(0.6, 0.8));
		rrand(1, 3).wait;
	};
}.fork;
)


//////////////// FreqShift Feedback Processor ///////////////////


// A demand-synthesis source feeding a frequency-shifting loop

(
Ndef(\stdn, {
	var sd = SampleDur.ir * 0.5;
	DemandEnvGen.ar(
		Dseq([1, [-1, 0.5]], inf),
		Dseq(Array.rand(5, 1, 25), inf) * sd
	).atan(SinOsc.ar(LFNoise0.ar(10).range(5, 7))) * 0.5;
});

Ndef(\fbx, {|out=0, feedback=0.98|
	var sig, input, first, second;

	sig = Ndef(\stdn).ar;
	input = sig + LocalIn.ar(4);

	first = input.clump(2)[0];
	first = FreqShift.ar(first, LFNoise1.ar(0.7).range(10, 30));

	second = input.clump(2)[1];
	second = MostChange.ar(first, FreqShift.ar(first, LFNoise1.ar(20).range(10, 40)));

	first = DelayC.ar(first, 1, LFNoise1.ar(0.1).range(0.004, 0.009));
	second = DelayC.ar(second, 1, LFNoise1.ar(0.1).range(0.008, 0.011));

	LocalOut.ar((first ++ second) * feedback);
	Out.ar(out, CombC.ar(Splay.ar(first ++ second) * 0.2, 0.1, 0.1, 0.2));
}).play;
)

