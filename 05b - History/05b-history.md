---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 05b Algorithmic Composition
titleTemplate: '%s'
layout: default
class: title
transition: slide-left
colorSchema: dark
favicon: /favicon.ico
mdc: true
---

<div class="logos">
  <img src="/figures/logo-001.png" alt="Institute of Sonology" />
  <img src="/figures/logo-002.png" alt="Royal Conservatoire The Hague" />
</div>

<div class="deck-title">Algorithmic Composition</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---
layout: center
class: divider
---

Algorithm

---

# Algorithm

A set of well-defined steps for solving a particular problem. The term is derived from the name of the Persian mathematician **Muhammad ibn Musa al-Khwarizmi**.

An algorithm proceeds from an **initial state** and executes the operations defined for each step until none is left and an **output** has been made.

In composition an algorithm is a mediation between an idea and its realisation, and a way of exploring ideas that could not be reached by hand.

---
class: light
---

# Boundaries of Imagination

> "If the composers would have to program each of their ideas for a computer system, they would have to define as accurately as possible what they are looking for. It is to be expected that the computer system will respond with far greater a quantity of propositions answering the definition than the composer's mind alone is either conscious of, or able to imagine. At the same time, it would provide for an exact, step-by-step record of all the proceedings between initial definition and final choice. The composer's choice from the computer's propositions would still remain a highly personal decision, but would be taken in a field which is not limited by the prejudicial boundaries of the choosing person's imagination."

<div class="src">(Herbert Brün)</div>

---
layout: center
class: divider
---

Tables

---

# Guido d'Arezzo

In the *Micrologus*, around **1026**, Guido describes a method for making a melody from a text.

The five vowels are laid along the gamut in turn, so each vowel points at three or four pitches. The text decides the vowel, and the composer chooses among its pitches.

The method is a **lookup table**, and it is the oldest data structure in this history.

---
class: light
---

# Vowel Table

<div class="shot"><img src="/figures/guido-000.svg" /></div>

---

# Vowel Table

<AudioEmbed src="/demos/guido/" height="23rem" label="the vowel table, interactive" />

---

# Vowel Table

The table lists the notes each vowel may be sung on. `Pdict` looks up each vowel of the text, and `Prand` chooses one of its notes.

```supercollider
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
	\midinote, Pdict(table, Pseq(text, 4)),
	\dur, Pseq([Pseq([0.4], 10), 1.2], inf)
).play
```

---

# Mozart

The *Musikalisches Würfelspiel*, a musical dice game attributed to Mozart (**1787**), assembles a minuet from pre-composed measures.

Each of the sixteen bars has eleven alternatives written in advance. Two dice are thrown for each bar, and the sum selects the measure from a **table of rules**.

Nothing is composed at the moment of playing. The dice only choose among outcomes that already exist.

---
class: light
---

# Mozart

<div class="shot"><img src="/figures/mozart-table-000.png" /></div>
<div class="src">(table of rules used to select specific measures given a certain dice roll)</div>

---
class: light
---

# Two Dice

<div class="shot"><img src="/figures/dice-000.svg" /></div>

---

# Musikalisches Würfelspiel

<AudioEmbed src="/demos/wurfel/" height="23rem" label="the dice game, interactive" />

---

# Musikalisches Würfelspiel

Eleven measures are written for each chord. For every bar, two dice choose one of them, and `Pswitch` plays it.

```supercollider
var tonic, dominant, dice;

tonic = [
	Pseq([0, 2, 4]), Pseq([4, 2, 0]), Pseq([7, 4, 2]), Pseq([2, 4, 7]),
	Pseq([0, 4, 2]), Pseq([4, 7, 4]), Pseq([2, 0, 2]), Pseq([7, 7, 4]),
	Pseq([0, 0, 4]), Pseq([4, 2, 4]), Pseq([2, 7, 0])
];
dominant = [ /* eleven measures over G B D */ ];

dice = Pwhite(1, 6, 1) + Pwhite(1, 6, 1) - 2;      // 2 to 12 becomes 0 to 10

Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		Pswitch(tonic, dice), Pswitch(dominant, dice),
		Pswitch(tonic, dice), Pswitch(dominant, dice)
	], 4),
	\dur, 0.4
).play
```

---
layout: center
class: divider
---

Series

---

# Serialism

After the Second World War several composers extended the serial technique of **Arnold Schönberg** from pitch to **duration**, **dynamics** and **articulation**.

**Pierre Boulez** wrote *Structures Ia* for two pianos in **1951**. One row of twelve pitches, numbered in its own order, generates the material for every parameter.

