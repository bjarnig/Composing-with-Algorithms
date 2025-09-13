////////////////////////////////////////////////////////////////
//
//                     Patterns. Recap.
//
////////////////////////////////////////////////////////////////

Pattern basics and 9 important things we have learned so far.

(

// We always start by booting the server (COMMAND-B) or running the following line:

Server.default.boot;

)

(

// Then we add the synthdefs we will use. For now we have simple synths but we will study those in detail later.

SynthDef(\sine, {
	|amp=0.1, freq=440, pan=0|
	var env, sig;
	env = EnvGen.kr(Env.perc, doneAction:2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;

SynthDef(\saw, {
	|amp=0.1, freq=440, pan=0|
	var env, sig;
	env = EnvGen.kr(Env.perc, doneAction:2);
	sig = Saw.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;

)


(

// Basics 01 - Make a sequence of values. Here three frequencies are played and repeated forever.

Pbind(
	\instrument, \sine,
	\freq, Pseq([100, 800, 300], inf),
	\dur, 0.2
).play

)


(

// Basics 02 - Choose random values. Here random frequencies between 100 and 800 are played and repeated forever.

Pbind(
	\instrument, \sine,
	\freq, Pwhite(100, 800),
	\dur, 0.2
).play

)


(

// Basics 03 - Shapes in time. Here a shape goes from 100 to 800 in 3 secs, then down to 60 in 1 sec and finally to 8000 in 2 secs

Pbind(
	\instrument, \sine,
	\freq, Penv([100, 800, 60, 8000], [1, 3, 2]),
	\dur, 0.1
).play

)


(

// Basics 04 - Patterns can be nested. Here we have a sequence of three fixed pitches, four random ones and a shape in time.

Pbind(
	\instrument, \sine,
	\freq, Pseq([ Pseq([100, 800, 400], 1), Pwhite(100, 800, 4), Penv([100,800,60],[1,2]) ], inf),
	\dur, 0.2
).play

)


(

// Basics 05 - Patterns can be also played in paralell

a = Pbind(
	\instrument, \sine,
	\freq, Pseq([100, 800, 400], inf),
	\dur, 0.2
);


b = Pbind(
	\instrument, \sine,
	\freq, Pwhite(1000, 4000).round(100),
	\amp, 0.05,
	\dur, 0.1
);

Ppar([a,b],inf).play;

)


(

// Basics 06 - Relate different parameters through Pkey

Pbind(
	\instrument, \sine,
	\freq, Pseq([100, 200, 400], inf),
	\dur, Pkey(\freq) * 0.001 // Reads the frequency from \freq
).play

)


(

// Basics 07 - Putting Pdef around a pattern and change it while it runs

Pdef(\something, Pbind(
	\instrument, \sine,
	\freq, Pwhite(100, 8000), // Try changing this and evaluate without stopping
	\dur, 0.2
)).play;

)


(

// Basics 08 - Arrays [  ] are lists and will result in 'chords' instead of single notes.

Pbind(
	\instrument, \sine,
	\freq, Pseq([ [100, 200, 800], [400, 600, 1000] ], inf),
	\dur, 0.3
).play

)


(

// Basics 09 - The shortest pattern will always stop the whole Pbind

Pbind(
	\instrument, \sine,
	\freq, Pwhite(100, 250, 14),
	\amp, Pexprand(0.2, 1.0, 8), // we will only hear 8 notes since this one will stop it
	\dur, 0.1
).play

)
