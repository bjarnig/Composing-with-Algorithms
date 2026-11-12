////////////////////////////////////////////////////////////////
//
//                Historical procedures as patterns
//
////////////////////////////////////////////////////////////////

Each section rebuilds one historical procedure with patterns. The rule is the
historical one and the material is chosen here. Patterns.scd has the pattern
techniques from last year, Reference.scd a short example of every pattern
and array method used here, and Solutions.scd answers the exercises.
Evaluate the SynthDefs first, then any block on its own.

StageLimiter.activate


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\pluck, {
	|out=0,pan=0,freq=440,amp=0.2,atk=0.005,rel=1.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = SinOsc.ar(freq * [1, 2, 3], 0, [1, 0.3, 0.12]).sum;
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\pad, {
	|out=0,pan=0,freq=440,amp=0.15,atk=1.5,sustain=3,rel=3|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sustain, rel, 1, \sin), doneAction:2);
	sig = SinOsc.ar(freq * [1, 1.003, 2], 0, [0.5, 0.5, 0.15]).sum;
	Out.ar(out, Pan2.ar(LPF.ar(sig, 2400) * env, pan, amp));
}).add;

SynthDef(\drawn, {
	|out=0,freq=220,amp=0.2,lop=1200,gate=1|
	var sig, env;
	env = EnvGen.ar(Env.asr(0.5, 1, 2), gate, doneAction:2);
	sig = Saw.ar(freq.lag(0.1) * [1, 1.005]).sum * 0.5;
	sig = BLowPass4.ar(sig, lop.lag(0.1).clip(80, 12000), 0.4);
	Out.ar(out, Pan2.ar(sig * env, 0, amp));
}).add;

)


////////////////////////// Tables ///////////////////////////


/* Guido d'Arezzo, around 1026. The five vowels are laid along the notes of the
gamut in turn (a, e, i, o, u, a, e ...), so each vowel owns every fifth note.
The text decides the vowel, and the composer chooses among its notes. Here
Prand makes that choice. */

(

var table, text;

table = (
	a: Prand([55, 64, 72, 81], 1),
	e: Prand([57, 65, 74], 1),
	i: Prand([59, 67, 76], 1),
	o: Prand([60, 69, 77], 1),
	u: Prand([62, 71, 79], 1)
);

// Ut queant laxis resonare fibris, one vowel per syllable
text = [\u, \e, \a, \a, \i, \e, \o, \a, \e, \i, \i];

Pbind(
	\instrument, \pluck,
	\midinote, Pdict(table, Pseq(text, 4)), // look up each vowel in the table
	\dur, Pseq([Pseq([0.4], 10), 1.2], inf)
).play

)


/* Any text: select keeps only the vowels of the string, and each vowel is
turned into a symbol so it can be looked up in the table. */

(

var table, text;

table = (
	a: Prand([55, 64, 72, 81], 1),
	e: Prand([57, 65, 74], 1),
	i: Prand([59, 67, 76], 1),
	o: Prand([60, 69, 77], 1),
	u: Prand([62, 71, 79], 1)
);

text = "Sonology has an interesting one year course".toLower.select { |c| c.isVowel };
text = text.as(Array).collect { |c| c.asSymbol };
text.postln;

Pbind(\instrument, \pluck, \midinote, Pdict(table, Pseq(text, 2)), \dur, 0.2).play

)


/* Mozart's dice game, 1787, in a small version. Eleven measures are written in
advance for the tonic chord, and eleven for the dominant. For every bar, two dice
choose one of them, and Pswitch plays it. */

