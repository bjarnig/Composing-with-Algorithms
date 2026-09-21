---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 03 Patterns
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

<div class="deck-title">Patterns</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---

# A First Pattern

Before any of it is defined.

```supercollider
s.boot;

Pbind(\degree, Pseq([0, 2, 4, 5], inf), \dur, 0.25).play;

// one word changed, and it is a different piece
Pbind(\degree, Prand([0, 2, 4, 5], inf), \dur, 0.25).play;
```

<span class="q">Neither line says what to play, only how to choose.</span>

---
layout: center
class: divider
---

Patterns and Streams

---

# Patterns

Patterns describe calculations without an explicit definition of every step of a musical process.

Patterns represent a **higher-level view** of a computational task.

Patterns allow a composer to focus on parameters, relationships and behaviour of musical materials instead of having to focus on detailed implementation.

Patterns allow to define **what** should happen instead of **how** exactly it happens.

---

# Patterns and Streams

Patterns can be seen as **templates**. Patterns define behaviour, and **streams** execute the behaviour.

Patterns are **stateless**: their definition does not change over time. A stream is what keeps track of where we are in the pattern's temporal evaluation.

A pattern does not have any knowledge of a current state, so it cannot proceed in time or go backwards in time. Invoking `asStream` creates a stream specified by a pattern, and that stream can be advanced by calling `next`.

A pattern specification can result in **multiple instances** of a stream.

---
class: light
---

# Patterns and Streams

<div class="shot"><img src="/figures/pattern-stream-000.svg" /></div>

---

# Streams

```supercollider
p = Pseq([0, 2, 4, 7], 2);     // a description, and it makes no sound

q = p.asStream;                // one reading of it
q.next; q.next; q.next;        // 0, then 2, then 4

r = p.asStream;                // a second reading, back at the beginning
r.next;                        // 0

q.all;                         // everything a finite stream has left
```

`Routine` and `Task` are subclasses of `Stream`. A stream uses **lazy evaluation**: a value is produced only when it is asked for, which is why a stream can be infinite.

---
layout: center
class: divider
---

Choosing

---

# List Patterns

- `Pseq(list, repeats, offset)` goes through a list linearly
- `Pser(list, repeats, offset)` plays through the list as many times as needed
- `Prand(list, repeats)` chooses items from the list randomly
- `Pxrand(list, repeats)` chooses randomly, but without repetition
- `Pshuf(list, repeats)` shuffles the list into a random order
- `Pwrand(list, weights, repeats)` chooses randomly with weighted probabilities
- `Pwalk(list, stepPattern, directionPattern, startPos)` is a random walk

---
class: light
---

# The Same List, Five Ways

<div class="shot"><img src="/figures/five-readings-000.svg" /></div>

---

# The Same List, Five Ways

The synth never changes. Only the stance does.

```supercollider
~notes = [0, 2, 4, 7, 9];

Pbind(\degree, Pseq(~notes, inf),  \dur, 0.2).play;   // in order
Pbind(\degree, Prand(~notes, inf), \dur, 0.2).play;   // any one, each time
Pbind(\degree, Pxrand(~notes, inf), \dur, 0.2).play;  // any but the last
Pbind(\degree, Pshuf(~notes, inf), \dur, 0.2).play;   // shuffled once, then looped
Pbind(\degree, Pwhite(0, 9),       \dur, 0.2).play;   // any number in the range
```

<span class="q">`Pshuf` decides once and `Prand` decides every time. </span>

---

# Stochastic Patterns

- `Pwhite(lo, hi, length)` random numbers with equal distribution
- `Pexprand(lo, hi, length)` an exponential distribution, favouring lower numbers
- `Pbrown(lo, hi, step, length)` Brownian motion, where a value adds a random step to the previous value
- `Pbeta(lo, hi, prob1, prob2, length)` a beta distribution, where prob1 is α and prob2 is β
- `Pcauchy(mean, spread, length)`, `Pgauss(mean, dev, length)`, `Ppoisson(mean, length)`

