////////////////////////////////////////////////////////////////
//
//                    Stochastic Texture
//
////////////////////////////////////////////////////////////////


Non-standard synthesis: a DemandEnvGen waveform whose segment
durations follow a Dbrown random walk, folded against very slow
sines. Four fold frequencies spread the texture across channels.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


//////////////////// Infinite Texture ///////////////////////////


// Dense walk between two short segment lengths, to channels 0-3

(
SynthDef(\stochasticA, {|
	demandA=9.5, demandB=15,
	envMin=0.1, envMax=0.2,
	foldFreqs = #[0.0005, 0.005, 0.00075, 0.0025]
|
	var sd = SampleDur.ir;
	var sig = DemandEnvGen.ar(
		Dseq([envMin, envMin.neg, [envMax.neg, envMax]], inf),
		sd * Dseq([demandA, demandB, Dbrown(demandA, demandB, demandB - demandA, demandA)], inf)
	).fold2(SinOsc.ar(foldFreqs));
	Out.ar(0, sig);
}).play;
)


// Sparser, wider walk, to channels 4-7

(
SynthDef(\stochasticB, {|
	demandA=5.5, demandB=25,
	envMin=0.1, envMax=0.2,
	foldFreqs = #[0.0005, 0.005, 0.00075, 0.0025]
|
	var sd = SampleDur.ir;
	var sig = DemandEnvGen.ar(
		Dseq([envMin, envMin.neg, [envMax.neg, envMax]], inf),
		sd * Dseq([demandA, demandB, Dbrown(demandA, demandB, demandB - demandA, demandA)], inf)
	).fold2(SinOsc.ar(foldFreqs));
	Out.ar(4, sig);
}).play;
)


//////////////////// With Fade-Out //////////////////////////////


// Self-terminating: amplitude fade plus a long LPF sweep down

(
SynthDef(\stochasticFadeA, {|
	demandA=9.5, demandB=15,
	envMin=0.1, envMax=0.2,
	foldFreqs = #[0.0005, 0.005, 0.00075, 0.0025],
	sustainTime=15, fadeOutTime=11,
	lpfStart=19990, lpfEnd=200
|
	var sd = SampleDur.ir;
	var sig, ampEnv, lpfEnv;
	sig = DemandEnvGen.ar(
		Dseq([envMin, envMin.neg, [envMax.neg, envMax]], inf),
		sd * Dseq([demandA, demandB, Dbrown(demandA, demandB, demandB - demandA, demandA)], inf)
	).fold2(SinOsc.ar(foldFreqs));
	ampEnv = EnvGen.kr(Env([1, 1, 0], [sustainTime, fadeOutTime], \sin), doneAction: 2);
	lpfEnv = EnvGen.kr(Env([lpfStart, lpfStart, lpfEnd], [sustainTime, fadeOutTime], \exp));
	sig = sig * LFTri.ar(Array.series(4, 15, 5)).range(0.5, 1.2);
	sig = LPF.ar(sig, lpfEnv);
	Out.ar(0, sig * ampEnv * 0.7);
}).play;
)


// Fade variant with the sparser, wider walk, to channels 4-7

(
SynthDef(\stochasticFadeB, {|
	demandA=5.5, demandB=25,
	envMin=0.1, envMax=0.2,
	foldFreqs = #[0.0005, 0.005, 0.00075, 0.0025],
	sustainTime=15, fadeOutTime=11,
	lpfStart=19000, lpfEnd=200
|
	var sd = SampleDur.ir;
	var sig, ampEnv, lpfEnv;
	sig = DemandEnvGen.ar(
		Dseq([envMin, envMin.neg, [envMax.neg, envMax]], inf),
		sd * Dseq([demandA, demandB, Dbrown(demandA, demandB, demandB - demandA, demandA)], inf)
	).fold2(SinOsc.ar(foldFreqs));
	ampEnv = EnvGen.kr(Env([1, 1, 0], [sustainTime, fadeOutTime], \sin), doneAction: 2);
	lpfEnv = EnvGen.kr(Env([lpfStart, lpfStart, lpfEnd], [sustainTime, fadeOutTime], \exp));
	sig = sig * LFTri.ar(Array.series(4, 15, 5)).range(0.5, 1.2);
	sig = LPF.ar(sig, lpfEnv);
	Out.ar(4, sig * ampEnv * 0.7);
}).play;
)
