////////////////////////////////////////////////////////////////
//
//                    Prisme - Synths
//
////////////////////////////////////////////////////////////////

(

~cSynthSpecs = Dictionary();

/* 4 x fm synth */

SynthDef(\cFm, {
	|out=0, amp=1.0, freq=100, atk=0.2, sus=0.25, rel=0.1, mod=0.5, pan=0.0, gate=1.0,
	lop=20000, hip=20, lopVol=0.5, hipVol=0.5, freqa=126, freqb=275, freqc=6074, freqd=5129,
 	mods=#[12,18,11,42], amps=#[0.1,0.1,0.2,0.1]|
    var sig, env, mult, note, freqs;
	freqs=[freqa, freqb, freqc, freqd];
	mod = LinLin.kr(mod, 0.0, 1.0, 0.01, 5);
	note = freq.cpsmidi;
    mult = note/60.0;
    sig = Mix.ar(PMOsc.ar(freqs * mult, mods * mult, mod, 0, amps) * 0.88);
	sig = BLowPass4.ar(sig, lop, 0.25, mul:lopVol) + BHiPass4.ar(sig, hip, 0.25, mul:hipVol);
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, sus, rel], [2,1,4], 1), gate, doneAction:2);
    sig = Pan2.ar(sig * env * amp, pan);
   	OffsetOut.ar(out, sig);
}).add;

~cSynthSpecs[\cFm] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\mod, ControlSpec(0.0, 10.0, \lin, 0.01, 0.5)],
[\freq, ControlSpec(20, 150, \lin, 0.1, 100)],
[\freqa, ControlSpec(20, 200, \lin, 0.1, 126)],
[\freqb, ControlSpec(20, 500, \lin, 0.1, 275)],
[\freqc, ControlSpec(100, 8000, \lin, 0.1, 6074)],
[\freqd, ControlSpec(20, 6000, \lin, 0.1, 5129)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]];


/* brownian ptich modulation */

SynthDef(\cBrown, {
	|out=0, amp=0.2, freq=1000, atk=0.1, sus=0.2, rel=0.2, mod=0.8, pan=0.0, gate=1.0, numharm=150,
	modFreq=5000, modDur=15|
	var sig, env, offset, brown, freqd, trig;
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, sus, rel], [4, 2,-2], 2), gate, amp, doneAction:2);
	brown = Dbrown(freq, freq + 10 + (200 * mod), 100, inf);
	trig = Impulse.kr(Line.kr(10, modFreq * mod, modDur));
    freqd = Demand.kr(trig, 0, brown);
    sig = Blip.ar(freqd, numharm) * 0.6;
	sig = Pan2.ar(sig * env, pan);
   	OffsetOut.ar(out, sig);
}).add;

~cSynthSpecs[\cBrown] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\numharm, ControlSpec(1, 200, \lin, 1, 100)],
[\modFreq, ControlSpec(10, 8000, \lin, 1, 100)],
[\modDur, ControlSpec(1, 20, \lin, 0.1, 100)],
[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)],
[\mod, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)]];


/* 2 x blip with modulation */

SynthDef(\cPlipar, {
	|out=0, amp=0.2, freq=400, atk=0.1, sus=0.2, rel=0.2, mod=0.8, pan=0.0, gate=1.0,
	numHarmonics=10, duration=3, lop=17000|
	var env = EnvGen.ar(Env([0, 1, 1, 0], [atk, sus, rel], [1,2,-2], 2), gate, amp, doneAction:2);
	var amount = mod;
	var lfo = SinOsc.ar(XLine.kr( freq / 24 , 0.1, duration), 0, 0.5, 0.5);
	var blip = Blip.ar(freq, XLine.ar(numHarmonics,numHarmonics/10,duration), 0.75);
	var blip2 = Blip.ar(freq/2, XLine.ar(numHarmonics,numHarmonics/2,duration * 0.5), 0.75);
	var signal = (blip + blip2) * 0.5;
	signal = RLPF.ar(signal, lop, 1);
	signal = (signal * (lfo * amount)) + (signal * (1 - amount));
   	OffsetOut.ar(out, Pan2.ar(signal * env, pan));
}).add;

~cSynthSpecs[\cPlipar] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\numHarmonics, ControlSpec(1, 50, \lin, 1, 100)],
[\duration, ControlSpec(0.1, 15, \lin, 0.001, 0.05)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)],
];


/* gritty pitch */

