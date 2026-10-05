---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 04 CDP
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

<div class="deck-title">CDP</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---
layout: center
class: divider
---

Sound Transformation

---

# Sound Transformation

*"Making a good transformation is like writing a tune. ... There are no rules."* (Trevor Wishart)

Sound transformation is the process of creating **timbral development** from one sound to another. Sometimes also described as *metamorphosis* from one point to another. The transformation can take place both within a sound continuum or with discrete sounds in a sequence.

Sound transformation can be thought of as a way of organizing **musical development** in electro-acoustic music. The way that sounds forming a piece relate is through the transformation, the change a sound experiences.

---

# Sound Transformation

The nature of a sound calls for a **specific type** of transformations. This means materials and transformations are tightly coupled.

Transformations can have various functions in electronic music. They can for example be used to **generate families** (or networks) of related sounds.

Potential transformations forms a **composable network** of musical outcomes. The organisation of how these appear and relate can form an important part of a composition of electronic music.

---

# Sound Transformation

**Identity**, **development**, **material state** and **mutation** are possible aspects to guide sonic transformations.

Sound transformation is often concerned with **detailed analysis** of sound in order to obtain useful information to use for its procedures. To explore the 'inner' qualities of sounds.

One use of sound transformation can be as a compositional methodology, a certain form of **musical progression** where new material is derived from old. Here, **transformations** serve the structural function of variation.

---
class: light
---

# Sound Transformation

> "Just as states of matter undergo critical phase transitions from solid to liquid to gas to plasma, sound phenomena can pass from one state to another. These zones of morphosis are of extreme interest from an aesthetic point of view, as they are intrinsically exciting and fascinating. Zones of morphosis can be seen as the places where a continuous change in a plastic medium confronts context dependent thresholds of human perception. They occur when a change in quantity in some parameter appears as a qualitative change to the listener."

<div class="src">(Curtis Roads, Composing Electronic Music)</div>

---
class: light
---

# Sound Transformation

> "One of the most ubiquitous zones of morphosis is the simple crossfade. Depending on the source and destination materials, we gradually change the ratio of the amplitudes of two or more signals to effect a sonic mutation. Similarly, an analysis-based morphing algorithm creates a zone of morphosis."

> "Other zones of morphosis appear when sounds are transposed. By means of tape-speed change, pioneers like Stockhausen could speed up discrete melodies to the point where they lost their melodic quality and morphed into continuous timbres. In a similar manner, rhythms, when sped up, change state and morph into tones. Modulations like tremolo and vibrato, when sped up, morph into complex spectra."

<div class="src">(Curtis Roads, Composing Electronic Music)</div>

---
class: light
---

# Sound Transformation

> "Another zone of morphosis is a point of emergence or disappearance, as something comes into being and goes out of being through a critical phase transition. This approach is fostered by treating musical material as a continuous and fluid energy, rather than as a pattern of discrete notes. By means of synthesis and processing, pitch, for example, can be manipulated as a flowing and ephemeral substance to be bent, modulated, or dissolved into noise. Similarly, by means of technology, time becomes a plastic medium that can be generated, modulated, reversed, bent, granulated, and scrambled. The undulations of envelopes and modulations weave into the fiber of musical structure on multiple timescales."

<div class="src">(Curtis Roads, Composing Electronic Music)</div>

---

# Sound Transformation

The composer Rajmil Fischman has provided seven points that might be useful to consider when executing a sound transformation.

1. **Differentiability** (sounds must be perceived as A and B)
2. **Similarity** (sound should also have common properties)
3. **Duration** (duration should come from sound type)
4. **Linearity** (design the transformation curve based on material)
5. **Spatial movement** (spatial processing can aid a transformation)
6. **Diversions** (to include a third sound to distract during the process)
7. **Context** (a transformation should depend on its originated context)

---
layout: center
class: divider
---

CDP

---

# CDP

The **CDP** (Composers Desktop Project) is a collection of sound transformation tools for creative musical contexts.

The aim is to offer new computer tools for sound design and composition with detailed access to the multiple dimensions of sounds. The CDP is not just a set of DSP routines but rather a *toolbox of sound transformation processes* useful for a music concrète practice or similar activities.

CDP runs **offline** (and in many cases faster than realtime). The format is usually: *program input output parameters*.

Common usage is to **chain programs** (feed the output of one to another.) and to **batch process** sounds.

---

