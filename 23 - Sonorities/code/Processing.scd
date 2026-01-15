////////////////////////////////////////////////////////////////
//
//                        Processing
//
////////////////////////////////////////////////////////////////


(

// Files & Test Setup

~path = thisProcess.nowExecutingPath.dirname;
~files = SoundFile.collect(~path ++ "/sounds/*");
~buffers = ~files.collect { |sf| Buffer.read(Server.local, sf.path) };

s = Server.default;

SynthDef(\testSampler, {|out=0, buf=0|
	var signal;
	signal = PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop: 1, doneAction: 2);
	Out.ar(out, signal ! 2);
}).add;

~testEffect = {|effect, args|
	var bus, effectArgs;

	Routine({
		effect.add;
		s.sync;

		bus = Bus.audio(Server.local, 2);
		effectArgs = [\in, bus, \out, 0].addAll(args);
		Synth(effect.name, effectArgs);
		Synth(\testSampler, [\out, bus, \buf, ~buffers[0]]);
	}).play
};

)


//////////////////////// Processing /////////////////////////


( // Dual Distortion

~testEffect.value(
	SynthDef(\dualDistortion, {|in=0, out=0, lpf=200, hpf=6000, gaina=1000, gainb=200|
		var sig = In.ar(in, 2);
		sig = HPF.ar(SoftClipAmp8.ar(sig, pregain: gaina) * 0.2, hpf) +
			LPF.ar(SoftClipAmp8.ar(sig, pregain: gainb) * 0.2, lpf);
		Out.ar(out, sig)
	}))

)


( // Binary Op Distortion

~testEffect.value(
	SynthDef(\binaryOpDistortion, {|in=0, out=0, modFreq=15|
		var sig = In.ar(in, 2);
		sig = LeastChange.ar(sig, SinOsc.ar(modFreq));
		sig = sig.thresh(Crackle.ar(0.8));
		sig = sig.scaleneg(LFSaw.ar(10 * SinOsc.kr(modFreq/100, 0.5, 0.5)));
		Out.ar(out, sig * 0.3)
	}))

)


( // Pitch Shifter + Paralell Combs

~testEffect.value(
	SynthDef(\combShift, {|in=0, out=0, rate1=0.25, grSize=0.1, rate2=4, dispersion=0.5|
		var sig, effect, shift1, shift2, times=10, delay=0.07, decay=1.5;
		sig = In.ar(in, 2);
		shift1 = PitchShift.ar(sig, grSize, rate1, dispersion, dispersion);
		shift2 = PitchShift.ar(sig, grSize, rate2, dispersion, dispersion);
		effect = shift1 + shift2;
		effect = Mix.fill(times, {
			CombC.ar(effect.tanh, delay, rrand(delay/1, delay), decay) * 1/times
		});
		Out.ar(out, effect)
	}))
)


( // Fb Feedback with Bandpass filter

~testEffect.value(
	SynthDef(\filterFeedback, {|in=0, out=0, feedback=0.98, delay=0.1|
		var sig, effect;
		sig = In.ar(in, 2);
		effect = Fb({|fbSig|
			BPF.ar(fbSig * feedback + sig, LFNoise1.ar(5).range(100,1000), 4).round(0.01);
		}, 2, EnvGen.ar(Env([1.8, 0.1], [20], [-5]).circle));
		Out.ar(out, Limiter.ar(effect))
	}))

)


( // LocalIn + LocalOut with FreqShift

~testEffect.value(
	SynthDef(\freqShift, {|in=0, out=0, feedback=0.4, delay=0.2, shiftFreq=2000, shiftDens=0.1|
		var sig, effect;
		sig = In.ar(in, 2);
		effect = sig + LocalIn.ar(2);
		effect = FreqShift.ar(effect, LFNoise2.ar(shiftDens, shiftFreq));
		effect = DelayC.ar(effect, delay, SinOsc.ar(10).range(0.1, 0.2));
		LocalOut.ar(effect * feedback);
		Out.ar(out, effect)
	}))

)


( // Amplitude follow that controls an array of Pulse oscillators (vocode-like)

~testEffect.value(
	SynthDef(\crossPulse, {|in=0, out=0, freq=500|
		var sig, osc, verb, thres;
		sig = In.ar(in, 2);
		thres = Lag.kr(Amplitude.kr(sig), 0.1);
		osc = Splay.ar(Pulse.ar(Array.series(10, freq, 5))) * thres;
		verb = Mix.ar(Array.fill(10, { CombL.ar(osc, 0.05, rrand(0.02, 0.04), 10.rand) }));
		Out.ar(out, osc + (verb * 0.5))
	}))

)


( // Track Pitch and Amplitude for an array of VarSaws with serial Allpass filters

~testEffect.value(
	SynthDef(\pitchTrack, {|in=0, out=0|
		var sig, effect, amp, freq, hasFreq;
		sig = In.ar(in, 1) * 2;
		amp = Amplitude.kr(sig, 0.05, 0.05);
		#freq, hasFreq = Tartini.kr(sig, 0.93, 1024, 512, 512);
		effect = Mix.new(VarSaw.ar(freq * [0.5, 1, 2], 0, LFNoise1.kr(0.3, 0.1, 0.1), amp));
		6.do({ effect = AllpassN.ar(effect, 0.040, [0.040.rand, 0.040.rand], 2) });
		effect = [DelayC.ar(effect, 0.01, 0.01), DelayC.ar(effect, 0.08, 0.08)];
		Out.ar(out, effect)
	}))

)


