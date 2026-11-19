////////////////////////////////////////////////////////////////
//
//                     		Xenakis
//
////////////////////////////////////////////////////////////////

The class in slide order: the Achorripsis matrix, Markov chains, the ST
algorithm, outside-time sets, the three sonorities, random walks, GENDYN and
the distributions. After that, the code from last year: plotters, Pfsm,
MarkovSetN, Ptime with Pif and Pspawner, and a list of every distribution.
Evaluate the SynthDefs first, then any block on its own.

StageLimiter.activate


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\sine, { |out=0, freq=440, amp=0.2, sus=0.05, pan=0|
	var env = EnvGen.kr(Env.perc(0.01, sus), doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq) * env, pan, amp));
}).add;

// a sawtooth that slides by slide semitones over its duration
SynthDef(\gliss, { |out=0, freq=440, amp=0.1, sus=0.8, slide=12, pan=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.linen(0.01, sus, 0.05), doneAction: 2);
	Out.ar(out, Pan2.ar(LFSaw.ar(line) * env, pan, amp));
}).add;

)


////////////////////////// Achorripsis ///////////////////////////

// eight density levels from a Poisson distribution with a mean of 0.6
Ppoisson(0.6).asStream.nextN(8)    // for example [0, 1, 0, 2, 0, 0, 1, 0]

( // that row played: a rest for 0, four events a second for each level above it
Pbind(\instrument, \sine,
	\midinote, Pwhite(60, 72),
	\dur, Pseq([Rest(1), Pn(1/4, 4), Rest(1), Pn(1/8, 8),
		Rest(1), Rest(1), Pn(1/4, 4), Rest(1)])
).play
)

// the whole matrix, with the levels drawn and played by the program
( // seven entities, eight sections, a Poisson density in every cell
var levels = Ppoisson(0.6).asStream;
var matrix = { { levels.next.min(4) } ! 8 } ! 7;
matrix.do(_.postln);   // one row per entity, one column per section
Pspawner({ |sp|
	8.do { |section|
		7.do { |entity|
			var n = matrix[entity][section] * 4;   // events in this cell
			if(n > 0) {
				sp.par(Pbind(\instrument, \sine,
					\midinote, Pwhite(36, 48) + (entity * 7),
					\dur, Pn(3 / n, n), \sus, 0.1, \amp, 0.1))
			}
		};
		sp.wait(3);   // each section lasts three seconds
	}
}).play
)


////////////////////////// Markov chains ///////////////////////////

( // the next note depends only on the current one
~chain = Dictionary[
	60 -> [[60, 64, 67], [0.2, 0.5, 0.3]],
	64 -> [[60, 67], [0.6, 0.4]],
	67 -> [[60, 64, 72], [0.3, 0.3, 0.4]],
	72 -> [[67], [1]]
];
~note = 60;
Pbind(\instrument, \sine,
	\midinote, Pfunc { ~note = ~chain[~note][0].wchoose(~chain[~note][1]) },
	\dur, 0.15).play
)


////////////////////////// The ST algorithm ///////////////////////////

( // much reduced: sequences, a density for each, then the events
Pspawner({ |sp|
	4.do {
		var length = exprand(2.0, 6.0);       // 1. a sequence, a seconds long
		var density = exprand(0.5, 20.0);     // 2. its mean density, onsets a second
		var low = rrand(36, 72);              // 3. its orchestra, as a register
		[length, density].round(0.1).postln;
		sp.seq(Pfindur(length, Pbind(
			\instrument, Pwrand([\sine, \gliss], [0.7, 0.3], inf), // 5. an instrument
			\dur, Pfunc { (1 - 1.0.rand).log.neg / density },      // 4. the onsets
			\midinote, Pwhite(low, low + 24),                      // 6. a pitch
			\slide, Pgauss(0, 7),                                  // 7. a glissando
			\sus, Pexprand(0.05, 1),                               // 8. a duration
			\amp, Pwhite(0.03, 0.12)                               // 9. a dynamic
		)));
	}
}).play
)


////////////////////////// Outside-time ///////////////////////////

(
a = Set[60, 62, 63, 67, 70];
b = Set[62, 65, 67, 69, 70];
(a | b).postln;   // union
(a & b).postln;   // intersection
(a - b).postln;   // difference
)

(
Pbind(\instrument, \sine,
	\midinote, Pseq([Pshuf((a | b).asArray), Pshuf((a & b).asArray, 2)], inf),
	\dur, 0.15).play
)


////////////////////////// Composing sound ///////////////////////////

( // masses of short sounds
Pbind(\instrument, \sine, \midinote, Pwhite(40, 100),
	\dur, Pexprand(0.005, 0.05), \amp, 0.05).play
)

( // glissandi, with speeds from a Gaussian, as in Pithoprakta
Pbind(\instrument, \gliss, \midinote, Pwhite(50, 80),
	\slide, Pgauss(0, 12), \sus, 2, \dur, 0.1, \amp, 0.02).play
)