The row comes from **Olivier Messiaen**'s *Mode de valeurs et d'intensités* (**1949**), where each pitch has its own fixed duration, dynamic and attack. Boulez keeps Messiaen's twelve pitches in their order and turns every parameter into a scale of twelve degrees, read in the order of the row.

---
class: light
---

# Structures Ia

> "I wanted to eradicate from my vocabulary absolutely every trace of the conventional, whether it concerned figures and phrases, or development and form; I then wanted gradually, element after element, to win back the various stages of the compositional process, in such a manner that a perfectly new synthesis might arise, a synthesis that would not be corrupted from the very outset by foreign bodies, stylistic reminiscences in particular."

<div class="src">(Boulez, 1986)</div>

---
class: light
---

# Structures 1a

<div class="shot"><img src="/figures/matrix-000.svg" /></div>

---
class: light
---

# Reading the Matrix

<div class="shot"><img src="/figures/matrix-reading-000.svg" /></div>

---

# The Matrix

`~matrix` holds the twelve lines, written out in History.scd. Piano 1 reads the lines for pitch, the columns for duration in 32nd notes, and the diagonal for the dynamic of each phrase.

```supercollider
~pitches = [63, 62, 69, 68, 67, 66, 64, 61, 60, 70, 65, 71];    // Eb D A Ab G F# E C# C Bb F B
~dynamics = [0.02, 0.03, 0.05, 0.07, 0.09, 0.12, 0.15, 0.18, 0.22, 0.26, 0.3, 0.35];
~diagonal = [12, 6, 7, 5, 3, 8, 11, 3, 12, 2, 9, 5];

// numbers start at 1 and arrays at 0, so 1 is subtracted before Pindex
Pbind(
	\instrument, \pluck,
	\midinote, Pindex(~pitches, Pseq(~matrix.flat) - 1),        // the lines
	\dur, Pseq(~matrix.flop.flat) / 8,                          // the columns
	\amp, Pindex(~dynamics, Pdup(12, Pseq(~diagonal)) - 1)      // one per phrase
).play
```

---

# Pierre Barbaud

Founded the **Groupe de Musique Algorithmique de Paris**. Its collective *Factorielle 7* is one of the first computer-generated scores, named after 7!, the number of ways to order seven elements.

Barbaud sets in motion a musical process which runs its course **without intervention**. If the result is found aesthetically insufficient, the composer must adjust the controls of the generative algorithm and then let it run again.

---
class: light
---

# Permutations

<div class="shot"><img src="/figures/permutations-000.svg" /></div>

---

# Permutations

`permute(i)` returns the i-th ordering of an array, so the stream visits all 5040 in turn. At this speed the piece lasts 47 minutes.

```supercollider
var set = [0, 1, 2, 4, 5, 7, 9];

Pbind(
	\instrument, \pluck,
	\degree, Pseq(Array.fill(5040, { |i| set.permute(i) }).flat),
	\dur, Pseq([Pseq([0.07], 6), 0.14], inf),
	\amp, Pseq([0.25, Pseq([0.12], 6)], inf),
	\rel, 0.4
).play
```

---
layout: center
class: divider
---

Generate and Test

---

# Lejaren Hiller

Trained as a chemist, Hiller realised the first computer-generated composition, the *Illiac Suite* for string quartet (**1956-1957**), with Leonard Isaacson at the University of Illinois.

His algorithms used **random numbers tested by rules**. A random number proposes a note, rules derived from counterpoint accept or reject it, and the accepted notes are transcribed into a score for human players.

---
class: light
---

# Lejaren Hiller

> "Music is . . . governed by laws of organization, which permit fairly exact codification. (. . . it has even been claimed that the content of music is nothing other than its organization.) From this proposition, it follows that computer-composed music which is 'meaningful' is conceivable to the extent to which the laws of musical organization are codifiable."

<div class="src">(Hiller, on the Illiac Suite)</div>

---
class: light
---

# Generate and Test

<div class="shot"><img src="/figures/hiller-000.svg" /></div>

---

# Generate and Test

<AudioEmbed src="/demos/hiller/" height="23rem" label="generate and test, interactive" />

---

# Generate and Test

`~accept` tests a proposed note against the four rules, one `if` per rule, and remembers the note when all of them allow it.

```supercollider
~last = 0;            // the last accepted note
~leapt = false;       // whether it was reached by a leap

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
```

---

# Generate and Test

The first Pbind plays every proposal and makes the rejected ones almost silent. The second uses `select` to keep only the accepted notes.

