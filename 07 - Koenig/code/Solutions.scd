////////////////////////////////////////////////////////////////
//
//                     CW06 - Exercises
//
////////////////////////////////////////////////////////////////

( // SynthDef that will be used below

SynthDef(\snd, { arg freq=500, gate=1, out=0, lop=8000, amp=0.1, pan=0, atk=0.01, rel=0.25;
	var env = EnvGen.kr(Env.asr(atk, amp, rel), gate, doneAction:2);
	var signal = RLPF.ar(Saw.ar(freq, 0.25).fold2(SinOsc.ar(freq/2)), lop);
    OffsetOut.ar(out, Pan2.ar(signal * env, pan));
}).add;

)


/* 1. Implement a stochastic process that uses a different distribution
for amplitude, frequency and duration of events. */

(

Pbind(
	\instrument, \snd,
	\amp, Pbeta(0.05, 0.2),
	\freq, Pexprand(100, 150).round(0.5),
	\dur, Pbrown(0.1, 0.2, 0.025)
).play

)


/* 2. Implement a stochastic process where the high and low limits of a
distribution change in time.They should start by being very wide (far apart)
but narrow as the process unfolds. */

(

Pbind(
	\instrument, \snd,
	\freq, [100, 300] * Pwhite(1, 2),
	\amp, 0.05,
	\lop, Pwhite(100, 8000),
	\lo, Env([0.05, 0.12, 0.8], [4, 8]),
	\hi, Env([0.025, 0.1, 0.2], [4, 8]),
	\dur, Pwhite(Pkey(\lo), Pkey(\hi))
).play

)

/* 3. Implement a stochastic process where sequences of different
distributions are used. */

(

var lo=50, hi=500;

Pbind(
	\instrument, \snd,
	\freq, Pseq([Pwhite(lo, hi, 8), Pbeta(lo, hi, length:8), Pexprand(lo, hi, 8)],inf),
	\amp, Pbrown(0.001, 0.1, 0.05),
	\atk, 0.02,
	\rel, 0.1,
	\dur, 0.1
).play

)


/* 4. Implement a rhythmic sequence where a Markov chain is used for
duration values. */

(

Pbind(
	\instrument, \snd,
	\freq, [100, 140],
	\amp, Pbrown(0.001, 0.2, 0.05),
	\lop, Pbeta(100, 8000),
	\rel, 0.1,
	\dur, Pfsm([[0], 0.1, [0, 1], 0.05, [1,2,3], 0.2, [0, 2], 0.4, [0]], inf),
).play

)

/* 5. Implement a sequence of Pbinds where each uses a brownain motion
(Pbrown) for controlling pitches in different ways.These Pbinds should
then be sequences in time using Pspawner. */


(

Pn(Pspawner({ | sp |
	sp.par(Pbind(\instrument, \snd, \dur, 0.1, \freq, Pbrown(100, 150, 1, 16)));
	sp.par(Pbind(\instrument, \snd, \dur, 0.15, \freq, Pbrown(50, 250, 100, 32)));
	sp.wait(2);
	sp.seq(Pbind(\instrument, \snd, \dur, 0.08, \freq, Pbrown(100, 400, 100, 16)));
	sp.seq(Pbind(\instrument, \snd, \dur, 0.12, \freq, Pbrown(50, 150, 10, 12)));
	sp.wait(1);
})).play

)
