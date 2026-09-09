---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 01 Introduction
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

<div class="deck-title">Composing with Algorithms</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

<!--
First class. Welcome, who is here, backgrounds. Acknowledge Paul Berg openly.
Play something before any definition, and something recent rather than canonical:
Elías Merino, Spaceless Latitudes (2018). Alternates: Merino, Fluctuating Melisma
(2015); Jia Liu; Roc Jiménez de Cisneros. Say nothing about it until afterwards.
-->

---
layout: center
class: divider
---

Class

---

# Course Description

An introduction to algorithmic composition, its applications, history and implementations. Participants will learn to program **sound**, **control** and musical **behaviour**.

Topics such as using probabilities, generative algorithms, complex systems and selection principles will be presented. Each of these will cover technique but also practical applications and musical examples.

The course will be using the **SuperCollider** environment as well as providing short introductions to other platforms.

---

# Composing with Algorithms

Discuss and develop strategies for **composing** music, sounds and behaviour using **algorithms** and computer programs.

Possible methods for doing this exist using:

- **Stochastic processes**
- **Markov chains**
- **Random walks**
- **Selection principles**
- **Iterative functions**
- **Microsound**
- **Live Coding**

These will be discussed as well as many others.

---

# Composing

To make or form *music*, *pieces*, *performances* or *sounds* by combining notes, sound material, parts, or elements.

Often involves **methods** and **strategies** used during the creation process to arrive at a musical composition.

A decision has to be made of what **should be composed**. Events, sections, relationships, sounds, control, timbres etc.

<span class="q">Composing-the-sound or composing-with-sound?</span>

---

# Algorithms

A list of **instructions** necessary to compute an outcome.

A **step-by-step** procedure that in most cases is executed by a computer.

Requires an attitude for problem solving and **formalization**.

Algorithms are found in computer programs and created during **programming**.

---

# Models of Musical Processes

A central theme: **exploring computational models of musical processes**.

A **model** of a musical process is a rule set that produces musical material. Decides the rule, the boundaries and what to keep; the procedure then introduces the events.

Examples:

- **Cellular automata** : many simple cells, one local rule, a pattern that emerges
- **Chaotic maps** : one equation iterated, deterministic but unpredictable
- **Random walks** : each value near the one before it, so a shape wanders rather than jumps

<span class="q">What is sensible to delegate to a procedure, and hard to hand over?</span>

---

# Objectives

Understand the **history**, **concepts**, **techniques** and **design considerations** used in algorithmic composition and generative systems.

Develop and inspire **creative approaches** for projects among participants by building on ideas of *algorithmic music* and the topics that will be discussed.

Establish a critical understanding of **contemporary computer music**, what paths it makes available, its aesthetics and the problems introduced by it.

---

# Prerequisites

An interest in **computer music**, **composition** and **algorithmic creation** of art.

Having a computer capable of running **SuperCollider** or be willing to come to the Sonology studios to use it.

Some *experience* with computers and digital audio is useful but not required.

Knowledge of *programming* is helpful but not at all required.

<span class="note">Basic programming concepts will be covered and an attempt will be made to present the topics as much as possible without code and programming concepts.</span>

---

# Course Format

A **class** will usually focus on a specific **topic** or **theme**.

Part of the lesson will be a **presentation** of, and discussion on, the topic in question. Slides will be presented and pieces will be played.

The other part of the lesson will focus on **hands-on experimentation** in **SuperCollider** or any of the other featured environments.

Regular **workshops** for practical works will also take place.

**Discussion** and **interaction** should take place as much as possible.

<span class="note">If you can, bring your laptops to classes.</span>

---

# Materials

<div class="shot">
  <img src="/figures/materials-000.png" alt="bjarni-gunnarsson.net" />
</div>

<div class="caption mono">/cwa </div>

---

# Tools

The class also features **online systems**, intended to be played with and used to illustrate a class concept.

