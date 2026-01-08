////////////////////////////////////////////////////////////////
//
//                    Granular Patterns
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)



////////////////////// Buffers & SynthDef ///////////////////////

(

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
~path = ~path ++ "samples/";
~voice = Buffer.read(s, ~path ++ "vocal.wav");
~bikecat = Buffer.read(s, ~path ++ "bikecat.wav");

SynthDef(\grain, { |buf=0, rate=1, start=0, amp=0.5, dur=0.3, pan=0|
	var sig, shape, env, pos;
	shape = Env([0, amp, 0], [dur*0.5, dur*0.5], \sine);
	env = EnvGen.ar(shape, doneAction: 2);
	pos = start * BufSamples.ir(buf);
	sig = PlayBuf.ar(1, buf, rate * BufRateScale.ir(buf), 1, pos, 0);
	OffsetOut.ar(0, Pan2.ar(sig * env, pan));
}).add;

)


// Play through a sound (linear progression)
(
var n = 1000;
var dur = 0.1;
var delta = 0.01;

Pbind(
	\instrument, \grain,
	\buf, ~voice.bufnum,
	\dur, dur,
	\delta, delta,
	\amp, 0.5,
	\pan, 0,
	\start, Pseries(0, 1/n, n)
).play;
)



// Randomize start times
(
var n = 100000;
var dur = 0.1;
var delta = 0.01;

Pbind(
	\instrument, \grain,
	\buf, ~bikecat.bufnum,
	\dur, dur,
	\delta, delta,
	\amp, 0.5,
	\pan, 0,
	\start, Pwhite(0.0, 0.1, n)
).play;
)



// Reconstruct a sound
(
var dur = 0.2;
var ovlp = 2;
var totaldur = ~voice.duration;
var next = dur / ovlp;
var n = (totaldur / dur * ovlp).asInteger;
var startIncrement = next / totaldur;

Pbind(
	\instrument, \grain,
	\buf, ~voice.bufnum,
	\dur, dur,
	\delta, next,
	\amp, 0.5,
	\pan, 0,
	\start, Pseries(0, startIncrement, n)
).play;
)



// Timestretch
(
var dur = 0.05;
var ovlp = 2;
var stretch = 8;
var totaldur = ~voice.numFrames / ~voice.sampleRate;
var next = dur / ovlp;
var n = (totaldur / dur * ovlp * stretch).asInteger;
var startIncrement = next / totaldur / stretch;

Pbind(
	\instrument, \grain,
	\buf, ~voice.bufnum,
	\dur, dur,
	\delta, next,
	\amp, 0.5,
	\pan, 0,
	\start, Pseries(0, startIncrement, n)
).play;
)



// Morph between sounds
(
var dur = 0.06;
var ovlp = 2;
var stretch = 0.75;
var totaldur = ~voice.numFrames / ~voice.sampleRate;
var next = dur / ovlp;
var n = (totaldur / dur * ovlp * stretch).asInteger;
var startIncrement = next / totaldur / stretch;

Pbind(
	\instrument, \grain,
	\dur, dur,
	\delta, next,
	\amp, 0.5,
	\pan, 0,
	\start, Pseries(0, startIncrement, n),
	// Morph probability from voice to bikecat over time
	\counter, Pseries(0, 1, n),
	\buf, Pfunc { |ev|
		var prob = ev[\counter].linlin(0, n, 0, 1);
		[~voice.bufnum, ~bikecat.bufnum].wchoose([1-prob, prob])
	}
).play;
)



// Randomize sound and start position
(
var n = 10000;
var dur = 0.15;
var delta = 0.01;

Pbind(
	\instrument, \grain,
	\dur, dur,
	\delta, delta,
	\amp, 0.5,
	\pan, 0,
	// 40% chance voice, 60% chance bikecat
	\buf, Pwrand([~voice.bufnum, ~bikecat.bufnum], [0.4, 0.6], n),
	// 20% chance range 0.1-0.4, 80% chance range 0.6-0.8
	\start, Pwrand(
		[Pwhite(0.1, 0.4, 1), Pwhite(0.6, 0.8, 1)],
		[0.2, 0.8],
		n
	)
).play;
)
