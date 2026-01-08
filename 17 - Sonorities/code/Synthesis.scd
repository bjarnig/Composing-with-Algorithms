////////////////////////////////////////////////////////////////
//
//                        Synthesis
//
////////////////////////////////////////////////////////////////


( // Resonating Impulses

SynthDef(\resImpulse, {|length=5, rate=10, freq=80, amp=1.0, klank=100, decay=0.4, geom=2|
	var sig, res, env, times=8;

	sig = Impulse.ar(rate, 0, 0.2);
	env = EnvGen.ar(Env.linen(length, length, length), doneAction: 2);

	res = Splay.ar(
		Resonz.ar(Array.fill(times, {
			DynKlank.ar(`[
				Array.series(times, klank, 10), nil,
				Array.series(times, decay, decay)
			], sig);
		}), freq * Array.geom(times, 0.25, 2), 0.1)
	);

	Out.ar(0, (res * env) * amp)
}).add

)

Synth(\resImpulse, [\rate, 5, \freq, 50, \decay, 0.2, \klank, 50, \geom, 4, \amp, 0.5])

Synth(\resImpulse, [\rate, 25, \freq, 700, \decay, 0.1, \klank, 500, \geom, 10, \amp, 0.5])

(

Pmono(
	\resImpulse,
	\dur, Pwhite(0.5, 1.0),
	\rate, Pwhite(1, 25),
	\freq, Pwhite(500, 1500),
	\amp, Pwhite(0.1, 1.1),
	\klank, Pwhite(75, 125)
).play

)

(

Pbind(
	\instrument, \resImpulse,
	\rate, Pwhite(2, 20),
	\dur, Pwhite(3, 4),
	\length, Pwhite(4, 5),
	\freq, Pwhite(80, 150),
	\decay, Pwhite(0.2, 0.6),
	\klank, Pwhite(100, 200),
	\geom, Pwhite(2, 6),
	\amp, Penv([0.5, 1, 1, 0], [5, 15, 5])
).play

)

// High (and very low) sine wave pulsation

(

SynthDef(\highSines, {|length=10, freq=8000, amp=1.0, rate=10, modFreq=2, modAmp=0.1, envDur=2|
	var sig, env, trig, trigEnv;

	sig = SinOsc.ar(freq, mul: amp);
	trig = Impulse.ar(rate * LFNoise1.ar(freq: modFreq, add: 1, mul: modAmp));
	trigEnv = EnvGen.ar(Env.new([0, 1, envDur/10, 0], [envDur/100, envDur/100, 2]), trig);
	env = EnvGen.ar(Env.linen(length/100, length, length/10, 1, \sine));
	sig = Pan2.ar(sig * trigEnv, 0) * env;

	Out.ar(0, sig)
}).add

)

Synth(\highSines, [\amp, 0.3, \envDur, 1])

Synth(\highSines, [\freq, 60, \amp, 0.75, \envDur, 0.5, \modAmp, 0.1])

(
Synth(\highSines, [\freq, 60, \amp, 0.5, \rate, 5]);
Synth(\highSines, [\freq, 3000, \amp, 0.1, \rate, 20])
)

(
Pbind(
	\instrument, \highSines,
	\freq, Pwhite(8000, 12000),
	\rate, Pbeta(5, 20, 0.6, 0.4),
	\dur, Pwhite(1, 3),
	\length, Pwhite(6, 8),
	\amp, 0.1
).play
)


// Exp Sine Wave Clusters

(

SynthDef(\phasePerc, {|amp=1, gate=1, freqLo=120, freqHi=1000, del=0.001, dec=0.05, modFreq=0.01|
	var signal, effect, times = 20;

	signal = AllpassN.ar(
		SinOsc.ar({ ExpRand(freqLo, freqHi) }.dup(times), 1.5),
		del, del, dec
	) * 0.1;

	signal = Splay.ar(signal) * Linen.kr(gate, susLevel: amp, releaseTime: 0.01, doneAction: 2);
	effect = HPF.ar(CombN.ar(signal, 0.1, LFNoise1.ar(modFreq).range(0.001, 0.1), dec), 100);

	Out.ar(0, signal + effect)
}).add

)

Synth(\phasePerc, [\freqLo, 20, \freqHi, 2000])

Synth(\phasePerc, [\freqLo, 100, \freqHi, 1000, \modFreq, 10])

(
Synth(\phasePerc, [\freqLo, 50, \freqHi, 150]);
Synth(\phasePerc, [\freqLo, 4500, \freqHi, 5000])
)

(
Pbind(
	\instrument, \phasePerc,
	\dur, 0.05,
	\freqLo, Pseq([Pwhite(8000, 10000, 32), Pwhite(80, 100, 64)], inf),
	\freqHi, Pseq([Pwhite(10000, 12000, 32), Pwhite(100, 120, 64)], inf),
	\amp, Pwhite(0.3, 1, inf)
).play
)


// Variable Looper

~loopBuf = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/sounds/catbike.wav")

(

SynthDef(\varLooper, {|buffer, length=1, startPos=0.0, endPos=0.5, winSize=0.5, amp=0.5|
	var loopDur, loopFreq, trigger, window, env, pos, sig, bufDur, start, end;

	bufDur = BufDur.ir(buffer) * SampleRate.ir;
	start = bufDur * startPos;
	end = bufDur * endPos;
	loopDur = (end - start);
	loopFreq = (SampleRate.ir / abs(loopDur));
	trigger = Impulse.kr(loopFreq);
	window = EnvGen.kr(Env.linen(winSize, loopFreq.reciprocal - winSize, winSize), trigger);
	pos = Phasor.ar(trigger, 1, start, end);
	sig = BufRd.ar(1, buffer, pos, loop: 0) * window * amp;
	sig = sig * EnvGen.kr(Env.linen(0.01, length, 0.01), doneAction: 2);

	Out.ar(0, sig ! 2)
}).add

)

(

Synth(\varLooper, [\buffer, ~loopBuf, \length, 5, \startPos, 0.66, \endPos, 0.767, \winSize, 0.01]);
Synth(\varLooper, [\buffer, ~loopBuf, \length, 10, \startPos, 0.84, \endPos, 0.845, \amp, 0.8])

)

(

Pbind(
	\instrument, \varLooper,
	\buffer, ~loopBuf,
	\startPos, Pwhite(0.11, 0.115),
	\endPos, Pwhite(0.12, 0.125),
	\amp, 0.5,
	\dur, 0.1,
	\length, 2
).play

)


// Filtered LPC Error

(

SynthDef(\lpcError, {|frequencyA=100, frequencyB=1000, lop=18000, hip=20, lopVol=0.5, hipVol=0.5, pan=0.0, entropy=14, length=5, amp=0.5|
	var signal;

	signal = Resonz.ar(Mix(Saw.ar(frequencyA * [1, 0.9, 0.8, 0.7, 0.5])), frequencyB, 0.1, 2);
	signal = (signal * 0.0) + LPCError.ar(signal, entropy) * 0.3;
	signal = BLowPass4.ar(signal, lop, 0.25, mul: lopVol) + BHiPass4.ar(signal, hip, 0.25, mul: hipVol);
	signal = Pan2.ar(signal, pan) * amp;
	signal = signal * EnvGen.ar(Env([0, 1, 1, 0], [length/3, length/3, length/3]), doneAction: 2);

	Out.ar(0, signal)
}).add

)

Synth(\lpcError, [\entropy, 4.6, \frequencyA, 400, \frequencyB, 800, \lop, 18280, \hip, 0])

Synth(\lpcError, [\entropy, 4.6, \frequencyA, 100, \frequencyB, 500, \lop, 8280, \hip, 100])

(
Pbind(
	\instrument, \lpcError,
	\frequencyA, Pwhite(100, 1000),
	\frequencyB, Pwhite(400, 600),
	\dur, Pwhite(2, 8),
	\length, Pwhite(6, 8),
	\entropy, Pwhite(2, 20),
	\amp, 1.5
).play
)


// Resonating Crackles

(

SynthDef(\crackleReso, {|start=85, distance=100, length=10, amp=1.0|
	var ex, sig, number=20;

	ex = Crackle.ar(Line.kr(1.0, 2.0, 3), 0.5, 0.5) * 0.02;
	sig = Pan2.ar(
		Klank.ar(`[Array.series(number, start, distance), Array.series(number, 1.0, -0.05)], ex),
		0
	);
	sig = sig * EnvGen.ar(Env([0, 1, 0], [length/2, length/2]), doneAction: 2) * amp;

	Out.ar(0, sig)
}).add

)

Synth(\crackleReso)

(

Pbind(
	\instrument, \crackleReso,
	\start, Pwhite(100, 1000),
	\distance, Pwhite(10, 20),
	\dur, Pwhite(2, 8),
	\length, Pwhite(6, 8),
	\amp, 0.8
).play

)


// Chaotics selection into amplitude following reverb

(

SynthDef(\chaos1, {|outBus=0, amp=0.5, atk=0.5, sus=10, rel=0.1, entropy=0.2, entropyB=0.5,
	frequencyA=80, frequencyB=80, lop=18000, hip=20, lopVol=0.5, hipVol=0.5, pan=0.0,
	envTime=0.8, envShape=2, osc=0,
	durations=#[1.5, 1, 2, 4, 0.5, 1], amplitudes=#[0.1, 1.0, 0.2, 1.0, 0.1, 0.9, 0.1]|

	var signal, gbEntropy;
	var env = EnvGen.kr(Env.new([0, 1, 1, 0], [atk, sus, rel], -2), doneAction: 2);

	gbEntropy = (frequencyB * 0.25) * entropyB;

	signal = Select.ar(osc, [
		StandardL.ar(frequencyA, entropy) + StandardL.ar(frequencyA * 0.5, entropy),
		(GbmanN.ar(frequencyB + LFNoise1.kr(100, gbEntropy, 1.0)) +
			GbmanN.ar((frequencyB * 0.5) + LFNoise1.kr(100, gbEntropy, 1.0))) * 0.6
	]);

	signal = signal * env;
	signal = BLowPass4.ar(signal, lop, 0.25, mul: lopVol) + BHiPass4.ar(signal, hip, 0.25, mul: hipVol);
	signal = signal * EnvGen.kr(Env.new(amplitudes, durations, [envShape, envShape * (-1)]).circle, timeScale: envTime);
	signal = BBandStop.ar(signal, 1000, EnvGen.kr(Env.new(amplitudes * 10, durations.reverse, [envShape, envShape * (-1)]).circle, timeScale: envTime));
	signal = Pan2.ar(signal * amp, pan);

	Out.ar(outBus, signal)
}).add;

SynthDef(\chaos1Verb, {|dryWet=0.2, inBus=0, outBus=2|
	var output, signal, effect, verb, controlSig, ampFollow;

	signal = In.ar(inBus, 2);
	ampFollow = Amplitude.kr(HPF.ar(signal, 4000), 1, 4, mul: 40, add: 0.0);
	controlSig = Lag.kr(ampFollow, 14).clip2(1.0);
	effect = GVerb.ar(signal, roomsize: 40, revtime: 4, damping: 0.2, spread: 0.5, drylevel: 0.5, earlyreflevel: 0.1, taillevel: 0.3);
	verb = (effect * controlSig) + (signal * (controlSig - 1));
	output = (verb * dryWet) + (signal * (1 - dryWet));

	Out.ar(outBus, output)
}).add

)

Synth(\chaos1Verb, [\inBus, 20, \outBus, 0, \dryWet, 0.4])

Synth(\chaos1, [\osc, 0, \outBus, 20, \entropyB, 0.9, \entropy, 2.6, \frequencyA, 8050, \lop, 8280, \hip, 0, \lopVol, 1, \hipVol, 0, \envShape, 20.1])

Synth(\chaos1, [\osc, 1, \outBus, 20, \entropyB, 0.9, \entropy, 2.6, \frequencyB, 8050, \lop, 8280, \hip, 0, \lopVol, 1, \hipVol, 0, \envShape, 20.1])



// Small-step brownian motion for pitch

(

SynthDef(\uBrown, {|amp=0.2, note=60, atk=0.1, sus=0.5, rel=0.5, mod=0.8, pos=0.125|
	var sig, env, pan, brown, freq, trig, base;

	base = note * 25;
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, sus, rel]), levelScale: amp, doneAction: 2);
	brown = Dbrown(base, base + 100, 100, inf);
	trig = Impulse.kr(500);
	freq = Demand.kr(trig, 0, brown);
	sig = Impulse.ar(freq) ! 2 * 0.2;
	pan = PanX.ar(8, sig * env, pos, 1.0, 2);

	Out.ar(0, pan)
}).add

)