SynthDef(\cEithne, {arg out=0, amp=0.8, buf=1, atk=0.1, sus=8, rel=12, rate=10, gate=1.0,
	curve=0, freq=1000, noiseAmp=1.5, impulseAmp=0.6,hipass=60;
	var signal;
	var trigger= (Impulse.ar(rate) * 0.9) + (Dust.ar(rate) * 0.1);
	var env= EnvGen.ar(Env.perc(atk, rel, 1), trigger, 1, 0, (1/rate));
	var trebleEnv= EnvGen.ar(Env.new([0,1,1,0],[atk/2,sus,rel/2], -2, 2), gate, doneAction:2);
	var impulse = BPF.ar(Impulse.ar(freq,env), freq + (freq/4), 0.1) * impulseAmp * env;
	var noise = BPF.ar(PinkNoise.ar(mul:env), freq, 0.1) * noiseAmp;
	var treble = (impulse + noise);
	treble = treble * trebleEnv;
	signal = LeakDC.ar(treble);
	signal = signal * amp * 5;
	signal = HPF.ar(signal, hipass);
	Out.ar(out, Pan2.ar(signal, 0));
}).add;

~cSynthSpecs[\cEithne] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\rate, ControlSpec(0.1, 50, \lin, 0.1, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];


/* upper noise with a pirch and controls */

SynthDef(\cDrack, {arg out=0, atk=0.1, sus=400, rel=4, speed = 0.01, density = 0.9525, pan=0.1, entropy=0.071, amp=0.74, pos=0.575, surface=0.1, gate=1.0, freq = 1000, lpf=19900;
	var freqA=freq/12, freqB=freq/10, freqBFilter=freq/5, freqC=freq, freqD=freq*2, ampA=0.5, ampB=05, ampC=0.5, ampD=0.5;
	var osca, oscb, oscc, oscd, signal, verb, distortion, env;
	env = EnvGen.kr(Env.new([0, 1, 1, 0],[atk, sus, rel], 1, 2), gate, doneAction:2);
	osca = SinOsc.ar(freqA, 0.3, 0.0) * ampA;
	oscb = RLPF.ar(Impulse.ar(freqB, mul:0.7), freqBFilter, 0.1) * ampB;
	oscc = HPF.ar(Dust.ar(freq), freqC) * ampC * 0.01;
	oscd = HPF.ar(PinkNoise.ar(0.4), freqD) * ampD;
	signal = osca + oscb + oscc + oscd;
	signal = (signal * LFGauss.ar(speed, density,0,1)) * 5;
	signal = signal * LFNoise2.ar(100 * entropy, 0.5, 0.5).min(1.0).max(1 - entropy);
	signal = (signal * (1 - surface));
	signal = signal * env;
	signal = LPF.ar(signal, lpf);
	signal =  Pan2.ar(signal, pan);
	signal = signal * amp;
	Out.ar(out, signal);
}).add;

~cSynthSpecs[\cDrack] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\density, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\entropy, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\speed, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\surface, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\lpf, ControlSpec(25, 19900, \lin, 1, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];


/* additive tri-waves */

SynthDef(\cOpal,
	{|out=0, amp=0.5, surface=0.0, freq=100, atk=0.02, sus=0.02, rel=2, pan=0,gate=1.0|
	var frequencies=[0.8, 1, 1.2, 1.4] * freq, amplitudes=#[0.1, 1.0, 0.4, 0.8];
 	var signal, osca, oscb, oscc, oscd, distorted;
 	var downsamp, samplerate=8000, bitsize=15;
	var env = EnvGen.ar(Env.new([0, 1, 0.2, 0],[atk, sus, rel], 'lin', 2), gate, doneAction:2);
	osca = LFTri.ar(frequencies[0], mul:amplitudes[0]) * env;
	oscb = LFTri.ar(frequencies[1], mul:amplitudes[1]) * env;
	oscc = LFTri.ar(frequencies[2], mul:amplitudes[2]) * env;
	oscd = LFTri.ar(frequencies[3], mul:amplitudes[3]) * env;
	signal = (osca + oscb + oscc + oscd) * amp;
	downsamp = Latch.ar(signal, LFTri.ar(samplerate*0.5));
	distorted = downsamp.round(0.5 ** bitsize);
	signal = (signal * (1 - surface)) + (distorted * surface);
	signal = HPF.ar(signal, 40) + LPF.ar(signal, 18500);
	signal = signal * amp * 0.8;
	signal = Pan2.ar(signal, pan);
	Out.ar(out, signal);
}).add;