# History of CDP

The Composers' Desktop Project has existed since 1986.

Initially the CDP ran on **Atari** machines but was ported to **Windows PCs** in the early 90's.

The early versions of CDP ran on command-line only. GUI components came accessible in the late 90's with *SoundShaper*, *GrainMill* and *Sound Loom*.

Later versions included support for **Mac OSX**, multichannel sound files and many sound transformation tools (400-600 different ones in version six).

In 2014 CDP 7 was released as **free software** and the source code was made public.

---

# CDP

Trevor Wishart defines broad categories of sound transformation instruments:

**Transforming the waveform of a sound**<br>
(transforming loudness contour, filter-banks and 'waveset' distortion)

**Segmenting a sound, and reassembling segments**<br>
(time-stretch, pitch-shift, sound-shred, reverberation and brassage)

**Transforming the time-varying spectrum of a sound**<br>
(spectral tracing, formant manipulation and morphing)

**Building new events from a whole sound**<br>
(iteration, multi-dimensional texture generation and mixing.)

---

# CDP

Some of the key collections of CDP include:

**CDP-FOCUS** – focusing and blurring<br>
**CDP-MORPH** – combinations, morphing and transitions of spectra<br>
**CDP-PITCH** – transposition, pitch-warping, harmony, tuning, loudness, echo & pan<br>
**CDP-TEXTURE** – texture-builder with harmonic/set options<br>
**CDP-X** – more extreme forms of distortion, extension & scrambling<br>
**CDP-UTILS-1** – CDP Time-Domain Editing Functions<br>
**CDP-UTILS-2** – CDP Spectral-Domain Utilities

---

# Installing CDP

*The project site:*<br>
<http://www.composersdesktop.com/>

*The (free) release download page:*<br>
<http://www.unstablesound.net/cdp.html>

A installer will install the core CDP files in the folder **"cdpr7"** in the user's home directory. It also adds an environment variable required by the CDP programs, and updates the user's PATH to enable access from the command line.

Some situations require **manual configuration** described in the Manualconfig.pdf in the cdpr7 directory.

The cdpr7 folder also includes the full (and extensive) **documentation**.

---

# Installing CDP (recent OS)

<span class="note">[ the following might be needed on some OSX versions ]</span>

```text
// Open the bash_profile file with the nano editor
nano ~/.bash_profile
// OR (later OSX versions)
nano ~/.zshrc
// Paste the following at the bottom of the .bash_profile file
PATH=$HOME/cdpr7/_cdp/_cdprogs:$PATH
export PATH

// Save the .bash_profile file
Ctrl-o

// Exit the nano editor
Ctrl-x
```

---

# Soundloom

<div class="plate"><img src="/figures/soundloom-000.png" /></div>

---
layout: center
class: divider
---

Trevor Wishart

---

# Trevor Wishart

English composer, based in York. Interested in using the **human voice** and its transformation in electro-acoustic music.

Wishart is the main user and developer of the CDP system. He is also author of the books:

*On Sonic Art* (discusses new musical possibilities offered by sound art, sound transformation and sound landscapes)

*Audible Design* (detailed discussion of sound transformation instruments and their use in composition)

