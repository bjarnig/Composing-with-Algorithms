////////////////////////////////////////////////////////////////
//
//                     Examples: Solutions
//
////////////////////////////////////////////////////////////////

// One simple answer to each exercise. Evaluate the SynthDefs first.

(
// the seven instruments from class 07, all with freq, amp, sus, pan and slide
SynthDef(\sine, { |out=0, freq=440, amp=0.2, sus=0.05, pan=0|
	var env = EnvGen.kr(Env.perc(0.01, sus), doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq) * env, pan, amp));
}).add;

SynthDef(\gliss, { |out=0, freq=440, amp=0.1, sus=0.8, slide=12, pan=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.linen(0.01, sus, 0.05), doneAction: 2);
	Out.ar(out, Pan2.ar(LFSaw.ar(line) * env, pan, amp));
}).add;

SynthDef(\pluck, { |out=0, freq=440, amp=0.2, sus=1, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var sig = Pluck.ar(WhiteNoise.ar, Impulse.kr(0), 0.05, line.reciprocal, sus, 0.3);
	var env = EnvGen.kr(Env.linen(0, sus, 0.05), doneAction: 2);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\bell, { |out=0, freq=440, amp=0.1, sus=1, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.perc(0.005, sus, curve: -6), doneAction: 2);
	var mod = SinOsc.ar(line * 1.4) * line * 3 * env;
	Out.ar(out, Pan2.ar(SinOsc.ar(line + mod) * env, pan, amp));
}).add;

