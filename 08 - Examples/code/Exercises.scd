////////////////////////////////////////////////////////////////
//
//                       EXERCISES
//
////////////////////////////////////////////////////////////////

/*

These exercises help you master the advanced techniques.
Try to complete them without looking at the solutions!

For each exercise:
1. Read the description
2. Think about which techniques to use
3. Implement your solution
4. Compare with the example solution at the bottom

*/


// First, evaluate the SynthDefs

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
	env = EnvGen.kr(Env.asr(0.01, 1, 0.1), gate);
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

)


////////////////////////////////////////////////////////////////
//                      EXERCISES
////////////////////////////////////////////////////////////////

/*
EXERCISE 1: Pmono Legato Line
Create a smooth melodic line using Pmono that:
- Uses scale degrees (0-7)
- Has legato articulation
- Filter cutoff follows the pitch
- Durations vary but notes connect smoothly
*/

// Your solution here:




/*
EXERCISE 2: Simple Markov Chain
Create a Markov chain using Pfsm that:
- Has 3 distinct pitch states (low, mid, high ranges)
- Low state usually stays low, occasionally jumps to mid
- Mid state can go to any state
- High state usually returns to mid
*/

// Your solution here:




/*
EXERCISE 3: Brownian Texture
Create a texture using Pbrown where:
- Pitch uses brownian motion between MIDI 48-72
- Duration also uses brownian motion (0.05-0.3 seconds)
- Amplitude uses brownian motion (0.05-0.25)
- All three create a cohesive wandering texture
*/

// Your solution here:




/*
EXERCISE 4: Gaussian Cloud
Create a dense cloud of notes using Pgauss where:
- Pitches cluster around MIDI note 60
- Standard deviation of 6 semitones
- Fast durations (0.05-0.1 seconds)
- Exponential distribution for amplitudes (favoring quiet)
*/

// Your solution here:




/*
EXERCISE 5: Extreme Dynamics
Create a pattern using Pbeta distribution where:
- Pitches are random but controlled
- Dynamics favor extremes (very quiet or very loud)
- Use beta distribution with low alpha and beta values
- Creates dramatic contrast
*/

// Your solution here:




/*
EXERCISE 6: Tendency Mask
Create a tendency mask where:
- Lower boundary moves: 48 -> 72 -> 48 (8 seconds each)
- Upper boundary moves: 60 -> 84 -> 60 (8 seconds each)
- Random notes selected between the boundaries
- Fast articulation (0.08 second durations)
*/

// Your solution here:




/*
EXERCISE 7: Sample & Hold Rhythm
Create a pattern using Pclutch where:
- Frequency changes randomly
- Values only update every 5th note
- Creates a rhythmic "frozen" effect
- Fast durations to hear the holds clearly
*/

// Your solution here:




/*
EXERCISE 8: Three-Part Form with Pspawner
Create a piece with ABA form using Pspawner:
- Section A: slow, low notes (4 seconds)
- Section B: fast, high notes (4 seconds)
- Section A: returns (4 seconds)
- Use spawner.seq() and spawner.wait()
*/

// Your solution here:




/*
EXERCISE 9: Multi-Parameter Correlation
Create a pattern where:
- Pitch uses brownian motion
- Filter cutoff is derived from pitch (use Pkey)
- Duration is inversely related to pitch (high=fast, low=slow)
- Demonstrates parameter coupling
*/

// Your solution here:




/*
EXERCISE 10: State-Controlled Distribution
Create a pattern using Pfsm where:
- Each state uses a DIFFERENT probability distribution
- State 0: uniform random (Pwhite)
- State 1: gaussian (Pgauss)
- State 2: exponential (Pexprand)
- Use Pswitch to select the distribution
*/

// Your solution here:




////////////////////////////////////////////////////////////////
//                  More EXERCISES
////////////////////////////////////////////////////////////////

/*
EXERCISE 11: Evolving Drone
Create a slowly evolving drone using:
- Pmono for smooth transitions
- Pseg for gradual frequency changes
- Multiple layers using Pspawner
- Filter that evolves independently
- Should last at least 30 seconds
*/

// Your solution here:




/*
EXERCISE 12: Markov Phrase Structure
Create a complete piece using MarkovSetN where:
- 4 distinct pitch sets represent different phrases
- Probability matrix creates logical flow
- Each phrase is 4-8 notes
- Runs for a defined duration
- Demonstrates musical form
*/

// Your solution here:




/*
EXERCISE 13: Multi-Dimensional Brownian
Create a complex texture where:
- Multiple voices use brownian motion
- Each voice has different step sizes
- Voices occasionally sync using Pclutch
- Use Pspawner to layer them
- Creates a rich, organic texture
*/

// Your solution here:




/*
EXERCISE 14: Distribution Showcase
Create a piece that clearly demonstrates 4 different distributions:
- Use Pspawner to sequence sections
- Each section uses a different distribution
- Same basic musical material, different statistics
- Label sections with .postln
*/

