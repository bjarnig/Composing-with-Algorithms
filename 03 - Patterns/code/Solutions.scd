////////////////////////////////////////////////////////////////
//
//               Exercises, worked solutions
//
////////////////////////////////////////////////////////////////

Run SynthDefs.scd first. One answer each, not the only answer.
Cmd+period stops everything.

s.boot;


///////////////////////////// 1 ////////////////////////////////

(
Pbind(
	\instrument, \sine,
	\dur,  Pseq([0.1, 0.2, 0.4, 0.15], inf),
	\freq, Pseq([220, 330, 440, 550], inf),
	\amp,  0.1
).play;
)


///////////////////////////// 2 ////////////////////////////////

(
Pbind(
	\instrument, \sine,
	\dur,  Pwhite(0.05, 0.4),
	\freq, Pexprand(150, 2000),
	\amp,  Pwhite(0.03, 0.12)
).play;
)


///////////////////////////// 3 ////////////////////////////////

(
Pbind(
	\instrument, \sine,
	\dur,  0.1,
	\freq, Pseg([200, 1800], [8], \exp),
	\amp,  Pseg([0.15, 0.01], [8], \lin)
).play;
)


///////////////////////////// 4 ////////////////////////////////

(
Pseq([
	Pbind(\instrument, \sine,  \degree, Pseq([0, 2, 4, 7], 4), \dur, 0.2,  \amp, 0.1),
	Pbind(\instrument, \pluck, \note,   Prand([48, 55, 60], 8), \dur, 0.4, \amp, 0.2)
], 1).play;
)


///////////////////////////// 5 ////////////////////////////////

~notes = [0, 2, 4, 7, 9];

Pbind(\instrument, \sine, \degree, Pseq(~notes, inf),   \dur, 0.2, \amp, 0.1).play;
Pbind(\instrument, \sine, \degree, Prand(~notes, inf),  \dur, 0.2, \amp, 0.1).play;
Pbind(\instrument, \sine, \degree, Pxrand(~notes, inf), \dur, 0.2, \amp, 0.1).play;
Pbind(\instrument, \sine, \degree, Pshuf(~notes, inf),  \dur, 0.2, \amp, 0.1).play;

// Pseq for a bass line: it is the only one that gives the same order every
// time, and a bass line has to be recognisable from one bar to the next.


///////////////////////////// 6 ////////////////////////////////

Pbind(\instrument, \sine, \freq, Pwhite(100, 3000),   \dur, 0.08, \amp, 0.08).play;
Pbind(\instrument, \sine, \freq, Pexprand(100, 3000), \dur, 0.08, \amp, 0.08).play;

// Pwhite is even in hertz, so almost everything lands in the top octaves;
// Pexprand is even in octaves, so the low register is heard as often as the high.


///////////////////////////// 7 ////////////////////////////////

(
Pbind(
	\instrument, \sine,
	\freq, Pexprand(150, 1600),
	\dur,  60 / Pkey(\freq),
	\amp,  0.1
).play;
)


///////////////////////////// 8 ////////////////////////////////

(
Pdef(\phrase, Pbind(
	\instrument, \sine, \degree, Pseq([0, 2, 4, 7], inf), \dur, 0.2, \amp, 0.1
)).quant_(4).play;
)

// evaluate while the first one is still sounding
(
Pdef(\phrase, Pbind(
	\instrument, \sine, \degree, Pseq([0, 3, 5, 10], inf), \dur, 0.2, \amp, 0.1
));
)

Pdef(\phrase).stop;


///////////////////////////// 9 ////////////////////////////////

(
~phrase = { |notes, dur, reps|
	Pbind(\instrument, \sine, \degree, Pseq(notes, reps), \dur, dur, \amp, 0.1)
};
)

~phrase.(#[0, 2, 4, 7], 0.2, 4).play;
~phrase.(#[0, 1, 5, 6, 10], 0.3, 2).play;
~phrase.(#[0, 3, 7], 0.5, 4).play;


//////////////////////////// 10 ////////////////////////////////

(
Ppar([
	Pbind(\instrument, \sine, \degree, Pseq([0, 4, 7, 11], inf), \dur, 0.25, \amp, 0.12),
	Pbind(\instrument, \sine, \degree, Pwhite(-14, -7),          \dur, 2.0,  \amp, 0.03)
], 1).play;
)

// The foreground is faster, louder, higher and repeats an order you can follow.
// The background is slower, quieter, lower and never repeats.
