////////////////////////////////////////////////////////////////
//
//                     		Xenakis
//
////////////////////////////////////////////////////////////////

Probability functions, random walks, set theory and markov chains.


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

// SynthDefs used

(

SynthDef(\sine,
    { arg out=0, freq=440, sus=0.05;
        var env = EnvGen.kr(Env.perc(0.01, sus, 0.6), doneAction:2);
        Out.ar(out, SinOsc.ar(freq, 0, env) ! 2)
    }).add;

SynthDef(\gliss,
	{ arg midinote = 60, dur=0.8, sus=0.05;
		var note = midinote.midicps;
		var line = Line.kr(note, note * 2, dur, doneAction:2);
		var sound = LFSaw.ar(line, 0, 0.1);
		Out.ar(0, sound ! 2);
	}).add;

)


////////////////////////// Probablities ///////////////////////////


( // Poisson used to model the number of events occurring within a given time interval

    Pbind(
	    \dur, 0.1,
	    \amp, 1,
	    \instrument, \sine,
	    \midinote, Ppoisson(90, inf).trace
    ).play;
)


( // Pgauss uses a gaussian distribution from uniformly distributed values

    Pbind(
	    \dur, 0.1,
	    \amp, 1,
		\instrument, \sine,
	    \midinote, Pgauss(60, 12, inf).trace
    ).play;
)


( // Pcauchy a continuous distribution describing resonance behavior

    Pbind(
	    \dur, 0.1,
	    \amp, 1,
	    \instrument, \sine,
	    \midinote, Pcauchy(60, 12).max(10).min(100).trace
    ).play
)


( // Pexprand, exponential distribution, lower events occur more often

    Pbind(
	    \dur, 0.1,
	    \amp, 1,
	    \instrument, \sine,
	    \midinote, Pexprand(40, 80).trace
    ).play
)


( // Phprand, random values that tend toward hi

    Pbind(
	    \dur, 0.1,
	    \amp, 1,
	    \instrument, \sine,
	    \midinote, Phprand(40, 80).trace
    ).play
)



////////////////////////// Combinations ///////////////////////////

( // Sequences

    Pbind(
	    \dur, Pseq([Plprand(0.1,0.2, Pwhite(2,4)), Pgauss(0.5, 0.25, 4)], inf),
	    \amp, Pexprand(0.3, 1.0),
	    \instrument, Pstutter(10, Pseq([\sine, \gliss], inf)),
	    \midinote,Pseq([Phprand(50, 60, 16), Pwhite(70, 80, 8)], inf)
    ).play
)

( // Layers

a = Pbind(
	    \dur, 0.2,
	    \amp, 1,
	    \instrument, \sine,
	    \midinote, Phprand(40, 80, 12),
    );

b = Pbind(
	    \dur, 0.2,
	    \amp, 1,
	    \instrument, \sine,
	    \midinote, Pexprand(40, 80, 8),
    );


Pseq([a,b], 16).play

)


////////////////////////// Ploters ///////////////////////////////

(

a = Pwhite(0.0, 1.0).asStream;
b = a.nextN(100000);
b.plot(bounds: Rect(10, 10, 520, 380), discrete: true);
b.histo(1000).plot(bounds: Rect(10, 410, 520, 380), discrete: true);

)

(

~plotPattern = {|pattern, count=512|
	var values = pattern.asStream.nextN(count);
    values.plot(minval: values.minItem.floor,
		maxval: values.maxItem.ceil, discrete: true)
};

~histogram = {|pattern, count=128|
	var values = pattern.asStream.nextN(count);
	values.histo(count).plot(bounds: Rect(10, 410, 520, 380),  discrete: false);
};

)

~plotPattern.value(Pexprand())

~histogram.value(Pbrown())


////////////////////////// Random Walks ///////////////////////////

( // Use Pbrown for random walks

Pbind(
	\dur, Pbrown(0.1, 0.2, 0.05, inf),
	\amp, 1,
	\instrument, \sine,
	\midinote, 60
).play;

)

~plotPattern.value(Pbrown())



/* A simulation of Brownian motion with a fixed start value. */

(

Pbind(
	\instrument, \sine,
	\midinote, Pseries(60, Pwhite(-2, 2, inf), inf).fold(50, 70).trace,
	\dur, Pbrown(0.1, 0.2,÷ 0.01, inf)
).play(TempoClock(150/60))

)


////////////////////////// Markov Chains ///////////////////////////

Quarks.install("MathLib")