*Sound Composition* (describes the musical thinking and formal ideas behind Wishart's pieces)

---

# Trevor Wishart

Wishart was influenced by **Xenakis** and initially composed serial music. When his father (who worked in a factory) died he became interested in working with recorded sounds and transforming them.

Wishart believes in **audible sound transformations** over time. That these can create *heard relationships* among sounds forming a composition and create a sense of unification for the piece of music.

Wishart derives his approach of structuring sounds from the concept of **sound metamorphosis**.

---

# Trevor Wishart

Some ideas from Wishart that might be interesting to discuss:

- Wishart feels that music should connect the composer and the listener in a way that a **clear meaning** is communicated through it. *"Music is not an object that sits in the world, it is an object that connects to something"*.
- We can only **follow three different layers** at the same time in music. If there are more, things get too complex and we loose focus on anything above three elements.
- It might be a good idea to **explore everything a sound can offer us** through transformation before we start to compose by using it.

---

# Trevor Wishart

- It is important that the tail of a sound is **"alive"**. Possible methods to do so are via tremolo and subtle-pitch changes.
- Wishart composes all his pieces using only the CDP. With this approach he **mixes each phrase** of the music independently.
- He thinks that each sound is unique and defined by a *variety of characteristics*. Sound transformation should be sensitive to this and therefore not simply process all sounds in the same way but be **guided by its characteristics**.

---

# Trevor Wishart

- **Temporal evolution** of a process is extremely important in order to avoid transformation being only like applying effects.
- Believes that for sound composition the basic metaphor must change from *architecture* to the one of *chemistry*.
- Holds that successful sound transformation needs to involve a **aurally perceptible relationship** between source and destination.
- Wishart holds that a sound has many **dimensions** one can compose for and that these are poorly represented by the traditional view of a sound having distinct parameters for time, pitch and 'colour'.

---
class: light
---

# Trevor Wishart

> "Clearly stating the principal materials is important for the listener in a context where a traditional musical language is not being used; establishing key moments or climaxes in the work; repetition and development, and recapitulation of materials, especially leading towards and away from these foci, and so on. Repetition and (possibly transformed) recapitulation are especially important to the listener to chart a path through an extended musical form. But all sound materials are different, and it is not possible to predict, except in the most obvious ways, what will arise when one begins to transform the sounds. So I spend a lot of time, exploring, playing with, the sources, transforming them, and transforming the transformations, and gradually a formal scheme appropriate to what I discover, and to those particulars materials, crystallizes in the studio."

<div class="src">(Trevor Wishart)</div>

---
class: light
---

# Wishart - Wavesets

<div class="fig tall"><img src="/figures/wishart-wavesets-000.png" /></div>

---
class: light
---

# Wishart - Gesture and Counterpoint

<div class="fig tall"><img src="/figures/wishart-gesture-000.png" /></div>

---
layout: center
class: divider
---

<Listen file="wishart-tongues-of-fire.mp3">Trevor Wishart - Tongues of Fire (1994)</Listen>

---

# Tongues of Fire

- First piece that Wishart completed using **only a desktop PC**.
- All the material in the piece is derived from an improvised 2-second long **vocal utterance** heard at the beginning of the piece.
- The material was organized as a **tree** where the root was the initial material and the branches were all the transformations done with CDP.
- The formal construction of the composition is focused on the development of the initial theme and is echoed at various moment during the piece.
- All phrase building comes from sound transformation with focus on **audible relationships** between each generation of sounds.

---
layout: center
class: divider
---

<Listen file="wishart-american-triptych.mp3">Trevor Wishart - American Triptych (1999)</Listen>

---

# American Triptych

- A commission from **GRM** in Paris and features the voices of three American icons, Martin Luther King, Elvis Presley and Neil Armstrong.
- Wishart sees the piece as a *"voice portrait"* of these men. This idea was first developed by him for the piece *"Two Women"* that uses recordings of Princess Diana and Margaret Thatcher.
- Besides the voices Wishart also used some noises from the transmission when Neil Armstrong spoke from the moon.
- The piece uses extreme **time-stretching** to zoom into individual syllables and create continuity.
- It also uses texturing, rhythmic pulsing and heavy distortion for its sound-transformations.

---
layout: center
class: divider
---

<Listen file="wishart-imago.mp3">Trevor Wishart - Imago (2002)</Listen>

---

# Imago

- Imago was created initially as part of **Jonty Harrison's** surprise 50th year birthday.
- Wishart chose the source material from Jonty Harrison's *'et ainsi de suite'*. The sound he chose is a very short pitched event that comes from a recording of **two whisky glasses clinging**. All other sounds in the piece come from this initial sample.
- The formal construction is focused on a gradual **metamorphosis** of one sound or soundscape into another.
- Many important CDP processes are clearly audible in the piece such as inharmonic spectral sequences, fugu sounds, time contraction, shuddering and spectral blurring.

---
layout: center
class: divider
---

Exercises

---

# Exercises

1. Choose a short sound for input, extend it (using drunk, zigzag or other extend methods) and finally implement a **time varying** (using breakpoints) movement for at least one of the process parameters.

2. Choose two different but still related **waveset distortion** methods to process a sound. Once they have been identified, create a transition from one to the other using the in-between program.

3. Implement a **morphing** between two sounds where the contact points of the material should flow smoothly together. In order to obtain a successful morphing, a potential first step could be to transform them in similar ways before executing the morphing.

4. Implement an algorithmic transformation where **four sounds** are extended in four different ways.

<span class="workshop">- workshop -</span>

---
layout: center
class: divider
---

&nbsp;
