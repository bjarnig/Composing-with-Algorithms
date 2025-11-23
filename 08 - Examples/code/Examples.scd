////////////////////////////////////////////////////////////////
//
//               Pattern Techniques & Examples
//
////////////////////////////////////////////////////////////////

/*

1. Pmono - Continuous synths vs event synths
2. Markov Chains - State-based composition
3. Brownian Motion - Random walks in multiple dimensions
4. Probability Distributions
5. Advanced Pattern Control (Pspawner, Pfsm)
6. Gendy - Stochastic synthesis
7. Tendency Masks - Controlled randomness
8. Sample & Hold and other transformations

*/

Be careful with volume. SafetyNet can prevent harmful signals.

(

Quarks.fetchDirectory(true);
Quarks.install("SafetyNet");
Quarks.install("MathLib"); // For MarkovSet
thisProcess.recompile;

)

////////////////////////////////////////////////////////////////
//
//                1. PMONO - Continuous Synths
//
////////////////////////////////////////////////////////////////

/*

Pbind creates a new synth for each event.
Pmono creates one synth and changes its parameters.

*/

// Pbind - each note triggers a new synth (percussive)

(

Pbind(
	\instrument, \pulse,
	\freq, Pseq([100, 200, 700, 800], inf),
	\dur, 0.2,
	\rel, 3,
	\amp, 0.1
).play

)

// Pmono - one synth, parameters change

(

Pmono(
	\pink,
	\freq, Pseg(Pwhite(100,2000),Pwhite(0.1,1.0),'lin',inf).trace,
	\dur, 0.05,
	\amp, 0.1
).play

)

// Example: Smooth gliding

(

Pmono(
	\monosaw,
	\freq, Pwhite(10,1000),
	\lop, Pwhite(500, 4000),
	\res, 0.1,
	\dur, Pwhite(0.1, 0.3),
	\amp, 0.15
).play

)

// Example: Brownian motion on a continuous synth

(

Pmono(
	\monosaw,
	\freq, Pbrown(100, 1000, 10, inf),
	\lop, Pbrown(500, 2000, 100, inf),
	\dur, 0.08,
	\amp, 0.15
).play

)


// Example: Using legato parameter for overlapping notes
// (legato > 1 = overlap, legato < 1 = gaps)

(

Pbind(
	\instrument, \add,
	\degree, Pwhite(0, 7, inf),
	\scale, Scale.lydian,
	\octave, Pwhite(2,5),
	\legato, Pseq([0.2, 0.5, 1.0, 1.5, 2.0], inf),
	\dur, 0.2,
	\rel, 2,
	\amp, 0.1
).play

)


////////////////////////////////////////////////////////////////
//
//              2. MARKOV CHAINS - State Machines
//
////////////////////////////////////////////////////////////////

/*

Markov chains create sequences where the next state depends
on the current state with defined probabilities.

Great for:
- Creating musical phrases with logical flow
- Controlled variation
- Quasi-repetitive structures

*/

// First, a simple state machine with Pfsm
// Format: [initial_states, state1, next_states, state2, next_states, ...]

(

Pbind(
	\instrument, \sine,
	\midinote, Pfsm([
		[0],        // Initial state: 0
		60, [1, 2], // State 0: play 60, go to state 1 or 2
		65, [0, 2], // State 1: play 72, go to state 0 or 2
		67, [0, 1]  // State 2: play 67, go to state 0 or 1
	], inf),
	\dur, 0.15,
	\amp, 0.3
).play

)


// More complex: using patterns as states

(

var low = Pwhite(48, 55, 2);
var mid = Pwhite(60, 67, 3);
var high = Pwhite(72, 79, 4);

Pbind(
	\instrument, \pluck,
	\midinote, Pfsm([
		[0],                    // Start with low
		low, [0, 0, 1],        // Stay low (66%) or go mid (33%)
		mid, [1, 1, 2],        // Stay mid (66%) or go high (33%)
		high, [0, 1, 2]        // Equally likely to go anywhere
	], inf),
	\dur, Pwhite(0.1, 0.2),
	\decay, 2,
	\amp, 0.2
).trace.play

)


