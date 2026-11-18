---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 06 Xenakis and Stochastics
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

<div class="deck-title">Xenakis and Stochastics</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---
class: light
---

# Pithoprakta

<div class="shot"><img src="/figures/pithoprakta-000.png" /></div>

<div class="src">(Pithoprakta, 1955-56, bars 52-59, Xenakis's own graph; Musique. Architecture, 1976)</div>

---
class: light
---

# Change

> "The main thing is: how to change. This is a matter of music, of knowledge, of the universe. Everywhere you feel the changes. The plants are changing, maybe not so fast as the human mind. They're changing slowly, as the particles do. Probably these particles are changing in the universe on a much larger scale of time. We know at least through astrophysics today that some of them are really mid-life, like the heavy ones. They did not exist at the beginning, and the lighter ones did not exist at the very beginning. So if even the matter itself is changing, everything is changing."

<div class="src">(Xenakis, 1986)</div>

---
class: light
---

# Construction

> "In musical composition, construction must stem from originality which can be defined in extreme (perhaps inhuman) cases as the creation of new rules or laws, as far as possible; as far as possible meaning original, not yet known or even forseeable, construct laws therefore from nothing."

<div class="src">(Xenakis, 1992)</div>

---

# Xenakis

Worked for **Le Corbusier** as an engineer and attended composition classes of **Messiaen**.

Composed instrumental pieces using **stochastic laws** and mathematics.

An important influence on the development of electronic and computer music.

---

# Xenakis

Pioneered **granular** and **non-standard** synthesis.

Developed **computer programs** for musical composition.

Catalogue of musical works contains more than **150** pieces.

---
class: light
---

# La Ville Cosmique

<div class="shot"><img src="/figures/ville-cosmique-000.png" /></div>

---
class: light
---

# La Tourette

<div class="shot"><img src="/figures/la-tourette-000.png" /></div>

---
class: light
---

# Metastaseis

<div class="shot"><img src="/figures/metastaseis-000.png" /></div>

<div class="src">(Metastaseis, 1954)</div>

---

# Metastaseis

*Meta*, after or beyond, and *stasis*, immobility: the relationship between movement, or change, and nondirectionality, or standstill.

For the audience at its **1955** premiere in Donaueschingen, it was as if they were hearing "atomic music" from "the first traveller in space".

Introduced the notion of **architectural** or **global sonorities**, where massed glissandi, for example, create a sonic entity that can only be perceived as a whole and not as a product of smaller elements.

Led to a statistical conception of complex sonorities, resulting in what he would eventually call **stochastic** music.

<span class="note">(Harley)</span>

---
class: light
---

# Bohor

<div class="shot"><img src="/figures/bohor-000.png" /></div>

<div class="src">(Bohor, 1962)</div>

---
class: light
---

# Bohor

> "Xenakis's composition Bohor (1962) deploys the sounds of a Laotian mouth organ (slowed down greatly), small crotale bells, and hammerings on the inside of a piano to create a hypnotic and monumental sound mass. The last two minutes consist of sheets of broadband noise, which provoked a reaction at a Paris concert: 'By the end of the piece, some were affected by the high sound level to the point of screaming; others were standing and cheering. Seventy-five percent of the people loved it and twenty-five percent hated it,' estimated the composer from his own private survey following the performance."

<div class="src">(Curtis Roads)</div>

---
layout: center
class: divider
---

Achorripsis

---

# Achorripsis

Greek for **jets of sound**, composed in **1956-57**.

Consists of **twenty-eight** short sections, each one lasting for **15 seconds**.

Seven **sonic entities** are used: flute, oboe, strings glissando, percussion, string pizzicato, brass and strings arco.

---

# Achorripsis

Five levels of **density** are generated using a **Poisson distribution**.

Pitches, durations, successions, dynamics and glissando within a section are also calculated using **probabilities**.

A **probability matrix** was used for the distribution of timbres and densities.

---
class: light
---

# Achorripsis

<div class="fig tall"><img src="/figures/achorripsis-matrix-000.png" /></div>

---
class: light
---

# Achorripsis

<div class="shot"><img src="/figures/achorripsis-score-000.png" /></div>

---
class: light
---

# Achorripsis

<div class="shot"><img src="/figures/achorripsis-poisson-000.svg" /></div>

---

# Achorripsis

Each cell of the matrix holds a **density level**. Here one row is played: one entity over eight sections of a second each, with four events a second for every level.

```supercollider
// eight density levels from a Poisson distribution with a mean of 0.6
Ppoisson(0.6).asStream.nextN(8)    // for example [0, 1, 0, 2, 0, 0, 1, 0]

// that row played: a rest for 0, four events a second for each level above it
Pbind(\instrument, \sine,
	\midinote, Pwhite(60, 72),
	\dur, Pseq([Rest(1), Pn(1/4, 4), Rest(1), Pn(1/8, 8),
		Rest(1), Rest(1), Pn(1/4, 4), Rest(1)])
).play
```

The whole matrix of seven entities is at the end of the Achorripsis section in *Xenakis.scd*.
---
class: light
---

# Surprise

> "Let us now imagine music composed with aid of matrix [of probabilities] (M). An observer who perceived the frequencies of events of the musical sample would deduce a distribution due to chance and following the laws of probability. Now the question is, when heard a number of times, will this music keep its surprise effect? Will it not change into a set of foreseeable phenomena through the existence of memory, despite the fact that the law of frequencies has been derived from the laws of chance?"

<div class="src">(Xenakis)</div>

---
class: light
---

# A Network

> "In fact, the data will appear aleatory only at the first hearing. Then, during successive rehearings the relations between the events of the sample ordained by 'chance' will form a network, which will take on a definite meaning in the mind of the listener, and will initiate a special 'logic,' a new cohesion capable of satisfying his intellect as well as his aesthetic sense; that is, if the artist has a certain flair."

<div class="src">(Xenakis)</div>

---

# Fundamental Phases

1. Initial conceptions
2. Definition of the sonic entities
3. Definition of the transformations
4. Microcomposition
5. Sequential programming of 3. and 4.
6. Implementation of calculations
7. Final symbolic result
8. Sonic realization

---
class: light
---

# Points of Light

> "A complex sound may be imagined as a multi-colored firework in which each point of light appears and instantaneously disappears against a black sky. But in this firework there would be such a quantity of points of light organized in such a way that their rapid and teeming succession would create forms and spirals, slowly unfolding, or conversely, brief explosions setting the whole sky aflame. A line of light would be created by a sufficiently large multitude of points appearing and disappearing instantaneously."

<div class="src">(Formalized Music)</div>

---

# Analogique A et B

**Granular**: "All sound is an integration of grains, of elementary sonic particles, of sonic quanta".

*Analogique A*, for orchestra, was composed using **stochastic methods**.

*Analogique B*, hundreds of splices of tiny fragments of **magnetic tape**.

---

# Analogique A et B

**Markovian stochastic music**. Two chapters of *Musiques Formelles* are dedicated to the piece.

One of Xenakis's most thoroughly formalized compositions.

Considered by many as a failure.

---
layout: center
class: divider
---

<Listen file="xenakis-analogique-ab.mp3">Iannis Xenakis, Analogique A et B (1958-59)</Listen>

---
class: light
---

# Markov Chains

<div class="shot"><img src="/figures/markov-000.svg" /></div>

---

# Markov Chains

In a first-order **Markov chain** the next state depends only on the current one. Each note has its own list of possible next notes and their probabilities.

```supercollider
~chain = Dictionary[
	60 -> [[60, 64, 67], [0.2, 0.5, 0.3]],
	64 -> [[60, 67], [0.6, 0.4]],
	67 -> [[60, 64, 72], [0.3, 0.3, 0.4]],
	72 -> [[67], [1]]
];
~note = 60;

Pbind(\instrument, \sine,
	\midinote, Pfunc { ~note = ~chain[~note][0].wchoose(~chain[~note][1]) },
	\dur, 0.15).play
```

---
layout: center
class: divider
---

ST

---

# ST Pieces

Possible **realizations** of a particular compositional model.

The **ST** (Stochastic Music) program generated data in text format which Xenakis later transcribed to musical notation.

**ST parameters**: attack time, instrument class, instrument, pitch, duration, dynamics and glissandi.

---

# ST Pieces

*ST/10-1 080262*. ST stands for stochastics, 10 for instrumental groups, 1 for version and the last digits for the realization date.

**Density** was important, and defined as the average number of events, note onsets, within a section.

---
class: light
---

# IBM 7090

<div class="shot"><img src="/figures/ibm-7090-000.png" /></div>

---

# ST Pieces

Quantization of **attack times** produces a rhythmic structure with a subdivision of a half note into 3, 4, 5 and 6 parts.

A piece contains a number of **sequences** or movements where the durations of the movements are independent.

Each section has a fixed mean density, with a lower limit at **0.11 onsets per second** and an upper limit around **50 sounds per second**.

---

# ST Pieces

Instruments divided into **classes of timbres** based on different articulations in playing: pizzicato, col legno, tremolo and glissando.

Pitch was expressed as a floating-point number between **0 and 85**. Duration was also expressed as a fractional number, and dynamics were represented by integers on a scale of **0 to 60**.

---

# ST Algorithm

1. The work consists of a succession of sequences or movements each *ai* seconds long
2. Definition of the mean density of the sounds during *ai*
3. Composition Q of the orchestra, from *r* classes of timbres, during sequence *ai*
4. Definition of the moment of occurrence of the sound N within the sequence *ai*
5. Attribution to the above sound of an instrument belonging to orchestra Q

---

# ST Algorithm

6. Attribution of a pitch as a function of the instrument
7. Attribution of a glissando speed if class *r* is characterized as a glissando
8. Attribution of a duration x to the sounds emitted
9. Attribution of dynamic forms to the sounds emitted
10. The same operations are begun again for each sound of the cluster N *ai*
11. Recalculations of the same sort are made for the other sequences

---
class: light
---

# ST Algorithm

<div class="shot"><img src="/figures/st-algorithm-000.svg" /></div>

---

# ST Algorithm

The algorithm much reduced, with the numbers of its steps in the comments. Onsets with exponential gaps around a mean density are what a Poisson process produces.

```supercollider
Pspawner({ |sp|
	4.do {
		var length = exprand(2.0, 6.0);       // 1. a sequence, a seconds long
		var density = exprand(0.5, 20.0);     // 2. its mean density, onsets a second
		var low = rrand(36, 72);              // 3. its orchestra, as a register
		[length, density].round(0.1).postln;
		sp.seq(Pfindur(length, Pbind(
			\instrument, Pwrand([\sine, \gliss], [0.7, 0.3], inf), // 5. an instrument
			\dur, Pfunc { (1 - 1.0.rand).log.neg / density },      // 4. the onsets
			\midinote, Pwhite(low, low + 24),                      // 6. a pitch
			\slide, Pgauss(0, 7),                                  // 7. a glissando
			\sus, Pexprand(0.05, 1),                               // 8. a duration
			\amp, Pwhite(0.03, 0.12)                               // 9. a dynamic
		)));
	}
}).play
```

---

# Interpretation

Xenakis **changed, edited, arranged** and inserted material into the literal results of the program.

Nouritza Matossian: "he used seventy-five per cent computer material, composing the remainder himself."

Did not see the pieces as test pieces, but rather that the program was a **generator of musical material**.

One run of the program could result in several pieces.

---
class: light
---

# Pilot

> "Freed from tedious calculations the composer is able to devote himself to the general problems that the new musical form poses and to explore the nooks and crannies of this form while modifying the values of the input data. For example, he may test all instrumental combinations from soloists to chamber orchestras, to large orchestras. With the aid of electronic computers the composer becomes a sort of pilot: he presses the buttons, introduces coordinates, and supervises the controls of a cosmic vessel sailing in the space of sound, across sonic constellations and galaxies that he could formerly glimpse only as a distant dream."

<div class="src">(Xenakis)</div>

---
class: light
---

# Atrées

<div class="plate"><img src="/figures/atrees-000.png" /></div>

<div class="src">(Xenakis, Atrées, ST/10, 3-060962, 1956-62)</div>

---
layout: center
class: divider
---

<Listen file="xenakis-atrees.mp3">Iannis Xenakis, Atrées, third part (1956-62)</Listen>

---
layout: center
class: divider
---

Outside-time

---
class: light
---

# Outside-time

> "A given pitch-scale is an outside-time architecture, for no horizontal or vertical combination of its elements can alter it. The event itself, that is, its actual occurrence, belongs to the temporal category. Finally, a melody or a chord on a given scale is produced by relating the outside-time category to the temporal category. Both are realizations in-time of outside-time constructions."

> "What will count will be the abstract relations within the event or between several events, and the logical operations which may be imposed on them."

<div class="src">(Xenakis)</div>

---
class: light
---

# Outside-time

> "For instance, the scale of white keys on the piano has a structure of intervals; this structure is an outside-of-time structure. Now you can produce good or bad music, of course, but it's interesting to see that this white key structure is something independent of the melody, or the tonality, or modal music, or serial music, and so on. That's very important."

> "Serial music is a typical in-time structure. The relationship of the notes in the twelve-tone scale is one of the simplest outside-of-time structures because you are repeating exactly the same chromatic interval creating the twelve tones. […] So any serial string of notes is something which is in-time, not outside-of-time."

<div class="src">(Xenakis)</div>

---

# Outside-time and In-time

**Outside-time** is everything that holds before any event happens: a scale, a set of durations, a collection of timbres, the ranges a parameter may take.

**In-time** is the placing of those things in order, one after another.

A `Scale`, an `Env` and an array of durations are outside-time. A `Pbind` reading them is in-time.

---
class: light
---

# Outside-time and In-time

<div class="shot"><img src="/figures/outside-time-000.svg" /></div>

---

# Outside-time and In-time

Two sets of pitches, and the union, intersection and difference of them, are all outside-time. The Pbind that reads them is in-time.

```supercollider
(
a = Set[60, 62, 63, 67, 70];
b = Set[62, 65, 67, 69, 70];
(a | b).postln;   // union
(a & b).postln;   // intersection
(a - b).postln;   // difference
)

Pbind(\instrument, \sine,
	\midinote, Pseq([Pshuf((a | b).asArray), Pshuf((a & b).asArray, 2)], inf),
	\dur, 0.15).play
```

---
class: light
---

# Material

> "In architecture, what is more important than the material itself? Like the Taj Mahal, which was made with marble and things like that, very expensive material, I don't think it's a very important architectural piece. There are other things that are done with cheaper materials. They are much more interesting. Why? Because in architecture [it] is the problem of shapes, of proportions and the sizes, of course. These are features, kind of abstract, much more than the material itself. And if the proportions are OK, then this enlightens the materials; they become much more important, interesting. If not, then you might add gold or whatever and fail anyway. In music, I think it's the same thing; it's the same problem."

<div class="src">(Xenakis)</div>

---

# Issues

- Stochos and goal
- Causality and logic
- Determinism and indeterminism
- Speed and movement
- Gravity and time

<span class="note">(Gerard Pape)</span>

---
class: light
---

# Xenakis

<div class="shot"><img src="/figures/xenakis-portrait-000.png" /></div>

<div class="src">(CCMIX interview, from 3.08)</div>

---
layout: center
class: divider
---

Composing Sound

---

# Composing Sound

Sound is not treated as the starting point of composition, but as its **outcome**.

> "Xenakis often composed with graphs, at least until the end of the 1970s. Many of the sonorities, with which he was the first to experiment and which make his music so original, have been conceived thanks to graphs."

Defines three important **Xenakian sonorities**:

1. **Masses** of short sounds
2. **Glissandi**
3. **Sustained** sounds

---

# Composing Sound

The three sonorities, each as one Pbind. The glissando speeds are Gaussian, as in *Pithoprakta*.

```supercollider
// masses of short sounds
Pbind(\instrument, \sine, \midinote, Pwhite(40, 100),
	\dur, Pexprand(0.005, 0.05), \amp, 0.05).play

// glissandi
Pbind(\instrument, \gliss, \midinote, Pwhite(50, 80),
	\slide, Pgauss(0, 12), \sus, 2, \dur, 0.1, \amp, 0.02).play

// sustained sounds
Pbind(\instrument, \gliss, \midinote, Pwhite(40, 80),
	\slide, 0, \sus, 6, \dur, 0.5, \amp, 0.02).play
```

---
class: light
---

# Symbolic Music

<div class="shot"><img src="/figures/symbolic-music-000.png" /></div>

---
class: light
---

# Screens

<div class="fig tall"><img src="/figures/screens-000.png" /></div>

---
layout: center
class: divider
---

Brownian motion

---

# Brownian Motion

**Brownian motion**, a mathematical model originally developed to describe random movement of particles suspended in gas or liquids.

Inspired Xenakis as a generating concept in *Pithoprakta* (**1955-56**).

---

# Brownian Motion

Brownian motion is often modeled with the **drunken walk** or **random walk** analogy. Imagine a drunkard walking in a city, resulting in a series of steps, each of which goes in a random direction.

Xenakis used random walks in pieces such as *Cendrées*, *Jonchaies*, *Tetras*, *N'Shima* and *Mikka*. It was also used for stochastic sound synthesis in pieces such as *La Légende d'Eer*, *S.709* and *Gendy3*.

---
class: light
---

# Random Walk

<div class="fig tall"><img src="/figures/random-walk-000.png" /></div>

---

# Random Walk

`Pbrown` takes a bounded random step from the previous value. The second version writes the walk out as a series whose steps are random.

```supercollider
// steps of at most two semitones, kept between 50 and 70
Pbind(\instrument, \sine,
	\midinote, Pbrown(50, 70, 2),
	\dur, 0.1).play

// the same walk written out, and a second walk on the durations
Pbind(\instrument, \sine,
	\midinote, Pseries(60, Pwhite(-2, 2), inf).fold(50, 70),
	\dur, Pbrown(0.05, 0.2, 0.02)).play
```

---
class: light
---

# Mikka

<div class="plate"><img src="/figures/mikka-000.png" /></div>

<div class="src">(Xenakis, Mikka, 1971)</div>

---
layout: center
class: divider
---

<Listen file="xenakis-mikka.mp3">Iannis Xenakis, Mikka (1971)</Listen>

---

# Dynamic Stochastic Synthesis

<AudioEmbed src="/demos/gendy/" height="22rem" label="GENDYN, interactive" />

<span class="note">The same random walk, applied to the waveform itself: the breakpoints of one cycle each take a bounded step, and the shape is whatever they currently spell.</span>

---

# Dynamic Stochastic Synthesis

`Gendy1` is GENDYN as a UGen. With `minfreq` equal to `maxfreq` the pitch holds, and the walk changes only the timbre.

```supercollider
// the defaults: the walk moves both the pitch and the timbre
{ Gendy1.ar * 0.1 ! 2 }.play

// the pitch held by the mouse
{
	var f = MouseX.kr(50, 400, \exponential);
	Gendy1.ar(minfreq: f, maxfreq: f) * 0.1 ! 2
}.play

// four layers in the ratios 1, 3, 7 and 9
{
	var f = [1, 3, 7, 9] * MouseX.kr(30, 170, \exponential);
	Splay.ar(Gendy1.ar(minfreq: f, maxfreq: f)) * 0.1
}.play
```

---
layout: center
class: divider
---

<Listen file="xenakis-s709.mp3">Iannis Xenakis, S.709 (1994)</Listen>

---
layout: center
class: divider
---

Stochastics

---
class: light
---

# Stochastics

> "... I originated in 1954 a music constructed from the principle of indeterminism; two years later I named it 'Stochastic Music.' The laws of the calculus of probabilities entered composition through musical necessity."

> "These laws ... are veritable diamonds of contemporary thought. They govern the laws of the advent of being and becoming. However, it must be well understood that they are not an end in themselves, but marvelous tools of construction and logical lifelines."

<div class="src">(Xenakis)</div>

---

# Stochastics

**Probabilities** to control the movements of elements, where the composer invents schemes and explores the limits of different distributions.

Stochastics studies and formulates the **law of large numbers**, the **laws of rare events**, the different aleatory procedures.

<span class="note">From Greek stochos, a target or an aim: skillful in aiming, guessing at.</span>

---

# Probabilities in Composition

1. "We can control continuous transformations of large sets of granular and/or continuous sounds."
2. "A transformation may be explosive when deviations from the mean suddenly become exceptional."
3. "We can likewise confront highly improbable events with average events."
4. "Very rarified sonic atmospheres may be fashioned and controlled with the aid of formulae such as Poisson's. Thus, even music for a solo instrument can be composed with stochastic methods."

<div class="src">(Xenakis)</div>

---

# Probabilities in Composition

The second and third of the four, as patterns. A narrow Gaussian suddenly widens, and rare events in a high register interrupt average ones.

```supercollider
// an explosive transformation: the deviation goes from 0.5 to 24 and back
Pbind(\instrument, \sine,
	\midinote, Pgauss(72, Pseg([0.5, 0.5, 24, 0.5], [6, 0.5, 4])),
	\dur, 0.05, \amp, 0.1).play

// improbable events against average ones, one in twenty
Pbind(\instrument, \sine,
	\midinote, Pwrand([Pgauss(60, 2, 1), Pwhite(90, 100, 1)], [0.95, 0.05], inf),
	\dur, 0.1).play
```

---
layout: center
class: divider
---

Density functions

---

# Density Functions

A random number generator has a **range** and a **shape**. The range says which values are possible; the shape says how often each one comes up.

Most noise sounds in nature have a **distributed spectrum**, where energy exists everywhere within a range of frequencies. The probabilities of a continuous random phenomenon are expressed by a **probability density function**.

Probability density functions have a shape, and in composition **the shape is the material**.

<span class="note">(after Dodge and Jerse, Computer Music; and Berg)</span>

---
class: light
---

# Six Shapes

<div class="shot"><img src="/figures/distributions-000.svg" /></div>

---
class: light
---

# The Shape Is the Material

<div class="shot"><img src="/figures/shape-is-material-000.svg" /></div>

<div class="src">(one synth, one range, one event count)</div>

---

# The Distributions

- **Uniform**: every value in the range equally likely. `rrand`, `Pwhite`
- **Exponential**: a large probability of values near the low end. `exprand`, `Pexprand`
- **Gaussian**: a bell around a mean, with a standard deviation for its spread. `gauss`, `Pgauss`
- **Beta**: two numbers, and the shape travels from both edges to uniform to bell. `Pbeta`
- **Cauchy**: symmetrical around a point, with far heavier tails than Gaussian. `Pcauchy`
- **Poisson**: how many events fall in a fixed interval, which is a density. `Ppoisson`
- **Weibull**: varies between exponential and Gaussian as its shape parameter moves

<span class="note">Xenakis used Poisson for the densities in *Achorripsis* and Gaussian for the glissando speeds in *Pithoprakta*.</span>

---

# The Distributions

The same Pbind with one distribution at a time on pitch. Run the lines one by one.

```supercollider
~play = { |pattern| Pbind(\instrument, \sine, \midinote, pattern, \dur, 0.1).play };

~play.(Pwhite(40, 80));

~play.(Pexprand(40, 80));

~play.(Pgauss(60, 6));

~play.(Pcauchy(60, 2).clip(30, 90));

~play.(Ppoisson(60));
```

---

# Beta

The beta density can assume various shapes depending on the values of **a** and **b**, and it returns values in the range 0 to 1.

When both a and b are greater than 1, the beta density is similar to a bell-shaped Gaussian density.

When both a and b equal 1, it is a special case of the **uniform** distribution.

When both are between 0 and 1, **a** controls the probability of values closest to 0 and **b** the probability of values closest to 1. The smaller a parameter is, the greater the probability at the extreme it governs.

The mean is **a / (a + b)**.

---
class: light
---

# Beta

<div class="shot"><img src="/figures/beta-family-000.svg" /></div>

---

# Beta as the Workhorse

Two numbers traverse the whole family, so one generator covers most of what the others do separately.

```supercollider
p = Pbeta(0, 1, 0.3, 0.3, inf).asStream;   // lo, hi, a, b
({ p.next } ! 4000).histo(40).plot("both edges");

// the same generator, three shapes
Pbind(\freq, Pbeta(200, 2000, 0.3, 0.3), \dur, 0.08).play;   // the extremes
Pbind(\freq, Pbeta(200, 2000, 3, 3),     \dur, 0.08).play;   // a bell
Pbind(\freq, Pbeta(200, 2000, 0.4, 3),   \dur, 0.08).play;   // the low end
```

<span class="note">`a = b = 1` is uniform, and every other pair is a deformation of it.</span>

---

# Look Before You Map

A distribution is drawn in its own units. What the ear does with those units is a separate question, and the two rarely agree.

Examine a **histogram** before mapping anything: draw a few thousand values, count them into bins, and look.

```supercollider
// what was actually drawn, before any of it becomes a frequency
a = { 1.0.exprand(0.001) } ! 4000;
a.histo(40).plot("exprand, as drawn");

// the same draws, counted per octave instead of per hertz
b = (a * 1000 + 200).log2;
(b - b.minItem).histo(40).plot("the same draws, per octave");
```

---
class: light
---

# Look Before You Map

<div class="shot"><img src="/figures/look-before-mapping-000.svg" /></div>

---

# Distributions

<AudioEmbed src="/demos/events/" height="22rem" label="six distributions, interactive" />

<span class="note">Each of duration, frequency and amplitude takes its own shape, so the effect of a distribution can be heard on one parameter at a time.</span>

---
layout: center
class: divider
---

Randomness

---

# Randomness

Random numbers in a computer are **pseudo-random**: a deterministic sequence that starts from a **seed** and only looks random.

Working with randomness means choosing the **range** of the values, their **distribution**, and how much each value **remembers** of the ones before it.

A random process is heard as a texture only over many events. Over a few events it is heard as one particular phrase.

---

# Random Numbers

The basic messages. Each one returns a new value every time it is evaluated.

```supercollider
10.rand
rrand(60, 72)
0.25.coin
[60, 64, 67].choose
[60, 64, 67].wchoose([0.6, 0.3, 0.1])
```

---

# Seeds

Setting the **seed** makes a random result repeatable. Run each of these twice, then change the seed.

```supercollider
(
thisThread.randSeed = 7;
{ 100.rand } ! 8
)

Pseed(7, Pbind(\instrument, \sine, \midinote, Pwhite(60, 72, 8), \dur, 0.15)).play
```

---

# Random Choice

Four ways to choose from a list, played with `~play` from *The Distributions*.

```supercollider
~play.(Prand([60, 64, 67, 72], 16));
~play.(Pxrand([60, 64, 67, 72], 16));    // never the same twice in a row
~play.(Pshuf([60, 64, 67, 72], 4));      // one random order, repeated
~play.(Pwrand([60, 64, 67, 72], [0.4, 0.3, 0.2, 0.1], 16));
```

---

# Plotting Patterns

Two views of the same values: **in order**, as they will be heard, and as a **histogram**, which counts how often each part of the range comes up.

```supercollider
(
~plotPattern = { |pattern, count = 500|
	pattern.asStream.nextN(count).plot(discrete: true)
};

~histogram = { |pattern, count = 4000|
	pattern.asStream.nextN(count).histo(40).plot
};
)

~plotPattern.(Pwhite(0.0, 1.0));
~histogram.(Pwhite(0.0, 1.0));

~plotPattern.(Pexprand(0.01, 1.0));
~histogram.(Pexprand(0.01, 1.0));
```

---

# Large Numbers

The **law of large numbers**: the more values are drawn, the closer their histogram comes to the shape of the distribution.

```supercollider
~histogram.(Pgauss(0.0, 1.0), 50);
~histogram.(Pgauss(0.0, 1.0), 500);
~histogram.(Pgauss(0.0, 1.0), 50000);
```

A cell of *Achorripsis* holds only a handful of events, and the Poisson distribution shows only across the whole matrix.

---
class: light
---

# Large Numbers

<div class="shot"><img src="/figures/large-numbers-000.svg" /></div>

---

# Combining Random Numbers

Two uniform values combined give a new shape. The lower of the two favours the low end, the higher favours the high end, and their mean favours the middle.

```supercollider
~histogram.(Plprand(0.0, 1.0));    // the lower of two
~histogram.(Phprand(0.0, 1.0));    // the higher of two
~histogram.(Pmeanrand(0.0, 1.0));  // the mean of two
```

---

# Sums

The **central limit theorem**: a sum of many independent random values approaches a **Gaussian**, whatever the distribution of each one. Quantities that result from many small causes are often bell-shaped for this reason.

```supercollider
~histogram.(Pfunc { 1.0.rand });

~histogram.(Pfunc { 1.0.rand + 1.0.rand });
~histogram.(Pfunc { ({ 1.0.rand } ! 12).sum });
```

---
class: light
---

# Sums

<div class="shot"><img src="/figures/sums-000.svg" /></div>

---

# Changing Distributions

The parameters of a distribution can themselves be patterns, so the shape changes while the values are drawn. This is the *continuous transformation* of the first of Xenakis's four points.

```supercollider
~plotPattern.(Pgauss(0.0, Pseries(0.0, 0.01)), 1000);
~plotPattern.(Pbeta(0.0, 1.0, Pseries(0.1, 0.01), Pseries(0.1, 0.01)), 1000);

Pbind(\instrument, \sine,
	\midinote, Pgauss(66, Pseries(0.0, 0.05, 400)),
	\dur, 0.04, \amp, 0.1).play
```

---
class: light
---

# Changing Distributions

<div class="shot"><img src="/figures/changing-distributions-000.svg" /></div>

---

# Memory

- **No memory**: `Pwhite`, `Pgauss` and the other distributions draw each value independently
- **The last value**: a random walk such as `Pbrown` takes a step from where it is
- **The current state**: a **Markov chain** chooses the next state by the current one
- **The last two states**: a **second-order** chain chooses by the last two

The more a process remembers, the more its output is heard as a line or a phrase.

---

# Brownian Motion

Plotted in order, white noise is a scatter and a walk is a line. The step size decides how fast the walk travels its range.

```supercollider
~plotPattern.(Pwhite(0, 100));
~plotPattern.(Pbrown(0, 100, 2));
~plotPattern.(Pbrown(0, 100, 20));
```

---

# Steps

The steps of a walk have a distribution of their own, and without limits the walk drifts away. With **Cauchy** steps it mostly moves a little and sometimes jumps far, which is called a **Lévy flight**.

```supercollider
~plotPattern.(Pseries(0.0, Pwhite(-1.0, 1.0)), 1000);
~plotPattern.(Pseries(0.0, Pgauss(0.0, 1.0)), 1000);
~plotPattern.(Pseries(0.0, Pcauchy(0.0, 0.5)), 1000);
```

---
class: light
---

# Steps

<div class="shot"><img src="/figures/walks-000.svg" /></div>

---

# Walks in Sound

A walk on each parameter. `Pgbrown` steps by ratios, which suits durations and frequencies. The second pattern is a Lévy flight on pitch, folded into a range.

```supercollider
Pbind(\instrument, \sine,
	\midinote, Pbrown(48, 84, 3),
	\dur, Pgbrown(0.04, 0.4, 0.1),
	\amp, Pbrown(0.02, 0.2, 0.02)).play

Pbind(\instrument, \sine,
	\midinote, Pseries(60, Pcauchy(0.0, 0.3)).fold(36, 96),
	\dur, 0.08).play
```

---

# Transition Matrix

A Markov chain written as a **transition matrix**: one row for each current state, one column for each next state. Each row sums to 1, and a 0 forbids the move. `windex` chooses an index by weight.

```supercollider
~states = [60, 64, 67, 72];
~matrix = [
	[0.1, 0.6, 0.2, 0.1],
	[0.3, 0.0, 0.6, 0.1],
	[0.4, 0.2, 0.0, 0.4],
	[0.0, 0.3, 0.7, 0.0]
];
~index = 0;
~chain = Pfunc { ~index = ~matrix[~index].windex; ~states[~index] };

Pbind(\instrument, \sine, \midinote, ~chain, \dur, 0.15).play
```

---
class: light
---

# Transition Matrix

<div class="shot"><img src="/figures/transition-matrix-000.svg" /></div>

---

# The Long Run

Run long enough, a chain spends a fixed share of its time in each state, whichever state it starts from. This is its **stationary distribution**. The matrix sets the proportions while the succession of states stays random.

```supercollider
~plotPattern.(~chain, 100);

(
a = ~chain.asStream.nextN(10000);
~states.collect { |state| a.occurrencesOf(state) / 10000 }
)
```

---

# Learning a Chain

`MarkovSetN` from the **MathLib** quark counts the transitions in a sequence and turns them into probabilities. Change the order from 1 to 2 and each pair of notes predicts the next, so more of the melody returns.

```supercollider
Quarks.install("MathLib");    // then recompile the class library

~melody = [60, 62, 64, 60, 60, 62, 64, 60, 64, 65, 67, 64, 65, 67];

(
m = MarkovSetN.fill(100, Pseq(~melody, inf).asStream, 1);
m.makeSeeds;
Pbind(\instrument, \sine, \midinote, m, \dur, 0.2).trace.play
)
```

---
class: light
---

# State Machines

<div class="shot"><img src="/figures/state-machine-000.svg" /></div>

---

# State Machines

A **finite state machine** moves between states along fixed connections. `Pfsm` takes the entry states, then each state followed by the states that may come next, chosen with equal chance. A state can be a pattern, and repeating an index in a list gives it more weight.

```supercollider
(
Pbind(\instrument, \sine,
	\midinote, Pfsm([
		[0],
		60, [1, 2],
		Pseq([64, 65, 67]), [0, 2],
		72, [0, 1]
	], inf),
	\dur, 0.15).trace.play
)
```

---

# Sections as States

With whole Pbinds as states, the state machine decides the **form**: which section follows which.

```supercollider
(
a = Pbind(\instrument, \sine, \midinote, Pwhite(72, 84, 16), \dur, 0.05);
b = Pbind(\instrument, \gliss, \midinote, Pwhite(40, 50, 2), \dur, 1);
c = Pbind(\instrument, \sine, \midinote, Pbrown(55, 65, 2, 8), \dur, 0.2);
Pfsm([[0], a, [1, 2], b, [0, 2], c, [0, 1]], inf).play
)
```

---
class: light
---

# A Network

> "In fact, the data will appear aleatory only at the first hearing. Then, during successive rehearings the relations between the events of the sample ordained by 'chance' will form a network, which will take on a definite meaning in the mind of the listener, and will initiate a special 'logic,' a new cohesion capable of satisfying his intellect as well as his aesthetic sense, that is, if the artist has a certain flair."

<div class="src">(Xenakis)</div>

---
class: light
---

# Stochastic Crossroads

> "But other paths also led to the same stochastic crossroads: natural events such as the collision of hail or rain with hard surfaces the song of cicadas in a summer field a political crowd of dozens or hundreds of thousands of people...It is an event of great power and beauty in its ferocity. Then the impact between the demonstrators and the enemy occurs. ...Imagine, in addition, the reports of dozens of machine guns and the whistle of bullets adding their punctuations to the total disorder. The crowd is then rapidly dispersed, and after sonic and visual hell follows a detonating calm, full of despair, dust, and death."

<div class="src">(Xenakis)</div>

---
class: light
---

# Not a Translation

> "Although some critics have genuinely misunderstood his intentions, Xenakis never claimed that a rigorous mathematical or analytic basis is sufficient to produce a well-formed piece of music. Those who are partially informed about the mathematical theory expect the music to be a mirror of mathematical processes and equations. Pithoprakta is no more a translation of probability theory than an artichoke or a celery heart is a translation of the Fibonacci series or a flowing river is a translation of random functions."

<div class="src">(Matossian)</div>

---

# Next Steps

- Run *Xenakis.scd* from the top. It holds every example from the slides, in order
- Play the whole **Achorripsis** matrix in *Xenakis.scd* and change its Poisson mean
- Give the **ST algorithm** more sequences and a wider range of densities
- Try each distribution in the **events** demo on one parameter at a time before writing it as a pattern
- Plot each distribution with `~plotPattern` and `~histogram` before listening to it
- Write a melody of your own into `~melody` and compare the first-order and second-order chains

---
layout: center
class: divider
---

Exercises

---

# Exercises

Twelve short ones first, each a small step from the one before. Then the four longer ones from last year, numbered on from 13. *Exercises.scd* has all of them with space to write, and *Xenakis.scd* has the SynthDefs.

---

# Distributions

1. Play notes with `Pwhite` pitches between 60 and 72. Then change only the distribution to `Pexprand`.
2. Use `Pgauss` for pitch with a mean of 60, and try deviations of 1, 6 and 24.
3. Draw 1000 values from `Pbeta(0, 1, 0.3, 0.3)` and plot their histogram. Then try a = b = 3.
4. Give the durations a `Pexprand` between 0.05 and 1, with the pitch fixed.
5. Use `Pbrown` for pitch between 48 and 72 with a step of 1, then with a step of 12.
6. Write the walk from 5 as a `Pseries` with `Pwhite` steps, folded between 48 and 72.

---

# Combined with Patterns

7. A `Pseq` of three sections of 16 notes each: `Pwhite`, then `Pgauss`, then `Pexprand` pitches.
8. Draw the amplitude from `Pexprand(0.02, 0.2)` and use `Pkey` so that louder notes are shorter.
9. Two Pbinds in `Ppar`, one with `Pbrown` pitches and one with `Pgauss` pitches.
10. Change the **Markov chain** so that 72 can return to 60, then add a fifth state.
11. Draw the eight levels of the **Achorripsis** row with a Poisson mean of 2, and play the row they give.
12. Glissandi whose Gaussian speed deviation grows from 0 to 24 over twenty seconds, using `Pseg`.

---

# Exercises

13. Implement a **stochastic process** that uses a different distribution for amplitude, frequency and duration of events.

14. Implement a stochastic process where **sequences of different distributions** are used.

15. Implement a rhythmic sequence where a **Markov chain** is used for duration values.

16. Implement a sequence of `Pbind`s where each uses a **brownian motion**, `Pbrown`, for controlling pitches in different ways. These should then be sequenced in time using `Pspawner`.

<span class="workshop">- workshop -</span>
