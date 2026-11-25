---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 07 Koenig and Selection
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

<div class="deck-title">Koenig and Selection</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---
layout: center
class: divider
---

Instruments

---

# Instruments

Five new **SynthDefs** join `\sine` and `\gliss` from the last class: `\pluck`, `\bell`, `\breath`, `\blip` and `\drone`.

All seven take the same arguments: **freq**, **amp**, **sus**, **pan** and, apart from `\sine`, **slide**. `sus` is the length of the sound in seconds and `slide` is a glissando in semitones over that length.

Any instrument can therefore replace any other in a Pbind by changing one symbol. Every example in this class can be played with all seven.

---
class: light
---

# Instruments

<div class="shot"><img src="/figures/instruments-000.svg" /></div>

---

# Instruments

A plucked string, made by a burst of noise ringing in a short delay line, and a bell made by **frequency modulation**.

```supercollider
SynthDef(\pluck, { |out=0, freq=440, amp=0.2, sus=1, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var sig = Pluck.ar(WhiteNoise.ar, Impulse.kr(0), 0.05, line.reciprocal, sus, 0.3);
	var env = EnvGen.kr(Env.linen(0, sus, 0.05), doneAction: 2);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\bell, { |out=0, freq=440, amp=0.1, sus=1, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.perc(0.005, sus, curve: -6), doneAction: 2);
	var mod = SinOsc.ar(line * 1.4) * line * 3 * env;
	Out.ar(out, Pan2.ar(SinOsc.ar(line + mod) * env, pan, amp));
}).add;
```

---

# Instruments

Noise through a narrow band-pass filter, and a pulse wave through a resonant filter that closes as the sound decays.

```supercollider
SynthDef(\breath, { |out=0, freq=440, amp=0.2, sus=0.5, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.sine(sus), doneAction: 2);
	var sig = BPF.ar(WhiteNoise.ar, line, 30 / line) * 8;   // a band 30 Hz wide
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\blip, { |out=0, freq=440, amp=0.1, sus=0.2, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.perc(0.002, sus), doneAction: 2);
	var cutoff = XLine.kr((freq * 12).min(16000), freq, sus);
	var sig = RLPF.ar(Pulse.ar(line, 0.3), cutoff, 0.2);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;
```

---

# Instruments

Two slightly detuned sines that swell and fade, for sustained sounds. Below it, one phrase played by each of the seven instruments in turn.

```supercollider
SynthDef(\drone, { |out=0, freq=440, amp=0.1, sus=2, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.linen(sus * 0.3, sus * 0.4, sus * 0.3, 1, \sine), doneAction: 2);
	var sig = SinOsc.ar(line * [1, 1.003]).sum * 0.5;
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

~instruments = [\sine, \gliss, \pluck, \bell, \breath, \blip, \drone];

Pbind(\instrument, Pdup(6, Pseq(~instruments)),
	\midinote, Pseq([60, 63, 67, 70, 67, 63], inf),
	\sus, 0.4, \slide, 0, \dur, 0.2).play
```

---
class: light
---

# Koenig

> "The Cologne studio looked down on composers that "only" had form problems. "Material fetishism" dates from then and could be understood as "form fetishism". Form was not mentioned at all, everything was material; sounds as well as the serial methods. Form was seen more as an automatic consequence of the treatment of material than as an independent category to which the fashioning of sounds ought to be subordinate. When forms were exposed at all they were simple concepts such as the crossform in Kreuzspiel or the group in Gruppen, in both cases they were derived from the treatment of the material."

<div class="src">(Koenig)</div>

---

# History

Started working in the electronic studio of the **West German Radio** in 1954.

Studied programming at **Bonn University** in order to learn to use computers to facilitate compositional ideas.

Was invited in 1964 to the **State University in Utrecht**, to fill the vacant position of artistic director of the electronic studio (later called the Institute of Sonology).

Composed both electronic and instrumental music as well as writing pioneering and important composition programs, **Project 1**, **Project 2** and **SSP**.

---

# Serialism

**Serialism** is *"more of a world-view or an aesthetic doctrine than the right way to compose."*

Serialism is not just about the 'series' but also about **quantization** and **differentiation**.

*"Whilst many composers soon tired of standardization, differentiation is still possible without strictest serial treatment. Since then serial ideas have been based less on the series and more on the concept of difference."*

*"Both serial and electronic music are characterized by a high degree of formalization and mechanization."*

---

# Planning

**Formalization** and **mechanization** involves **planning**.

*"By planning I do not mean contriving systems which operate more or less automatically, but the translation of psychological perception values into technical work processes."*

Planning can involve **rules**.

*"Composers who were unwilling to invent a personal serial system, perhaps even a new one for each composition, could not really compose serially."*

---

# Material

**Koenig**: *"Artistic endeavor seemed impossible without a precise definition of material."*

The concept of material is not limited to sounds but also includes **compositional methods** and **rules**.

---

# Essay

*Essay* (**1957**), a composition for electronic sounds on tape. Koenig's own description of its structure:

- **8 parts** of different lengths, each containing one material
- A material is an *"already composed arrangement"* of sound processes: sines, noise, impulses
- The materials vary in length and construction according to their intended characteristics
- Each material is subjected to **transformations**, chiefly of timbre and time
- The material is projected into *"time-space"* by **contraction** and **expansion**

<div class="src">(after Berg, Koenig as a laptop artist)</div>

---

# Essay

Eight parts, each built from one material and projected into time by contraction or expansion. The material is a short phrase; the factor scales its durations.

```supercollider
~material = { |instrument, notes, durs|
	Pbind(\instrument, instrument, \midinote, Pseq(notes), \dur, Pseq(durs))
};

~parts = [
	[\sine, [72, 79, 74], [0.1, 0.1, 0.4]], [\breath, [48, 50], [1, 2]],
	[\blip, [60, 61, 62, 63], [0.05, 0.05, 0.05, 0.3]], [\drone, [43], [3]]
];

Pseq(8.collect { |i|
	var part = ~parts.wrapAt(i);
	var factor = [0.25, 0.5, 1, 2, 4].choose;   // contraction or expansion
	Pstretch(factor, ~material.(*part))
}).play
```

