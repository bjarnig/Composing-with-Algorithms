////////////////////////////////////////////////////////////////
//
//                     Examples: Patterns
//
////////////////////////////////////////////////////////////////

The class in slide order: the instruments, a recap, the pattern vocabulary
from events and pitch without a scale to Pmono and state machines, then the
techniques and the textures. Every example can be played with any of the seven
instruments. Evaluate the SynthDefs first, then any block on its own.

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


////////////////////////// Instruments ///////////////////////////

~instruments = [\sine, \gliss, \pluck, \bell, \breath, \blip, \drone];

(
Pbind(\instrument, Pdup(5, Pseq(~instruments)),
	\freq, Pexprand(80, 3000),
	\sus, 0.3, \slide, Pwhite(-3.0, 3.0), \dur, 0.2).play
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


////////////////////////// Events ///////////////////////////

(instrument: \bell, freq: 1234.5, sus: 2).play;

Pbind(\instrument, \bell, \freq, 1234.5, \sus, 2, \dur, 1).play;

Pbind(\instrument, \bell, \freq, Pexprand(200, 4000), \sus, 2, \dur, 1).play;


////////////////////////// Pitch without a Scale ///////////////////////////

(
// hertz
Pbind(\instrument, \pluck, \freq, Pseq([97, 389, 1543, 211], inf), \dur, 0.25).play;
)

(
// a fraction of a semitone
Pbind(\instrument, \pluck, \midinote, 60 + Pwhite(0.0, 1.0), \dur, 0.15).play;
)

(
// ratios to a fundamental of 110 Hz
Pbind(\instrument, \bell, \freq, 110 * Pseq([1, 1.13, 1.47, 2.71, 3.9], inf), \dur, 0.3).play;
)

(
// an inharmonic chord
Pbind(\instrument, \bell, \freq, [110, 155.6, 297.1, 523.4], \dur, 2).play;
)


////////////////////////// Silence ///////////////////////////

(
// a rest of one second after every eight sounds
Pbind(\instrument, \blip, \freq, Pexprand(300, 3000),
	\dur, Pseq([Pn(0.1, 8), Rest(1)], inf)).play;
)

(
// one event in three is silent
Pbind(\instrument, \pluck, \freq, Pexprand(100, 1000), \dur, 0.15,
	\type, Pwrand([\note, \rest], [2, 1].normalizeSum, inf)).play;
)


////////////////////////// Lists ///////////////////////////

~list = [97, 211, 389, 1543, 2903];

Pbind(\instrument, \blip, \freq, Pseq(~list, inf), \dur, 0.15).play;

Pbind(\instrument, \blip, \freq, Prand(~list, inf), \dur, 0.15).play;

Pbind(\instrument, \blip, \freq, Pxrand(~list, inf), \dur, 0.15).play;

Pbind(\instrument, \blip, \freq, Pwrand(~list, [8, 4, 2, 1, 1].normalizeSum, inf), \dur, 0.15).play;

Pbind(\instrument, \blip, \freq, Pshuf(~list, inf), \dur, 0.15).play;


////////////////////////// Lists ///////////////////////////

Pbind(\instrument, \pluck, \freq, 400, \dur, Prand([0.05, 0.05, 0.1, 0.8], inf)).play;

Pbind(\instrument, Pxrand([\pluck, \bell, \breath, \blip], inf), \freq, 700, \dur, 0.2).play;

(
// each inner pattern is played to its end before the next
Pbind(\instrument, \blip,
	\freq, Pseq([Pseq([300, 310, 320]), Pexprand(1000, 4000, 4), Pn(80, 2)], inf),
	\dur, 0.12).play;
)


////////////////////////// Numbers ///////////////////////////

Pbind(\instrument, \sine, \freq, Pwhite(200, 2000), \dur, 0.1).play;

Pbind(\instrument, \sine, \freq, Pexprand(200, 2000), \dur, 0.1).play;

Pbind(\instrument, \sine, \freq, Pbrown(200, 2000, 60), \dur, 0.1).play;

Pbind(\instrument, \sine, \freq, Pseries(200, 37, 50), \dur, 0.1).play;

Pbind(\instrument, \sine, \freq, Pgeom(200, 1.05, 50), \dur, 0.1).play;


////////////////////////// Numbers ///////////////////////////

(
Pbind(\instrument, \pluck,
	\freq, Pbrown(100, 1500, 40),
	\dur, Pbrown(0.03, 0.3, 0.02),
	\amp, Pbrown(0.02, 0.3, 0.03),
	\pan, Pbrown(-1.0, 1.0, 0.2)).play;
)

Pbind(\instrument, \blip, \freq, Pgbrown(100, 4000, 0.1), \dur, Pgbrown(0.02, 0.5, 0.1)).play;


////////////////////////// Distributions ///////////////////////////

Pbind(\instrument, \pluck, \midinote, Pgauss(60, 8), \dur, 0.08).play;

Pbind(\instrument, \pluck, \midinote, Pcauchy(60, 2).clip(20, 110), \dur, 0.08).play;

(
// mostly very quiet or loud
Pbind(\instrument, \blip, \freq, 900, \amp, Pbeta(0.01, 0.4, 0.3, 0.3), \dur, 0.08).play;
)


////////////////////////// Shapes in Time ///////////////////////////

(
// the register from 30 Hz to 4000 Hz and back over twenty seconds
Pbind(\instrument, \sine, \freq, Pseg([30, 4000, 30], [10, 10], \exp), \dur, 0.05).play;
)

(
// from fifty events a second to two
Pbind(\instrument, \pluck, \freq, Pexprand(200, 3000), \dur, Pseg([0.02, 0.5], [15], \exp)).play;
)

(
// a crescendo of noise
Pbind(\instrument, \breath, \freq, Pexprand(500, 5000), \dur, 0.05, \amp, Pseg([0, 0.5], [12])).play;
)


////////////////////////// Relations ///////////////////////////

Pbind(\instrument, \bell, \freq, Pexprand(80, 5000), \sus, 300 / Pkey(\freq), \dur, 0.15).play;

(
Pbind(\instrument, \pluck, \freq, Pexprand(100, 4000),
	\pan, Pkey(\freq).collect { |f| f.explin(100, 4000, -1, 1) }, \dur, 0.1).play;
)

(
Pbind(\instrument, \blip, \freq, Pexprand(200, 2000),
	\dur, Pfunc { if(0.25.coin) { Rest(0.2) } { 0.1 } }).play;
)


////////////////////////// Repetition ///////////////////////////

(
// a gesture of five sounds, four times
Pbind(\instrument, \blip, \freq, Pn(Pgeom(3000, 0.7, 5), 4), \dur, 0.08).play;
)

(
// each value twice
Pbind(\instrument, \pluck, \freq, Pdup(2, Pexprand(100, 2000)), \dur, 0.1).play;
)

(
// groups of one to eight
Pbind(\instrument, \pluck, \freq, Pdup(Pwhite(1, 8), Pexprand(100, 2000)), \dur, 0.06).play;
)


////////////////////////// Layers ///////////////////////////

(
~a = Pbind(\instrument, \drone, \freq, 55, \sus, 3, \dur, Pn(3, 1));
~b = Pbind(\instrument, \blip, \freq, Pexprand(2000, 6000, 20), \dur, 0.1);
~c = Pbind(\instrument, \breath, \freq, Pexprand(300, 900, 8), \dur, 0.5);
)

Pseq([~a, ~b, ~c]).play;

Ppar([~a, ~b, ~c]).play;

Ptpar([0, ~a, 1, ~b, 2.5, ~c]).play;


////////////////////////// Layers ///////////////////////////

~cloud = Pbind(\instrument, \sine, \freq, Pexprand(800, 1200), \sus, 0.03, \dur, 0.03);

(
Ppar([
	~cloud,
	Pbindf(~cloud, \freq, Pkey(\freq) * 0.25, \instrument, \pluck),
	Pbindf(~cloud, \freq, Pkey(\freq) * 4.1, \amp, 0.02)
]).play
)


////////////////////////// Form and Change ///////////////////////////

(
Pspawner({ |sp|
	sp.seq(Pfindur(4, Pbind(\instrument, \sine,
		\freq, Pexprand(1000, 8000), \sus, 0.02, \dur, 0.01)));
	sp.wait(2);
	sp.par(Pbind(\instrument, \drone, \freq, 41.2, \sus, 6, \dur, Pn(6, 1)));
	sp.seq(Pfindur(6, Pbind(\instrument, \gliss, \freq, Pexprand(200, 2000),
		\slide, Pgauss(0, 12), \sus, 2, \dur, 0.25, \amp, 0.03)));
}).play
)


////////////////////////// Form and Change ///////////////////////////

Pdef(\noise, Pbind(\instrument, \breath, \freq, Pexprand(200, 800), \dur, 0.1)).play;

(
// evaluate this while it plays: the change comes at the next event
Pdef(\noise, Pbind(\instrument, \breath, \freq, Pexprand(3000, 6000), \dur, 0.03));
)

Pdef(\noise).stop;


////////////////////////// Pmono ///////////////////////////

(
SynthDef(\mono, { |out=0, freq=200, amp=0.1, pan=0, glide=0.1, gate=1|
	var env = EnvGen.kr(Env.asr(0.05, 1, 0.5), gate, doneAction: 2);
	var sig = LPF.ar(VarSaw.ar(Lag.kr(freq, glide), 0, 0.3), 3000);
	Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;
)

Pmono(\mono, \freq, Pexprand(60, 2000), \dur, 0.2).play;

Pmono(\mono, \freq, Pbrown(100, 400, 20), \glide, 0.02, \dur, 0.05).play;

Pmono(\mono, \freq, Pseq([100, 3000], inf), \glide, Pwhite(0.05, 2.0), \dur, 2).play;


////////////////////////// States and Conditions ///////////////////////////

(
Pbind(\instrument, \pluck,
	\freq, Pfsm([
		[0],
		Pexprand(50, 120, 4), [0, 0, 1],      // low: stays, or rises
		Pexprand(300, 900, 3), [0, 1, 2],
		Pexprand(2000, 6000, 6), [1]          // high: always back to the middle
	], inf),
	\dur, 0.1).play;
)

(
Pbind(\instrument, \blip,
	\freq, Pif(Pwhite(0.0, 1.0) < 0.8, Pexprand(100, 300), Pexprand(4000, 8000)),
	\dur, 0.08).play;
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
~collection = Array.series(16, 40, 2.5);
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
	\freq, Pseq([[200, 283, 317], [151, 389, 1210]], inf),
	\dur, Pseq([0.5, 0.25], inf)).play;
)

(
Pbind(\instrument, \pluck,
	\midinote, Pwhite([60, 70.5], [80, 90.5], inf),
	\dur, Pwrand([1, 0.25], [0.6, 0.4], inf)).play;
)

(
// chords that grow from one note to six
Pbind(\instrument, \drone,
	\size, Pseries(1, 1, 6),
	\freq, Pfunc { |event| [55, 87.3, 131, 208.6, 333, 529].keep(event[\size]) },
	\dur, 1.5, \sus, 2).play
)


////////////////////////// Series and Layers ///////////////////////////

(
~up = Pbind(\instrument, \blip, \freq, Pseries(100, 37, 48), \dur, 0.1);
~down = Pbind(\instrument, \blip, \freq, Pseries(1876, -37, 48), \dur, 0.1);
)

Pseq([~up, ~down]).play;

Ptpar([0.0, ~up, 0.0, ~down, 0.5, ~up, 0.5, ~down, 1.0, ~up, 1.0, ~down]).play;

(
// a walk inside a series: each step is random
Pbind(\instrument, \pluck, \midinote, Pseries(60, Pwhite(-5.0, 5.0), inf).fold(36, 96),
	\dur, 0.1).play;
)


////////////////////////// Canon ///////////////////////////

(
~voice = Pbind(\instrument, \pluck,
	\freq, Pseq([311, 347, 529, 467, 389, 803, 212, 236, 331]),
	\dur, Pseq([2, 1, 1, 2, 1, 1, 2, 2, 4] / 8));
)

(
Ptpar([
	0, ~voice,
	1, Pbindf(~voice, \freq, Pkey(\freq) * 1.41, \instrument, \bell),
	2, Pbindf(~voice, \freq, Pkey(\freq) * 0.37, \instrument, \blip)
]).play
)


////////////////////////// Phasing ///////////////////////////

~notes = Pseq([60, 61.5, 66, 59, 70.5, 64], inf);

(
Ppar([
	Pbind(\instrument, \pluck, \midinote, ~notes, \dur, 0.2, \pan, -0.7),
	Pbind(\instrument, \blip, \midinote, ~notes + 12, \dur, 0.21, \pan, 0.7)
]).play
)


////////////////////////// Polymeter ///////////////////////////

(
Ppar([
	Pbind(\instrument, \pluck, \freq, Pseq([61, 97, 73], inf), \dur, 0.15,
		\amp, Pseq([0.3, 0.1, 0.1], inf)),
	Pbind(\instrument, \blip, \freq, Pseq([1013, 877, 1411, 653], inf), \dur, 0.15,
		\amp, Pseq([0.15, 0.05, 0.05, 0.05], inf)),
	Pbind(\instrument, \bell, \freq, Pseq([3011, 3593, 2707, 4219, 3301], inf), \dur, 0.15,
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
	\freq, Ppatlace([Pseq([90, 97, 104], inf), Pexprand(2000, 4000), Pbrown(300, 400, 10)], inf),
	\dur, 0.12).play;
)

(
Pbind(\instrument, \blip,
	\freq, Place([200, [310, 470, 730], 1100, [1700, 2600]], inf),
	\dur, 0.12).play
)


////////////////////////// Walking a List ///////////////////////////

~list = [110, 127, 151, 178, 209, 247, 290, 341, 403, 475, 559, 659];

(
// steps of -1, 1 or 2, turning back at the ends
Pbind(\instrument, \pluck,
	\freq, Pwalk(~list, Prand([-1, 1, 2], inf), Pseq([1, -1], inf), 0),
	\dur, 0.12).play;
)

(
// Pindex reads a list with an index from any pattern
Pbind(\instrument, \bell, \freq, Pindex(~list, Pbrown(0, 11, 2), inf) * 2,
	\dur, 0.15).play
)


////////////////////////// Switching ///////////////////////////

(
Pbind(\instrument, \blip,
	\freq, Pswitch1([
		Pseq([300, 330, 371, 406], inf),
		Pseries(4000, -150, inf).wrap(1000, 4000),
		Pexprand(50, 120)
	], Pseq([0, 0, 1, 0, 2, 1], inf)),
	\dur, 0.1).play
)


////////////////////////// Filtering ///////////////////////////

(
// only frequencies below 800
Pbind(\instrument, \sine, \freq, Pwhite(100, 900).select { |x| x < 800 }, \dur, 0.1).play;
)

(
// nothing between 300 and 3000 Hz: only the extremes remain
Pbind(\instrument, \pluck,
	\freq, Pexprand(50, 8000).reject { |f| (f > 300) && (f < 3000) },
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
Pbind(\instrument, \pluck, \freq, Pif(Ptime(inf) < 1.0, Pexprand(200, 2000, inf)), \dur, 0.1).play;
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

Pchain(Pbind(\instrument, \bell, \freq, Pseq([2203, 3389, 2671], inf)), ~rhythm).play;

Pbindf(~rhythm, \instrument, \breath, \freq, Pexprand(300, 3000)).play


////////////////////////// Changing While Playing ///////////////////////////

Pbindef(\live, \instrument, \pluck, \freq, Pexprand(200, 2000), \dur, 0.15).play;

Pbindef(\live, \instrument, \bell);

Pbindef(\live, \freq, Pseq([97, 389, 1543, 211], inf));

Pbindef(\live, \dur, Prand([0.1, 0.2], inf), \slide, Pwhite(-2, 2));

Pbindef(\live).stop;


////////////////////////// Form ///////////////////////////

(
Pspawner({ |sp|
	sp.par(Pbind(\instrument, \drone, \freq, [41, 61.3], \sus, 24, \dur, Pn(24, 1), \amp, 0.05));
	sp.seq(Pfindur(6, Pbind(\instrument, \pluck,                         // group
		\freq, Pdup(Pwhite(2, 5), Prand([311, 347, 529, 803], inf)), \dur, 0.1)));
	sp.par(Pfindur(12, Pbind(\instrument, \breath, \freq, Pexprand(400, 4000), \dur, 0.3)));
	sp.seq(Pfindur(6, Pbind(\instrument, \bell,                          // tendency
		\midinote, Pwhite(Pseg([60, 36], [6]), Pseg([62, 96], [6])), \dur, 0.08)));
	sp.seq(Pfindur(6, Pbind(\instrument, \blip,                          // series
		\freq, Pn(Plazy { Pseq([1013, 1171, 1409, 1693, 1877].scramble) }), \dur, 0.12)));
	sp.seq(Pbind(\instrument, \gliss, \freq, [130, 196.4, 311.7], \slide, -12, \sus, 4,
		\dur, Pn(4, 1)));
}).play
)


////////////////////////// Clouds ///////////////////////////

Pbind(\instrument, \sine, \freq, Pexprand(2000, 9000), \sus, 0.01, \dur, 0.005, \amp, 0.05).play;

(
Pbind(\instrument, \sine, \sus, 0.02, \dur, 0.01, \amp, 0.05,
	\freq, Pexprand(Pseg([100, 1900], [15]), Pseg([8000, 2100], [15]))).play;
)


////////////////////////// Noise Bands ///////////////////////////

Pbind(\instrument, \breath, \freq, 800, \sus, 2, \dur, 0.5).play;

(
// many bands, of many lengths
Pbind(\instrument, \breath, \freq, Pexprand(100, 8000), \sus, Pexprand(0.2, 4), \dur, 0.1).play;
)

(
// one band sliding down four octaves
Pbind(\instrument, \breath, \freq, 4000, \slide, -48, \sus, 8, \dur, Pn(8, 1)).play;
)


////////////////////////// Glissandi ///////////////////////////

(
Pbind(\instrument, \gliss, \freq, Pexprand(100, 2000), \slide, Pwhite(-24, 24),
	\sus, 2, \dur, 0.2, \amp, 0.03).play;
)

(
Pbind(\instrument, \drone, \freq, Pexprand(500, 3000), \slide, -36,
	\sus, Pseries(0.5, 0.25, 30), \dur, 0.4, \amp, 0.05).play;
)


////////////////////////// Registers ///////////////////////////

(
Pbind(\instrument, \pluck,
	\freq, Prand([Pwhite(30, 60, 1), Pwhite(6000, 9000, 1)], inf), \dur, 0.1).play;
)

(
Ppar([
	Pbind(\instrument, \drone, \freq, [41, 41.7], \sus, 8, \dur, 6, \amp, 0.1),
	Pbind(\instrument, \blip, \freq, Pexprand(5000, 9000), \dur, Pexprand(0.1, 2.0), \amp, 0.03)
]).play
)


////////////////////////// Density ///////////////////////////

(
Pbind(\instrument, \blip, \freq, Pexprand(400, 4000),
	\dur, Pseg([1, 0.01, 1], [10, 10], \exp), \sus, 0.05).play;
)

Pbind(\instrument, \pluck, \freq, Pexprand(100, 3000), \dur, Pexprand(0.01, 1.0)).play;


////////////////////////// Bursts ///////////////////////////

(
Pbind(\instrument, \breath, \freq, Pexprand(1000, 6000), \sus, 0.03,
	\dur, Pseq([Pgeom(0.3, 0.8, 20), Rest(2)], inf)).play;
)


////////////////////////// Microtones ///////////////////////////

(
Pbind(\instrument, \drone, \midinote, 60 + (Array.series(10) / 10),
	\sus, 8, \dur, Pn(8, 1), \amp, 0.02).play;
)

Pbind(\instrument, \pluck, \midinote, Pbrown(48, 72, 1/3).round(1/3), \dur, 0.12).play;


////////////////////////// Ratios ///////////////////////////

~ratios = [1, 2.76, 5.4, 8.93, 13.3];

Pbind(\instrument, \bell, \freq, 55 * Prand(~ratios, inf), \dur, 0.2).play;

(
Pbind(\instrument, \drone, \freq, Pexprand(40, 200).collect { |f| f * ~ratios },
	\sus, 4, \dur, 3, \amp, 0.02).play;
)