( // Probabilities are set for future states

m = MarkovSetN(
			  [ [[ 60 ], 	[ 61, 100 ], 	[ 0.9, 0.1 ]],
				[[ 61 ], 	[ 60 ], 		[ 1 ]],
				[[ 100 ], 	[ 101, 60 ], 	[ 0.9, 0.1 ]],
				[[ 101 ], 	[ 100 ], 		[ 1 ]]
			], 1);

m.makeSeeds;

p = Pbind(
	\instrument, \sine,
	\midinote, m,
	\dur, 1/8);

p.trace.play;

)


/* A state machine, Pfsm, possible initial states, then state and possible next states. */

(

var geom = Pgeom(50,1.1,4);

Pbind(
	\instrument, \sine,
	\midinote, Pfsm([ [0], 67, [0, 1], geom, [2,3], 73, [0, 2], 83, [0] ], inf),
	\dur, 0.1).trace.play
)


////////////////////////// Set Theory ///////////////////////////

(

// 2 sets of pitches
a = Set[61, 62, 63, 67];
b = Set[62, 63, 64, 65];

// union is the set of all elements in the collection
c = union(a, b);

// intersection is the set that contains all elements of a that also belong to b
d = sect(a, b);

// is the set of all members of the whole set that are not members of a.
e = difference(a, b);

// The sets played where each subset is repeated twice
Pbind(
	\instrument, \sine,
	\dur, 0.1,
	\amp, 1,
	\midinote, Pseq([ Pseq(c.asList, 2), Pseq(d.asList, 2), Pseq(e.asList, 2)], inf).trace
).play;

)


////////////////////////// Gendy ///////////////////////////

{ Gendy3.ar * 0.1 }.play

(

{ Pan2.ar(Mix.new(Gendy3.ar(freq:([1,3,7,9]*MouseX.kr(3,17,'exponential')),mul:0.2))) }.play

)

(

{ Pan2.ar(Gendy2.ar(0, 0, SinOsc.kr(0.1, 0, 0.1, 0.9),1.0, 50,1000,1,0.005,12,12, 0.2,0.2,0.2), 0.0) }.play

)


//////////////////////// Ptime / Pif  ///////////////////////////

// Use Ptime with Pif to time limit a section

(

// a plays for 2 seconds

a =  Pbind(
	\instrument, \sine,
	\freq, Pif(Ptime(inf) < 2.0, Pwhite(100, 400, inf)),
	\dur, 0.1);

// b plays for 1 seconds

b =  Pbind(
	\instrument, \gliss,
	\freq, Pif(Ptime(inf) < 1.0, Pwhite(300, 700, inf)),
	\dur, 0.15);


// play a and b in a looped sequence

Pseq( [a,b], inf).play;

)


//////////////////////// Pspawner  ///////////////////////////

// Pspawner is very useful to sequence other patterns both in paralell, in sequence and waiting between.

(

~firstPattern = Pbind(
    \instrument, \sine,
	\midinote, Pwhite(40, 50, 4),
	\dur, 0.2
);

~secondPattern = Pbind(
    \instrument, \sine,
	\midinote, Pwhite(70, 80, 4),
	\dur, 0.1
);


Pspawner({|spawner|

	spawner.seq(~firstPattern);

	spawner.wait(4);

	spawner.seq(~secondPattern);
	spawner.seq(~firstPattern);

	spawner.wait(4);

	spawner.par(~secondPattern);
	spawner.par(~firstPattern)

}).play;

)



///////////////////// Probablities //////////////////////

// Produces length random numbers with equal distribution ('white' refers to white noise).
Pwhite(lo, hi, length)

// Same, but the random numbers have an exponential distribution, favoring lower numbers.
Pexprand(lo, hi, length)

// Brownian motion. Each value adds a random step to the previous value, where the step has an equal distribution
Pbrown(lo, hi, step, length)

// Brownian motion on a geometric scale. Each value multiplies a random step factor to the previous value.
Pgbrown(lo, hi, step, length)

// Beta distribution, where prob1 = α (alpha) and prob2 = β (beta).
Pbeta(lo, hi, prob1, prob2, length)

// Cauchy distribution.
Pcauchy(mean, spread, length)

// Guassian (normal) distribution.
Pgauss(mean, dev, length)

// Returns the greater of two equal-distribution random numbers.
Phprand(lo, hi, length)

// Returns the lesser of two equal-distribution random numbers.
Plprand(lo, hi, length)

// Returns the average of two equal-distribution random numbers, i.e., (x + y) / 2.
Pmeanrand(lo, hi, length)

// Poisson distribution.
Ppoisson(mean, length)

// To see a distribution, make a histogram out of it.
Pmeanrand(0.0, 1.0, inf).asStream.nextN(10000).histo(200, 0.0, 1.0).plot;
