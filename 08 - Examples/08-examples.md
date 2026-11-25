---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 08 Examples
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

<div class="deck-title">Examples</div>

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

The seven instruments from the last class are used throughout: `\sine`, `\gliss`, `\pluck`, `\bell`, `\breath`, `\blip` and `\drone`.

All of them take **freq**, **amp**, **sus**, **pan** and, apart from `\sine`, **slide**. `sus` is the length of the sound in seconds and `slide` a glissando in semitones over that length. The SynthDefs are at the top of *Patterns.scd*.

One more, `\mono`, is added in the section on **Pmono**.

---
class: light
---

# Instruments

<div class="shot"><img src="/figures/instruments-000.svg" /></div>

---

# Instruments

One gesture played by each instrument in turn: frequencies from an exponential range and a small random glissando.

```supercollider
~instruments = [\sine, \gliss, \pluck, \bell, \breath, \blip, \drone];

Pbind(\instrument, Pdup(5, Pseq(~instruments)),
	\freq, Pexprand(80, 3000),
	\sus, 0.3, \slide, Pwhite(-3.0, 3.0), \dur, 0.2).play
```

---
layout: center
class: divider
---

Patterns

---

# Patterns

This is one of the last classes that is mainly about **patterns**. What follows is a recap of the basics and then a collection of techniques, each with an example.

None of them is tied to Koenig. All of them can be played with any of the seven instruments, and every example is in *Patterns.scd* in the same order, with the instruments at the top.

---

# Recap

1. A **sequence** of values: `Pseq`
2. **Random** values: `Pwhite`
3. **Shapes** in time: `Penv` or an `Env`
4. Patterns can be **nested**
5. Patterns can be played in **parallel**: `Ppar`
6. One parameter can read another: `Pkey`
7. `Pdef` changes a pattern **while it runs**
8. An array gives a **chord**
9. The **shortest** pattern stops the whole `Pbind`

---

# Recap

The first five as five Pbinds. *Recap.scd* has all nine, one block each.

```supercollider
Pbind(\instrument, \sine, \freq, Pseq([100, 800, 300], inf), \dur, 0.2).play;

Pbind(\instrument, \sine, \freq, Pwhite(100, 800), \dur, 0.2).play;

Pbind(\instrument, \sine, \freq, Penv([100, 800, 60, 8000], [1, 3, 2]), \dur, 0.1).play;

Pbind(\instrument, \sine, \dur, 0.2,
	\freq, Pseq([Pseq([100, 800, 400]), Pwhite(100, 800, 4), Penv([100, 800, 60], [1, 2])], inf)).play;

Ppar([
	Pbind(\instrument, \sine, \freq, Pseq([100, 800, 400], inf), \dur, 0.2),
	Pbind(\instrument, \sine, \freq, Pwhite(1000, 4000).round(100), \amp, 0.05, \dur, 0.1)
]).play;
```

---

# Recap

The other four.

```supercollider
// the duration reads the frequency
Pbind(\instrument, \sine, \freq, Pseq([100, 200, 400], inf), \dur, Pkey(\freq) * 0.001).play;

// change the range and evaluate again, without stopping
Pdef(\something, Pbind(\instrument, \sine, \freq, Pwhite(100, 8000), \dur, 0.2)).play;

// chords
Pbind(\instrument, \sine, \freq, Pseq([[100, 200, 800], [400, 600, 1000]], inf), \dur, 0.3).play;

// only eight notes: the amplitude pattern ends first
Pbind(\instrument, \sine, \freq, Pwhite(100, 250, 14), \amp, Pexprand(0.2, 1.0, 8), \dur, 0.1).play;
```

---
layout: center
class: divider
---

Events

---

# Events

A Pbind produces **events**. Each key names one value of the event:

- `\instrument`: the SynthDef that plays it
- `\freq` or `\midinote`: the pitch
- `\dur`: the time until the next event
- `\sus`, `\amp`, `\pan` and `\slide`: the arguments of the instrument

A key that is not given keeps its default. Any key can be a fixed value or a pattern.

---
class: light
---

# Events

<div class="shot"><img src="/figures/event-keys-000.svg" /></div>

---

# Events

One event, the same values in a Pbind, and then one key made into a pattern.

```supercollider
(instrument: \bell, freq: 1234.5, sus: 2).play;

Pbind(\instrument, \bell, \freq, 1234.5, \sus, 2, \dur, 1).play;

Pbind(\instrument, \bell, \freq, Pexprand(200, 4000), \sus, 2, \dur, 1).play;
```

---

# Pitch without a Scale

Pitch can be a **frequency** in hertz, a **MIDI note** with a fraction, or a **ratio** to a fundamental. None of them needs a scale.

`\freq` is the most direct. `\midinote` 60.5 is a quarter tone above middle C. Ratios that are not simple fractions give **inharmonic** chords.

---

# Pitch without a Scale

