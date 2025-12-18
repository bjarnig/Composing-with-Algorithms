////////////////////////////////////////////////////////////////
//
//                       CWA07 - Exercises
//
////////////////////////////////////////////////////////////////

(

SynthDef(\sine, { arg freq=500, gate=1, out=0, amp=0.1, pan=0, atk=0.01, rel=0.1;
	var env = EnvGen.kr(Env.asr(atk, amp, rel), gate, doneAction:2);
	var signal = SinOsc.ar(freq);
    OffsetOut.ar(out, Pan2.ar(signal * env, pan));
}).add;

)


/*1. Create three collections of pre-selected pitched and a process that will
play first some events from the first collection, then some from the other
and finally some from the third. The way notes are selected should be
different at each time.*/

(

var lista = [500,600,700,800];
var listb = [2500,2600,2700,2800];
var listc = [150,260,370,480];

Pbind(
	\instrument, \sine, \dur, 0.2, \legato, 0.5,
	\freq, Pn(Plazy({Prand([
		Pseq( Array.fill(1 + 4.rand, { lista.choose }) ),
		Prand( Array.fill(1 + 4.rand, { listb.choose }) ),
		Pxrand( Array.fill(1 + 4.rand, { listc.choose }) )
	])})).trace

).play

)


/*2. Create a process consisting of two layers where one plays low notes and
the other high notes. A tendancy mask should be created for controlling
the balance between the two processes. It should start by favouring high
notes and end towards low ones.*/

(

var balance = 0.5;

Pbind(\instrument, \sine, \freq, 200, \dur, 0.1, \legato, 0.2, \amp, Pfunc{ balance }).play;
Pbind(\instrument, \sine, \freq, 2000, \dur, 0.1, \legato, 0.2, \amp, Pfunc{ 1.0 - balance }).play;
Pbind(
	\dur, 0.1, \amp, 0.0,
	\tm, Pn(Pwhite(Penv([0.0,0.5,0.8],[2,2]), Penv([0.2,0.8,0.9],[2,2]))),
	\sm, Pfunc{|ev| balance = ev.tm}).trace.play;
)


/*3. Create a chord progression where the duration of each chord increases
in time. The pitches that form the chords should be selected from a
predefined group(s) of pitches.
Exercises*/

(

var groups = [
	[300,600,900],
	[400,600,800],
	[100,1000,4000],
	[2200,220,880]
];

Pbind(
	\instrument, \sine, \amp, 0.3, \legato, 1.3,
	\dur, Pn(Pseries(0.1,0.1,8)),
	\freq, Pseq([
		groups.choose.postln,
		groups.choose
   ], inf)).trace.play;

)


/*4. Implement a process that selects durations from a collection of pre-
defined durations (rhythmic values). To the selected duration a variable
number should be added each time. This number should be very small in
the beginning of the process but increase as it unfolds.*/

(

var durs = [0.1,0.15,0.2,0.25];

Pbind(\instrument, \sine, \amp, 0.3, \dur, Prand(durs,inf) + Pn(Pseries(0.1,0.1,8))).play


)


/*5. Implement a tendency mask for frequency and duration values where
the high and low boundaries are determined by a random walk.*/


(
	Pbind(
	    \instrument, \sine,
	    \freq, Pwhite(
		    Pseg(
			    Pbrown(600,1000,100),
				Pseq([ 5, 5, 5, 5 ], inf)),
			Pseg(
			    Pbrown(100,5000,100),
				Pseq([ 5, 5, 5, 5 ], inf))
			),
	    \dur, 0.1
	).play;
)



/*6. Implement a sequence of chords where the number of notes a chord
consists of is low at the start of the process but increases as it unfolds.*/

(

var pitches = Array.fill(8,{|i| Array.fill(i + 2, { rrand(100,1000) }) });

Pbind(
	\instrument, \sine,
	\freq, Pseq( pitches, inf).trace,
	\dur, 0.3
).play

)

