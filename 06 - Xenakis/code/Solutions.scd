////////////////////////////////////////////////////////////////
//
//                     Xenakis: Solutions
//
////////////////////////////////////////////////////////////////

// One simple answer to each exercise. Evaluate the SynthDefs first.

(
SynthDef(\sine, { |out=0, freq=440, amp=0.2, sus=0.05, pan=0|
	var env = EnvGen.kr(Env.perc(0.01, sus), doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq) * env, pan, amp));
}).add;

SynthDef(\gliss, { |out=0, freq=440, amp=0.1, sus=0.8, slide=12, pan=0|
	var line = Line.kr(freq, freq * slide.midiratio, sus);
	var env = EnvGen.kr(Env.linen(0.01, sus, 0.05), doneAction: 2);
	Out.ar(out, Pan2.ar(LFSaw.ar(line) * env, pan, amp));
}).add;
)


// 1. uniform pitches, then exponential ones, which favour the low end
Pbind(\instrument, \sine, \midinote, Pwhite(60, 72), \dur, 0.15).play

Pbind(\instrument, \sine, \midinote, Pexprand(60, 72), \dur, 0.15).play


// 2. a Gaussian around 60, narrow, medium and wide
Pbind(\instrument, \sine, \midinote, Pgauss(60, 1), \dur, 0.15).play

Pbind(\instrument, \sine, \midinote, Pgauss(60, 6), \dur, 0.15).play

Pbind(\instrument, \sine, \midinote, Pgauss(60, 24), \dur, 0.15).play


// 3. beta at both edges, then a bell
Pbeta(0, 1, 0.3, 0.3).asStream.nextN(1000).histo(40).plot("a = b = 0.3")

Pbeta(0, 1, 3, 3).asStream.nextN(1000).histo(40).plot("a = b = 3")


// 4. exponential durations on a fixed pitch
Pbind(\instrument, \sine, \midinote, 60, \dur, Pexprand(0.05, 1)).play


// 5. a walk with small steps, then with large ones
Pbind(\instrument, \sine, \midinote, Pbrown(48, 72, 1), \dur, 0.1).play

Pbind(\instrument, \sine, \midinote, Pbrown(48, 72, 12), \dur, 0.1).play


// 6. the same walk as a series of random steps
Pbind(\instrument, \sine, \midinote, Pseries(60, Pwhite(-1, 1), inf).fold(48, 72), \dur, 0.1).play


( // 7. three sections of sixteen notes, one distribution each
Pbind(\instrument, \sine,
	\midinote, Pseq([Pwhite(60, 72, 16), Pgauss(66, 3, 16), Pexprand(60, 72, 16)], inf),
	\dur, 0.12).play
)


( // 8. the louder the note, the shorter: 0.2 lasts 0.1 seconds, 0.02 lasts 1
Pbind(\instrument, \sine,
	\amp, Pexprand(0.02, 0.2),
	\dur, 0.02 / Pkey(\amp),
	\midinote, 64).play
)


( // 9. a walk and a bell at the same time
Ppar([
	Pbind(\instrument, \sine, \midinote, Pbrown(48, 72, 2), \dur, 0.15),
	Pbind(\instrument, \sine, \midinote, Pgauss(76, 4), \dur, 0.2)
]).play
)


( // 10. 72 can now return to 60, and 69 is a fifth state
~chain = Dictionary[
	60 -> [[60, 64, 67], [0.2, 0.5, 0.3]],
	64 -> [[60, 67, 69], [0.4, 0.4, 0.2]],
	67 -> [[60, 64, 72], [0.3, 0.3, 0.4]],
	69 -> [[67, 72], [0.5, 0.5]],
	72 -> [[67, 60], [0.5, 0.5]]
];
~note = 60;
Pbind(\instrument, \sine,
	\midinote, Pfunc { ~note = ~chain[~note][0].wchoose(~chain[~note][1]) },
	\dur, 0.15).play
)


// 11. with a mean of 2 there are far fewer empty sections
Ppoisson(2).asStream.nextN(8)    // for example [2, 1, 3, 2, 0, 2, 1, 4]

( // that row, written out: four events a second for each level
Pbind(\instrument, \sine,
	\midinote, Pwhite(60, 72),
	\dur, Pseq([Pn(1/8, 8), Pn(1/4, 4), Pn(1/12, 12), Pn(1/8, 8),
		Rest(1), Pn(1/8, 8), Pn(1/4, 4), Pn(1/16, 16)])
).play
)


( // 12. the deviation of the glissando speeds grows from 0 to 24 over twenty seconds
Pbind(\instrument, \gliss,
	\midinote, Pwhite(50, 80),
	\slide, Pgauss(0, Pseg([0, 24], [20])),
	\sus, 1, \dur, 0.1, \amp, 0.02).play
)


( // 13. a different distribution for frequency, duration and amplitude
Pbind(\instrument, \sine,
	\midinote, Pgauss(64, 5),
	\dur, Pexprand(0.05, 0.5),
	\amp, Pwhite(0.05, 0.2)).play
)


( // 14. a sequence of distributions on pitch, and another on duration
Pbind(\instrument, \sine,
	\midinote, Pseq([Pwhite(40, 80, 8), Pbrown(40, 80, 3, 8), Pexprand(40, 80, 8), Pgauss(60, 10, 8)], inf),
	\dur, Pseq([Pexprand(0.05, 0.5, 5), Pwhite(0.1, 0.2, 5)], inf)).play
)


( // 15. a Markov chain on three durations, by their index
~durs = [0.125, 0.25, 0.5];
~next = [[[0, 1], [0.7, 0.3]], [[0, 2], [0.5, 0.5]], [[0, 1], [0.6, 0.4]]];
~state = 0;
Pbind(\instrument, \sine,
	\dur, Pfunc { ~state = ~next[~state][0].wchoose(~next[~state][1]); ~durs[~state] },
	\midinote, 67).play
)


( // 16. three walks that differ in range and step, sequenced with Pspawner
var low = Pbind(\instrument, \sine, \midinote, Pbrown(36, 48, 1, 16), \dur, 0.2);
var mid = Pbind(\instrument, \sine, \midinote, Pbrown(55, 70, 4, 24), \dur, 0.1);
var high = Pbind(\instrument, \sine, \midinote, Pbrown(80, 96, 12, 32), \dur, 0.05);
Pspawner({ |sp|
	sp.seq(low);
	sp.par(mid);
	sp.wait(1);
	sp.seq(high);
	sp.par(low);
	sp.seq(Ppar([mid, high]));
}).play
)