(

var tonic, dominant, dice;

// eleven measures over the tonic chord (C E G), one for each sum from 2 to 12
tonic = [
	Pseq([0, 2, 4]), Pseq([4, 2, 0]), Pseq([7, 4, 2]), Pseq([2, 4, 7]),
	Pseq([0, 4, 2]), Pseq([4, 7, 4]), Pseq([2, 0, 2]), Pseq([7, 7, 4]),
	Pseq([0, 0, 4]), Pseq([4, 2, 4]), Pseq([2, 7, 0])
];

// eleven measures over the dominant chord (G B D)
dominant = [
	Pseq([4, 6, 8]), Pseq([8, 6, 4]), Pseq([1, 4, 6]), Pseq([6, 4, 1]),
	Pseq([4, 8, 6]), Pseq([6, 6, 4]), Pseq([1, 1, 4]), Pseq([8, 4, 6]),
	Pseq([4, 1, 6]), Pseq([6, 8, 8]), Pseq([1, 6, 4])
];

// one throw of two dice gives 2 to 12; minus 2 gives a place in the list, 0 to 10
dice = Pwhite(1, 6, 1) + Pwhite(1, 6, 1) - 2;

// eight bars, played twice, with a new throw of the dice for every bar
Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		Pswitch(tonic, dice), Pswitch(dominant, dice),
		Pswitch(tonic, dice), Pswitch(dominant, dice),
		Pswitch(tonic, dice), Pswitch(dominant, dice),
		Pswitch(dominant, dice), Pswitch(tonic, dice)
	], 2),
	\dur, 0.4
).play

)


/* The whole game: sixteen bars, each with its own chord, and the measures
made by a function, with a rhythm as well as notes. */

(

var tonic, second, fourth, fifth, chords, makeMeasure, bank, dice;

thisThread.randSeed = 1787;  // the same bank of measures every time

// the triads on the first, second, fourth and fifth degree of the scale
tonic = [0, 2, 4]; second = [1, 3, 5]; fourth = [3, 5, 7]; fifth = [4, 6, 8];

// the harmony of the sixteen bars: I V I IV I V V I V II V V I IV V I
chords = [tonic, fifth, tonic, fourth, tonic, fifth, fifth, tonic,
	fifth, second, fifth, fifth, tonic, fourth, fifth, tonic];

// one measure: a rhythm, and a note of the chord for each note of the rhythm
makeMeasure = { |chord|
	var rhythm = [[1, 1, 1], [0.5, 0.5, 1, 1], [2, 1], [1, 0.5, 0.5, 1]].choose;
	var notes = Array.fill(rhythm.size, { chord.choose + 7 });
	Pbind(\instrument, \pluck, \degree, Pseq(notes), \dur, Pseq(rhythm), \amp, 0.2)
};

// eleven measures for every bar, written before the game starts
bank = chords.collect { |chord| Array.fill(11, { makeMeasure.value(chord) }) };

// two dice give 2 to 12, and the measures are numbered 0 to 10
dice = Pwhite(1, 6, 1) + Pwhite(1, 6, 1) - 2;

Pseq(bank.collect { |measures| Pswitch(measures, dice) }).play(TempoClock(2.4))

)


////////////////////////// Series ///////////////////////////


/* The matrix of Boulez's Structures Ia, 1951. The row is numbered 1 to 12 in
its own order: Eb is 1, D is 2 ... B is 12. Every line of the matrix is the row
transposed, written in those numbers. A phrase reads one line for pitch, one
column for duration, and one number of the diagonal for its dynamic. */

(

~matrix = [
	[ 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12],
	[ 7,  1, 10,  3,  4,  5, 11,  2,  8, 12,  6,  9],
	[ 3,  4,  1,  2,  8,  9, 10,  5,  6,  7, 12, 11],
	[10,  3,  7,  1,  2,  8, 12,  4,  5, 11,  9,  6],
	[12, 10, 11,  7,  1,  2,  9,  3,  4,  6,  8,  5],
	[ 9, 12,  6, 11,  7,  1,  8, 10,  3,  5,  2,  4],
	[ 2,  8,  4,  5,  6, 11,  1,  9, 12,  3,  7, 10],
	[11,  7, 12, 10,  3,  4,  6,  1,  2,  9,  5,  8],
	[ 6, 11,  9, 12, 10,  3,  5,  7,  1,  8,  4,  2],
	[ 4,  5,  2,  8,  9, 12,  3,  6, 11,  1, 10,  7],
	[ 8,  9,  5,  6, 11,  7,  2, 12, 10,  4,  1,  3],
	[ 5,  6,  8,  9, 12, 10,  4, 11,  7,  2,  3,  1]
];

~pitches = [63, 62, 69, 68, 67, 66, 64, 61, 60, 70, 65, 71];    // Eb D A Ab G F# E C# C Bb F B
~dynamics = [0.02, 0.03, 0.05, 0.07, 0.09, 0.12, 0.15, 0.18, 0.22, 0.26, 0.3, 0.35];   // pppp to ffff
~diagonal = [12, 6, 7, 5, 3, 8, 11, 3, 12, 2, 9, 5];           // from the top right corner down

)

