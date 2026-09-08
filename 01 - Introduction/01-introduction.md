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

The course in one line: **exploring computational models of musical processes**.

A **model** of a musical process is a rule set that produces material you did not write out by hand. You decide the rule, the boundaries and what to keep; the procedure decides the events.

Three families, named now so the year has a shape, each with a class of its own later:

- **Cellular automata** — many simple cells, one local rule, a pattern nobody specified
- **Chaotic maps** — one equation iterated, deterministic and still unpredictable
- **Random walks** — each value near the one before it, so a line wanders rather than jumps

<span class="q">What would you delegate to a procedure, and what would you never hand over?</span>

<!--
The last line is the question the whole year keeps asking. Take answers now and write
them down: it is worth reading them back in June.
-->

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

<div class="caption mono">/courses . code == 'composing'</div>

---

# Tools

Two of the three families are also **browser demos**, so they can be played with before anything is installed, and after the course ends:

- <a href="https://slides.bjarni-gunnarsson.net/tools/chaos/">**Chaotic maps**</a> — nine of them, one and two dimensional, audio rate or pitched events, with a bifurcation view
- <a href="https://slides.bjarni-gunnarsson.net/tools/events/">**Event generator**</a> — six distributions and a random walk, applied to duration, frequency and amplitude

<span class="note">Both live under slides.bjarni-gunnarsson.net/tools. A cellular automaton demo is still to come, which completes the trio.</span>

---
layout: center
class: divider
---

Topics

---

# Topics

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

---

# Topics

Class 11, Microsound and Timescales<br>
Class 12, Non-Standard Synthesis<br>
Class 13, Errors and Glitches<br>
Class 14, Iterative Systems<br>
Class 15, Feedback and Cybernetics<br>
Class 16, Mapping and Control<br>
Class 17, Machine Learning<br>
Class 18, Posthuman Listening<br>
Class 19, Sound Transformation

---

# Topics

Class 20, Gesture and Texture<br>
Class 21, Spectral Composition<br>
Class 22, Rhythm and Time<br>
Class 23, Sonorities and Materials<br>
Class 24, Drawing and Notation<br>
Class 25, Own Works<br>
Class 26, Live Coding<br>
Class 27, Composition Processes<br>
Class 28, Open topic

<!--
Twenty-eight classes, one workshop at 04. Class 28 is deliberately left open; the
candidates are in the plan sheet. Do not promise which it will be.
-->

---

# SuperCollider

**SuperCollider** is an environment for real time audio and composition.

SuperCollider consists of an interpreted **object-oriented language** and a state of the art, realtime **sound synthesis server**.

SuperCollider supports different activities such as **sound synthesis**, **digital signal processing**, **algorithmic composition**, **live electronics** and **live coding**.

SuperCollider is *free software*, released under the terms of the GNU General Public License

<a href="https://supercollider.github.io/downloads">supercollider.github.io/downloads</a>

---

# One Line, A Hundred Events

Three notes, stated one at a time. Every value is yours.

```supercollider
Pbind(\instrument, \sine, \dur, 0.2, \midinote, Pseq([60,62,65], inf)).play
```

A range instead of a list. Now you decide the boundaries, not the notes.

```supercollider
Pbind(\instrument, \sine, \dur, 0.2, \freq, Pwhite(400,600)).play
```

A **random walk**: each value near the one before it, so the line wanders rather than jumps. The step size is the whole character.

```supercollider
Pbind(\instrument, \sine, \dur, 0.1, \midinote, Pbrown(36, 84, 4, inf)).play
```

<span class="note">All of it, with the instrument it needs, is in *code/Intro.scd*.</span>

<!--
Run the third one twice, with step 1 and step 12. The difference is audible and it is
the first time this year that a single number changes the character of a whole texture.
-->

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

---

# Representations

How the different **possibilities** of composing with computers are made available to users is a problem of **representation**.

The **possible operations** on sounds, notes, lower or higher-level structures is that what enables meaningful interaction.

With digital technology compositional methods have become reproducible due to their **digital definition** and storage.

The way materials for a composition are **represented** is certainly not something that should be thought of a being fixed. The precise definition of materials, possible operations that transform the material and relationship between them is perhaps part of what is **to be composed**.

---

# Programming

Necessary to do anything **really new** in computer music or should be left to system designers?

Requires a perhaps slightly **different mindset** of problem solving compared to composing music?

Becomes dominant during the creative process in such a way that its **goals** become more important than the initial musical ones?

---

# Programming and Music

Many concepts relate programming and music:

- **Hierarchy** of levels
- **Complexity** of relationships
- **Simultaneous happening** of events
- **Abstraction** of details
- **Structure** of entities
- **Modularisation** of components
- **Reference** to external ideas

---

# Composing Sound

Music exists at **different levels** of time at any given moment.

It is common to distinguish between micro, meso and micro time but many other possible timeframes are imaginable.

<span class="q">Is there a difference between **composing music** and **composing sounds?**</span>

If a music is not based on notes, does it make sense to think of what happens beneath or above the note?

