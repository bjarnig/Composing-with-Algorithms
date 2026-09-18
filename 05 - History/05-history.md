---
theme: seriph
addons:
  - ./shared
title: Composing with Algorithms — 05 Algorithmic Composition
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

<div class="deck-title">Algorithmic Composition</div>

<div class="sub">
  Composing with Algorithms
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---
layout: center
class: divider
---

Algorithm

---

# Algorithm

Algorithm a mediation between existing ideas and practical realisations.

Algorithmic processes as implementations to realise an idea or to explore compositional ideas.

---
class: light
---

# Boundaries of Imagination

> "If the composers would have to program each of their ideas for a computer system, they would have to define as accurately as possible what they are looking for. It is to be expected that the computer system will respond with far greater a quantity of propositions answering the definition than the composer's mind alone is either conscious of, or able to imagine. At the same time, it would provide for an exact, step-by-step record of all the proceedings between initial definition and final choice. The composer's choice from the computer's propositions would still remain a highly personal decision, but would be taken in a field which is not limited by the prejudicial boundaries of the choosing person's imagination."

<div class="src">(Herbert Brün)</div>

---

# Algorithm

A set of well-defined steps for solving a particular problem.

Term derived from the name of the Persian mathematician **Muhammad ibn Musa al-Khwarizmi** who introduced algebra to western mathematics.

An algorithm proceeds from an **initial state** and executes operations defined for each step until none is left and an **output** has been made.

Could refer to a method, procedure, operation or technique.

---

# Pseudocode

Pseudocode is an informal language used for specifying algorithms.

```text
INPUT:     Length, Sounds, Durations and Intensities
VARIABLES: ListOfEvents, CurrentLength

LOOP: until the duration has been filled
    choose a random sound S
    choose a random duration D
    choose a random intensity I
    create event E from S, D and I
    add E to the ListOfEvents
    increase CurrentLength by D
```

---
layout: center
class: divider
---

Before the computer

---

# Guido d'Arezzo

Established the framework for traditional music notation.

In **1026** he used rule-based methods for composing music.

Created **lookup tables** for translating vowels to notes. The vowels come from a Latin text.

A vowel could correspond to several pitches. Compositional choices had to be made regarding which pitches to choose.

<span class="note">What formalisation buys, in the eleventh century: a way of teaching a skill that had been learned only by ear.</span>

---
class: light
---

# Guido d'Arezzo

A table determines the compositional rules and therefore the possible music created.

<div class="shot"><img src="/figures/guido-table-000.png" /></div>

<div class="src">(vowel lookup table for translating vowels to pitches)</div>

---

# Kircher

Athanasius Kircher (1602-1680).

**Combinatorial tables**: pre-composed fragments combined systematically.

**Rule-bound procedures**: deterministic schemes, not true randomness.

**Counterpoint as system**: step-by-step execution of rules.

Anticipated music as a rule-based process.

---
class: light
---

# Kircher

<div class="fig"><img src="/figures/kircher-statue-000.png" /></div>

<div class="src">(Athanasius Kircher, a talking statue, Phonurgia Nova, 1673)</div>

---

# Mozart

Used **musical dice games** to generate compositions from pre-composed materials (1787).

Different versions of each measure were pre-composed and the dice rolled to determine how these would occur in a piece.

A table of rules is used to look up which measures to use after a dice roll.

For some steps only a certain measure was possible no matter what the dice roll outcome was.

---
class: light
---

# Mozart

<div class="shot"><img src="/figures/mozart-table-000.png" /></div>

<div class="src">(table of rules used to select specific measures given a certain dice roll)</div>

---

# Musikalisches Würfelspiel

<AudioEmbed src="/demos/dice/" height="22rem" label="the dice game, interactive" />

<span class="note">Sixteen bars, eleven alternatives each. The dice choose a row; nothing is composed at the moment of playing.</span>

---

# Ada Lovelace