---
class: light
---

# Serialism and Aleatoric Composition

> "It is not the order of certain intervals that is perceived but the rate at which they occur and this results in the 'harmonic timbre' of a structure. The same applies to all other parameters."

> "Serial theory registers the behavior of point-wise phenomena in closest proximity to one another, permitting predictions in this limited area. Mass phenomena resulting as collages from layering point-wise or other mass phenomena cannot be described in serial theory. As far as I could see, the only chance of registering such phenomena was to expand serial methods to aleatoric ones, which were endorsed by Stockhausen's field concept."

<div class="src">(Koenig)</div>

---
class: light
---

# Randomness as a control structure

<div class="shot"><img src="/figures/streichquartett-000.png" /></div>

<div class="src">(Paul Berg)</div>

---

# Streichquartett 1959

*Streichquartett 1959* was **not made with a computer**. Randomness is used as a **control structure**, with several levels of control for each parameter.

1. A **supply** of elements, `[a b c d e f g]`
2. A **random selection** from the supply, `[a c d g]`
3. A **group list** chosen at random, `[3 1 2 5]`, which says how often each selected element repeats: the **repetition list**
4. The repetition list in **random order** is the result

Five years before Project 1, the method is already a program, carried out by hand.

<div class="src">(Berg, after Essl)</div>

---

# Streichquartett 1959

The four steps as four lines, and the result played.

```supercollider
~supply = [60, 62, 63, 65, 67, 68, 70];                    // a b c d e f g
~selection = ~supply.scramble.keep(4).sort;                 // random selection
~groups = { rrand(1, 5) } ! 4;                              // the group list
~repetitions = ~selection.collect { |n, i| n ! ~groups[i] }.flat;
~result = ~repetitions.scramble;                            // random order

[~selection, ~groups, ~result].do(_.postln);

Pbind(\instrument, \pluck, \midinote, Pseq(~result), \dur, 0.15).play
```

---

# Terminus

**Koenig's** last electronic composition in **Cologne**.

The title refers to giving up any further attempts to realize a truly continuous sound with the electronic studio.

*"The formal construction of Terminus was based on the fact that transformations of sound material which in its turn is already transformed keep on moving further away from the initial material. It was to be expected that the sound material would first differ because of transformation, but would later forfeit these differences because common characteristics caused by transformations dominate the original characteristics of the "Urklänge"."*

---

# Terminus

The initial material consists of **five sine wave glissandi**. Each sine wave has to start its glissando from a prescribed basic frequency.

No sine wave is allowed to become higher than the highest one or lower than the lowest one, so that the spectrum is unambiguously defined in the pitch range.

The five frequencies are: *331, 443, 592, 793, 1062 Hz*.

Transformations change the "original". The following are used: **Transposition**, **Filtering**, **Reverberation**, **Ring modulation**, **Chopping**, **Cutting** and **permutation** and **Synchronisation**.

---
class: light
---

# Terminus

<div class="shot"><img src="/figures/terminus-000.png" /></div>

---

# Terminus

**Scheme**: start in each sub-section with the lowest line index and use the "permitted" material (underlined in the generation diagram), paying no attention to the columns. Then find the next line containing "permitted" material and use it, if it consists of several parts, from left to right. If more "permitted" items of material should be found "above" some material (same column, lower line index), they are added immediately (in decreasing line index order).

---
class: light
---

# Terminus

<div class="fig tall"><img src="/figures/terminus-scheme-000.png" /></div>

---

# Terminus

Glissandi that start on one of the five frequencies and end on another, so that none leaves the range. Then two transformations of the same material: transposition and chopping.

```supercollider
~terminus = [331, 443, 592, 793, 1062];

~glissandi = Pbind(\instrument, \drone,
	\freq, Prand(~terminus, inf),
	\target, Prand(~terminus, inf),
	\slide, (Pkey(\target) / Pkey(\freq)).ratiomidi,
	\sus, 4, \dur, 0.8, \amp, 0.05);

~glissandi.play;

Pbindf(~glissandi, \freq, Pkey(\freq) * 0.25, \target, Pkey(\target) * 0.25).play;  // transposed

Pbindf(~glissandi, \instrument, \blip, \sus, 0.1, \dur, 0.06).play;   // chopped
```

---
layout: center
class: divider
---

<Listen file="koenig-terminus-x.mp3">Gottfried Michael Koenig, Terminus X (1967)</Listen>

---

# Funktionen

**VFG** used to create **curves stored** and used both for sound and control.

Variants were produced from those sound-structures by using 36 different patches (*rm*, *filtering*, *reverberation* and *rhythmicising*).

The result was cut, combined and ordered by using chance operations from a computer program.

---
class: light
---

# Funktionen

<div class="fig tall"><img src="/figures/funktionen-000.png" /></div>

---

# Compositional rules

**Three** main avenues:

1. **Analysis** of existing music of the past and present. Given the music, find the rules.

2. **Introspection**, the composer/programmer analyses his own experiences.

3. Making **limited models**. Given the rules, find the music.

---

# Project One

A program for **instrumental composition**, first conceived in **1964**.

*"... enables the user to investigate a simple compositional model and consequently various musical structures produced according to this model. This model is restricted to the parameters instrument, rhythm, harmony, register, and dynamics."*

Behind the rules for selection and combination of elements is the **serial** method. Since Koenig regards serialism as a special case of aleatoric composition, **random selection principles** are used instead of series and their permutations.

<div class="src">(Koenig, quoted by Berg)</div>

---

# Project One (1964)

Overall form is divided into **7** sections where each section is assigned a value between 1-7 (**irregular** -> **regular**) for each parameter.