// Markov chains with MathLib (more sophisticated)
// Each array: [current_state, next_states, probabilities]

(

m = MarkovSetN([
	// From note 60: 80% to 62, 20% to 65
	[[60], [62, 65], [0.8, 0.2]],
	// From note 62: 70% to 60, 30% to 67
	[[62], [60, 67], [0.7, 0.3]],
	// From note 65: 50% to 67, 50% back to 60
	[[65], [67, 60], [0.5, 0.5]],
	// From note 67: always back to 62
	[[67], [62], [1.0]]
], 1);

m.makeSeeds;

Pbind(
	\instrument, \sine,
	\midinote, m,
	\dur, 0.2,
	\amp, 0.3
).trace.play;

)


// Musical example: Markov chain controlling phrase structure

(

m = MarkovSetN([
	[[0], [1, 2], [0.7, 0.3]],         // Motif A -> usually B, sometimes C
	[[1], [0, 1, 2], [0.5, 0.3, 0.2]], // Motif B -> varied
	[[2], [0], [1.0]]                  // Motif C -> always back to A
], 1);

m.makeSeeds;

~motifs = [
	Pseq([60, 62, 64, 62], 2),  // Motif A
	Pseq([57, 55, 54], 2),      // Motif B
	Pseq([72, 70, 80, 82], 2)   // Motif C
];

Pbind(
	\instrument, \pluck,
	\midinote, Pswitch(~motifs, m).trace,
	\dur, 0.1,
	\decay, 1.5,
	\amp, 0.2
).play;

)


////////////////////////////////////////////////////////////////
//
//            3. BROWNIAN MOTION - Random Walks
//
////////////////////////////////////////////////////////////////

/*

Brownian motion: each value is the previous value plus/minus
a random step. Creates smooth, organic movement.

Pbrown(lo, hi, step, length)
Pgbrown(lo, hi, step, length) - geometric (multiplicative)

*/

// Simple pitch walk

(

Pbind(
	\instrument, \fold,
	\freq, Pbrown(20, 300, 50, inf),
	\dur, 0.1,
	\amp, 0.2
).play

)


// Multi-dimensional brownian motion

(

Pbind(
	\instrument, \gbman,
	\freq, Pbrown(50, 1000, 100, inf),
	\chaos, Pbrown(0.1, 1.0, 0.1, inf),
	\dur, Pbrown(0.08, 0.2, 0.02, inf),
	\rel, Pbrown(0.1, 0.8, 0.1, inf),
	\amp, 0.15
).play

)

// Geometric brownian motion (exponential)

(

Pbind(
	\instrument, \sine,
	\freq, Pgbrown(100, 2000, 1.1, inf).trace,
	\dur, Pgbrown(0.05, 0.5, 1.05, inf),
	\amp, 0.1
).play

)


// Brownian motion as a "drunk walk" through a scale

(

Pbind(
	\instrument, \sine,
	\degree, Pbrown(-12, 12, 2, inf).trace,
	\scale, Scale.minor,
	\octave, Prand([5,7],inf),
	\dur, 0.12,
	\amp, 0.15
).play

)


////////////////////////////////////////////////////////////////
//
//         4. PROBABILITY DISTRIBUTIONS
//
////////////////////////////////////////////////////////////////

/*

Different distributions create different musical characters:

Pwhite(lo, hi)      - uniform/equal distribution
Pexprand(lo, hi)    - exponential (favors lower values)
Phprand(lo, hi)     - favors higher values
Plprand(lo, hi)     - favors lower values
Pmeanrand(lo, hi)   - favors middle values
Pgauss(mean, dev)   - gaussian/normal (bell curve)
Pcauchy(mean, dev)  - cauchy (fat tails, outliers)
Pbeta(lo, hi, a, b) - beta (favors extremes when a,b < 1)
Ppoisson(mean)      - poisson (discrete events)

*/