- <a href="https://slides.bjarni-gunnarsson.net/tools/ca/">**Cellular automata**</a> all 256 elementary rules, the rule drawn as its eight neighbourhoods, and a row read as a waveform
- <a href="https://slides.bjarni-gunnarsson.net/tools/chaos/">**Chaotic maps**</a> nine equations, one and two dimensional, audio rate or pitched events, with a bifurcation view
- <a href="https://slides.bjarni-gunnarsson.net/tools/events/">**Event generator**</a> six distributions and a random walk, applied to duration, frequency and amplitude

<span class="note">All three are at <a href="https://slides.bjarni-gunnarsson.net/tools/">slides.bjarni-gunnarsson.net/tools</a></span>

---
layout: center
class: divider
---

Topics

---

# Topics: Algorithms

<div class="topics">
Class 01, Composing with Algorithms<br>
Class 02, SuperCollider<br>
Class 03, Patterns and Streams<br>
Class 04, Practical Workshop<br>
Class 05, Algorithmic Composition<br>
Class 06, Xenakis and Stochastics<br>
Class 07, Koenig and Selection<br>
Class 08, Sound Synthesis<br>
Class 09, Generating Shapes<br>
Class 10, Recording and Processing
</div>

---

# Topics: Synthesis

<div class="topics">
Class 11, Microsound and Timescales<br>
Class 12, Non-Standard Synthesis<br>
Class 13, Errors and Glitches<br>
Class 14, Iterative Systems<br>
Class 15, Feedback and Cybernetics<br>
Class 16, Mapping and Control<br>
Class 17, Machine Learning<br>
Class 18, Listening Machines<br>
Class 19, Sound Transformation
</div>

---

# Topics: Composition

<div class="topics">
Class 20, Gesture and Texture<br>
Class 21, Spectral Composition<br>
Class 22, Rhythm and Time<br>
Class 23, Sonorities and Materials<br>
Class 24, Drawing and Notation<br>
Class 25, Own Works<br>
Class 26, Live Coding<br>
Class 27, Composition Processes<br>
Class 28, Generative AI and Agents
</div>

<!--
Twenty-eight classes, one workshop at 04. 28 closes the year on language models and
generative AI: the class that asks whether writing the rule can itself be delegated.
-->

---
class: light
---

# SuperCollider

<div class="shot"><img src="/figures/sclang-server-000.svg" /></div>

<div class="src">(two components, client/server)</div>

<!--
The whole architecture in one picture, and the only claim worth making now: these are two
separate programs, and nothing you type makes a sound until a message crosses that arrow.
Class 02 unpacks it. Do not name a single UGen here.
-->

---

# SuperCollider

**SuperCollider** is an environment for real time audio and composition.

SuperCollider consists of an interpreted **object-oriented language** and a state of the art, realtime **sound synthesis server**.

SuperCollider supports different activities such as **sound synthesis**, **digital signal processing**, **algorithmic composition**, **live electronics** and **live coding**.

SuperCollider is *free software*, released under the terms of the GNU General Public License

<a href="https://supercollider.github.io/downloads">supercollider.github.io/downloads</a>

---

# One Line, Many Events

Three notes, stated one at a time. Every value is yours.

```supercollider
Pbind(\instrument, \sine, \dur, 0.2, \midinote, Pseq([60,62,65], inf)).play
```

A range instead of a list. Now you decide the boundaries, not the notes.

```supercollider
Pbind(\instrument, \sine, \dur, 0.2, \freq, Pwhite(400,600)).play
```

<span class="note">All of it, with the instrument it needs, is in *code/Intro.scd*. The ways of choosing a value come back under the first thread.</span>

---
layout: center
class: divider
---

Computer Music

---

# Music with Computers

What is special to the making of music with computers?

- **Speed** of execution
- **Accuracy** of output
- Escape human **judgement** and **biases**
- Exploration of **formalized** ideas
- Testing of **compositional models**
- Execute tasks with **high order of magnitudes**
- Experimenting with **organizational principles**
- **Algorithmic control** for all details of a problem