**Parameters** generated with random selection principles that are calculated **independent** of each other.

Ranges 5-7 contain repetitions, ranges 1-3 contain no repetition and range 4 contains both regular and irregular features.

---

# Project One (1964)

Very little support for **user input** (number of points per section, 6 tempi, values for entry delays and random start number).

The program **outputs lists** of (non-overlapping) points.

---

# Regularity

Ranges 1 to 3 concern the **size of a group** of elements chosen without the possibility of repetition. Ranges 5 to 7 concern the **number of repetitions** of a single value.

At **4** a regular phrase is answered by an irregular one and the other way round. Koenig called this **set and balance**.

For the instrument parameter in a later version: series of 9, 6 and 3 values at 1, 2 and 3; then 1 to 4, 4 to 8 and 7 to 12 repetitions at 5, 6 and 7.

<div class="src">(Berg, Koenig as a laptop artist)</div>

---
class: light
---

# Regularity

<div class="shot"><img src="/figures/regularity-000.svg" /></div>

---

# Regularity

A function that turns a value from 1 to 7 into a selection from a list. The list stays the same and only its regularity changes.

```supercollider
~regularity = { |value, list|
	case
	{ value < 4 } { Pn(Plazy { Pseq(list.scramble.keep([7, 5, 3][value - 1])) }) }
	{ value == 4 } { Pseq([Pdup(6, Prand(list, 1)), Pshuf(list, 1)], inf) }
	{ value > 4 } {
		var range = [[1, 4], [4, 8], [7, 12]][value - 5];
		Pdup(Pwhite(range[0], range[1]), Prand(list, inf))
	}
};

~list = [60, 62, 63, 65, 67, 68, 70];
Pbind(\instrument, \pluck, \midinote, ~regularity.(1, ~list), \dur, 0.12).play;

Pbind(\instrument, \pluck, \midinote, ~regularity.(7, ~list), \dur, 0.12).play;
```

---

# Harmony

Rhythm is left to the user, and harmony is *"protected from his assaults"*.

A program builds **three-note groups**, ascending or descending, from minor seconds and major thirds or minor seconds and minor thirds. The group is **transposed** to give all twelve notes.

```supercollider
~group = [0, 1, 5];                                          // a minor second, a major third
~row = [0, 3, 6, 9].collect { |t| ~group + t }.flat % 12;   // four transpositions
~row.postln;               // [0, 1, 5, 3, 4, 8, 6, 7, 11, 9, 10, 2]
~row.asSet.size.postln;    // 12

Pbind(\instrument, \bell, \note, Pseq(~row, 2), \octave, Prand([4, 5, 6], inf),
	\dur, 0.15).play
```

---

# Project One

Seven sections, each with its own value from 1 to 7 for instrument, entry delay and register, read from a **branching table**. The harmony is the protected row.

```supercollider
~table = [
	[1, 3, 6, 4, 2, 7, 5],    // instrument
	[6, 3, 7, 5, 4, 1, 2],    // entry delay
	[2, 7, 6, 5, 1, 3, 4]     // register
];

Pseq(7.collect { |section|
	Pfindur(4, Pbind(
		\instrument, ~regularity.(~table[0][section], [\sine, \pluck, \bell, \breath, \blip]),
		\dur, ~regularity.(~table[1][section], [1, 2, 3, 5, 8, 13] / 32),
		\octave, ~regularity.(~table[2][section], [3, 4, 5, 6, 7]),
		\note, Pseq(~row, inf),
		\sus, 0.3))
}).play
```

---
class: light
---

# Branching table

<div class="shot"><img src="/figures/branching-table-000.png" /></div>

---

# Interpretation

The program produces lists of points. Durations are not calculated; only the start times, from the **entry delays**. Tempo changes and fermatas are inserted in the result.

The **interpretation** of the score table is a key issue: *"The interpretation of the score table is also an interpretation of the compositional strategy."* A composer could pick a main parameter and score it, and search the table for clues to further decisions.

*Segmente 99-105* (**1982**), for violin and piano, is a piece read off this kind of output.

<div class="src">(Berg, Koenig as a laptop artist)</div>

---
class: light
---

# A Study Model

> "The program should serve as a study model, to stimulate composers and students to look for conditions under which systematically collected musical material facilitates substitution of aesthetic judgement; it should not be seen as a composing machine although thoughtful experimentation might lead to compositions."

> "The algorithms combined in Project 1 are based on ways of structuring musical time ... The algorithms produce cycles of differing frequency (and also of differing irregularity of movement), so that constantly changing overlappings occur. This principle - a circular one - is not goal-oriented; the result is static and consequently, I think, suited to being split up into voices."

<div class="src">(Koenig)</div>

---

# Form

**Form** emerges during **planning** and **realization**.

Form was not really a topic in Cologne because everybody was concerned with **material**. Form was taken for granted for how could one recognize art if it had no form. The concept of material was not limited to sounds but also included compositional methods and rules.

Form is a **process** (or the result of a process leaving its trace) that starts with inspiration and proceeds with design, execution, correction, and performance of music.

---
class: light
---

# Form

> "'Form' is no longer the personal manner in which the musical material is presented or the listener's perception is guided, rather, it is the rationally discernible, reproducible effect, detached from the composer, of an organized system imposed on arbitrary material."

> "Form, here, is not merely a vessel, but a process that starts with the composer's inspiration and proceeds by way of design, execution, correction, and performance to the listener's ear and judgment. The conflict [between idea and its representation in time], then, ... is due to the elimination of the composer during an important phase of the process."

<div class="src">(Koenig)</div>

---
class: light
---

# Form

> "Even composers who like to experiment will want to bear responsibility for the aesthetic result, and will therefore try to come to terms with their own form criteria. In doing so, they enter territory that is at least as close to interpretation as to composing."