<span class="note">The distribution is the composition. A uniform choice and an exponential choice over the same range are different pieces.</span>

---

# Series and Constraint

- `Pseries(start, step, length)` an arithmetic series, adding `step` each time
- `Pgeom(start, grow, length)` a geometric series, multiplying by `grow`
- `Pseg(levels, durs, curves, repeats)` interpolates towards the next value
- `Pkey(key)` reads a key already calculated in this event, so one value can be derived from another
- `Pfunc(nextFunc, resetFunc)` the next value is whatever the function returns
- `Pn(pattern, repeats)` and `Pfin(count, pattern)` control repetition and length

---

# Parallel Patterns

- `Ppar(list, repeats)` starts each of the event patterns at the same time
- `Ptpar(list, repeats)` starts them with an offset
- `Pgpar(list, repeats)` is like `Ppar` but gives each subpattern its own group
- `Pspawner(routineFunc)` and `Pspawn(pattern, spawnProtoEvent)` build patterns that start other patterns

```supercollider
Ppar([
	Pbind(\instrument, \sine,  \freq, Pseq([300, 400, 500], inf), \dur, 0.25, \amp, 0.08),
	Pbind(\instrument, \pluck, \note, Prand([48, 52, 55], inf),   \dur, 0.75, \amp, 0.15)
]).play;
```

---
layout: center
class: divider
---

Pbind

---

# Pbind

`Pbind` is a way to give **names** to values coming out of patterns.

When one asks a `Pbind` stream for its next value, the result is an object called an **Event**. Like a Dictionary, an event is a set of key and value pairs.

The `Event` class provides a default event prototype that includes powerful options to create and manipulate objects on the server, and it can be extended with custom configurations.

---
class: light
---

# An Event Reaching a Synth

<div class="shot"><img src="/figures/event-synth-000.svg" /></div>

---

# Pbind

```supercollider
(
Pbind(
	\instrument, \sine,              // which SynthDef
	\freq, Pwhite(200, 900),         // an argument of that SynthDef
	\amp, Pseq([0.1, 0.05], inf),    // another one
	\dur, 0.15                       // not an argument: the wait before the next event
).play;
)
```

A key is sent to the synth when its name matches one of the SynthDef's arguments. Everything else belongs to the event, which uses it to work out timing or to calculate a value before sending it.

<span class="note">`\degree` works without any SynthDef at all, because the default event has one.</span>

---

# Event Keys

**Pitch**, calculated in this order and each step settable directly:

<span class="mono">degree &rarr; note &rarr; midinote &rarr; freq &rarr; detunedFreq</span>

`scale`, `stepsPerOctave`, `octave`, `root` and `octaveRatio` turn a degree into a note, `mtranspose`, `gtranspose` and `ctranspose` transpose at each of the three stages, and `harmonic` and `detune` adjust the frequency at the end.

**Time**: `dur`, `stretch`, `legato`, `sustain`, `lag`, `strum`, `tempo`

**Level**: `amp`, `db`, `velocity`, `pan`

**Destination**: `instrument`, `out`, `group`, `addAction`, `server`

<span class="note">Setting an end key stops everything above it from being used. If `\freq` has a value then `\degree` no longer has any effect.</span>

---
layout: center
class: divider
---

Instrument and Score

---
class: light
---

# Instrument and Score

<div class="shot"><img src="/figures/instrument-score-000.svg" /></div>

---

# Replacing While It Sounds

`Pdef` holds a pattern under a name. Evaluate a new definition and the next event comes from it, with no gap.

```supercollider
Pdef(\a, Pbind(\instrument, \sine, \freq, Pseq([300, 400], inf), \dur, 0.25, \amp, 0.1)).play;

// re-evaluate this with the first still sounding
Pdef(\a, Pbind(\instrument, \sine, \freq, Pexprand(200, 2000), \dur, 0.08, \amp, 0.08));

Pdef(\a).stop;
```

<span class="note">This is the practical reason to name patterns and will be show in more detail later.</span>

---

# A Family From One Function