```supercollider
Pbind(
	\instrument, \pluck,
	\degree, Pwhite(0, 7),                    // C to C
	\amp, Pfunc { |event| if(~accept.value(event[\degree])) { 0.25 } { 0.015 } },
	\dur, 0.15
).play

Pbind(
	\instrument, \pluck,
	\degree, Pwhite(0, 7).select(~accept),
	\dur, 0.25
).play
```

With all four rules, about 40 percent of the proposals are kept.

---
layout: center
class: divider
---

Chance

---

# John Cage

Applied **chance procedures** from the *I Ching* to *Music of Changes* (**1951**). Each parameter has a **chart** of 64 cells, one for each hexagram, and half of the cells in the sound charts are silences.

Worked with Hiller on *HPSCHD* (**1967-69**) for seven harpsichords, fifty-one tapes of computer generated music and slide projections.

Cage generalized his procedures in 1982 into computer algorithms with **Andrew Culver**, and used them later in his life.

---
class: light
---

# Abundance

> "Formerly, when one worked alone, at a given point a decision was made, and one went in one direction rather than another; whereas, in the case of working with another person and with computer facilities, the need to work as though decisions were scarce, as though you had to limit yourself to one idea, is no longer pressing. It's a change from the influences of scarcity or economy to the influences of abundance and, I'd be willing to say, waste."

<div class="src">(John Cage, interview during the composition of HPSCHD)</div>

---
class: light
---

# Charts

<div class="shot"><img src="/figures/iching-000.svg" /></div>

---

# Charts

Three charts of 64 cells, and a separate cast for each one. `Pindex` reads the cell the cast names, and the even cells of the sound chart are rests.

```supercollider
var sounds, durs, dyns;

thisThread.randSeed = 1951;

sounds = Array.fill(64, { |i| if(i.even) { Rest() } { rrand(36, 96) } });
durs = Array.fill(64, { [0.125, 0.25, 0.375, 0.5, 0.75, 1, 1.5, 2].choose });
dyns = Array.fill(64, { [0.03, 0.06, 0.1, 0.16, 0.25].choose });

Pbind(
	\instrument, \pluck,
	\midinote, Pindex(sounds, Pwhite(0, 63), inf),
	\dur, Pindex(durs, Pwhite(0, 63), inf),
	\amp, Pindex(dyns, Pwhite(0, 63), inf),
	\rel, Pkey(\dur) * 2
).play
```

---
layout: center
class: divider
---

Time

---

# Conlon Nancarrow

Composed directly onto **player piano rolls**, punched by hand, for music often too exact for human players.

Many of the studies are **tempo canons**: one melody in several voices at different tempi. Some use irrational ratios, such as 2 : √2 in Study No. 33.

In a **convergence canon** the voices start apart and meet at a calculated point.

---
class: light
---

# Conlon Nancarrow

<div class="fig tall"><img src="/figures/nancarrow-000.png" /></div>

---
class: light
---

# Tempo Canon

<div class="shot"><img src="/figures/canon-000.svg" /></div>

---

# Tempo Canon

`\stretch` scales every duration of a voice. `Ptpar` starts each voice at its own time.

```supercollider
var melody = Pbind(
	\instrument, \pluck,
	\degree, Pseq([0, 2, 4, 7, 9, 7, 4, 2, 5, 4, 2, -1], 4),
	\dur, Pseq([0.25, 0.25, 0.5], inf) * 2
);

Ptpar([
	0, Pbindf(melody, \octave, 5),
	7.75, Pbindf(melody, \octave, 4, \stretch, 0.75)
]).play
```

For the irrational canon, start both voices together with `Ppar` and give the second one a `\stretch` of `2.sqrt.reciprocal`.

---

# Brian Eno

> "Since I have always preferred making plans to executing them, I have gravitated towards situations and systems that, once set into operation, could create music with little or no intervention on my part. That is to say, I tend towards the roles of planner and programmer, and then become an audience to the results."

*Music for Airports* (**1978**) uses tape loops of different lengths, which cause evolving patterns as they drift out of phase.

---
class: light
---

# Loops

<div class="shot"><img src="/figures/loops-000.svg" /></div>

---

# Loops

<AudioEmbed src="/demos/loops/" height="23rem" label="loops of different lengths, interactive" />

---

# Loops

Each note is one `Pbind` whose duration is the loop length. `Ptpar` starts each loop at its own time.