// Your solution here:




/*
EXERCISE 15: Interactive Tendency System
Create a pattern where:
- Tendency mask boundaries controlled by variables
- Multiple parameters use the same boundaries
- Create ~changeTendency function to modify on the fly
- Use PatternProxy for live updates
- Demonstrates live coding techniques
*/

// Your solution here:




////////////////////////////////////////////////////////////////
//              EXAMPLE SOLUTIONS
////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////
// SOLUTION 1: Pmono Legato Line

(

Pmono(
	\monosaw,
	\degree, Pbrown(0, 7, 2, inf),
	\scale, Scale.minor,
	\octave, 5,
	\lop, Pkey(\degree).linexp(0, 7, 500, 3000),
	\dur, Pwhite(0.05, 0.3, inf),
	\amp, 0.15
).play

)


////////////////////////////////////////////////////////////////
// SOLUTION 2: Simple Markov Melody

(

Pbind(
	\instrument, \sine,
	\midinote, Pfsm([
		[0],               // start in low
		Pwhite(48, 55),   // low range
		[0, 0, 0, 1],     // 75% stay low, 25% to mid
		Pwhite(60, 67),   // mid range
		[0, 1, 2],        // equal chance to all states
		Pwhite(72, 79),   // high range
		[1, 1, 2]         // 66% to mid, 33% stay high
	], inf),
	\dur, 0.15,
	\amp, 0.2
).trace.play

)


////////////////////////////////////////////////////////////////
// SOLUTION 3: Brownian Texture

(

Pbind(
	\instrument, \saw,
	\midinote, Pbrown(10, 100, 10, inf),
	\dur, Pbrown(0.05, 0.3, 0.03, inf),
	\amp, Pbrown(0.05, 0.25, 0.03, inf),
	\lop, 2000,
	\rel, 0.3
).play

)


////////////////////////////////////////////////////////////////
// SOLUTION 4: Gaussian Cloud

(

Pbind(
	\instrument, \sine,
	\midinote, Pgauss(60, 6, inf),
	\dur, Pwhite(0.05, 0.1, inf),
	\amp, Pexprand(0.05, 0.2, inf),
	\rel, 1
).play

)


////////////////////////////////////////////////////////////////
// SOLUTION 5: Extreme Dynamics

(
Pbind(
	\instrument, \saw,
	\midinote, Pwhite(48, 72, inf),
	\amp, Pbeta(0.05, 0.3, 0.5, 0.5, inf), // extreme values
	\lop, Prand([100,200,2000,3000],inf),
	\dur, 0.1,
	\rel, 0.3
).play
)


////////////////////////////////////////////////////////////////
// SOLUTION 6: Tendency Mask

(
Pbind(
	\instrument, \sine,
	\midinote, Pwhite(
		Pseg(Pseq([48, 72, 48], inf), 8),
		Pseg(Pseq([60, 84, 60], inf), 8)
	),
	\dur, 0.08,
	\amp, 0.15
).play
)


////////////////////////////////////////////////////////////////
// SOLUTION 7: Sample & Hold Rhythm

(
Pbind(
	\instrument, \sine,
	\freq, Pclutch(
		Pwhite(200, 800, inf),
		Pseq([1, 0, 0, 0, 0], inf)  // update every 5th
	),
	\dur, 0.1,
	\amp, 0.2
).trace.play
)


////////////////////////////////////////////////////////////////
// SOLUTION 8: Three-Part Form with Pspawner

(
~sectionA = Pbind(
	\instrument, \pluck,
	\midinote, Pwhite(36, 48, 16),
	\dur, 0.25,
	\decay, 2,
	\amp, 0.2
);

~sectionB = Pbind(
	\instrument, \sine,
	\midinote, Pwhite(72, 84, 32),
	\dur, 0.125,
	\rel, 0.1,
	\amp, 0.15
);

Pspawner({ |sp|
	"Section A".postln;
	sp.seq(~sectionA);
	sp.wait(1);

	"Section B".postln;
	sp.seq(~sectionB);
	sp.wait(1);

	"Section A (return)".postln;
	sp.seq(~sectionA);
}).play;
)


////////////////////////////////////////////////////////////////
// SOLUTION 9: Multi-Parameter Correlation

(
Pbind(
	\instrument, \saw,
	\midinote, Pbrown(36, 72, 4, inf),
	\lop, Pkey(\midinote).linexp(36, 72, 100, 1000),
	\dur, Pkey(\midinote).linlin(36, 72, 0.2, 0.05),
	\amp, 0.15,
	\rel, 0.3
).play
)


////////////////////////////////////////////////////////////////
// SOLUTION 10: State-Controlled Distribution

(

var distributions = [
	Pwhite(48, 72, inf),      // uniform
	Pgauss(60, 8, inf),       // gaussian
	Pexprand(48, 72, inf)     // exponential
];

Pbind(
	\instrument, \sine,
	\midinote, Pswitch(
		distributions,
		Pstutter(8, Pseq([0, 1, 2], inf))  // 8 notes per distribution
	),
	\dur, 0.15,
	\amp, 0.2
).trace.play

)