Four ways to give a pitch.

```supercollider
// hertz
Pbind(\instrument, \pluck, \freq, Pseq([97, 389, 1543, 211], inf), \dur, 0.25).play;

// a fraction of a semitone
Pbind(\instrument, \pluck, \midinote, 60 + Pwhite(0.0, 1.0), \dur, 0.15).play;

// ratios to a fundamental of 110 Hz
Pbind(\instrument, \bell, \freq, 110 * Pseq([1, 1.13, 1.47, 2.71, 3.9], inf), \dur, 0.3).play;

// an inharmonic chord
Pbind(\instrument, \bell, \freq, [110, 155.6, 297.1, 523.4], \dur, 2).play;
```

---

# Silence

A **rest** is an event that makes no sound and takes its time from `\dur`. Silence sets the density as much as the sounds do.

```supercollider
// a rest of one second after every eight sounds
Pbind(\instrument, \blip, \freq, Pexprand(300, 3000),
	\dur, Pseq([Pn(0.1, 8), Rest(1)], inf)).play;

// one event in three is silent
Pbind(\instrument, \pluck, \freq, Pexprand(100, 1000), \dur, 0.15,
	\type, Pwrand([\note, \rest], [2, 1].normalizeSum, inf)).play;
```

---
layout: center
class: divider
---

Lists

---

# Lists

- `Pseq(list)`: in order
- `Prand(list)`: any element, each time
- `Pxrand(list)`: any element but the one just played
- `Pwrand(list, weights)`: by weight
- `Pshuf(list)`: one random order, repeated

Each takes a number of repeats as its second argument. A list can hold numbers, symbols or other patterns.

---

# Lists

One list of five frequencies, read five ways. Run the lines one at a time.

```supercollider
~list = [97, 211, 389, 1543, 2903];

Pbind(\instrument, \blip, \freq, Pseq(~list, inf), \dur, 0.15).play;

Pbind(\instrument, \blip, \freq, Prand(~list, inf), \dur, 0.15).play;

Pbind(\instrument, \blip, \freq, Pxrand(~list, inf), \dur, 0.15).play;

Pbind(\instrument, \blip, \freq, Pwrand(~list, [8, 4, 2, 1, 1].normalizeSum, inf), \dur, 0.15).play;

Pbind(\instrument, \blip, \freq, Pshuf(~list, inf), \dur, 0.15).play;
```

---

# Lists

Lists of durations, of instruments, and of other patterns.

```supercollider
Pbind(\instrument, \pluck, \freq, 400, \dur, Prand([0.05, 0.05, 0.1, 0.8], inf)).play;

Pbind(\instrument, Pxrand([\pluck, \bell, \breath, \blip], inf), \freq, 700, \dur, 0.2).play;

// each inner pattern is played to its end before the next
Pbind(\instrument, \blip,
	\freq, Pseq([Pseq([300, 310, 320]), Pexprand(1000, 4000, 4), Pn(80, 2)], inf),
	\dur, 0.12).play;
```

---
layout: center
class: divider
---

Numbers

---

# Numbers

- `Pwhite(lo, hi)`: uniform between two limits
- `Pexprand(lo, hi)`: more values near the low limit, which suits frequency and duration
- `Pbrown(lo, hi, step)`: a random walk between two limits
- `Pseries(start, step)`: the same step added each time
- `Pgeom(start, factor)`: multiplied by the same factor each time

---

# Numbers

The same frequency key with each of the five. Listen for the difference between the uniform and the exponential range.

```supercollider
Pbind(\instrument, \sine, \freq, Pwhite(200, 2000), \dur, 0.1).play;

Pbind(\instrument, \sine, \freq, Pexprand(200, 2000), \dur, 0.1).play;

Pbind(\instrument, \sine, \freq, Pbrown(200, 2000, 60), \dur, 0.1).play;

Pbind(\instrument, \sine, \freq, Pseries(200, 37, 50), \dur, 0.1).play;

Pbind(\instrument, \sine, \freq, Pgeom(200, 1.05, 50), \dur, 0.1).play;
```

---

# Numbers

A walk on every parameter, and a geometric walk, `Pgbrown`, which steps by ratios.

```supercollider
Pbind(\instrument, \pluck,
	\freq, Pbrown(100, 1500, 40),
	\dur, Pbrown(0.03, 0.3, 0.02),
	\amp, Pbrown(0.02, 0.3, 0.03),
	\pan, Pbrown(-1.0, 1.0, 0.2)).play;

Pbind(\instrument, \blip, \freq, Pgbrown(100, 4000, 0.1), \dur, Pgbrown(0.02, 0.5, 0.1)).play;
```

---

# Distributions

Three more shapes of randomness: a **Gaussian** bell around a centre, **Cauchy** with rare far outliers, and **beta**, which favours both extremes.