~cSynthSpecs[\cOpal] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\surface, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];


/* (modulated) additive tri-waves */

SynthDef(\cModpal,
	{|out=0, amp=0.5, surface=0.0, freq=100, atk=0.02, sus=0.02, rel=2, pan=0,gate=1.0,curve=2,
	hpf=40, lpf=18500, ampModFreq=15, ampModAmt=0.01, freqMod=0.2|
	var ampa=0.1, ampb=1.0, ampc=0.4, ampd=0.8;
	var frequencies=[1-freqMod, 1, 1 + freqMod, 1 +  (freqMod * 2)] * freq, amplitudes=[ampa,ampb,ampc,ampd];
 	var signal, osca, oscb, oscc, oscd, distorted;
 	var downsamp, samplerate=8000, bitsize=15;
	var env = EnvGen.ar(Env.new([0, 1, 0.2, 0],[atk, sus, rel], curve, 2), gate, doneAction:2);
	osca = LFTri.ar(frequencies[0], mul:ampa) * env;
	oscb = LFTri.ar(frequencies[1], mul:ampb) * env;
	oscc = LFTri.ar(frequencies[2], mul:ampc) * env;
	oscd = LFTri.ar(frequencies[3], mul:ampd) * env;
	signal = (osca + oscb + oscc + oscd) * amp;
	downsamp = Latch.ar(signal, LFTri.ar(samplerate*0.5));
	distorted = downsamp.round(0.5 ** bitsize);
	signal = (signal * (1 - surface)) + (distorted * surface);
	signal = signal * SinOsc.ar(ampModFreq).range(1-ampModAmt, 1);
	signal = HPF.ar(LPF.ar(signal, lpf), hpf);
	signal = signal * amp * 0.8;
	signal = Pan2.ar(signal, pan);
	Out.ar(out, signal);
}).add;

~cSynthSpecs[\cModpal] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\ampModFreq, ControlSpec(0.01, 50, \lin, 0.01, 100)],
[\ampModAmt, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\freqMod, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];


/* . - .. */

SynthDef(\cDechlor,
	{|out=0, amp=0.5, freq=100, atk=0.5, dec=0.1, sus=1.0, rel=0.1, surface=0.55,
	speed=0.1, entropy=0.95, pan=0.0, bpFreq=2000, gate=1|
	var freq1=freq*0.8, freq2=freq*0.9, freq3=freq, freq4= freq*1.1;
	var freq5=freq*1.2, freq6=freq*1.3, freq7=freq*1.4, freq8=freq*1.5;
 	var env = EnvGen.kr(Env.adsr(atk, dec, sus, rel),gate:gate, doneAction:2);
 	var osca = Impulse.ar(freq1 + LFNoise1.ar(100, entropy * 100, 0.1));
	var oscb = Impulse.ar(freq2 + LFNoise1.ar(200, entropy * 200, 0.1));
	var oscc = Impulse.ar(freq3 + LFNoise1.ar(300, entropy * 300, 0.1));
	var oscd = Impulse.ar(freq4 + LFNoise1.ar(400, entropy * 400, 0.1));
	var signal = (osca + oscb + oscc + oscd);

	signal = (signal * surface) + ((1 - surface) * Formlet.ar(signal, freq/2, 0.01, 0.1));
	signal = (signal * (1-speed)) + (signal * StandardL.ar(50*entropy, 10*speed) * speed);
	signal = BPeakEQ.ar(signal, bpFreq, 0.1, 2);
	signal = LeakDC.ar(signal);
	signal = signal * env;
	signal = signal * amp * 0.7;
	signal = Pan2.ar(signal, pan);
	Out.ar(out, signal);
	}, [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]
).add;

~cSynthSpecs[\cDechlor] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\surface, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\speed, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\entropy, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];


/* . - .. */

SynthDef(\cGbman, {
	|out=0, amp=0.3, freq=100, pan=0.0, atk=1.1, dec=0.5, sus=1.0, rel=0.5, gate=1, mod=0.5,
	lop=18000, loprq=1|
	var env, sig;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction:2);
	sig = Saw.ar(Lag.ar(GbmanL.ar(freq/4).range(freq/2,freq)));
	sig = BBandStop.ar(sig, freq * 2, 2);
	sig = RLPF.ar(sig, lop, loprq);
	sig = Pan2.ar(sig * env, pan) * amp;
	OffsetOut.ar(out, sig);
}).add();

