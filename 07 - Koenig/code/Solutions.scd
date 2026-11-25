////////////////////////////////////////////////////////////////
//
//                     Koenig: Solutions
//
////////////////////////////////////////////////////////////////

// One simple answer to each exercise. Evaluate the SynthDefs first.

(
// from the last class: a percussive sine and a sawtooth glissando
SynthDef(\sine, { |out=0, freq=440, amp=0.2, sus=0.05, pan=0|
	var env = EnvGen.kr(Env.perc(0.01, sus), doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq) * env, pan, amp));
}).add;

SynthDef(\gliss, { |out=0, freq=440, amp=0.1, sus=0.8, slide=12, pan=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.linen(0.01, sus, 0.05), doneAction: 2);
	Out.ar(out, Pan2.ar(LFSaw.ar(line) * env, pan, amp));
}).add;

// new in this class, with the same arguments
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

~list = [60, 62, 63, 65, 67, 68, 70];


////////////////////////// Selection Principles ///////////////////////////

// 1. a sequence, then alea
Pbind(\instrument, \pluck, \midinote, Pseq(~list, inf), \dur, 0.15).play

Pbind(\instrument, \pluck, \midinote, Prand(~list, inf), \dur, 0.15).play


// 2. a series: Plazy makes a new order on every round
Pbind(\instrument, \pluck, \midinote, Pn(Plazy { Pshuf(~list) }), \dur, 0.15).play


// 3. ratio: the first two values much more likely
Pbind(\instrument, \bell,
	\midinote, Pwrand(~list, [10, 10, 1, 1, 1, 1, 1].normalizeSum, inf),
	\dur, 0.15).play


// 4. group: each random value two to five times
Pbind(\instrument, \blip, \midinote, Pdup(Pwhite(2, 5), Prand(~list, inf)), \dur, 0.12).play


// 5. a tendency whose limits widen over twenty seconds
Pbind(\instrument, \pluck,
	\midinote, Pwhite(Pseg([60, 36], [20]), Pseg([62, 96], [20])),
	\dur, 0.08).play


// 6. series for pitch, group for duration, ratio for instrument
(
Pbind(\instrument, Pwrand([\pluck, \bell, \blip], [0.6, 0.3, 0.1], inf),
	\midinote, Pn(Plazy { Pshuf(~list) }),
	\dur, Pdup(Pwhite(2, 4), Prand([0.1, 0.2, 0.4], inf))).play
)


////////////////////////// Combined with Earlier Classes ///////////////////////////

// 7. three sections of eight notes, each with its own principle
(
Pseq([
	Pbind(\instrument, \pluck, \midinote, Pseq(~list, 1) ++ Pseq([72]), \dur, 0.15),
	Pbind(\instrument, \pluck, \midinote, Prand(~list, 8), \dur, 0.15),
	Pbind(\instrument, \pluck, \midinote, Pdup(4, Prand(~list, 2)), \dur, 0.15)
]).play
)


// 8. the Streichquartett method
(
~selection = ~list.scramble.keep(4);
~result = ~selection.collect { |n| n ! rrand(1, 5) }.flat.scramble;
~result.postln;
Pbind(\instrument, \bell, \midinote, Pseq(~result), \dur, 0.15).play
)


// 9. a Gaussian whose mean rises from 48 to 84
Pbind(\instrument, \blip, \midinote, Pgauss(Pseg([48, 84], [15]), 3), \dur, 0.08).play


// 10. ratio on duration, a random walk on pitch
(
Pbind(\instrument, \pluck,
	\midinote, Pbrown(48, 72, 2),
	\dur, Pwrand([0.1, 0.2, 0.4], [0.6, 0.3, 0.1], inf)).play
)


// 11. variant 1, variant 2 and variant 1 again
(
~variant = { |seed| Pseed(seed, Pbind(\instrument, \pluck, \midinote, Pwhite(60, 72, 8), \dur, 0.15)) };
Pseq([~variant.(1), ~variant.(2), ~variant.(1)]).play
)


// 12. cycles of three, four and five pitches at once
(
Ppar([
	Pbind(\instrument, \pluck, \midinote, Pseq([48, 51, 55], inf), \dur, 0.2),
	Pbind(\instrument, \bell, \midinote, Pseq([72, 74, 75, 79], inf), \dur, 0.2),
	Pbind(\instrument, \blip, \midinote, Pseq([60, 62, 63, 65, 67], inf), \dur, 0.2)
]).play
)


