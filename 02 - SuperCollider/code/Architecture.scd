////////////////////////////////////////////////////////////////
//
//                     SuperCollider
//
////////////////////////////////////////////////////////////////

s.boot;

///////////////////// First sound /////////////////////////////

// it does the same thing every time
{ SinOsc.ar(220, 0, 0.2) ! 2 }.play;

// it decides for itself and will not repeat
{ SinOsc.ar(LFNoise1.kr(3).range(200, 800), 0, 0.2) ! 2 }.play;



///////////////////// SynthDef and Synth /////////////////////////

/* A SynthDef is a description that is sent and named.
   The arguments are what can change afterwards
*/

(
SynthDef(\tone, { |freq = 440, amp = 0.2, pan = 0, dur = 2|
	var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
	var sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

Synth(\tone, [\freq, 330]);
Synth(\tone, [\freq, 660, \amp, 0.1, \pan, -0.7]);

// three at once, one description
(
[320, 577, 730].do { |f, i|
	Synth(\tone, [\freq, f, \pan, i - 1, \dur, 3]);
};
)


///////////////////// Rates //////////////////////////////////////

// .kr is quantised to the block, so a fast sweep on kr is a staircase
{ SinOsc.ar(Line.kr(200, 2000, 0.3), 0, 0.2) ! 2 }.play;
{ SinOsc.ar(Line.ar(200, 2000, 0.3), 0, 0.2) ! 2 }.play;

// how many values a second each rate produces
s.sampleRate;                       // whatever the device is set to
s.sampleRate / s.options.blockSize; // 689.06 at 44100, 750 at 48000



///////////////////// Order of execution /////////////////////////

/* The server runs its nodes from head to tail within a group. An effect has to sit
   after the source it reads. Put it before and it is silent, not late: In.ar returns
   zeros for a bus that has not been written yet in this block. Measured here: In.ar
   in front of the source peaks at 0.0, InFeedback.ar in the same place at 0.3. */

(
SynthDef(\src, { |out = 16|
	Out.ar(out, PinkNoise.ar(0.2) * EnvGen.kr(Env.perc(0.01, 0.3), doneAction: 2));
}).add;
SynthDef(\verb, { |in = 16|
	Out.ar(0, FreeVerb.ar(In.ar(in, 1), 0.9, 0.9) ! 2);
}).add;
)

// the reverb at the tail, so it reads what the source already wrote
(
x = Synth(\verb, addAction: \addToTail);
Routine({ 8.do { Synth(\src, addAction: \addToHead); 0.4.wait } }).play;
)
x.free;

// the same thing with the reverb at the head: silence
(
y = Synth(\verb, addAction: \addToHead);
Routine({ 8.do { Synth(\src, addAction: \addToTail); 0.4.wait } }).play;
)
y.free;

// InFeedback reads the previous block, so the same wrong order now sounds
(
SynthDef(\verbFb, { |in = 16|
	Out.ar(0, FreeVerb.ar(InFeedback.ar(in, 1), 0.9, 0.9) ! 2);
}).add;
)
(
z = Synth(\verbFb, addAction: \addToHead);
Routine({ 8.do { Synth(\src, addAction: \addToTail); 0.4.wait } }).play;
)
z.free;

s.plotTree;                          // the order, drawn
s.options.numOutputBusChannels;      // where the private busses start

CmdPeriod.run;


///////////////////// Multichannel expansion /////////////////////

/* Pass an array where a UGen expects one value and the whole expression is
   duplicated, once per element. The signature idiom of the language. */

{ SinOsc.ar([200, 300, 400, 500, 600, 700, 800, 900], 0, 0.05) }.play;

// mixed down, so the expansion is a timbre rather than a channel count
{ Splay.ar(SinOsc.ar((1..16) * 110, 0, 0.03)) }.play;

// the same idea with the ratios chosen rather than counted
{ Splay.ar(SinOsc.ar(110 * [1, 2.4, 3.7, 5.2, 8.1], 0, 0.06)) }.play;

// and the version nobody writes, which sounds the same
(
SynthDef(\one, { |freq = 200| Out.ar(0, SinOsc.ar(freq, 0, 0.05) ! 2) }).add;
)

(
8.do { |i| Synth(\one, [\freq, 200 + (i * 100)]) };
)

CmdPeriod.run;


///////////////////// Server or language /////////////////////////

/* The same glissando */

// on the server: one node, a continuous line
{ SinOsc.ar(XLine.kr(200, 800, 4), 0, 0.2) ! 2 }.play;

// in the language: many nodes, each with a fixed frequency
(
Routine({
	40.do { |i|
		Synth(\tone, [\freq, 200 * pow(4, i / 39), \dur, 0.2, \amp, 0.1]);
		0.1.wait;
	};
}).play;
)


///////////////////// Two clocks /////////////////////////////////

s.latency;            // 0.2 by default

(
Pdef(\steady, Pbind(\instrument, \tone, \dur, 0.15,
	\freq, Pseq([330, 440, 550, 660], inf), \amp, 0.1, \dur, 0.15)).play;
)

// the network becoming audible
s.latency = nil;
s.latency = 0.2;

Pdef(\steady).stop;

CmdPeriod.run;


///////////////////// Patterns and performances //////////////////

/* A Pattern is a description, a Stream is one reading of it. The same relation
   as a score to a performance, and as a SynthDef to a Synth. Class 03. */

p = Pseq([1, 2, 3], inf).asStream;
p.next;
p.next;
p.next;
