////////////////////////////////////////////////////////////////
//
//                          Glisson
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
SynthDef(\gliss, { |buf=0, start=0, amp=0.5, dur=0.3, pan=0, from=0.5, to=4.0|
	var sig, shape, env, pos;
	shape = Env([0, amp, 0], [dur*0.5, dur*0.5], \sine);
	env = EnvGen.ar(shape, doneAction: 2);
	pos = start * BufFrames.ir(buf);
	sig = PlayBuf.ar(1, buf, Line.ar(from, to, dur) * BufRateScale.ir(buf), 1, pos, 0);
	OffsetOut.ar(0, Pan2.ar(sig * env, pan));
}).add;

)

// Glisson towards hi

(

var dur = 0.02;
var ovlp = 2.0;
var sample = ~voice;
var totaldur = sample.numFrames / sample.sampleRate;
var next = dur / ovlp;
var n = (totaldur / dur * ovlp).asInteger;
var startIncrement = next / totaldur;

Pbind(
	\instrument, \gliss,
	\buf, sample.bufnum,
	\dur, dur,
	\delta, next,
	\amp, 0.5,
	\pan, 0,
	\start, Pseries(0, startIncrement, n),
	// Glissando from sweeps upward over time
	\counter, Pseries(0, 1, n),
	\from, Pkey(\counter).linlin(0, n, 1.0, 2.0),
	\to, Pkey(\counter).linlin(0, n, 2.0, 10.0)
).play;

)



// Glisson converging to center
(

var dur = 0.02;
var ovlp = 2.0;
var sample = ~voice;
var totaldur = sample.numFrames / sample.sampleRate;
var next = dur / ovlp;
var n = (totaldur / dur * ovlp).asInteger;
var startIncrement = next / totaldur;

// Pre-calculate envelope values for from/to
var fromEnv = Env([0.1, 1, 1], [n/2, n/2]);
var toEnv = Env([100, 4, 1], [n/2, n/2]);

Pbind(
	\instrument, \gliss,
	\buf, sample.bufnum,
	\dur, dur,
	\delta, next,
	\amp, 0.5,
	\pan, 0,
	\start, Pseries(0, startIncrement, n),
	\counter, Pseries(0, 1, n),
	\from, Pfunc { |ev| fromEnv.at(ev[\counter]) },
	\to, Pfunc { |ev| toEnv.at(ev[\counter]) }
).play;

)



// Glisson layers - function version
(

~glissons = { |times=10, dur=0.1, ovlp=2.0, from=0.1, to=2, sample|
	var totaldur = sample.numFrames / sample.sampleRate;
	var next = dur / ovlp;
	var n = (totaldur / dur * ovlp).asInteger;
	var startIncrement = next / totaldur;

	times.do { |layer|
		var layerNum = layer + 1;
		var fromEnv = Env([from * layerNum, 1, 1], [n/2, n/2] * layerNum);
		var toEnv = Env([to * layerNum, 4, 1], [n/2, n/2] * layerNum);

		Pbind(
			\instrument, \gliss,
			\buf, sample.bufnum,
			\dur, dur,
			\delta, next,
			\amp, 0.5,
			\pan, 0,
			\start, Pseries(0, startIncrement, n),
			\counter, Pseries(0, 1, n),
			\from, Pfunc { |ev| fromEnv.at(ev[\counter]) },
			\to, Pfunc { |ev| toEnv.at(ev[\counter]) }
		).play;
	};
};

~glissons.value(5, sample: ~voice);

)