////////////////////////// Instruments ///////////////////////////

// 13. one phrase on each instrument in turn
(
Pbind(\instrument, Pdup(4, Pseq([\sine, \gliss, \pluck, \bell, \breath, \blip, \drone])),
	\midinote, Pseq([60, 64, 67, 72], inf),
	\sus, 0.3, \slide, 0, \dur, 0.2).play
)


// 14. the instrument chosen by ratio
(
Pbind(\instrument, Pwrand([\pluck, \bell, \drone], [0.8, 0.15, 0.05], inf),
	\midinote, Pwhite(48, 72), \dur, 0.15).play
)


// 15. sustained tones that glide a little
Pbind(\instrument, \drone, \midinote, Pwhite(48, 72), \sus, 3, \slide, Pgauss(0, 2), \dur, 1).play


// 16. Terminus: glissandi that start and end on the five frequencies
(
~terminus = [331, 443, 592, 793, 1062];
Pbind(\instrument, \drone,
	\freq, Prand(~terminus, inf),
	\slide, (Prand(~terminus, inf) / Pkey(\freq)).ratiomidi,
	\sus, 4, \dur, 1, \amp, 0.05).play
)


////////////////////////// Koenig's Programs ///////////////////////////

// 17. the same list at regularity 1, 4 and 7, eight seconds each
(
~regularity = { |value, list|
	case
	{ value < 4 } { Pn(Plazy { Pseq(list.scramble.keep([7, 5, 3][value - 1])) }) }
	{ value == 4 } { Pseq([Pdup(6, Prand(list, 1)), Pshuf(list, 1)], inf) }
	{ value > 4 } {
		var range = [[1, 4], [4, 8], [7, 12]][value - 5];
		Pdup(Pwhite(range[0], range[1]), Prand(list, inf))
	}
};
Pseq([1, 4, 7].collect { |v|
	Pfindur(8, Pbind(\instrument, \pluck, \midinote, ~regularity.(v, ~list), \dur, 0.12))
}).play
)


// 18. list, table and ensemble
(
~table = (48..71).clump(4);
~table.size.postln;   // 6
Pbind(\instrument, \bell,
	\ensemble, Pdup(8, Prand((0..5), inf)),
	\midinote, Pfunc { |event| ~table[event[\ensemble]].choose },
	\dur, 0.15).play
)


// 19. three layers that end together after eight seconds
(
~layer = { |note, length|
	Pbind(\instrument, \drone, \midinote, note, \sus, length, \dur, Pn(length, 1))
};
Ptpar([0, ~layer.(43, 8), 2, ~layer.(50, 6), 6, ~layer.(59, 2)]).play
)


////////////////////////// Transition Tables ///////////////////////////

// 20. zero-order weights derived from a melody
(
~melody = [62, 62, 65, 67, 62, 69, 67, 65, 62, 62];
~values = ~melody.asSet.asArray.sort;
~weights = ~values.collect { |v| ~melody.occurrencesOf(v) }.normalizeSum;
[~values, ~weights].postln;   // [[62, 65, 67, 69], [0.5, 0.2, 0.2, 0.1]]
Pbind(\instrument, \pluck, \midinote, Pwrand(~values, ~weights, inf), \dur, 0.15).play
)


// 21. every note may follow every other, but not itself
(
~notes = [60, 63, 67, 70];
~table = Dictionary[
	60 -> [63, 67, 70], 63 -> [60, 67, 70], 67 -> [60, 63, 70], 70 -> [60, 63, 67]
];
~note = 60;
Pbind(\instrument, \pluck, \midinote, Pfunc { ~note = ~table[~note].choose }, \dur, 0.15).play
)


// 22. a first-order table derived from a melody
(
~melody = [60, 62, 64, 65, 67, 65, 64, 62, 60, 64, 67, 72, 67, 64, 60, 62];   // ends on a pair that occurs earlier
~first = ();
~melody.doAdjacentPairs { |a, b| ~first[a] = (~first[a] ? []).add(b) };
~note = ~melody[0];
Pbind(\instrument, \bell, \midinote, Pfunc { ~note = ~first[~note].choose }, \dur, 0.2).play
)


