////////////////////////////////////////////////////////////////
//
//                       Microsound
//
////////////////////////////////////////////////////////////////


Granular and particle techniques: synthetic grains, GrainFM,
wavefolding, buffer granulation, and demand-rate waveforms.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


//////////////////// Synthetic Grains ///////////////////////////


// A single-grain SynthDef scheduled by a Routine

(
SynthDef(\sg, {|freq=400, amp=0.3, dur=0.3, pan=0|
	var env, sig;
	env = EnvGen.ar(Env([0, amp, 0], [dur * 0.5, dur * 0.5], [8, -8]), doneAction: 2);
	sig = SinOsc.ar(freq, 0, env);
	OffsetOut.ar(0, Pan2.ar(sig, pan));
}).add;

Routine {
	var next, fr, dur;
	var env = Env([1000, 18000, 1000], [500, 500]);
	inf.do {|i|
		dur = 0.02;
		next = dur * rrand(0.1, 0.4);
		fr = rrand(100.0, env[i % 1001]);
		Synth(\sg, [\dur, dur, \freq, fr, \pan, rrand(-1.0, 1.0), \amp, 0.2]);
		next.wait;
	};
}.play;
)


// GrainFM triggered by Dust, layered and wavefolded

(
{
	var density = 100, dur = 0.01, freqFrom = 100, freqTo = 4000;
	var trig = Dust.kr(density);
	Mix.fill(5, {
		var freq = rrand(freqFrom, freqTo);
		var modfreq = rrand(freqFrom, freqTo);
		GrainFM.ar(2, trig, dur, freq, modfreq, Line.ar(0.1, 0.9, 5)).fold2(SinOsc.ar(10)) * 0.05;
	})
}.play
)


// Gaussian sine grains swept through a frequency envelope

(
SynthDef(\sawgauss, {|amp=0.5, freq=440, sustain=0.075|
	var sig = SinOsc.ar(freq, 0, sustain);
	var env = EnvGen.ar(Env.sine(sustain, amp), doneAction: 2);
	OffsetOut.ar(0, sig * env ! 2);
}).add;

f = {|times=100, from=10, amp=0.3, dur=0.002, freqs|
	Task {
		e = Env(freqs, (1.0 / freqs.size) ! (freqs.size - 1));
		times.do {|i|
			var index = i.linlin(0, times - 1, 0.0, 1.0);
			Synth(\sawgauss, [\freq, rrand(from, e[index]), \amp, amp]);
			dur.wait;
		};
	}.play
};

Task {
	inf.do {
		f.(dur: 0.002, freqs: Array.rand(1500, 10, 3000), times: rrand(100, 400), amp: 0.1);
		2.wait;
	};
}.play;
)


//////////////////////// Wavefolding ///////////////////////////


// Compare fold2 thresholds on a sine

(
{ SinOsc.ar().fold2(0.1) }.plot;
{ SinOsc.ar().fold2(0.9) }.plot;
{ SinOsc.ar().fold2(Line.kr(0.0, 0.5, 0.1)) }.plot;
)


// Fold a feedback sine between moving boundaries

(
Ndef(\fold, {
	Fold.ar(
		SinOscFB.ar([40, 42], LFNoise1.ar(3).range(0.1, 1.75)),
		LFNoise2.ar(4.3).range(0.1, 0.5),
		SinOsc.ar([0.03, 0.1]).range(0.5, 2.0)
	) * 0.3
}).play;
)


// fold2 a Blip against a noise-modulated sine

{ Blip.ar([200, 100], 150).fold2(SinOsc.ar(LFDNoise1.ar(15).range(10, 40))) * 0.3 }.play


// fold2 vs wrap2

(
{ SinOsc.ar().fold2(0.9) }.plot;
{ SinOsc.ar().wrap2(0.9) }.plot;
)


//////////////////// Buffer Granulation /////////////////////////


// Write a live source into a buffer, granulate it with delay taps

