---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 02 SuperCollider
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

<div class="deck-title">SuperCollider</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>
---

# SuperCollider

**SuperCollider** is an environment for real time audio and composition.

**SuperCollider** consists of an interpreted object-oriented language and a state of the art realtime sound synthesis server.

**SuperCollider** supports different activities such as sound synthesis, digital signal processing, algorithmic composition, live electronics and live coding.

<span class="note">**SuperCollider** is open source and free software, released under the terms of the GNU General Public License.</span>

---

# SuperCollider

<div class="plate"><img src="/figures/screens-001.png" /></div>

---

# SuperCollider

<div class="plate"><img src="/figures/screens-002.png" /></div>

---
class: light
---

# SuperCollider

<div class="fig tall"><img src="/figures/website-000.png" /></div>

<div class="src">(http://supercollider.github.io)</div>

---

# Design Goals

To realize sound processes that are different every time they are played.

To write pieces in a way that describes a range of possibilities rather than a fixed entity.

To facilitate live improvisation by a composer/performer.

<span class="note">(McCartney, Rethinking the Computer Music Language: SuperCollider)</span>

---

# About

The **SuperCollider language** is based on **Smalltalk** and is used for creating programs that communicate with the **synthesis server** in order to make sounds.

**Unit Generators (UGens)** are used for generating and processing audio signals within the synthesis server. Interconnected UGens are packaged into a **SynthDef** that describes which UGens are used and how they connect.

<span class="note">The **objects** of the SuperCollider language objects together data and methods that act on that data.</span>

---

# Running Code

```supercollider
s.boot;  // start the server

{ SinOsc.ar(440) * 0.1 ! 2 }.play;
```

Put the cursor in a line and press **Cmd+Return**. 


```supercollider
(
a = 100;
{ Blip.ar(a) * 0.2 }.play
)
```

For a block wrapped in parentheses, put the cursor inside it and press **Cmd+Return**, that evaluates the whole block.

**Cmd+.** stops every sound immediately. It is important to remember and does not delete anything.

<span class="note">`Cmd+D` on any class name opens its help file, and every help file has runnable examples.</span>

---

# Sounds

`SinOsc` is one partial; `Saw` is every harmonic.

```supercollider
s.boot;

{ SinOsc.ar(220) * 0.2 ! 2 }.play;  // one partial

{ Saw.ar(220) * 0.1 ! 2 }.play;     // every harmonic
```

<span class="note">Open `s.freqscope` before running either line.</span>

---

# Oscillators

Sweep the frequency instead of fixing it, and the two shapes sound differently.

```supercollider
{ SinOsc.ar(XLine.kr(100, 2000, 8)) * 0.2 ! 2 }.play;

{ Saw.ar(XLine.kr(100, 2000, 8)) * 0.1 ! 2 }.play;
```

The sine stays the same shape at any pitch. 

The saw's harmonics spread further apart as it rises, so it brightens on top of getting higher.

---

# Feedback

The output of a graph read back into its own input, one block later.

```supercollider
(
x = { var sig, mod1, mod2, mod3;
	mod3 = LocalIn.ar(2) * LFNoise0.kr(8 ! 2).exprange(5, 500);
	mod2 = SinOsc.ar(3, mul: mod3);
	mod1 = SinOsc.ar(800 + mod2, mul: mod3);
	sig = SinOsc.ar([500, 501] + mod1);
	LocalOut.ar(sig);
	sig * 0.1;
}.play;
)

x.release(2);
```

Five lines but the result is not predictable from reading them. An important attraction but also a risk.

---
class: light
---

# Three Programs

<div class="shot"><img src="/figures/three-programs-000.svg" /></div>

---
class: light
---

# Architecture

<div class="shot"><img src="/figures/lang-server-000.svg" /></div>

---

# Arrays

Provide a UGen an array instead of a number and the graph quietly builds one copy per element.

```supercollider
// six pulse waves at once, through one filter sweep
{ RLPF.ar(Pulse.ar([10, 25, 80, 9, 4, 3], 0.5, 0.1), XLine.kr(8000, 400, 5), 0.05) }.play;
```

Six frequencies where the low ones arrive as rhythm and the high ones as pitch.

---

# Excitation and Resonance

A resonator has no sound of its own. It needs to be struck.

```supercollider
// Dust fires at random times; Ringz rings at whatever frequency it is given
{ Ringz.ar(Dust.ar(6) * 0.4, LFNoise0.kr(6).exprange(100, 4000), 0.6) ! 2 * 0.5 }.play;
```

The struck-object family of sounds comes almost entirely from this pair: something short and broad, and something narrow that rings.

---

# Gendy

Xenakis's dynamic stochastic synthesis, as a single UGen.

```supercollider
{ Gendy1.ar(1, 1, 1, 1, 60, 180, 0.6, 0.4, 12, 12, 0.25) ! 2 }.play;
```

Twelve control points, each with an amplitude and a duration. Every cycle, each one takes a small random step, bounded so it cannot leave the range. The waveform is whatever the points currently spell, and it is never quite the same twice.

<span class="note">No oscillator shape was chosen here. The shape is the output of a process.</span>

---

# A Signal Chain

<AudioEmbed src="/demos/chain/" height="23rem" label="a signal chain, interactive" />

<span class="note">A Gendy into a filter into a comb delay, with one oscillator wired to the cutoff rather than to the output.</span>

---
class: light
---

# Seeing What You Hear

<div class="shot"><img src="/figures/monitoring-000.svg" /></div>

---

# Inside the Server

<div class="plate"><img src="/figures/inside-server-000.svg" /></div>

---
layout: center
class: divider
---

Instruments

---

# SynthDef

Everything so far was a function played once. A **SynthDef** is the same graph, sent to the server, named, and given arguments that can differ between one copy and the next.

```supercollider
(
SynthDef(\blip, { |freq = 440, amp = 0.2, dur = 0.3, pan = 0, harm = 12|
	var env = EnvGen.kr(Env.perc(0.002, dur), doneAction: 2);
	var sig = Blip.ar(freq, harm) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

Synth(\blip, [\freq, 330]);
Synth(\blip, [\freq, 660, \harm, 40, \pan, -0.7]);
```

<span class="note">`Blip` is a band-limited pulse: `harm` is how many harmonics it has, and it never aliases. `doneAction: 2` frees the node when the envelope ends, and without it the server accumulates nodes until it runs out.</span>

---
class: light
---

# SynthDef and Synth

<div class="shot"><img src="/figures/synthdef-synth-000.svg" /></div>

---

# Patterns

The instrument does not decide when it plays, or on what. A **Pbind** is a stream of events, one per note, and each key can be its own pattern.

```supercollider
(
Pbind(
	\instrument, \blip,
	\dur, Prand([0.06, 0.06, 0.09, 0.18], inf),
	\freq, Pexprand(90, 3000) * Prand([1, 1.031, 1.414, 2.377], inf),
	\harm, Pwhite(4, 60),
	\pan, Pwhite(-0.9, 0.9),
	\amp, 0.12
).play;
)
```

<span class="q">Nothing in the SynthDef changed. So where is the piece?</span>

---

# Resources

**Supercollider home page** https://supercollider.github.io/

**Original Supercollider home page** http://www.audiosynth.com

**Code examples** http://sccode.org

**Forum** https://scsynth.org

**The Supercollider book** https://mitpress.mit.edu/books/supercollider-book

**Eli Fieldsteel's video tutorials** https://www.youtube.com/user/elifieldsteel

**Reflectives** https://www.youtube.com/channel/UCypLRZiSlIQjsT_7J4Vz35Q

---

# Resources

**A Gentle Introduction to SuperCollider, CCRMA** https://ccrma.stanford.edu/~ruviaro/texts/A_Gentle_Introduction_To_SuperCollider.pdf

**Mapping and visualization with SuperCollider** http://marinoskoutsomichalis.com/mapping-and-visualization

**Nick Collins tutorial** https://composerprogrammer.com/teaching/supercollider/sctutorial/tutorial.html

**Thor Magnusson tutorial** http://www.ixi-software.net/content/body_backyard_tutorials.html

**Stelios Manousakis course** http://modularbrains.net/portfolio/supercollider-real-time-interactive-course-sc-code/

**Fredrik Olofsson tutorials** http://www.fredrikolofsson.com/pages/code-sc.html

---
class: light
---

# Resources

<div class="fig tall"><img src="/figures/awesome-000.png" /></div>

<div class="src">(Awesome SuperCollider, https://github.com/madskjeldgaard/awesome-supercollider)</div>

---
layout: center
class: divider
---

Exercises

---

# Exercises

1. Add two sine waves a few hertz apart and find the two frequencies where the beating stops being a rhythm and becomes a tone.

2. Build a spectrum by adding **eight** sine waves, then give each one its own amplitude so the result no longer sounds like a machine.

3. Filter a saw wave with `RLPF` at a fixed cutoff. Then lower the resonance argument until the filter starts to sing at the cutoff frequency.

4. Replace that fixed cutoff with an `LFO`, and find a rate at which the movement stops being heard as a filter and starts being heard as a rhythm.

5. Use the same `LFO` on three destinations in turn: amplitude, frequency, and filter cutoff. Say which one changes the sound most.

---

# Exercises

6. Drive one parameter with `LFNoise0` and the same parameter with `LFNoise1` at the same rate, one in each ear, and describe the difference in one sentence.

7. Map `MouseX` to a frequency and `MouseY` to a filter cutoff. Find the corner of the screen where the sound is most interesting, and write down the two numbers.

8. Take a `CombC` and move its delay time from 200 ms down to 2 ms while it sounds. Name the delay time at which the echo became a pitch.

9. Tune a `CombC` so that it rings at a note you choose, by working the delay time out from the frequency rather than by ear.

10. Combine four of the above into one line that you would be willing to play to the room, and be able to say what every number in it does.

<span class="note">Worked answers for all ten are in *Solutions.scd*, including the numbers the exercises ask you to name.</span>

<span class="workshop">- workshop -</span>