> "[The Analytical Engine] might act upon other things besides number, were objects found whose mutual fundamental relations could be expressed by those of the abstract science of operations, and which should be also susceptible of adaptations to the action of the operating notation and mechanism of the engine… Supposing, for instance, that the fundamental relations of pitched sounds in the science of harmony and of musical composition were susceptible of such expression and adaptations, the engine might compose elaborate and scientific pieces of music of any degree of complexity or extent."

---
class: light
---

# Analytical Engine

<div class="fig"><img src="/figures/analytical-engine-000.png" /></div>

<div class="src">(the proposed design for the Analytical Engine, a mechanical general-purpose computer designed by Charles Babbage, mid-1830s)</div>

---
layout: center
class: divider
---

Formalisation

---

# The Schillinger System

Joseph Schillinger developed a method of composition based on mathematics and algorithms in **1946**.

Not bound to a style and was aimed at helping the composer to generate material instead of limiting him within a closed system.

The publication consists of two volumes and a total of 1640 pages.

> "My system does not circumscribe the composer's freedom, but merely points out the methodological way to arrive at a decision. Any decision, which results in a harmonic relation, is fully acceptable. We are opposed only to vagueness and haphazard speculation."

---

# The Schillinger System

Comprehensive mathematical method for **rhythm**, **melody**, **harmony** and **form**.

Used permutation, combinatorics and geometric transformations.

**Deterministic**: rules plus input give predictable musical output.

Bridge between pre-computer rule systems and later algorithmic formalism.

---
class: light
---

# Schillinger

<div class="shot"><img src="/figures/schillinger-graph-000.png" /></div>

<div class="src">(barlines at the bottom of the graph, pitch names on the left, each pitch on the y-axis; the lines above the melodic graph are period, measure and phrase divisions)</div>

---
class: light
---

# Schillinger

<div class="fig tall"><img src="/figures/schillinger-sheet-000.png" /></div>

---

# Conlon Nancarrow

Composed directly onto **player piano rolls**, punched by hand.

Explored rhythmic complexity: tempo canons, accelerations, irrational ratios.

**Rule-based procedures**: systematic transformations of rhythm and pitch.

Music often unplayable by humans, but exact for machines.

Seen as a precursor to computer music: hand-coded algorithms for a mechanical instrument.

---
class: light
---

# Conlon Nancarrow

<div class="fig tall"><img src="/figures/nancarrow-000.png" /></div>

---

# Johanna Beyer

*Music of the Spheres* (**1938**) is routinely described as the earliest score by a woman calling for electrical instruments.

The score specifies an **electrical instrument** without specifying which one, so the realisation is left open and every performance decides the timbre.

Almost nothing of hers was published in her lifetime.

<span class="note">The piece reached a wider audience through the 1977 anthology New Music for Electronic and Recorded Media.</span>

---
layout: center
class: divider
---

Serialism

---

# Serialism

After World War II, several composers continued to develop the serial technique invented earlier by **Arnold Schönberg**.

A general tendency was to extend the serial principles to organize **time**, **timbre** and **dynamics**. The series would function as a unifying element, or algorithm, controlling every detail of a composition.

Transformations such as **transposition**, **inversion**, **retrograde** and **permutation** serve to vary the base series.

Brings forward issues such as formalization, total control, parametric spaces and compositional dimensions.

<span class="note">What formalisation buys, around 1950: a guarantee that nothing in the piece was arrived at by habit.</span>

---

# Serialism

**Pierre Boulez** composed his *Structures 1a* during a single night in **1951**, applying the serial principles to pitches, durations and articulations.

Automatic procedures applied to predetermined material could thus generate entire compositions.

---
class: light
---

# Structures 1a

> "I wanted to eradicate from my vocabulary absolutely every trace of the conventional, whether it concerned figures and phrases, or development and form; I then wanted gradually, element after element, to win back the various stages of the compositional process, in such a manner that a perfectly new synthesis might arise, a synthesis that would not be corrupted from the very outset by foreign bodies, stylistic reminiscences in particular."

<div class="src">(Boulez, 1986)</div>

---

# Structures Ia

