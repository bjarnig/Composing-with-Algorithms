////////////////////////////////////////////////////////////////
//
//                   Patterns in SuperCollider
//
////////////////////////////////////////////////////////////////

Pattern techniques for building processes: envelopes as patterns, selecting
between generators, changing patterns while they play, distributions, chords
and repetition. The historical procedures are in History.scd.

Be careful with sound volumes. StageLimiter, in the BatLib Quark, limits the
sound output once it is activated.

StageLimiter.activate


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\fm, {
	|out=0,pan=0,note=60,amp=0.3,mod=1000,amt=0.5,atk=0.1,sus=0.1,rel=0.1|
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
	|out=0,pan=0,note=40,amp=0.3,atk=0.1,sus=0.1,rel=0.1,lop=8000|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = BLowPass4.ar(Saw.ar(note.midicps), lop.clip(20, 18000));
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

SynthDef(\sine, {
	|out=0,pan=0,freq=440,amp=0.2,atk=0.005,rel=0.2|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq) * env, pan, amp));
}).add;

)

// Test the synths

Synth(\noise)

Synth(\fm)

Synth(\saw)

Synth(\sine)

Pbind(\instrument, \saw, \note, 60).play



////////////////////////// Patterns ///////////////////////////


/* Patterns with MIDI output, to a bus of the IAC Driver on macOS.
MIDIClient.destinations lists the names available on your machine. */

MIDIClient.init;

(

var midiout = MIDIOut.newByName("IAC Driver", "BG.Virtual");

Pbind(
	\type, \midi,
	\midiout, midiout,
	\midinote, Pbrown(30, 60, 4),
	\dur, 1/16,
	\amp, 0.5
).trace.play

)


/* Envelope shapes as patterns: a percussive shape for pitch and a random
shape for the FM index. Pn loops each envelope. */

(

var perc, pitch, shape, mod;

perc = Env.perc;
pitch = Pn(Penv(perc.levels.linlin(0, 1, 40, 80), perc.times * 2));

shape = Env(Array.rand(10, 0.0, 10.0), Array.rand(9, 0.1, 2.0));
mod = Pn(Penv(shape.levels, shape.times));

perc.plot;
shape.plot;

Pbind(
	\instrument, \fm,
	\note, pitch,
	\amt, mod,
	\dur, 0.1
).play

)


/* Pswitch1 selects one of two generators at every event, and Pfunc reads a
value the event has already decided. */

(

var low, high, which;

low = Pwhite(48, 60);
high = Pwhite(70, 80);
which = Pdup(Pseq([2, 3], inf), Pseq([0, 1], inf));

Pbind(
	\instrument, \noise,
	\note, Pswitch1([low, high], which),
	\rel, Pfunc { |event| if(event[\note] < 60) { rrand(1.0, 2.0) } { 0.5 } },
	\dur, 0.2
).play

)


/* Change a pattern on the fly with PatternProxy. */

(

a = PatternProxy(Pwhite(80, 88));

Pbind(
	\instrument, \noise,
	\note, a,
	\dur, 0.2
).play;

)

a.source = Pseq([50, 60, 70, 80], inf);
a.source = Pbrown(20, 50);


/* Pdef replaces a Pbind while it plays. Evaluate again with other values. */

(

Pdef(\fun, Pbind(
	\instrument, \saw,
	\note, 30,
	\dur, Pn(Penv([0.3, 0.5, 0.01], [2, 4]))
)).play

)


/* A beta distribution with small parameters favours the extremes. Here it is
used for pitch, for the filter, and to choose from a list of durations. */

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


/* Three properties sequenced together: each array sets note, filter and
duration at once. */

(

Pbind(
	\instrument, \saw,
	[\note, \lop, \dur],
	Pseq([
		[42, 8000, 1/8],
		[72, 800, 1/16],
		Pfuncn({ [rrand(50, 55), rrand(400, 600), rrand(1/32, 1/4)] }, 1)
	], inf)
).play

)


/* The upper limit of an exponential distribution follows an envelope. */

(

Pbind(
	\instrument, \saw,
	\dur, Pexprand(0.1, Env([0.11, 0.3, 0.15], [5, 5])),
	\note, Pexprand(10, Env([30, 40, 80], [5, 5]))
).trace.play

)


/* Ptuple takes one value from each sub-pattern and returns them as an array,
which plays as a chord. Pser counts items rather than repeats of the list. */

(

Pbind(
	\instrument, \fm,
	\note, Ptuple([Pwhite(50, 60, inf), Pwhite(70, 80, inf)]),
	\amt, Pwhite(1.0, 10.0),
	\amp, 0.15,
	\dur, Pser([1/8, 1/10], 24)
).trace.play

)


/* Groups of values repeated in shuffled order, which controls the rate of
change. */

(

var groupSize = 3, repeats = 4;

Pbind(
	\instrument, \saw,
	\note, Pn(Plazy({ Pshuf(Pwhite(30, 50).asStream.nextN(groupSize), repeats) })).trace,
	\lop, Pbrown(800, 1500, 50),
	\dur, 0.2
).play

)


////////////////////////// One-liners ///////////////////////////

// select, collect and reject work on patterns as on collections
Pbind(\instrument, \sine, \freq, Pwhite(100, 900).select({ |x| x < 800 }), \dur, 0.1).play

// Pn, simple repetition
Pbind(\instrument, \sine, \freq, Pn(Pseq([500, 600, 700]), 10), \dur, 0.1).play

// Pdup, repeat each value
Pbind(\instrument, \sine, \freq, Pdup(10, Pseq([500, 600, 700], inf)), \dur, 0.1).play

// Ptime, the time since starting, used here with Pif to stop after one second
Pbind(\instrument, \sine, \degree, Pif(Ptime(inf) < 1.0, Pwhite(-4, 11, inf)), \dur, 0.1).play

// Psync, like Pfindur but waits for the next multiple of the beat, here one beat
Psync(Pbind(\instrument, \sine, \freq, Pseq([500, 600, 700], inf), \dur, 0.03), 1, 1).play

// Pstep, hold each value for an amount of time
Pbind(\instrument, \sine, \freq, Pstep(Pwhite(200, 400), 4, inf), \dur, 0.05).play

// Pseg, like Pstep but interpolates between the values
Pbind(\instrument, \sine, \freq, Pseg(Pwhite(100, 500), Pseq([1, 5], inf), \linear), \dur, 0.1).play

// an Env used directly as a pattern
Pbind(\instrument, \sine, \freq, Env([100, 1000], [5]), \dur, Env([0.05, 0.01, 0.1], [5, 10])).play

// Pclutch, sample and hold: a new value only when the second pattern is true
Pbind(\instrument, \sine, \freq, Pclutch(Pwhite(95.123, 551.1234), Pseq([1, 0, 0, 0, 0], inf)), \dur, 0.1).play

// Pconst, stop once the values add up to 5000
Pbind(\instrument, \sine, \freq, Pconst(5000, Pseq([500, 600, 700], inf)), \dur, 0.1).play

// an envelope inside Pn loops
Pbind(\instrument, \sine, \freq, Pn(Pif(Ptime(inf) < 2, Env([100, 200], [1])), inf), \dur, 0.08).play

// Pbindf adds keys to an existing Pbind
a = Pbind(\instrument, \sine, \dur, 0.1); Pbindf(a, \freq, 800).play

// Pchain combines Pbinds, the later ones providing values to the earlier
a = Pbind(\instrument, \sine); b = Pbind(\dur, 0.1, \freq, 150); Pchain(a, b).play
