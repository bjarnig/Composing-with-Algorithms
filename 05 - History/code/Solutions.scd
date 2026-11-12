////////////////////////////////////////////////////////////////
//
//               Exercises, worked solutions
//
////////////////////////////////////////////////////////////////

One answer each, and not the only answer. Exercises 1 to 5 practise the
techniques in Patterns.scd, and 6 to 11 extend the procedures in History.scd.
Evaluate the SynthDefs first. Cmd+period stops everything.

StageLimiter.activate


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\pluck, {
	|out=0,pan=0,freq=440,amp=0.2,atk=0.005,rel=1.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = SinOsc.ar(freq * [1, 2, 3], 0, [1, 0.3, 0.12]).sum;
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\buzz, {
	|out=0,pan=0,freq=110,amp=0.2,atk=0.01,rel=0.3,lop=3000|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = BLowPass4.ar(Saw.ar(freq * [1, 1.006]).sum * 0.5, lop.clip(20, 18000));
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\hiss, {
	|out=0,pan=0,freq=1000,amp=0.6,atk=0.005,rel=0.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = BPF.ar(WhiteNoise.ar, freq.clip(40, 16000), 0.2);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

SynthDef(\pad, {
	|out=0,pan=0,freq=440,amp=0.15,atk=1.5,sustain=3,rel=3|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sustain, rel, 1, \sin), doneAction:2);
	sig = SinOsc.ar(freq * [1, 1.003, 2], 0, [0.5, 0.5, 0.15]).sum;
	Out.ar(out, Pan2.ar(LPF.ar(sig, 2400) * env, pan, amp));
}).add;

)


///////////////////////////// 1 ////////////////////////////////

/* Pitches from a beta distribution, and durations where each one occurs four
times. */

(

Pbind(
	\instrument, \buzz,
	\midinote, Pbeta(36, 84, 0.3, 0.3),
	\dur, Pdup(4, Prand([0.1, 0.15, 0.25, 0.4], inf)),
	\rel, Pkey(\dur) * 1.5
).play

)


///////////////////////////// 2 ////////////////////////////////

/* Pitches alternate between a uniform choice, an exponential choice and a
predefined phrase. Pswitch picks which one plays next. */

(

Pbind(
	\instrument, \pluck,
	\midinote, Pswitch([
		Pwhite(48, 72, 4),
		Pexprand(40, 96, 4).round,
		Pseq([60, 62, 67, 72])
	], Prand([0, 1, 2], inf)),
	\dur, 0.15
).play

)


///////////////////////////// 3 ////////////////////////////////

/* Two synths at the same time, each with its own rhythm and its own
amplitude curve. */

(

Ppar([
	Pbind(
		\instrument, \buzz,
		\midinote, Pwhite(36, 48),
		\dur, Pseq([0.25, 0.25, 0.5], inf),
		\amp, Pseg(Pseq([0.02, 0.3], inf), 8, \sin)
	),
	Pbind(
		\instrument, \pluck,
		\midinote, Pwhite(72, 84),
		\dur, 1/3,
		\amp, Pseg(Pseq([0.3, 0.01], inf), 6, \exp)
	)
]).play

)


///////////////////////////// 4 ////////////////////////////////

/* Chords of three notes. Each note of the chord has its own amplitude pattern,
so the balance inside the chord keeps changing. */

(

Pbind(
	\instrument, \pluck,
	\midinote, Ptuple([Pwhite(48, 55), Pwhite(60, 67), Pwhite(72, 79)]),
	\amp, Ptuple([Pwhite(0.15, 0.25), Pseq([0.02, 0.08, 0.15], inf), Pexprand(0.01, 0.1)]),
	\dur, 0.5
).play

)


///////////////////////////// 5 ////////////////////////////////

/* A random pitch is repeated between two and six times before a new one is
chosen. */

(

Pbind(
	\instrument, \pluck,
	\midinote, Pdup(Pwhite(2, 6), Pwhite(48, 72)),
	\dur, 0.12
).play

)


///////////////////////////// 6 ////////////////////////////////

/* Guido's table with another text and another choice rule: always the highest
note the vowel allows. Each entry of the table is now a single note. */

(

var table, text;

table = (a: 81, e: 74, i: 76, o: 77, u: 79);

// Algorithmic composition, one vowel per syllable: Al-go-rith-mic com-po-si-tion
text = [\a, \o, \i, \i, \o, \o, \i, \o];

Pbind(
	\instrument, \pluck,
	\midinote, Pdict(table, Pseq(text, 4)),
	\dur, Pseq([0.3, 0.3, 0.3, 0.6, 0.3, 0.3, 0.3, 1.2], inf)
).play

)


/* The same text with a rule of your own: the lowest note for a, e and i, a
random note for o and u. */

(

var table, text;

table = (
	a: 55, e: 57, i: 59,
	o: Prand([60, 69, 77], 1),
	u: Prand([62, 71, 79], 1)
);
text = [\a, \o, \i, \i, \o, \o, \i, \o];

Pbind(
	\instrument, \pluck,
	\midinote, Pdict(table, Pseq(text, 4)),
	\dur, 0.3
).play

)


