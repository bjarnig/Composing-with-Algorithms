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

# Modulation

One oscillator multiplying another, with the modulator's frequency swept from 1 Hz to 150 Hz over eight seconds.

```supercollider
s.boot;

// amplitude modulation: the modulator stays positive
{ var m = SinOsc.ar(XLine.kr(1, 150, 8)).range(0, 1);
  (SinOsc.ar(750, mul: m) * 0.2) ! 2 }.play;

// ring modulation: the same thing, but the modulator crosses zero
{ var m = SinOsc.ar(XLine.kr(1, 150, 8));
  (SinOsc.ar(750, mul: m) * 0.2) ! 2 }.play;
```

<span class="q">At what point did the rhythm stop being a rhythm?</span>

---

# Modulation

The third case adds the modulator to the frequency instead of multiplying the amplitude.

```supercollider
// frequency modulation
{ var m = SinOsc.ar(XLine.kr(1, 150, 8), mul: 300);
  (SinOsc.ar(750 + m) * 0.2) ! 2 }.play;
```

Three lines, one changed word each time, and three different families of sound. The sweep crosses the same threshold in all three: below about 20 Hz the ear counts events, above it the ear hears a tone.

<span class="note">That threshold is the subject of class 11, and it is where granular synthesis lives.</span>

---
class: light
---

# Three Programs

<div class="shot"><img src="/figures/three-programs-000.svg" /></div>

---

# Running Code

```supercollider
s.boot;                 // start the server, once per session

{ SinOsc.ar(440) * 0.1 ! 2 }.play;
```

Put the cursor in a line and press **Cmd+Return**. For a block wrapped in parentheses, put the cursor inside it and press **Cmd+Return**, which evaluates the whole block.

**Cmd+.** stops every sound immediately. It is the most used key in the room, and nothing is lost by pressing it.

<span class="note">`Cmd+D` on any class name opens its help file, and every help file has runnable examples.</span>

---

# Feedback

The output of a graph read back into its own input, one block later.

```supercollider
(
x = { var sig, mod1, mod2, mod3;
	mod3 = LocalIn.ar(2) * LFNoise0.kr(8 ! 2).exprange(5, 90);
	mod2 = SinOsc.ar(3, mul: mod3);
	mod1 = SinOsc.ar(800 + mod2, mul: mod3);
	sig = SinOsc.ar([500, 501] + mod1);
	LocalOut.ar(sig);
	sig * 0.1;
}.play;
)

x.release(2);
```

Five lines, and the result is not predictable from reading them. That is the whole attraction, and the risk.

---

# Arrays

Give a UGen an array where it expects a number and the graph quietly builds one copy per element.

```supercollider
// six pulse waves at once, through one filter sweep
{ RLPF.ar(Pulse.ar([10, 25, 80, 9, 4, 3], 0.5, 0.1), XLine.kr(8000, 400, 5), 0.05) }.play;
```

Six frequencies, most of them below hearing, so the low ones arrive as rhythm and the high ones as pitch. One line describes the whole texture.

<span class="q">Which of those six numbers do you hear as notes, and which as pulses?</span>

---

# Excitation and Resonance

A resonator has no sound of its own. It needs to be struck.

```supercollider
// Dust fires at random times; Ringz rings at whatever frequency it is given
{ Ringz.ar(Dust.ar(6) * 0.4, LFNoise0.kr(6).exprange(200, 2400), 0.6) ! 2 * 0.5 }.play;
```

The struck-object family of sounds comes almost entirely from this pair: something short and broad, and something narrow that rings.

---

# Gendy

Xenakis's dynamic stochastic synthesis, as a single UGen.

```supercollider
{ Gendy1.ar(1, 1, 1, 1, 60, 180, 0.6, 0.4, 12, 12, 0.25) ! 2 }.play;
```

Twelve control points, each with an amplitude and a duration. Every cycle, each one takes a small random step, bounded so it cannot leave the range. The waveform is whatever the points currently spell, and it is never quite the same twice.

<span class="note">No oscillator shape was chosen here. The shape is the output of a process, which is the argument of this whole course.</span>

---
class: light
---

# A Signal Chain

<AudioEmbed src="/demos/chain/" height="22rem" label="a signal chain, interactive" />

<span class="note">A Gendy into a filter into a comb delay, with one oscillator wired to the cutoff rather than to the output.</span>

---
class: light
---

# Seeing What You Hear

