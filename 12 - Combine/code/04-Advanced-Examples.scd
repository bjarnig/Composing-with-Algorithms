////////////////////////////////////////////////////////////////
//
//                  Advanced Combinations
//
////////////////////////////////////////////////////////////////

// Complex examples combining multiple techniques


////////////////////////// SynthDefs ///////////////////////////

(
SynthDef(\fm, {|out=0, freq=400, cmRatio=1.5, index=3, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, modFreq, env;
	modFreq = freq * cmRatio.reciprocal;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = PMOsc.ar(freq, modFreq, index) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

SynthDef(\sine, {|out=0, freq=440, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, env;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = SinOsc.ar(freq) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

SynthDef(\buzz, {|out=0, freq=200, harmonics=10, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, env;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = Blip.ar(freq, harmonics) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

SynthDef(\saw, {|out=0, freq=440, cutoff=1200, rq=0.3, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, env, filt;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = Saw.ar(freq) * env;
	filt = RLPF.ar(signal, cutoff, rq) * amp;
	Out.ar(out, Pan2.ar(filt, pan));
}).add;
)


////////////////////////// Effects /////////////////////////////

(
SynthDef(\reverb, {|in=0, out=0, mix=0.5, decay=2|
	var signal, rev;
	signal = In.ar(in, 2);
	rev = Mix(signal);
	8.do({ rev = LPF.ar(AllpassN.ar(rev, 1.0, [0.05.rand, 0.05.rand], decay), 7000)});
	ReplaceOut.ar(out, (signal * (1-mix)) + (rev * mix));
}).add;

SynthDef(\echo, {|in=0, out=0, length=0.3, fb=0.7|
	var signal, feedback, echo;
	signal = In.ar(in, 2);
	feedback = LocalIn.ar(2);
	echo = LeakDC.ar(feedback * fb + signal);
	LocalOut.ar(DelayC.ar(echo, 1, length));
	ReplaceOut.ar(out, echo);
}).add;
)


/////////////// Example 1: Multi-Layer Probability Cloud ////////

(
~fxBus = Bus.audio(s, 2);
~fxGroup = Group.after(s.defaultGroup);
~reverb = Synth(\reverb, [\in, ~fxBus, \out, 0, \mix, 0.4, \decay, 3], ~fxGroup);

Ppar([
	// Low drone layer
	Pbind(
		\instrument, \buzz,
		\out, ~fxBus,
		\midinote, Pstutter(32, Pseq([36, 38, 40, 43], inf)),
		\harmonics, Pbrown(8, 20, 2, inf),
		\rel, 0.8,
		\amp, 0.1,
		\pan, 0,
		\dur, 0.25
	),
	// Middle stochastic layer
	Pbind(
		\instrument, \fm,
		\out, ~fxBus,
		\midinote, Pgauss(60, 12, inf).round(1),
		\cmRatio, Pwrand([1.5, 2, 3], [0.5, 0.3, 0.2], inf),
		\index, Pexprand(4, 12),
		\rel, Pexprand(0.15, 0.04),
		\amp, 0.12,
		\pan, Pgauss(0, 0.5).clip(-1, 1),
		\dur, Ppoisson(0.15, inf).clip(0.05, 0.5)
	),
	// High sparse layer
	Pbind(
		\instrument, \sine,
		\out, ~fxBus,
		\midinote, Pexprand(72, 96, inf).round(1),
		\rel, 0.1,
		\amp, 0.08,
		\pan, Pwhite(-0.8, 0.8),
		\dur, Pexprand(0.3, 1.5)
	)
]).play;
)

~reverb.free; ~fxBus.free;


/////////////// Example 2: Tendency Mask with Layers ////////////

(
Ppar([
	Pbind(
		\instrument, \saw,
		\midinote, Pseg(Pseq([36, 48, 40], inf), Pseq([6, 4], inf)),
		\cutoff, Pseg(Pseq([500, 3000, 1000], inf), Pseq([5, 3], inf), \exp),
		\rq, 0.2,
		\rel, 0.4,
		\amp, 0.15,
		\pan, 0,
		\dur, 0.25
	),
	Pbind(
		\instrument, \fm,
		\midinote, Pseg(Pseq([60, 72, 84, 72], inf), Pseq([4, 2, 3], inf)) + Pwhite(-3, 3),
		\cmRatio, Pseg(Pseq([1.5, 3, 2], inf), Pseq([5, 3], inf)),
		\index, Pseg(Pseq([3, 12, 6], inf), 4),
		\rel, 0.2,
		\amp, 0.12,
		\pan, Pwhite(-0.6, 0.6),
		\dur, 0.1
	)
]).play;
)


/////////////// Example 3: Chaotic Density Cloud ////////////////

(
Pbind(
	\instrument, \fm,
	\midinote, Pcauchy(60, Pseg(Pseq([4, 18, 8], inf), Pseq([5, 3], inf)), inf)
		.max(36).min(96).round(1),
	\cmRatio, Pexprand(1.0, 5.0),
	\index, Pexprand(2, 15),
	\rel, Pexprand(0.05, Pseg(Pseq([0.2, 0.6, 0.3], inf), Pseq([4, 3], inf))),
	\amp, Pexprand(0.05, 0.18),
	\pan, Pbrown(-1, 1, 0.2, inf),
	\dur, Ppoisson(Pseg(Pseq([0.08, 0.3, 0.12], inf), Pseq([6, 4], inf)), inf)
		.clip(0.02, 0.5)
).play;
)


/////////////// Example 4: Granular FM Texture //////////////////

(
~fxBus = Bus.audio(s, 2);
~fxGroup = Group.after(s.defaultGroup);
~reverb = Synth(\reverb, [\in, ~fxBus, \out, 0, \mix, 0.5, \decay, 4], ~fxGroup);

Pbind(
	\instrument, \fm,
	\out, ~fxBus,
	\midinote, Pstutter(rrand(10, 30), Pexprand(48, 84, inf).round(1)),
	\cmRatio, Pstutter(rrand(5, 15), Pexprand(1.5, 4.5)),
	\index, Pexprand(5, 15),
	\rel, Pexprand(0.03, 0.12),
	\amp, Pexprand(0.05, 0.12),
	\pan, Pgauss(0, 0.7).clip(-1, 1),
	\dur, Pexprand(0.02, 0.08)
).play;
)

~reverb.free; ~fxBus.free;

/////////////// Example 5: Self-Modulating Feedback /////////////

// Feedback network creating evolving timbres
(
{
	var fb, sig, modulator;
	fb = LocalIn.ar(2);

	// Multiple feedback paths
	modulator = SinOsc.ar(LFNoise1.kr(0.2).range(0.5, 4));
	sig = SinOsc.ar([200, 201] + (fb * [150, 155]));
	sig = sig + (SinOsc.ar([400, 403] + (fb * 300)) * 0.3);
	sig = sig * modulator;
	sig = LeakDC.ar(sig);

	LocalOut.ar(sig * 0.7);
	sig * 0.15;
}.play;
)


/////////////// Example 6: Granular Resynthesis /////////////////

// Create evolving granular textures
(
{
	var density, grainDur, pos, sig;

	density = LFNoise1.kr(0.3).range(20, 120);
	grainDur = LFNoise2.kr(0.5).range(0.01, 0.1);
	pos = LFNoise1.kr(0.2).range(0, 1);

	sig = Mix.fill(8, {
		var trigger = Dust.ar(density);
		var freq = TExpRand.ar(100, 2000, trigger);
		var env = EnvGen.ar(Env.perc(0.001, grainDur), trigger);
		SinOsc.ar(freq) * env * 0.1;
	});

	sig = FreeVerb.ar(sig, 0.4, 0.8);
	sig ! 2;
}.play;
)


/////////////// Example 7: Spectral Morphing ///////////////////

// Morphing between different spectral content
(
{
	var sig1, sig2, morph, fft1, fft2, chain;

	// Source 1: Harmonic
	sig1 = Blip.ar(100, LFNoise1.kr(2).range(5, 30));

	// Source 2: Noise
	sig2 = BPF.ar(WhiteNoise.ar, LFNoise1.kr(1).range(200, 2000), 0.3);

	// Morph control
	morph = LFTri.kr(0.1).range(0, 1);

	// Spectral mixing
	fft1 = FFT(LocalBuf(2048), sig1);
	fft2 = FFT(LocalBuf(2048), sig2);
	chain = PV_XFade(fft1, fft2, morph);

	IFFT(chain).dup * 0.3;
}.play;
)


/////////////// Example 8: Complex Waveshaping /////////////////

// Multiple waveshapers in series
(
{
	var sig, driver;

	driver = LFNoise1.kr([0.3, 0.31]).range(0.5, 3);

	sig = SinOsc.ar([150, 151]);

	// Multiple shaping stages
	sig = (sig * driver).fold2(0.8);
	sig = (sig * 2).wrap2(0.7);
	sig = sig.distort;
	sig = sig * LFPulse.ar([0.5, 0.51], 0, 0.5).range(0.3, 1);

	sig = LPF.ar(sig, LFNoise1.kr(0.2).range(500, 3000));
	sig * 0.2;
}.play;
)


/////////////// Example 9: Granular Drone //////////////////////

// Dense granular synthesis creating drone textures
(
{
	var grains, freqs;

	freqs = [100, 133, 150, 200, 267].choose;

	grains = Mix.fill(4, {
		var trig = Dust.ar(ExpRand(20, 80));
		var freq = TExpRand.ar(freqs * 0.98, freqs * 1.02, trig);
		var dur = TRand.ar(0.05, 0.2, trig);
		var env = EnvGen.ar(
			Env.perc(dur * 0.3, dur * 0.7),
			trig
		);
		var pan = TRand.ar(-1, 1, trig);

		Pan2.ar(SinOsc.ar(freq) * env, pan);
	});

	grains = LPF.ar(grains, LFNoise1.kr(0.3).range(800, 3000));
	grains = grains + (CombC.ar(grains, 0.2, [0.12, 0.13], 3) * 0.3);

	grains * 0.15;
}.play;
)


/////////////// Example 10: Formant Synthesis ///////////////////

// Vowel-like formant synthesis with morphing
(
{
	var source, formants, vowel;

	// Source: pitched buzz
	source = Impulse.ar(LFNoise1.kr(0.5).range(80, 150));
	source = source + (WhiteNoise.ar(0.1));

	// Morphing vowel position
	vowel = LFTri.kr(0.1).range(0, 1);

	// Formant filters (simplified vowels)
	formants = [
		// "ah" formants
		[730, 1090, 2440],
		// "ee" formants
		[270, 2290, 3010]
	];

	source = Mix([
		BPF.ar(source, LinLin.kr(vowel, 0, 1, formants[0][0], formants[1][0]), 0.1) * 3,
		BPF.ar(source, LinLin.kr(vowel, 0, 1, formants[0][1], formants[1][1]), 0.05) * 2,
		BPF.ar(source, LinLin.kr(vowel, 0, 1, formants[0][2], formants[1][2]), 0.03) * 1
	]);

	source = source + FreeVerb.ar(source, 0.3, 0.7);
	source ! 2 * 0.3;
}.play;
)


/////////////// Example 11: Frequency Shifter Network ///////////

// Multiple frequency shifters
(
{
	var sig, shifted, freqs;

	sig = Impulse.ar(LFNoise1.kr(0.3).range(2, 12));
	sig = Decay2.ar(sig, 0.01, 0.1) * PinkNoise.ar();

	freqs = [0, 100, 217, 345, 523];

	shifted = Mix(freqs.collect({ |freq|
		FreqShift.ar(sig,
			freq * LFNoise1.kr(0.2).range(0.95, 1.05),
			LFNoise1.kr(0.1).range(-pi, pi)
		) * 0.2
	}));

	shifted = LPF.ar(shifted, LFNoise1.kr(0.5).range(1000, 4000));
	shifted = shifted + CombC.ar(shifted, 0.2, [0.15, 0.16], 2) * 0.3;

	shifted * 0.3;
}.play;
)

/////////////// Example 12: Texture Layers //////////////////////

// Multiple textural layers creating complex sonority
(
{
	var layer1, layer2, layer3, mix;

	// Layer 1: Low drone
	layer1 = Mix(
		SinOsc.ar([100, 100.5, 101] * [1, 1.5, 2.5]) * [0.3, 0.2, 0.15]
	);
	layer1 = layer1 * LFNoise1.kr(0.3).range(0.5, 1);

	// Layer 2: Granular mid
	layer2 = Mix.fill(8, {
		var trig = Dust.ar(ExpRand(10, 40));
		var freq = TExpRand.ar(400, 1200, trig);
		var env = EnvGen.ar(Env.perc(0.01, 0.1), trig);
		SinOsc.ar(freq) * env * 0.08;
	});

	// Layer 3: High shimmer
	layer3 = BPF.ar(
		WhiteNoise.ar(),
		LFNoise1.kr([0.2, 0.21]).range(2000, 4000),
		0.1
	) * 2;
	layer3 = layer3 * LFPulse.kr(LFNoise0.kr(0.5).range(1, 8), 0, 0.3);

	mix = [layer1, layer2, layer3].sum;
	mix = mix + FreeVerb.ar(mix, 0.5, 0.9) * 0.4;

	mix * 0.2;
}.play;
)