Written for two pianos.

**Total serialism**: pitch, rhythm, dynamics and articulation all derived from one series.

**Procedural rules**: transformations such as inversion, retrograde and permutation applied systematically.

**Automatic generation**: once rules are set, material unfolds with little intuitive choice.

Aim: eradicate convention, rebuild music from pure parametric control.

<span class="q">If the rules make the piece, what is left of the composer's judgement?</span>

---

# Karel Goeyvaerts

Attended the Darmstadt New Music Summer School, was a friend of Stockhausen and composed music using serial technique.

Held that **sine waves** are the purest of sounds and an important discovery for composing music with.

His *Composition nr 5* is made only of sine tones, and relations among the parametric values are derived from the arithmetic series of the numbers 1 to 11.

Each parameter value is derived from mathematical relationships, and the structure of the piece is generated from **numerical control tables**.

---
layout: center
class: divider
---

Machines

---

# Computers

Computers become available during the postwar years, in the forties and early fifties.

Large, complex, limited and difficult to access in the beginning.

Early machines often had an integrated loudspeaker, called a **hooter**. It was used by various groups of people to make music, and it was based on impulses.

Different hooter tunes were realized but little of quality or with lasting effects on computer music.

---

# Mark 1

Mark 1 was the world's first commercially available general-purpose electronic computer, built in Manchester.

Its instruction set included a **hoot** command, that enabled the machine to give auditory feedback to its operators. The sound generated could be altered in pitch, a feature which was exploited when the Mark 1 made the earliest known recording of computer-generated music in **1951**.

**Alan Turing** in 1951 described the hoot instruction, which applies an impulse to the loudspeaker diaphragm.

These experiments are not considered to have artistic impact or to influence the design of later music software.

---

# Caplan, Prinz

In **1955** Caplan wrote hooter-based music-playing routines. As a demonstration, the *Wilhelmus*, the Dutch national anthem, could be played.

Caplan also wrote music-generating routines:

- based on the **Mozart dice game**
- machine not fast enough, so it composed down an octave
- only used melodic lines

Perhaps can be considered a computer-aided algorithmic composition system, and predates the *Illiac Suite*.

---

# RCA Synthesizer

The first programmable electronic synthesizer, with **paper tape** to control analog sound production (**1955**). The composer entered data as punched hole patterns.

- Input: paper tape, flexible, maximum control time four minutes. The input format was note and event oriented
- Two channels sharing a common bank of sound sources: a white noise generator and twelve oscillators
- Output to speakers but also cut directly to disk

---
class: light
---

# RCA Synthesizer

<div class="shot"><img src="/figures/rca-synthesizer-000.png" /></div>

---

# RCA Synthesizer

Algorithmic aspects.

**Event-oriented programming**: each punch tape symbol encoded musical parameters.

**Deterministic control**: once the tape was prepared, the machine executed exactly what was specified.

**Parameterization**: pitches, durations and dynamics all specified numerically, a strong link to serial procedures.

**Constraint**: limited memory and tape length, about four minutes.

---

# Bebe Barron

Bebe and Louis Barron produced the first entirely electronic feature score, *Forbidden Planet* (**1956**).

They built **circuits after Norbert Wiener's cybernetics**, let each one run until it burned out, and recorded its behaviour. The circuit is the generative source and the tape is what it happened to do.

The studio credited the work as *electronic tonalities* rather than as a score, since the musicians' union would not recognise them as composers.

<span class="q">A credit line that invents a genre and erases an authorship at the same time. Which of those is the algorithm responsible for?</span>

---

# Else Marie Pade

The first Danish composer of electronic and concrete music, from 1954, and later a colleague of Schaeffer, Stockhausen and Boulez.

*Syv Cirkler*, seven circles (**1958**), is her reference work: a tape piece whose durations and proportions are laid out **numerically before any sound is recorded**.

The plan exists on paper, the studio realises it. The procedure and its realisation are separate stages, as they are in the Music N model that arrives a year earlier.

---

# Daphne Oram