> "Computer music involves a strategy which, freed from the psyche of the human composer, can be taken over by an algorithm. In the algorithm, the elements and methods (selection, permutation, conditional branching in the working schedule) are redefined. The result of algorithmic composition can be converted into performance categories that are foreign to it: voice leading, phrasing, and playing technique..."

<div class="src">(Koenig)</div>

---

# Project Two

Based on a **database** of **parameters** and a structuring method for selecting and combining the parameters.

The basic idea is of **selection**.

A composer selects values for parameters to use in a composition. He then applies selection principles to choose from those values how and when they will occur.

---

# Project Two

The user (composer) answers many **questions** (about 60) which will determine the generated output.

**Layers** can be created and **variants** from the same input as well.

**Parameters** are calculated within a **hierarchy** and can have a specified relation determined in the database.

---
class: light
---

# Project Two

<div class="fig tall"><img src="/figures/project-two-000.png" /></div>

---

# Project Two

*"There ought ... to be programs which any composer can use just as he uses manuscript paper, a piano or a tape-recorder, without any knowledge of computers or mathematics."*

The **composer is a selector**. **Time** is a basic entity: a length of time is specified, then filled with values.

The **hierarchy** decides the order in which the parameters of a note are calculated. If pitch is higher up than instrument, an instrument must be chosen that can play that pitch. Significant compositional decisions concern resolving the **conflicts** these dependencies provoke.

<div class="src">(Koenig, and Berg, Filling time with Xenakis and Koenig)</div>

---

# List, Table, Ensemble

The **List** contains the available values. The values are grouped in a **Table**. A group, or a combination of groups, is chosen for the **Ensemble** with a selection principle. Values are chosen from the Ensemble for the **Score** with another selection principle.

---
class: light
---

# List, Table, Ensemble

<div class="shot"><img src="/figures/list-table-ensemble-000.svg" /></div>

---

# List, Table, Ensemble

The Ensemble changes every eight events by **Series**, and each note is chosen from it by **Alea**. The key is not called `\group`, which an event already uses for the group its synths are placed in.

```supercollider
~list = (48..83);                     // the available values
~table = ~list.clump(6);              // six groups of six

Pbind(\instrument, \bell,
	\ensemble, Pdup(8, Pn(Plazy { Pseq((0..5).scramble) })),     // the ensemble
	\midinote, Pfunc { |event| ~table[event[\ensemble]].choose },  // the score
	\dur, 0.15, \sus, 0.6).play
```

---

# Hierarchy

Instrument above pitch: the instrument is chosen first and the pitch is then chosen from its range. Turned the other way round, the pitch would decide the instrument.

```supercollider
~ranges = (pluck: [40, 60], bell: [72, 96], breath: [55, 75]);

Pbind(\instrument, Prand([\pluck, \bell, \breath], inf),
	\midinote, Pfunc { |event| var range = ~ranges[event[\instrument]]; rrand(range[0], range[1]) },
	\dur, 0.15).play
```

---

# Selection Principles

**Sequence** (a series of values)

**Alea** (random)

**Series** (random with repetition check)

**Ratio** (weighted random)

**Group** (repeating random values)

**Tendency** (random between changing boundaries)

---
class: light
---

# Selection Principles

<div class="shot"><img src="/figures/selection-principles-000.svg" /></div>

---

# Selection Principles

Each principle has a short equivalent in patterns. The list is the same for all six.

- **Sequence**: `Pseq(list)`
- **Alea**: `Prand(list)` or `Pwhite(lo, hi)`
- **Series**: `Pn(Plazy { Pshuf(list) })`, or `Pxrand(list)` which only refuses a direct repeat
- **Ratio**: `Pwrand(list, weights)`
- **Group**: `Pdup(Pwhite(2, 5), Prand(list, inf))`
- **Tendency**: `Pwhite(Pseg(...), Pseg(...))`

The same vocabulary in Berg's **AC Toolbox**: random-value, series-value, ratio, group, tendency, read-from, make-chord, stockpile.

---

# Selection Principles

The six principles over one list, seven events each, one after the other.

```supercollider
~pitches = [43, 48, 45, 50, 52, 47, 39];

~principles = [
	Pseq(~pitches),                                        // sequence
	Prand(~pitches, 7),                                    // alea
	Pshuf(~pitches),                                       // series
	Pwrand(~pitches, [8, 4, 2, 1, 1, 1, 1].normalizeSum, 7), // ratio
	Pfin(7, Pdup(Pwhite(2, 4), Prand(~pitches, inf))),     // group
	Pwhite(Pseries(39, 1, 7), Pseries(43, 2, 7))           // tendency
];

Pbind(\instrument, \pluck,
	\midinote, Pseq(~principles) + 12,
	\dur, 0.15, \sus, 0.8).play
```

---

# Sequence

A **series of values**, in order. Here three sequences of different lengths, which only meet again after 3 × 4 × 5 events.

```supercollider
Pbind(\instrument, \blip,
	\midinote, Pseq([43, 48, 45, 50, 52], inf) + 12,
	\dur, Pseq([0.25, 0.125, 0.125], inf),
	\amp, Pseq([0.2, 0.05, 0.1, 0.05], inf)).play
```

---

# Alea

**Random** selection from a list, with every element equally likely. Collections can be transformed before they are read, and unwanted values can be blocked.

```supercollider
~pitches = [43, 48, 45, 43, 48, 43, 47, 39, 41];
~rhythms = [1, 1/4, 1/5, 1/4, 1/8, 1/2];

Pbind(\instrument, \pluck, \midinote, Prand(~pitches, inf) + 12,
	\dur, Prand(~rhythms, inf)).play;

// collect to transform a list: midi notes to frequencies, an octave up
~frequencies = ~pitches.collect { |item| item.midicps } * 2;
Pbind(\instrument, \sine, \freq, Prand(~frequencies, inf), \dur, Prand(~rhythms, inf)).play;

// block a range of values
Pbind(\instrument, \blip,
	\degree, Pwhite(0.1, 1.0).reject { |item| (item > 0.4) && (item < 0.8) } * 10,
	\dur, 0.1).play
```

