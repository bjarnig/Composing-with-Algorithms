////////////////////////////////////////////////////////////////
//
//                          Patterns
//
////////////////////////////////////////////////////////////////


Pattern basics and sequencing synths.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\sine, {
	|out=0, amp=0.1, freq=440, rel=0.2, pan=0|
	var env, sig;
	env = EnvGen.kr(Env.perc(rel:rel), doneAction:2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;


SynthDef(\saw, {|out=0, freq=25, rel=1.0, lop=500, res=0.1, amp=1.0|
	var sig, env, filter;
	sig = Saw.ar(freq ! 2) * amp;
	env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction:2);
	filter = BLowPass4.ar(sig, lop, res);
	Out.ar(out, filter * env);
}).add;


SynthDef(\sampler, {
	|out=0, pan=0, buf=0, note=60, amp=1.0, pos=0.0, rel=1.0|
	var sig, rate, start, env;
	env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction:2);
	rate = BufRateScale.ir(buf) * (note / 60.0);
	start = BufFrames.kr(buf) * pos;
	sig = PlayBuf.ar(1, buf, rate, 1, start);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;


SynthDef(\pluck, {
	|amp=0.1, note=60, decay=4, coef=0.1, pan=0|
	var env, sig, pluck, delay;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction:2);
	sig = WhiteNoise.ar(amp);
	delay = note.midicps.reciprocal;
	sig = Pluck.ar(in:sig, delaytime:delay, decaytime:decay, coef:coef);
	Out.ar(0, Pan2.ar(sig * 0.5, pan));
}).add;

)

// pbind, bind instruments and values
Pbind(\instrument, \sine,  \dur, 0.1, \freq, 200, \amp, 0.1).play

// detune (in hertz)
Pbind(\instrument, \sine,  \dur, 0.2, \freq, 200, \detune, Pn(Pseries(10,10,10,10))).play

// using midinotes directly
Pbind(\instrument, \sine, \dur, 0.2, \midinote, Pseq([60,62,65], inf)).play

// within an octave
Pbind(\instrument, \sine, \dur, 0.2, \note, Pseq([1,3,5], inf), \octave, Pseq([6,6,5,5,7], inf)).play

// within a scale
Pbind(\instrument, \sine, \dur, 0.2, \degree, Pseq([1,3,5, Pseq([6,7],2)], inf), \scale, Scale.ionian).play

// divide the octave differently than in 12 steps using \stepsPerOctave
Pbind(\instrument, \sine, \dur, 0.2, \stepsPerOctave, 31, \note, Pseq([1,3,5], inf)).play

// calling play returns an EventStreamPlayer with various ways to play the pattern
p = Pbind(\instrument, \sine, \dur, 0.2, \freq, Pwhite(400,600)).play

p.class
p.stop
p.start
p.mute
p.unmute
p.pause
p.resume
p.reset


////////////////////////// Buffers ///////////////////////////

(

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
~path = ~path = ~path ++ "/samples/";
~vocal = Buffer.read(s, ~path ++ "vocal.wav");
~sequence = Buffer.read(s, ~path ++ "sequence.wav");

)

// Test Synths

Synth(\pluck, [\note, 60, \decay, 10])

Synth(\pulse, [\rel, 12, \lop, 2800])

Synth(\sampler, [\buf, ~vocal.bufnum, \rel, 14])

Synth(\sampler, [\buf, ~sequence.bufnum, \rel, 4])

Synth(\sampler)



////////////////////////// Patterns ///////////////////////////


// Bind sine with patterns for freq and amp
(
Pbind(
	\instrument, \sine,
	\freq, Pwhite(100, 1000),
	\amp, Pseq([0.1, 0.2], inf),
	\dur, 0.2
).play
)


// Pwhite for pitches and filter
(
Pbind(\instrument, \saw,
		\midinote, Pwhite(24, 72),
		\lop, Pwhite(1000, 2000),
		\dur, 0.2,
		\amp, 0.2
	).play
)


// Pwhite for duration, amplitude and filter
(
Pbind(\instrument, \saw,
		\lop, Pwhite(100, 8000),
		\dur, Pwhite(0.1, 0.2),
		\amp, Pwhite(0.0, 1.0),
	).play
)


