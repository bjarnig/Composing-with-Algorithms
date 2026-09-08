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