Co-founded the BBC Radiophonic Workshop in 1958 and left within about a year, then set up her own studio.

Developed **Oramics**: shapes drawn by hand on 35 mm film strips are read **optically** to generate waveform, envelope and pitch.

A drawn control function is an algorithm in the same sense a breakpoint envelope is: a curve that some other process reads and obeys.

<span class="note">Her book is An Individual Note of Music, Sound and Electronics (1972). Oramics belongs beside non-standard synthesis, not only beside the studio histories.</span>

---

# Delia Derbyshire

**Realised** Ron Grainer's *Doctor Who* theme (**1963**) at the Radiophonic Workshop, from a page of written instructions, by cutting and splicing tape and test-oscillator tones.

The composition credit went to Grainer, the realisation credit to the Workshop.

The interesting question is not whether she deserved a credit. It is that **the technical labour of executing a specification had no authorship category at all**.

<span class="q">A program is a specification, and running it is a realisation. Who composed the output?</span>

---
layout: center
class: divider
---

Music N

---

# Music N

First to use the **unit generator** concept, where synthesis networks are designed by passing a signal through a series of unit generators (**1957**).

An **instrument** is a basic program which takes the parameters of a note and generates the appropriate samples.

Unit generators: oscillators, envelope generators, mixers, filters.

**Score** definition: notes containing parameters for instruments.

The note paradigm still dominates computer music. Sound transformations are considered effects.

<span class="note">Punch cards in, tape out, tape to a digital-to-analogue converter.</span>

---

# Music N

**Music as process**: composers write algorithms, rules for generating notes and events, rather than direct performances.

**Generativity**: parameter sets can be manipulated systematically with formulas, probability and transformations.

**Modularity as algorithm**: unit generators can be combined recursively, like functions in code.

**Conceptual shift**: the note becomes a data structure, which enables algorithmic manipulation of entire musical forms.

Encouraged exploration: composers begin to think in terms of procedures, systems and computation rather than fixed scores.

---
layout: center
class: divider
---

Illinois

---

# Lejaren Hiller

Trained as a chemist and realized the first computer-generated composition, the *Illiac Suite* (**1956-1957**), with fellow chemist Leonard Isaacson at the University of Illinois.

Saw music as related to **information theory**, where a piece was like extracting order out of chaos using rules.

His algorithms often used **random numbers tested by rules** that determine succeeding steps. The resulting data would then be transcribed to musical notation.

---
class: light
---

# Lejaren Hiller

> "Music is . . . governed by laws of organization, which permit fairly exact codification. (. . . it has even been claimed that the content of music is nothing other than its organization.) From this proposition, it follows that computer-composed music which is 'meaningful' is conceivable to the extent to which the laws of musical organization are codifiable."

<div class="src">(Hiller, on the Illiac Suite)</div>

---

# Illiac Suite

Each of the four movements uses different algorithms.

**Rule-based generation**: compositional rules were encoded as logical conditions.

**Stochastic choice**: random numbers provided variation within constraints.

**Filtering process**: the computer generated many options and the rules decided what was acceptable.

**Output**: notation, a string quartet score, not sound.

Hiller wrote an article in *Scientific American* describing the piece and computer music, which generated much feedback.

---
class: light
---

# Illiac Suite

<div class="fig"><img src="/figures/illiac-000.png" /></div>

<div class="src">(the ILLIAC I computer)</div>

---

# University of Illinois

Hiller moved to the music department and founded the **Experimental Music Studio**.

Composers interested in working with computers and electric sound later joined, for example **James Tenney** and **Herbert Brün**.

Tenney realized compositions with software by Max Mathews, became a composer-in-residence at Bell Labs and was interested in applying stochastic procedures to composition.

Brün was interested in designing processes and listening to the result instead of imagining a sound and trying to create it, to discover what music could be when computers are available.

---

# James Tenney

