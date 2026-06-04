////////////////////////////////////////////////////////////////
//
//                    Pulsar Synthesis
//
////////////////////////////////////////////////////////////////


Particles of sound: pulsaret waveform (duty d) + silence (s).
Period p = d + s. Repetitions form a pulsar train.
Fundamental sets train rate. Formant sets pulsaret rate.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


/////////////////////// Buffers /////////////////////////////////


// Load the table waveforms from ./tables as pulsarets, plus a grain envelope.
// ~pulsarbuf and ~complexBuf point at two tables — swap the indices to taste.

(
Routine {
	var dir = thisProcess.nowExecutingPath.dirname +/+ "tables";
	~tables = (dir +/+ "*.wav").pathMatch.sort.collect {|p| Buffer.read(s, p) };
	~envbuf = Buffer.sendCollection(s, Env.perc.discretize, 1);
	s.sync;
	~pulsarbuf = ~tables[0];
	~complexBuf = ~tables[5];
	("Loaded" + ~tables.size + "tables").postln;
}.play;
)


// Basic pulsar SynthDef

(
SynthDef(\pulsar, {|fund=10, form=100, amp=0.5, wavebuf, envbuf|
	var trig = Impulse.ar(fund);
	var grdur = form.reciprocal;
	var rate = form * BufDur.kr(wavebuf);
	Out.ar(0, GrainBuf.ar(2, trig, grdur, wavebuf, rate, 0, 4, 0, envbuf, mul: amp));
}).add
)


/////////////////////// Pulsar Train ////////////////////////////


// Basic train: low fundamental, mid formant

(
Synth(\pulsar, [
	\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
	\fund, 20, \form, 100
])
)


// Pmono with evolving envelopes on fund and form

(
Pmono(\pulsar,
	\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
	\fund, Env([100, 50, 10, 5], [2, 3, 1]),
	\form, Env([100, 1000, 10, 400], [2, 3, 1]),
	\dur, 0.001,
	\amp, 0.7
).play
)


// Stochastic control: Beta fund, Brown formant

(
Pmono(\pulsar,
	\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
	\fund, Pbeta(10, 2000),
	\form, Pbrown(100, 1000, 50),
	\dur, 0.001,
	\amp, 0.5
).play
)


// Layered pulsar trains spread across fundamentals

(
var n = 10;
n.do {|i|
	Pmono(\pulsar,
		\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
		\fund, 50 + (i * 5),
		\form, Env([100, 1000, 100], [5, 5]),
		\amp, 1.0 / n,
		\dur, 0.01
	).play
}
)


// Inharmonic source with white-noise formant

(
Pmono(\pulsar,
	\wavebuf, ~complexBuf, \envbuf, ~envbuf,
	\fund, 20,
	\form, Pwhite(10, 100),
	\dur, 0.05,
	\amp, 0.8
).play
)


////////////////// Waveshaped Pulsar ////////////////////////////


// Folded pulsar through a slow sine boundary

(
SynthDef(\pulsarFold, {|fund=10, form=100, amp=0.5, wavebuf, envbuf|
	var trig = Impulse.ar(fund);
	var grdur = form.reciprocal;
	var rate = form * BufDur.kr(wavebuf);
	var sig = GrainBuf.ar(2, trig, grdur, wavebuf, rate, 0, 4, 0, envbuf, mul: amp);
	sig = sig.fold2(SinOsc.ar(fund * 0.25) * 0.5);
	Out.ar(0, HPF.ar(sig, 40));
}).add
)


// Two folded layers: slow body + fast grain dust

(
Pmono(\pulsarFold,
	\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
	\fund, Pwhite(10, 100), \form, 400,
	\dur, 0.1, \amp, 0.7
).play;

Pmono(\pulsarFold,
	\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
	\fund, Pwhite(100, 300), \form, 2000,
	\dur, 0.02, \amp, 0.1
).play;
)


//////////////// Demand-Driven Pulsar ///////////////////////////


// DemandEnvGen drives both fund and form

(
SynthDef(\pulsarDemand, {|wavebuf, envbuf, amp=0.5|
	var fund = DemandEnvGen.kr(
		Dbrown(20, 200, 10, inf),
		Dwhite(10, 100, inf) * SampleDur.ir
	);
	var form = DemandEnvGen.kr(
		Dbrown(100, 2000, 100, inf),
		Dwhite(20, 200, inf) * SampleDur.ir
	);
	var trig = Impulse.ar(fund);
	var grdur = form.reciprocal;
	var rate = form * BufDur.kr(wavebuf);
	Out.ar(0, GrainBuf.ar(2, trig, grdur, wavebuf, rate, 0, 4, 0, envbuf, mul: amp));
}).add;

Synth(\pulsarDemand, [\wavebuf, ~pulsarbuf, \envbuf, ~envbuf]);
)


//////////////////// Advanced Pulsar ////////////////////////////


