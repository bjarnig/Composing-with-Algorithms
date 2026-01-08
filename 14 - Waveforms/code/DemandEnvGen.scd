////////////////////////////////////////////////////////////////
//
//                      DemandEnvGen
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)



///////////////////////// DemandEnvGen //////////////////////////


( // DemandEnv for waveform (saw)

{

DemandEnvGen.ar(
		Dseq([Dseries(-0.5, 0.1, 15)], inf),
        SampleDur.ir * 50
) ! 2 * 0.5

}.play

)


( // Triangle wave from ascending + descending series

{
	var levels = Dseq([
		Dseries(-1, 0.04, 50),   // rise: -1 to 1
		Dseries(1, -0.04, 50)    // fall: 1 to -1
	], inf);
	var durations = SampleDur.ir * 5;

	DemandEnvGen.ar(levels, durations) ! 2 * 0.6;
}.play

)


( // Multi-layered sawtooth waves at different frequencies

{
	var numLayers = 10;
	var signals = numLayers.collect { |i|
		var steps = 50 + (i * 20);  // different frequencies per layer
		var stepSize = 2.0 / steps;
		var levels = Dseq([Dseries(-1, stepSize, steps)], inf);
		var durations = SampleDur.ir;

		DemandEnvGen.ar(levels, durations) / numLayers;
	};

	Splay.ar(signals);
}.play

)


( // Complex: saw + triangle + square + exponential

{
	var levels = Dseq([
		Dseries(-1, 0.04, 50),             // sawtooth up
		Dseries(-1, 0.04, 50),             // triangle up
		Dseries(1, -0.04, 50),             // triangle down
		Dstutter(25, Dseq([1, -1], 6)),    // square wave
		Dgeom(0.01, 1.08, 50)              // exponential ramp
	], inf);

	var durations = SampleDur.ir * 15;
	var sig = DemandEnvGen.ar(levels, durations);
	sig = sig.clip(-1, 1);

	sig ! 2 * 0.3;
}.play

)



( // Basic Gendy: random walks for breakpoints (Sergio Luque model)

{
	var points = 10;
	var durFrom = 5, durTo = 15, durStep = 0.1;
	var ampFrom = -0.5, ampTo = 0.5, ampStep = 0.01;

	var amps = { Dbrown(ampFrom, ampTo, ampStep, inf) } ! points;
	var durations = { Dbrown(durFrom, durTo, durStep, inf) } ! points;
	var series = Array.series(points, 0, 1);

	DemandEnvGen.ar(
		Dswitch1(amps, Dseq(series, inf)),
		Dswitch1(durations, Dseq(series, inf)) * SampleDur.ir
	) ! 2 * 0.3;
}.play

)



( // Shuffled Gendy: random without immediate repeats

{
	var points = 40;
	var durFrom = 1, durTo = 20, durStep = 0.8;
	var ampFrom = -0.6, ampTo = 0.6, ampStep = 0.015;

	var amps = { Dbrown(ampFrom, ampTo, ampStep, inf) } ! points;
	var durations = { Dbrown(durFrom, durTo, durStep, inf) } ! points;
	var series = Array.series(points, 0, 1);

	DemandEnvGen.ar(
		Dswitch1(amps, Dshuf(series, inf)),
		Dswitch1(durations, Dshuf(series, inf)) * SampleDur.ir * 2
	) ! 2 * 0.3;
}.play

)



( // Multi-voice Gendy: layered breakpoint clouds

{
	var numVoices = 5;

	Splay.ar(Array.fill(numVoices, { |i|
		var points = 6 + (i * 3);  // increasing complexity per voice
		var durFrom = 5 + (i * 2), durTo = 15 + (i * 3);
		var ampRange = 5.0 / (i + 1);  // decreasing amplitude per voice

		var amps = { Dbrown(ampRange.neg, ampRange, 0.03, inf) } ! points;
		var durations = { Dbrown(durFrom, durTo, 0.1, inf) } ! points;
		var series = Array.series(points, 0, 1);

		DemandEnvGen.ar(
			Dswitch1(amps, Dseq(series, inf)),
			Dswitch1(durations, Dseq(series, inf)) * SampleDur.ir
		) / numVoices;
	}));

}.play

)



( // Rapid Gendy: large steps for aggressive evolution

{
	var points = 15;
	var durFrom = 3, durTo = 12, durStep = 1.0;   // large duration jumps
	var ampFrom = -0.8, ampTo = 0.8, ampStep = [0.1,0.01];

	var amps = { Dbrown(ampFrom, ampTo, ampStep, inf) } ! points;
	var durations = { Dbrown(durFrom, durTo, durStep, inf) } ! points;
	var series = Array.series(points, 0, 1);

	DemandEnvGen.ar(
		Dswitch1(amps, Dseq(series, inf)),
		Dswitch1(durations, Drand(series, inf)) * SampleDur.ir
	) * 0.5;
}.play

)



( // Impulse-triggered demand envelope with sine folding

{
	var rate = 28, trig = 0.5, a = 8, b = 3, min = 0.1, max = 0.2, amp = 1.0;
	var trigger, seq, freq, soundx, sd = SampleDur.ir;

	trigger = Impulse.kr(trig);
	seq = Dseq([
		Dbrown(rate * 0.1, rate, rate * 0.1, rate * 1.6),
		Dwhite(rate * 0.1, rate, 8)
	], inf);
	freq = Demand.kr(trigger, 0, seq);

	HPF.ar(DemandEnvGen.ar(
		Dseq([min, min.neg, [max.neg, max]], inf),
		Dseq([sd * a, sd * b], inf)
	).fold2(SinOsc.ar([freq, freq * 0.5])), 20, 0.25);

}.play

)



( // Demand envelope folding with brownian timing

{
	var sdm = 1, mod = 0.005, from = 9, to = 12;
	var min = 0.1, max = 0.3, amp = 0.8, hpf = 40, mf = 1.0;
	var sd = SampleDur.ir * sdm;

	HPF.ar(
		DemandEnvGen.ar(
			Dseq([min, min.neg, [max.neg, max]], inf),
			sd * Dseq([from, to, Dbrown(from, to, to, from.neg, from)], inf)
		).fold2(SinOsc.ar(mod)) * mf * amp,
	hpf);
}.play

)



( // Complex multi-stage demand sequencing

{
	var sdm = 1, repeats = 32, from = 8, to = 30;
	var min = 0.1, max = 0.9, amp = 0.8, mf = 0.2;
	var sd = SampleDur.ir * sdm;

	DemandEnvGen.ar(
		Dseq([
			Dseq([0, 0.5], repeats),
			Dseq([-0.2, 0.8], repeats/2),
			Dseq([-1.0, 1.0], Dwhite(repeats/32, repeats)),
			Dseq([-0.8, 0.1], repeats/16)
		], inf),
		Dseq([
			Dwhite(from, to, [repeats, repeats * 0.5]),
			Dwhite(from/1.5, to/1.5, [repeats, repeats * 2]),
			Dbrown(from/10, to/10, from/20, [repeats, repeats * 0.25])
		], inf) * sd
	) * mf * amp;
}.play

)



( // Long series texture with brownian timing

{
	var ser = 500, step = 2.5, amp = 0.8, sdm = 0.5, mf = 0.008;
	var sd = SampleDur.ir * sdm;

	Limiter.ar(DemandEnvGen.ar(
		Dseq([Dseries(-0.5, [0.1, -0.1], ser)], inf),
		sd * Dbrown(1, 7, 2.5)
	) * mf) * amp ! 2;
}.play

)

