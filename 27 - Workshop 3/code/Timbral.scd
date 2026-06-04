////////////////////////////////////////////////////////////////
//
//                       Timbral Spectra
//
////////////////////////////////////////////////////////////////


Timbral richnesses and spectra to use as the basis for synthesis.
Each is a live-editable Ndef — redefine and .set while it plays.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


// Folded blips

(
Ndef(\bloded, {|freq=100, modFreq=6, harms=150|
	var son = Splay.ar(HPF.ar(Blip.ar(Array.series(4, freq, 5), harms).fold2(SinOsc.ar(Array.series(4, modFreq, modFreq / 2))), 30)) * 0.5;
	LPF.ar(son, 2000)
}).play;
)


// FM with logistic/Gbman chaos as modulator

(
Ndef(\goschc, {|freq=60, index=10, modMult=15, eqFreq=3000, cutt=(-12)|
	var mod = Lag.ar(GbmanL.ar(LFNoise1.kr(0.1, 0.5, 3.5), LFNoise1.kr(0.2, 500, 1000), 0.25, 0.5).range(freq, freq * modMult), 0.1);
	BPeakEQ.ar(PMOsc.ar([LFNoise2.kr(0.05, freq / 5, freq), LFNoise2.kr(0.01, freq / 10, freq / 2)], mod, index, 0, 0.2), eqFreq, 2, cutt, 0.5);
}).play;
)


// Blip + band reject

(
Ndef(\craks, {|freq=290, harms=170, modFreq=1|
	var mod = SinOsc.ar(LFNoise2.kr(1).range(modFreq * 5, 0.5), 0, LFNoise2.kr(modFreq / 10).range(5, 20));
	var sig = Splay.ar(Blip.ar(Array.series(5, freq, freq / 24) + mod, harms));
	BPeakEQ.ar(BBandStop.ar(sig, harms * 10, 2.5), LFNoise1.kr(modFreq, 3500, 4000), 1, -24) * 0.5;
}).play;
)


// Noise + sine grains

(
Ndef(\golum, {|rate=20, grAtk=0.88, grRel=0.2|
	var trigger = (Impulse.ar(rate) * 0.8) + (Dust.ar(rate) * 0.2);
	var env = EnvGen.ar(Env.perc(grAtk, grRel, 1, 4), trigger, 1, 0, (1 / rate));
	HPF.ar(SinOsc.ar([rate / 3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul: env), rate * 8, 0.2), 40);
}).play;
)


// Strange chaos resonance

(
Ndef(\plick, {|rate=10, delay=0.00007, filtFreq=1000|
	var snd = Crackle.ar(Array.series(10, 0.6, 0.1));
	var pluck = Pluck.ar(snd, Impulse.ar(Array.series(10, rate, 10)), 0.1, Array.series(10, delay, 0.000002));
	BBandStop.ar(HPF.ar(Splay.ar(pluck, 0.1), 100), LFNoise1.kr(rate, filtFreq * 0.4, filtFreq))
}).play;
)


// VarSaw fatness

(
Ndef(\varsaw, {|freq=100|
	var sig = VarSaw.ar(LFPar.ar([freq / 10, freq / 20], 0, 10, LFPar.kr(5, 0, 5, freq)), 0, LFNoise2.kr(freq / 3, 0.5, 1.5)) * 0.15;
	BBandStop.ar(sig, LFNoise1.kr(freq / 10, 300, 700), 4)
}).play;
)


// SyncSaw fatness

(
Ndef(\syncsaw, {|freq=1300|
	var saw = SyncSaw.ar(Saw.ar([freq / 10, freq / 12], freq / 4, freq), freq * 1.3);
	var band = BBandStop.ar(saw, LFNoise2.kr(freq / 1000, freq, freq * 3), 12);
	Splay.ar(CombN.ar(band, 0.1, LFNoise2.ar(0.001, 0.05, 0.15), 2) * 0.1);
}).play;
)


// Pulsonorities

