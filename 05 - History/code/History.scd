////////////////////////////////////////////////////////////////
//
//                   Patterns in SuperCollider
//
////////////////////////////////////////////////////////////////

This document covers simple synths, noises, playing samples
and sequencing with patterns.

Be careful with sound volumes, uperhaps use StageLimiter
included in the BatLib Quark, activate and it will limit the
sound output.

StageLimiter.activate


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\fm, {
	|out=0,pan=0,note=60,amp=1.0,mod=1000,amt=0.5,atk=0.1,sus=0.1,rel=0.1|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = PMOsc.ar(note.midicps, mod, amt);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

SynthDef(\noise, {
	|out=0,pan=0,note=60,amp=1.0,res=0.5,atk=0.1,sus=0.1,rel=0.1|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = BPF.ar(WhiteNoise.ar, note.midicps, res);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

SynthDef(\saw, {
	|out=0,pan=0,note=40,amp=1.0,res=0.5,atk=0.1,sus=0.1,rel=0.1,lop=8000|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = BLowPass4.ar(Saw.ar(note.midicps), lop);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

)

// Test Synths

Synth(\noise)

Synth(\fm)

Synth(\saw)

Pbind(\instrument, \saw, \note, 60).play



////////////////////////// Patterns ///////////////////////////


/* Patterns with midi output. */

MIDIClient.init;

(

var midiout = MIDIOut.newByName("IAC Driver", "BG.Virtual");

Pbind(
	\midinote, Pbrown(30, 60, 4),
	\dur, 1/16,
	\amp, 0.5,
	\midiout, midiout,
	\type, \midi
).trace.play

)




/* Use envelope shapes for pitches (here a sine shape) and fm
modulation (here a generated shape) */

(

var sine, pitch, shape, mod;

sine = Env.perc;
pitch = Pn(Penv(sine.levels.linlin(0,1,40,80), sine.times * 2));

shape = Env(Array.rand(10, 0.0, 10.0), Array.rand(9, 0.0, 2.0));
mod = Pn(Penv(shape.levels, shape.times));

sine.plot;
shape.plot;

Pbind(
	\instrument,\fm,
	\note, pitch,
	\amt, mod,
	\dur, 0.1
).play

)


/* Checking already decided properties of the Event and use Pswitch for selecting generators */

(

var wa, wb, stutter;

wa = Pwhite(48,60);
wb = Pwhite(70,80);
stutter = Pstutter(Pseq([2,3],inf),Pseq([0,1],inf));

Pbind(
	\instrument, \noise,
	\note, Pswitch1([wa, wb], stutter),
	\rel, Pfunc({ arg event;
			event.postln;
			if(event.note < 60, {
				rrand(1.0, 2.0);
			}, 0.5);
		}),
	\dur, 0.2
).play

)


/* Change patterns on the fly using EventPatternProxy */

(

a = PatternProxy(Pwhite(80,88));

Pbind(
	\instrument, \noise,
	\note, a,
	\dur, 0.2
).play;

)

a.source = Pseq([50,60,70,80], inf);
a.source = Pbrown(20,50);



/* Use Pdef to change a Pbind while it plays   */

(

Pdef(\fun, Pbind(
	\instrument, \saw,
	\note, 30,
	\dur, Pn(Penv([0.3, 0.5, 0.01], [2,4]))
)).play

)


/* Beta distribution favors the extremes, here for pitch, filter and list reading (durations) */

(

var list, beta;

list = [0.15, 0.1, 0.25, 0.35];
beta = Pbeta(0, list.size - 1, 0.1, 0.1, inf).round(1);

Pbind(
	\instrument, \saw,
	\note, Pbeta(40, 80, 0.1, 0.1, inf),
	\lop, Pbeta(200, 10000, 0.5, 0.5, inf),
	\dur, Pindex(list, beta).trace
).play

)



/* Sequencing three (or more) properties at a time */

(

Pbind(
	\instrument, \saw,
	[\note, \lop, \dur],
	Pseq([
		[42, 8000, 1/8],
		[72, 800, 1/16],
		Pfuncn({ [rrand(50,55),rrand(400,600),rrand(1/32,1/4)]},1)
	], inf)
).play

)




/* Upper limit of an exponential distribution changes */

(

Pbind(
	\instrument, \saw,
	\dur, Pexprand(0.1, Env([0.1, 0.2, 0.15], [5,5], Env([0.1,0.8, 0.15], [5,5], [2,8]))),
	\note, Pexprand(10, Env([30, 40, 80], [5,5], Env([0.1,0.8, 0.15], [5,5], [2,8])))
).trace.play

)



/* One value from each sub-pattern and return as array (chord) using Ptuple.
Pser for durations where we specify the number of items (otherwise like Pseq.)  */

(

Pbind(
	\instrument, \fm,
	\note, Ptuple([Pwhite(50,60,inf), Pwhite(70,80,inf)]),
	\amt, Pwhite(1.0, 10.0),
	\dur, Pser([1/8, 1/10], 24)
	).trace.play
)



/* Group repeats of incoming values, controls rate of change */

(

var groupSize = 3, repeats = 4;
Pbind(
	\instrument, \saw,
	\note, Pn(Plazy({ Pshuf(Pwhite(30,50).asStream.nextN(groupSize), repeats) })).trace,
	\lop, Pbrown(800, 1500, 50),
	\dur, 0.2
).play

)


// Collection operations, select, collect or reject.
Pbind(\instrument, \sine, \freq , Pwhite(100,900).select({|x| x < 800}), \dur, 0.1).play

// Pn, simple repetition
Pbind(\freq, Pn(Pseq([500,600,700]), 10), \dur, 0.1).play

// Pstutter, repeat values
Pbind(\freq, Pstutter(10, Pseq([500,600,700], inf)), \dur, 0.1).play

// Ptime, the time amount since starting, used here with an if to stop
Pbind(\degree, Pif(Ptime(inf) < 1.0, Pwhite(-4, 11, inf)), \dur, 0.1).play;

// Psync, limit total dur, like Pfindur but waits until clock sync, here one beat
Psync(Pbind(\freq, Pseq([500,600,700], inf), \dur, 0.03), 1, 1).play

// Pstep repeat input value for an amount of time
Pbind(\instrument, \sine, \freq, Pstep(Pwhite(200,400), 4, inf), \dur, 0.05).play;

// Pseq similar to step but interpolates between values
Pbind( \instrument, \sine, \freq, Pseg(Pwhite(100,500),Pseq([1,5],inf),\linear),\dur, 0.1).play;

// Use env simply within patterns
Pbind(\instrument, \sine, \freq,Env([100,1000], [5]),\dur,Env([0.05,0.01,0.1], [5,10])).play;

// Pclutch, sample and hold a pattern, second pattern boolean indicates if one should sample again.
Pbind(\freq, Pclutch(Pwhite(95.123, 551.1234), Pseq([1, 0, 0, 0, 0], inf)), \dur, 0.1).play

// Pconst, limit the sum of items, (here we stop after a total of 5k freqs)
Pbind(\freq, Pconst(5000, Pseq([500,600,700], inf)), \dur, 0.1).play

// Wrap envelopes inside Pn to loop
Pbind(\instrument, \sine, \freq, Pn(Pif(Ptime(inf) < 2, Env([100,200],[1])),inf), \dur,0.08).play

// Pbindef to bind value patterns to one event stream
a = Pbind(\instrument, \sine, \dur, 0.1); Pbindf(a, \freq, 800).play

// Pchain, chains pbinds together
a = Pbind(\instrument, \sine); b = Pbind(\dur, 0.1, \freq, 150); Pchain(a,b).play