////////////////////////////////////////////////////////////////
// SOLUTION 11: Evolving Drone

(

~drone1 = Pmono(
	\monosaw,
	\freq, Pseg(Pwhite(80, 200), 3, \exp, inf),
	\lop, Pseg(Pwhite(400, 2000), 2, \sine, inf),
	\dur, 0.1,
	\amp, 0.12
);

~drone2 = Pmono(
	\monosaw,
	\freq, Pseg(Pwhite(150, 350), 4, \exp, inf),
	\lop, Pseg(Pwhite(600, 3000), 3, \sine, inf),
	\dur, 0.1,
	\amp, 0.08
);

Pspawner({ |sp|
	sp.par(~drone1);
	sp.wait(5);
	sp.par(~drone2);
	sp.wait(30);
}).play;

)


////////////////////////////////////////////////////////////////
// SOLUTION 12: Markov Phrase Structure

(

Quarks.install("MathLib"); // if not already installed

m = MarkovSetN([
	// Phrase transitions
	[[0], [1, 2], [0.7, 0.3]],
	[[1], [0, 1, 2], [0.4, 0.3, 0.3]],
	[[2], [3], [1.0]],
	[[3], [0], [1.0]]
], 1).makeSeeds;

~phrases = [
	Pseq([60, 62, 64, 65], 1),       // A
	Pseq([67, 65, 64, 62, 60], 1),   // B
	Pseq([72, 70, 69, 67], 1),       // C
	Pseq([60, 55, 60], 1)            // D (cadence)
];

Pbind(
	\instrument, \pluck,
	\midinote, Pswitch(~phrases, m),
	\dur, 0.2,
	\decay, 1.5,
	\amp, 0.2
).play;

)


////////////////////////////////////////////////////////////////
// SOLUTION 13: Multi-Dimensional Brownian

(

~voice1 = Pbind(
	\instrument, \sine,
	\midinote, Pbrown(48, 60, 2, inf),
	\dur, Pbrown(0.2, 0.4, 0.05, inf),
	\amp, 0.15
);

~voice2 = Pbind(
	\instrument, \sine,
	\midinote, Pbrown(60, 72, 4, inf),
	\dur, Pbrown(0.1, 0.25, 0.03, inf),
	\amp, 0.12
);

~voice3 = Pbind(
	\instrument, \sine,
	\midinote, Pbrown(72, 84, 6, inf),
	\dur, Pbrown(0.05, 0.15, 0.02, inf),
	\amp, 0.1
);

Pspawner({ |sp|
	sp.par(~voice1);
	sp.wait(3);
	sp.par(~voice2);
	sp.wait(3);
	sp.par(~voice3);
}).play;

)


////////////////////////////////////////////////////////////////
// SOLUTION 14: Distribution Showcase

(

Pspawner({ |sp|

	"Section 1: Uniform Distribution (Pwhite)".postln;
	sp.seq(Pbind(
		\instrument, \sine,
		\midinote, Pwhite(48, 72, 32),
		\dur, 0.1,
		\amp, 0.2
	));
	sp.wait(1);

	"Section 2: Gaussian Distribution (Pgauss)".postln;
	sp.seq(Pbind(
		\instrument, \sine,
		\midinote, Pgauss(60, 6, 32),
		\dur, 0.1,
		\amp, 0.2
	));
	sp.wait(1);

	"Section 3: Exponential Distribution (Pexprand)".postln;
	sp.seq(Pbind(
		\instrument, \sine,
		\midinote, Pexprand(48, 72, 32),
		\dur, 0.1,
		\amp, 0.2
	));
	sp.wait(1);

	"Section 4: Cauchy Distribution (Pcauchy)".postln;
	sp.seq(Pbind(
		\instrument, \sine,
		\midinote, Pcauchy(60, 5, 32).clip(48, 72),
		\dur, 0.1,
		\amp, 0.2
	));

}).play;

)


////////////////////////////////////////////////////////////////
// SOLUTION 15: Interactive Tendency System

(

~lowerBound = PatternProxy(Pseg(Pseq([40, 70], inf), 8));
~upperBound = PatternProxy(Pseg(Pseq([60, 85], inf), 8));

~changeTendency = { |lo, hi, time|
	~lowerBound.source = Pseg(Pseq(lo, inf), time);
	~upperBound.source = Pseg(Pseq(hi, inf), time);
	"Tendency boundaries updated".postln;
};

Pbind(
	\instrument, \saw,
	\midinote, Pwhite(~lowerBound, ~upperBound),
	\lop, Pwhite(
		~lowerBound * 10,
		~upperBound * 30
	),
	\dur, 0.08,
	\amp, 0.12
).play;

)

// Try changing while it plays:
~changeTendency.value([30, 80], [50, 90], 4);
~changeTendency.value([50, 60], [70, 80], 2);