// VISUALIZE THE DISTRIBUTIONS

(

~plotDist = { |pattern, name="Distribution"|
	var values = pattern.asStream.nextN(1000);
	values.histo(50).plot(
		name: name,
		bounds: Rect(100, 100, 600, 400),
		discrete: false
	);
};

)

~plotDist.value(Pwhite(0, 100), "Uniform (Pwhite)")
~plotDist.value(Pexprand(1, 100), "Exponential")
~plotDist.value(Phprand(0, 100), "High Pass Random")
~plotDist.value(Plprand(0, 100), "Low Pass Random")
~plotDist.value(Pmeanrand(0, 100), "Mean Random")
~plotDist.value(Pgauss(50, 15), "Gaussian")
~plotDist.value(Pcauchy(50, 10).clip(0, 100), "Cauchy (clipped)")
~plotDist.value(Pbeta(0, 100, 0.5, 0.5), "Beta (extremes)")


// Exponential: sparse high notes, dense low notes

(

Pbind(
	\instrument, \sine,
	\midinote, Pexprand(48, 84),
	\dur, 0.05,
	\amp, 0.2
).play

)


// Gaussian: centered around a pitch

(

Pbind(
	\instrument, \sine,
	\midinote, Pgauss(60, 8, inf), // mean=60, deviation=8
	\dur, 0.1,
	\amp, 0.2
).play
)


// Cauchy: mostly centered but with occasional wild outliers

(

Pbind(
	\instrument, \sine,
	\midinote, Pcauchy(60, 5, inf).clip(40, 80),
	\dur, 0.1,
	\amp, 0.2
).play

)


// Beta distribution: favors extremes

(

Pbind(
	\instrument, \saw,
	\midinote, Pwhite(20, 60),
	\amp, Pbeta(0.05, 0.5, 0.5, 0.5, inf), // mostly quiet or loud
	\lop, 2000 * Pkey(\amp),
	\dur, 0.15
).play

)


// Poisson: modeling event occurrences

(

Pbind(
	\instrument, \pluck,
	\midinote, Ppoisson(60, inf).clip(48, 72),
	\decay, 3,
	\dur, 0.1,
	\amp, 0.15
).play

)


////////////////////////////////////////////////////////////////
//
//         5. PSPAWNER - Pattern Sequencing
//
////////////////////////////////////////////////////////////////

/*
Pspawner allows sophisticated control over when patterns
start, stop, and how they overlap.

spawner.seq(pattern)  - sequential (wait for completion)
spawner.par(pattern)  - parallel (start immediately)
spawner.wait(time)    - wait for duration
*/

// Basic example: sequence and parallel

(
~pat1 = Pbind(
	\instrument, \sine,
	\midinote, Pwhite(60, 72, 8),
	\dur, 0.1,
	\amp, 0.2
);

~pat2 = Pbind(
	\instrument, \pluck,
	\midinote, Pwhite(48, 55, 12),
	\dur, 0.2,
	\decay, 2,
	\amp, 0.15
);

Pspawner({ |spawner|
	spawner.seq(~pat1);        // Play pattern 1
	spawner.wait(1);            // Wait 1 second
	spawner.seq(~pat2);        // Then pattern 2
	spawner.wait(1);            // Wait again
	spawner.par(~pat1);        // Start pattern 1
	spawner.par(~pat2);        // Overlay pattern 2
}).play;
)


// Piece using Pspawner

(

~intro = Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 3, 4, 7], 4),
	\octave, 4,
	\dur, 0.1,
	\amp, 0.15
);

~theme = Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 2, 4, 5, 4], 4),
	\scale, Scale.minor,
	\octave, 5,
	\dur, 0.25,
	\decay, 2,
	\amp, 0.2
);

~bass = Pbind(
	\instrument, \sine,
	\midinote, Pseq([20, 60], 4),
	\dur, 0.2,
	\lop, 100,
	\rel, 0.1,
	\amp, 0.25
);