(
Ndef(\cosite, {|freq=101|
	var pulse = Pulse.ar(LFPulse.ar(120, 0, 0.55, freq / 8, freq), Saw.ar(freq / 3));
	var bass = MoogFF.ar(pulse, LFNoise1.ar(10, 10, freq), 3) ! 2 * 0.3;
	var highs = RHPF.ar(pulse, LFNoise0.ar(1, 20, freq * 60), 3) ! 2 * 0.3;
	bass + highs
}).play;
)


// High impulses (folded feedback sine)

(
Ndef(\himmer, {|freq=2000, modFreq=6, harms=0.0|
	SinOscFB.ar(freq, harms).fold2(SinOsc.ar(modFreq)) ! 2 * 0.03
}).play;
)


// Soft sine bass feedback

(
Ndef(\softbass, {
	DFM1.ar(SinOsc.ar([65, 66.125], 0, 0.1), 1600, SinOsc.kr(0.1).range(0.92, 1.0135), 1, 0, 0.001, 0.7)
}).play;
)


// Dust & crackle, slowly breathing

(
Ndef(\gas, {
	var sig = Dust.ar(120) + Crackle.ar(0.9);
	var timeUp = 6, timeDown = 8;
	var holder = EnvGen.ar(Env([0, 1, 0], [timeUp, timeDown]).circle);
	var sinFrom = EnvGen.ar(Env([0, 1, 0], [timeUp * 2, timeDown / 2]).circle);
	var mod = LFNoise2.ar([4, 8]).range(sinFrom, 1.0);
	sig = sig * Line.kr(0, 1, timeUp);
	sig * (mod * holder) ! 2
}).play;
)


// Saw multiplied with percussive envelopes

(
Ndef(\dust, {|freq=1000|
	RLPF.ar(Saw.ar(LFNoise2.ar([0.1, 0.15]).range(freq, freq * 1.01)), 600) * EnvGen.ar(Env.perc(0.01, 0.01), Impulse.ar(20));
}).play;
)


// Sine and crackle, crossfading LFO depth

(
Ndef(\lfis, {
	var amount = 0.75, duration = 5;
	var lfo = SinOsc.ar(XLine.kr(8, 0.1, duration), 0, 0.1, 0.5);
	var crackle = Crackle.ar(XLine.kr(1, 0.7, duration)) * 0.9;
	var blip = Blip.ar(10, XLine.ar(12, 10, duration), 0.75);
	var signal = crackle + blip;
	(signal * (lfo * amount)) + (signal * (1 - amount))
}).play;
)


// DemandEnv waveform with live shape/rate controls

(
Ndef(\oDemWave, {|dur=1.1, shape=1, curve=0, amp=0.1, times=5, rate=10|
	var sd = SampleDur.ir * dur;
	var seq = Dseq([-1, 0.1, Dwhite(-0.1, 0.1, times), Dwhite(-0.2, 0.2, times)], inf);
	DemandEnvGen.ar(seq, sd, shape, curve, 1, Impulse.ar([rate, rate * 4])) * amp
}).play;
)


// LFbrownnoise from demand segments

(
Ndef(\lfb, {|dur=0.2, a=10, b=80, c=128, amp=0.5|
	var sd = SampleDur.ir * dur;
	DemandEnvGen.ar(Dseq([-0.1, 0.1], inf), Dseq([sd * a, sd * b, sd * Dwhite(60, 90, c)], inf)) ! 2 * amp;
}).play;
)


// Sparkling: gravity grid least-changed against PM

(
Ndef(\sparkling, {
	var mod = PMOsc.ar(20, LFDClipNoise.ar().range(50, 100), 1);
	0.1 * LPF.ar(LeastChange.ar(GravityGrid.ar(0, [12, 30]), mod), 2000)
}).play;
)


// Noise: logistic-modulated PM cluster

(
Ndef(\logic, {|freq=70, index=5, modMult=25|
	var mod = Lag.ar(Logistic.ar(LFNoise1.kr(0.001, 0.5, 3.5), LFNoise1.kr(0.2, 500, 1000), 0.25, 0.5).range(freq, freq * modMult));
	var signal = PMOsc.ar(Array.rand(8, freq / 4, freq), mod, rrand(index, index * 2) ! 8, 0, 0.02);
	signal * EnvGen.ar(Env([0, 1, 0, 1, 0], [8, 8, 15, 6]).circle)
}).play;
)
