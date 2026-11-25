////////////////////////////////////////////////////////////////
//
//                     Examples: Patterns
//
////////////////////////////////////////////////////////////////

A recap of the pattern basics and a collection of pattern techniques, in slide
order. Every example can be played with any of the seven instruments. Evaluate
the SynthDefs first, then any block on its own.

StageLimiter.activate


////////////////////////// SynthDefs ///////////////////////////

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


////////////////////////// Recap ///////////////////////////

Pbind(\instrument, \sine, \freq, Pseq([100, 800, 300], inf), \dur, 0.2).play;

Pbind(\instrument, \sine, \freq, Pwhite(100, 800), \dur, 0.2).play;

Pbind(\instrument, \sine, \freq, Penv([100, 800, 60, 8000], [1, 3, 2]), \dur, 0.1).play;

(
Pbind(\instrument, \sine, \dur, 0.2,
	\freq, Pseq([Pseq([100, 800, 400]), Pwhite(100, 800, 4), Penv([100, 800, 60], [1, 2])], inf)).play;
)

(
Ppar([
	Pbind(\instrument, \sine, \freq, Pseq([100, 800, 400], inf), \dur, 0.2),
	Pbind(\instrument, \sine, \freq, Pwhite(1000, 4000).round(100), \amp, 0.05, \dur, 0.1)
]).play;
)


////////////////////////// Recap ///////////////////////////

(
// the duration reads the frequency
Pbind(\instrument, \sine, \freq, Pseq([100, 200, 400], inf), \dur, Pkey(\freq) * 0.001).play;
)

(
// change the range and evaluate again, without stopping
Pdef(\something, Pbind(\instrument, \sine, \freq, Pwhite(100, 8000), \dur, 0.2)).play;
)

(
// chords
Pbind(\instrument, \sine, \freq, Pseq([[100, 200, 800], [400, 600, 1000]], inf), \dur, 0.3).play;
)

(
// only eight notes: the amplitude pattern ends first
Pbind(\instrument, \sine, \freq, Pwhite(100, 250, 14), \amp, Pexprand(0.2, 1.0, 8), \dur, 0.1).play;
)


////////////////////////// Reading a Collection ///////////////////////////

(
~shape = Env([0, 0.5, 0.8, 0.2, 1.0], 2.5 ! 4);
~collection = Array.series(24, 48, 0.5);
)

(
Pbind(\instrument, \pluck,
	\position, Pn(Penv(~shape.levels, ~shape.times)),
	\midinote, Pfunc { |event| ~collection[((~collection.size - 1) * event[\position]).round] },
	\dur, 0.1).play
)


////////////////////////// Reading a Collection ///////////////////////////

(
~high = Env([0.26, 0.51, 0.9], [0.5, 0.5]);
~low = Env([0.25, 0.49, 0.01], [0.5, 0.5]);
~collection = Array.series(16, 40, 2);
)

(
Pbind(\instrument, \blip,
	\high, Pn(Penv(~high.levels, ~high.times * 2)),
	\low, Pn(Penv(~low.levels, ~low.times * 2)),
	\midinote, Pfunc { |event|
		~collection[((~collection.size - 1) * rrand(event[\low], event[\high])).round] },
	\dur, Pn(Pshuf([1/16, 1/8, 1/32]))
).play(TempoClock(90/60))
)


////////////////////////// Chords ///////////////////////////

(
Pbind(\instrument, \bell,
	\midinote, Pseq([[60, 64, 68], [53, 56, 59]], inf),
	\dur, Pseq([0.5, 0.25], inf)).play;
)

(
Pbind(\instrument, \pluck,
	\midinote, Pwhite([60, 70], [80, 90], inf),
	\dur, Pwrand([1, 0.25], [0.6, 0.4], inf)).play;
)

(
// chords that grow from one note to six
Pbind(\instrument, \drone,
	\size, Pseries(1, 1, 6),
	\midinote, Pfunc { |event| [48, 55, 62, 64, 69, 76].keep(event[\size]) },
	\dur, 1.5, \sus, 2).play
)


////////////////////////// Series and Layers ///////////////////////////

(
~up = Pbind(\instrument, \blip, \midinote, Pseries(48, 1, 48), \dur, 0.1);
~down = Pbind(\instrument, \blip, \midinote, Pseries(96, -1, 48), \dur, 0.1);
)

Pseq([~up, ~down]).play;

Ptpar([0.0, ~up, 0.0, ~down, 0.5, ~up, 0.5, ~down, 1.0, ~up, 1.0, ~down]).play;

