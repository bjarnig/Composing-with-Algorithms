////////////////////////////////////////////////////////////////
//
//               Examples - Synth Collection
//
////////////////////////////////////////////////////////////////

(

////////////////////////////////////////////////////////////////
//                  BASIC SYNTHESIS
////////////////////////////////////////////////////////////////

// Pure sine wave
SynthDef(\sine, {
	|out=0, amp=0.3, freq=440, atk=0.01, rel=0.3, pan=0.0, gate=1.0|
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Filtered sawtooth (subtractive)
SynthDef(\saw, {
	|out=0, amp=0.3, freq=440, atk=0.01, rel=0.3, cutoff=2000, res=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = Saw.ar(freq);
	sig = RLPF.ar(sig, cutoff, res);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Filtered square wave (subtractive)
SynthDef(\square, {
	|out=0, amp=0.3, freq=440, atk=0.01, rel=0.3, cutoff=2000, res=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = Pulse.ar(freq, 0.5);
	sig = RLPF.ar(sig, cutoff, res);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Pulse wave with PWM (subtractive)
SynthDef(\pulse, {
	|out=0, amp=0.3, freq=440, atk=0.01, rel=0.3, width=0.5, cutoff=2000, pan=0.0, gate=1.0|
	var sig, env, pwm;
	pwm = SinOsc.kr(0.5).range(0.1, 0.9);
	sig = Pulse.ar(freq, pwm * width);
	sig = RLPF.ar(sig, cutoff, 0.5);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Triangle wave (additive)
SynthDef(\tri, {
	|out=0, amp=0.4, freq=100, atk=0.05, rel=0.5, detune=0.2, pan=0.0, gate=1.0|
	var sig, env;
	sig = LFTri.ar([1 - detune, 1, 1 + detune, 1 + (detune * 2)] * freq,
		mul: [0.1, 1.0, 0.4, 0.8]);
	sig = Mix.ar(sig);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 0.5, pan);
	Out.ar(out, sig);
}).add;


// Additive synthesis (multiple sines)
SynthDef(\add, {
	|out=0, amp=0.3, freq=200, atk=0.01, rel=0.3, numharm=8, brightness=0.5, pan=0.0, gate=1.0|
	var sig, env, partials, maxHarm = 16;
	// Use fixed array size, then mix based on numharm parameter
	partials = Array.fill(maxHarm, { |i|
		var harmNum = i + 1;
		var ampScale = (1 / harmNum) * (1 - (brightness * (harmNum - 1) / maxHarm));
		var active = (harmNum <= numharm);  // This creates a 0 or 1
		SinOsc.ar(freq * harmNum, 0, ampScale * active)
	});
	sig = Mix.ar(partials) / maxHarm.sqrt;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  NOISE-BASED
////////////////////////////////////////////////////////////////

// White noise with filter
SynthDef(\white, {
	|out=0, amp=0.2, freq=1000, atk=0.01, rel=0.3, bw=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = WhiteNoise.ar();
	sig = BPF.ar(sig, freq, bw);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 8, pan);
	Out.ar(out, sig);
}).add;


// Pink noise with filter
SynthDef(\pink, {
	|out=0, amp=0.2, freq=1000, atk=0.01, rel=0.3, bw=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = PinkNoise.ar();
	sig = BPF.ar(sig, freq, bw);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 8, pan);
	Out.ar(out, sig);
}).add;


// Dust/impulses with filter
SynthDef(\dust, {
	|out=0, amp=0.3, freq=1000, atk=0.01, rel=0.3, density=100, pan=0.0, gate=1.0|
	var sig, env;
	sig = Dust.ar(density);
	sig = BPF.ar(sig, freq, 0.1);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 4, pan);
	Out.ar(out, sig);
}).add;


// Chaotic crackle with filter
SynthDef(\crackle, {
	|out=0, amp=0.2, freq=1000, atk=0.01, rel=0.3, chaos=1.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = Crackle.ar(chaos);
	sig = BPF.ar(sig, freq, 0.1);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 2, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  FM & MODULATION
////////////////////////////////////////////////////////////////

// 4-operator FM
SynthDef(\fm, {
	|out=0, amp=0.3, freq=100, atk=0.05, rel=0.5, mod=2.0, pan=0.0, gate=1.0|
	var sig, env, mult, note;
	note = freq.cpsmidi;
	mult = note / 60.0;
	sig = Mix.ar(PMOsc.ar(
		[126, 275, 6074, 5129] * mult,
		[12, 18, 11, 42] * mult,
		mod,
		0,
		[0.1, 0.1, 0.2, 0.1]
	));
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Granular FM with evolving modulation
SynthDef(\fmgrain, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, mod=0.5, pan=0.0, gate=1.0|
	var sig, env, grains;
	sig = PMOsc.ar([freq, freq * 0.5, freq * 1.5, freq * 0.25],
		[3040, 760, 3040, 380],
		Line.kr(0.02, mod * 8, 0.5),
		mul: [0.3, 0.1, 0.05, 0.2]);
	sig = Mix.ar(sig);
	grains = EnvGen.ar(Env.perc(0.1, 0.3), Impulse.ar(Line.kr(4, 20, 0.5)));
	sig = sig * grains;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Dual blips with amplitude modulation
SynthDef(\plip, {
	|out=0, amp=0.3, freq=400, atk=0.1, rel=0.5, mod=0.5, pan=0.0, gate=1.0|
	var sig, env, lfo;
	lfo = SinOsc.ar(freq / 24, 0, 0.5, 0.5);
	sig = Blip.ar(freq, 20, 0.5) + Blip.ar(freq / 2, 30, 0.5);
	sig = (sig * (lfo * mod)) + (sig * (1 - mod));
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 0.5, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  WAVESHAPING & FEEDBACK
////////////////////////////////////////////////////////////////

// Sine oscillator with feedback
SynthDef(\sinefb, {
	|out=0, amp=0.2, freq=440, atk=0.1, rel=0.5, feedback=0.7, pan=0.0, gate=1.0|
	var sig, env;
	sig = SinOscFB.ar(freq / 4, feedback) + SinOscFB.ar(freq / 6, feedback * 1.1);
	sig = HPF.ar(sig.softclip * 0.3, freq);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Blip with waveshaping
SynthDef(\fold, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, foldfreq=300, pan=0.0, gate=1.0|
	var sig, env;
	sig = Blip.ar(freq, 80).fold2(SinOsc.ar(foldfreq));
	sig = RLPF.ar(sig, freq * 8, 0.5);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  CHAOTIC & ALGORITHMIC
////////////////////////////////////////////////////////////////

// Brownian pitch modulation
SynthDef(\brown, {
	|out=0, amp=0.2, freq=400, atk=0.1, rel=0.5, mod=0.5, pan=0.0, gate=1.0|
	var sig, env, brownseq, freqd, trig;
	brownseq = Dbrown(freq, freq + (200 * mod), 50, inf);
	trig = Impulse.kr(Line.kr(10, 2000 * mod, 5));
	freqd = Demand.kr(trig, 0, brownseq);
	sig = Blip.ar(freqd, 80);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 0.6, pan);
	Out.ar(out, sig);
}).add;


// Chaotic impulse texture
SynthDef(\chaos, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, entropy=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = Impulse.ar([0.8, 0.9, 1.0, 1.1] * freq +
		LFNoise1.ar([100, 200, 300, 400], entropy * [100, 200, 300, 400]));
	sig = Mix.ar(sig);
	sig = sig + Formlet.ar(sig, freq / 2, 0.01, 0.1);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 0.4, pan);
	Out.ar(out, sig);
}).add;


// Gingerbreadman chaotic oscillator
SynthDef(\gbman, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, chaos=0.5, pan=0.0, gate=1.0|
	var sig, env, chaosFreq;
	chaosFreq = GbmanL.ar(freq / 4).range(freq / 2, freq);
	sig = Saw.ar(Lag.ar(chaosFreq, chaos * 0.1));
	sig = RLPF.ar(sig, freq * 4, 0.5);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  TEXTURAL
////////////////////////////////////////////////////////////////

// Gritty impulse-based texture
SynthDef(\grain, {
	|out=0, amp=0.3, freq=500, atk=0.1, rel=0.5, rate=10, pan=0.0, gate=1.0|
	var sig, env, trigger, impulse, noise;
	trigger = Impulse.ar(rate);
	env = EnvGen.ar(Env.perc(0.01, 1 / rate), trigger);
	impulse = BPF.ar(Impulse.ar(freq, env), freq, 0.1) * 0.6;
	noise = BPF.ar(PinkNoise.ar(env), freq, 0.1) * 1.5;
	sig = HPF.ar(impulse + noise, 60);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 3, pan);
	Out.ar(out, sig);
}).add;


// Upper register noise texture
SynthDef(\upper, {
	|out=0, amp=0.3, freq=1000, atk=0.1, rel=0.5, entropy=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = SinOsc.ar(freq / 12, 0.3) * 0.5;
	sig = sig + RLPF.ar(Impulse.ar(freq / 10), freq / 5, 0.1) * 0.5;
	sig = sig + HPF.ar(Dust.ar(freq), freq) * 0.5 * 0.01;
	sig = sig + HPF.ar(PinkNoise.ar(0.4), freq * 2) * 0.5;
	sig = sig * LFNoise2.ar(100 * entropy, 0.5, 0.5).clip(1 - entropy, 1.0);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 2, pan);
	Out.ar(out, sig);
}).add;

// Basic synths for examples

SynthDef(\sine_simple, {
	|out=0, amp=0.1, freq=440, rel=0.2, pan=0|
	var env, sig;
	env = EnvGen.kr(Env.perc(releaseTime:rel), doneAction:2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\saw_simple, {
	|out=0, freq=440, rel=0.5, lop=2000, res=0.5, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction:2);
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

SynthDef(\monosaw, {
	|out=0, freq=440, lop=2000, res=0.5, amp=0.2, pan=0, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 0.1), gate, doneAction:2);
	sig = Saw.ar(freq) * amp;
	sig = BLowPass4.ar(sig, lop, res);
	Out.ar(out, Pan2.ar(sig, pan, env));
}).add;

SynthDef(\monosine, {
	|out=0, freq=440, amp=0.2, pan=0, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 0.1), gate);
	sig = SinOsc.ar(freq) * amp * env;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;

"## Synths loaded successfully".postln;

)


////////////////////////////////////////////////////////////////
//                    TEST SYNTHS
////////////////////////////////////////////////////////////////

// Basic synthesis
Synth(\sine, [\freq, 440]);
Synth(\saw, [\freq, 220, \cutoff, 1000, \res, 0.3]);
Synth(\square, [\freq, 330, \cutoff, 1500]);
Synth(\pulse, [\freq, 110, \width, 0.7]);
Synth(\tri, [\freq, 165, \detune, 0.3]);
Synth(\add, [\freq, 220, \numharm, 6, \brightness, 0.6]);

// Noise-based
Synth(\white, [\freq, 2000, \bw, 0.3]);
Synth(\pink, [\freq, 800, \bw, 0.5]);
Synth(\dust, [\freq, 1500, \density, 50]);
Synth(\crackle, [\freq, 1000, \chaos, 1.8]);

// FM & modulation
Synth(\fm, [\freq, 100, \mod, 3]);
Synth(\fmgrain, [\freq, 150, \mod, 0.6]);
Synth(\plip, [\freq, 300, \mod, 0.7]);

// Waveshaping & feedback
Synth(\sinefb, [\freq, 200, \feedback, 0.8]);
Synth(\fold, [\freq, 220, \foldfreq, 400]);

// Chaotic & algorithmic
Synth(\brown, [\freq, 400, \mod, 0.8]);
Synth(\chaos, [\freq, 250, \entropy, 0.6]);
Synth(\gbman, [\freq, 180, \chaos, 0.5]);

// Textural
Synth(\grain, [\freq, 800, \rate, 15]);
Synth(\upper, [\freq, 1200, \entropy, 0.7]);


////////////////////////////////////////////////////////////////
//                  PARAMETER REFERENCE
////////////////////////////////////////////////////////////////

/*
BASIC SYNTHESIS:
\sine     - Simple sine tone
\saw      - cutoff: 100-8000, res: 0.1-1.0
\square   - cutoff: 100-8000, res: 0.1-1.0
\pulse    - width: 0.1-0.9, cutoff: 100-8000
\tri      - detune: 0.0-1.0
\add      - numharm: 1-16, brightness: 0.0-1.0

NOISE-BASED:
\white    - freq: 100-8000, bw: 0.1-1.0
\pink     - freq: 100-8000, bw: 0.1-1.0
\dust     - freq: 100-8000, density: 10-500
\crackle  - freq: 100-8000, chaos: 1.0-2.0

FM & MODULATION:
\fm       - freq: 20-500, mod: 0.1-10.0
\fmgrain  - freq: 50-800, mod: 0.0-1.0
\plip     - freq: 100-1000, mod: 0.0-1.0

WAVESHAPING & FEEDBACK:
\sinefb   - freq: 50-1000, feedback: 0.1-0.9
\fold     - freq: 50-1000, foldfreq: 20-1000

CHAOTIC & ALGORITHMIC:
\brown    - freq: 100-2000, mod: 0.0-1.0
\chaos    - freq: 50-1000, entropy: 0.0-1.0
\gbman    - freq: 50-1000, chaos: 0.0-1.0

TEXTURAL:
\grain    - freq: 200-2000, rate: 1-50
\upper    - freq: 500-4000, entropy: 0.0-1.0

Common ranges:
- amp: 0.0 to 1.0
- freq: see specific ranges above
- atk: 0.001 to 2.0 seconds
- rel: 0.001 to 2.0 seconds
- pan: -1.0 to 1.0
*/