(
{
	SynthDef(\source, {|in=0, out=0| Out.ar(out, Gendy3.ar * 0.1) }).add;

	SynthDef(\writer, {|in=0, out=0, buf=0|
		var pos = Phasor.ar(0, 1, 0, BufFrames.kr(buf));
		BufWr.ar(In.ar(in, 1), buf, pos);
		Out.ar(out, pos);
	}).add;

	SynthDef(\reader, {|buf, in, rate=1, dur=0.4, delay=0.1|
		var pos = In.ar(in) / BufFrames.kr(buf);
		var sig;
		pos = (pos - delay).wrap(0, 1) * LFNoise1.ar(10).range(0.9, 1.1);
		rate = LFDNoise3.ar(10).range(rate * 0.5, rate * 2);
		sig = GrainBuf.ar(1, Impulse.ar(40), dur ! 2, buf, rate, pos) * 0.5;
		Out.ar(0, sig);
	}).add;

	s.sync;

	b = Buffer.alloc(s, s.sampleRate * 10);
	~sourceBus = Bus.audio(s);
	~writerBus = Bus.audio(s);

	s.sync;

	8.do {|i|
		Synth(\reader, [\buf, b, \in, ~writerBus, \rate, rrand(0.01, 4.0), \dur, (i + 1) * 0.01]);
	};

	Synth(\writer, [\buf, b, \in, ~sourceBus, \out, ~writerBus]);
	Synth(\source, [\in, 0, \out, ~sourceBus]);
}.fork;
)


//////////////////// Demand-Rate Waveforms //////////////////////


// Demand sequences a server-side waveform — plot one cycle

(
{
	var trig = Impulse.ar(60 ! 2);
	var shape = Dseq([Dseries(-1.0, 0.1, 20), Dseries(1.0, -0.1, 20)], inf);
	Demand.ar(trig, 0, shape) * 0.5;
}.plot(1)
)


// DemandEnvGen interpolates between break points

(
{
	DemandEnvGen.ar(
		Dseq([Dseries(-1.0, 0.1, 20), Dseries(1.0, -0.1, 20)], inf),
		SampleDur.ir
	) ! 2 * 0.5;
}.play
)


// Sample duration changes continuously per segment

(
{
	DemandEnvGen.ar(
		Dseq([Dseries(-1.0, 0.1, 40 ! 2)], inf),
		Dseq([Dwhite(1, 10, 4), Dwhite(0.1, 100, 4)], inf) * SampleDur.ir
	) * 0.3;
}.play
)


// Noisy texture wrapped against a sine

(
{
	var min = 0.1, max = 0.3, mod = 0.01, sd = SampleDur.ir;
	DemandEnvGen.ar(
		Dseq([min, min.neg, [max.neg, max ! 2]], inf),
		Dwhite(sd, sd * 100)
	).wrap2(SinOsc.ar(mod));
}.play
)


// Non-standard synthesis: demand waveform shaped by atan + PM layer

(
{|sdm=0.15, modFreq=10, modFrom=5, modTo=25, fmfreq=100, fmhi=4000, amp=1.0, mf=0.25|
	var sd = SampleDur.ir * sdm;
	var seq = Dseq(Array.rand(5, 20, 25), inf);
	var snd = DemandEnvGen.ar(Dseq([1, [-1, 1.0]], inf), seq * sd)
		.atan(SinOsc.ar(LFNoise0.ar(modFreq).range(modFrom, modTo))) * 0.5;
	var freq = Demand.kr(Impulse.kr(10), 0, seq);
	snd = snd + (PMOsc.ar(LFCub.kr([freq, freq / 2], 0, fmfreq * 0.2, fmfreq), fmhi, 0.5) * mf);
	snd = snd + DemandEnvGen.ar(Dwhite(-0.9, 0.9, 1), seq * sd * 10 * 0.1);
	Out.ar(0, HPF.ar(snd, 40, amp));
}.play;
)