Synth(\uBrown, [\note, 50, \sus, 10, \amp, 1.5])

(
Pbind(
	\instrument, \uBrown,
	\note, Pwhite(10, 100),
	\sus, Pwhite(6, 8),
	\dur, Pwhite(2, 8),
	\amp, 1.5
).play
)


// Combined synthesis

(

SynthDef(\combi, {|outBus=0, atk=0.1, sus=5, rel=4, speed=0.11, density=0.8525, pan=0.1,
	entropy=0.071, amp=0.74, freqA=80, freqB=52, freqBFilter=200, freqC=1200, freqD=2000,
	ampA=0.5, ampB=0.5, ampC=0.5, ampD=0.5|

	var osca, oscb, oscc, oscd, signal, output, env;

	env = EnvGen.kr(Env.new([0, 1, 1, 0], [atk, sus, rel]), doneAction: 2);
	osca = SinOsc.ar(freqA, 0.3) * ampA;
	oscb = RLPF.ar(Impulse.ar(freqB, mul: 0.5), freqBFilter, 0.1) * ampB;
	oscc = HPF.ar(Dust.ar(180.5), freqC) * ampC;
	oscd = HPF.ar(PinkNoise.ar(0.5), freqD) * ampD;
	signal = osca + oscb + oscc + oscd;
	signal = (signal * LFGauss.ar(speed, density, 0, 1)) * 1.5;
	signal = signal * LFNoise2.ar(100 * entropy, 0.5, 0.5).min(1.0).max(1 - entropy);
	signal = signal * env;
	output = Pan2.ar(signal, pan) * amp;

	Out.ar(outBus, output)
}).add

)

