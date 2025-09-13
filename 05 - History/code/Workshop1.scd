////////////////////////////////////////////////////////////////
//
//                 Workshop 1, Possible Solutions
//
////////////////////////////////////////////////////////////////

(

SynthDef(\sine, {
	|amp=0.1, freq=440, pan=0, dur=1|
	var env, sig;
	env = EnvGen.kr(Env.perc(0.01, dur), doneAction:2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;

SynthDef(\saw, {
	|amp=0.1, freq=440, pan=0, dur=1|
	var env, sig;
	env = EnvGen.kr(Env.perc(0.01, dur), doneAction:2);
	sig = Saw.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;

)

/*

1. Implement a process where a synth is played first very fast and then very slowly.
The duration pattern should alternate between the two types of duration.
(hint: see Pseq with nested patterns)


*/

(

Pbind(
	\instrument, \sine,
	\freq, 500,
	\dur, Pseq([ Pwhite(0.1, 0.2, 10).round(0.01), Pwhite(0.4,1.0,6).round(0.1)], inf).trace
).play

)


/* 2. Implement a process that plays two synths interchangeably
where the probability of synth a is 25% and event b is 75%
(hint: see Pwrand for weighted randomness) */

(

Pbind(
	\instrument, Pwrand([\sine, \saw], [0.25, 0.75],inf).poll,
	\freq, 150,
	\dur, 0.1
).play

)

/* 3. Implement a stochastic process where low pitches have a
longer duration than high ones.
(hint: see Pkey to couple parameters) */

(

Pbind(
	\instrument, \sine,
	\freq, Pwhite(100, 1000),
	\dur, Pkey(\freq).linlin(100, 1000, 1.5, 0.001)
).poll.play

)

/* 4. Implement a Process based on two or more layers where
moments occur with all layers playing at the same time and
others with only a single layer playing.
(hint: see Ppar for parallel patterns). */

(

a = Pbind(
	\instrument, \sine,
	\freq, Pseq([800, 160, \rest, \rest, 400, 500], inf),
	\dur, 0.4
);

b = Pbind(
	\instrument, \saw,
	\freq, Pseq([30, 40, 40, 30, \rest, \rest], inf),
	\dur, 0.4
);

Ppar([a,b], inf).trace.play;

)

/* 5. Implement a sequence where pitches are chosen randomly.
The randomness should be very wide in range in the beginning
but decrease and settle once it continues.
(hint: see Penv or simply Env for gradual shapes). */

(

Pbind(
	\instrument, \saw,
	\rand, Penv([1000, 500, 250, 50], [4,3,6]),
	\freq, Pwhite(40, Pkey(\rand)),
	\dur, 0.1
).play

)


/* 6. Implement a process with various layers where each layer
appears and later disappears gradually.
(hint: see Penv or simply Env for gradual shapes). */

(

a = Pbind(
	\instrument, \sine,
	\freq, 100,
	\amp, Pn(Penv([0,0,1,0], [4,8,8])) * 0.2,
	\dur, 0.1
);

b = Pbind(
	\instrument, \sine,
	\freq, 800,
	\amp, Pn(Penv([0,1,0.1,0], [2,8,8])) * 0.2,
	\dur, 0.1
);

Ppar([a,b], inf).play;

)


/* 7. Implement a process that oscillates between random values and repeated ones.
(hint: see Pstutter for repeating values). */

(

Pbind(
	\instrument, \sine,
	\freq, Pstutter(Pseq([Pseq([1],8),8], inf), Pwhite(100, 400)).trace,
	\dur, 0.1
).play

)

/* 8. Implement a sequence of two layers, both using brownian
motion for pitch and duration values. One layer should stop
before the other.
(hint: see Pbrown for brownian motion). */

(

a =  Pbind(
	\instrument, \sine,
	\freq, Pbrown(1000, 1200, 10, 64),
	\dur, Pbrown(0.05, 0.15, 0.01)
);

b =  Pbind(
	\instrument, \saw,
	\freq, Pbrown(80, 90, 1, 32),
	\dur, Pbrown(0.2, 0.4, 0.01)
);


Ppar([a,b]).play

)


/* 9. Implement a process with at least three layers where
moments occur where all are playing but also where each one
plays individually.
(hint: see \rest for rest values). */

( "see solution to exercise 4" )


/* 10. Implement a process where pitch values are determined
either according to cauchy or exponential distribution.
Dynamics should be determined with a geometric rise.
(hint: see Pcauchy, Pexprand and Pgeom).*/

(

Pbind(
	\instrument, \saw,
	\freq, Pcauchy(200, 10, inf),
	\amp, Pseq([Pgeom(0.001, 1.15, 48), Pgeom(0.713, 0.85, 48)], inf).trace,
	\dur, 0.1
).play

)