// Pwhite for position and release
(
Pbind(\instrument, \sampler,
		\buf, ~vocal,
	    \note, 60,
	    \pos, Pwhite(0.0, 0.2, inf),
		\rel, Pwhite(0.5, 2.0, inf),
		\dur, 0.2,
		\amp, 1.0
	).play
)


// Pwhite for note, position and duration
(
Pbind(\instrument, \sampler,
		\buf, ~vocal.bufnum,
	    \note, Pwhite(20, 100, inf),
	    \pos, Pwhite(0.0, 1.0, inf),
		\dur, Pwhite(0.05, 0.06, inf),
	    \rel, 0.2,
		\amp, 1.0
	).play
)


// Pwhite for note, position and duration
(
Pbind(\instrument, \sampler,
		\buf, ~vocal.bufnum,
	    \note, 60,
	    \pos, Pwhite(0.1, 0.15, inf),
		\dur, Pwhite(0.01, 0.04, inf),
	    \rel, 0.2,
		\amp, 1.5
	).play
)


// Simple series for pitch
(
Pbind(\instrument, \pluck,
		\note, Pseries(48, 0.25, 32),
		\dur, 0.2,
		\amp, 0.2,
	).play
)


// Series for all parameters
(
Pbind(\instrument, \pluck,
		\note, Pseries(Pwhite(20, 40), -2),
	    \dur, Pseries(0.1, 0.01),
		\amp, Pseries(0.5, 0.01),
	).play
)


// Geom for multiplied growth
(
Pbind(\instrument, \pluck,
		\note, Pgeom(80, 1.01, 32),
		\dur, Pgeom(0.1, 1.1, 32),
		\amp, Pgeom(0.5, 1.001, 32),
	).play
)


// Patterns can be plotted

Pwhite(0.0, 1.0, 100).asStream.all.plot(discrete: true);

Pseries(0, 0.01, 100).asStream.all.plot;

Pwhite(Pseries(0, 0.01, 100), 1.0, 100).asStream.all.plot;




// series up and series down, with variables
(
var base, dur, step, times;

base = 60;
dur = 0.2;
step = 1;
times = 6;

Pbind(\instrument, \pluck,
	\note, Pseq([Pseries(base,step,times), Pseries(base,step.neg,times)], inf),
		\dur, dur,
		\amp, 0.5,
	).play
)




// pluck and pulse at the same time
(
var noteFrom=12, noteTo=72, steps=12, growth=1.1, durations;

durations = Array.geom(steps, 0.1, growth);
durations = durations ++ durations.reverse;

~pluck = Pbind(
	\instrument, \pluck,
	\note, Pwhite(noteFrom, noteTo),
	\dur, Pseq(durations, inf)
);

~pulse = Pbind(
	\instrument, \pulse,
	\note, Pwhite(noteFrom, noteTo),
	\dur, Pseq(durations, inf)
);

Ppar([ ~pluck, ~pulse ]).play;
)




// sequence and vocal at the same time
(
var noteFrom=12, noteTo=72, steps=12, growth=1.1, durations;

durations = Array.geom(steps, 0.1, growth);
durations = durations ++ durations.reverse;

~sampler = Pbind(
	\instrument, \sampler,
	\buf, ~vocal.bufnum,
	\note, Pwhite(noteFrom, noteTo),
	\amp, 1.0,
	\dur, Pseq(durations, inf)
);

~sequence = Pbind(
	\instrument, \sampler,
	\buf, ~sequence.bufnum,
	\note, Pwhite(noteFrom, noteTo),
	\amp, 1.0,
	\dur, Pseq(durations, inf)
);

Ppar([ ~sampler, ~sequence ]).play;
)




// pos and dur with envelopes
(
var up=5, down=10;
~sampler = Pbind(
	\instrument, \sampler,
	\buf, ~vocal.bufnum,
	\note, 60,
	\amp, 1.0,
	\pos, Env.new([0.1, 0.5, 0.1],[up, down], 'sine'),
	\dur, Pkey(\pos) * 0.1
).play
)
