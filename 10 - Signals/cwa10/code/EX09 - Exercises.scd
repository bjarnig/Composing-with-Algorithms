////////////////////////////////////////////////////////////////
//
//                       CWA09 - Exercises
//
////////////////////////////////////////////////////////////////


/* 1. Create a sound movement that starts with a sine wave and
ends with a noise. */

(

SynthDef(\ex1, {|out=0, freq=800|
	var sine, noise, sig;
	sine = SinOsc.ar(freq) * EnvGen.kr(Env([0, 1, 0], [4, 4]));
	noise = PinkNoise.ar(0.5) * EnvGen.kr(Env([0, 0, 1, 0], [2, 4, 8]), doneAction:2);
	sig = (sine + noise) ! 2;
	Out.ar(out, sig);
}).add;

)

Synth(\ex1)




/* 2. Create a cluster of sine wave (10 or more) going from low
frequencies to high ones. */

(

SynthDef(\ex2, {|out=0, mul=0.01|
	var highs, lows, sig;
	lows = Mix.new(Array.fill(20, {SinOsc.ar(rrand(100, 400), mul:mul)}));
	highs = Mix.new(Array.fill(20, {SinOsc.ar(rrand(4000, 6000), mul:mul)}));
	lows = lows * EnvGen.kr(Env([0, 1, 0], [5, 10]));
	highs = highs * EnvGen.kr(Env([0, 0, 1, 0], [5, 10, 5]));
	sig = (lows + highs) * EnvGen.kr(Env([0, 1, 0], [0.1, 20, 0.1]), doneAction:2);
	Out.ar(out, sig ! 2);
}).add;

)

Synth(\ex2)




/* 3. Create a slow sound movement lasting 30 seconds or more
using at least 20 sine waves. */

(

SynthDef(\ex3, {|out=0, mul=0.005|
	var sig, sines;
	sines = Mix.new(Array.fill(50, {
	SinOsc.ar(rrand(100, 4000), mul:mul) *
	EnvGen.kr(Env([0, 1, 0], [5 + 25.rand, 25.rand]))}));
	sig = sines * EnvGen.kr(Env([0, 1, 0], [0.1, 50, 0.1]), doneAction:2);
	Out.ar(out, sig ! 2);
}).add;

)

Synth(\ex3)




/* 4. Combine different moments of noise types where they can be
perceived at the same time during some moments but also separate
in others. */

(

SynthDef(\brown, {|out=0,mul=0.1,sus=2|
	var sig = BrownNoise.ar(mul)
	* EnvGen.kr(Env([0, 1, 0], [0.1, sus, 0.1]), doneAction:2);
	Out.ar(out, sig ! 2);
}).add;

SynthDef(\gray, {|out=0,mul=0.1,sus=2|
	var sig = GrayNoise.ar(mul)
	* EnvGen.kr(Env([0, 1, 0], [0.1, sus, 0.1]), doneAction:2);
	Out.ar(out, sig ! 2);
}).add;

SynthDef(\dust, {|out=0,mul=0.1,sus=2|
	var sig = Dust.ar(50, mul)
	* EnvGen.kr(Env([0, 1, 0], [0.1, sus, 0.1]), doneAction:2);
	Out.ar(out, sig ! 2);
}).add;

)

(

Ppar(Array.fill(4, {
	Pbind(
	\instrument, Pstutter(4, Pseq([\brown, \gray, \dust], inf)),
	\sus, Pwhite(0.1, 4),
	\dur, Prand([0.1, 0.2, 0.5], inf)
)})).play

)




/* 5. Create a FM sound using two carrier waves each one being
modulated by a different modulator. */

(

SynthDef(\fm5, {|out=0,sus=10|
	var sig, carr1, carr2, mod1, mod2;
	mod1 = SinOsc.ar(124);
	mod2 = SinOsc.ar(456);
	carr1= SinOsc.ar(500 * mod1);
	carr2= SinOsc.ar(1000 * mod2);
	sig = carr1 + carr2
	* EnvGen.kr(Env([0, 1, 0], [0.1, sus, 0.1]), 1, 0.2, doneAction:2);
	Out.ar(out, sig ! 2);
}).add;

)

Synth(\fm5)