A function that returns a pattern is a piece with parameters rather than a fixed piece.

```supercollider
(
~phrase = { |scale = #[0, 2, 4, 7, 9], tempo = 0.2, density = 1|
	Pbind(\degree, Prand(scale, inf), \dur, tempo / density, \amp, 0.08)
};
)

~phrase.value.play;
~phrase.value(#[0, 1, 5, 6, 10], 0.3, 2).play;
~phrase.value(#[0, 3, 7], 0.5, 4).play;
```

---
class: light
---

# Daniel M Karlsson

A Swedish composer who works almost entirely in SuperCollider, and who publishes all of his code.

His pieces are built as **patterns**. The score is a `.scd` file, the sound comes from his own sampler library **SuperClean**, and the whole piece runs live each time it is played.

*towards a music for large ensemble (acts I to VI)* is made of **sixty-four `Pdef`s**, numbered 0 to 63. Two factory functions build every one of them, so the piece is a single `Pbind` template instantiated sixty-four times with different arguments.

A routine on top decides how many voices sound at once: between 5 and 36 sustained, and between 5 and 11 onsets.

<span class="note">The code is at <a href="https://codeberg.org/t36s/superclean-code/raw/branch/main/towards-GRM-at-Sonic-Acts.scd" target="_blank">codeberg.org/t36s/superclean-code</a>. He suggested this piece for the class and it is featured with his permission.</span>

---
class: light
---

# Towards a Music for Large Ensemble

<div class="shot"><img src="/figures/karlsson-bandcamp-000.png" /></div>

<div class="src">(danielmkarlsson.bandcamp.com, six acts of about 24 minutes, released March 2026)</div>

---
class: light
---

# DMK Approach

> "Generally I really like how working with the Patterns paradigm for the most part lets me write code that is very similar to what I teach others to write on day one. I don't want for there to be any hierarchical difference between myself and anyone else who is interested in my music or more broadly in the task of organizing sound."

> "My favorite situation is when I can get someone sat up to have their computer run my smol Pattern code block and for them to then potentially listen to it forever and or get started making their own personal expressive imagining of just how weird music could potentially could get if we all supported each other in that endeavor."

<div class="src">(Daniel M Karlsson, written for this class, September 2026)</div>

---
class: light
---

# Sixty-Four Sources

<div class="fig tall"><img src="/figures/karlsson-cover-000.jpg" /></div>

<div class="src">(the cover names sixty-four recorded instruments and objects)</div>

---
class: light
---

# Sixty-Four Voices with Pbind

<div class="src">(Daniel M Karlsson, towards-GRM-at-Sonic-Acts.scd, abridged)</div>

```supercollider
~a = { |type, snd, spd, num, bgn, atk, octave, degree, aux, cav, amp|
	Pseq([ Pbind(*[
		pan: Pmeanrand(0.1, 0.9),
		hld: Plprand(39.0, 59.0),          // held for 39 to 59 seconds
		rel: Phprand(31.0, 51.0),
		crv: Phprand(1.0, 4.0),
		crt: Pkey(\crv).neg,               // one curve, and its opposite
		dur: Pkey(\atk) + Pkey(\hld) + Pkey(\rel) / Pexprand(1.75, 4.0),
		scale: Pdup(Plprand(55, 111), Pxshuf([
			Scale.harmonicMinor(\sept2), Scale.ionian(\just),
			~slnd.scale, ~bal5.scale, ~dip7.scale ], inf)),
		amp: amp ]) ], inf)
};

Pdef(00, ~c.(..., \bbu, 1, Pfunc({ ~bbuNum.next }), 0, 0, 5, 0, ...));
```

Note what is a pattern here: not only pitch and amplitude but the **scale itself**.

<span class="note">`\bbu` is the second name on the cover: each `Pdef` sequences one instrument's recordings.</span>

---
class: light
---

# Leaving the Paradigm

> "Specifically though, this particular example of my working with Patterns got a lil messy. There where some things that I really wanted to be able to control on a kind of macro level that made it so I had to dip outside of the Pattern paradigm to get it working the way I wanted. Sadly this makes this material a little less approachable as a social or even pedagogical material."

