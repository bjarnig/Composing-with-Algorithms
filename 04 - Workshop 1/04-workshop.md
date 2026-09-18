---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 04 Workshop 1
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

<div class="deck-title">Workshop 1</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---

# Format

Ten tasks are described that need implementation with **patterns** and simple synthesis.

Students shall work in **groups** to solve at least some of the tasks during class.

The final **30 minutes** of class should involve a short presentation of each group where they show or discuss what they have done.

<span class="note">Not every task, and not perfectly. Three that sound, and that you can explain, beat ten that half work.</span>

---

# One Constraint

Before the tasks, agree three things in your group and write them at the top of the file.

- A **duration**. Eight seconds, or two minutes. The piece ends when it ends.
- **One sound source**. The sine below, or one SynthDef you write in the first ten minutes.
- **One prohibition**. Something you are not allowed to use, chosen by you.

<span class="q">A constraint you chose is not a limitation. What did the prohibition force you to find?</span>

---

# The Synth

For today best use the simple sine synth, or the default one.

```supercollider
SynthDef(\sine, { |amp = 0.1, freq = 440, pan = 0|
	var env, sig;
	env = EnvGen.kr(Env.perc, doneAction: 2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;
```

---

# Binding It

Then use `Pbind` to bind the synth to compositional patterns. The parameters `\freq` and `\amp` should match the ones of the Synth. `\dur` is an exception, since it concerns the duration of an event.

```supercollider
Pbind(
	\instrument, \sine,
	\freq, Pseq([100, 800, 600], inf),    // 3 frequencies are repeated
	\amp, Env([0.0, 1.0, 0.0], [3, 4]),   // volume goes from 0 to 1 and to 0 again
	\dur, Pwhite(0.05, 0.1)               // each note lasts from 50 to 100 ms
).play
```

<span class="note">An `Env` given to a key is read over time in seconds, which is how a pattern gets a shape rather than a value.</span>

---
layout: center
class: divider
---

Tasks

---

# Tasks

1. Implement a process where a synth is played first very fast and then very slowly. The duration pattern should alternate between the two types of duration. <span class="note">(hint: see `Pseq` with nested patterns)</span>

2. Implement a process that plays two synths interchangeably, where the probability of synth a is 25% and event b is 75%. <span class="note">(hint: see `Pwrand` for weighted randomness)</span>

3. Implement a stochastic process where low pitches have a longer duration than high ones. <span class="note">(hint: see `Pkey` to couple parameters)</span>

---

# Tasks

4. Implement a process based on two or more layers, where moments occur with all layers playing at the same time and others with only a single layer playing. <span class="note">(hint: see `Ppar` for parallel patterns)</span>

5. Implement a sequence where pitches are chosen randomly. The randomness should be very wide in range in the beginning but decrease and settle once it continues. <span class="note">(hint: see `Penv` or simply `Env` for gradual shapes)</span>

6. Implement a process with various layers, where each layer appears and later disappears gradually. <span class="note">(hint: see `Penv` or simply `Env` for gradual shapes)</span>

---

# Tasks

7. Implement a process that oscillates between random values and repeated ones. <span class="note">(hint: see `Pstutter` for repeating values)</span>

8. Implement a sequence of two layers, both using brownian motion for pitch and duration values. One layer should stop before the other. <span class="note">(hint: see `Pbrown` for brownian motion)</span>

9. Implement a process with at least three layers, where moments occur where all are playing but also where each one plays individually. <span class="note">(hint: see `\rest` for rest values)</span>

---

# Tasks

10. Implement a process where pitch values are determined either according to a **cauchy** or an **exponential** distribution. Dynamics should be determined with a geometric rise. <span class="note">(hint: see `Pcauchy`, `Pexprand` and `Pgeom`)</span>

<span class="q">Of the ten, which one produced something you would keep?</span>

---

# Presenting

Thirty minutes at the end, a few minutes per group. Play the thing, then say:

- Which task it answers, and what you changed to make it yours
- What the **prohibition** was, and what it forced
- One line of the code you would show someone else

<span class="note">Worked answers to all ten are in *Workshop1.scd*, and they are worth reading after you have tried, not before.</span>
