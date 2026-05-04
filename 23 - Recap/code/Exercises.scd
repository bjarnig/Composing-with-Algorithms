////////////////////////////////////////////////////////////////
//
//     Composing with Algorithms - 15 Recap Exercises
//
////////////////////////////////////////////////////////////////

/*

These exercises span the full course material.
Each one combines multiple techniques from different classes.

Difficulty: * = straightforward, ** = moderate, *** = challenging

*/


////////////////////////// SynthDefs ///////////////////////////

// Evaluate this block first!

(

SynthDef(\sine, {
	|out=0, amp=0.1, freq=440, rel=0.2, pan=0|
	var env, sig;
	env = EnvGen.kr(Env.perc(rel:rel), doneAction:2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\saw, {
	|out=0, freq=440, rel=0.5, lop=2000, res=0.5, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction:2);
	sig = Saw.ar(freq) * amp;
	sig = BLowPass4.ar(sig, lop, res);
	Out.ar(out, Pan2.ar(sig, pan, env));
}).add;

SynthDef(\monosaw, {
	|out=0, freq=440, lop=2000, res=0.5, amp=0.2, pan=0, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 0.1), gate, doneAction:2);
	sig = Saw.ar(freq) * amp;
	sig = BLowPass4.ar(sig, lop, res);
	Out.ar(out, Pan2.ar(sig, pan, env));
}).add;

SynthDef(\pluck, {
	|amp=0.1, freq=440, decay=4, coef=0.1, pan=0|
	var env, sig, delay;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction:2);
	sig = WhiteNoise.ar(amp);
	delay = freq.reciprocal;
	sig = Pluck.ar(in:sig, delaytime:delay, decaytime:decay, coef:coef);
	Out.ar(0, Pan2.ar(sig * 0.5, pan));
}).add;

SynthDef(\snd, { arg freq=500, gate=1, out=0, lop=8000, amp=0.1, pan=0, atk=0.01, rel=0.25;
	var env = EnvGen.kr(Env.asr(atk, amp, rel), gate, doneAction:2);
	var signal = RLPF.ar(Saw.ar(freq, 0.25).fold2(SinOsc.ar(freq/2)), lop);
    OffsetOut.ar(out, Pan2.ar(signal * env, pan));
}).add;