(

// piano 1 reads the lines for pitch and the columns for duration, piano 2 the reverse.
// .flat joins the lines into one list, .flop turns the columns into lines.
// The numbers start at 1 and arrays at 0, so 1 is subtracted before Pindex.
Ppar([
	Pbind(
		\instrument, \pluck,
		\midinote, Pindex(~pitches, Pseq(~matrix.flat) - 1) + Prand([-12, 0, 12], inf),
		\dur, Pseq(~matrix.flop.flat) / 8,
		\amp, Pindex(~dynamics, Pdup(12, Pseq(~diagonal)) - 1)
	),
	Pbind(
		\instrument, \pluck,
		\midinote, Pindex(~pitches, Pseq(~matrix.flop.flat) - 1) + Prand([-24, -12, 0], inf),
		\dur, Pseq(~matrix.flat) / 8,
		\amp, Pindex(~dynamics, Pdup(12, Pseq(~diagonal.reverse)) - 1),
		\pan, 0.5
	)
]).play(TempoClock(1.5))

)


/* For later: the matrix can be computed from the row instead of written out.
The first column is the row upside down, and every line is the row transposed
to start on the note in that column. */

(

var row, inverted, computed;

row = [3, 2, 9, 8, 7, 6, 4, 1, 0, 10, 5, 11]; // Eb D A Ab G F# E C# C Bb F B, as pitch classes
inverted = row.collect { |p| (2 * row[0] - p) % 12 };
computed = inverted.collect { |start|
	row.collect { |p| row.indexOf((p - row[0] + start) % 12) + 1 }
};

(computed == ~matrix).postln;                           // true

)


/* Pierre Barbaud and exhaustive permutation. Seven notes can be ordered in
7! = 5040 ways, and the process plays every ordering in turn, with no
intervention. permute(n) returns ordering number n. At this speed the whole
piece lasts 47 minutes. */

[0, 1, 2].permute(0)     // [0, 1, 2]
[0, 1, 2].permute(1)     // [1, 0, 2]
[0, 1, 2].permute(2)     // [2, 1, 0]

(

var notes, orderings;

notes = [0, 1, 2, 4, 5, 7, 9];
orderings = Array.fill(5040, { |n| notes.permute(n) });     // every ordering, one after another

Pbind(
	\instrument, \pluck,
	\degree, Pseq(orderings.flat).trace,
	\dur, Pseq([0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.14], inf),
	\amp, Pseq([0.25, 0.12, 0.12, 0.12, 0.12, 0.12, 0.12], inf),
	\rel, 0.4
).play

)


////////////////////////// Generate and Test ///////////////////////////


/* Lejaren Hiller and the Illiac Suite, 1957. A random note is proposed and a
set of rules accepts or rejects it. The notes are scale degrees from 0 to 7,
C to C. ~accept tests a note, and remembers it when every rule allows it. */

(

~last = 0;            // the last accepted note
~leapt = false;       // whether the last accepted note was reached by a leap

~accept = { |note|
	var step = (note - ~last).abs;
	var ok = true;

	if(step == 0) { ok = false };                             // no repeated note
	if(step > 4) { ok = false };                              // no leap larger than a fifth
	if(~leapt and: { step != 1 }) { ok = false };             // a leap is followed by a step
	if((note == 3 and: { ~last == 6 }) or: { note == 6 and: { ~last == 3 } }) {
		ok = false                                            // no tritone, F to B
	};

	if(ok) { ~leapt = step > 2; ~last = note };
	ok
};

)


/* Every proposal is played: the accepted ones loud, the rejected ones almost
silent, so the filtering can be heard as well as the melody. */

(

Pbind(
	\instrument, \pluck,
	\degree, Pwhite(0, 7),
	\amp, Pfunc { |event| if(~accept.value(event[\degree])) { 0.25 } { 0.015 } },
	\dur, 0.15
).play

)


/* Only the accepted notes: select keeps the proposals that ~accept allows. */

(

Pbind(
	\instrument, \pluck,
	\degree, Pwhite(0, 7).select(~accept),
	\dur, 0.25
).play

)


////////////////////////// Chance ///////////////////////////


