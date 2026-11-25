////////////////////////////////////////////////////////////////
//
//                     Koenig and Selection
//
////////////////////////////////////////////////////////////////

The class in slide order: seven instruments with the same arguments, the
Streichquartett method, Terminus, Project One with its regularity values and
protected harmony, List, Table and Ensemble from Project Two, the six selection
principles, layers, tendency masks and variants, Xenakis beside Koenig, and
transition tables. Evaluate the SynthDefs first, then any block on its own.

StageLimiter.activate


////////////////////////// SynthDefs ///////////////////////////

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


////////////////////////// Instruments ///////////////////////////

~instruments = [\sine, \gliss, \pluck, \bell, \breath, \blip, \drone];

(
Pbind(\instrument, Pdup(6, Pseq(~instruments)),
	\midinote, Pseq([60, 63, 67, 70, 67, 63], inf),
	\sus, 0.4, \slide, 0, \dur, 0.2).play
)


////////////////////////// Essay ///////////////////////////

(
~material = { |instrument, notes, durs|
	Pbind(\instrument, instrument, \midinote, Pseq(notes), \dur, Pseq(durs))
};
)

(
~parts = [
	[\sine, [72, 79, 74], [0.1, 0.1, 0.4]], [\breath, [48, 50], [1, 2]],
	[\blip, [60, 61, 62, 63], [0.05, 0.05, 0.05, 0.3]], [\drone, [43], [3]]
];
)

(
Pseq(8.collect { |i|
	var part = ~parts.wrapAt(i);
	var factor = [0.25, 0.5, 1, 2, 4].choose;   // contraction or expansion
	Pstretch(factor, ~material.(*part))
}).play
)


////////////////////////// Streichquartett 1959 ///////////////////////////

(
~supply = [60, 62, 63, 65, 67, 68, 70];                    // a b c d e f g
~selection = ~supply.scramble.keep(4).sort;                 // random selection
~groups = { rrand(1, 5) } ! 4;                              // the group list
~repetitions = ~selection.collect { |n, i| n ! ~groups[i] }.flat;
~result = ~repetitions.scramble;                            // random order
)

[~selection, ~groups, ~result].do(_.postln);

Pbind(\instrument, \pluck, \midinote, Pseq(~result), \dur, 0.15).play


////////////////////////// Terminus ///////////////////////////

~terminus = [331, 443, 592, 793, 1062];

(
~glissandi = Pbind(\instrument, \drone,
	\freq, Prand(~terminus, inf),
	\target, Prand(~terminus, inf),
	\slide, (Pkey(\target) / Pkey(\freq)).ratiomidi,
	\sus, 4, \dur, 0.8, \amp, 0.05);
)

~glissandi.play;

Pbindf(~glissandi, \freq, Pkey(\freq) * 0.25, \target, Pkey(\target) * 0.25).play;  // transposed

Pbindf(~glissandi, \instrument, \blip, \sus, 0.1, \dur, 0.06).play;   // chopped


////////////////////////// Regularity ///////////////////////////

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
)

(
~list = [60, 62, 63, 65, 67, 68, 70];
Pbind(\instrument, \pluck, \midinote, ~regularity.(1, ~list), \dur, 0.12).play;
)

Pbind(\instrument, \pluck, \midinote, ~regularity.(7, ~list), \dur, 0.12).play;


////////////////////////// Harmony ///////////////////////////

(
~group = [0, 1, 5];                                          // a minor second, a major third
~row = [0, 3, 6, 9].collect { |t| ~group + t }.flat % 12;   // four transpositions
~row.postln;               // [0, 1, 5, 3, 4, 8, 6, 7, 11, 9, 10, 2]
~row.asSet.size.postln;    // 12
)

(
Pbind(\instrument, \bell, \note, Pseq(~row, 2), \octave, Prand([4, 5, 6], inf),
	\dur, 0.15).play
)


////////////////////////// Project One ///////////////////////////

(
~table = [
	[1, 3, 6, 4, 2, 7, 5],    // instrument
	[6, 3, 7, 5, 4, 1, 2],    // entry delay
	[2, 7, 6, 5, 1, 3, 4]     // register
];
)

