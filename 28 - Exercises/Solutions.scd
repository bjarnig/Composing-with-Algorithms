////////////////////////////////////////////////////////////////
//
//             Composing with Algorithms - Solutions
//
////////////////////////////////////////////////////////////////


( // SynthDef used by the pattern exercises

SynthDef(\sine, {|freq=440, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.3), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

)


/* Exercise 1: */

( // Solution 1

Pbind(
	\instrument, \sine,
	\freq, Pexprand(80, 5000),
	\dur, 0.08
).play

)


/* Exercise 2: */

( // Solution 2

Pbind(
	\instrument, \sine,
	\freq, Pgauss(800, 300).abs + 40,  // keep it positive/audible
	\dur, 0.12
).play

)


/* Exercise 3: */

( // Solution 3

// Pbeta(lo, hi, prob1, prob2): shape params < 1 give a U-shape.
Pbind(
	\instrument, \sine,
	\freq, Pexprand(200, 3000),
	\amp, Pbeta(0.02, 0.4, 0.3, 0.3),
	\dur, 0.12
).play

)


/* Exercise 4: */

( // Solution 4

Pbind(
	\instrument, \sine,
	\freq, Pexprand(200, 3000),
	\dur, Pwrand([0.05, 0.1, 0.25, 0.5], [0.5, 0.3, 0.15, 0.05], inf)
).play

)


/* Exercise 5: */

( // Solution 5

Pbind(
	\instrument, \sine,
	\freq, Pbrown(100, 3000, 150),
	\dur, Pbrown(0.05, 0.4, 0.05)
).play

)


/* Exercise 6: */

( // Solution 6

Pbind(
	\instrument, \sine,
	\freq, Pfsm([
		#[0],
		Pexprand(60, 120, 1),    #[0, 1],        // low   -> stay or rise
		Pexprand(400, 1200, 1),  #[0, 1, 2],     // mid   -> anywhere
		Pexprand(3000, 7000, 1), #[1, 2]         // high  -> mid or stay
	], inf),
	\dur, 0.12
).play

)


/* Exercise 7: */

( // Solution 7

SynthDef(\ping, {|freq=400, rq=0.02, amp=0.5, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.001, 0.6), doneAction:2);
	sig = Resonz.ar(Impulse.ar(0), freq, rq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \ping, \freq, Pexprand(200, 4000), \dur, Pwhite(0.1, 0.4)).play;

)


/* Exercise 8: */

( // Solution 8

SynthDef(\bell, {|freq=400, amp=0.3, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.001, 2.0), doneAction:2);
	sig = DynKlank.ar(`[
		freq * [1, 2.7, 4.1, 6.8, 9.2],   // inharmonic partials
		[1, 0.6, 0.4, 0.3, 0.2],
		[1.5, 1.1, 0.8, 0.6, 0.4]         // ring times
	], Impulse.ar(0));
	Out.ar(0, Pan2.ar(sig * env * amp, pan));
}).add;

Pbind(\instrument, \bell, \freq, Pexprand(150, 1000), \dur, Pwhite(0.4, 1.2)).play;

)


/* Exercise 9: */

( // Solution 9

SynthDef(\wind, {|freq=1000, rq=0.1, amp=0.4, atk=0.3, rel=0.6, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.linen(atk, 0.1, rel), doneAction:2);
	sig = BPF.ar(WhiteNoise.ar, freq, rq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \wind,
	\freq, Pexprand(400, 5000),
	\rq, Pwhite(0.05, 0.3),
	\dur, Pwhite(0.3, 0.8)
).play;

)


/* Exercise 10:  */

( // Solution 10

SynthDef(\fm, {|freq=200, ratio=2, index=3, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.4), doneAction:2);
	sig = PMOsc.ar(freq, freq * ratio, index) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \fm,
	\freq, Pexprand(80, 600),
	\ratio, Prand([1.5, 2, 3.5, 5], inf),
	\index, Pwhite(1, 10),
	\dur, 0.2
).play;

)


/* Exercise 11: */

( // Solution 11

SynthDef(\grain, {|freq=1000, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.002, 0.03), doneAction:2);  // very short grain
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \grain,
	\freq, Pexprand(300, 6000),
	\pan, Pwhite(-1, 1),
	\dur, Pexprand(0.01, 0.06)
).play;

)


/* Exercise 12: */

( // Solution 12

x = {
	var sig = StandardL.ar(
		LFNoise1.kr(0.2).exprange(400, 4000),   // swept rate
		LFNoise1.kr(0.1).range(0.9, 1.6)        // swept chaos parameter
	);
	LeakDC.ar(sig) * 0.2 ! 2;
}.play;

)
x.free;


/* Exercise 13: */

( // Solution 13

x = {
	var amt = SinOsc.kr(0.2).range(0.1, 1.0);   // moving fold depth
	var sig = SinOsc.ar(120);
	sig = sig.fold2(amt);
	sig * 0.2 ! 2;
}.play;

)
x.free;


/* Exercise 14: */

( // Solution 14

x = {
	var fb = LFNoise1.kr(0.3).range(0, 4);  // feedback amount wanders
	SinOscFB.ar(120, fb) * 0.2 ! 2;
}.play;

)
x.free;


/* Exercise 15: */

( // Solution 15

SynthDef(\comb, {|delay=0.005, amp=0.3, pan=0|
	var sig, exc, env;
	env = EnvGen.kr(Env.perc(0.001, 1.0), doneAction:2);
	exc = WhiteNoise.ar * EnvGen.kr(Env.perc(0.001, 0.01));  // short burst
	sig = CombN.ar(exc, 0.05, delay, 1.5);                   // delay tunes pitch
	Out.ar(0, Pan2.ar(sig * env * amp, pan));
}).add;

Pbind(\instrument, \comb,
	\delay, Pexprand(0.001, 0.01),   // 1/delay = resonant frequency
	\dur, Pwhite(0.2, 0.5)
).play;

)


/* Exercise 16: */

( // Solution 16

x = {|minf=40, maxf=400|
	Gendy1.ar(
		ampdist: 1, durdist: 1,
		adparam: LFNoise1.kr(0.2).range(0.1, 1),
		ddparam: LFNoise1.kr(0.2).range(0.1, 1),
		minfreq: minf, maxfreq: maxf,
		ampscale: 0.5, durscale: 0.5,
		initCPs: 12, knum: 12
	) * 0.2 ! 2;
}.play;

)
x.set(\maxf, 1500);
x.free;


/* Exercise 17:  */

( // Solution 17 - load the buffer first

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

)

( // then granulate

x = {
	var trig = Dust.ar(40);
	var pos  = LFNoise1.kr(0.3).range(0, BufDur.kr(b));
	TGrains.ar(2, trig, b,
		rate: TRand.kr(0.5, 2.0, trig),
		centerPos: pos,
		dur: 0.1,
		pan: TRand.kr(-1, 1, trig),
		amp: 0.4);
}.play;

)
x.free;


/* Exercise 18:  */

( // Solution 18

SynthDef(\metal, {|freq=200, amp=0.2, pan=0|
	var sig, env, ratios;
	env = EnvGen.kr(Env.perc(0.01, 1.5), doneAction:2);
	ratios = [1, 1.41, 2.3, 3.7, 5.1, 6.9];   // inharmonic
	sig = Klang.ar(`[freq * ratios, nil, nil]) * 0.1;
	Out.ar(0, Pan2.ar(sig * env * amp, pan));
}).add;