```supercollider
Pbind(\instrument, \pluck, \midinote, Pgauss(60, 8), \dur, 0.08).play;

Pbind(\instrument, \pluck, \midinote, Pcauchy(60, 2).clip(20, 110), \dur, 0.08).play;

// mostly very quiet or loud
Pbind(\instrument, \blip, \freq, 900, \amp, Pbeta(0.01, 0.4, 0.3, 0.3), \dur, 0.08).play;
```

---
layout: center
class: divider
---

Shapes in Time

---

# Shapes in Time

`Pseg(levels, durations, curve)` moves between levels over **seconds**, whatever the `\dur` is. `Penv` reads an envelope in the same way.

A shape is how a texture changes as a whole: the register moving, the density thinning out, a crescendo.

---

# Shapes in Time

Three shapes, each on one key. Each pattern ends when its shape ends.

```supercollider
// the register from 30 Hz to 4000 Hz and back over twenty seconds
Pbind(\instrument, \sine, \freq, Pseg([30, 4000, 30], [10, 10], \exp), \dur, 0.05).play;

// from fifty events a second to two
Pbind(\instrument, \pluck, \freq, Pexprand(200, 3000), \dur, Pseg([0.02, 0.5], [15], \exp)).play;

// a crescendo of noise
Pbind(\instrument, \breath, \freq, Pexprand(500, 5000), \dur, 0.05, \amp, Pseg([0, 0.5], [12])).play;
```

---
layout: center
class: divider
---

Relations

---

# Relations

`Pkey(\key)` reads a key already set in the same event, so one parameter can follow another.

`Pfunc { |event| ... }` runs a function for every event. It receives the event, so it can read any key, and it can return anything, including a rest.

---

# Relations

High sounds short and low sounds long, higher sounds further to the right, and a function that silences one event in four.

```supercollider
Pbind(\instrument, \bell, \freq, Pexprand(80, 5000), \sus, 300 / Pkey(\freq), \dur, 0.15).play;

Pbind(\instrument, \pluck, \freq, Pexprand(100, 4000),
	\pan, Pkey(\freq).collect { |f| f.explin(100, 4000, -1, 1) }, \dur, 0.1).play;

Pbind(\instrument, \blip, \freq, Pexprand(200, 2000),
	\dur, Pfunc { if(0.25.coin) { Rest(0.2) } { 0.1 } }).play;
```

---
layout: center
class: divider
---

Repetition

---

# Repetition

`Pn(pattern, n)` repeats a whole pattern. `Pdup(n, pattern)` repeats each value n times; `Pstutter` is an older name for the same thing.

With a pattern for n, `Pdup` gives groups of irregular length.

```supercollider
// a gesture of five sounds, four times
Pbind(\instrument, \blip, \freq, Pn(Pgeom(3000, 0.7, 5), 4), \dur, 0.08).play;

// each value twice
Pbind(\instrument, \pluck, \freq, Pdup(2, Pexprand(100, 2000)), \dur, 0.1).play;

// groups of one to eight
Pbind(\instrument, \pluck, \freq, Pdup(Pwhite(1, 8), Pexprand(100, 2000)), \dur, 0.06).play;
```

---
layout: center
class: divider
---

Layers

---

# Layers

`Pseq` of Pbinds plays them one after the other. `Ppar` plays them at the same time. `Ptpar` gives each one a start time.

`Pbindf(pattern, key, value)` takes an existing pattern and adds or replaces keys, so one pattern can be reused in several layers.

---
class: light
---

# Layers

<div class="shot"><img src="/figures/layers-in-time-000.svg" /></div>

---

# Layers

The three patterns of the figure: a low drone of three seconds, two seconds of high blips, and four seconds of noise.

```supercollider
~a = Pbind(\instrument, \drone, \freq, 55, \sus, 3, \dur, Pn(3, 1));
~b = Pbind(\instrument, \blip, \freq, Pexprand(2000, 6000, 20), \dur, 0.1);
~c = Pbind(\instrument, \breath, \freq, Pexprand(300, 900, 8), \dur, 0.5);

Pseq([~a, ~b, ~c]).play;

Ppar([~a, ~b, ~c]).play;

Ptpar([0, ~a, 1, ~b, 2.5, ~c]).play;
```

---

# Layers

One cloud and two copies made with `Pbindf`: two octaves down on another instrument, and four times higher and quieter.

```supercollider
~cloud = Pbind(\instrument, \sine, \freq, Pexprand(800, 1200), \sus, 0.03, \dur, 0.03);

Ppar([
	~cloud,
	Pbindf(~cloud, \freq, Pkey(\freq) * 0.25, \instrument, \pluck),
	Pbindf(~cloud, \freq, Pkey(\freq) * 4.1, \amp, 0.02)
]).play
```

---
layout: center
class: divider
---

Form and Change

---

# Form and Change

`Pspawner` runs a function that places patterns in time. `seq` waits for a pattern to end, `par` starts one and goes on at once, and `wait` lets time pass.