*"To do things that without the computer could not be done."*
(Paul Berg)

---

# Music with Computers

What are possible **pitfalls** when making music with computers?

- Lack of **judgement** regarding its output
- Belief that an idea can **guarantee interesting results**
- **Lack of interaction** with algorithmic methods
- **Complexity problems** due to the multitude of tasks
- Lack of **possible responses** in disappointing scenarios
- Difficulties in **relating** *material*, *structure* and *form*

*"When you become aware of technique, the music is failing"*
(John Wall)

---

# Possible Roles

A computer can take different roles in the creative process:

- A tool for **composition**
- Generator of **materials**
- Assistant in **organization** of materials
- **Transformation** of materials
- Interactive **partner** (in the studio or real-time)
- **Patient listener** with abilities to analyze music and performances
- **Instrument** during a performance
- **Playback device** for pre-composed materials

<!--
This list is the hinge. Read it once, then say that the year turns those roles into four
questions, and go straight into the threads.
-->

---

# Representations

How the different **possibilities** of composing with computers are made available to users is a problem of **representation**.

The **possible operations** on sounds, notes, lower or higher-level structures is that what enables meaningful interaction.

With digital technology compositional methods have become reproducible due to their **digital definition** and storage.

The way materials for a composition are **represented** is certainly not something that should be thought of a being fixed. The precise definition of materials, possible operations that transform the material and relationship between them is perhaps part of what is **to be composed**.

---
layout: center
class: divider
---

Threads

---

# Rule and Selection

Where a rule comes from, and what you do with what it makes.

<span class="note">Classes 05 Algorithmic Composition, 06 Xenakis and Stochastics, 07 Koenig and Selection, 27 Composition Processes</span>

- Mozart's **dice game**, the oldest algorithmic composition you will meet, and the cheapest demonstration of the whole idea
- Xenakis fixing a **density** between 0.11 and 150 sounds per second, and letting the events fall where they fall
- Koenig's six **selection principles**: sequence, alea, series, ratio, group, tendency
- A **transition table** derived from a poem, and used to write music

<span class="q">Generating is the easy half. On what grounds do you keep one result and throw away the other twenty?</span>

---

# Six Ways to Choose

Koenig's selection principles, each one line, one instrument, and the same four notes throughout. Only the **way a value is picked** changes.

```supercollider {*|1-2|3-4|5-6|7-8|9-10|11-13}
// sequence: in order, forever
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pseq([60,63,67,70], inf)).play
// alea: any value in a range, no memory
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pwhite(60, 72)).play
// series: every value once before any repeats
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pshuf([60,63,67,70], inf)).play
// ratio: weighted, so some values are likelier
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pwrand([60,63,67,70], [0.6,0.2,0.1,0.1], inf)).play
// group: a value repeated a few times, then the next
Pbind(\instrument, \sine, \dur, 0.15, \midinote, Pdup(Pwhite(2,5), Pwhite(60,72))).play
// tendency: random inside boundaries that move, drawn on the next slide
Pbind(\instrument, \sine, \dur, 0.1,
	\midinote, Pwhite(Pseg([36,60],[10],\lin), Pseg([84,66],[10],\lin))).play
```

<!--
Click through one at a time and play each. Six lines, and class 07 is built on them.
The last one needs the diagram that follows.
-->

---
class: light
---

# Tendency Mask

<div class="shot"><img src="/figures/tendency-000.svg" /></div>

<div class="src">(after Koenig, Project 2)</div>

<!--
Koenig's own device. Draw the two boundaries, divide the time into N parts, and let the
values fall between them. The composer sets the shape of the corridor, not the notes.
-->

---
class: light
---

# Given the Rules

> "Repeated application of a model under changed circumstances makes its limits clearer: accumulation and correlation of the results cause the model to reveal itself and at the same time the extent to which it coincides with a part of musical reality."