~development = Pbind(
	\instrument, \sine,
	\midinote, Pbrown(60, 84, 3, 32),
	\dur, 0.2,
	\amp, 0.12
);

Pspawner({ |spawner|

	spawner.seq(~intro);
	spawner.seq(~theme);
	spawner.wait(1);
	spawner.par(~bass);
	spawner.seq(~theme);
	spawner.wait(2);
	spawner.par(~development);

}).play;

)


////////////////////////////////////////////////////////////////
//
//              6. TENDENCY MASKS - Controlled Randomness
//
////////////////////////////////////////////////////////////////

/*

Tendency masks: random values between changing boundaries.

Pseg creates line segments between values over time.

*/

// Basic tendency mask

(

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(
		Pseg(Pseq([48, 72, 36, 60], inf), Pseq([4, 4, 4], inf)), // lower bound
		Pseg(Pseq([60, 84, 48, 72], inf), Pseq([4, 4, 4], inf))  // upper bound
	),
	\dur, 0.08,
	\amp, 0.15
).play

)


// Multiple parameters with tendency masks

(

Pbind(
	\instrument, \pink,
	\midinote, Pwhite(
		Pseg(Pseq([36, 60, 48], inf), 8),
		Pseg(Pseq([48, 84, 60], inf), 8)
	),
	\bw, Pwhite(
		Pseg(Pseq([0.04, 0.1, 0.01], inf), 6),
		Pseg(Pseq([0.1, 0.3, 0.8], inf), 6)
	),
	\dur, 0.1,
	\rel, Pwhite(0.1, 0.5),
	\amp, 0.6
).play

)


// Using Env for tendency boundaries (more shapes)

(

var lower = Env([40, 70, 45, 60], [3, 2, 3], \sine);
var upper = Env([60, 85, 70, 80], [3, 2, 3], \sine);

lower.plot;
upper.plot;

Pbind(
	\instrument, \pluck,
	\midinote, Pwhite(
		Pn(Penv(lower.levels, lower.times)),
		Pn(Penv(upper.levels, upper.times))
	),
	\decay, 2,
	\dur, 0.1,
	\amp, 0.15
).play
)


////////////////////////////////////////////////////////////////
//
//         7. PCLUTCH & PATTERN TRANSFORMATIONS
//
////////////////////////////////////////////////////////////////

/*

Pclutch: Sample and hold - freeze values based on a trigger

*/

// Basic sample & hold

(

Pbind(
	\instrument, \sine,
	// Second pattern: 1=sample new value, 0=hold current value
	\freq, Pclutch(
		Pwhite(200, 2000),
		Pseq([1, 0, 0, 0, 1, 0, 0, 0], inf)
	),
	\dur, 0.1,
	\amp, 0.15
).trace.play

)


// Sample & hold with random trigger

(

Pbind(
	\instrument, \pluck,
	\midinote, Pclutch(
		Pwhite(48, 72),
		Pwhite(0.0, 1.0) > 0.7  // 30% chance to update
	),
	\lop, 1500,
	\dur, 0.15,
	\amp, 0.15
).play

)


// Pstep: hold value for a duration (time-based clutch)

(

Pbind(
	\instrument, \sine,
	\freq, Pstep(Pwhite(200, 800), 0.5, inf), // hold each for 0.5 seconds
	\dur, 0.05,
	\amp, 0.15
).play

)


// Pseg: smooth interpolation between values

(

Pbind(
	\instrument, \sine,
	\freq, Pseg(Pwhite(200, 800), 1.0, \exp, inf), // 1 second glides
	\dur, 0.05,
	\amp, 0.15
).play

)


////////////////////////////////////////////////////////////////
//
//            8. PATTERN COMBINATIONS
//
////////////////////////////////////////////////////////////////

// Ptuple: create chords from multiple patterns

(

Pbind(
	\instrument, \sine,
	\midinote, Ptuple([
		Pwhite(20, 30, inf),
		Pwhite(40, 50, inf),
		Pwhite(60, 70, inf)
	]).trace,
	\dur, 0.2,
	\amp, [0.1,0.2,0.1]
).play

)