(
Pseq(7.collect { |section|
	Pfindur(4, Pbind(
		\instrument, ~regularity.(~table[0][section], [\sine, \pluck, \bell, \breath, \blip]),
		\dur, ~regularity.(~table[1][section], [1, 2, 3, 5, 8, 13] / 32),
		\octave, ~regularity.(~table[2][section], [3, 4, 5, 6, 7]),
		\note, Pseq(~row, inf),
		\sus, 0.3))
}).play
)


////////////////////////// List, Table, Ensemble ///////////////////////////

(
~list = (48..83);                     // the available values
~table = ~list.clump(6);              // six groups of six
)

(
Pbind(\instrument, \bell,
	\ensemble, Pdup(8, Pn(Plazy { Pseq((0..5).scramble) })),     // the ensemble
	\midinote, Pfunc { |event| ~table[event[\ensemble]].choose },  // the score
	\dur, 0.15, \sus, 0.6).play
)


////////////////////////// Hierarchy ///////////////////////////

~ranges = (pluck: [40, 60], bell: [72, 96], breath: [55, 75]);

(
Pbind(\instrument, Prand([\pluck, \bell, \breath], inf),
	\midinote, Pfunc { |event| var range = ~ranges[event[\instrument]]; rrand(range[0], range[1]) },
	\dur, 0.15).play
)


////////////////////////// Selection Principles ///////////////////////////

~pitches = [43, 48, 45, 50, 52, 47, 39];

(
~principles = [
	Pseq(~pitches),                                        // sequence
	Prand(~pitches, 7),                                    // alea
	Pshuf(~pitches),                                       // series
	Pwrand(~pitches, [8, 4, 2, 1, 1, 1, 1].normalizeSum, 7), // ratio
	Pfin(7, Pdup(Pwhite(2, 4), Prand(~pitches, inf))),     // group
	Pwhite(Pseries(39, 1, 7), Pseries(43, 2, 7))           // tendency
];
)

(
Pbind(\instrument, \pluck,
	\midinote, Pseq(~principles) + 12,
	\dur, 0.15, \sus, 0.8).play
)


////////////////////////// Sequence ///////////////////////////

(
Pbind(\instrument, \blip,
	\midinote, Pseq([43, 48, 45, 50, 52], inf) + 12,
	\dur, Pseq([0.25, 0.125, 0.125], inf),
	\amp, Pseq([0.2, 0.05, 0.1, 0.05], inf)).play
)


////////////////////////// Alea ///////////////////////////

(
~pitches = [43, 48, 45, 43, 48, 43, 47, 39, 41];
~rhythms = [1, 1/4, 1/5, 1/4, 1/8, 1/2];
)

(
Pbind(\instrument, \pluck, \midinote, Prand(~pitches, inf) + 12,
	\dur, Prand(~rhythms, inf)).play;
)

(
// collect to transform a list: midi notes to frequencies, an octave up
~frequencies = ~pitches.collect { |item| item.midicps } * 2;
Pbind(\instrument, \sine, \freq, Prand(~frequencies, inf), \dur, Prand(~rhythms, inf)).play;
)

(
// block a range of values
Pbind(\instrument, \blip,
	\degree, Pwhite(0.1, 1.0).reject { |item| (item > 0.4) && (item < 0.8) } * 10,
	\dur, 0.1).play
)


////////////////////////// Alea ///////////////////////////

(
Pbind(\instrument, \bell,
	\note, Prand([1, 3, 4], inf),
	\octave, Prand([3, 4], inf),
	\dur, Pwhite(0.08, 0.18).round(0.02)).play
)


////////////////////////// Series ///////////////////////////

(
Pbind(\instrument, \pluck,
	\midinote, Pn(Plazy { Pseq(~pitches.scramble) }) + 12,
	\dur, 0.2).play;
)

(
Pbind(\instrument, \sine,
	\freq, Pn(Plazy { Pseq(~frequencies.scramble) }),
	\dur, 0.1).play;
)

(
// only a direct repeat is refused
Pbind(\instrument, \blip, \midinote, Pxrand(~pitches, inf) + 24, \dur, 0.1).play
)


////////////////////////// Ratio ///////////////////////////

~weights = [2, 0.2, 2, 0.3, 0.5, 0.5, 1, 0.5, 1].normalizeSum;

(
Pbind(\instrument, \bell,
	\midinote, Pwrand(~pitches, ~weights, inf) + 24,
	\dur, 0.2).play;
)

