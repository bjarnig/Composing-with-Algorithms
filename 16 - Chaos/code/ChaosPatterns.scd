////////////////////////////////////////////////////////////////
//
//                      Chaos Patterns
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


/////////////////////////// SynthDefs //////////////////////////


(

SynthDef(\perc, {|freq=440, amp=0.1|
	var env = EnvGen.ar(Env.perc(0.01, 0.2), 1, doneAction:2) * amp;
	OffsetOut.ar(0, SinOsc.ar(freq, 0, env) ! 2);
}).add;

SynthDef(\percNote, {|note=60, amp=0.1|
	var env = EnvGen.ar(Env.perc(0.01, 0.2), 1, doneAction:2) * amp;
	OffsetOut.ar(0, SinOsc.ar(note.midicps, 0, env) ! 2);
}).add;

)


////////////////////// Plotter Helpers ////////////////////////

(

~plotPattern = {|pattern, count=500|
	var values = pattern.asStream.nextN(count).flatten;
    values.plot(minval: values.minItem.floor,
		maxval: values.maxItem.ceil)
};

)


////////////////////////// Chaos Patterns ///////////////////////////

/* See BhobUGens in SC3 plugins for some chaos patterns, often they
output arrays and normalize to 0-1 by default (turned off by setting
n false) */

~plotPattern.value(Pstandard.new)

~plotPattern.value(Pfhn.new)

~plotPattern.value(Pgbman.new)

~plotPattern.value(Pquad.new(-2.8, 3.8, 0.1, 0.2))

~plotPattern.value(PlinCong.new(1.8,0.1))

~plotPattern.value(Plorenz.new(20, 22))

~plotPattern.value(Platoo.new(7,2, 0.2))

~plotPattern.value(Phenon.new(1.4, 0.2, 0.2, 0.3))


////////////////////////// Pbind Examples ///////////////////////////


( // Standard Map - chaotic melody

Pbind(
	\instrument, \percNote,
	\note, Pstandard(1.5, 4.9, 5.9) * 24 + 48,
	\dur, 0.1,
	\amp, 0.15
).play

)


( // Hénon - two voices with different parameters

Ppar([
	Pbind(
		\instrument, \percNote,
		\note, Phenon(1.4, 0.3, 0.1, 0.1) * 12 + 60,
		\dur, 0.15,
		\amp, 0.1
	),
	Pbind(
		\instrument, \percNote,
		\note, Phenon(1.38, 0.3, 0.2, 0.1) * 12 + 48,
		\dur, 0.2,
		\amp, 0.08
	)
]).play

)


( // FitzHugh-Nagumo - ghost notes

Pbind(
	\instrument, \percNote,
	\note, Pfhn(1, 0.7, 0.8, -0.8, -0.8) * 24 + 36,
	\dur, 0.1,
	\amp, 0.12
).play

)


( // Gingerbreadman - rhythmic chaos

Pbind(
	\instrument, \percNote,
	\note, Pgbman(-0.1, 0) * 6 + 60,
	\dur, Pgbman(0.1, 0.2) * 0.15 + 0.05,
	\amp, 0.15
).play

)


( // Quadratic map - wide pitch range

Pbind(
	\instrument, \percNote,
	\note, Pquad(-2.8, 3.8, 0.1, 0.2) * 36 + 36,
	\dur, 0.12,
	\amp, Pquad(-2.5, 3.5, 0.2, 0.3) * 0.1 + 0.05
).play

)


( // Linear Congruential - pseudo-random

Pbind(
	\instrument, \percNote,
	\note, PlinCong(1.8, 0.1, 0.5, 0.1) * 24 + 48,
	\dur, PlinCong(1.5, 0.2, 0.3, 0.2) * 0.2 + 0.08,
	\amp, 0.12
).play

)


( // Lorenz - smooth chaos (scale to minor)

Pbind(
	\instrument, \percNote,
	\note, Plorenz(10, 28, 2.67, 0.05, 0.1, 0, 1).round * 2 + 48,
	\dur, 0.15,
	\amp, 0.1
).play

)


( // Latoocarfian - wild and unpredictable

Pbind(
	\instrument, \percNote,
	\note, Platoo(1.5, 1.8, 0.5, 1.2, 0.5, 0.5) * 24 + 48,
	\dur, 0.1,
	\amp, Platoo(1.2, 1.5, 0.3, 1.0, 0.2, 0.3) * 0.1 + 0.05
).play

)


( // Combined: chaos controls multiple parameters

Pbind(
	\instrument, \percNote,
	\note, Pstandard(1.2, 0.1, 0.1) * 24 + 48,
	\dur, Phenon(1.35, 0.3, 0.1, 0.2) * 0.2 + 0.05,
	\amp, Pgbman(0.1, 0.1) * 0.1 + 0.05
).play

)


( // Polyrhythmic - three voices

Ppar([
	Pbind(
		\instrument, \percNote,
		\note, Pstandard(1.5, 0.1, 0.1) * 12 + 72,
		\dur, 0.2,
		\amp, 0.08
	),
	Pbind(
		\instrument, \percNote,
		\note, Phenon(1.4, 0.3, 0.2, 0.1) * 12 + 60,
		\dur, 0.25,
		\amp, 0.1
	),
	Pbind(
		\instrument, \percNote,
		\note, Pgbman(0.1, 0.2) * 12 + 36,
		\dur, 0.3,
		\amp, 0.12
	)
]).play

)