- Influenced by his study with Lejaren Hiller
- Research composer at Bell Labs 1961 to 1964
- Dissatisfaction with timbre in purely synthetic electronic music
- Psychoacoustic experiments that resulted in random amplitude and frequency modulations
- Wanted to separate **compositional procedures** from **note generation**
- *Dialogue* (1963) is between a tone and a band of noise
- Stochastic control over timbral, durational and pitch parameters

---
class: light
---

# James Tenney

<div class="shot"><img src="/figures/tenney-000.png" /></div>

---
class: light
---

# Dialogue

<div class="fig"><img src="/figures/tenney-dialoge-000.png" /></div>

<div class="src">(James Tenney, Dialogue, 1963)</div>

---
layout: center
class: divider
---

Stochastics

---

# Xenakis

Worked initially as architectural assistant for Le Corbusier in Paris.

Applied ideas from architecture in music, for example in *Metastasis* (1954), where long continuous glissandi create sonic spaces.

Criticized total serialism for destroying itself by complexity, where the methods resulted in "nothing but a mass of notes in different registers".

---

# Xenakis

Proposed **stochastic** music, where the organization of materials is based on probabilities. First used in *Pithoprakta* (1956).

The use of statistical methods resulted in a formal approach to composition, creating a compositional model for the "fundamental phases of a musical work".

<span class="note">The next class is entirely about this, so here it is only one step in the line.</span>

---

# Xenakis

Developed a computer algorithm **ST** (1964) which was implemented by IBM in Paris and used to generate a family of different pieces.

Used various other algorithms for composing music such as:

- Markov chains
- Screens (granular synthesis)
- Strategy games
- Boolean algebra
- Set theory
- Brownian motion
- Cellular automata

---
layout: center
class: divider
---

Utrecht

---

# Gottfried Michael Koenig

Implemented his first compositional program, **Project 1**, in **1966** at the Institute of Sonology in Utrecht.

Enables the composer to investigate a simple compositional model.

Parameter values are chosen between **regular** and **irregular** on a scale from 1 to 7.

The result of the program is output in the form of a **score table**. The interpretation of the table data and the transfer to notation is very important.

---

# Gottfried Michael Koenig

Implemented **Project 2** in the sixties. It is based on defining a **database of parameters** and a **structure formula** for selecting and combining those parameters.

Variants of the same structure could be made.

---

# Selection Principles

Koenig's selection principles for treating musical material:

- **Sequence**, a series of values
- **Alea**, random
- **Series**, random with repetition check
- **Ratio**, weighted random
- **Group**, repeated random
- **Tendency**, random with changing boundaries

<span class="note">Each of these has a one-line equivalent in SuperCollider patterns. Class 07 is built on that mapping.</span>

---

# Pierre Barbaud

Algorithmic music as the rational spirit of modernity, whose goal was "to submit the appearance of sound events to calculation, to demolish what is conventionally called 'inspiration', to replace the mystical passivity of the composer in the presence of the 'muse' with lucid and premeditated activity."

Founded the **Groupe de Musique Algorithmique de Paris** (GMAP), joined by Roger Blanchard, Jeannine Charbonnier and Brian de Martinoir in 1960. The group produced a collective composition, *Factorielle 7*, one of the first computer-generated scores.

The piece was built around 5040 combinations of a twelve-tone row (7! = 1x2x3x4x5x6x7 = 5040), devised using aleatoric techniques.

---

# Pierre Barbaud

Barbaud sets in motion a musical process which runs its course **without intervention**.

No ad hoc modifications of the musical output. If it is found aesthetically insufficient, the composer must adjust the controls of the generative algorithm and then let it run again.

<span class="q">You have all done the opposite: fixed the output by hand. What does Barbaud's rule protect?</span>

---
class: light
---

# Pierre Barbaud

<div class="shot"><img src="/figures/barbaud-000.png" /></div>

<div class="src">(a generative routine, in Algol)</div>

---

# Teresa Rampazzi

Italian pianist turned composer, co-founded **NPS**, Nuove Proposte Sonore, in Padua in 1965 and then moved into computer-generated music at the University of Padua's computing centre.