(
// ratio on the instrument
Pbind(\instrument, Pwrand([\pluck, \bell, \drone], [0.7, 0.25, 0.05], inf),
	\midinote, Prand(~pitches, inf) + 24, \dur, 0.15).play
)


////////////////////////// Group ///////////////////////////

~repeats = 4;

(
Pbind(\instrument, \blip,
	\midinote, Pdup(~repeats, Prand(~pitches, inf)) + 24,
	\dur, 0.15).play;
)

(
Pbind(\instrument, \pluck,
	\midinote, Pdup(Pwhite(1, 6), Prand(~pitches, inf)) + 24,
	\dur, 0.1).play
)


////////////////////////// Tendency ///////////////////////////

(
Pbind(\instrument, \blip,
	\midinote, Pwhite(
		Pseg(Pseq([60, 80, 10, 100], inf), Pseq([5, 5, 5, 5], inf)),
		Pseg(Pseq([80, 100, 50, 120], inf), Pseq([5, 5, 5, 5], inf))),
	\dur, 0.1).play
)


////////////////////////// Layers ///////////////////////////

(
~layer = { |note, length|
	Pbind(\instrument, \drone, \midinote, note, \sus, length, \dur, Pn(length, 1))
};
)

(
// sounds begin simultaneously
Ppar([~layer.(48, 8), ~layer.(55, 5), ~layer.(64, 3)]).play;
)

(
// sounds stop simultaneously
Ptpar([0, ~layer.(48, 8), 3, ~layer.(55, 5), 5, ~layer.(64, 3)]).play;
)

(
// symmetric superposition
Ptpar([0, ~layer.(48, 8), 1.5, ~layer.(55, 5), 2.5, ~layer.(64, 3)]).play;
)


////////////////////////// Layers ///////////////////////////

(
Pbind(
	\instrument, Pseq([\pluck, \bell, \blip], inf),
	\midinote, Pseq([60, 63, 67, 70, 72], inf),
	\dur, Pseq([1, 1, 2, 1, 3, 1, 2] / 8, inf),
	\amp, Pseq([0.2, 0.05, 0.1, 0.05], inf),
	\sus, 0.5).play
)


////////////////////////// Tendency Mask ///////////////////////////

(
~plotPattern = { |pattern, count = 500|
	pattern.asStream.nextN(count).plot(discrete: true)
};
)

~plotPattern.(Pwhite(Pseries(0.0, 0.05), Pseries(100.0, -0.05)), 1000);

(
Pbind(\instrument, \sine,
	\midinote, Pwhite(Pseg([36, 70, 60], [10, 10]), Pseg([96, 72, 62], [10, 10])),
	\dur, 0.05, \amp, 0.1).play
)


////////////////////////// Tendency Mask ///////////////////////////

(
~mask = { |n, a1, a2, z1, z2|
	Pwhite(Pseries(a1, (z1 - a1) / n, n), Pseries(a2, (z2 - a2) / n, n))
};
)

~plotPattern.(~mask.(40, 0.45, 0.6, 0.05, 0.95), 40);

(
Pbind(\instrument, \pluck,
	\midinote, Pseq([~mask.(60, 60, 62, 36, 90), ~mask.(30, 36, 90, 80, 84)]),
	\dur, 0.08).play
)


////////////////////////// Tendency Mask ///////////////////////////

(
Pbind(\instrument, \pluck,
	\midinote, Pwhite(Pseg([36, 44, 54, 60, 63], [5, 5, 5, 5]),
		Pseg([100, 92, 80, 70, 65], [5, 5, 5, 5])).round,
	\dur, 1/12, \sus, 0.4).play
)


////////////////////////// Variants ///////////////////////////

(
~model = { |seed|
	Pseed(seed, Pbind(\instrument, \pluck,
		\midinote, Pbrown(48, 72, 3, 24),
		\dur, Prand([1, 2, 3] / 12, inf)))
};
)

Pseq([~model.(1), ~model.(2), ~model.(1)]).play;

(
// four structures, and the performer's choice of one of three variants for each
Pseq(4.collect { |structure| Prand(3.collect { |v| ~model.(structure * 3 + v) }, 1) }).play
)


////////////////////////// Filling Time ///////////////////////////

(
// Xenakis: six onsets a second on average
Pfindur(10, Pbind(\instrument, \pluck,
	\dur, Pfunc { (1 - 1.0.rand).log.neg / 6 },
	\midinote, Pwhite(48, 84))).play;
)