( // Prepare Convolution

{

~pulsePath = thisProcess.nowExecutingPath.dirname ++ "/sounds/impulses/impulse.aif";
~irbuffer = Buffer.read(Server.default, ~pulsePath);

s.sync;

~fftsize = 2048;
~bufsize = PartConv.calcBufSize(~fftsize, ~irbuffer);
~irspectrum = Buffer.alloc(Server.default, ~bufsize, 1);
~irspectrum.preparePartConv(~irbuffer, ~fftsize);

}.fork

)

( // Execute Convolution

~testEffect.value(
	SynthDef(\grainConv, {|in=0, out=0, fftsize=2048, specBufNum=8|
		var sig, verb;
		sig = GrainIn.ar(2, Dust.kr(120), 0.01, In.ar(in, 2));
		verb = PartConv.ar(sig, fftsize, specBufNum) * 0.1;
		Out.ar(out, (sig * 0.6) + (verb * 0.4))
	}),
	[\specBufNum, ~irspectrum.bufnum])

)


( // Prepare Waveshaping

{

~shaperSig = Signal.sineFill(512, Array.rand(128, -1.0, 1.0).normalizeSum);
~shaperBuf = Buffer.alloc(s, 1024, 1);

s.sync;

~shaperBuf.sendCollection(~shaperSig.asWavetableNoWrap);

}.fork

)

( // Execute Waveshaping

~testEffect.value(
	SynthDef(\revShaper, {|in=0, out=0, sinFreq=0.1, buffer=0|
		var sig, mod, index, player, analyse;
		sig = In.ar(in, 1) * 4;
		mod = BufFrames.kr(buffer) * SinOsc.ar(sinFreq, 0, 0.5, 0.5);
		index = LinLin.ar(sig, -1.0, 1.0, 0.0, mod);
		player = BufRd.ar(1, buffer, index);
		analyse = Amplitude.ar(sig, 0.1, 0.1, 2).range(0.2, 0.8);
		player = FreeVerb.ar(player, analyse, analyse, 0.2, 0.5);
		Out.ar(out, player ! 2)
	}),
	[\buffer, ~shaperBuf.bufnum])

)


( // Prepare Spectral Freeze

~freezeBuf = Buffer.alloc(s, 2048);

)

( // Execute Spectral Freeze

~testEffect.value(
	SynthDef(\frozen, {|in=0, out=0, feedback=0.95, delay=0.1, bufnum=9|
		var sig, effect, thres;
		sig = In.ar(in, 2);
		sig = Fb({|fbSig|
			BPF.ar(fbSig * feedback + sig, LFNoise1.kr(1, 200, 2000), 4).tanh;
		}, 0.2);
		effect = FFT(bufnum, sig);
		thres = Duty.ar(Dwhite(0.01, 0.1, inf), 0, Dwhite(0.4, 0.6, inf));
		effect = PV_Freeze(effect, thres > 0.5);
		Out.ar(out, IFFT(effect).dup)
	}),
	[\bufnum, ~freezeBuf.bufnum])

)


( // Spectral Comb

~testEffect.value(
	SynthDef(\spectralComb, {|in=0, out=0, numTeeth=8, width=0.5, mix=0.7|
		var sig, chain, buffer;
		buffer = LocalBuf(2048);
		sig = In.ar(in, 1);
		chain = FFT(buffer, sig);
		chain = PV_RectComb(chain, numTeeth, LFNoise1.kr(10.2).range(0, 1), width);
		Out.ar(out, XFade2.ar(sig, IFFT(chain), mix * 2 - 1) ! 2)
	}))

)


( // Allpass Verb

~testEffect.value(
	SynthDef(\allpassVerb, {|in=0, out=0, predelay=0.048, combdecay=2, allpassdecay=4, mix=0.4|
		var sig, z, y;
		sig = In.ar(in, 2);
		z = DelayN.ar(sig, 0.1, predelay);
		y = Mix.ar(Array.fill(7, { CombL.ar(z, 0.05, rrand(0.03, 0.05), combdecay).distort }));
		6.do({ y = AllpassN.ar(y, 0.050, rrand(0.03, 0.05), allpassdecay) });
		Out.ar(out, (sig * (1 - mix)) + (y * mix * 0.5))
	}))

)


( // Tanh Distort

~testEffect.value(
	SynthDef(\tanhDistort, {|in=0, out=0, drive=4, tone=2000, mix=0.6|
		var sig, dist;
		sig = In.ar(in, 2);
		dist = (sig * drive).tanh;
		dist = LPF.ar(dist, tone);
		Out.ar(out, XFade2.ar(sig, dist, mix * 2 - 1))
	}))

)