( // sustained sounds
Pbind(\instrument, \gliss, \midinote, Pwhite(40, 80),
	\slide, 0, \sus, 6, \dur, 0.5, \amp, 0.02).play
)


////////////////////////// Random walks ///////////////////////////

( // steps of at most two semitones, kept between 50 and 70
Pbind(\instrument, \sine,
	\midinote, Pbrown(50, 70, 2),
	\dur, 0.1).play
)

( // the same walk written out, and a second walk on the durations
Pbind(\instrument, \sine,
	\midinote, Pseries(60, Pwhite(-2, 2), inf).fold(50, 70),
	\dur, Pbrown(0.05, 0.2, 0.02)).play
)


////////////////////////// GENDYN ///////////////////////////

// Gendy3 also holds a pitch, but its output can spike far above 1, so Gendy1 is used

// the defaults: the walk moves both the pitch and the timbre
{ Gendy1.ar * 0.1 ! 2 }.play

( // the pitch held by the mouse
{
	var f = MouseX.kr(50, 400, \exponential);
	Gendy1.ar(minfreq: f, maxfreq: f) * 0.1 ! 2
}.play
)

( // four layers in the ratios 1, 3, 7 and 9
{
	var f = [1, 3, 7, 9] * MouseX.kr(30, 170, \exponential);
	Splay.ar(Gendy1.ar(minfreq: f, maxfreq: f)) * 0.1
}.play
)


////////////////////////// Probabilities in composition ///////////////////////////

( // an explosive transformation: the deviation goes from 0.5 to 24 and back
Pbind(\instrument, \sine,
	\midinote, Pgauss(72, Pseg([0.5, 0.5, 24, 0.5], [6, 0.5, 4])),
	\dur, 0.05, \amp, 0.1).play
)

( // improbable events against average ones, one in twenty
Pbind(\instrument, \sine,
	\midinote, Pwrand([Pgauss(60, 2, 1), Pwhite(90, 100, 1)], [0.95, 0.05], inf),
	\dur, 0.1).play
)


////////////////////////// The distributions ///////////////////////////

// the same Pbind, one distribution at a time on pitch: run the lines one by one
~play = { |pattern| Pbind(\instrument, \sine, \midinote, pattern, \dur, 0.1).play };

~play.(Pwhite(40, 80));

~play.(Pexprand(40, 80));

~play.(Pgauss(60, 6));

~play.(Pcauchy(60, 2).clip(30, 90));

~play.(Ppoisson(60));


////////////////////////// Beta ///////////////////////////

p = Pbeta(0, 1, 0.3, 0.3, inf).asStream;   // lo, hi, a, b

({ p.next } ! 4000).histo(40).plot("both edges");

// the same generator, three shapes
Pbind(\freq, Pbeta(200, 2000, 0.3, 0.3), \dur, 0.08).play;   // the extremes

Pbind(\freq, Pbeta(200, 2000, 3, 3),     \dur, 0.08).play;   // a bell

Pbind(\freq, Pbeta(200, 2000, 0.4, 3),   \dur, 0.08).play;   // the low end


////////////////////////// Look before you map ///////////////////////////

( // what was actually drawn, before any of it becomes a frequency
a = { 1.0.exprand(0.001) } ! 4000;
a.histo(40).plot("exprand, as drawn");
)

( // the same draws, counted per octave instead of per hertz
b = (a * 1000 + 200).log2;
(b - b.minItem).histo(40).plot("the same draws, per octave");
)


////////////////////////// Randomness ///////////////////////////

10.rand

rrand(60, 72)

0.25.coin

[60, 64, 67].choose

[60, 64, 67].wchoose([0.6, 0.3, 0.1])


////////////////////////// Seeds ///////////////////////////

(
thisThread.randSeed = 7;
{ 100.rand } ! 8
)

Pseed(7, Pbind(\instrument, \sine, \midinote, Pwhite(60, 72, 8), \dur, 0.15)).play


////////////////////////// Random choice ///////////////////////////

~play.(Prand([60, 64, 67, 72], 16));

~play.(Pxrand([60, 64, 67, 72], 16));

~play.(Pshuf([60, 64, 67, 72], 4));

~play.(Pwrand([60, 64, 67, 72], [0.4, 0.3, 0.2, 0.1], 16));


////////////////////////// Plotting patterns ///////////////////////////

(
~plotPattern = { |pattern, count = 500|
	pattern.asStream.nextN(count).plot(discrete: true)
};

~histogram = { |pattern, count = 4000|
	pattern.asStream.nextN(count).histo(40).plot
};
)

~plotPattern.(Pwhite(0.0, 1.0));

~histogram.(Pwhite(0.0, 1.0));

~plotPattern.(Pexprand(0.01, 1.0));

~histogram.(Pexprand(0.01, 1.0));


////////////////////////// Large numbers ///////////////////////////

~histogram.(Pgauss(0.0, 1.0), 50);

~histogram.(Pgauss(0.0, 1.0), 500);

~histogram.(Pgauss(0.0, 1.0), 50000);


////////////////////////// Combining random numbers ///////////////////////////

