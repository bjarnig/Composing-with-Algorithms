
///////////////////////// Patterns ///////////////////////////////

// Plot a pattern
Pwhite(0.0, 1.0, 100).asStream.all.plot;

// Sequence of values
Pbind(\freq, Pseq([200,300,500], inf), \dur, 0.2).play

// Random values
Pbind(\freq, Pwhite(200, 800), \dur, 0.2).play

// Shape in time
Pbind(\freq, Env([100, 1000, 100],[1, 2], 'sine'), \dur, 0.05).play

//Series up
a = Pbind(\midinote, Pseries(48, 1, 48), \dur, 0.1); a.play

// Series down
b = Pbind(\midinote, Pseries(96, -1, 48), \dur, 0.1); b.play

// Combine layers
Pseq([a,b]).play

// Create layers from up and down
Ptpar([0.0, a, 0.0, b, 0.5, a, 0.5, b, 1.0, a, 1.0, b]).play

// Distribution, Exprand
Pbind(\amp, Pexprand(0.01, 1), \dur, 0.1, \freq, [120, 180]).play;

// Distribution, Exprand
Pbind(\amp, Phprand(0.01, 1), \dur, 0.1, \freq, [120, 180]).play;

// Distribution, Poisson
Pbind(\amp, Pexprand(0.01, 1), \dur, 0.1, \midinote, Ppoisson(60, inf)).play;

// Distribution, Gauss
Pbind(\amp, Pexprand(0.01, 1), \dur, 0.1, \midinote, Pgauss(60, 6, inf)).play;

// Distribution, Cauchy
Pbind(\amp, Pexprand(0.01, 1), \dur, 0.1, \midinote, Pcauchy(60, 6, inf)).play;

// Random walks
Pbind(\freq, Pbrown(400, 600, 10, inf), \dur, 0.1).play

// Beta (favors the extremes)
Pbind(\freq, Pbeta(200, 600, 1, 1), \dur, 0.1).play

// Returns the greater of two equal-distribution random numbers.
Pbind(\freq, Phprand(200, 600), \dur, 0.1).play

// Returns the lesser of two equal-distribution random numbers.
Pbind(\freq, Plprand(200, 600), \dur, 0.1).play

// Returns the average of two equal-distribution random numbers, i.e., (x + y) / 2.
Pbind(\freq, Pmeanrand(200, 600), \dur, 0.1).play

// Sequencing more properties at a time
Pbind([\midinote, \dur],Pseq([ [62, 1/8], Pfuncn({[rrand(50,55),rrand(1/32,1/4)]},1)], inf)).play

// Nested pattern with randomness
Pbind(\midinote, Pseries(60, Pwhite(-5, 5, inf).trace, inf), \dur, 0.1).play

// Play for a duration, rounded floating point numbers
Pfindur(10, Pbind(\midinote, Pwhite(60.001, 61.008).round(0.1), \dur, 0.1)).play

// Create and play from a collection and add an offset.
a = [0,1,2,3,4,5,6] + 60; Pbind(\midinote, Prand(a + 7, inf), \dur, 0.1).play

// Generate a collection using a pattern.
b = Pseries(1, 1).asStream.nextN(64) + 60; Pbind(\midinote, Pseq(b), \dur, 0.05).play

// Choose from different collections
c=[50,52,54]; d=[60,62]; Pbind(\midinote, Pseq([Prand(c,4), Prand(d,2)], inf), \dur, 0.1).play

// Group repeats, control rate of change
Pbind(\dur,0.1, \midinote, Pn(Plazy({ Pshuf(Pwhite(40,60).asStream.nextN(3),4)}))).play;

// Collection operations, select, collect or reject.
Pbind(\freq , Pwhite(100,900).select({|x| x < 800}), \dur, 0.1).play

// Pclutch, sample and hold a pattern, second pattern boolean indicates if one should sample again.
Pbind(\freq, Pclutch(Pwhite(95.123, 551.1234), Pseq([1, 0, 0, 0, 0], inf)), \dur, 0.1).play

// Pn, simple repetition
Pbind(\freq, Pn(Pseq([500,600,700]), 10), \dur, 0.1).play

// Pstutter, repeat values
Pbind(\freq, Pstutter(10, Pseq([500,600,700], inf)), \dur, 0.1).play

// Pconst, limit the sum of items, (here we stop after a total of 5k freqs)
Pbind(\freq, Pconst(5000, Pseq([500,600,700], inf)), \dur, 0.1).play

// Psync, limit total dur, like Pfindur but waits until clock sync, here one beat
Psync(Pbind(\freq, Pseq([500,600,700], inf), \dur, 0.03), 1, 1).play

// Ptime, the time amount since starting, used here with an if to stop
Pbind(\degree, Pif(Ptime(inf) < 1.0, Pwhite(-4, 11, inf)), \dur, 0.1).play;

// Pstep repeat input value for an amount of time
Pbind(\freq, Pstep(Pwhite(200,400), 4, inf), \dur, 0.05).play;

// Pseg similar to step but interpolates between values
Pbind( \freq, Pseg(Pwhite(100,500),Pseq([1,5],inf),\linear),\dur, 0.1).play;

// Use env simply within patterns
Pbind(\freq,Env([100,1000], [5]),\dur,Env([0.05,0.01,0.1], [5,10])).play;

// Wrap envelopes inside Pn to loop
Pbind(\freq, Pn(Pif(Ptime(inf) < 2, Env([100,200],[1])),inf), \dur,0.08).play

// Pbindef to bind value patterns to one event stream
a = Pbind(\dur, 0.1); Pbindf(a, \freq, 200).play

// Pchain, chains pbinds together
a = Pbind(\amp, Pexprand(0.01, 1)); b = Pbind(\dur, 0.1, \freq, [150, 200]); Pchain(a,b).play

// Pfsm, state machine, possible initial states, then state and possible next states.
Pbind(\midinote, Pfsm( [[0], 67, [0, 1], 50, [2,3], 73, [0, 2], 83, [0]], inf), \dur, 0.1).trace.play

// Markov chains
Pbind(\midinote, MarkovSetN([[[60], [62, 60], [0.7, 0.3]], [[62], [60],[1]]],1).makeSeeds,\dur, 1/8).play;
