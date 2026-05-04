////////////////////////////////////////////////////////////////
//
//          Composing with Algorithms - 50 Examples
//
////////////////////////////////////////////////////////////////

/*

A recap of techniques from the course.

*/


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\sine, {
	|out=0, amp=0.1, freq=440, rel=0.2, pan=0|
	var env, sig;
	env = EnvGen.kr(Env.perc(rel:rel), doneAction:2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\saw, {
	|out=0, freq=440, rel=0.5, lop=2000, res=0.5, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction:2);
	sig = Saw.ar(freq) * amp;
	sig = BLowPass4.ar(sig, lop, res);
	Out.ar(out, Pan2.ar(sig, pan, env));
}).add;

SynthDef(\monosaw, {
	|out=0, freq=440, lop=2000, res=0.5, amp=0.2, pan=0, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 0.1), gate, doneAction:2);
	sig = Saw.ar(freq) * amp;
	sig = BLowPass4.ar(sig, lop, res);
	Out.ar(out, Pan2.ar(sig, pan, env));
}).add;

SynthDef(\pluck, {
	|amp=0.1, freq=440, decay=4, coef=0.1, pan=0|
	var env, sig, delay;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction:2);
	sig = WhiteNoise.ar(amp);
	delay = freq.reciprocal;
	sig = Pluck.ar(in:sig, delaytime:delay, decaytime:decay, coef:coef);
	Out.ar(0, Pan2.ar(sig * 0.5, pan));
}).add;

SynthDef(\snd, { arg freq=500, gate=1, out=0, lop=8000, amp=0.1, pan=0, atk=0.01, rel=0.25;
	var env = EnvGen.kr(Env.asr(atk, amp, rel), gate, doneAction:2);
	var signal = RLPF.ar(Saw.ar(freq, 0.25).fold2(SinOsc.ar(freq/2)), lop);
    OffsetOut.ar(out, Pan2.ar(signal * env, pan));
}).add;