`Pdef` gives a pattern a name. Evaluating it again with new content changes it while it plays.

---

# Form and Change

A cloud, two seconds of silence, then glissandi over a low drone.

```supercollider
Pspawner({ |sp|
	sp.seq(Pfindur(4, Pbind(\instrument, \sine,
		\freq, Pexprand(1000, 8000), \sus, 0.02, \dur, 0.01)));
	sp.wait(2);
	sp.par(Pbind(\instrument, \drone, \freq, 41.2, \sus, 6, \dur, Pn(6, 1)));
	sp.seq(Pfindur(6, Pbind(\instrument, \gliss, \freq, Pexprand(200, 2000),
		\slide, Pgauss(0, 12), \sus, 2, \dur, 0.25, \amp, 0.03)));
}).play
```

---

# Form and Change

A texture with a name, changed while it plays.

```supercollider
Pdef(\noise, Pbind(\instrument, \breath, \freq, Pexprand(200, 800), \dur, 0.1)).play;

// evaluate this while it plays: the change comes at the next event
Pdef(\noise, Pbind(\instrument, \breath, \freq, Pexprand(3000, 6000), \dur, 0.03));

Pdef(\noise).stop;
```

---
layout: center
class: divider
---

Pmono

---

# Pmono

A Pbind starts a **new synth** for every event. `Pmono` starts **one synth** and changes its parameters with every event, so the sound is continuous.

It needs a SynthDef that keeps sounding until it is released, with a `gate` argument. `\mono` is a filtered sawtooth that **glides** to each new frequency over `glide` seconds.

---

# Pmono

The SynthDef, then one synth gliding: between random frequencies, in a slow walk, and between two extremes with glides of random length.

```supercollider
SynthDef(\mono, { |out=0, freq=200, amp=0.1, pan=0, glide=0.1, gate=1|
	var env = EnvGen.kr(Env.asr(0.05, 1, 0.5), gate, doneAction: 2);
	var sig = LPF.ar(VarSaw.ar(Lag.kr(freq, glide), 0, 0.3), 3000);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

Pmono(\mono, \freq, Pexprand(60, 2000), \dur, 0.2).play;

Pmono(\mono, \freq, Pbrown(100, 400, 20), \glide, 0.02, \dur, 0.05).play;

Pmono(\mono, \freq, Pseq([100, 3000], inf), \glide, Pwhite(0.05, 2.0), \dur, 2).play;
```

---
layout: center
class: divider
---

States and Conditions

---

# States and Conditions

`Pfsm` is a **state machine**: each state is a value or a pattern, followed by the states that may come next. Repeating an index makes that move more likely.

`Pif(condition, a, b)` takes the next value from a or from b, depending on a condition tested for every event.

---

# States and Conditions

Three registers as states, and a coin that decides the register of each event.

```supercollider
Pbind(\instrument, \pluck,
	\freq, Pfsm([
		[0],
		Pexprand(50, 120, 4), [0, 0, 1],      // low: stays, or rises
		Pexprand(300, 900, 3), [0, 1, 2],
		Pexprand(2000, 6000, 6), [1]          // high: always back to the middle
	], inf),
	\dur, 0.1).play;

Pbind(\instrument, \blip,
	\freq, Pif(Pwhite(0.0, 1.0) < 0.8, Pexprand(100, 300), Pexprand(4000, 8000)),
	\dur, 0.08).play;
```

---
layout: center
class: divider
---

Techniques

---

# Reading a Collection

A shape in time is read as a position in a collection made beforehand. The shape decides the movement and the collection decides the values.

```supercollider
~shape = Env([0, 0.5, 0.8, 0.2, 1.0], 2.5 ! 4);
~collection = Array.series(24, 48, 0.5);

Pbind(\instrument, \pluck,
	\position, Pn(Penv(~shape.levels, ~shape.times)),
	\midinote, Pfunc { |event| ~collection[((~collection.size - 1) * event[\position]).round] },
	\dur, 0.1).play
```

---
class: light
---

# Reading a Collection

<div class="shot"><img src="/figures/collection-shape-000.svg" /></div>

---

# Reading a Collection

A tendency mask that reads from a collection, with shuffled durations, on a clock at 90 beats a minute.

```supercollider
~high = Env([0.26, 0.51, 0.9], [0.5, 0.5]);
~low = Env([0.25, 0.49, 0.01], [0.5, 0.5]);
~collection = Array.series(16, 40, 2.5);

Pbind(\instrument, \blip,
	\high, Pn(Penv(~high.levels, ~high.times * 2)),
	\low, Pn(Penv(~low.levels, ~low.times * 2)),
	\midinote, Pfunc { |event|
		~collection[((~collection.size - 1) * rrand(event[\low], event[\high])).round] },
	\dur, Pn(Pshuf([1/16, 1/8, 1/32]))
).play(TempoClock(90/60))
```