---

# Alea

Three notes from two random octaves, and durations rounded to a grid.

```supercollider
Pbind(\instrument, \bell,
	\note, Prand([1, 3, 4], inf),
	\octave, Prand([3, 4], inf),
	\dur, Pwhite(0.08, 0.18).round(0.02)).play
```

---

# Series

**Random with repetition check**: each value comes once, in a random order, before any value comes again. `Plazy` makes a new order every time round.

```supercollider
Pbind(\instrument, \pluck,
	\midinote, Pn(Plazy { Pseq(~pitches.scramble) }) + 12,
	\dur, 0.2).play;

Pbind(\instrument, \sine,
	\freq, Pn(Plazy { Pseq(~frequencies.scramble) }),
	\dur, 0.1).play;

// only a direct repeat is refused
Pbind(\instrument, \blip, \midinote, Pxrand(~pitches, inf) + 24, \dur, 0.1).play
```

---

# Ratio

**Weighted random**. Koenig also called it scattered repetition: some values come back far more often than others.

```supercollider
~weights = [2, 0.2, 2, 0.3, 0.5, 0.5, 1, 0.5, 1].normalizeSum;

Pbind(\instrument, \bell,
	\midinote, Pwrand(~pitches, ~weights, inf) + 24,
	\dur, 0.2).play;

// ratio on the instrument
Pbind(\instrument, Pwrand([\pluck, \bell, \drone], [0.7, 0.25, 0.05], inf),
	\midinote, Prand(~pitches, inf) + 24, \dur, 0.15).play
```

---

# Group

**Repeating random values**. Each value is chosen at random and then repeated, by a fixed number or by a number that is itself random.

```supercollider
~repeats = 4;

Pbind(\instrument, \blip,
	\midinote, Pdup(~repeats, Prand(~pitches, inf)) + 24,
	\dur, 0.15).play;

Pbind(\instrument, \pluck,
	\midinote, Pdup(Pwhite(1, 6), Prand(~pitches, inf)) + 24,
	\dur, 0.1).play
```

---

# Tendency

**Random between changing boundaries**. Both limits are `Pseg` streams that move between levels over five seconds each.

```supercollider
Pbind(\instrument, \blip,
	\midinote, Pwhite(
		Pseg(Pseq([60, 80, 10, 100], inf), Pseq([5, 5, 5, 5], inf)),
		Pseg(Pseq([80, 100, 50, 120], inf), Pseq([5, 5, 5, 5], inf))),
	\dur, 0.1).play
```

---

# Composition Processes

**Interpolation**<br>"from the outer limits of the total form into the inner areas"

**Extrapolation**<br>"from the interior towards the outside: from the individual sound to the group of sounds, thence to the super-groups, via sections to the total form."

**Chronological-associative**<br>"unfolds along the time-axis, thus being put in the position of the ideal listener... every event is given its irremovable place in time"

**Blocks**<br>"a part of a structure which requires complementing by other blocks but which is still complete in itself."

---
class: light
---

# Layers

> "When I made my first electronic piece, which was only four minutes long, I spliced all the sounds onto several four-minute tapes which were then synchronized with the aforementioned "copy head". I thus had the pleasure of hearing my piece emerge layer by layer during this process without having to lift a finger myself."

<div class="fig"><img src="/figures/layers-000.png" /></div>

---
class: light
---

# Layers

> "Music progresses in layers, so to speak, which can be considered as single parameters: rhythm, harmony, melody, dynamics, scoring. These layers run their own formal courses whose ends only coincide after longer form-sections; the shorter the layers and hence the more unexpected their overlapping, the more clearly they articulate one another."

<div class="src">(Koenig)</div>

---

# Layers

Three sustained layers that begin together, end together, or are placed symmetrically, as in the figure.

```supercollider
~layer = { |note, length|
	Pbind(\instrument, \drone, \midinote, note, \sus, length, \dur, Pn(length, 1))
};

// sounds begin simultaneously
Ppar([~layer.(48, 8), ~layer.(55, 5), ~layer.(64, 3)]).play;

// sounds stop simultaneously
Ptpar([0, ~layer.(48, 8), 3, ~layer.(55, 5), 5, ~layer.(64, 3)]).play;

// symmetric superposition
Ptpar([0, ~layer.(48, 8), 1.5, ~layer.(55, 5), 2.5, ~layer.(64, 3)]).play;
```

---

# Layers

Each parameter as its own layer: cycles of 3, 5, 7 and 4 values, which coincide only after 420 events.

```supercollider
Pbind(
	\instrument, Pseq([\pluck, \bell, \blip], inf),
	\midinote, Pseq([60, 63, 67, 70, 72], inf),
	\dur, Pseq([1, 1, 2, 1, 3, 1, 2] / 8, inf),
	\amp, Pseq([0.2, 0.05, 0.1, 0.05], inf),
	\sus, 0.5).play
```

---
class: light
---

# Tendency Mask

<div class="shot"><img src="/figures/tendency-mask-berg-000.png" /></div>

<div class="src">(Paul Berg)</div>

---

# Tendency Mask

A **tendency mask**, after Gottfried Michael **Koenig**: two limits that move over time, with values drawn uniformly between them. `Pseries` moves once per value, which suits a plot. `Pseg` moves in seconds while the pattern plays.

---
class: light
---

# Tendency Mask

<div class="shot"><img src="/figures/tendency-mask-000.svg" /></div>

---

# Tendency Mask

The same mask twice: plotted value by value, and played with limits that move in seconds.

```supercollider
~plotPattern = { |pattern, count = 500|
	pattern.asStream.nextN(count).plot(discrete: true)
};

~plotPattern.(Pwhite(Pseries(0.0, 0.05), Pseries(100.0, -0.05)), 1000);

Pbind(\instrument, \sine,
	\midinote, Pwhite(Pseg([36, 70, 60], [10, 10]), Pseg([96, 72, 62], [10, 10])),
	\dur, 0.05, \amp, 0.1).play
```