(
// a walk inside a series: each step is random
Pbind(\instrument, \pluck, \midinote, Pseries(60, Pwhite(-5, 5), inf).fold(36, 96),
	\dur, 0.1).play;
)


////////////////////////// Canon ///////////////////////////

(
~voice = Pbind(\instrument, \pluck,
	\midinote, Pseq([60, 62, 63, 67, 65, 63, 62, 58, 60]),
	\dur, Pseq([2, 1, 1, 2, 1, 1, 2, 2, 4] / 8));
)

(
Ptpar([
	0, ~voice,
	1, Pbindf(~voice, \midinote, Pkey(\midinote) + 7, \instrument, \bell),
	2, Pbindf(~voice, \midinote, Pkey(\midinote) - 12, \instrument, \blip)
]).play
)


////////////////////////// Phasing ///////////////////////////

~notes = Pseq([60, 63, 65, 63, 67, 65], inf);

(
Ppar([
	Pbind(\instrument, \pluck, \midinote, ~notes, \dur, 0.2, \pan, -0.7),
	Pbind(\instrument, \blip, \midinote, ~notes + 12, \dur, 0.21, \pan, 0.7)
]).play
)


////////////////////////// Polymeter ///////////////////////////

(
Ppar([
	Pbind(\instrument, \pluck, \midinote, Pseq([48, 55, 51], inf), \dur, 0.15,
		\amp, Pseq([0.3, 0.1, 0.1], inf)),
	Pbind(\instrument, \blip, \midinote, Pseq([72, 70, 67, 65], inf), \dur, 0.15,
		\amp, Pseq([0.15, 0.05, 0.05, 0.05], inf)),
	Pbind(\instrument, \bell, \midinote, Pseq([84, 86, 91, 89, 87], inf), \dur, 0.15,
		\amp, Pseq([0.1, 0.02, 0.02, 0.02, 0.02], inf))
]).play
)


////////////////////////// Accelerando ///////////////////////////

(
// 40 notes, each 7 percent shorter than the last
Pbind(\instrument, \blip, \midinote, 72, \dur, Pgeom(0.5, 0.93, 40)).play;
)

(
// slowing down and speeding up again over twelve seconds
Pbind(\instrument, \pluck, \midinote, Pwhite(60, 72),
	\dur, Pseg([0.03, 0.3, 0.03], [6, 6], \exp)).play
)


////////////////////////// Ratchets ///////////////////////////

(
Pbind(\instrument, \blip,
	\dur, PdurStutter(Prand([1, 1, 2, 3, 4], inf), 0.4),
	\midinote, Pwhite(60, 72)).play;
)

(
// simpler: the same note repeated a random number of times at a fixed speed
Pbind(\instrument, \pluck, \midinote, Pdup(Prand([1, 2, 4], inf), Pwhite(60, 72)),
	\dur, 0.1).play
)


////////////////////////// Sample and Hold ///////////////////////////

(
// a new value on every fifth event
Pbind(\instrument, \bell,
	\freq, Pclutch(Pwhite(95.123, 551.1234), Pseq([1, 0, 0, 0, 0], inf)),
	\dur, 0.1).play;
)

(
// each value held for one beat
Pbind(\instrument, \blip, \freq, Pstep(Pwhite(200, 400), 1, inf), \dur, 0.05).play;
)

(
// interpolated between values instead of held
Pbind(\instrument, \sine, \freq, Pseg(Pwhite(100, 500), Pseq([1, 5], inf), \linear),
	\dur, 0.1).play
)


////////////////////////// Interlacing ///////////////////////////

(
Pbind(\instrument, \pluck,
	\midinote, Ppatlace([Pseq([48, 50, 52], inf), Pwhite(72, 84), Pbrown(60, 66, 1)], inf),
	\dur, 0.12).play;
)

(
Pbind(\instrument, \blip,
	\midinote, Place([60, [63, 65, 67], 70, [72, 74]], inf),
	\dur, 0.12).play
)


////////////////////////// Walking a List ///////////////////////////

~scale = [48, 50, 51, 53, 55, 56, 58, 60, 62, 63, 65, 67];

(
// steps of -1, 1 or 2, turning back at the ends
Pbind(\instrument, \pluck,
	\midinote, Pwalk(~scale, Prand([-1, 1, 2], inf), Pseq([1, -1], inf), 0),
	\dur, 0.12).play;
)

(
// Pindex reads a list with an index from any pattern
Pbind(\instrument, \bell, \midinote, Pindex(~scale, Pbrown(0, 11, 2), inf) + 12,
	\dur, 0.15).play
)


