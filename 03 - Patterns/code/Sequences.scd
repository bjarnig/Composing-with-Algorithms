////////////////////////////////////////////////////////////////
//
//              Five sequences a composer follows
//
////////////////////////////////////////////////////////////////

/* Patterns.scd is the catalogue. This file is five working sessions instead:
   each one is a series of small edits with a listen after every one, so the
   question is always what changed rather than what the class is called.

   The SynthDefs come from SynthDefs.scd. Run that file first.
   Cmd+. stops everything. */

s.boot;


//////////////// 1. From a note to a phrase ////////////////

/* One Pbind, and only the value source changes. Same synth, same durations. */

Pbind(\instrument, \sine, \freq, 400, \dur, 0.25, \amp, 0.1).play;          // one note

Pbind(\instrument, \sine, \freq, Pseq([300, 400, 500, 600], inf),
	\dur, 0.25, \amp, 0.1).play;                                           // a sequence

Pbind(\instrument, \sine, \freq, Prand([300, 400, 500, 600], inf),
	\dur, 0.25, \amp, 0.1).play;                                           // a choice

Pbind(\instrument, \sine, \freq, Pwhite(300, 600),
	\dur, 0.25, \amp, 0.1).play;                                           // a range

/* Sequence, choice and range are three stances towards the same four numbers.
   Nothing technical separates them. */


//////////////// 2. From phrase to section ////////////////

// hold it under a name so it can be replaced while it sounds
Pdef(\a, Pbind(\instrument, \sine, \freq, Pseq([300, 400, 500], inf),
	\dur, 0.25, \amp, 0.1)).play;

// evaluate this with the first still going: the next event comes from the new one
Pdef(\a, Pbind(\instrument, \sine, \freq, Pexprand(200, 2000),
	\dur, 0.08, \amp, 0.07));

// a finite length, and a repeat count
Pdef(\a, Pn(Pfin(8, Pbind(\instrument, \sine, \freq, Pseq([300, 400, 500, 700], inf),
	\dur, 0.15, \amp, 0.1)), 3)).play;

// a second layer
Pdef(\a, Ppar([
	Pbind(\instrument, \sine,  \freq, Pseq([300, 400, 500], inf), \dur, 0.25, \amp, 0.07),
	Pbind(\instrument, \pluck, \note, Prand([48, 52, 55], inf),   \dur, 0.75, \amp, 0.15)
])).play;

Pdef(\a).stop;


//////////////// 3. From sketch to family ////////////////

/* Put the Pbind in a function and the piece becomes a space of pieces. */

(
~phrase = { |scale = #[0, 2, 4, 7, 9], tempo = 0.2, density = 1|
	Pbind(\degree, Prand(scale, inf), \dur, tempo / density, \amp, 0.08)
};
)

~phrase.value.play;
~phrase.value(#[0, 1, 5, 6, 10], 0.3, 2).play;
~phrase.value(#[0, 3, 7], 0.5, 4).play;


//////////////// 4. From material to selection ////////////////

/* Generate many, listen, keep few. This is the working method of class 07,
   arriving three weeks early. */

(
~sketch = {
	var scale = #[0, 2, 3, 5, 7, 8, 10].scramble.keep(rrand(3, 5));
	var tempo = [0.1, 0.15, 0.2, 0.3].choose;
	[scale, tempo].postln;                 // so the good ones can be written down
	Pfin(12, Pbind(\degree, Prand(scale, inf), \dur, tempo, \amp, 0.09));
};
)

~sketch.value.play;      // run this twenty times and keep three

// then fix the three you kept, by pasting the numbers back in
Pbind(\degree, Prand(#[0, 5, 7], inf), \dur, 0.15, \amp, 0.09).play;


//////////////// 5. Swap one side, keep the other ////////////////

// two scores over one instrument
Pbind(\instrument, \sine, \freq, Pseq([300, 400, 500], inf), \dur, 0.3, \amp, 0.1).play;
Pbind(\instrument, \sine, \freq, Pexprand(200, 2000), \dur, 0.08, \amp, 0.06).play;

// two instruments under one score
Pbind(\instrument, Prand([\sine, \pluck], inf),
	\freq, 440, \note, Prand([48, 55], inf), \dur, 0.4, \amp, 0.1).play;

/* The score did not change in the last example and the instrument did not change
   in the first two. That boundary is the subject of classes 08 and 27. */


//////////////// One key derived from another ////////////////

/* Pkey reads a value already computed for this event, so a relationship can be
   written down rather than typed out. Here high notes are short. */

Pbind(\instrument, \sine,
	\freq, Pexprand(200, 2000),
	\dur, Pkey(\freq).explin(200, 2000, 0.4, 0.05),
	\amp, 0.1).play;


CmdPeriod.run;
