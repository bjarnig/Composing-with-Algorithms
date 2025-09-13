////////////////////////////////////////////////////////////////
//
//                     SuperCollider
//
////////////////////////////////////////////////////////////////

A short introduction to SuperCollider with statements, sounds,
synths and patterns.


// post to the post window
(
"Hello World!"
)

// a calculation
4 + 8


// a list
[60, 62, 64, 68].class + 12


// math
2.pow(4)


// random numbers
rrand(1, 10)


// conversion
60.midicps


// push cmd-d while selection the classes below
SimpleNumber
String
Array


// a sine wave
{ SinOsc.ar }.play


// with arguments
{ SinOsc.ar(300, 0.1) }.play;


// modulate frequency
{ SinOsc.ar(440 + SinOsc.kr(100.1).range(-150, 150), 0, 0.1) }.play


// a saw modulated by a sine
{ Saw.ar( SinOsc.kr(0.1).range(10, 60).midicps, 0.1) }.play


// a code block, variables and semicolons
(
a = 10;
b = exprand(1, 5);
a + b
)

// environment variables

(
~myFunction = { "sonology".postln; 10 + 2 };
a = ~myFunction.value
)

~mySynth = { PinkNoise.ar(0.1) }
~mySynth.play


// A Synth

(

SynthDef(\sonology, {|out=0, freq=5|
	Out.ar(out, Pan2.ar(Impulse.ar(freq)));
}).add;

)


// play the synth
Synth(\sonology)


// with arguments
Synth(\sonology, [\freq, 10]);
Synth(\sonology, [\freq, 200])


// change arguments
~mySynth = Synth(\sonology, [\freq, 50])
~mySynth.set(\freq, 20)




// noise synth and reverb effect
(

SynthDef(\noise, { arg out=0, amp=0.3, atk=0.5, sus=1.0, rel=1.0, freq=10000;
		var sig, shape, env, filter, crackle, pan;
	    shape = Env([0, 1, 1, 0], [atk, sus, rel]);
	    env = EnvGen.ar(shape, doneAction: 2);
	    crackle = Crackle.ar(1.99, mul: amp);
	    filter = RLPF.ar(crackle, freq, 0.1);
	    pan = Pan2.ar(filter, 0.3);
		sig = pan * env;
		Out.ar(out, sig);
	}).add;

SynthDef(\gverb, {|in=0, out=0, amp=0.5, roomsize=100, revtime=3, mix=0.8|
		var signal, verb;
		signal = In.ar(in, 2);
		verb = GVerb.ar(signal, roomsize, revtime, 0.5, 0.5, 15, 0.5, 0.7, 0.5, roomsize);
		Out.ar(out, (signal * (1 - mix)) + (verb * mix)) * amp;
	}).add;

)


// play first the noise, then the effect, then noise through the effect.
// the noise sends audio to bus 4, the reverb reads from there and writes to 0.
~reverb = Synth(\gverb, [\in, 4, \out, 0, \revtime, 20])
~noise = Synth(\noise, [\out, 4, \freq, rrand(100,10000)])


// scheduling events with .fork
(

{
	4.do {

	Synth(\noise, [\freq, 800]);

	1.wait;

	Synth(\noise, [\freq, 400, \atk, 4]);
	Synth(\noise, [\freq, 1400, \atk, 4]);

	4.wait;

	Synth(\noise, [\freq, 2000, \amp, 0.1, \rel, 10]);

	}

}.fork

)


// scheduling with patterns
Pbind().play


// scheduling with patterns, randomness in duration
Pbind(\dur, Pwhite(0.01, 1.5)).play


( // random pitches and durations from a list

~pitches = [60,64,67,69];
~durations = [1, 0.1, 2, 0.2];

Pbind(
	\midinote, Prand(~pitches, inf),
	\dur, Prand(~durations, inf),
).play

)


( // play our noise synth

Pbind(
	\instrument, \noise,
	\freq, Pwhite(100, 1000),
	\dur, Pbrown(0.0, 0.5, 0.1),
).play

)


( // nested patterns and attack control

Pbind(
	\instrument, \noise,
	\atk, Pwhite(0.01, 0.2),
	\freq, Pseq([Pwhite(1000, 1200, 5), Pwhite(200, 400, 5)], inf),
	\dur, Pseq([Pbrown(0.0, 1.0, 0.1, 10), Pwhite(0.1, 0.5, 10)], inf),
).play

)


( // add a simple sine synth similar to the noise one

SynthDef(\sine, { arg out=0, amp=0.1, atk=0.5, sus=1.0, rel=1.0, freq=200;
		var shape, env, osc, pan;
	    shape = Env([0, 1, 1, 0], [atk, sus, rel]);
	    env = EnvGen.ar(shape, doneAction: 2);
	    osc = SinOsc.ar(freq, 0, amp) * env;
		pan = Pan2.ar(osc, 0);
		Out.ar(out, pan);
	}).add;

)



// play several patterns at the same time

(

~noise = Pbind(
	\instrument, \noise,
	\freq, Pwhite(100, 2000),
	\dur, Pbrown(0.0, 1.0, 0.1),
);

~sine = Pbind(
	\instrument, \sine,
	\freq, Pwhite(100, 500),
	\dur, Pbrown(0.0, 1.0, 0.1),
);

Ppar([ ~noise, ~sine ]).play;

)