*With the light pen* (**1977**) is made with MUSIC 4BF and then Tisato's ICMS: the **computer case** among her generation, rather than the tape case.

She is far less recovered than the tape composers of the same decade, which is a fact about historiography rather than about the work.

<span class="note">Rediscovery is easy where the artefact is a recording and hard where it is a program, because a program has to be read or run.</span>

---
layout: center
class: divider
---

Chance

---

# Cage

> "Music which should be allowed to grow freely from sound at its very grass roots, for methods of discovering how to let sounds be themselves rather than vehicles for manmade theories, or expression of human sentiments."

<div class="src">(1957)</div>

Applied **chance procedures** to his music, for example with the *I Ching*.

Used a set of **charts** with entries for sonorities, rhythm and dynamics.

---

# Cage

Worked with Hiller on *HPSCHD* (**1967-69**) for seven harpsichords, fifty-one tapes of computer generated music and slide projections.

Cage generalized his procedures in 1982 into computer algorithms with **Andrew Culver**, and used them later in his life.

---
class: light
---

# Abundance

> "Formerly, when one worked alone, at a given point a decision was made, and one went in one direction rather than another; whereas, in the case of working with another person and with computer facilities, the need to work as though decisions were scarce, as though you had to limit yourself to one idea, is no longer pressing. It's a change from the influences of scarcity or economy to the influences of abundance and, I'd be willing to say, waste."

<div class="src">(John Cage, interview during the composition of HPSCHD)</div>

---
class: light
---

# HPSCHD

<div class="shot"><img src="/figures/hpschd-000.png" /></div>

<div class="src">(performance of HPSCHD at the Assembly Hall of Urbana Campus, University of Illinois)</div>

---
layout: center
class: divider
---

Systems

---

# David Tudor

*Neural Synthesis* combines music, electronics and the inspiration of biology through a custom **hybrid synthesizer**.

The neural-network chip forms the heart of the synthesizer. It consists of 64 non-linear amplifiers, the electronic neurons on the chip, with 10240 programmable connections. Any input signal can be connected to any neuron, the output of which can be fed back to any input.

*Neural Synthesis* relies upon an **overlaying process** exposing different levels of the source material.

---
class: light
---

# David Tudor

The space of possible interneuron configurations is so large that it is difficult to reproduce the behavior of the synthesizer, which can evolve sound on its own over time. Searching for the regions of configurations that produce captivating sound becomes the challenge.

<div class="fig"><img src="/figures/tudor-000.png" /></div>

---

# David Tudor

**Composing by building systems**: networks of circuits set up conditions rather than fixed scores.

**Listening into algorithms**: the music emerged from system behavior, not from pre-determined material.

**Cybernetic practice**: feedback, interaction and adaptation replaced control and prediction.

**Letting go**: the composer becomes a listener and mediator, allowing the system's agency to shape the music. The composer as a performer of systems.

**Blurring roles**: instrument, composition and performance become the same object.

---
class: light
---

# The League of Automatic Music Composers

Collective of electronic music experimentalists from San Francisco, active in the early eighties. Used network models with computers for live performance.

> "We approached the computer network as one large, interactive musical instrument made up of independently programmed automatic music machines, producing a music that was noisy, difficult, often unpredictable, and occasionally beautiful."

<div class="fig"><img src="/figures/league-000.png" /></div>

---

# Pauline Oliveros

*Sonic Meditations* (**1971**) are pieces written as **instructions**: a paragraph of text that tells a group what to listen for and what to do about it.

There is no notation and no sound in the score. The piece is the procedure, and the performers are the machine that runs it.

The **Expanded Instrument System** does the same thing electronically, as a delay network that turns a performance into an ecology rather than a sequence.

<span class="q">Guido's table, Koenig's Project 1 and a Sonic Meditation are all instructions for producing sound. What separates them?</span>

---

# Suzanne Ciani

Worked with the **Buchla 200** from the early seventies, building patches in which the sequencer and the control voltages, not the keyboard, decide what happens.

