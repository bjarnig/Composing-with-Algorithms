////////////////////////////////////////////////////////////////
//
//                    Granular Examples
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)



////////////////////// Buffers & SynthDefs ///////////////////////

(

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
~path = ~path ++ "samples/";
~voice = Buffer.read(s, ~path ++ "vocal.wav");
~bikecat = Buffer.read(s, ~path ++ "bikecat.wav");

// Load click samples for buffer variations
~clickPath = ~path ++ "clicks/*";
~files = SoundFile.collect(~clickPath);
~clicks = ~files.collect { |sf| Buffer.read(s, sf.path) };

// Basic grain synth
SynthDef(\grain, { |buf=0, rate=1, start=0, amp=0.5, dur=0.3, pan=0|
	var sig, shape, env, pos;
	shape = Env([0, amp, 0], [dur*0.5, dur*0.5], \sine);
	env = EnvGen.ar(shape, doneAction: 2);
	pos = start * BufSamples.ir(buf);
	sig = PlayBuf.ar(1, buf, rate * BufRateScale.ir(buf), 1, pos, 0);
	OffsetOut.ar(0, Pan2.ar(sig * env, pan));
}).add;

// Glissando grain (pitch sweeps within each grain)
SynthDef(\gliss, { |buf=0, start=0, amp=0.5, dur=0.3, pan=0, from=1.0, to=2.0|
	var sig, shape, env, pos, rate;
	shape = Env([0, amp, 0], [dur*0.5, dur*0.5], \sine);
	env = EnvGen.ar(shape, doneAction: 2);
	pos = start * BufFrames.ir(buf);
	rate = Line.ar(from, to, dur) * BufRateScale.ir(buf);
	sig = PlayBuf.ar(1, buf, rate, 1, pos, 0);
	OffsetOut.ar(0, Pan2.ar(sig * env, pan));
}).add;

// Bandpass filtered grain
SynthDef(\grainbp, { |buf=0, rate=1, start=0, amp=0.5, dur=0.3, pan=0, bpf=1000, bw=1.0|
	var sig, shape, env, pos;
	shape = Env([0, amp, 0], [dur*0.5, dur*0.5], \sine);
	env = EnvGen.ar(shape, doneAction: 2);
	pos = start * BufFrames.ir(buf);
	sig = PlayBuf.ar(1, buf, rate * BufRateScale.ir(buf), 1, pos, 0);
	sig = BBandPass.ar(sig, bpf, bw);
	OffsetOut.ar(0, Pan2.ar(sig * env, pan));
}).add;

// Waveshaping/folding grain
SynthDef(\grainfold, { |buf=0, rate=1, start=0, amp=0.5, dur=0.3, pan=0, flo=(-0.5), fhi=0.5|
	var sig, shape, env, pos;
	shape = Env([0, amp, 0], [dur*0.5, dur*0.5], \sine);
	env = EnvGen.ar(shape, doneAction: 2);
	pos = start * BufFrames.ir(buf);
	sig = PlayBuf.ar(1, buf, rate * BufRateScale.ir(buf), 1, pos, 0);
	sig = Fold.ar(sig, flo, fhi);
	OffsetOut.ar(0, Pan2.ar(sig * env, pan));
}).add;

// Pulsar synthesis grain (sine with adjustable window)
SynthDef(\pulsar, { |freq=220, amp=0.3, dur=0.1, pan=0, attack=0.5|
	var sig, env;
	env = EnvGen.ar(Env.perc(dur * attack, dur * (1 - attack), amp), doneAction: 2);
	sig = SinOsc.ar(freq) * env;
	OffsetOut.ar(0, Pan2.ar(sig, pan));
}).add;

// FM pulsar grain
SynthDef(\pulsarfm, { |freq=220, modfreq=440, modindex=1, amp=0.3, dur=0.1, pan=0|
	var sig, env, mod;
	env = EnvGen.ar(Env.sine(dur, amp), doneAction: 2);
	mod = SinOsc.ar(modfreq) * modindex * freq;
	sig = SinOsc.ar(freq + mod) * env;
	OffsetOut.ar(0, Pan2.ar(sig, pan));
}).add;

)

// Glissando converging to unity (wide sweep → stable)
(
var dur = 0.025;
var ovlp = 2.0;
var sample = ~bikecat;
var totaldur = sample.numFrames / sample.sampleRate;
var next = dur / ovlp;
var n = (totaldur / dur * ovlp).asInteger;
var startIncrement = next / totaldur;

var fromEnv = Env([0.25, 1, 1], [n/2, n/2]);
var toEnv = Env([8, 1, 1], [n/2, n/2]);

Pbind(
	\instrument, \gliss,
	\buf, sample.bufnum,
	\dur, dur,
	\delta, next,
	\amp, 0.4,
	\pan, Pbrown(-0.5, 0.5, 0.1, n),
	\start, Pseries(0, startIncrement, n),
	\counter, Pseries(0, 1, n),
	\from, Pfunc { |ev| fromEnv.at(ev[\counter]) },
	\to, Pfunc { |ev| toEnv.at(ev[\counter]) }
).play;
)


