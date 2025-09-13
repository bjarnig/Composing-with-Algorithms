////////////////////////////////////////////////////////////////
//
//                          SynthDefs
//
////////////////////////////////////////////////////////////////


Pattern basics and sequencing synths.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\sine, {
	|amp=0.1, freq=440, pan=0|
	var env, sig;
	env = EnvGen.kr(Env.perc, doneAction:2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;


SynthDef(\pulse, {|out=0, note=25, rel=1.0, lop=500, res=0.1, amp=1.0|
	var sig, env, filter, freq;
	freq = note.midicps;
	sig = Impulse.ar([freq, freq*0.5]) * amp;
	env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction:2);
	filter = BLowPass4.ar(sig, lop, res);
	Out.ar(out, filter * env);
}).add;

SynthDef(\sampler, {
	|out=0, pan=0, buf=0, note=60, amp=1.0, pos=0.0, rel=1.0|
	var sig, rate, start, env;
	env = EnvGen.ar(Env.perc(releaseTime: rel), doneAction:2);
	rate = BufRateScale.ir(buf) * (note / 60.0);
	start = BufFrames.kr(buf) * pos;
	sig = PlayBuf.ar(1, buf, rate, 1, start);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;


SynthDef(\pluck, {
	|amp=0.1, note=60, decay=4, coef=0.1, pan=0|
	var env, sig, pluck, delay;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction:2);
	sig = WhiteNoise.ar(amp);
	delay = note.midicps.reciprocal;
	sig = Pluck.ar(in:sig, delaytime:delay, decaytime:decay, coef:coef);
	Out.ar(0, Pan2.ar(sig * 0.5, pan));
}).add;

)