SynthDef(\fm, {|out=0, freq=400, cmRatio=1.5, index=3, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, modFreq, env;
	modFreq = freq * cmRatio.reciprocal;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = PMOsc.ar(freq, modFreq, index) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

SynthDef(\noise, {
	|out = 0, pan = 0, gate=1, freq = 1400, atk = 0.01, rel = 0.5, rq = 0.5, amp = 0.1|
	var noise, env, filter, sig;
	noise = WhiteNoise.ar(0.5);
    env = EnvGen.kr(Env.asr(0, 1, 3), gate, doneAction:2);
	filter = BLowPass.ar(noise, freq, rq);
	sig = filter * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;

)


////////////////////////////////////////////////////////////////
//
//        PATTERNS & SEQUENCING (Classes 03, 05)
//
////////////////////////////////////////////////////////////////


// 1. Pbind basics: bind a synth with patterns for freq and duration
(
Pbind(
	\instrument, \sine,
	\freq, Pwhite(100, 1000),
	\amp, Pseq([0.1, 0.2], inf),
	\dur, 0.2
).play
)


// 2. Pseq with midinotes and scale degrees
(
Pbind(
	\instrument, \sine,
	\dur, 0.2,
	\degree, Pseq([1,3,5, Pseq([6,7],2)], inf),
	\scale, Scale.ionian
).play
)


// 3. Pseries and Pgeom for linear and geometric growth
(
Pbind(\instrument, \pluck,
	\note, Pgeom(40, 1.01, 32),
	\dur, Pgeom(0.1, 1.1, 32),
	\amp, Pgeom(0.5, 1.001, 32),
).play
)


// 4. Ppar for playing two patterns simultaneously
(
~low = Pbind(
	\instrument, \pluck,
	\note, Pwhite(12, 48),
	\dur, Pseq(Array.geom(12, 0.1, 1.1) ++ Array.geom(12, 0.1, 1.1).reverse, inf)
);

~high = Pbind(
	\instrument, \sine,
	\note, Pwhite(60, 84),
	\dur, Pseq(Array.geom(12, 0.1, 1.1) ++ Array.geom(12, 0.1, 1.1).reverse, inf)
);

Ppar([ ~low, ~high ]).play;
)


// 5. Pkey for parameter correlation (pos drives dur)
(
Pbind(\instrument, \sine,
	\midinote, Pbrown(48, 72, 4, inf),
	\lop, Pkey(\midinote).linexp(48, 72, 100, 1000),
	\dur, Pkey(\midinote).linlin(48, 72, 0.2, 0.05),
	\amp, 0.15
).play
)


////////////////////////////////////////////////////////////////
//
//   PROBABILITY & DISTRIBUTIONS (Classes 06, 07, 08)
//
////////////////////////////////////////////////////////////////


// 6. Pwhite — uniform distribution
(
Pbind(
	\instrument, \sine,
	\midinote, Pwhite(48, 84),
	\dur, 0.1,
	\amp, 0.2
).play
)


// 7. Pgauss — gaussian/bell curve, centered around a pitch
(
Pbind(
	\instrument, \sine,
	\midinote, Pgauss(60, 8, inf),
	\dur, 0.1,
	\amp, 0.2
).play
)


// 8. Pexprand — exponential, favoring lower values
(
Pbind(
	\instrument, \sine,
	\midinote, Pexprand(48, 84),
	\dur, 0.05,
	\amp, 0.2
).play
)


// 9. Pbeta — extreme dynamics (favoring very quiet or very loud)
(
Pbind(
	\instrument, \saw,
	\midinote, Pwhite(48, 72, inf),
	\amp, Pbeta(0.05, 0.3, 0.5, 0.5, inf),
	\lop, Prand([100,200,2000,3000],inf),
	\dur, 0.15,
	\rel, 0.3
).play
)


// 10. Pwrand — weighted random
(
~pitches = [43, 48, 45, 43, 48, 43, 47, 39, 41];
~weights = [2, 0.2, 2, 0.3, 0.5, 0.5, 1, 0.5, 1].normalizeSum;

Pbind(
    \instrument, \snd,
    \midinote, Pwrand(~pitches, ~weights, inf),
    \dur, 0.1
).play;
)


////////////////////////////////////////////////////////////////
//
//    MARKOV CHAINS & STATE MACHINES (Classes 06, 08)
//
////////////////////////////////////////////////////////////////


// 11. Pfsm — simple finite state machine
(
Pbind(
	\instrument, \sine,
	\midinote, Pfsm([
		[0],        // Initial state: 0
		60, [1, 2], // State 0: play 60, go to 1 or 2
		65, [0, 2], // State 1: play 65, go to 0 or 2
		67, [0, 1]  // State 2: play 67, go to 0 or 1
	], inf),
	\dur, 0.15,
	\amp, 0.3
).play
)


// 12. Pfsm with patterns as states (register-based)
(
var low = Pwhite(48, 55, 2);
var mid = Pwhite(60, 67, 3);
var high = Pwhite(72, 79, 4);

Pbind(
	\instrument, \pluck,
	\midinote, Pfsm([
		[0],                    // Start with low
		low, [0, 0, 1],        // Stay low (66%) or go mid (33%)
		mid, [1, 1, 2],        // Stay mid (66%) or go high (33%)
		high, [0, 1, 2]        // Equally likely to go anywhere
	], inf),
	\dur, Pwhite(0.1, 0.2),
	\decay, 2,
	\amp, 0.2
).play
)


// 13. MarkovSetN — probabilistic transitions
(
Quarks.install("MathLib");

m = MarkovSetN([
	[[60], [62, 65], [0.8, 0.2]],
	[[62], [60, 67], [0.7, 0.3]],
	[[65], [67, 60], [0.5, 0.5]],
	[[67], [62],     [1.0]]
], 1);

m.makeSeeds;

Pbind(
	\instrument, \sine,
	\midinote, m,
	\dur, 0.2,
	\amp, 0.3
).play;
)


// 14. Markov controlling phrase structure with Pswitch
(
m = MarkovSetN([
	[[0], [1, 2], [0.7, 0.3]],
	[[1], [0, 1, 2], [0.5, 0.3, 0.2]],
	[[2], [0], [1.0]]
], 1);

m.makeSeeds;

~motifs = [
	Pseq([60, 62, 64, 62], 2),
	Pseq([57, 55, 54], 2),
	Pseq([72, 70, 80, 82], 2)
];

Pbind(
	\instrument, \pluck,
	\midinote, Pswitch(~motifs, m),
	\dur, 0.1,
	\decay, 1.5,
	\amp, 0.2
).play;
)


// 15. Brownian motion (random walk) with Pseries
(
Pbind(
	\instrument, \sine,
	\midinote, Pseries(60, Pwhite(-2, 2, inf), inf).fold(50, 70),
	\dur, Pbrown(0.1, 0.2, 0.01, inf)
).play(TempoClock(150/60))
)


////////////////////////////////////////////////////////////////
//
//   TENDENCY MASKS & CONTROLLED RANDOMNESS (Classes 07, 08)
//
////////////////////////////////////////////////////////////////


// 16. Basic tendency mask with Pseg boundaries
(
Pbind(
    \instrument, \snd,
    \midinote, Pwhite(
	    Pseg(Pseq([ 60, 80, 10, 100 ], inf), Pseq([ 5, 5, 5, 5 ], inf)),
		Pseg(Pseq([ 80, 100, 50, 120 ], inf), Pseq([ 5, 5, 5, 5 ], inf))
	),
    \dur, 0.1
).play;
)


// 17. Tendency mask with Env for custom shapes
(
var lower = Env([40, 70, 45, 60], [3, 2, 3], \sine);
var upper = Env([60, 85, 70, 80], [3, 2, 3], \sine);

Pbind(
	\instrument, \pluck,
	\midinote, Pwhite(
		Pn(Penv(lower.levels, lower.times)),
		Pn(Penv(upper.levels, upper.times))
	),
	\decay, 2,
	\dur, 0.1,
	\amp, 0.15
).play
)


// 18. Tendency mask reading from a collection (Koenig)
(
var low, hi, coll;

hi = Env([0.26, 0.51, 0.9], [0.5, 0.5]);
low = Env([0.25, 0.49, 0.01], [0.5, 0.5]);
coll = Array.series(16, 40, 2);

Pbind(
	\instrument, \snd,
	\th, Pn(Penv(hi.levels, hi.times * 2)),
	\tl, Pn(Penv(low.levels, low.times * 2)),
	\midinote, Pfunc{|ev| coll[((coll.size-1) * rrand(ev.tl, ev.th))]},
	\dur, Pn(Pshuf([1/16, 1/8, 1/32]))
).play(TempoClock(90/60));
)


// 19. Pclutch — sample and hold (freeze values)
(
Pbind(
	\instrument, \sine,
	\freq, Pclutch(
		Pwhite(200, 2000),
		Pseq([1, 0, 0, 0, 1, 0, 0, 0], inf)
	),
	\dur, 0.1,
	\amp, 0.15
).play
)


// 20. Ptime + Pif for time-limited sections
(
a = Pbind(
	\instrument, \sine,
	\freq, Pif(Ptime(inf) < 2.0, Pwhite(100, 400, inf)),
	\dur, 0.1);

b = Pbind(
	\instrument, \sine,
	\freq, Pif(Ptime(inf) < 1.0, Pwhite(300, 700, inf)),
	\dur, 0.15);

Pseq( [a,b], inf).play;
)


////////////////////////////////////////////////////////////////
//
//             SYNTHESIS (Classes 09, 12)
//
////////////////////////////////////////////////////////////////


// 21. Additive synthesis — layering sine waves
(
10.do {
	{ SinOsc.ar(exprand(100.0, 2000.0), 0, 0.1) ! 2 }.play
}
)


// 22. DynKlang — dynamic sine oscillator bank
(
{
	(DynKlang.ar(`[
		[200, 1000, 2000],
		[0.5, 0.4, 0.1]
	]) * 0.1) ! 2
}.play;
)


// 23. Subtractive synthesis — Saw through resonant filter
(
{
	RLPF.ar(Saw.ar([100, 150], 0.5), LFNoise1.kr(0.1).range(100, 1200), 0.1)
}.play
)


// 24. FM synthesis — PMOsc with carrier/modulator ratio
(
Pbind(
	\instrument, \fm,
	\midinote, Pgauss(60, 12, inf),
	\cmRatio, Pwhite(1.0, 3.0),
	\index, Pwhite(2, 8),
	\rel, 0.2,
	\amp, 0.2,
	\dur, 0.1
).play;
)


// 25. Physical modeling — Pluck UGen
(
Pbind(\instrument, \pluck,
	\note, Pseries(48, 0.25, 32),
	\dur, 0.1,
	\amp, 0.2,
).play
)


////////////////////////////////////////////////////////////////
//
//       SIGNALS, ENVELOPES & LFOs (Class 10)
//
////////////////////////////////////////////////////////////////


// 26. Envelopes — custom shapes
(
{
	var env = Env([0, 1, 0.5, 1, 0], [2.01, 1.5, 0.2, 0.5]);
	SinOsc.ar([200, 201]) * EnvGen.kr(env, doneAction: 2)
}.play
)


// 27. LFO controlling frequency
(
{
	var lfo = SinOsc.ar(freq: 10, mul: 100, add: 400);
	SinOsc.ar(lfo, mul: 0.5)
}.play
)


// 28. LFNoise types — step, ramp, smooth
(
{
	var freq = LFNoise2.kr([1, 1.1]).range(200, 600);
	SinOsc.ar(freq, mul: 0.3)
}.play
)


// 29. Sample and hold with Latch
(
{
	var trigger = Impulse.kr(4);
	var held = Latch.kr(WhiteNoise.kr, trigger);
	SinOsc.ar(held.range(200, 800), mul: 0.3)
}.play
)


// 30. TChoose — triggered random selection from array
(
{
	var trigger = Impulse.kr(4);
	var freq = TChoose.kr(trigger, [100, 200, 300, 400, 600, 800]);
	SinOsc.ar(freq, mul: 0.3)
}.play
)


////////////////////////////////////////////////////////////////
//
//         EFFECTS & PROCESSING (Class 11)
//
////////////////////////////////////////////////////////////////


// 31. Delay — simple delay with feedback echo
(
SynthDef(\echo,{|in=0, out=0, length = 0.5, fb = 0.8, sep = 0.012|
	var source, feedback, echo;
	source = In.ar(in, 2);
	feedback = LocalIn.ar(2);
	echo = LeakDC.ar(feedback*fb + source);
	LocalOut.ar(DelayC.ar(echo, 1, LFNoise2.ar(12).range([length,length+sep],[length+sep,length])));
	ReplaceOut.ar(out, echo);
}).add;

SynthDef(\imp, {|out=0, freq=1|
	Out.ar(out, Pan2.ar(Impulse.ar(freq)));
}).add;
)

// Evaluate, then:
Synth(\echo, [\length, 0.1, \fb, 0.9])
Synth(\imp, [\freq, 1])


// 32. Reverb — allpass chain algorithm
(
{
	var sig = Impulse.ar(2) * 0.5;
	var rev = sig;
	6.do({ rev = LPF.ar(AllpassN.ar(rev, 1.0, [0.05.rand, 0.05.rand], 2.0), 7000) });
	(sig * 0.4) + (rev * 0.3)
}.play
)


// 33. Distortion — bit reduction
(
{
	var sig = SinOsc.ar(200, 0, 0.5);
	var bits = 5;
	sig = sig.round(2**(bits * -1));
	sig.clip(-0.2,0.3).distort * 0.5 ! 2
}.play
)


// 35. Spectral freeze (PV_MagFreeze)
(
{
	var sig = Saw.ar(LFNoise1.kr(2).range(200, 800), 0.3);
	var chain = FFT(LocalBuf(2048), sig);
    chain = PV_MagFreeze(chain, LFPulse.kr(0.5));
	IFFT(chain) ! 2
}.play
)


////////////////////////////////////////////////////////////////
//
//       GRANULAR / MICROSOUND (Class 13)
//
////////////////////////////////////////////////////////////////


// 36. GrainFM — FM grains triggered by Dust
(
{
	var density=50, dur=0.01, trig;
	trig = Dust.kr(density);
	Mix.fill(5, {
		var freq=rrand(100, 800);
		var modfreq=rrand(100, 800);
		GrainFM.ar(2, trig, dur, freq, modfreq, Line.ar(0.1, 0.9, 5)) * 0.2;
	})
}.play
)


// 37. GrainSin — granular sine with random parameters
(
{
	var trig = Dust.ar(40);
	var freq = TExpRand.ar(200, 2000, trig);
	var pan = TRand.ar(-1, 1, trig);
	GrainSin.ar(2, trig, 0.05, freq, pan) * 0.3;
}.play
)


// 38. GrainFM — harmonic grain layers with envelope density
(
{
	var density=10, fund=100, trig, dur;
	trig = Impulse.kr(EnvGen.ar(Env([1,100,1],[4,4])));
	dur = EnvGen.ar(Env([0.1,0.01,0.2],[4,4]));
	Mix.fill(10, {|i|
		var freq=fund * (i + 1);
		var modfreq= freq * 4;
		GrainFM.ar(2, trig, dur, freq, modfreq,
			LFNoise0.ar(2, mul:0.2, add:0.7)) * 0.02;
	})
}.play
)


////////////////////////////////////////////////////////////////
//
//       WAVEFORMS & GENDY (Classes 06, 14)
//
////////////////////////////////////////////////////////////////


// 39. Gendy — stochastic waveform synthesis (Xenakis)
(
{ Pan2.ar(Mix.new(
	Gendy3.ar(freq:([1,3,7,9] * 12), mul:0.2)
)) }.play
)


// 40. Gendy2 with SinOsc modulation
(
{ Pan2.ar(
	Gendy2.ar(0, 0, SinOsc.kr(0.1, 0, 0.1, 0.9), 1.0,
		50, 1000, 1, 0.005, 12, 12, 0.2, 0.2, 0.2), 0.0)
}.play
)


////////////////////////////////////////////////////////////////
//
//         ERRORS & GLITCH (Class 15)
//
////////////////////////////////////////////////////////////////


// 42. Sample rate reduction
(
{
	var sig = SinOsc.ar(440, 0, 0.3);
	var sampleRate = LFNoise1.kr(2).exprange(200, 8000);
	Latch.ar(sig, Impulse.ar(sampleRate)) ! 2;
}.play
)


// 43. Random dropouts / muting
(
{
	var sig = Pulse.ar([120, 222]);
	var cutTrig = Dust.kr(4);
	var env = EnvGen.kr(Env([1, 0, 1], [0.001, 0.1]), cutTrig);
	sig * env * 0.3;
}.play
)


// 44. Codec switching artifacts
(
{
	var sig = SinOsc.ar(330, 0, 0.3);
	var codecSwitch = LFNoise0.kr(5).range(0, 3);
	var codecs = [
		{ |s| Latch.ar(s.round(0.5), Impulse.ar(22050)) },
		{ |s| Latch.ar(s.round(0.2), Impulse.ar(11025)) },
		{ |s| Latch.ar(s.round(0.05), Impulse.ar(5512)) },
		{ |s| Latch.ar(s.round(0.01), Impulse.ar(2756)) }
	];
	Select.ar(codecSwitch, codecs.collect(_.value(sig))) ! 2;
}.play
)


////////////////////////////////////////////////////////////////
//
//       CHAOS & ITERATIVES (Class 16)
//
////////////////////////////////////////////////////////////////


// 45. Chaos UGens controlling frequency
(
{
	var freq = HenonN.ar(100).range(200, 800);
	var width = CuspN.ar(50).range(0.1, 0.9);
	Pulse.ar(freq, width, 0.1) ! 2
}.play
)


// 46. Chaos with granular synthesis
(
{
	var trig = Dust.ar(StandardL.ar(5).range(5, 40));
	var freq = HenonN.ar(100).range(200, 1000);
	var sig = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.01, 0.2), trig) * 0.3;
	FreeVerb.ar(sig, 0.6, 0.9, 0.2) ! 2
}.play
)


// 47. Feedback synthesis with LocalIn/LocalOut
(
SynthDef(\feedbackSimple, {|feedback=0.99, delay=0.05|
	var sig, input;
	sig = Dust.ar(10) * 0.3;
	input = sig + LocalIn.ar(2);
	input = DelayC.ar(input, 1, LFNoise2.ar(0.1).range(delay, delay * 1.2));
	input = OnePole.ar(input, 0.5);
	LocalOut.ar(input * feedback);
	Out.ar(0, Limiter.ar(input, 0.5))
}).add;
)


x = Synth(\feedbackSimple);

x.free;


////////////////////////////////////////////////////////////////
//
//        GUI & MIDI CONTROL (Class 17)
//
////////////////////////////////////////////////////////////////


// 48. GUI — Slider controlling synth frequency
(
var synth, knob, num, spec;
spec = ControlSpec(200, 2000, \exp);
Window("Knob", Rect(200,200,120,120)).front.layout_(
	VLayout(
		knob = Knob().mode_(\vert),
		num = NumberBox()
	)
);
synth = {|freq=440| Saw.ar(freq) * 0.1 ! 2}.play;
knob.action = {|v| var f = spec.map(v.value); num.value_(f); synth.set(\freq, f) };
)


// 49. MIDI — trigger synths with note numbers
(
MIDIClient.init; MIDIIn.connectAll;

SynthDef(\perc, {
	|out=0, note=60, amp=0.5|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.1, 4), doneAction:2);
	sig = Blip.ar(note.midicps);
	Out.ar(out, sig * amp * env ! 2);
}).add;

MIDIFunc.noteOn({|val, num, chan, src|
	Synth(\perc, [\note, num, \amp, val.linlin(0,127,0.5,1.0)])
})
)


////////////////////////////////////////////////////////////////
//
//              OSC / IANNIX (Class 22)
//
////////////////////////////////////////////////////////////////


// 50. OSC — receive cursor data from Iannix to control synthesis
(
var synth;

SynthDef(\oscSaw, {
	|out=0, freq=100, lop=1000, amp=0.3|
	var sig, env;
	env = EnvGen.ar(Env.linen(2, 100, 2), doneAction:2);
	sig = BLowPass4.ar(Saw.ar(freq), lop);
	Out.ar(out, Pan2.ar(sig, 0, amp) * env);
}).add;

s.sync;

synth = Synth(\oscSaw);

OSCFunc({|msg|
	if(msg[1] == 2) {
		synth.set(\freq, msg[4].linlin(0.0, 1.0, 100, 1000));
		synth.set(\lop, msg[3].linlin(0.0, 1.0, 50, 1000))
	}
}, '/cursor');
)