A patch is a **program**: the routing is the algorithm, the modules are its operators, and the piece is what the configuration does while it runs.

Her commercial sound design of the seventies and eighties put that practice in front of an audience that never heard the word algorithm.

---

# Wendy Carlos

Worked at the Columbia-Princeton Electronic Music Center and was materially involved in the development of Moog's first commercial keyboard instrument.

*Switched-On Bach* (**1968**) did more than any other record to make **synthesis legible as a compositional medium**.

Her later work with **alternative tunings**, notably the Bohlen-Pierce and her own scales, treats tuning as something computed rather than inherited.

---
layout: center
class: divider
---

Instruments

---
class: light
---

# Laurie Spiegel

> "For me the computer is a musical instrument, not a system for automated composition. I want to play with algorithms, not just have them play by themselves."

> "An algorithm is not a finished piece. It is a way of thinking, a set of possibilities. The music is what happens when you live inside that space."

> "I see composing not as making finished objects but as designing processes that can generate an infinite variety of results."

---

# Laurie Spiegel

Algorithms not as constraints, but as **partners in invention**.

*Music Mouse* (**1986**): algorithms embedded in an instrument, where the performer navigates possibilities.

**Interactivity**: music emerges from dialogue between human input and system behavior.

**Transparency of process**: algorithms made audible, directly shaping perception.

**Generativity as compositional stance**: the composer sets conditions, not fixed works.

<span class="note">She worked with the GROOVE system at Bell Labs from 1973 to 1978, so the instrument comes out of thirteen years of writing this kind of code.</span>

---
class: light
---

# Music Mouse

<div class="shot"><img src="/figures/music-mouse-000.png" /></div>