---

# Chords

An array in a Pbind gives a chord. `Pwhite` with arrays draws every note of the chord at once, and `Pfunc` can build chords of any size.

```supercollider
Pbind(\instrument, \bell,
	\freq, Pseq([[200, 283, 317], [151, 389, 1210]], inf),
	\dur, Pseq([0.5, 0.25], inf)).play;

Pbind(\instrument, \pluck,
	\midinote, Pwhite([60, 70.5], [80, 90.5], inf),
	\dur, Pwrand([1, 0.25], [0.6, 0.4], inf)).play;

// chords that grow from one note to six
Pbind(\instrument, \drone,
	\size, Pseries(1, 1, 6),
	\freq, Pfunc { |event| [55, 87.3, 131, 208.6, 333, 529].keep(event[\size]) },
	\dur, 1.5, \sus, 2).play
```

---

# Series and Layers

A series of frequencies going up in steps of 37 Hz, one going down, the two in sequence and then as layers that enter one after the other.

```supercollider
~up = Pbind(\instrument, \blip, \freq, Pseries(100, 37, 48), \dur, 0.1);
~down = Pbind(\instrument, \blip, \freq, Pseries(1876, -37, 48), \dur, 0.1);

Pseq([~up, ~down]).play;

Ptpar([0.0, ~up, 0.0, ~down, 0.5, ~up, 0.5, ~down, 1.0, ~up, 1.0, ~down]).play;

// a walk inside a series: each step is random
Pbind(\instrument, \pluck, \midinote, Pseries(60, Pwhite(-5.0, 5.0), inf).fold(36, 96),
	\dur, 0.1).play;
```

---

# Canon

One voice, entering three times at a distance and a transposition by a ratio. `Pbindf` changes a key of a pattern that already exists.

```supercollider
~voice = Pbind(\instrument, \pluck,
	\freq, Pseq([311, 347, 529, 467, 389, 803, 212, 236, 331]),
	\dur, Pseq([2, 1, 1, 2, 1, 1, 2, 2, 4] / 8));

Ptpar([
	0, ~voice,
	1, Pbindf(~voice, \freq, Pkey(\freq) * 1.41, \instrument, \bell),
	2, Pbindf(~voice, \freq, Pkey(\freq) * 0.37, \instrument, \blip)
]).play
```

---

# Phasing

The same six notes in two voices, one of them slightly slower. The voices drift apart and come back together.

```supercollider
~notes = Pseq([60, 61.5, 66, 59, 70.5, 64], inf);

Ppar([
	Pbind(\instrument, \pluck, \midinote, ~notes, \dur, 0.2, \pan, -0.7),
	Pbind(\instrument, \blip, \midinote, ~notes + 12, \dur, 0.21, \pan, 0.7)
]).play
```

---
class: light
---

# Phasing

<div class="shot"><img src="/figures/phasing-000.svg" /></div>

---

# Polymeter

Three voices with cycles of three, four and five notes at the same speed. Accents from a cycle of their own make the meters audible.

```supercollider
Ppar([
	Pbind(\instrument, \pluck, \freq, Pseq([61, 97, 73], inf), \dur, 0.15,
		\amp, Pseq([0.3, 0.1, 0.1], inf)),
	Pbind(\instrument, \blip, \freq, Pseq([1013, 877, 1411, 653], inf), \dur, 0.15,
		\amp, Pseq([0.15, 0.05, 0.05, 0.05], inf)),
	Pbind(\instrument, \bell, \freq, Pseq([3011, 3593, 2707, 4219, 3301], inf), \dur, 0.15,
		\amp, Pseq([0.1, 0.02, 0.02, 0.02, 0.02], inf))
]).play
```

---

# Accelerando

`Pgeom` multiplies each duration by the same factor, which gives a smooth acceleration. `Pseg` can move durations over time, measured in seconds.

```supercollider
// 40 notes, each 7 percent shorter than the last
Pbind(\instrument, \blip, \midinote, 72, \dur, Pgeom(0.5, 0.93, 40)).play;

// slowing down and speeding up again over twelve seconds
Pbind(\instrument, \pluck, \midinote, Pwhite(60, 72),
	\dur, Pseg([0.03, 0.3, 0.03], [6, 6], \exp)).play
```

---

# Ratchets

`PdurStutter` divides a duration into equal parts. A note of 0.4 divided by 4 is four notes of 0.1.

```supercollider
Pbind(\instrument, \blip,
	\dur, PdurStutter(Prand([1, 1, 2, 3, 4], inf), 0.4),
	\midinote, Pwhite(60, 72)).play;

// simpler: the same note repeated a random number of times at a fixed speed
Pbind(\instrument, \pluck, \midinote, Pdup(Prand([1, 2, 4], inf), Pwhite(60, 72)),
	\dur, 0.1).play
```

---

