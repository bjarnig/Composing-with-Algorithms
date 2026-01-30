////////////////////////////////////////////////////////////////
//
//           Synthetic SynthDef Collection
//           Gated Envelopes (Env.adsr / Env.asr)
//
////////////////////////////////////////////////////////////////

// This collection contains only synthetic (non-sample-based) SynthDefs
// with gated envelopes suitable for pattern-based composition.
//
// All SynthDefs use gate parameter with doneAction:2 for proper cleanup.
// Common parameters: out, amp, freq, pan, gate, atk, dec, sus, rel

(

"Loading SynthDef collection...".postln;


////////////////////////////////////////////////////////////////
//                  1. BASIC SYNTHESIS
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


// Triangle wave with detuning (additive)
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
	partials = Array.fill(maxHarm, { |i|
		var harmNum = i + 1;
		var ampScale = (1 / harmNum) * (1 - (brightness * (harmNum - 1) / maxHarm));
		var active = (harmNum <= numharm);
		SinOsc.ar(freq * harmNum, 0, ampScale * active)
	});
	sig = Mix.ar(partials) / maxHarm.sqrt;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Blip/Buzz (band-limited pulse with harmonics)
SynthDef(\blip, {
	|out=0, amp=0.3, freq=200, atk=0.01, rel=0.3, harmonics=10, pan=0.0, gate=1.0|
	var sig, env;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate, doneAction: 2);
	sig = Blip.ar(freq, harmonics) * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;


////////////////////////////////////////////////////////////////
//                  2. NOISE-BASED
////////////////////////////////////////////////////////////////


// White noise with bandpass filter
SynthDef(\white, {
	|out=0, amp=0.2, freq=1000, atk=0.01, rel=0.3, bw=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = WhiteNoise.ar();
	sig = BPF.ar(sig, freq, bw);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 8, pan);
	Out.ar(out, sig);
}).add;


// Pink noise with bandpass filter
SynthDef(\pink, {
	|out=0, amp=0.2, freq=1000, atk=0.01, rel=0.3, bw=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = PinkNoise.ar();
	sig = BPF.ar(sig, freq, bw);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 8, pan);
	Out.ar(out, sig);
}).add;


// Brown noise with resonant filter
SynthDef(\brown, {
	|out=0, amp=0.2, freq=1000, atk=0.01, rel=0.3, res=0.1, pan=0.0, gate=1.0|
	var sig, env;
	sig = BrownNoise.ar();
	sig = RLPF.ar(sig, freq, res);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 4, pan);
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
//                  3. FM & MODULATION
////////////////////////////////////////////////////////////////


// Simple FM using PMOsc (Phase Modulation)
SynthDef(\fm, {
	|out=0, amp=0.3, freq=400, atk=0.01, rel=0.3, cmRatio=1.5, index=3, pan=0.0, gate=1.0|
	var signal, modFreq, env;
	modFreq = freq * cmRatio.reciprocal;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate, doneAction: 2);
	signal = PMOsc.ar(freq, modFreq, index) * env * amp;
	Out.ar(out, Pan2.ar(signal, pan));
}).add;