<div class="shot"><img src="/figures/monitoring-000.svg" /></div>

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
SynthDef(\blip, { |freq = 440, amp = 0.2, dur = 0.3, pan = 0, index = 3|
	var env = EnvGen.kr(Env.perc(0.005, dur), doneAction: 2);
	var mod = SinOsc.ar(freq * 1.5, mul: freq * index * env);
	var sig = SinOsc.ar(freq + mod) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

Synth(\blip, [\freq, 330]);
Synth(\blip, [\freq, 660, \index, 8, \pan, -0.7]);
```

<span class="note">`doneAction: 2` frees the node when the envelope ends. Without it the server accumulates nodes until it runs out.</span>

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
	\dur, 0.25,
	\freq, Pseq([220, 330, 440, 550], inf) * Prand([1, 1.5, 2], inf),
	\index, Pwhite(0.5, 6),
	\pan, Pwhite(-0.8, 0.8),
	\amp, 0.15
).play;
)
```

<span class="q">Nothing in the SynthDef changed. So where is the piece?</span>

---

# Patterns

Held under a name with `Pdef`, the pattern can be replaced while it plays. The next event comes from the new definition, and there is no gap.

```supercollider
Pdef(\p, Pbind(\instrument, \blip, \dur, 0.25,
	\freq, Pseq([220, 330, 440, 550], inf), \index, 2, \amp, 0.15)).play;

// evaluate this with the first still sounding
Pdef(\p, Pbind(\instrument, \blip, \dur, Prand([0.125, 0.5], inf),
	\freq, Pexprand(120, 1200), \index, Pwhite(1, 8), \amp, 0.12));
```

The instrument stayed still and the score moved. That split is the subject of the next class, and most of the year runs through it.

---
layout: center
class: divider
---

People

---

# Who Uses It

**Julian Rohrhuber** and **Alberto de Campo** built `JITLib`, the live-coding layer, and theorised programming as conversation rather than construction.

**Thor Magnusson** wrote *ixi lang*, a small language living inside SuperCollider, and writes about instruments as epistemic tools.

**Alex McLean** built **TidalCycles**, whose sound engine, SuperDirt, is written in SuperCollider. A great deal of live-coded music is running SuperCollider without saying so.

**Pierre-Alexandre Tremblay** and the **FluCoMa** team brought corpus analysis and machine listening into it.

**Marcin Pietruszewski** extended Roads and de Campo's Pulsar Generator into the **nuPG**, which is class 11.

<span class="note">Also Daniel Mayer, Luc Döbereiner, Hanns Holger Rutz, Eli Fieldsteel, Nick Collins, Fredrik Olofsson. The community is small, and it reads each other's code.</span>

---
class: light
---

# Practice

> "[I am interested in] electroacoustic, digital and social systems that can surprise me."

<div class="src">(Alberto de Campo, artist statement, ICLC 2025)</div>

---
class: light
---

# Practice

> "Just in time programming includes the programming activity in the program's operation. A program is not taken as a tool that is made first to be productive later, but instead as a dynamic construction process of description and conversation."

<div class="src">(Julian Rohrhuber, Algorithms Today, ICMC 2005)</div>

---

# What People Do With It

**Fixed media.** Compose offline and render. `Score` and `recordNRT` write a piece to disk faster than real time, so an hour of sound need not take an hour.

**Live coding.** Rewrite the running program while it sounds, which is what `Ndef` and `Pdef` are for.

**Installation.** A patch that runs unattended for weeks, on a machine with no screen. Bela, Norns and a Raspberry Pi all run the same server.

**Instruments.** A controller, a mapping, and a graph. The mapping is usually where the composition is.

**Listening and corpora.** Analysis of large collections of sound, and composing with what the analysis returns.

<span class="note">Not a menu to choose from this week. It is the shape of what the rest of the year touches.</span>

---

# Next Steps

- Take one line from today and change one number at a time until you cannot predict the result
- Wrap your favourite of them in a `SynthDef` and give it three arguments
- Play that SynthDef with a `Pbind`, then change only the pattern
- Open `s.scope` and `s.freqscope` and leave them open while you work

<span class="note">Eli Fieldsteel's video series and *SuperCollider for the Creative Musician* are the best modern starting point. `Cmd+D` on any UGen is the fastest.</span>

---
layout: center
class: divider
---

Exercises

---

# Exercises

1. Build a sound from **one line** that you would be willing to play to the room, and be able to say which number does what.

2. Take the modulation example and find the two frequencies where it stops being rhythm and starts being timbre. Write them down.

3. Write a `SynthDef` with at least **four arguments**, where changing each one is clearly audible.

4. Play it with a `Pbind` where three keys are patterns rather than numbers.

5. Replace the pattern with `Pdef` while it is sounding, so the change is heard as a transition.

<span class="workshop">- workshop -</span>
