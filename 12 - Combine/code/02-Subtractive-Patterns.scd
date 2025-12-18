////////////////////////////////////////////////////////////////
//
//              Subtractive Synthesis + Patterns
//
////////////////////////////////////////////////////////////////

// Subtractive synthesis combined with pattern techniques


////////////////////////// SynthDefs ///////////////////////////

(
SynthDef(\saw, {|out=0, freq=440, cutoff=1200, rq=0.3, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, env, filt;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = Saw.ar(freq) * env;
	filt = RLPF.ar(signal, cutoff, rq) * amp;
	Out.ar(out, Pan2.ar(filt, pan));
}).add;

SynthDef(\buzz, {|out=0, freq=200, harmonics=10, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, env;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = Blip.ar(freq, harmonics) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;
)


/////////////// Example 1: Saw with Brownian Motion /////////////

(
Pbind(
	\instrument, \saw,
	\midinote, Pbrown(20, 30, 4, inf),
	\cutoff, Pbrown(500, 3000, 150, inf),
	\rq, 0.02,
	\atk, 0.1,
	\rel, Pwhite(0.1, 0.8),
	\amp, 0.15,
	\dur, Pbrown(0.01, 0.3, 0.05, inf)
).play;
)


/////////////// Example 2: Filter Sweep with Tendency ///////////

(
Pbind(
	\instrument, \saw,
	\midinote, Pwhite(36, 48, inf),
	\cutoff, Pseg(Pseq([300, 5000, 800], inf), Pseq([6, 4], inf), \exp),
	\rq, Pseg(Pseq([0.8, 0.1, 0.5], inf), Pseq([5, 3], inf)),
	\rel, 0.3,
	\amp, 0.18,
	\dur, 0.025
).play;
)


/////////////// Example 3: Saw Density Cloud ////////////////////

(
Pbind(
	\instrument, \saw,
	\midinote, Pgauss(60, 18, inf).round(1).clip(36, 96),
	\cutoff, Pexprand(800, 4000, inf),
	\rq, Pexprand(0.1, 0.5),
	\rel, Pexprand(0.05, 0.2),
	\amp, Pexprand(0.08, 0.15),
	\pan, Pgauss(0, 0.5).clip(-1, 1),
	\dur, Ppoisson(0.1, inf).clip(0.03, 0.4)
).play;
)



/////////////// Example 4: Saw Resonance Sweep /////////////////

(
Pbind(
	\instrument, \saw,
	\midinote, Pstutter(16, Pseq([20, 50, 40, 60], inf)),
	\cutoff, Pwhite(1000, 3000),
	\rq, Pseg(Pseq([0.9, 0.05, 0.6], inf), Pseq([4, 2], inf), \sin),
	\rel, 0.02,
	\amp, 0.2,
	\dur, 0.1
).play;
)