# Sample and Hold

`Pclutch` takes a new value only when its second pattern is true. `Pstep` holds each value for a length of time.

```supercollider
// a new value on every fifth event
Pbind(\instrument, \bell,
	\freq, Pclutch(Pwhite(95.123, 551.1234), Pseq([1, 0, 0, 0, 0], inf)),
	\dur, 0.1).play;

// each value held for one beat
Pbind(\instrument, \blip, \freq, Pstep(Pwhite(200, 400), 1, inf), \dur, 0.05).play;

// interpolated between values instead of held
Pbind(\instrument, \sine, \freq, Pseg(Pwhite(100, 500), Pseq([1, 5], inf), \linear),
	\dur, 0.1).play
```

---

# Interlacing

`Ppatlace` takes one value from each pattern in turn. `Place` does the same with an array, where an inner array gives its values one at a time on each round.

```supercollider
Pbind(\instrument, \pluck,
	\freq, Ppatlace([Pseq([90, 97, 104], inf), Pexprand(2000, 4000), Pbrown(300, 400, 10)], inf),
	\dur, 0.12).play;

Pbind(\instrument, \blip,
	\freq, Place([200, [310, 470, 730], 1100, [1700, 2600]], inf),
	\dur, 0.12).play
```

---

# Walking a List

`Pwalk` steps through a list by an index that moves by a pattern of steps. At the ends it can wrap or turn back. The list here is twelve frequencies with uneven steps between them.

```supercollider
~list = [110, 127, 151, 178, 209, 247, 290, 341, 403, 475, 559, 659];

// steps of -1, 1 or 2, turning back at the ends
Pbind(\instrument, \pluck,
	\freq, Pwalk(~list, Prand([-1, 1, 2], inf), Pseq([1, -1], inf), 0),
	\dur, 0.12).play;

// Pindex reads a list with an index from any pattern
Pbind(\instrument, \bell, \freq, Pindex(~list, Pbrown(0, 11, 2), inf) * 2,
	\dur, 0.15).play
```

---

# Switching

`Pswitch1` chooses, for every event, which pattern the next value comes from. The patterns keep their own position.

```supercollider
Pbind(\instrument, \blip,
	\freq, Pswitch1([
		Pseq([300, 330, 371, 406], inf),
		Pseries(4000, -150, inf).wrap(1000, 4000),
		Pexprand(50, 120)
	], Pseq([0, 0, 1, 0, 2, 1], inf)),
	\dur, 0.1).play
```

---

# Filtering

`select`, `reject` and `collect` work on patterns as on collections: values pass a test, fail a test, or are transformed.

```supercollider
// only frequencies below 800
Pbind(\instrument, \sine, \freq, Pwhite(100, 900).select { |x| x < 800 }, \dur, 0.1).play;

// nothing between 300 and 3000 Hz: only the extremes remain
Pbind(\instrument, \pluck,
	\freq, Pexprand(50, 8000).reject { |f| (f > 300) && (f < 3000) },
	\dur, 0.12).play;

// every value rounded to the nearest quarter tone
Pbind(\instrument, \bell, \midinote, Pwhite(60.0, 72.0).collect { |n| n.round(0.5) },
	\dur, 0.15).play
```

---

# Time Limits

Ways to stop a pattern: after a length of time, at the next beat, when a sum is reached, or by asking how long it has played.

```supercollider
// play for four seconds
Pfindur(4, Pbind(\instrument, \blip, \midinote, Pwhite(60, 72), \dur, 0.1)).play;

// stop at the end of the beat in which the total reaches one beat
Psync(Pbind(\instrument, \blip, \freq, Pseq([500, 600, 700], inf), \dur, 0.03), 1, 1).play;

// stop after a total of 5000 Hz has been played
Pbind(\instrument, \sine, \freq, Pconst(5000, Pseq([500, 600, 700], inf)), \dur, 0.1).play;

// Ptime counts the time since the start
Pbind(\instrument, \pluck, \freq, Pif(Ptime(inf) < 1.0, Pexprand(200, 2000, inf)), \dur, 0.1).play;
```

---

# Regenerating

`Plazy` builds a new pattern every time it is played. Inside `Pn` it makes a new phrase on every repeat.

```supercollider
// a new four-note phrase every time, played three times before the next
Pbind(\instrument, \pluck,
	\midinote, Pn(Plazy { Pseq(Pwhite(48, 72).asStream.nextN(4), 3) }),
	\dur, 0.12).play;

// three values, shuffled and repeated four times, then three new values
Pbind(\instrument, \blip,
	\midinote, Pn(Plazy { Pshuf(Pwhite(40, 60).asStream.nextN(3), 4) }) + 12,
	\dur, 0.1).play
```

---

# Chaining

`Pchain` combines Pbinds, so a rhythm can be written once and given different pitches and instruments. `Pbindf` adds keys to an existing pattern.