> "The analytical task - given the music, find the rules - is reversed: given the rules, find the music."

<div class="src">(Koenig, on Project 1)</div>
<div class="fig"><img src="/figures/koenig-000.png" /></div>

<!--
Both from Koenig, quoted in Paul Berg's CWA 6. The second sentence is the course in one line
and it belongs here, at the start, not buried in class 07.
-->

---
class: light
---

# Pilot

> "Freed from tedious calculations the composer is able to devote himself to the general problems that the new musical form poses and to explore the nooks and crannies of this form while modifying the values of the input data. […] With the aid of electronic computers the composer becomes a sort of pilot: he presses the buttons, introduces coordinates, and supervises the controls of a cosmic vessel sailing in the space of sound, across sonic constellations and galaxies that he could formerly glimpse only as a distant dream."

<div class="src">(Xenakis, Formalized Music)</div>
<div class="fig">
  <img src="/figures/xenakis-000.png" />
  <img src="/figures/xenakis-001.png" />
</div>

---

# Inside the Sound

The same rule, applied beneath the note.

<span class="note">Classes 08 Sound Synthesis, 09 Generating Shapes, 11 Microsound and Timescales, 12 Non-Standard Synthesis, 21 Spectral Composition</span>

- Risset's **bell** as four parallel lists, with a decay per partial: timbre as process, not state
- A **grain rate** climbing past 20 Hz, where a rhythm stops being a rhythm and becomes a pitch
- **GENDYN**, where the breakpoints of the waveform itself take a random walk
- One analysed **spectrum**, four selection criteria, four different chords, and the disagreement is the lesson

<span class="q">Is there a difference between composing music and composing sounds?</span>

---
class: light
---

# One Rate, Three Kinds of Thing

<div class="shot"><img src="/figures/rate-000.svg" /></div>

<div class="src">(the boundary classes 09 and 11 are built on)</div>

<!--
Nothing about the generator changes across this axis. Only how fast it is read. Around 20 Hz
a sequence of events stops being countable and turns into a pitch, and that is the same
threshold the grain-rate demo crosses.
-->

---
class: light
---

# Particles

> "point, pulse, line, and surface emerge as particle density increases"

<div class="src">(Curtis Roads)</div>
<div class="fig"><img src="/figures/roads-000.png" /></div>

<!--
One quantity changes, density, and the kind of thing you are hearing changes with it. That is
the whole of class 11 in a sentence.
-->

---

# Systems That Run

What happens when it runs without you.

<span class="note">Classes 13 Errors and Glitches, 14 Iterative Systems, 15 Feedback and Cybernetics, 17 Machine Learning, 28 Generative AI and Agents</span>

- The **logistic map** at r = 2.8, 3.2, 3.5, 3.56 and 3.9: period one, two, four, eight, then chaos, from one equation
- Jaap Vink's chain of delay, filter, ring modulation and compression, where **removing any one component stops it working**
- A system that **listens to its own output** and regulates itself
- A model that writes the **rule** rather than the sound

<span class="q">If you set the conditions rather than choose the events, where did the composing happen?</span>

---

# One Equation, Iterated

$$x_{n+1} = r \cdot x_n \cdot (1 - x_n)$$

```supercollider
~logistic = { |r = 3.9, x = 0.5, n = 64| n.collect { x = r * x * (1 - x) } };
```

Feed it four values of **r** and print the last six numbers each time:

```
r = 2.8   [ 0.643, 0.643, 0.643, 0.643, 0.643, 0.643 ]
r = 3.2   [ 0.799, 0.513, 0.799, 0.513, 0.799, 0.513 ]
r = 3.5   [ 0.827, 0.501, 0.875, 0.383, 0.827, 0.501 ]
r = 3.9   [ 0.120, 0.413, 0.945, 0.202, 0.628, 0.911 ]
```

One value, then two, then four, then none of them repeating. **Nothing was random.**

<!--
Real output, not an illustration. Open /tools/chaos and sweep r to see the same thing as a
picture. Then map the numbers to pitch, which is the next block in Intro.scd.
-->