~cSynthSpecs[\cGbman] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\mod, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\lop, ControlSpec(40, 18000, \lin, 1, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];

/* . - .. */

SynthDef(\cSineFB, {
	|out=0, amp=0.1, freq=440, pan=0, atk=1.1, dec=0.5, sus=1.0, rel=2.5, gate=1, curve=1,
	ampModAmt=0.25, ampModFreq=10, feedbacka=0.7, feedbackb=0.8, brFreq=200, brBw=2|
	var env, sig, ampMod;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel, amp, curve), gate, doneAction:2);
	ampMod = LFNoise2.kr(ampModFreq, ampModAmt, amp);
	sig = SinOscFB.ar(freq/4, feedbacka) + SinOscFB.ar(freq/6, feedbackb);
	sig = HPF.ar(SoftClipAmp8.ar(sig, pregain:8) * 0.2, (freq * 12).min(8000)) +
	LPF.ar(SoftClipAmp8.ar(sig, pregain:4) * 0.2, freq / 2);
	sig = HPF.ar(sig, 50, 4);
	sig = BBandStop.ar(sig, brFreq, brBw);
	sig = sig * env * ampMod;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add();

~cSynthSpecs[\cSineFB] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\ampModAmt, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\ampModFreq, ControlSpec(0.01, 50, \lin, 0.01, 100)],
[\feedbacka, ControlSpec(0.1, 0.9, \lin, 0.01, 0.05)],
[\feedbackb, ControlSpec(0.1, 0.9, \lin, 0.01, 0.05)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];


/* . - .. */

SynthDef(\cFmAst, {
	|out=0, amp=0.2, freq=100, atk=0.1, sus=0.2, rel=0.2, mod=0.8, pan=0.0, gate=1.0, curve=1,
	modFreq=3040.1, modDur=0.4, modFrom=0.02, modTo=0.8, rateFrom=4, rateTo=20, grEnvAtk=0.1, grEnvRel=0.5|
	var sig, env, osca, oscb, oscc, oscd;
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, sus, rel], [4,2,-2], curve), gate, amp, doneAction:2);
	osca = PMOsc.ar(freq, modFreq * 2, Line.kr(modFrom, modTo, modDur)) * 0.3 ;
	oscb = PMOsc.ar(freq * 0.5, modFreq * 0.25, Line.kr(modFrom, modTo, modDur*2)) * 0.1 ;
	oscc = PMOsc.ar(freq * 1.5, modFreq, Line.kr(modFrom, modTo, modDur)) * 0.05 ;
	oscd = PMOsc.ar(freq * 0.25, modFreq * 0.125, Line.kr(modFrom, modTo, modDur*2)) * 0.2 ;
	sig = HPF.ar(osca + oscb + oscc + oscd, 40, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, rateTo, modDur)));
	sig = Pan2.ar(sig * env, pan);
   	OffsetOut.ar(out, sig);
}).add;

~cSynthSpecs[\cFmAst] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\modFreq, ControlSpec(0.01, 50, \lin, 0.01, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];

SynthDef(\cCroft, {
	|out=0, amp=0.3, freq=100, modFreq=200, numHarm=150, pan=0.0, atk=1.1, dec=0.5, sus=1.0, rel=0.5, gate=1, curve=1, lpf=19900, hpf=20, ampModFreq=15, ampModAmt=0.01|
	var env, sig, mod;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel, 1, curve), gate, doneAction:2);
	sig = Blip.ar(freq, numHarm).fold2(SinOsc.ar(modFreq));
	sig = RLPF.ar(RHPF.ar(sig, hpf), lpf);
	sig = sig * SinOsc.ar(ampModFreq).range(1-ampModAmt, 1);
	sig = Pan2.ar(sig * env, pan) * amp;
	OffsetOut.ar(out, sig);
}).add();

~cSynthSpecs[\cCroft] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\dec, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 2000, \lin, 0.1, 100)],
[\modFreq, ControlSpec(0.01, 1000, \lin, 0.01, 100)],
[\numHarm, ControlSpec(1, 300, \lin, 1, 100)],
[\ampModFreq, ControlSpec(0.01, 25, \lin, 0.1, 100)],
[\ampModAmt, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\lpf, ControlSpec(20, 18000, \lin, 1, 100)],
[\hpf, ControlSpec(20, 18000, \lin, 1, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];

)