<div class="src">(Laurie Spiegel's Music Mouse for Macintosh)</div>

---

# Brian Eno

> "Since I have always preferred making plans to executing them, I have gravitated towards situations and systems that, once set into operation, could create music with little or no intervention on my part. That is to say, I tend towards the roles of planner and programmer, and then become an audience to the results."

*Music for Airports* (**1978**) uses tape loops of different lengths causing evolving patterns due to phasing. The vocal-only piece repeats its first note every 23 seconds, the next one every 25, the third every 29 and so on.

---

# Brian Eno

Released *Generative Music 1* (**1996**) using only **SSEYO Koan**, a generative software, to create the music he describes as ever-different and changing.

Hopes for three kinds of music: live, recorded and generative.

---
layout: center
class: divider
---

Style

---

# David Cope

> "I envision a time in which new works will be convincingly composed in the styles of composers long dead. These will be commonplace and, while never as good as the originals, they will be exciting, entertaining, and interesting."

<div class="src">(1982)</div>

Cope created software that produces output in the style of various composers. Software that attempts to replicate, not create.

His method uses **pattern matching** and **style databases**.

---

# Composition or Music Theory

In algorithmic composition much discussion has been on how to program software that generates **plausible** results that appear to be in a certain style or to emulate a composer.

One belief states that computers should learn a musical structure and then reproduce it. The idea itself prevents invention but encourages copying of ideas.

A possible confusion is between the different goals of **composition** on the one hand and **music theory** or **artificial intelligence** on the other.

---
class: light
---

# Imagination

> "Ultimately, the limitation with the computer is only the limitation of the imagination itself. Perhaps our imagination is not yet open enough or vast enough to know exactly what to do to exceed our limitations. I think that this is one of the reasons why someone like Xenakis was interested in a program like the Gendyn program; he wanted to be surprised. He wanted to do something in which he had some control over the process, but in which the results would go beyond what he could possibly imagine. The question of how to use one's imagination but not be constrained by its limitations is a central one in regard to the use of the computer in creating music."

<div class="src">(Gerard Pape, 2003)</div>

---
layout: center
class: divider
---

Now

---

# Mark Fell

*Multistability* (**2010**) and the *Sensate Focus* series treat the **grid** itself as the compositional object.

Fell argues that metric time and the quantised grid are not neutral tools. They carry assumptions about time, labour and value, and they shape what a composer is able to think.

> "To compose against the grid is to compose against the dominant temporality of our time."

The rule being examined is the one the software imposes before any code is written.

---

# EVOL

Roc Jiménez de Cisneros and Anna Ramos work as **EVOL** on computer music built from **exhaustive permutation**: a small set of parameters, every combination of them, played out at length.

*Rave Slime* (**2013**) takes the acid line and the rave riff as raw material and subjects them to the same formal treatment Koenig gave a twelve-tone row.

The lineage is Barbaud's: set the process going, do not intervene, and accept what the enumeration produces.

---

# Caterina Barbieri

*Patterns of Consciousness* (**2017**) is made on a Buchla 200 and an **ER-101 step sequencer**.

Each piece is a generative entity whose growth is embedded in its **opening instructions**. The sequencer's rule is the composition; what is heard is that rule unfolding over fifteen minutes.

Her subject is the **psychoacoustics of pattern**: what repetition does to perception once a listener has stopped tracking individual notes.

<span class="note">Sixty years after the Illiac Suite, the machine is a sequencer and the score is still a rule.</span>

---

# Kali Malone

*The Sacrificial Code* (**2019**) is written for pipe organ in **historical temperaments and just intonation**.

The tuning is **computed** and the structure follows from it: slowly evolving harmonic cycles in which small frequency ratios become the whole event.

Nothing about the surface is computational, and the method is.

---

# Jessica Ekomane

*Multivocal* (**2019**) is built in Max/MSP on **millisecond-scale phase relationships** and staged quadraphonically.

The room and the listening body are the compositional material: the piece changes as the audience moves, so the algorithm produces a **field** rather than a fixed object.

She draws polyphonies from outside the Western chromatic system, including heptatonic tunings from Malawi.

---

# Holly Herndon

*PROTO* (**2019**) is co-authored with a neural network vocalist called **Spawn** and a Berlin choir, trained on the ensemble it sings with.

The compositional question moves from the rule to the **training data**: who consented, whose voice is in the model, and what authorship means once a piece includes a learned system.

Her later work, the voice model Holly+ and the consent tools built with Mat Dryhurst, treats those questions as material rather than as obstacles.

<span class="q">Cope's software imitated dead composers. What changes when the model is trained on living ones who agreed?</span>

---

# Beatrice Dillon and Elías Merino

*Workaround* (**2020**) is built in **TidalCycles**, at a single fixed tempo throughout, so every rhythmic event is a transformation of one grid.

Merino's *Synthesis of Unlocated Affections* (**2020**) works the other way: discrete computer-generated sonic objects suspended in silence, with no ornament and no continuity between them.

Two opposite uses of the same tools, one pinning everything to a clock and the other refusing one.

---

# Live Coding

The current form of the practice writes the algorithm **in front of the audience**, with the screen projected and the code editable while it sounds.

**Alexandra Cárdenas**, **Shelly Knotts** and **Jia Liu** work in this way. Knotts also writes about it: network music, machine learning in performance, and failure as part of the form.

The rule is no longer prepared in advance and then run. It is written, heard, and rewritten in the same minute.

<span class="note">This is where the course arrives in class 23.</span>

---

# Sixty Years

<span class="q">Hiller generated a string quartet and printed it. Barbieri runs a sequencer and records what it does. Cárdenas types the rule while you listen. What has actually changed, and what has not?</span>

---
layout: center
class: divider
---

Exercises

---

# Exercises

1. A process where a synth is played using a **beta distribution** for pitches and a stutter pattern for duration, where each duration occurs four times.

2. A process where pitches vary between **random**, using either a uniform or an exponential distribution, and predefined ones.

3. A process that plays **two synths** at the same time, where each one has a different rhythm pattern and amplitude trajectory.

4. A process that plays **chords of three notes** each, where each note in the chord has a different amplitude set.

5. A process that will generate a random pitch and **repeat it** for a number of times until it generates another one.

<span class="workshop">- workshop -</span>