---

# Tendency Mask

Koenig's mask has five numbers: **N** parts, **A1** and **A2** for the limits at the start, and **Z1** and **Z2** for the limits at the end. Masks can follow each other.

```supercollider
~mask = { |n, a1, a2, z1, z2|
	Pwhite(Pseries(a1, (z1 - a1) / n, n), Pseries(a2, (z2 - a2) / n, n))
};

~plotPattern.(~mask.(40, 0.45, 0.6, 0.05, 0.95), 40);

Pbind(\instrument, \pluck,
	\midinote, Pseq([~mask.(60, 60, 62, 36, 90), ~mask.(30, 36, 90, 80, 84)]),
	\dur, 0.08).play
```

---
class: light
---

# Tendency Mask

<div class="shot"><img src="/figures/tendency-mask-koenig-000.svg" /></div>

---

# Tendency Mask

<AudioEmbed src="/demos/tendency/" height="26rem" label="tendency mask, interactive" />

---

# Tendency Mask

The line under the editor is the mask written as a pattern. Pasted into a Pbind it plays the same mask, here the **narrowing** preset over twenty seconds.

```supercollider
Pbind(\instrument, \pluck,
	\midinote, Pwhite(Pseg([36, 44, 54, 60, 63], [5, 5, 5, 5]),
		Pseg([100, 92, 80, 70, 65], [5, 5, 5, 5])).round,
	\dur, 1/12, \sus, 0.4).play
```

---

# Variants

**Prototypes** for musical activity are best suited to the forming of **variants**.

**Variants** can be understood as generated **instances** of the same compositional model.

**Project 2** was capable of producing one or more variants of the structure being used.

---

# Variants

In *Übung für Klavier* the performer could choose between three variants for each of the twelve structures.

**Variants** can be understood as being the **actuality** of a **potential form**.

---

# Variants

One model and a seed for each variant. The same seed gives the same variant again.

```supercollider
~model = { |seed|
	Pseed(seed, Pbind(\instrument, \pluck,
		\midinote, Pbrown(48, 72, 3, 24),
		\dur, Prand([1, 2, 3] / 12, inf)))
};

Pseq([~model.(1), ~model.(2), ~model.(1)]).play;

// four structures, and the performer's choice of one of three variants for each
Pseq(4.collect { |structure| Prand(3.collect { |v| ~model.(structure * 3 + v) }, 1) }).play
```

---

# Complex Sounds

**Permeability**<br>How a structure blends with others.

**Susceptibility**<br>How structures complement each other, interpret each other.

**Coalescing**<br>The penetration of two susceptible structures.

**Direct and indirect complexity**<br>How sounds are compared in similarity.

---
class: light
---

# Complex Sounds

<div class="fig tall"><img src="/figures/complex-sounds-000.png" /></div>

---
class: light
---

# Rules

> "Repeated application of a model under changed circumstances makes its limits clearer: accumulation and correlation of the results cause the model to reveal itself and at the same time the extent to which it coincides with a part of musical reality. In this it may even transcend the reality experienced up to that point by exposing context which had escaped analytical scrutiny."

> "The analytical task - given the music, find the rules - is reversed: given the rules, find the music."

<div class="fig"><img src="/figures/koenig-studio-000.png" /></div>

---
class: light
---

# Process and Form

<div class="fig tall"><img src="/figures/process-and-form-000.png" /></div>

---
layout: center
class: divider
---

Xenakis and Koenig

---

# Two Programs

Two programs for **instrumental composition** from the same decade: Xenakis's **Free Stochastic Music Program** (1962), which produced the ST pieces, and Koenig's **Project Two** (1966 to 1968).

Both composers mention the reduction of long calculation times as an advantage: many options can be tried and compared.

They start from different traditions, use randomness differently, and fill time in different ways.

<div class="src">(Berg, Filling time with Xenakis and Koenig)</div>

---
class: light
---

# Exploration

> "Because of certain uncertainties introduced in the program, the composer-pilot can instill his own personality in the sonic result he obtains."

> "The computer does not compose, it merely carries out the orders which it is given ... the computer can help solve problems which previously had to remain unsolved because of the time it took to solve them; for instance, it can combine data to form any number of constellations, thus providing the composer with a clearer survey of the solutions inherent in a problem."

<div class="src">(Xenakis, then Koenig)</div>

---
class: light
---

# Traditions

> "The use of computers is the logical outcome of a historical development. It by no means heralds a new musical epoch: it simply offers a fast, reliable and versatile means of solving problems that already demanded solution."

> "A composer should be original, should create his music uninfluenced by the past."

<div class="src">(Koenig, then Xenakis)</div>

---

# Serialism

**Koenig** is rooted in serialism and extends it: *"serialism is a special case of aleatoric composition"*. Aleatoric procedures come from the serial tradition.

**Xenakis** attacked serialism in *The Crisis of Serial Music* (1955): *"Linear polyphony by its present complexity destroys itself. What one hears is in reality no more than a heap of notes in various registers."*

Xenakis appeals instead to science and philosophy: *"even the basic principles of kinetic gas theory can be found in music"*. Matossian names the difference as his concentration on **modalities of change** and **dynamic processes**, where serial works displayed static geometries.

<div class="src">(Berg, Filling time with Xenakis and Koenig)</div>

---

# Filling Time

**Xenakis**: a work is a succession of sequences whose lengths are independent. Each sequence has a **mean density**, between 0.11 and about 150 sounds a second, and the intervals between attacks are calculated from it. A *"memory"* from sequence to sequence tempers the independence of the densities.

**Koenig**: a length of time is specified and then **filled with values**. The number of values follows from an average density, because a tendency mask needs to know in advance how many parts it is divided into. Time is points on a line, from the structure duration, entry delays, durations and rests.