---
class: light
---

# Frontier between thinking and acting

> "In various forms of algorithmic techniques, a peculiar intermediacy between mental and physical acts and a strong affinity toward a reflective attitude by means of mechanisms can be observed. From one point of view, their mechanisms may be seen as an externalization of reasoning. From the other, one can consider them as acting patterns setting cognitive constraints. Addressing the frontier between thinking and acting, the algorithm is necessarily an ambiguous term."

<div class="src">(Julian Rohrhuber)</div>
<div class="fig"><img src="/figures/rohrhuber-000.png" /></div>

---
class: light
---

# The Objective

> "As soon as you create an objective, you ruin your ability to reach it."

> "If you're wondering how to escape the myth of the objective, just do things because they're interesting."

<div class="src">(Kenneth Stanley, Why Greatness Cannot Be Planned, 2015)</div>

<!--
Hold this against the whole year, and especially against class 28: a prompt is an objective,
stated in advance. Stanley is the argument for not stating one.
-->

---

# Ears and Surfaces

What reaches a listener, and whose ear it is.

<span class="note">Classes 10 Recording and Processing, 18 Listening Machines, 20 Gesture and Texture, 23 Sonorities and Materials, 24 Drawing and Notation</span>

- **Reduced listening** and the sound object: hearing a sound as itself rather than as its cause
- An analyser reporting a loudness of 0.192486 on **silence**, and a pitch tracker holding its last value: a listening machine that looks healthy and hears nothing
- Smalley's **archetypes**, a vocabulary for describing a sound rather than making one
- A **drawn curve** read as frequency over time

<span class="q">Who is the listener you are composing for, and is it necessarily a person?</span>

---

# What the Analyser Reports

Three numbers a machine will offer about any sound.

```supercollider
{
	var snd = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
	var amp = Amplitude.kr(snd);
	var freq = Pitch.kr(snd)[0];
	var centroid = SpecCentroid.kr(FFT(LocalBuf(2048), snd));
	[amp, freq, centroid].poll(2, ["amp", "freq", "centroid"]);
	snd * 0.5 ! 2
}.play
```

Now stop the sound and watch the numbers. Amplitude falls to zero, and **`Pitch` keeps reporting whatever it last found**.

<span class="q">A listener that cannot tell silence from a held note. What else is it not telling you?</span>

<!--
This is class 18 in one block. The machine's ear is not a worse ear, it is a different one,
and the interesting part is the shape of what it misses.
-->

---
class: light
---

# Anticommunication

> "A relation between persons and things which emerges and is maintained through messages requiring and permitting not yet available encoding and decoding systems or mechanisms."

> "Anticommunication is an attempt at saying something, not a refusal to say it. Communication is achievable by learning from language how to say something. Anticommunication is an attempt at respectfully teaching language to say it."

<div class="src">(Herbert Brün)</div>
<div class="fig"><img src="/figures/brun-000.png" /></div>

---

# The Craft That Serves All Four

Four classes cut across every thread rather than belonging to one.

- **03 Patterns and Streams** is the tool the whole year is written with
- **16 Mapping and Control** is the join: what you connect to what is the compositional decision
- **22 Rhythm and Time** is time itself, from the sieve to the Risset rhythm
- **26 Live Coding** is the rule changed while it is still running
- **25 Own Works** is the case study, with the code open beside the piece

<span class="workshop">- workshop -</span>

<span class="note">04 is where you try it, with a duration, one sound source and one prohibition.</span>

---
class: light
---

# Determining Indeterminacy

> Computation is "a process of determining indeterminacy."

<div class="src">(M. Beatrice Fazi, Contingent Computation, 2018)</div>

<!--
Close on this. Not the deterministic execution of pre-given rules, but a process that makes
something that was not specified. That is the year's wager, and the last class tests it.
-->

---
layout: center
class: divider
---

&nbsp;
