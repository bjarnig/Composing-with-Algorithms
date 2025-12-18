////////////////////////////////////////////////////////////////
//
//                  FM Synthesis + Patterns
//
////////////////////////////////////////////////////////////////

// FM synthesis combined with various pattern techniques


////////////////////////// SynthDefs ///////////////////////////

(
// FM using PMOsc (Phase Modulation)
SynthDef(\fm, {|out=0, freq=400, cmRatio=1.5, index=3, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, modFreq, env;
	modFreq = freq * cmRatio.reciprocal;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = PMOsc.ar(freq, modFreq, index) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

// FM using multiple sine wave operators (classic FM)
SynthDef(\fmSine, {|out=0, freq=400,
	modFreq1=100, modIndex1=5,
	modFreq2=200, modIndex2=3,
	modFreq3=50, modIndex3=2,
	amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var carrier, mod1, mod2, mod3, env;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);

	// Modulator
	mod3 = SinOsc.ar(modFreq3, mul: modIndex3 * modFreq3);
	mod2 = SinOsc.ar(modFreq2 + mod3, mul: modIndex2 * modFreq2);
	mod1 = SinOsc.ar(modFreq1 + mod2, mul: modIndex1 * modFreq1);

	// Carrier
	carrier = SinOsc.ar(freq + mod1) * env * amp;
	Out.ar(out, Pan2.ar(carrier, pan));
}).add;
)


/////////////// Example 1: FM with Gaussian Distribution ////////

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


/////////////// Example 2: FM with Exponential Distribution /////

(
Pbind(
	\instrument, \fm,
	\midinote, Pexprand(48, 84, inf).round(1),
	\cmRatio, Pseq([1.5, 2, 3, 4], inf),
	\index, Pwhite(3, 10),
	\rel, 0.3,
	\amp, 0.15,
	\dur, Pexprand(0.05, 0.2)
).play;
)

/////////////// Example 3: Multi-Op FM with Tendency Mask //////////

(
Pbind(
	\instrument, \fmSine,
	\midinote, Pseg(Pseq([48, 72, 60, 84], inf), Pseq([4, 3, 2, 5], inf), \linear),
	\modFreq1, Pseg(Pseq([100, 300, 150], inf), Pseq([5, 3], inf), \exp),
	\modIndex1, Pseg(Pseq([3, 8, 5], inf), Pseq([4, 2], inf)),
	\modFreq2, Pseg(Pseq([200, 500, 250], inf), Pseq([4, 2], inf), \exp),
	\modIndex2, 2,
	\modFreq3, 50,
	\modIndex3, 1,
	\rel, 0.25,
	\amp, 0.2,
	\dur, 0.1
).play;
)


/////////////// Example 4: Multi-Op FM with Poisson Distribution ///

(
Pbind(
	\instrument, \fmSine,
	\midinote, Ppoisson(60, inf).clip(48, 72),
	\modFreq1, Ppoisson(150, inf).clip(50, 300),
	\modIndex1, Ppoisson(6, inf).clip(2, 12),
	\modFreq2, Ppoisson(250, inf).clip(100, 500),
	\modIndex2, Ppoisson(4, inf).clip(1, 8),
	\modFreq3, Ppoisson(80, inf).clip(30, 150),
	\modIndex3, Pwhite(1, 3),
	\rel, 0.2,
	\amp, 0.2,
	\dur, Ppoisson(0.15, inf).clip(0.05, 0.5)
).play;
)


/////////////// Example 5: Multi-Op FM with Linked Parameters //////

(
Pbind(
	\instrument, \fmSine,
	\midinote, Phprand(48, 72, inf),
	\modFreq1, Pkey(\midinote).midicps * Pwrand([0.5, 1, 1.5], [0.4, 0.3, 0.3], inf),
	\modIndex1, Pkey(\modFreq1).linlin(50, 400, 3, 10),
	\modFreq2, Pkey(\modFreq1) * Pwrand([1.5, 2, 3], [0.5, 0.3, 0.2], inf),
	\modIndex2, Pkey(\modFreq2).linlin(100, 600, 2, 6),
	\modFreq3, Pkey(\midinote).midicps * 0.5,
	\modIndex3, 2,
	\rel, 0.3,
	\amp, 0.18,
	\dur, 0.125
).play;
)


/////////////// Example 6: FM Arpeggio Pattern //////////////////

(
Pbind(
	\instrument, \fm,
	\midinote, Pseq([60, 64, 67, 72], inf) + Pwhite(-1, 1),
	\cmRatio, Pstutter(4, Pseq([1.5, 2, 3], inf)),
	\index, Pseq([4, 6, 8, 10], inf),
	\rel, 0.2,
	\amp, Pseq([0.25, 0.15, 0.15, 0.2], inf),
	\dur, 0.1
).play;
)