<div class="src">(Berg, Filling time with Xenakis and Koenig)</div>

---
class: light
---

# Filling Time

<div class="shot"><img src="/figures/filling-time-000.svg" /></div>

---

# Filling Time

The same ten seconds filled twice. Exponential gaps around a mean density, then sixty entry delays chosen by **Alea** and scaled so that they fill the length exactly.

```supercollider
// Xenakis: six onsets a second on average
Pfindur(10, Pbind(\instrument, \pluck,
	\dur, Pfunc { (1 - 1.0.rand).log.neg / 6 },
	\midinote, Pwhite(48, 84))).play;

// Koenig: N points in a length, the pitch inside a tendency mask of N parts
~n = 60;
~delays = ({ [1, 2, 3].choose } ! ~n).normalizeSum * 10;
~delays.sum.postln;   // 10.0
Pbind(\instrument, \pluck,
	\dur, Pseq(~delays),
	\midinote, Pwhite(Pseries(48, 12 / ~n, ~n), Pseries(84, -12 / ~n, ~n))).play
```

---

# Memory

Each section takes its density from the one before, multiplied by a random interval and kept between Xenakis's limits.

```supercollider
~density = 4;
Pn(Plazy {
	~density = (~density * exprand(0.5, 2.0)).clip(0.11, 50);
	~density.round(0.01).postln;
	Pfindur(3, Pbind(\instrument, \blip,
		\dur, Pfunc { (1 - 1.0.rand).log.neg / ~density },
		\midinote, Pwhite(60, 96)))
}, 6).play
```

---

# Interpretation

**Xenakis** changed, edited, arranged and inserted material into the literal results of the program. According to Matossian, 25% of the notes in *Atrées* are not derived from the output, and its sections can be played in any order.

**Koenig**: the time points of Project One required interpretation by the composer. The selection principles of Project Two have formal qualities of their own, and its output does not require interpretation.

Both programs make **realizations of a model**: the ST pieces from one program, variants from one structure in Project Two.

<div class="src">(Berg, Filling time with Xenakis and Koenig)</div>

---
layout: center
class: divider
---

Transition Tables

---

# Transition Tables

*"A collection of conditional probabilities for a particular process is a transition table. The probability density of the next result depends on one or more past results."*

A **first-order** transition table is sufficient to describe a **Markov chain**. Higher-order transition tables are not necessarily Markovian. Other names are transition networks and probability tables.

Various people explored them in the fifties, among them **Hiller**, in Experiment 4 of the *Illiac Suite*.

<div class="src">(Dodge and Jerse, quoted by Berg, Transition tables (sometimes are Markov chains))</div>

---
class: light
---

# Transition Tables

> "Experiments of this type, however, soon lead to the asking of whether there are formal principles of organization more general than the rules of composition involving harmony, counterpoint, and similar techniques."

<div class="src">(Hiller, Experimental Music)</div>

---

# Zero Order

A **zero-order** table looks at no previous values: each value has an **unconditional probability**. The probabilities can be specified, or derived from an existing object such as a melody, a poem or a stockpile.

```supercollider
// specified: 60 with a probability of 0.6, 67 with 0.4
Pbind(\instrument, \pluck, \midinote, Pwrand([60, 67], [0.6, 0.4], inf), \dur, 0.15).play;

// derived from an existing object: how often each value occurs in it
~object = [60, 60, 60, 67, 67, 60, 67, 60, 60, 67];
~values = ~object.asSet.asArray.sort;
~weights = ~values.collect { |v| ~object.occurrencesOf(v) }.normalizeSum;
[~values, ~weights].postln;   // [[60, 67], [0.6, 0.4]]

Pbind(\instrument, \pluck, \midinote, Pwrand(~values, ~weights, inf), \dur, 0.15).play
```

---

# Stepwise Sum

To choose by probability, the elements are laid out on a line from 0 to 1, each taking a length equal to its probability. A uniform random number falls on one of them. Since the number is evenly distributed, there is a 25% chance that it falls below 0.25.

---
class: light
---

# Stepwise Sum

<div class="shot"><img src="/figures/stepwise-sum-000.svg" /></div>

---

# Stepwise Sum

The stepwise sum written out, and the one-word version that SuperCollider already has.

```supercollider
~choose = { |values, weights|
	var r = 1.0.rand, sum = 0;
	values.detect { |v, i| sum = sum + weights[i]; r < sum }
};

~choose.([\a, \b, \c], [0.25, 0.5, 0.25]);

// about 5000 of 10000 are b
({ ~choose.([\a, \b, \c], [0.25, 0.5, 0.25]) } ! 10000).occurrencesOf(\b);

[\a, \b, \c].wchoose([0.25, 0.5, 0.25]);
```

---

# Conditional Probabilities

**Conditional probabilities** consider one or more previous values: what is the probability that after A, B will occur? A **first-order** process considers one previous value, a **second-order** process two, and so on.

When designing a table, care must be taken that every element on the right also occurs on the left. Every value that can come next needs its own row saying what can follow it.

---
class: light
---

# Conditional Probabilities

<div class="shot"><img src="/figures/transition-table-000.svg" /></div>

---

# Conditional Probabilities

Berg's table: four notes, each with the notes that may follow it and their probabilities.

```supercollider
~table = (
	c: [[\g, \f, \e], [0.5, 0.3, 0.2]],
	g: [[\c], [1]],
	f: [[\g, \e], [0.5, 0.5]],
	e: [[\c, \f, \g], [0.2, 0.4, 0.4]]
);
~notes = (c: 48, e: 52, f: 53, g: 55);
~state = \c;

Pbind(\instrument, \bell,
	\midinote, Pfunc { ~state = ~table[~state][0].wchoose(~table[~state][1]); ~notes[~state] },
	\dur, 0.2).play
```

---

# Deriving a Table

A first-order table derived from a melody: every note is listed with the notes that followed it. A note that followed twice is twice as likely.