```supercollider
Ptpar([
	0.0,  Pbind(\instrument, \pad, \midinote, 65, \dur, 17.8, \sustain, 3),
	2.3,  Pbind(\instrument, \pad, \midinote, 68, \dur, 20.1, \sustain, 3),
	4.6,  Pbind(\instrument, \pad, \midinote, 72, \dur, 23.5, \sustain, 3),
	6.9,  Pbind(\instrument, \pad, \midinote, 73, \dur, 25.9, \sustain, 3),
	9.2,  Pbind(\instrument, \pad, \midinote, 75, \dur, 29.9, \sustain, 3),
	11.5, Pbind(\instrument, \pad, \midinote, 77, \dur, 31.8, \sustain, 3),
	13.8, Pbind(\instrument, \pad, \midinote, 80, \dur, 19.6, \sustain, 3)
]).play
```

These seven lengths, in tenths of a second, return to their starting phase after about one and a half million years.

---

# Laurie Spiegel

Worked with the **GROOVE** system at Bell Labs from 1973 to 1978, writing programs that she played in real time.

*Music Mouse* (**1986**) puts the algorithm inside an instrument. The performer moves the mouse, and the program keeps the result within a chosen harmony, scale and rhythm.

Playing becomes a way of moving through conditions the composer has set.

---
layout: center
class: divider
---

Sound

---

# Music N

Max Mathews's **Music N** programs (from **1957**) introduced the **unit generator**: synthesis built by passing a signal through oscillators, envelopes, filters and mixers.

An **instrument** turns the parameters of a note into samples, and a **score** is a list of notes for the instruments.

The note paradigm still dominates computer music, and algorithms in that paradigm write scores.

---
class: light
---

# Notes and Samples

<div class="shot"><img src="/figures/paradigms-000.svg" /></div>

---

# Daphne Oram

Co-founded the BBC Radiophonic Workshop in 1958 and left within about a year to set up her own studio.

Developed **Oramics**: shapes drawn by hand on 35 mm film strips are read **optically** to generate waveform, envelope and pitch.

A drawn control function is an algorithm in the same sense a breakpoint envelope is: a curve that some other process reads and obeys.

---
class: light
---

# Oramics

<div class="shot"><img src="/figures/drawn-000.svg" /></div>

---

# Oramics

`Pseg` is a drawn curve as a pattern. `Pmono` keeps one synth running, and three curves steer its pitch, filter and level.

```supercollider
Pmono(
	\drawn,
	\midinote, Pseg(Pseq([40, 52, 47, 59, 43], inf), Pseq([4, 2, 6, 3, 5], inf), \sin),
	\lop, Pseg(Pseq([300, 4000, 800, 2500], inf), Pseq([3, 5, 2, 6], inf), \exp),
	\amp, Pseg(Pseq([0.05, 0.25, 0.1, 0.2], inf), Pseq([2, 3, 4, 3], inf), \lin),
	\dur, 0.05
).play
```

---

# Composing Sound

The same kind of rule can be applied to the sound itself, at the level of the sample.

- **Herbert Brün**, *SAWDUST* (1976): waveforms built from short segments that are linked, mingled and varied
- **Gottfried Michael Koenig**, *SSP* (1977): the selection principles of Project 1 applied to amplitude values in time
- **Iannis Xenakis**, *GENDYN* (1991): a waveform whose breakpoints follow random walks
- **David Tudor**, *Neural Synthesis* (1990s): a network of electronic neurons that evolves its own sound

---
layout: center
class: divider
---

Exercises

---

# Exercises

1. A process where a synth is played using a **beta distribution** for pitches and a stutter pattern for duration, where each duration occurs four times.
2. A process where pitches vary between **random**, using either a uniform or an exponential distribution, and predefined ones.
3. A process that plays **two synths** at the same time, where each one has a different rhythm pattern and amplitude trajectory.
4. A process that plays **chords of three notes** each, where each note in the chord has a different amplitude set.
5. A process that will generate a random pitch and **repeat it** for a number of times until it generates another one.

---

# Exercises

6. Give **Guido's table** a different text and a different choice rule: the nearest pitch, the highest, or one of your own.
7. Rewrite the **dice game** so that some bars have only one possible measure, whatever the dice say.
8. Read the **Structures matrix** for a fourth parameter, such as pan or release time.
9. Add a rule to **generate and test** and count how many proposals it rejects.
10. Make **Cage charts** for timbre, where each cell names a SynthDef rather than a pitch.
11. Build a piece from **loops** with Ptpar, with lengths chosen so that they realign after exactly two minutes.

<span class="note">Patterns.scd has the techniques for 1 to 5, History.scd the procedures for 6 to 11, and Solutions.scd one answer to each.</span>

<span class="workshop">- workshop -</span>