// Pfunc: inspect and transform events in real-time

(

Pbind(
	\instrument, \sine,
	\degree, Pwhite(0, 7, inf),
	\octave, 5,

	\amp, Pfunc({ |event|
		var degree = event[\degree];
		if(degree < 3, { 0.3 }, { 0.1 }) // louder for lower scale degrees
	}),
	\dur, 0.2
).play

)


// Pif: conditional pattern execution

(

Pbind(
	\instrument, \sine,
	\midinote, Pif(
		Pwhite(0.0, 1.0) > 0.3,   // condition
		Pwhite(60, 66),           // if true: high notes
		Pwhite(80, 84)            // if false: low notes
	).trace,
	\dur, 0.15,
	\amp, 0.2
).play

)


// PatternProxy: change patterns on the fly

(

~proxy = PatternProxy(Pwhite(60, 72));

Pbind(
	\instrument, \sine,
	\midinote, ~proxy,
	\dur, 0.15,
	\amp, 0.2
).play;

)

// Change the pattern while it's playing:
~proxy.source = Pseq([60, 64, 67, 72], inf);
~proxy.source = Pbrown(48, 84, 3, inf);
~proxy.source = Pgauss(60, 8, inf);


////////////////////////////////////////////////////////////////
//
//                  EXERCISES & EXPERIMENTS
//
////////////////////////////////////////////////////////////////

/*
1. Create a piece using Pmono with a Markov chain controlling
   both pitch and filter cutoff.

2. Build a texture using tendency masks where the boundaries
   themselves follow brownian motion.

3. Use Pspawner to create a 3-part form (ABA) where:
   - A: sparse, using Poisson distribution
   - B: dense, using Gaussian distribution
   - A: returns with variation

4. Create a pattern that uses Pfsm to switch between different
   probability distributions based on musical state.

5. Experiment with Gendy parameters controlled by patterns.

6. Build a multi-voice piece where each voice uses a different
   exotic probability distribution.

7. Create a pattern using Pclutch that "freezes" in rhythmic
   patterns, creating polyrhythmic effects.

8. Combine Pbrown with Ptuple to create harmonies that walk
   in parallel motion.
*/


////////////////////////////////////////////////////////////////
//
//                     REFERENCE
//
////////////////////////////////////////////////////////////////

/*

CONTINUOUS SYNTHS:
Pmono(\synth, ...)     - One synth, changing parameters

MARKOV CHAINS:
Pfsm(...)              - Simple finite state machine
MarkovSetN(...)        - Sophisticated Markov chains

RANDOM WALKS:
Pbrown(lo, hi, step)   - Additive brownian motion
Pgbrown(lo, hi, step)  - Multiplicative brownian motion

DISTRIBUTIONS:
Pwhite(lo, hi)         - Uniform
Pexprand(lo, hi)       - Exponential
Phprand(lo, hi)        - Favors high
Plprand(lo, hi)        - Favors low
Pmeanrand(lo, hi)      - Favors middle
Pgauss(mean, dev)      - Gaussian (bell curve)
Pcauchy(mean, spread)  - Cauchy (outliers)
Pbeta(lo, hi, a, b)    - Beta (extremes when a,b < 1)
Ppoisson(mean)         - Poisson (discrete)

PATTERN CONTROL:
Pspawner({ })          - Complex sequencing
Pclutch(pat, trigger)  - Sample and hold
Pstep(pat, dur)        - Hold for duration
Pseg(pat, dur, curve)  - Interpolate over duration

TENDENCY MASKS:
Pwhite(Pseg(...), Pseg(...)) - Random between moving boundaries

PATTERN COMBINATIONS:
Ptuple([p1, p2, ...])  - Combine as chords
Pswitch(list, index)   - Choose pattern by index
PatternProxy(...)      - Change pattern live
Pfunc({ |ev| ... })    - Function with event access
Pif(cond, true, false) - Conditional patterns

*/