////////////////////////// Switching ///////////////////////////

(
Pbind(\instrument, \blip,
	\midinote, Pswitch1([
		Pseq([60, 62, 63, 65], inf),
		Pseries(84, -1, inf).wrap(72, 84),
		Pwhite(36, 48)
	], Pseq([0, 0, 1, 0, 2, 1], inf)),
	\dur, 0.1).play
)


////////////////////////// Filtering ///////////////////////////

(
// only frequencies below 800
Pbind(\instrument, \sine, \freq, Pwhite(100, 900).select { |x| x < 800 }, \dur, 0.1).play;
)

(
// only notes in a scale, by rejecting the rest
Pbind(\instrument, \pluck,
	\midinote, Pwhite(48, 72).reject { |n| [1, 3, 6, 8, 10].includes(n % 12) },
	\dur, 0.12).play;
)

(
// every value rounded to the nearest quarter tone
Pbind(\instrument, \bell, \midinote, Pwhite(60.0, 72.0).collect { |n| n.round(0.5) },
	\dur, 0.15).play
)


////////////////////////// Time Limits ///////////////////////////

(
// play for four seconds
Pfindur(4, Pbind(\instrument, \blip, \midinote, Pwhite(60, 72), \dur, 0.1)).play;
)

(
// stop at the end of the beat in which the total reaches one beat
Psync(Pbind(\instrument, \blip, \freq, Pseq([500, 600, 700], inf), \dur, 0.03), 1, 1).play;
)

(
// stop after a total of 5000 Hz has been played
Pbind(\instrument, \sine, \freq, Pconst(5000, Pseq([500, 600, 700], inf)), \dur, 0.1).play;
)

(
// Ptime counts the time since the start
Pbind(\instrument, \pluck, \degree, Pif(Ptime(inf) < 1.0, Pwhite(-4, 11, inf)), \dur, 0.1).play;
)


////////////////////////// Regenerating ///////////////////////////

(
// a new four-note phrase every time, played three times before the next
Pbind(\instrument, \pluck,
	\midinote, Pn(Plazy { Pseq(Pwhite(48, 72).asStream.nextN(4), 3) }),
	\dur, 0.12).play;
)

(
// three values, shuffled and repeated four times, then three new values
Pbind(\instrument, \blip,
	\midinote, Pn(Plazy { Pshuf(Pwhite(40, 60).asStream.nextN(3), 4) }) + 12,
	\dur, 0.1).play
)


////////////////////////// Chaining ///////////////////////////

~rhythm = Pbind(\dur, Pseq([3, 1, 2, 2] / 8, inf));

Pchain(Pbind(\instrument, \pluck, \midinote, Pwhite(48, 60)), ~rhythm).play;

Pchain(Pbind(\instrument, \bell, \midinote, Pseq([72, 79, 77], inf)), ~rhythm).play;

Pbindf(~rhythm, \instrument, \breath, \freq, Pexprand(300, 3000)).play


////////////////////////// Changing While Playing ///////////////////////////

Pbindef(\live, \instrument, \pluck, \midinote, Pwhite(60, 72), \dur, 0.15).play;

Pbindef(\live, \instrument, \bell);

Pbindef(\live, \midinote, Pseq([60, 63, 67, 70], inf));

Pbindef(\live, \dur, Prand([0.1, 0.2], inf), \slide, Pwhite(-2, 2));

Pbindef(\live).stop;


////////////////////////// Form ///////////////////////////

(
Pspawner({ |sp|
	sp.par(Pbind(\instrument, \drone, \midinote, [36, 43], \sus, 24, \dur, Pn(24, 1), \amp, 0.05));
	sp.seq(Pfindur(6, Pbind(\instrument, \pluck,                         // group
		\midinote, Pdup(Pwhite(2, 5), Prand([60, 63, 67, 70], inf)), \dur, 0.1)));
	sp.par(Pfindur(12, Pbind(\instrument, \breath, \freq, Pexprand(400, 4000), \dur, 0.3)));
	sp.seq(Pfindur(6, Pbind(\instrument, \bell,                          // tendency
		\midinote, Pwhite(Pseg([60, 36], [6]), Pseg([62, 96], [6])), \dur, 0.08)));
	sp.seq(Pfindur(6, Pbind(\instrument, \blip,                          // series
		\midinote, Pn(Plazy { Pseq([72, 74, 75, 79, 80].scramble) }), \dur, 0.12)));
	sp.seq(Pbind(\instrument, \gliss, \midinote, [48, 55, 63], \slide, -12, \sus, 4,
		\dur, Pn(4, 1)));
}).play
)

