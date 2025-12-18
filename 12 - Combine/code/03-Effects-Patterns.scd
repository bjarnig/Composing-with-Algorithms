////////////////////////////////////////////////////////////////
//
//                  Effects + Patterns
//
////////////////////////////////////////////////////////////////

// Combining synthesis patterns with effects processing


////////////////////////// SynthDefs ///////////////////////////

(
SynthDef(\fm, {|out=0, freq=400, cmRatio=1.5, index=3, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, modFreq, env;
	modFreq = freq * cmRatio.reciprocal;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = PMOsc.ar(freq, modFreq, index) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

SynthDef(\sine, {|out=0, freq=440, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, env;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = SinOsc.ar(freq) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

SynthDef(\buzz, {|out=0, freq=200, harmonics=10, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, env;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = Blip.ar(freq, harmonics) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

// Noise-based synth with filtered noise
SynthDef(\noise, {|out=0, cutoff=2000, rq=0.5, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, noise, env;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	noise = WhiteNoise.ar();
	signal = RLPF.ar(noise, cutoff, rq) * env * amp * 3;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;

// Crackle-based synth (chaotic noise)
SynthDef(\crackle, {|out=0, chaos=1.5, amp=0.3, pan=0, gate=1, atk=0.01, sus=1, rel=0.3|
	var signal, env;
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
	signal = Crackle.ar(chaos) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;
)


////////////////////////// Effects /////////////////////////////

(
SynthDef(\reverb, {|in=0, out=0, mix=0.5, decay=2|
	var signal, rev;
	signal = In.ar(in, 2);
	rev = Mix(signal);
	8.do({ rev = LPF.ar(AllpassN.ar(rev, 1.0, [0.05.rand, 0.05.rand], decay), 7000)});
	ReplaceOut.ar(out, (signal * (1-mix)) + (rev * mix));
}).add;

SynthDef(\echo, {|in=0, out=0, length=0.3, fb=0.7|
	var signal, feedback, echo;
	signal = In.ar(in, 2);
	feedback = LocalIn.ar(2);
	echo = LeakDC.ar(feedback * fb + signal);
	LocalOut.ar(DelayC.ar(echo, 1, length));
	ReplaceOut.ar(out, echo);
}).add;

SynthDef(\distort, {|in=0, out=0, mix=0.5, gain=50|
	var signal, dist;
	signal = In.ar(in, 2);
	dist = (signal.squared + (gain*signal))/(signal.squared + ((gain-1)*signal) + 1) * 0.01;
	Out.ar(out, (signal * (1-mix)) + (dist * mix));
}).add;

SynthDef(\resonator, {|in=0, out=0, mix=0.7, amp=0.1|
	var signal, resonate, freqs;
	freqs = Control.names([\freqs]).kr([400, 800, 1200, 1800]);
	signal = In.ar(in, 2);
	resonate = DynKlank.ar(`[freqs, [0.1, 0.2, 0.1, 0.2]], signal) * amp;
	ReplaceOut.ar(out, (signal * (1-mix)) + (resonate * mix));
}).add;
)


/////////////// Example 1: FM + Reverb //////////////////////////

(
~fxBus = Bus.audio(s, 2);
~fxGroup = Group.after(s.defaultGroup);
~reverb = Synth(\reverb, [\in, ~fxBus, \out, 0, \mix, 0.4, \decay, 3], ~fxGroup);

Pbind(
	\instrument, \fm,
	\out, ~fxBus,
	\midinote, Pexprand(48, 84, inf).round(1),
	\cmRatio, Pseq([1.5, 2, 3, 4], inf),
	\index, Pwhite(3, 10),
	\rel, 0.3,
	\amp, 0.15,
	\dur, Pexprand(0.05, 0.2)
).play;
)

~reverb.free; ~fxBus.free;


/////////////// Example 2: Sine + Echo //////////////////////////

(
~fxBus = Bus.audio(s, 2);
~fxGroup = Group.after(s.defaultGroup);
~echo = Synth(\echo, [\in, ~fxBus, \out, 0, \length, 0.25, \fb, 0.6], ~fxGroup);

Pbind(
	\instrument, \sine,
	\out, ~fxBus,
	\midinote, Pgauss(60, 12, inf).round(1),
	\rel, 0.15,
	\amp, 0.2,
	\pan, Pwhite(-0.8, 0.8),
	\dur, Phprand(0.1, 0.3)
).play;
)

~echo.free; ~fxBus.free;


/////////////// Example 3: Noise + Dynamic Resonator ////////////

(
~fxBus = Bus.audio(s, 2);
~fxGroup = Group.after(s.defaultGroup);
~res = Synth(\resonator, [\in, ~fxBus, \out, 0, \mix, 0.8, \amp, 0.15], ~fxGroup);

// Change resonator frequencies over time
fork {
	loop {
		~res.setn(\freqs, Array.rand(4, 200, 2000).sort);
		rrand(1.5, 4.0).wait;
	}
};

Pbind(
	\instrument, \noise,
	\out, ~fxBus,
	\cutoff, Pexprand(800, 4000, inf),
	\rq, Pexprand(0.3, 0.8),
	\rel, Pexprand(0.05, 0.15),
	\amp, 0.2,
	\pan, Pwhite(-0.6, 0.6),
	\dur, Pexprand(0.05, 0.25)
).play;
)

~res.free; ~fxBus.free;


/////////////// Example 4: Crackle + Dynamic Resonator //////////

(
~fxBus = Bus.audio(s, 2);
~fxGroup = Group.after(s.defaultGroup);
~res = Synth(\resonator, [\in, ~fxBus, \out, 0, \mix, 0.7, \amp, 0.2], ~fxGroup);

// Evolving resonator frequencies with tendency
fork {
	var freqEnv = Env([200, 1500, 400, 2000], [8, 6, 10], \exp);
	var time = 0, dt = 0.5;
	loop {
		var baseFreq = freqEnv.at(time.mod(24) / 24);
		~res.setn(\freqs, Array.fill(4, {|i| baseFreq * (i+1) * rrand(0.9, 1.1)}).sort);
		dt.wait;
		time = time + dt;
	}
};

Pbind(
	\instrument, \crackle,
	\out, ~fxBus,
	\chaos, Pbrown(1.25, 1.95, 0.1, inf),
	\rel, Pexprand(0.08, 0.2),
	\amp, 0.15,
	\pan, Pbrown(-0.8, 0.8, 0.2, inf),
	\dur, Ppoisson(0.12, inf).clip(0.04, 0.3)
).play;
)

~res.free; ~fxBus.free;


/////////////// Example 5: FM + Reverb + Distortion /////////////

(
~fxBus = Bus.audio(s, 2);
~fxGroup = Group.after(s.defaultGroup);

~reverb = Synth.head(~fxGroup, \reverb, [\in, ~fxBus, \out, ~fxBus, \mix, 0.3]);
~dist = Synth.after(~reverb, \distort, [\in, ~fxBus, \out, 0, \mix, 0.2, \gain, 30]);

Pbind(
	\instrument, \sine,
	\out, ~fxBus,
	\midinote, Pcauchy(60, 8, inf).max(40).min(80),
	\rel, Pexprand(0.05, 0.3),
	\amp, 0.15,
	\pan, Pwhite(-1.0, 1.0),
	\dur, Pexprand(0.05, 0.2)
).play;
)

~reverb.free; ~dist.free; ~fxBus.free;






