////////////////////////////////////////////////////////////////
//
//              What a procedure buys you
//
////////////////////////////////////////////////////////////////

/* Four short examples for the first class. The point is not the
   language: it is that each line describes a rule, and the rule
   produces material nobody wrote out by hand. Nothing chaotic
   here: chaos has its own class at 14. */

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// An instrument ////////////////////////

(

SynthDef(\sine, {
	|out=0, amp=0.1, freq=440, rel=0.2, pan=0|
	var env, sig;
	env = EnvGen.kr(Env.perc(rel:rel), doneAction:2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

)


//////////////////////// Written by hand ///////////////////////

// Three notes, stated one at a time. You decided every value.

Pbind(\instrument, \sine, \dur, 0.2, \midinote, Pseq([60,62,65], inf)).play


/////////////////////// Written as a rule //////////////////////

// A range instead of a list. Same instrument, and now you have
// decided the boundaries rather than the notes.

Pbind(\instrument, \sine, \dur, 0.2, \freq, Pwhite(400,600)).play


// A random walk: each value stays near the one before it, so the
// line wanders rather than jumps. Step size is the whole character.
// (the exercise brief in 23 - Recap sets this range and step)

Pbind(\instrument, \sine, \dur, 0.1, \midinote, Pbrown(36, 84, 4, inf)).play


// The same walk with a small step, then a large one. Listen to the
// difference between the two before reading anything into it.

Pbind(\instrument, \sine, \dur, 0.1, \midinote, Pbrown(36, 84, 1, inf)).play

Pbind(\instrument, \sine, \dur, 0.1, \midinote, Pbrown(36, 84, 12, inf)).play


//////////////////////// A hundred events //////////////////////

// One line, a hundred events, none of them typed out. This is the
// whole argument of the course in a single expression.

Pbind(\instrument, \sine, \dur, 0.05, \freq, Pwhite(200, 2000), \amp, Pwhite(0.02, 0.1)).play


// Stop everything

CmdPeriod.run


//////////////////// Six ways to choose /////////////////////

/* Koenig's selection principles from Project 2, each as one line over the
   same instrument. The list of values never changes; only the way a value
   is picked from it. Class 07 is built on these. */

// Sequence: in order, forever
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pseq([60,63,67,70], inf)).play

// Alea: any value in a range, no memory
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pwhite(60, 72)).play

// Series: every value once before any repeats
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pshuf([60,63,67,70], inf)).play

// Ratio: weighted, so some values are likelier than others
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pwrand([60,63,67,70], [0.6,0.2,0.1,0.1], inf)).play

// Group: a value, repeated a few times, then the next
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pdup(Pwhite(2,5), Pwhite(60,72))).play

// Tendency: random inside boundaries that themselves move
(
Pbind(\instrument, \sine, \dur, 0.1,
	\midinote, Pwhite(Pseg([36, 60], [10], \lin), Pseg([84, 66], [10], \lin))
).play
)


//////////////////// One equation, iterated /////////////////

/* The logistic map. x(n+1) = r * x(n) * (1 - x(n)). One line, and the
   value of r decides whether it settles, cycles or never repeats.
   Class 14 is built on this. */

(
~logistic = { |r = 3.9, x = 0.5, n = 32|
	n.collect { x = r * x * (1 - x) }
};
)

// one r per line: settles, then two values, then four, then never repeats
(
[2.8, 3.2, 3.5, 3.9].do { |r|
	("r = " ++ r ++ "  " ++ ~logistic.value(r).round(0.001).keep(-6)).postln;
};
)

// the same numbers as pitch
(
Pbind(\instrument, \sine, \dur, 0.08,
	\midinote, Pseq(~logistic.value(3.9, 0.5, 200).linlin(0, 1, 48, 84), inf)
).play
)


//////////////////// What the analyser reports //////////////

/* Three numbers a machine can offer about a sound, and the point is what
   they leave out. Class 18 is built on this. */

(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
)

(
{
	var snd = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
	var amp = Amplitude.kr(snd);
	var freq = Pitch.kr(snd)[0];
	var centroid = SpecCentroid.kr(FFT(LocalBuf(2048), snd));
	[amp, freq, centroid].poll(2, ["amp", "freq", "centroid"]);
	snd * 0.5 ! 2
}.play
)

/* Now stop the sound and watch the numbers. Amplitude falls to zero,
   but Pitch holds whatever it last found and Loudness never reaches it:
   a listening machine that looks healthy and is hearing nothing. */
