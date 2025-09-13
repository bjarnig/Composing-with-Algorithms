////////////////////////////////////////////////////////////////
//
//                         Koenig
//
////////////////////////////////////////////////////////////////


Pattern basics and sequencing synths.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

(

SynthDef(\sine, { |freq=400, amp=0.2, atk=0.1, rel=0.5, pan=0|
	var env, sig;
	env = EnvGen.ar(Env([0, amp, 0], [atk, rel], \sine), doneAction: 2);
	sig = SinOsc.ar(freq, 0, env);
	sig = Pan2.ar(sig, pan);
	OffsetOut.ar(0, sig);
}).add;

SynthDef(\saw, {
	|amp=0.1, freq=440, pan=0, atk=0.1, dec=0.5, sus=0.5, rel=0.2, gate=1, curve=1, lpf=10000, rq=0.5|
	var env, sig;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel, amp, curve), gate, doneAction:2);
	sig = Saw.ar(freq, freq/2) * env;
	sig = RLPF.ar(sig, lpf, rq) * 0.1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;

SynthDef(\snd, { arg freq=500, gate=1, out=0, lop=8000, amp=0.1, pan=0, atk=0.01, rel=0.25;
	var env = EnvGen.kr(Env.asr(atk, amp, rel), gate, doneAction:2);
	var signal = RLPF.ar(Saw.ar(freq, 0.25).fold2(SinOsc.ar(freq/2)), lop);
    OffsetOut.ar(out, Pan2.ar(signal * env, pan));
}).add;


)


//////////////////////////// Alea //////////////////////////////

Alea (random)

(

    ~pitches = [43, 48, 45, 43, 48, 43, 47, 39, 41];
    ~rhythms = [1, 1/4, 1/5, 1/4, 1/8, 1/2];

    Pbind(
	    \instrument, \snd,
	    \midinote, Prand(~pitches, inf),
	    \dur, Prand(~rhythms, inf)
	).play;
)

( // collect to transform a list

    ~frequencies = ~pitches.collect({ arg item, i; item.midicps }) * 2;

    Pbind(
    	\instrument, \sine,
	    \freq, Prand(~frequencies, inf),
	    \dur, Prand(~rhythms, inf)
	).play;
)

( // block certain intervals

 Pbind(
	    \instrument, \snd,
	    \degree, Pwhite(0.1, 1.0).reject({arg item; (item > 0.4) && (item < 0.8) }).trace,
	    \dur, 0.1
	).play;
)

( // three notes from two random octaves

 Pbind(
	    \instrument, \snd,
	    \note, Prand([1,3,4], inf),
	    \octave, Prand([3,4], inf),
	    \dur, Pwhite(0.08, 0.18).round(0.02)
	).play;
)


////////////////////////// Series //////////////////////////////

Series (random with repetition check)

(
    Pbind(
	    \instrument, \snd,
		\midinote, Pn(Plazy({ Pseq(~pitches.scramble, 1) }), inf),
		\dur, 0.2
	).play;
)

(
    Pbind(
    	\instrument, \sine,
		\freq, Pn(Plazy({ Pseq(~frequencies.scramble, 1) }), inf),
		\dur, 0.1
	).play;
)



/////////////////////////// Ratio //////////////////////////////

Ratio (weighted random)

(
	~weights = [2, 0.2, 2, 0.3, 0.5, 0.5, 1, 0.5, 1].normalizeSum;

	Pbind(
	    \instrument, \snd,
	    \midinote, Pwrand(~pitches, ~weights, inf),
	    \dur, 0.2
	).play;
)




/////////////////////////// Group //////////////////////////////

Group (repeating random values)

(
	~repeats = 4;

	Pbind(
	    \instrument, \snd,
	    \midinote, Pstutter(~repeats, Prand(~pitches, inf)),
	    \dur, 0.15
	).play;
)



/////////////////////////// Tendency ///////////////////////////

Tendency (random between changing boundaries)

(
	Pbind(
	    \instrument, \snd,
	    \midinote, Pwhite(
		    Pseg(
			    Pseq([ 60, 80, 10, 100 ], inf),
				Pseq([ 5, 5, 5, 5 ], inf)),
			Pseg(
			    Pseq([ 80, 100, 50, 120 ], inf),
				Pseq([ 5, 5, 5, 5 ], inf))
			),
	    \dur, 0.1
	).play;
)



///////////////////////// Chords ///////////////////////////////

(
    Pbind(
	    \instrument, \snd,
	    \midinote, Pseq([[60, 64, 68], [53, 56, 59] ], inf),
	    \dur, Pseq([0.5, 0.25], inf)
	).play;
)

(
    Pbind(
	    \instrument, \snd,
		\midinote, Pwhite([60, 70], [80, 90], inf),
		\dur, Pwrand([1, 0.25], [0.6, 0.4], inf)
	).trace.play;
)


/////////////////////// Selections /////////////////////////////

/* Use a shape to read from previously created collection. */

(

var shape, coll;

shape = Env([0,0.5,0.8,0.2,1.0], 2.5 ! 4);
shape.plot;
coll = Array.series(24, 48, 0.05);

Pbind(
	\instrument, \snd,
	\env, Pn(Penv(shape.levels, shape.times)),
	\midinote, Pfunc{|ev| ev.postln; coll[(coll.size-1) * ev.env]},
	\dur, 0.1,
	\atk, 0.1
	).play
)


/* Tendancy mask reads from a collection, shuffled durations and clock at 90 bpm */

(

var low, hi, coll;

hi = Env([0.26, 0.51, 0.9], [0.5, 0.5]);
low = Env([0.25, 0.49, 0.01], [0.5, 0.5]);
coll = Array.series(16, 40, 2);

Pbind(
	\instrument, \snd,
	\th, Pn(Penv(hi.levels, hi.times * 2)),
	\tl, Pn(Penv(low.levels, low.times * 2)),
	\midinote, Pfunc{|ev| coll[((coll.size-1) * rrand(ev.tl, ev.th))]}.trace,
	\dur, Pn(Pshuf([1/16, 1/8, 1/32]))
).play(TempoClock(90/60));

)


///////////////////////// Patterns ///////////////////////////////

//Series up
a = Pbind(\midinote, Pseries(48, 1, 48), \dur, 0.1)
a.play


// Series down
b = Pbind(\midinote, Pseries(96, -1, 48), \dur, 0.1)
b.play


// Combine up and down
c = Pseq([a,b])
c.play


// Create layers from up and down
d = Ptpar([0.0, a, 0.0, b, 0.5, a, 0.5, b, 1.0, a, 1.0, b])
d.play


// Nested pattern with randomness
e = Pbind(\midinote, Pseries(60, Pwhite(-5, 5, inf).trace, inf), \dur, 0.1)
e.play


// Play for a duration, rounded floating point numbers
f = Pfindur(10, Pbind(\midinote, Pwhite(60.001, 61.008).round(0.1), \dur, 0.1)).trace
f.play


// Create and play from a collection and add an offset.
a = [0,1,2,3,4,5,6] + 60
Pbind(\midinote, Prand(a + 7, inf), \dur, 0.1).play


// Generate a collection using a pattern.
b = Pseries(1, 1).asStream.nextN(64) + 60
Pbind(\midinote, Pseq(b), \dur, 0.05).play


// Choose from different collections
c = [50,52,54]; d = [60,62]; e = [70,71];
Pbind(\midinote, Pseq([Prand(c,4), Prand(d,2), Prand(e,10)], inf), \dur, 0.1).play