(
// Koenig: N points in a length, the pitch inside a tendency mask of N parts
~n = 60;
~delays = ({ [1, 2, 3].choose } ! ~n).normalizeSum * 10;
~delays.sum.postln;   // 10.0
Pbind(\instrument, \pluck,
	\dur, Pseq(~delays),
	\midinote, Pwhite(Pseries(48, 12 / ~n, ~n), Pseries(84, -12 / ~n, ~n))).play
)


////////////////////////// Memory ///////////////////////////

(
~density = 4;
Pn(Plazy {
	~density = (~density * exprand(0.5, 2.0)).clip(0.11, 50);
	~density.round(0.01).postln;
	Pfindur(3, Pbind(\instrument, \blip,
		\dur, Pfunc { (1 - 1.0.rand).log.neg / ~density },
		\midinote, Pwhite(60, 96)))
}, 6).play
)


////////////////////////// Zero Order ///////////////////////////

(
// specified: 60 with a probability of 0.6, 67 with 0.4
Pbind(\instrument, \pluck, \midinote, Pwrand([60, 67], [0.6, 0.4], inf), \dur, 0.15).play;
)

(
// derived from an existing object: how often each value occurs in it
~object = [60, 60, 60, 67, 67, 60, 67, 60, 60, 67];
~values = ~object.asSet.asArray.sort;
~weights = ~values.collect { |v| ~object.occurrencesOf(v) }.normalizeSum;
[~values, ~weights].postln;   // [[60, 67], [0.6, 0.4]]
)

Pbind(\instrument, \pluck, \midinote, Pwrand(~values, ~weights, inf), \dur, 0.15).play


////////////////////////// Stepwise Sum ///////////////////////////

(
~choose = { |values, weights|
	var r = 1.0.rand, sum = 0;
	values.detect { |v, i| sum = sum + weights[i]; r < sum }
};
)

~choose.([\a, \b, \c], [0.25, 0.5, 0.25]);

(
// about 5000 of 10000 are b
({ ~choose.([\a, \b, \c], [0.25, 0.5, 0.25]) } ! 10000).occurrencesOf(\b);
)

[\a, \b, \c].wchoose([0.25, 0.5, 0.25]);


////////////////////////// Conditional Probabilities ///////////////////////////

(
~table = (
	c: [[\g, \f, \e], [0.5, 0.3, 0.2]],
	g: [[\c], [1]],
	f: [[\g, \e], [0.5, 0.5]],
	e: [[\c, \f, \g], [0.2, 0.4, 0.4]]
);
~notes = (c: 48, e: 52, f: 53, g: 55);
~state = \c;
)

(
Pbind(\instrument, \bell,
	\midinote, Pfunc { ~state = ~table[~state][0].wchoose(~table[~state][1]); ~notes[~state] },
	\dur, 0.2).play
)


////////////////////////// Deriving a Table ///////////////////////////

~melody = [60, 62, 64, 60, 60, 62, 64, 60, 64, 65, 67, 64, 65, 67];

(
~first = ();
~melody.doAdjacentPairs { |a, b| ~first[a] = (~first[a] ? []).add(b) };
~first.postln;
)

(
~note = ~melody[0];
Pbind(\instrument, \pluck, \midinote, Pfunc { ~note = ~first[~note].choose }, \dur, 0.2).play
)


////////////////////////// Second Order ///////////////////////////

(
~second = Dictionary.new;
(~melody.size - 2).do { |i|
	var key = ~melody[i..i + 1];
	~second[key] = (~second[key] ? []).add(~melody[i + 2]);
};
)

(
~last = ~melody[0..1];
Pbind(\instrument, \pluck,
	\midinote, Pfunc { var next = ~second[~last].choose; ~last = [~last[1], next]; next },
	\dur, 0.2).play
)


////////////////////////// Transition Tables ///////////////////////////

(
~durs = [0.1, 0.2, 0.4];
~next = [[0, 0, 1], [0, 2], [0]];   // what may follow each duration, by index
~d = 0;
)

(
Pbind(\instrument, \blip,
	\midinote, Pfunc { ~note = ~first[~note].choose } + 12,
	\dur, Pfunc { ~d = ~next[~d].choose; ~durs[~d] }).play
)

