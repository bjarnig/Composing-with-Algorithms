////////////////////////////////////////////////////////////////
//
//                     Examples: Patterns Solutions
//
////////////////////////////////////////////////////////////////

// Evaluate the SynthDefs first.

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

)


// 1. two voices phasing
(
~notes = Pseq([60, 62, 67, 69, 67, 62], inf);
Ppar([
	Pbind(\instrument, \pluck, \midinote, ~notes, \dur, 0.2),
	Pbind(\instrument, \pluck, \midinote, ~notes + 12, \dur, 0.205)
]).play
)