// 4-operator FM
SynthDef(\fm4op, {
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


// Multi-operator FM with cascading modulators
SynthDef(\fmCascade, {
	|out=0, freq=400, atk=0.01, rel=0.3,
	modFreq1=100, modIndex1=5,
	modFreq2=200, modIndex2=3,
	modFreq3=50, modIndex3=2,
	amp=0.3, pan=0, gate=1|
	var carrier, mod1, mod2, mod3, env;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate, doneAction: 2);
	mod3 = SinOsc.ar(modFreq3, mul: modIndex3 * modFreq3);
	mod2 = SinOsc.ar(modFreq2 + mod3, mul: modIndex2 * modFreq2);
	mod1 = SinOsc.ar(modFreq1 + mod2, mul: modIndex1 * modFreq1);
	carrier = SinOsc.ar(freq + mod1) * env * amp;
	Out.ar(out, Pan2.ar(carrier, pan));
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
//                  4. WAVESHAPING & FEEDBACK
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


// Blip with waveshaping (fold distortion)
SynthDef(\fold, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, foldfreq=300, pan=0.0, gate=1.0|
	var sig, env;
	sig = Blip.ar(freq, 80).fold2(SinOsc.ar(foldfreq));
	sig = RLPF.ar(sig, freq * 8, 0.5);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Saw with waveshaping
SynthDef(\sawfold, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, fold=0.5, pan=0.0, gate=1.0|
	var sig, env;
	sig = Saw.ar(freq);
	sig = sig.fold2(fold);
	sig = RLPF.ar(sig, freq * 4, 0.5);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  5. CHAOTIC & ALGORITHMIC
////////////////////////////////////////////////////////////////


// Gingerbreadman chaotic oscillator
SynthDef(\gbman, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, chaos=0.5, lop=18000, loprq=1, pan=0.0, gate=1.0|
	var sig, env, chaosFreq;
	chaosFreq = GbmanL.ar(freq / 4).range(freq / 2, freq);
	sig = Saw.ar(Lag.ar(chaosFreq, chaos * 0.1));
	sig = BBandStop.ar(sig, freq * 2, 2);
	sig = RLPF.ar(sig, lop, loprq);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Henon chaotic oscillator with filter sweep
SynthDef(\henon, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, rate=100, pan=0.0, gate=1.0|
	var sig, env, chaosFreq;
	chaosFreq = HenonN.ar(rate).range(freq * 0.5, freq * 2);
	sig = Pulse.ar(chaosFreq, 0.5);
	sig = RLPF.ar(sig, chaosFreq * 2, 0.3);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Standard Map chaotic modulation
SynthDef(\standard, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, rate=1000, pan=0.0, gate=1.0|
	var sig, env, chaos;
	chaos = StandardL.ar(rate).range(freq, freq * 4);
	sig = Blip.ar(chaos, 20);
	sig = RLPF.ar(sig, chaos * 2, 0.5);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 0.5, pan);
	Out.ar(out, sig);
}).add;


// Lorenz chaotic system with filtering
SynthDef(\lorenz, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, rate=4000, pan=0.0, gate=1.0|
	var sig, env, x, y, z;
	#x, y, z = LorenzL.ar(rate);
	sig = SinOsc.ar(x.range(freq * 0.5, freq * 2));
	sig = RLPF.ar(sig, y.range(freq, freq * 8), z.range(0.1, 0.9));
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Brownian pitch modulation
SynthDef(\brownpitch, {
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
SynthDef(\chaosimpulse, {
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


////////////////////////////////////////////////////////////////
//                  6. PHYSICAL MODELING
////////////////////////////////////////////////////////////////


// Karplus-Strong plucked string
SynthDef(\pluck, {
	|out=0, amp=0.3, freq=440, atk=0.001, rel=2.0, coef=0.1, pan=0.0, gate=1.0|
	var sig, env, noise, delay;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate, doneAction:2);
	delay = freq.reciprocal;
	noise = WhiteNoise.ar(amp);
	sig = Pluck.ar(in: noise, delaytime: delay, decaytime: rel, coef: coef);
	sig = Pan2.ar(sig * env * 0.5, pan);
	Out.ar(out, sig);
}).add;


// Resonant filter bank (modal synthesis)
SynthDef(\modal, {
	|out=0, amp=0.3, freq=200, atk=0.01, rel=0.5, strike=0.1, pan=0.0, gate=1.0|
	var sig, env, exciter;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	exciter = WhiteNoise.ar(Decay2.ar(Impulse.ar(0.1), 0.001, strike));
	sig = DynKlank.ar(
		`[[freq, freq * 2.13, freq * 3.76, freq * 5.41],
		  [1, 0.5, 0.3, 0.2],
		  [1, 0.8, 0.6, 0.4]],
		exciter
	);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Formant synthesis
SynthDef(\formant, {
	|out=0, amp=0.3, freq=100, atk=0.1, rel=0.5, form1=800, form2=1200, form3=2400, pan=0.0, gate=1.0|
	var sig, env, source;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	source = Saw.ar(freq);
	sig = Formlet.ar(source, form1, 0.004, 0.2, 0.3);
	sig = sig + Formlet.ar(source, form2, 0.004, 0.2, 0.3);
	sig = sig + Formlet.ar(source, form3, 0.004, 0.2, 0.2);
	sig = Pan2.ar(sig * env * amp * 0.5, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  7. TEXTURAL & COMPLEX
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


// Metallic resonance
SynthDef(\metal, {
	|out=0, amp=0.3, freq=200, atk=0.01, rel=0.5, decay=1.0, pan=0.0, gate=1.0|
	var sig, env, exciter;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	exciter = Impulse.ar(0.1) * 0.3;
	sig = Klank.ar(
		`[[freq, freq * 2.76, freq * 5.4, freq * 8.93, freq * 11.34],
		  [1, 0.4, 0.3, 0.2, 0.1] * 0.02,
		  [decay, decay * 0.8, decay * 0.6, decay * 0.4, decay * 0.3]],
		exciter
	);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  8. GENDY (STOCHASTIC)
////////////////////////////////////////////////////////////////


// Gendy1 - basic stochastic waveform
SynthDef(\gendy, {
	|out=0, amp=0.3, freq=100, atk=0.1, rel=0.5, minfreq=50, maxfreq=500, pan=0.0, gate=1.0|
	var sig, env;
	sig = Gendy1.ar(minfreq: minfreq, maxfreq: maxfreq);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 0.5, pan);
	Out.ar(out, sig);
}).add;


// Gendy3 - frequency-locked stochastic
SynthDef(\gendy3, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, durscale=0.1, knum=12, pan=0.0, gate=1.0|
	var sig, env;
	sig = Gendy3.ar(freq: freq, durscale: durscale, knum: knum);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 0.5, pan);
	Out.ar(out, sig);
}).add;


// Gendy with resonator
SynthDef(\gendyres, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, minfreq=20, maxfreq=200, pan=0.0, gate=1.0|
	var sig, env, gen;
	gen = Gendy1.ar(minfreq: minfreq, maxfreq: maxfreq, mul: 0.1);
	sig = Ringz.ar(gen, [freq, freq * 2, freq * 4, freq * 8], 0.05);
	sig = Mix.ar(sig);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  9. FILTERS AS OSCILLATORS
////////////////////////////////////////////////////////////////


// Self-oscillating resonant filter
SynthDef(\resself, {
	|out=0, amp=0.3, freq=440, atk=0.1, rel=0.5, drive=10, pan=0.0, gate=1.0|
	var sig, env;
	sig = RLPF.ar(WhiteNoise.ar(0.001), freq, 0.01) * drive;
	sig = sig.tanh;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Dual resonator
SynthDef(\dualres, {
	|out=0, amp=0.3, freq=440, atk=0.1, rel=0.5, freq2=880, res=0.05, pan=0.0, gate=1.0|
	var sig, env, noise;
	noise = WhiteNoise.ar(0.05);
	sig = Resonz.ar(noise, freq, res) + Resonz.ar(noise, freq2, res);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 4, pan);
	Out.ar(out, sig);
}).add;


// Formlet cascade
SynthDef(\formcascade, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, dens=100, pan=0.0, gate=1.0|
	var sig, env, source;
	source = Dust.ar(dens);
	sig = Formlet.ar(source, freq, 0.01, 0.1);
	sig = sig + Formlet.ar(source, freq * 2.1, 0.01, 0.08);
	sig = sig + Formlet.ar(source, freq * 3.7, 0.01, 0.06);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp * 2, pan);
	Out.ar(out, sig);
}).add;


////////////////////////////////////////////////////////////////
//                  10. COMPOSITE & LAYERED
////////////////////////////////////////////////////////////////


// Multi-oscillator stack
SynthDef(\stack, {
	|out=0, amp=0.3, freq=100, atk=0.1, rel=0.5, detune=0.02, pan=0.0, gate=1.0|
	var sig, env;
	sig = Saw.ar(freq * [1, 1 + detune, 1 - detune, 1 + (detune * 2)]);
	sig = Mix.ar(sig) * 0.25;
	sig = RLPF.ar(sig, freq * 8, 0.5);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Harmonic drone
SynthDef(\drone, {
	|out=0, amp=0.3, freq=100, atk=1.0, rel=1.0, drift=0.1, pan=0.0, gate=1.0|
	var sig, env;
	sig = Mix.ar(
		SinOsc.ar(
			freq * [1, 2, 3, 4, 5, 7, 9] * LFNoise1.kr([0.1, 0.2, 0.15, 0.3, 0.25, 0.2, 0.1]).range(1 - drift, 1 + drift),
			mul: [1, 0.5, 0.3, 0.2, 0.15, 0.1, 0.05]
		)
	) * 0.2;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


// Ring modulation
SynthDef(\ring, {
	|out=0, amp=0.3, freq=200, atk=0.1, rel=0.5, modfreq=50, pan=0.0, gate=1.0|
	var sig, env, carrier, modulator;
	carrier = Saw.ar(freq);
	modulator = SinOsc.ar(modfreq);
	sig = carrier * modulator;
	sig = RLPF.ar(sig, freq * 4, 0.5);
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;


"SynthDef collection loaded successfully!".postln;
"Total: 50 synthetic SynthDefs with gated envelopes".postln;

)


////////////////////////////////////////////////////////////////
//                    USAGE EXAMPLES
////////////////////////////////////////////////////////////////

/*

// Test individual synths
x = Synth(\sine, [\freq, 440]);
x.set(\gate, 0);  // Release

x = Synth(\gbman, [\freq, 200, \chaos, 0.7]);
x.set(\gate, 0);

x = Synth(\fm4op, [\freq, 100, \mod, 4]);
x.set(\gate, 0);


// Use with patterns
(
Pbind(
	\instrument, \saw,
	\midinote, Pwhite(36, 72),
	\cutoff, Pexprand(800, 4000),
	\res, 0.3,
	\dur, 0.125,
	\legato, 0.8
).play;
)

(
Pbind(
	\instrument, \fm,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\cmRatio, Pwhite(1.0, 3.0),
	\index, Pwhite(2, 8),
	\dur, 0.25,
	\legato, 0.5
).play;
)

(
Pbind(
	\instrument, \gendy3,
	\freq, Pexprand(100, 800),
	\durscale, Pwhite(0.05, 0.3),
	\knum, Pwhite(4, 20),
	\dur, Pexprand(0.1, 0.5),
	\legato, 0.6
).play;
)


// Pmono for continuous pitch changes
(
Pmono(\monosaw,
	\midinote, Pseq([60, 64, 67, 72, 67, 64], inf),
	\cutoff, Pseg(Pseq([500, 3000], inf), 4, \exp),
	\dur, 0.25
).play;
)

*/