// Setup: simpler buffers + extended SynthDef with FM, flux, masking

(
{
	// Use a table as the pulsaret and the perc grain envelope
	~advPul = ~tables[2];
	~advEnv = ~envbuf;

	SynthDef(\pulsarAdv, {|pulBuf, envBuf, trigFreq=50, grainFreq=1,
		fmRatio=1, fmAmt=0, fluxAmt=0, fluxRate=40,
		probability=1, burst=5, rest=0,
		pan=0, chanMask=0, centerMask=1, amp=0.3|

		var grain = trigFreq * grainFreq;
		var grainDur, trig, rate, channelMask, sig;

		grain = grain * LFDNoise3.ar(fluxRate, fluxAmt, 1).lag(0.5);
		grainDur = grain.reciprocal;

		trig = Impulse.ar(trigFreq * LFDNoise3.kr(fluxRate, fluxAmt * 0.5, 1).lag(0.5));
		trig = trig * CoinGate.ar(probability, trig);
		trig = trig * Demand.ar(trig, 1, Dseq([Dser([1], burst), Dser([0], rest)], inf));

		rate = grain * (BufFrames.kr(pulBuf) / SampleRate.ir);
		rate = rate * (1 + (SinOsc.ar(grain * fmRatio) * fmAmt * 0.1));

		channelMask = Demand.ar(trig, 0, Dseq([
			Dser([-1], chanMask),
			Dser([1], chanMask),
			Dser([0], centerMask)
		], inf)).lag(0.01);

		pan = (pan + channelMask).clip(-1, 1);

		sig = GrainBuf.ar(2, trig, grainDur, pulBuf, rate, 0, 4, pan, envBuf, 512, amp);
		Out.ar(0, LeakDC.ar(sig));
	}).add;
}.fork
)


// Plain pulsar, formant at 2x fundamental

(
~p = Synth(\pulsarAdv, [\pulBuf, ~advPul, \envBuf, ~advEnv,
	\trigFreq, 10, \grainFreq, 2.0])
)

~p.free


// FM on the formant

(
~p = Synth(\pulsarAdv, [\pulBuf, ~advPul, \envBuf, ~advEnv,
	\trigFreq, 80, \grainFreq, 2.0,
	\fmRatio, 2.0, \fmAmt, 0.5])
)

~p.free


// Flux: randomized formant and trigger rate

(
~p = Synth(\pulsarAdv, [\pulBuf, ~advPul, \envBuf, ~advEnv,
	\trigFreq, 60, \grainFreq, 2.5,
	\fluxAmt, 0.2, \fluxRate, 20])
)

~p.free


// Probability mask: drop 30% of pulses

(
~p = Synth(\pulsarAdv, [\pulBuf, ~advPul, \envBuf, ~advEnv,
	\trigFreq, 100, \grainFreq, 3.0,
	\probability, 0.7])
)

~p.free


// Burst/rest: 5 on, 3 off

(
~p = Synth(\pulsarAdv, [\pulBuf, ~advPul, \envBuf, ~advEnv,
	\trigFreq, 100, \grainFreq, 2.0,
	\burst, 5, \rest, 3])
)

~p.free


// Channel mask: L-L-R-R-C spatial cycle

(
~p = Synth(\pulsarAdv, [\pulBuf, ~advPul, \envBuf, ~advEnv,
	\trigFreq, 80, \grainFreq, 2.0,
	\chanMask, 2, \centerMask, 1])
)

~p.free


// All modulations combined

(
~p = Synth(\pulsarAdv, [\pulBuf, ~advPul, \envBuf, ~advEnv,
	\trigFreq, 120, \grainFreq, 3.0,
	\fmRatio, 1.5, \fmAmt, 0.3,
	\fluxAmt, 0.15, \fluxRate, 30,
	\probability, 0.8,
	\burst, 7, \rest, 2,
	\chanMask, 1, \centerMask, 2])
)

~p.free


// Sweep formant ratio over time

(
~p = Synth(\pulsarAdv, [\pulBuf, ~advPul, \envBuf, ~advEnv,
	\trigFreq, 50, \grainFreq, 1.0]);

Routine({
	30.do {|i|
		~p.set(\grainFreq, 1.0 + (i * 0.2));
		0.2.wait;
	}
}).play;
)

~p.free


/////////////////// Array-Driven Pulsars ///////////////////////


// Formant and fundamental frequencies drawn from frequency
// arrays, resonated by combs and Ringz tuned to the array.