```supercollider
~melody = [60, 62, 64, 60, 60, 62, 64, 60, 64, 65, 67, 64, 65, 67];

~first = ();
~melody.doAdjacentPairs { |a, b| ~first[a] = (~first[a] ? []).add(b) };
~first.postln;

~note = ~melody[0];
Pbind(\instrument, \pluck, \midinote, Pfunc { ~note = ~first[~note].choose }, \dur, 0.2).play
```

---

# Second Order

A second-order table looks at the last two notes, so more of the melody returns. `Dictionary` compares its keys by their contents, which lets a pair of notes be a key.

```supercollider
~second = Dictionary.new;
(~melody.size - 2).do { |i|
	var key = ~melody[i..i + 1];
	~second[key] = (~second[key] ? []).add(~melody[i + 2]);
};

~last = ~melody[0..1];
Pbind(\instrument, \pluck,
	\midinote, Pfunc { var next = ~second[~last].choose; ~last = [~last[1], next]; next },
	\dur, 0.2).play
```

---

# Transition Tables

A table on the durations beside the derived table on the pitches. The two are independent, as the parameters of Project One are. Here the table holds indices into a list of durations.

```supercollider
~durs = [0.1, 0.2, 0.4];
~next = [[0, 0, 1], [0, 2], [0]];   // what may follow each duration, by index
~d = 0;

Pbind(\instrument, \blip,
	\midinote, Pfunc { ~note = ~first[~note].choose } + 12,
	\dur, Pfunc { ~d = ~next[~d].choose; ~durs[~d] }).play
```

---

# Next Steps

- Run *Koenig.scd* from the top. It holds every example from the slides, in order
- Play every example with a different **instrument**, and change `\sus` and `\slide`
- Change the **branching table** of the Project One example and listen to the seven sections
- Give each parameter of one Pbind its own **selection principle**
- Draw a **tendency mask** in the Tendency Mask tool, then write it with `~mask` or with `Pseg`
- Derive a **transition table** from a melody you know, first order and then second order

---
layout: center
class: divider
---

Exercises

---

# Exercises

Twenty-five short ones first, each a small step from the one before. Then the seven longer ones, numbered on from 26. *Exercises.scd* has all of them with space to write, and *Koenig.scd* has the SynthDefs.

---

# Selection Principles

1. Play the list `[60, 62, 63, 65, 67, 68, 70]` as a **Sequence**, then as **Alea**.
2. Play the same list as a **Series**: every value once in a random order, with a new order each time.
3. Play it as **Ratio**, with the first two values much more likely than the rest.
4. Play it as **Group**: each random value repeated between two and five times.
5. A **Tendency** between limits that start at 60 and 62 and widen to 36 and 96 over twenty seconds.
6. One Pbind with a different selection principle for pitch, duration and instrument.

---

# Combined with Earlier Classes

7. A `Pseq` of three Pbinds of eight notes, each using a different selection principle for pitch.
8. The **Streichquartett** method: choose four of seven pitches, repeat each one to five times, scramble and play.
9. A Gaussian pitch, `Pgauss`, whose mean follows a `Pseg` from 48 to 84 over fifteen seconds.
10. **Ratio** for the durations and a random walk, `Pbrown`, for the pitch.
11. The same Pbind played three times in a row with `Pseed` and the seeds 1, 2 and 1.
12. Three Pbinds in `Ppar` with `Pseq` cycles of three, four and five pitches.

---

# Instruments

13. One phrase played by each of the seven instruments in turn, using `Pdup` on the instrument.
14. Choose the instrument by **Ratio**: mostly `\pluck`, sometimes `\bell`, rarely `\drone`.
15. Give `\drone` a `\sus` of 3 and a Gaussian `\slide` around 0, with a new note every second.
16. Glissandi on `\drone` between the five **Terminus** frequencies, so that none leaves the range.

---

# Koenig's Programs

17. Use `~regularity` on the same list with the values 1, 4 and 7, one after the other.
18. **List, Table, Ensemble**: group 24 pitches with `clump(4)`, choose a group every eight events and a pitch from it every event.
19. Three `\drone` layers of different lengths in `Ptpar` that **end together**.

---

# Transition Tables

20. Derive the zero-order weights of a melody of your own and play it with `Pwrand`.
21. Write a first-order table for four notes in which every note can follow every other but not itself.
22. Derive a first-order table from a melody with `doAdjacentPairs` and play it on `\bell`.
23. Change 22 to a second-order table and compare how much of the melody returns.

---

# Xenakis and Koenig

24. Fill ten seconds with exponential gaps around a density of 8, then with 80 entry delays chosen by **Alea** and scaled to fill the same ten seconds.
25. Draw a mask in the **Tendency Mask** tool, copy the pattern under it into a Pbind and play it on `\pluck`.

---

# Exercises

26. Create three **collections** of pre-selected pitches and a process that will play first some events from the first collection, then some from the other and finally some from the third. The way notes are selected should be different at each time.

27. Create a process consisting of two **layers** where one plays low notes and the other high notes. A **tendency mask** should be created for controlling the balance between the two processes. It should start by favouring high notes and end towards low ones.

28. Create a **chord progression** where the duration of each chord increases in time. The pitches that form the chords should be selected from a predefined group(s) of pitches.

---

# Exercises

29. Implement a process that selects **durations** from a collection of predefined durations (rhythmic values). To the selected duration a variable number should be added each time. This number should be very small in the beginning of the process but increase as it unfolds.

30. Implement a **tendency mask** for frequency and duration values where the high and low boundaries are determined by a **random walk**.

31. Implement a sequence of **chords** where the number of notes a chord consists of is low at the start of the process but increases as it unfolds.

32. Implement a stochastic process where the **high and low limits** of a distribution change in time. They should start by being very wide, far apart, but narrow as the process unfolds.

<span class="workshop">- workshop -</span>