SynthDef(\fm, {|out=0, freq=400, cmRatio=1.5, index=3, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, modFreq, env;
	modFreq = freq * cmRatio.reciprocal;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = PMOsc.ar(freq, modFreq, index) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

)


////////////////////////////////////////////////////////////////
//                       EXERCISES
////////////////////////////////////////////////////////////////


/*
EXERCISE 1: Alea and Series (Koenig) *
Topics: Prand, Plazy, Pseq, scramble

Create a pattern that:
- Defines a collection of 6 pitches and 4 rhythms
- Plays through the pitches in a random order (scramble),
  completing all pitches before reshuffling (Koenig's "Series")
- Uses Prand for the rhythms

Hint: Use Plazy with Pseq and .scramble inside Pn
*/

// Your solution here:




/*
EXERCISE 2: Gaussian Cloud *
Topics: Pgauss, Pexprand

Create a dense cloud of sine tones where:
- Pitches cluster around MIDI note 66, deviation of 6
- Durations are very fast (0.03 - 0.08)
- Amplitudes use exponential distribution (favoring quiet)
- Release times are long (1-2 seconds) so notes overlap

This should sound like a shimmering cluster.
*/

// Your solution here:




/*
EXERCISE 3: Brownian Walk with Correlated Parameters **
Topics: Pbrown, Pkey, linexp, linlin

Create a Pbind where:
- Pitch uses Pbrown (MIDI 36-84, step 4)
- Filter cutoff is derived from pitch using Pkey
  (low notes = low cutoff, high notes = high cutoff)
- Duration is inversely related to pitch
  (high = fast 0.05s, low = slow 0.3s)
- Use \saw as the instrument
*/

// Your solution here:




/*
EXERCISE 4: Markov Melody with Phrases **
Topics: MarkovSetN, Pswitch, Pseq

Create a piece where:
- 3 melodic phrases are defined as Pseq patterns
- A MarkovSetN controls which phrase plays next
- Phrase A (ascending) usually leads to B
- Phrase B (descending) usually leads to C
- Phrase C (held notes) always returns to A

Requires the MathLib quark: Quarks.install("MathLib")
*/

// Your solution here:




/*
EXERCISE 5: Tendency Mask Composition **
Topics: Pwhite, Pseg, Pseq

Create a 20-second piece where:
- Pitch boundaries narrow from wide (30-90) to tight (58-62)
  and back to wide again
- Use Pseg for both boundaries
- Duration is fast (0.08)
- The effect should be: scattered -> focused -> scattered
*/

// Your solution here:




/*
EXERCISE 6: Three-Part Form with Pspawner **
Topics: Pspawner, spawner.seq, spawner.par, spawner.wait

Create an ABA form:
- Section A: low register, sparse (pluck, MIDI 36-48, dur 0.25)
- Section B: two overlapping layers in parallel
  (sine high MIDI 72-84 + sine mid MIDI 55-67)
- Section A returns
- 1 second silence between sections

Use spawner.seq for sequential and spawner.par for parallel.
*/

// Your solution here:




/*
EXERCISE 7: FM Synthesis with Patterns **
Topics: PMOsc, cmRatio, index, Pbind

Using the \fm SynthDef, create a pattern where:
- Pitch follows a Pseq arpeggio [48, 55, 60, 64, 67]
- The carrier/modulator ratio (cmRatio) changes per note
  using Pseq [1.5, 2, 3, 1, 2.5]
- The modulation index grows from 1 to 12 using Pseries
- Duration alternates between 0.1 and 0.2
*/

// Your solution here:




/*
EXERCISE 8: Granular Texture *
Topics: GrainFM, GrainSin, Dust, Mix.fill

Create a granular texture using GrainFM where:
- 5 layers are mixed together (Mix.fill)
- Each layer has a different random base frequency (100-800)
- Triggered by Dust at density 30
- Grain duration is 0.02 seconds
- Modulation amount increases from 0.1 to 1.0 over 8 seconds
  using Line.ar
*/

// Your solution here:




/*
EXERCISE 9: Chaos-Controlled Synthesis **
Topics: HenonN, CuspN, StandardL, range

Create a sound where:
- HenonN controls the frequency of a Blip oscillator
  (range 100-500 Hz)
- GbmanN controls the number of harmonics (range 5-50)
- An envelope fades in over 5 seconds and out over 5 seconds
- The result should be an evolving, unpredictable timbre
*/

// Your solution here:




/*
EXERCISE 10: Error / Glitch Composition **
Topics: Latch, Impulse, round, LFNoise0

Create a glitch piece that simulates degrading audio:
- Start with a clean sine tone (440 Hz)
- Apply sample rate reduction using Latch + Impulse
- The sample rate degrades over time (44100 -> 2000)
  using Line.kr over 10 seconds
- Add bit depth reduction using .round()
  that also gets worse over time
*/

// Your solution here:




/*
EXERCISE 11: Pmono Drone with Evolving Filter ***
Topics: Pmono, Pseg, Pwhite, monosaw

Create two Pmono drones layered with Ppar:
- Drone 1: freq glides between 80-200 Hz (Pseg, 3 sec each)
            filter (lop) glides between 400-2000 Hz
- Drone 2: freq glides between 150-350 Hz (Pseg, 4 sec each)
            filter (lop) glides between 600-3000 Hz
- Both use \monosaw, dur 0.1, amp 0.1
- Should last at least 20 seconds
*/

// Your solution here:




/*
EXERCISE 12: Distribution Showcase with Pspawner ***
Topics: Pspawner, Pwhite, Pgauss, Pexprand, Pcauchy

Create a piece in 4 sections using Pspawner, where each
section uses a DIFFERENT distribution for pitch:
- Section 1: Pwhite (uniform) — 16 notes
- Section 2: Pgauss (mean 60, dev 6) — 16 notes
- Section 3: Pexprand (48-72) — 16 notes
- Section 4: Pcauchy (mean 60, spread 5, clipped 48-72) — 16 notes
- 1 second wait between sections
- Use the same instrument, duration and amplitude for all sections
  so the statistical difference is audible
*/

// Your solution here:




/*
EXERCISE 13: Sample & Hold Polyrhythm ***
Topics: Pclutch, Pwhite, Ppar

Create a polyrhythmic texture using Pclutch in 3 layers:
- Layer 1: freq updates every 3rd note
  Pclutch(Pwhite(200,400), Pseq([1,0,0], inf))
- Layer 2: freq updates every 5th note
  Pclutch(Pwhite(400,800), Pseq([1,0,0,0,0], inf))
- Layer 3: freq updates every 7th note
  Pclutch(Pwhite(800,1600), Pseq([1,0,0,0,0,0,0], inf))
- All layers dur 0.1
- Use Ppar to combine them
*/

// Your solution here:




/*
EXERCISE 14: Feedback Network ***
Topics: LocalIn, LocalOut, DelayC, Limiter

Create a feedback SynthDef where:
- Source signal is Dust.ar(5)
- LocalIn feeds back 2 channels
- The feedback is filtered with OnePole (coef 0.7)
- Delayed with DelayC (randomized delay times using LFNoise2)
- LocalOut feeds back at 0.98 amplitude
- Output through Limiter for safety
- Test with different feedback and delay values
*/

// Your solution here:




/*
EXERCISE 15: Full Algorithmic Piece ***
Topics: Combine

Create a 30-second piece that uses at least 5 different techniques:
- Pspawner for form (intro, development, ending)
- Tendency masks for pitch in at least one section
- A Markov chain or Pfsm for another section
- Pbrown for smooth transitions
- Ppar for layering
- At least 2 different synths

Plan your form on paper first. The piece should have
a clear beginning, middle, and end.
*/

// Your solution here:




////////////////////////////////////////////////////////////////
//
//                      Reference
//
////////////////////////////////////////////////////////////////

/*

PATTERNS:

Sequencing:    Pseq, Prand, Pwhite, Pbrown, Pseries, Pgeom
Distribution:  Pgauss, Pexprand, Phprand, Plprand, Pcauchy, Pbeta, Ppoisson
Control:       Pkey, Pfunc, Pif, Pclutch, Pstep, Pseg
Structure:     Ppar, Pspawner, Pfsm, Pswitch, Pdef, PatternProxy
Repetition:    Pstutter, Pn, Plazy
Timing:        Ptime, Pfindur

SYNTHESIS:

Additive:      SinOsc, DynKlang, Mix.fill
Subtractive:   Saw + RLPF/BLowPass4/MoogFF/DFM1
FM:            PMOsc, SinOsc with modulation
Granular:      GrainFM, GrainSin, GrainBuf, TGrains
Physical:      Pluck
Chaotic:       HenonN, GbmanL, StandardL, CuspN, LorenzL

EFFECTS:

Delay:         DelayL, CombL, AllpassL
Feedback:      LocalIn/LocalOut
Reverb:        AllpassN chains, GVerb, FreeVerb
Distortion:    .round, .fold2, .distort, Shaper
Spectral:      FFT/IFFT, PV_MagFreeze, PV_BrickWall

*/