// 23. the same melody at second order: longer stretches of it return
(
~second = Dictionary.new;
(~melody.size - 2).do { |i|
	var key = ~melody[i..i + 1];
	~second[key] = (~second[key] ? []).add(~melody[i + 2]);
};
~last = ~melody[0..1];
Pbind(\instrument, \bell,
	\midinote, Pfunc { var next = ~second[~last].choose; ~last = [~last[1], next]; next },
	\dur, 0.2).play
)


////////////////////////// Xenakis and Koenig ///////////////////////////

// 24. ten seconds filled twice
(
Pseq([
	Pfindur(10, Pbind(\instrument, \blip, \dur, Pfunc { (1 - 1.0.rand).log.neg / 8 },
		\midinote, Pwhite(60, 84))),
	Pbind(\instrument, \pluck, \dur, Pseq(({ [1, 2, 3].choose } ! 80).normalizeSum * 10),
		\midinote, Pwhite(60, 84))
]).play
)


// 25. a mask copied from the Tendency Mask tool, here the widening preset over twenty seconds
(
Pbind(\instrument, \pluck,
	\midinote, Pwhite(Pseg([59, 56, 50, 42, 30], [5, 5, 5, 5]), Pseg([61, 64, 72, 86, 100], [5, 5, 5, 5])),
	\dur, 1/12).play
)


////////////////////////// Longer exercises ///////////////////////////

// 26. three collections, each read by a different principle
(
~a = [48, 50, 53]; ~b = [60, 63, 65, 67]; ~c = [72, 74, 79, 81, 84];
Pbind(\instrument, \pluck,
	\midinote, Pseq([Pseq(~a, 2), Pshuf(~b, 2), Pdup(3, Prand(~c, 4))], inf),
	\dur, 0.12).play
)


// 27. two layers, the balance moved by a tendency mask from high to low
(
~balance = Pseg([0.9, 0.1], [20]);   // the chance of the high layer playing a note
Ppar([
	Pbind(\instrument, \bell, \midinote, Pwhite(72, 90),
		\amp, Pif(Pwhite(0.0, 1.0) < ~balance, 0.1, 0), \dur, 0.1),
	Pbind(\instrument, \pluck, \midinote, Pwhite(36, 50),
		\amp, Pif(Pwhite(0.0, 1.0) > ~balance, 0.2, 0), \dur, 0.1)
]).play
)


// 28. chords from a group of pitches, each one longer than the last
(
~pitches = [48, 51, 55, 58, 60, 63, 67, 70, 74];
Pbind(\instrument, \drone,
	\midinote, Pfunc { ~pitches.scramble.keep(3) },
	\dur, Pseries(0.5, 0.25, 12),
	\sus, Pkey(\dur) * 1.5, \amp, 0.05).play
)


// 29. durations from a collection, plus an amount that grows
(
Pbind(\instrument, \blip,
	\midinote, Pwhite(60, 72),
	\dur, Prand([1, 2, 3] / 16, inf) + Pseg([0, 0.4], [20]).collect { |x| x.rand }).play
)


// 30. a tendency mask whose limits are random walks
(
Pbind(\instrument, \pluck,
	\low, Pbrown(200, 600, 20),
	\high, Pkey(\low) + Pbrown(50, 800, 40),
	\freq, Pwhite(Pkey(\low), Pkey(\high)),
	\dur, Pwhite(Pbrown(0.05, 0.1, 0.01), Pbrown(0.1, 0.4, 0.02))).play
)


// 31. chords that gain a note every two chords
(
Pbind(\instrument, \bell,
	\size, Pdup(2, Pseries(1, 1, 7)),
	\midinote, Pfunc { |event| ([48, 55, 60, 64, 67, 71, 74].scramble.keep(event[\size])) },
	\dur, 0.8, \sus, 1.5, \amp, 0.05).play
)


// 32. limits that start wide and narrow towards 64 over thirty seconds
(
Pbind(\instrument, \sine,
	\midinote, Pwhite(Pseg([30, 63], [30]), Pseg([100, 65], [30])),
	\dur, 0.08).play
)