Synth(\combi)

(

Pbind(
	\instrument, \combi,
	\density, Pwhite(0.0, 1.0),
	\entropy, Pwhite(0.0, 1.0),
	\freqA, Pwhite(20, 200),
	\freqB, Pwhite(20, 200),
	\freqC, Pwhite(1000, 2000),
	\freqD, Pwhite(1000, 200),
	\dur, Pwhite(2, 6),
	\amp, 0.8
).play

)


// Modulating Position for Granular Synthesis

~grainBuf = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/sounds/branches.wav")

(

SynthDef(\grainPos, {|buf=0, amp=0.2, note=60, atk=0.01, sus=0.5, rel=0.5, mod=0.5, pos=0.25|
	var sig, rate, env, trig, scale, stretch=5 * mod, times=10;

	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, sus, rel]), levelScale: amp, doneAction: 2);
	rate = (note / 60.0);
	trig = Impulse.kr(100 * mod);
	scale = 1/times;

	sig = Mix.fill(times, {
		TGrains.ar(2, trig, buf, rate,
			EnvGen.kr(Env([mod.rand, BufDur.kr(buf)], [BufDur.kr(buf) * stretch]).circle)
			+ TRand.kr(0, 0.01, trig),
			0.1, TRand.kr(-1, 1, trig), scale, 1
		)
	});

	OffsetOut.ar(0, sig)
}).add

)

Synth(\grainPos, [\buf, ~grainBuf, \sus, 10, \mod, 1.2, \note, 80])