/* John Cage, Music of Changes, 1951. Each parameter has a chart of 64 cells, one
per I Ching hexagram, and half of the cells in the sound chart are silences.
Six coin-thrown lines read as a binary number give 0 to 63, so the I Ching is
Pwhite(0, 63). */

(

var sounds, durs, dyns;

thisThread.randSeed = 1951;          // the same charts every time

// even cells are silences, odd cells a note
sounds = Array.fill(64, { |i| if(i.even) { Rest() } { rrand(36, 96) } });
durs = Array.fill(64, { [0.125, 0.25, 0.375, 0.5, 0.75, 1, 1.5, 2].choose });
dyns = Array.fill(64, { [0.03, 0.06, 0.1, 0.16, 0.25].choose });

// a separate throw for every chart
Pbind(
	\instrument, \pluck,
	\midinote, Pindex(sounds, Pwhite(0, 63), inf),
	\dur, Pindex(durs, Pwhite(0, 63), inf),
	\amp, Pindex(dyns, Pwhite(0, 63), inf),
	\rel, Pkey(\dur) * 2
).play

)


////////////////////////// Time ///////////////////////////


/* Conlon Nancarrow, tempo canon. One melody in two voices whose tempi stand in
an irrational ratio, 1 to the square root of 2, so the voices never line up
again. \stretch scales every duration of a voice. */

(

var melody = Pbind(
	\instrument, \pluck,
	\degree, Pseq([0, 2, 4, 7, 9, 7, 4, 2, 5, 4, 2, -1], 4),
	\dur, Pseq([0.25, 0.25, 0.5], inf)
);

Ppar([
	Pbindf(melody, \octave, 5, \pan, -0.5),
	Pbindf(melody, \octave, 4, \stretch, 2.sqrt.reciprocal, \pan, 0.5)
]).play

)


/* A convergence canon. The faster voice starts later and both arrive at the
last note together. The last note begins after 31 beats, so the voice at 3/4
of the speed enters a quarter of that later, after 7.75 beats. */

(

var melody = Pbind(
	\instrument, \pluck,
	\degree, Pseq([0, 2, 4, 7, 9, 7, 4, 2, 5, 4, 2, -1], 4),
	\dur, Pseq([0.5, 0.5, 1], inf)
);

Ptpar([
	0, Pbindf(melody, \octave, 5),
	7.75, Pbindf(melody, \octave, 4, \stretch, 0.75)
]).play

)


/* Brian Eno, Music for Airports, 1978. Each note is its own loop, and the loop
lengths share no common measure, so the combinations keep changing. Ptpar
starts each loop at its own time. Durations are in seconds at the default
tempo of one beat per second. */

(

Ptpar([
	0.0,  Pbind(\instrument, \pad, \midinote, 65, \dur, 17.8, \sustain, 3),
	2.3,  Pbind(\instrument, \pad, \midinote, 68, \dur, 20.1, \sustain, 3),
	4.6,  Pbind(\instrument, \pad, \midinote, 72, \dur, 23.5, \sustain, 3),
	6.9,  Pbind(\instrument, \pad, \midinote, 73, \dur, 25.9, \sustain, 3),
	9.2,  Pbind(\instrument, \pad, \midinote, 75, \dur, 29.9, \sustain, 3),
	11.5, Pbind(\instrument, \pad, \midinote, 77, \dur, 31.8, \sustain, 3),
	13.8, Pbind(\instrument, \pad, \midinote, 80, \dur, 19.6, \sustain, 3)
]).play

)


////////////////////////// Sound ///////////////////////////


/* Daphne Oram, Oramics. A drawn curve controls a continuous sound, and Pseg is a
drawn curve: breakpoints, durations and a shape. Pmono keeps one synth running
and the curves steer it. */

(

Pmono(
	\drawn,
	\midinote, Pseg(Pseq([40, 52, 47, 59, 43], inf), Pseq([4, 2, 6, 3, 5], inf), \sin),
	\lop, Pseg(Pseq([300, 4000, 800, 2500], inf), Pseq([3, 5, 2, 6], inf), \exp),
	\amp, Pseg(Pseq([0.05, 0.25, 0.1, 0.2], inf), Pseq([2, 3, 4, 3], inf), \lin),
	\dur, 0.05
).play

)