```supercollider
~rhythm = Pbind(\dur, Pseq([3, 1, 2, 2] / 8, inf));

Pchain(Pbind(\instrument, \pluck, \midinote, Pwhite(48, 60)), ~rhythm).play;

Pchain(Pbind(\instrument, \bell, \freq, Pseq([2203, 3389, 2671], inf)), ~rhythm).play;

Pbindf(~rhythm, \instrument, \breath, \freq, Pexprand(300, 3000)).play
```

---

# Changing While Playing

`Pdef` replaces a pattern while it plays. `Pbindef` replaces a single key and leaves the others alone.

```supercollider
Pbindef(\live, \instrument, \pluck, \freq, Pexprand(200, 2000), \dur, 0.15).play;

Pbindef(\live, \instrument, \bell);

Pbindef(\live, \freq, Pseq([97, 389, 1543, 211], inf));

Pbindef(\live, \dur, Prand([0.1, 0.2], inf), \slide, Pwhite(-2, 2));

Pbindef(\live).stop;
```

---

# Form

`Pspawner` places sections in time, in sequence or in parallel. Here a short piece in four sections, made of selection principles and the seven instruments.

```supercollider
Pspawner({ |sp|
	sp.par(Pbind(\instrument, \drone, \freq, [41, 61.3], \sus, 24, \dur, Pn(24, 1), \amp, 0.05));
	sp.seq(Pfindur(6, Pbind(\instrument, \pluck,                         // group
		\freq, Pdup(Pwhite(2, 5), Prand([311, 347, 529, 803], inf)), \dur, 0.1)));
	sp.par(Pfindur(12, Pbind(\instrument, \breath, \freq, Pexprand(400, 4000), \dur, 0.3)));
	sp.seq(Pfindur(6, Pbind(\instrument, \bell,                          // tendency
		\midinote, Pwhite(Pseg([60, 36], [6]), Pseg([62, 96], [6])), \dur, 0.08)));
	sp.seq(Pfindur(6, Pbind(\instrument, \blip,                          // series
		\freq, Pn(Plazy { Pseq([1013, 1171, 1409, 1693, 1877].scramble) }), \dur, 0.12)));
	sp.seq(Pbind(\instrument, \gliss, \freq, [130, 196.4, 311.7], \slide, -12, \sus, 4,
		\dur, Pn(4, 1)));
}).play
```

---
layout: center
class: divider
---

Textures

---

# Textures

Examples built from the vocabulary above, one idea each. They avoid scales and chords on purpose: the material is **frequency**, **register**, **density**, **duration** and **silence**.

Every one of them can be played with another instrument, and every value is worth changing.

---

# Clouds

Very short sines in great numbers. The second cloud narrows from a wide band to a narrow one over fifteen seconds.

```supercollider
Pbind(\instrument, \sine, \freq, Pexprand(2000, 9000), \sus, 0.01, \dur, 0.005, \amp, 0.05).play;

Pbind(\instrument, \sine, \sus, 0.02, \dur, 0.01, \amp, 0.05,
	\freq, Pexprand(Pseg([100, 1900], [15]), Pseg([8000, 2100], [15]))).play;
```

---

# Noise Bands

`\breath` is noise filtered to a band, so its frequency is the centre of the band.

```supercollider
Pbind(\instrument, \breath, \freq, 800, \sus, 2, \dur, 0.5).play;

// many bands, of many lengths
Pbind(\instrument, \breath, \freq, Pexprand(100, 8000), \sus, Pexprand(0.2, 4), \dur, 0.1).play;

// one band sliding down four octaves
Pbind(\instrument, \breath, \freq, 4000, \slide, -48, \sus, 8, \dur, Pn(8, 1)).play;
```

---

# Glissandi

Glissandi in both directions, then falling glissandi that grow longer.

```supercollider
Pbind(\instrument, \gliss, \freq, Pexprand(100, 2000), \slide, Pwhite(-24, 24),
	\sus, 2, \dur, 0.2, \amp, 0.03).play;

Pbind(\instrument, \drone, \freq, Pexprand(500, 3000), \slide, -36,
	\sus, Pseries(0.5, 0.25, 30), \dur, 0.4, \amp, 0.05).play;
```

---

# Registers

Only the extremes: below 60 Hz and above 6000 Hz. Then a low beating drone under sparse, very high blips.

```supercollider
Pbind(\instrument, \pluck,
	\freq, Prand([Pwhite(30, 60, 1), Pwhite(6000, 9000, 1)], inf), \dur, 0.1).play;

Ppar([
	Pbind(\instrument, \drone, \freq, [41, 41.7], \sus, 8, \dur, 6, \amp, 0.1),
	Pbind(\instrument, \blip, \freq, Pexprand(5000, 9000), \dur, Pexprand(0.1, 2.0), \amp, 0.03)
]).play
```

---

# Density