SynthDef(\breath, { |out=0, freq=440, amp=0.2, sus=0.5, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.sine(sus), doneAction: 2);
	var sig = BPF.ar(WhiteNoise.ar, line, 30 / line) * 8;   // a band 30 Hz wide
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\blip, { |out=0, freq=440, amp=0.1, sus=0.2, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.perc(0.002, sus), doneAction: 2);
	var cutoff = XLine.kr((freq * 12).min(16000), freq, sus);
	var sig = RLPF.ar(Pulse.ar(line, 0.3), cutoff, 0.2);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\drone, { |out=0, freq=440, amp=0.1, sus=2, pan=0, slide=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.linen(sus * 0.3, sus * 0.4, sus * 0.3, 1, \sine), doneAction: 2);
	var sig = SinOsc.ar(line * [1, 1.003]).sum * 0.5;
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;


// for Pmono: one synth that keeps sounding and glides to each new frequency
SynthDef(\mono, { |out=0, freq=200, amp=0.1, pan=0, glide=0.1, gate=1|
	var env = EnvGen.kr(Env.asr(0.05, 1, 0.5), gate, doneAction: 2);
	var sig = LPF.ar(VarSaw.ar(Lag.kr(freq, glide), 0, 0.3), 3000);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;
)


////////////////////////// Events and Pitch ///////////////////////////

// 1. one event in hertz, then one as a MIDI note with a fraction
(instrument: \bell, freq: 1234.5, sus: 2).play

(instrument: \bell, midinote: 60.5, sus: 2).play


// 2. ratios to 110 Hz, in order
Pbind(\instrument, \bell, \freq, 110 * Pseq([1, 1.13, 1.47, 2.71], inf), \dur, 0.3).play


// 3. a high, thin cloud
Pbind(\instrument, \sine, \freq, Pexprand(50, 5000), \sus, 0.02, \dur, 0.02).play


// 4. a second of silence after every eight events
Pbind(\instrument, \pluck, \freq, Pexprand(100, 2000), \dur, Pseq([Pn(0.12, 8), Rest(1)], inf)).play


////////////////////////// Lists and Numbers ///////////////////////////

// 5. never the same frequency twice in a row
Pbind(\instrument, \blip, \freq, Pxrand([131, 457, 1203, 2711], inf), \dur, 0.15).play


// 6. mostly very short, sometimes two seconds
Pbind(\instrument, \pluck, \freq, Pexprand(200, 2000),
	\dur, Pwrand([0.04, 0.08, 2], [0.6, 0.35, 0.05], inf)).play


// 7. each instrument once in every round, in a random order
Pbind(\instrument, Pshuf([\sine, \pluck, \bell, \breath, \blip], inf), \freq, 600, \dur, 0.3).play


// 8. a slow walk, then a fast one
Pbind(\instrument, \sine, \freq, Pbrown(200, 2000, 50), \dur, 0.1).play

Pbind(\instrument, \sine, \freq, Pbrown(200, 2000, 500), \dur, 0.1).play


// 9. forty durations, each 0.9 of the last
Pbind(\instrument, \blip, \freq, 1500, \dur, Pgeom(0.5, 0.9, 40)).play
Pgeom(0.5, 0.9, 40).asStream.all.sum.postln;   // 4.926..., just under five seconds in all


// 10. a series in steps of a semitone and a half
Pbind(\instrument, \pluck, \midinote, Pseries(30, 1.5, 40), \dur, 0.1).play
Pseries(30, 1.5, 40).asStream.all.last.postln;   // 88.5


////////////////////////// Shapes and Relations ///////////////////////////

// 11. faster and faster over ten seconds
Pbind(\instrument, \pluck, \freq, Pexprand(200, 2000), \dur, Pseg([0.5, 0.01], [10], \exp)).play


// 12. high sounds are short
Pbind(\instrument, \bell, \freq, Pexprand(100, 4000), \sus, 200 / Pkey(\freq), \dur, 0.15).play


// 13. one event in four is a rest
Pbind(\instrument, \blip, \freq, Pexprand(300, 3000),
	\dur, Pfunc { if(0.25.coin) { Rest(0.1) } { 0.1 } }).play


// 14. groups of one to six
Pbind(\instrument, \pluck, \freq, Pdup(Pwhite(1, 6), Pexprand(100, 3000)), \dur, 0.08).play


////////////////////////// Layers, Form and Pmono ///////////////////////////

// 15. a low and a high layer
(
Ppar([
	Pbind(\instrument, \drone, \freq, 48, \sus, 4, \dur, 3),
	Pbind(\instrument, \blip, \freq, Pexprand(3000, 7000), \dur, 0.15, \amp, 0.05)
]).play
)


// 16. one pattern three times, each later and on another instrument
(
~p = Pbind(\instrument, \pluck, \freq, Pexprand(200, 2000, 30), \dur, 0.1);
Ptpar([0, ~p, 1, Pbindf(~p, \instrument, \bell), 2, Pbindf(~p, \instrument, \blip)]).play
)


// 17. a cloud, a silence, glissandi
(
Pspawner({ |sp|
	sp.seq(Pfindur(4, Pbind(\instrument, \sine, \freq, Pexprand(1000, 8000), \sus, 0.02, \dur, 0.01)));
	sp.wait(2);
	sp.seq(Pfindur(4, Pbind(\instrument, \gliss, \freq, Pexprand(200, 2000),
		\slide, Pwhite(-12, 12), \sus, 1, \dur, 0.2, \amp, 0.03)));
}).play
)


// 18. a texture that is changed while it plays
Pdef(\band, Pbind(\instrument, \breath, \freq, Pexprand(100, 400), \dur, 0.1)).play

Pdef(\band, Pbind(\instrument, \breath, \freq, Pexprand(2000, 5000), \dur, 0.05))

Pdef(\band).stop


// 19. one synth gliding
Pmono(\mono, \freq, Pexprand(80, 1500), \glide, 0.3, \dur, 0.4).play


// 20. two voices phasing
(
~notes = Pseq([60, 61.5, 66, 59, 70.5, 64], inf);
Ppar([
	Pbind(\instrument, \pluck, \midinote, ~notes, \dur, 0.2),
	Pbind(\instrument, \pluck, \midinote, ~notes + 12, \dur, 0.205)
]).play
)


////////////////////////// Longer exercises ///////////////////////////

// 21. A B A: sparse Poisson gaps, a dense Gaussian cloud, and A again with another instrument
(
~a = { |instrument| Pfindur(6, Pbind(\instrument, instrument, \freq, Pexprand(100, 1000),
	\dur, Ppoisson(4).collect { |n| n + 1 / 8 })) };
~b = Pfindur(6, Pbind(\instrument, \sine, \midinote, Pgauss(84, 4), \sus, 0.03, \dur, 0.02));
Pspawner({ |sp|
	sp.seq(~a.(\pluck));
	sp.seq(~b);
	sp.seq(~a.(\bell));
}).play
)


// 22. a tendency mask whose limits are random walks
(
Pbind(\instrument, \pluck,
	\low, Pbrown(100, 600, 15),
	\high, Pkey(\low) * Pbrown(1.2, 8.0, 0.2),
	\freq, Pexprand(Pkey(\low), Pkey(\high)),
	\dur, 0.06).play
)


// 23. three voices, three distributions
(
Ppar([
	Pbind(\instrument, \pluck, \freq, Pexprand(100, 3000), \dur, 0.15),
	Pbind(\instrument, \blip, \midinote, Pgauss(90, 3), \dur, 0.2, \amp, 0.05),
	Pbind(\instrument, \drone, \freq, Pbeta(40, 200, 0.3, 0.3), \sus, 3, \dur, 2, \amp, 0.05)
]).play
)


// 24. two voices that hold their values at different rates
(
Ppar([
	Pbind(\instrument, \pluck, \freq, Pclutch(Pexprand(100, 1000), Pseq([1, 0, 0], inf)), \dur, 0.1),
	Pbind(\instrument, \blip, \freq, Pclutch(Pexprand(2000, 6000), Pseq([1, 0, 0, 0, 0], inf)),
		\dur, 0.1, \amp, 0.05)
]).play
)


// 25. each state of the machine has its own distribution
(
Pbind(\instrument, \blip,
	\freq, Pfsm([
		[0],
		Pwhite(200, 2000, 6), [1, 2],
		Pgauss(1000, 50, 6), [0, 2],
		Pexprand(50, 8000, 6), [0, 1]
	], inf),
	\dur, 0.1).play
)


// 26. a drone in three layers, each a Pmono moving slowly
(
~layer = { |lo, hi, length|
	Pmono(\mono, \freq, Pseg(Pexprand(lo, hi), length / 4, \exp), \glide, 1,
		\dur, 0.25, \amp, 0.05)
};
Pspawner({ |sp|
	sp.par(Pfindur(36, ~layer.(40, 80, 8)));
	sp.wait(6);
	sp.par(Pfindur(30, ~layer.(200, 400, 6)));
	sp.wait(6);
	sp.par(Pfindur(24, ~layer.(1500, 3000, 4)));
}).play
)