~histogram.(Plprand(0.0, 1.0));    // the lower of two

~histogram.(Phprand(0.0, 1.0));    // the higher of two

~histogram.(Pmeanrand(0.0, 1.0));  // the mean of two

~histogram.(Pfunc { 1.0.rand + 1.0.rand });

~histogram.(Pfunc { ({ 1.0.rand } ! 12).sum });


////////////////////////// Changing distributions ///////////////////////////

~plotPattern.(Pgauss(0.0, Pseries(0.0, 0.01)), 1000);

~plotPattern.(Pbeta(0.0, 1.0, Pseries(0.1, 0.01), Pseries(0.1, 0.01)), 1000);

Pbind(\instrument, \sine, \midinote, Pgauss(66, Pseries(0.0, 0.05, 400)), \dur, 0.04, \amp, 0.1).play


////////////////////////// Brownian motion ///////////////////////////

~plotPattern.(Pwhite(0, 100));

~plotPattern.(Pbrown(0, 100, 2));

~plotPattern.(Pbrown(0, 100, 20));

~plotPattern.(Pseries(0.0, Pwhite(-1.0, 1.0)), 1000);

~plotPattern.(Pseries(0.0, Pgauss(0.0, 1.0)), 1000);

~plotPattern.(Pseries(0.0, Pcauchy(0.0, 0.5)), 1000);

(
Pbind(\instrument, \sine,
	\midinote, Pbrown(48, 84, 3),
	\dur, Pgbrown(0.04, 0.4, 0.1),
	\amp, Pbrown(0.02, 0.2, 0.02)).play
)

Pbind(\instrument, \sine, \midinote, Pseries(60, Pcauchy(0.0, 0.3)).fold(36, 96), \dur, 0.08).play


////////////////////////// Transition matrix ///////////////////////////

(
~states = [60, 64, 67, 72];
~matrix = [
	[0.1, 0.6, 0.2, 0.1],
	[0.3, 0.0, 0.6, 0.1],
	[0.4, 0.2, 0.0, 0.4],
	[0.0, 0.3, 0.7, 0.0]
];
~index = 0;
~chain = Pfunc { ~index = ~matrix[~index].windex; ~states[~index] };
)

Pbind(\instrument, \sine, \midinote, ~chain, \dur, 0.15).play


////////////////////////// Learning a chain ///////////////////////////

Quarks.install("MathLib");    // then recompile the class library

~melody = [60, 62, 64, 60, 60, 62, 64, 60, 64, 65, 67, 64, 65, 67];

(
m = MarkovSetN.fill(100, Pseq(~melody, inf).asStream, 1);
m.makeSeeds;
Pbind(\instrument, \sine, \midinote, m, \dur, 0.2).trace.play
)

(
m = MarkovSetN.fill(100, Pseq(~melody, inf).asStream, 2);
m.makeSeeds;
Pbind(\instrument, \sine, \midinote, m, \dur, 0.2).trace.play
)


////////////////////////// State machines ///////////////////////////

(
Pbind(\instrument, \sine,
	\midinote, Pfsm([
		[0],
		60, [1, 2],
		Pseq([64, 65, 67]), [0, 2],
		72, [0, 1]
	], inf),
	\dur, 0.15).trace.play
)

(
a = Pbind(\instrument, \sine, \midinote, Pwhite(72, 84, 16), \dur, 0.05);
b = Pbind(\instrument, \gliss, \midinote, Pwhite(40, 50, 2), \dur, 1);
c = Pbind(\instrument, \sine, \midinote, Pbrown(55, 65, 2, 8), \dur, 0.2);
Pfsm([[0], a, [1, 2], b, [0, 2], c, [0, 1]], inf).play
)


////////////////////////// Plotters ///////////////////////////////

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


////////////////////////// More distributions ///////////////////////////

( // Phprand, random values that tend toward hi
Pbind(\instrument, \sine, \dur, 0.1, \midinote, Phprand(40, 80).trace).play
)

( // sequences of distributions
Pbind(
	\dur, Pseq([Plprand(0.1, 0.2, Pwhite(2, 4)), Pgauss(0.5, 0.25, 4)], inf),
	\amp, Pexprand(0.03, 0.1),
	\instrument, Pstutter(10, Pseq([\sine, \gliss], inf)),
	\midinote, Pseq([Phprand(50, 60, 16), Pwhite(70, 80, 8)], inf)
).play
)

( // layers
a = Pbind(\instrument, \sine, \dur, 0.2, \midinote, Phprand(40, 80, 12));
b = Pbind(\instrument, \sine, \dur, 0.2, \midinote, Pexprand(40, 80, 8));
Pseq([a, b], 16).play
)


////////////////////////// Markov chains with MathLib ///////////////////////////

Quarks.install("MathLib")

( // probabilities are set for future states
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



///////////////////// Every distribution //////////////////////

/*
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
*/

// To see a distribution, make a histogram out of it.
Pmeanrand(0.0, 1.0, inf).asStream.nextN(10000).histo(200, 0.0, 1.0).plot;