Could we think of the **sounds a music creates** instead of which music sounds create?

---

# Parametrical thinking

A **parameter** is one of the variables that controls the outcome of a system.

**Attributes of a process** are converted to values representing its state where its properties and variability control the value settings.

**Parametrical thinking** enables **limits**, **boundaries**, **parameter spaces** and **mapping** from one to the other.

**Parameter mappings** include *one-to-many*, *many-to-one* and *many-to-many*.

---

# Composition or Music Theory

In **algorithmic composition** much discussion has been on how to program software that generates "plausible" results that appear to be in a *certain style* or to *emulate a composer*.

One belief states that computers should "learn" a musical structure and then reproduce it. The idea itself prevents invention but encourages copying of ideas.

A possible confusion is between the different goals of composition on the one hand and music theory or artificial intelligence on the other.

---

# Approaches

**The working process** and its different possible approaches is important both when **developing** software and **creating** music.

Two opposite poles are the *top-down approach* and the *bottom-up approach*.

The computer is an ideal tool for **inspecting** different aspects at multiple stages of the creation process.

The study of what happens during the evolution of a musical composition made with a computer can give birth to new methods and ways of making music

---
layout: center
class: divider
---

Traces

---
class: light
---

# Material

> "The Cologne studio looked down on composers that "only" had form problems. "Material fetishism" dates from then and could be understood as "form fetishism". Form was not mentioned at all, everything was material; sounds as well as the serial methods. Form was seen more as an automatic consequence of the treatment of material than as an independent category to which the fashioning of sounds ought to be subordinate. When forms were exposed at all they were simple concepts such as the crossform in Kreuzpiel or the group in Gruppen, in both cases they were derived from the treatment of the material. "

<div class="src">(Koenig, Genesis of Form)</div>
<div class="fig"><img src="/figures/koenig-000.png" /></div>

---
class: light
---

# Microtime

> "All compositional manipulations articulating relations between different temporal levels depend essentially on the paradigm adopted by the composer. Evidently, a decision has to be made concerning the status and the nature of these interactions: to consider them as taking place in a continuum organized as a fixed hierarchy [...] or to assume the existence of discontinuities, of nonlinearities, considering (in the last case) microtime, macrotime, and all intermediate dimensions as disjoint (or relative) realms."

<div class="src">(Vaggione, interview with Budon)</div>
<div class="fig"><img src="/figures/vaggione-000.png" /></div>

---
class: light
---

# Sonological Emergence

> "The conceptual separation of composition (or, responsibility on premises and conditions, in my wording) and music (sonic features arising from premises and conditions) perhaps attests to a shared perspective. The implication is that sound is the epiphenomenon of a lower-level process: you design a low-level process, and the interactions and interferences among particle components taking part in the process are heard as a dynamic shape of sound, a process of sonological emergence. "

<div class="src">(Agostino Di Scipio, 2005)</div>
<div class="fig"><img src="/figures/discipio-000.png" /></div>

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
class: light
---

# Agency

> "The presumption that there is an agency, desire, or will belonging to the self and clearly distinguished from the "wills of others" is undercut in the posthuman, for the posthuman's collective heterogeneous quality implies a distributed cognition located in disparate parts that may be in only tenuous communication with one another. […] If "human essence is freedom from the wills of others," the posthuman is "post" not because it is necessarily unfree but because there is no a priori way to identify a self-will that can be clearly distinguished from an other-will."

<div class="src">(Katherine Hayles)</div>
<div class="fig"><img src="/figures/hayles-000.png" /></div>

---
class: light
---

# Assimilation

> "After the different waves of cybernetics, after information and control theory, semiotics and linguistics, cognitive science and artificial intelligence, we are reaching a point … intensified constructivism, or by a renewed realism, both of which de-emphasise the human subject and the categorial split between humans and machines.
> From this standpoint, the interesting question is not so much whether machines can be creative or artistic, but rather how the exchange and assimilation processes between human and machine are structured, and how they can give rise to an aesthetics."

<div class="src">(Hans Holger Rutz)</div>
<div class="fig"><img src="/figures/rutz-000.png" /></div>

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

# Anticommunication

> "A relation between persons and things which emerges and is maintained through messages requiring and permitting not yet available encoding and decoding systems or mechanisms."

> "Anticommunication is an attempt at saying something, not a refusal to say it. Communication is achievable by learning from language how to say something. Anticommunication is an attempt at respectfully teaching language to say it."

<div class="src">(Herbert Brün)</div>
<div class="fig"><img src="/figures/brun-000.png" /></div>

---
class: light
---

# Contagion

> "There is a concrete culture, an aesthetic and a mode of thought, specific to the computational production of new probabilities.[…] contagion is taken here to define the quasi-finitude of algorithmic objects: the fact that these objects are spatiotemporal actualities which cannot be summed up in smaller programs, and which do not result from the sum of their parts."

<div class="src">(Luciana Parisi)</div>
<div class="fig"><img src="/figures/parisi-000.png" /></div>

---
layout: center
class: divider
---

&nbsp;