> "Also instead of synthesis what is being sequenced is a heap of sound files that I recorded of me playing a bunch of acoustic instruments and objects in various ways. These sound files constitute a lot of data, many GigaBytes in fact, which also decreases portability which I find sad."

> "Pdef + Bind combo 4 lyfe!"

<div class="src">(Daniel M Karlsson, written for this class, September 2026)</div>

---

layout: center
class: divider
---

Why Patterns

---

# Algorithmic Composition

Composing music, sounds and behaviour using algorithms and computer programs. Possible methods for doing this include:

**Randomness**, **stochastic processes**, **selection principles**, **Markov chains**, **random walks**, **grammars** and **genetic algorithms**.

<span class="note">All of these can be realised using the Pattern library in SuperCollider, and most of them are a class of their own later in the year.</span>

---

# Approaches with Patterns

Two opposite poles for composition are the **top-down** approach and the **bottom-up** approach.

A top-down model is often specified with the assistance of black boxes, which can later be edited, replaced or upgraded without destroying the whole model or process.

Patterns in SuperCollider specify **behaviour instead of details**. This means they are ideal to experiment with top-down approaches and methods that combine patterns or blocks of patterns.

---

# Composing with Parameters

A **parameter** is one of the variables that controls the outcome of a system. Attributes of a process are converted to values representing its state.

Parametrical thinking enables limits, boundaries, **parameter spaces** and mapping from one to the other. Parameter mappings include one-to-many, many-to-one and many-to-many.

Patterns in SuperCollider relate generative behaviour to a synthesis or sound process parameter.

---

# Why Patterns

The code is shorter and cleaner.

Patterns are tested, and their behaviour works as specified, as opposed to a custom user process which could contain bugs.

Patterns are specified in a well-defined format and are easy to read.

There are over **150** different patterns covering many complex use cases, and they can also be extended.

Patterns allow us to focus on abstract but meaningful attributes instead of implementation details.

---

# Thinking in Patterns

Patterns can be seen as a different way of expressing musical thought, describing **behaviour** rather than precise orders.

A focus on the representation means that the implementation could be done in another class library, or even in another programming language.

Describing musical procedures using patterns requires much exercise and thinking, since it differs from traditional approaches.

A potential first step is to **modularise events** and then build up.

---

# Next Steps

- Run *Patterns.scd*, then change one pattern class at a time in the same Pbind
- Take a phrase you like and wrap it in `Pdef`, then alter it while it plays
- Put a Pbind inside a function with three arguments, and call it three times
- Write one Pbind that uses `Pkey`, so one key is derived from another

<span class="note">The code files are *Patterns.scd*, *SynthDefs.scd*, *Functions.scd*, *Environment.scd* and *Sequences.scd*.</span>

---
layout: center
class: divider
---

Exercises

---

# Exercises

1. Create a Pbind sequence that consists of **4 different durations** and 4 different frequencies.

2. Create a Pbind sequence where duration, frequency and amplitude are **randomly determined**.

3. Create a Pbind sequence where frequency goes **up** in time while amplitude goes **down**.

4. Create a sequence of at least **2 different Pbinds** that are different in some way.

5. Take one list of five notes and play it with `Pseq`, `Prand`, `Pxrand` and `Pshuf` without changing anything else. Say which one you would use for a bass line, and why.

---

# Exercises

6. Use `Pwhite` and then `Pexprand` over the **same range** for the same parameter. Describe the difference in one sentence.

7. Write a Pbind where one key is derived from another with `Pkey`, so that high notes are short and low notes are long.

8. Build a phrase with `Pdef`, then replace it while it sounds so the change is heard as a transition rather than as a stop and a start.

9. Put a Pbind inside a function with **three arguments**, call it three times with different values, and keep the call you like best.

10. Use `Ppar` to run two Pbinds at once where one is clearly the foreground and the other is clearly the background, and say what makes the difference.

<span class="workshop">- workshop -</span>