///////////////////////////// 7 ////////////////////////////////

/* The dice game where some bars have only one possible measure. Bars 1, 8 and
16 get a single measure, so the dice make no difference there. */

(

var tonic, second, fourth, fifth, chords, makeMeasure, bank, dice;

thisThread.randSeed = 1787;

tonic = [0, 2, 4]; second = [1, 3, 5]; fourth = [3, 5, 7]; fifth = [4, 6, 8];
chords = [tonic, fifth, tonic, fourth, tonic, fifth, fifth, tonic,
	fifth, second, fifth, fifth, tonic, fourth, fifth, tonic];

makeMeasure = { |chord|
	var rhythm = [[1, 1, 1], [0.5, 0.5, 1, 1], [2, 1], [1, 0.5, 0.5, 1]].choose;
	var notes = Array.fill(rhythm.size, { chord.choose + 7 });
	Pbind(\instrument, \pluck, \degree, Pseq(notes), \dur, Pseq(rhythm), \amp, 0.2)
};

bank = chords.collect { |chord| Array.fill(11, { makeMeasure.value(chord) }) };

// the same measure in all eleven places of bars 1, 8 and 16
bank[0] = Array.fill(11, bank[0][0]);
bank[7] = Array.fill(11, bank[7][0]);
bank[15] = Array.fill(11, bank[15][0]);

dice = Pwhite(1, 6, 1) + Pwhite(1, 6, 1) - 2;

Pseq(bank.collect { |measures| Pswitch(measures, dice) }, inf).play(TempoClock(2.4))

)


///////////////////////////// 8 ////////////////////////////////

/* The Structures matrix read for a fourth parameter: pan. Evaluate the matrix
block in History.scd first. Each column, read as numbers 1 to 12, moves the
sound from left to right. */

(

Pbind(
	\instrument, \pluck,
	\midinote, Pindex(~pitches, Pseq(~matrix.flat) - 1),
	\dur, Pseq(~matrix.flop.flat) / 8,
	\amp, Pindex(~dynamics, Pdup(12, Pseq(~diagonal)) - 1),
	\pan, Pseq(~matrix.flop.flat).linlin(1, 12, -1, 1)
).play(TempoClock(1.5))

)


///////////////////////////// 9 ////////////////////////////////

/* Generate and test with a fifth rule: no more than three steps in a row in the
same direction. ~tried and ~kept count the proposals, and are posted every 50. */

(

~last = 0; ~leapt = false;
~direction = 0;       // +1 going up, -1 going down
~run = 0;             // how many steps in a row in that direction
~tried = 0; ~kept = 0;

~accept = { |note|
	var step = (note - ~last).abs;
	var direction = (note - ~last).sign;
	var ok = true;
	if(step == 0) { ok = false };
	if(step > 4) { ok = false };
	if(~leapt and: { step != 1 }) { ok = false };
	if((note == 3 and: { ~last == 6 }) or: { note == 6 and: { ~last == 3 } }) { ok = false };
	if(direction == ~direction and: { ~run >= 3 }) { ok = false };    // the new rule

	~tried = ~tried + 1;
	if(ok) {
		if(direction == ~direction) { ~run = ~run + 1 } { ~run = 1 };
		~direction = direction;
		~leapt = step > 2; ~last = note; ~kept = ~kept + 1;
	};
	if(~tried % 50 == 0) { "% proposed, % kept, % rejected".format(~tried, ~kept, ~tried - ~kept).postln };
	ok
};

Pbind(
	\instrument, \pluck,
	\degree, Pwhite(0, 7).select(~accept),
	\dur, 0.2
).play

)


///////////////////////////// 10 ////////////////////////////////

/* Cage charts for timbre: every cell names a SynthDef, and the even cells of
the sound chart are silences. */

(

var timbres, sounds, durs;

thisThread.randSeed = 1951;

timbres = Array.fill(64, { [\pluck, \buzz, \hiss].choose });
sounds = Array.fill(64, { |i| if(i.even) { Rest() } { rrand(36, 96) } });
durs = Array.fill(64, { [0.125, 0.25, 0.375, 0.5, 0.75, 1].choose });

Pbind(
	\instrument, Pindex(timbres, Pwhite(0, 63), inf),
	\midinote, Pindex(sounds, Pwhite(0, 63), inf),
	\dur, Pindex(durs, Pwhite(0, 63), inf),
	\amp, 0.15,
	\rel, Pkey(\dur) * 2
).play

)


///////////////////////////// 11 ////////////////////////////////

/* Loops that realign after exactly two minutes. Every length divides 120
seconds, and 120 is the least common multiple of all of them. */

(

var loops = [[65, 8], [68, 10], [72, 12], [73, 15], [75, 20], [77, 24], [80, 30]];

loops.collect(_[1]).reduce { |a, b| a lcm: b }.postln;      // 120

Ptpar(loops.collect { |pair|
	[0, Pbind(\instrument, \pad, \midinote, pair[0], \dur, pair[1], \sustain, 2, \atk, 0.5, \rel, 2)]
}.flat).play

)
