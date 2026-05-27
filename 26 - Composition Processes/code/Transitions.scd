////////////////////////////////////////////////////////////////
//
//                        Transitions
//
////////////////////////////////////////////////////////////////


//////////////////////////  Setup  ////////////////////////////

(

SynthDef(\tone, { |out=0, freq=440, amp=0.2, pan=0, rel=0.18|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.001, rel), doneAction: 2);
	sig = SinOsc.ar(freq * 2.01, SinOsc.ar(freq * 1.41, 0, 4)) * 0.5;
	sig = sig + Blip.ar(freq, 8, 0.3);
	sig = RHPF.ar(sig, freq, 0.5);
	Out.ar(out, Pan2.ar(sig * env * amp, pan));
}).add;

)

(

~secA = Pbind(\instrument, \tone, \midinote, Pseq([48, 54, 49, 53], inf),
	\dur, 0.4, \amp, 0.14, \pan, -0.2);

~secB = Pbind(\instrument, \tone, \midinote, Pseq([72, 66, 71, 77], inf),
	\dur, 0.2, \amp, 0.12, \pan, 0.2);

)


//////////////////////  Sequencing  ////////////////////////

(

Pseq([
	Pfindur(6, ~secA),
	Pfindur(6, ~secB),
], 1).play;

)


////////////////////////  Layering  ////////////////////////

Ppar([~secA, ~secB], 1).play;

(

Pseq([
	Ppar([~secA, ~secB]),
	Ppar([~secB, ~secA]),
], inf).play;

)


///////////////////////  Crossfade  ////////////////////////

(

var fade = 8;

Ppar([
	(Pbind(\amp, 0.12 * Env([1, 0], [fade], [-2]).asPseg) <> ~secA),
	(Pbind(\amp, 0.12 * Env([0, 1], [fade], [ 2]).asPseg) <> ~secB),
], 1).play;

)


////////////////////////  Morphing  ////////////////////////

(

Pbind(
	\instrument, \tone,
	\blend, Pseg([0, 1, 1, 0], [10, 2, 10], \sin, inf),
	\degree, Pseq([0, 2, 3, 5], inf)
		.blend(Pseq([9, 7, 11, 12], inf), Pkey(\blend)).round,
	\dur,    0.4.blend(0.2, Pkey(\blend)),
	\amp,    0.12,
	\octave, 4.blend(5, Pkey(\blend)).round,
	\pan,    (-0.4).blend(0.4, Pkey(\blend)),
).play;

)


///////////////////////  Live morph  ///////////////////////

(

Pbindef(\live,
	\instrument, \tone,
	\degree, Pseq([0, 2, 4, 5, 7], inf),
	\dur, Pdefn(\liveDur, 0.3),
	\amp, 0.1,
	\octave, Pdefn(\liveOct, 4),
).play;

)

Pdefn(\liveDur, Pseg(Pseq([0.3, 0.08], 1), 12, \exp));
Pdefn(\liveOct, 6);

Pbindef(\live).stop;


//////////////////////  Timeline  /////////////////

(

Pspawner({ |sp|

	sp.par(~secA);
	sp.wait(8);

	sp.par(~secB);
	sp.wait(8);

	sp.suspendAll;
	sp.par(Pfindur(12, Pbind(\dur, Pexprand(0.4, 1.5), \midinote, Pseq([36, 42, 37, 41], inf)) <> ~secA));
	sp.wait(12);

	sp.suspendAll;
}).play(TempoClock(120/60));

)