Pbind(\instrument, \metal, \freq, Pexprand(100, 800), \dur, Pwhite(0.5, 1.5)).play;

)


/* Exercise 19: */

( // Solution 19

x = {
	var trig = Impulse.kr(8);
	var freq = Demand.kr(trig, 0, Dseq([200, 320, 500, 800, 1300], inf));
	Saw.ar(freq, 0.15) ! 2;
}.play;

)
x.free;


/* Exercise 20: */

( // Solution 20

x = {
	var trig = Impulse.kr(10);
	var freq = Demand.kr(trig, 0, Dbrown(120, 1800, 120));
	Pulse.ar(freq, 0.5, 0.15) ! 2;
}.play;

)
x.free;


/* Exercise 21: */

( // Solution 21

Ndef(\drone).fadeTime = 1;
Ndef(\drone, {|cutoff=800|
	RLPF.ar(Saw.ar(60, 0.2), cutoff, 0.2) ! 2;
}).play;

)
Ndef(\drone).set(\cutoff, 3000);  // change live
Ndef(\drone).stop;


/* Exercise 22: */

( // Solution 22

Ndef(\src, { WhiteNoise.ar(0.3) });
Ndef(\fx, {|cf=2| BPF.ar(Ndef(\src).ar, LFNoise1.kr(cf).exprange(300, 5000), 0.1) * 6 }).play;

)
Ndef(\fx).set(\cf, 6);
Ndef(\fx).clear; Ndef(\src).clear;


/* Exercise 23: */

( // Solution 23

Ndef(\a)[0] = { Saw.ar([80, 81], 0.2) };
Ndef(\a)[1] = \filter -> {|in| (in * 5).tanh * 0.5 };            // distortion
Ndef(\a)[2] = \filter -> {|in| in + FreeVerb.ar(in, 0.6, 0.9) }; // reverb
Ndef(\a).play;

)
Ndef(\a)[1] = nil;  // remove the distortion while running
Ndef(\a).clear;


/* Exercise 24: */

( // Solution 24

t = TempoClock(120/60);
~low  = Pbind(\instrument, \sine, \freq, Pbrown(60, 120, 10), \dur, 0.4, \amp, 0.2);
~high = Pbind(\instrument, \sine, \freq, Pexprand(3000, 7000), \dur, 0.08, \amp, 0.1);

Routine({
	var a, b;
	a = ~low.play(t);
	8.wait;
	b = ~high.play(t);
	8.wait;
	a.stop; b.stop;
	"done".postln;
}).play(t);

)


/* Exercise 25: */

( // Solution 25

~lo  = Pbind(\instrument, \sine, \freq, Pexprand(50, 120),    \dur, 0.5,  \amp, 0.2);
~mid = Pbind(\instrument, \sine, \freq, Pexprand(400, 1200),  \dur, 0.15, \amp, 0.12);
~hi  = Pbind(\instrument, \sine, \freq, Pexprand(3000, 8000), \dur, Pexprand(0.02, 0.1), \amp, 0.08);

Pspawner({|sp|
	sp.par(~lo);
	sp.wait(8);
	sp.par(~mid);
	sp.wait(8);
	sp.par(~hi);
	sp.wait(8);
	sp.suspendAll;
}).play;

)