(
SynthDef(\pulsarComb, {|out=0, fund=10, form=100, amp=0.5, wavebuf, envbuf,
	combFreq=440, combDecay=0.5, combMix=0.5, hpf=30|
	var trig = Impulse.ar(fund);
	var grdur = form.reciprocal;
	var rate = form * BufDur.kr(wavebuf);
	var sig = GrainBuf.ar(1, trig, grdur, wavebuf, rate, 0, 4, 0, envbuf, mul: amp);
	var delayTime = (1 / combFreq).clip(0.00005, 0.05);
	var resonated = CombL.ar(sig, 0.05, delayTime, combDecay);
	var mix = (sig * (1 - combMix)) + (resonated * combMix);
	Out.ar(out, LeakDC.ar(HPF.ar(mix, hpf)));
}).add;

SynthDef(\pulsarRingz, {|out=0, fund=10, form=100, amp=0.3, wavebuf, envbuf,
	ringFreq=440, ringDecay=0.15, ringMix=0.4,
	notchFreq=4000, notchBW=4, notchModRate=0.3, notchModDepth=800|
	var trig = Impulse.ar(fund);
	var grdur = form.reciprocal;
	var rate = form * BufDur.kr(wavebuf);
	var sig = GrainBuf.ar(1, trig, grdur, wavebuf, rate, 0, 4, 0, envbuf, mul: amp);
	var notchCenter = notchFreq + LFNoise2.ar(notchModRate, notchModDepth);
	var resonated;
	sig = BBandStop.ar(sig, notchCenter.clip(200, 12000), notchBW);
	resonated = Ringz.ar(sig, ringFreq.clip(40, 16000), ringDecay);
	Out.ar(out, LeakDC.ar((sig * (1 - ringMix)) + (resonated * ringMix)));
}).add;
)


// Set the frequency array

(
~pfreqs = [274.72, 1754.78, 1475.88, 742.66, 523.69, 439.24, 364.11];
)


// Comb pulsars with evolving formant and organic drift

(
~pfreqs.do {|f, i|
	var formDrift = 1.0, fundDrift = 1.0;
	Pmono(\pulsarComb,
		\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
		\formBase, Env([f, f * 15.2, f, f * 0.85, f], [1, 3, 1, 5], \sin),
		\fundBase, Env([6, 28, 0.2], [10, 10], \sin),
		\formDrift, Pfunc({ formDrift = (formDrift * rrand(0.985, 1.015)).clip(0.75, 1.35) }),
		\fundDrift, Pfunc({ fundDrift = (fundDrift * rrand(0.99, 1.01)).clip(0.8, 1.25) }),
		\form, Pkey(\formBase) * Pkey(\formDrift),
		\fund, Pkey(\fundBase) * Pkey(\fundDrift),
		\combFreq, f * 4, \combDecay, 0.5, \combMix, 0.2,
		\amp, 0.8 / ~pfreqs.size,
		\out, i.mod(2),
		\dur, 0.001
	).play;
};
)


// Ringz pulsars on the complex table with breathing decay

(
~pfreqs.do {|f, i|
	var decay = rrand(0.08, 0.25);
	Pmono(\pulsarRingz,
		\wavebuf, ~complexBuf, \envbuf, ~envbuf,
		\form, 50,
		\ringFreq, f * 8, \ringMix, 0.5,
		\amp, 0.3 / ~pfreqs.size,
		\out, i.mod(2),
		\fund, Pbrown(1, 10, 2),
		\ringDecay, Env([decay, decay * 1.6, decay * 0.8, decay], [12, 16, 14], \sin),
		\dur, 0.2
	).play;
};
)


// Layer the array with its retrograde, inversion and dilation

(
var centre = ~pfreqs.product.pow(~pfreqs.size.reciprocal);
var transforms = [
	~pfreqs,
	~pfreqs.reverse,
	~pfreqs.collect {|f| centre.squared / f },
	~pfreqs.collect {|f| centre * (f / centre).pow(0.7) }
];
transforms.do {|freqs, layer|
	freqs.do {|f, i|
		Synth(\pulsarComb, [
			\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
			\fund, f.linlin(freqs.minItem, freqs.maxItem, 5, 30),
			\form, f.linlin(freqs.minItem, freqs.maxItem, 60, 300),
			\combFreq, f, \combDecay, rrand(0.15, 0.5), \combMix, 0.55,
			\amp, 0.8 / (transforms.size * freqs.size),
			\out, i.mod(2)
		]);
	};
};
)


// Dynamic walk: each synth steps to the next frequency in the array

(
{
	var synths = ~pfreqs.collect {|f, i|
		Synth(\pulsarComb, [
			\wavebuf, ~pulsarbuf, \envbuf, ~envbuf,
			\fund, 15, \form, f,
			\combFreq, f * 4, \combDecay, 0.4, \combMix, 0.5,
			\amp, 0.3 / ~pfreqs.size,
			\out, i.mod(2)
		]);
	};
	Routine({
		20.do {|step|
			synths.do {|syn, i|
				var nextFreq = ~pfreqs[(i + step + 1).mod(~pfreqs.size)];
				syn.set(\form, nextFreq * 4);
				syn.set(\combFreq, nextFreq * 4);
			};
			0.2.wait;
		};
	}).play;
}.fork;
)