// Filter sweep: low to high frequency
(
var dur = 0.04;
var ovlp = 2.0;
var sample = ~bikecat;
var totaldur = sample.numFrames / sample.sampleRate;
var next = dur / ovlp;
var n = (totaldur / dur * ovlp).asInteger;
var startIncrement = next / totaldur;

Pbind(
	\instrument, \grainbp,
	\buf, sample.bufnum,
	\dur, dur,
	\delta, next,
	\amp, 0.6,
	\pan, 0,
	\bw, 2,
	\start, Pseries(0, startIncrement, n),
	\counter, Pseries(0, 1, n),
	\bpf, Pkey(\counter).linexp(0, n, 200, 6000)
).play;
)



// Spectral clouds: random filter bands
(
var n = 5000;
var dur = 0.08;
var delta = 0.01;

Pbind(
	\instrument, \grainbp,
	\buf, Pwrand([~voice.bufnum, ~bikecat.bufnum], [0.3, 0.7], n),
	\dur, dur,
	\delta, delta,
	\amp, 0.5,
	\pan, Pwhite(-0.8, 0.8, n),
	\bw, 3,
	\start, Pwhite(0.0, 1.0, n),
	\bpf, Prand([200, 400, 800, 1600, 3200, 6400], n)
).play;
)


// Accelerating grain density
(
var sample = ~voice;
var totaldur = sample.numFrames / sample.sampleRate;
var n = 800;

Pbind(
	\instrument, \grain,
	\buf, sample.bufnum,
	\amp, 0.4,
	\pan, Pbrown(-0.5, 0.5, 0.1, n),
	\counter, Pseries(0, 1, n),
	// Grain duration shrinks
	\dur, Pkey(\counter).linexp(0, n, 0.2, 0.002),
	// Delta shrinks faster = increasing density
	\delta, Pkey(\counter).linexp(0, n, 0.1, 0.001),
	// Progress through buffer
	\start, Pkey(\counter).linlin(0, n, 0, 1)
).play;
)



// Breathing density (swells and recedes)
(
var sample = ~bikecat;
var n = 1000;

Pbind(
	\instrument, \grain,
	\buf, sample.bufnum,
	\dur, 0.06,
	\amp, 0.4,
	\pan, Pwhite(-0.6, 0.6, n),
	\counter, Pseries(0, 1, n),
	// Oscillating density via sine-shaped delta
	\delta, Pseg(
		Pseq([0.05, 0.005, 0.05], inf),
		Pseq([2, 2], inf),
		\sine
	),
	\start, Pwhite(0.0, 1.0, n)
).play;
)

// Bouncing stereo grains
(
var n = 2000;
var dur = 0.05;
var delta = 0.015;

Pbind(
	\instrument, \grain,
	\buf, Pwrand([~voice.bufnum, ~bikecat.bufnum], [0.5, 0.5], n),
	\dur, dur,
	\delta, delta,
	\amp, 0.4,
	\rate, Pwhite(0.8, 1.2, n),
	\start, Pwhite(0.0, 1.0, n),
	// Brownian motion in stereo field with bounce at edges
	\pan, Pbrown(-1.0, 1.0, 0.15, n)
).play;
)


// Cycling through click samples
(
var n = 500;
var dur = 0.01;
var delta = 0.003;
var numClicks = ~clicks.size;

Pbind(
	\instrument, \grain,
	\dur, dur,
	\delta, delta,
	\amp, 0.75,
	\pan, Pwhite(-0.8, 0.8),
	\rate, Pwhite(0.5, 2.0),
	\start, 0,
	// Cycle through available click buffers
	\counter, Pn(Pseries(0, 1, n)),
	\buf, Pfunc { |ev| ~clicks.wrapAt(ev[\counter]).bufnum }
).play;
)



// Weighted random buffer selection with density correlation
(
var n = 3000;
var dur = 0.08;
var delta = 0.012;

Pbind(
	\instrument, \grain,
	\dur, dur,
	\delta, delta,
	\amp, 0.4,
	\pan, Pwhite(-1.0, 1.0, n),
	// Voice grains are longer, bikecat are shorter
	\buf, Pwrand([~voice.bufnum, ~bikecat.bufnum], [0.4, 0.6], n),
	\rate, Pfunc { |ev|
		if(ev[\buf] == ~voice.bufnum,
			{ rrand(0.8, 1.0) },
			{ rrand(1.5, 2.5) }
		)
	},
	\start, Pwhite(0.1, 0.9, n)
).play;
)


// Freeze effect (staying at one position)
(
var dur = 0.68;
var delta = 0.01;
var n = 500;
var freezePos = 1.0.rand;

5.do {

Pbind(
	\instrument, \grain,
	\buf, ~voice.bufnum,
	\dur, dur,
	\delta, delta,
	\amp, 0.4,
	\pan, Pwhite(-0.3, 0.3, n),
	\rate, Pwhite(0.98, 1.02, n),
	// Small random deviation around freeze position
	\start, freezePos + Pwhite(-0.01, 0.01, n)
).play;

}

)

// Stutter/repeat effect
(
var dur = 0.05;
var delta = 0.02;
var sample = ~bikecat;
var totaldur = sample.numFrames / sample.sampleRate;

Pbind(
	\instrument, \grain,
	\buf, sample.bufnum,
	\dur, dur,
	\delta, delta,
	\amp, 0.5,
	\pan, 0,
	\rate, 1,
	// Repeat each position 8 times before moving on
	\start, Pn(Pstutter(8, Pseries(0, 0.05, 20)))
).play;

)