From one event a second to a hundred and back, then gaps drawn from an exponential range.

```supercollider
Pbind(\instrument, \blip, \freq, Pexprand(400, 4000),
	\dur, Pseg([1, 0.01, 1], [10, 10], \exp), \sus, 0.05).play;

Pbind(\instrument, \pluck, \freq, Pexprand(100, 3000), \dur, Pexprand(0.01, 1.0)).play;
```

---

# Bursts

Bursts of noise that accelerate, separated by silence.

```supercollider
Pbind(\instrument, \breath, \freq, Pexprand(1000, 6000), \sus, 0.03,
	\dur, Pseq([Pgeom(0.3, 0.8, 20), Rest(2)], inf)).play;
```

---

# Microtones

Ten pitches inside one semitone, sounding together, and a walk in steps of a sixth of a tone.

```supercollider
Pbind(\instrument, \drone, \midinote, 60 + (Array.series(10) / 10),
	\sus, 8, \dur, Pn(8, 1), \amp, 0.02).play;

Pbind(\instrument, \pluck, \midinote, Pbrown(48, 72, 1/3).round(1/3), \dur, 0.12).play;
```

---

# Ratios

The partials of a struck bar, roughly 1, 2.76, 5.4, 8.93 and 13.3 times the fundamental, as single sounds and as chords over a changing fundamental.

```supercollider
~ratios = [1, 2.76, 5.4, 8.93, 13.3];

Pbind(\instrument, \bell, \freq, 55 * Prand(~ratios, inf), \dur, 0.2).play;

Pbind(\instrument, \drone, \freq, Pexprand(40, 200).collect { |f| f * ~ratios },
	\sus, 4, \dur, 3, \amp, 0.02).play;
```

---

# Next Steps

- Run *Patterns.scd* from the top. It holds every example from the slides, in order
- Play each texture with a different **instrument**, then change one key at a time
- Replace a fixed value with a pattern, and a pattern with a **shape in time**
- Write a short **form** with `Pspawner` from three textures and a silence

---
layout: center
class: divider
---

Exercises

---

# Exercises

Twenty short ones first, each a small step from the one before. Then six longer ones, numbered on from 21. *Patterns Exercises.scd* has all of them with space to write, and *Patterns.scd* has the SynthDefs.

---

# Events and Pitch

1. Play one event on `\bell` with a frequency of 1234.5 Hz, then one with a `\midinote` of 60.5.
2. A Pbind whose `\freq` is 110 times the ratios `[1, 1.13, 1.47, 2.71]`, in order.
3. Frequencies from `Pexprand` between 50 and 5000 on `\sine`, with `\sus` and `\dur` of 0.02.
4. A rest of one second after every eight events.

---

# Lists and Numbers

5. `Pxrand` over four frequencies of your own that are not in a scale.
6. `Pwrand` for the durations: mostly very short, sometimes one of two seconds.
7. `Pshuf` over five instruments, so that each is heard in turn.
8. `Pbrown` on `\freq` between 200 and 2000, first with a step of 50, then 500.
9. Forty durations from `Pgeom`, starting at 0.5 and multiplied by 0.9 each time.
10. A `Pseries` of `\midinote` from 30, rising by 1.5 for forty events.

---

# Shapes and Relations

11. A `Pseg` that takes `\dur` from 0.5 to 0.01 over ten seconds.
12. Higher frequencies are shorter: `\sus` is 200 divided by `\freq`, with `Pkey`.
13. A `Pfunc` that returns a rest one time in four, and a duration of 0.1 otherwise.
14. Each random frequency repeated between one and six times with `Pdup`.

---

# Layers, Form and Pmono

15. A low `\drone` layer and a high `\blip` layer together, with `Ppar`.
16. Three copies of one pattern entering 0, 1 and 2 seconds apart, each given another instrument with `Pbindf`.
17. With `Pspawner`: a cloud for four seconds, two seconds of silence, then glissandi for four seconds.
18. A noise texture in a `Pdef`, its frequency range changed while it plays.
19. `Pmono` on `\mono`, gliding between frequencies from `Pexprand`.
20. Two voices **phasing**: the same six notes with durations of 0.2 and 0.205.

---

# Exercises

21. Create a three-part form, A B A, with `Pspawner`. A is sparse and uses a Poisson distribution for its gaps, B is dense and uses a Gaussian distribution, and the returning A is varied.

22. Build a texture with a **tendency mask** whose boundaries follow a random walk.

23. Make a piece of several voices in which each voice uses a **different distribution**.

---

# Exercises

24. Use `Pclutch` to freeze values in two voices at different rates, so that the holds interlock rhythmically.

25. Create a pattern that uses `Pfsm` to switch between **different distributions**, one for each state.

26. Make a slowly changing drone of at least thirty seconds with `Pmono` and `Pseg`, in several layers placed with `Pspawner`.

<span class="workshop">- workshop -</span>
