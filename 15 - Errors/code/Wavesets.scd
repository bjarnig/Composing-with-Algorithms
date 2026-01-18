////////////////////////////////////////////////////////////////
//
//                       Wavesets
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


Quarks.install("Wavesets");


////////////////////////// Setup ///////////////////////////


(

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
w = Wavesets.from(~path ++ "/samples/mahler.wav");

SynthDef(\waveset, {|out=0, buf=0, start=0, length=441, playRate=1, sustain=1, amp=0.2, pan=0|
	var phasor = Phasor.ar(0, BufRateScale.ir(buf) * playRate, 0, length) + start;
	var env = EnvGen.ar(Env([amp, amp, 0], [sustain, 0]), doneAction: 2);
	var snd = BufRd.ar(1, buf, phasor) * env;
	OffsetOut.ar(out, Pan2.ar(snd, pan));
}).add;

)


////////////////////////// Inspection ///////////////////////////


w.buffer

w.signal

w.numXings

w.lengths

w.amps

w.plot(1000, 1)

w.plot(1000, 10)


////////////////////////// Reconstruction ///////////////////////////

( // Pbind version (plays once through all wavesets)

Pbind(
	\instrument, \waveset,
	\startWs, Pseries(0, 1, w.numXings),
	\numWs, 1,
	\playRate, 1,
	\buf, w.buffer.bufnum,
	\repeats, 1,
	\amp, 0.4,
	[\start, \length, \sustain], Pfunc({ |ev|
		var start, length, wsDur;
		#start, length, wsDur = w.frameFor(ev[\startWs], ev[\numWs]);
		[start, length, wsDur * ev[\repeats] / ev[\playRate].abs]
	}).trace,
	\dur, Pkey(\sustain)
).play;

)


( // Pbindef version (can be modified in real-time)

Pbindef(\ws).clear;
Pbindef(\ws,
	\instrument, \waveset,
	\startWs, Pn(Pseries(0, 1, w.numXings), inf),
	\numWs, 1,
	\playRate, 1,
	\buf, w.buffer.bufnum,
	\repeats, 1,
	\amp, 0.4,
	[\start, \length, \sustain], Pfunc({ |ev|
		var start, length, wsDur;
		#start, length, wsDur = w.frameFor(ev[\startWs], ev[\numWs]);
		[start, length, wsDur * ev[\repeats] / ev[\playRate].abs]
	}),
	\dur, Pkey(\sustain)
).play;
P
)


////////////////////////// Transposition ///////////////////////////


Pbindef(\ws, \playRate, 0.5, \startWs, Pn(Pseries(0, 4, 1000), inf)).play

Pbindef(\ws, \numWs, 2, \playRate, -1, \startWs, Pn(Pseries(0, 10, 1000), inf)).play

Pbindef(\ws, \numWs, 1, \playRate, 1, \startWs, Pn(Pseries(0, 1, 1000), 1)).play


////////////////////////// Timestretch ///////////////////////////


Pbindef(\ws, \playRate, 1, \repeats, 10).play

Pbindef(\ws, \playRate, 4, \repeats, 100).play


////////////////////////// Random Selection ///////////////////////////


Pbindef(\ws, \numWs, 1, \repeats, 1, \freq, Pfunc({ if(0.25.coin, 1, \) })).play

Pbindef(\ws, \startWs, Pwhite(0, w.numXings)).play


////////////////////////// Amplitude Selection ///////////////////////////


(
var ampThreshold = 0.3;
var loudWavesets = [];

w.amps.do { |amp, i|
	if(amp > ampThreshold) {
		loudWavesets = loudWavesets.add(i);
	}
};

"Found % loud wavesets out of %".format(loudWavesets.size, w.numXings).postln;

Pbindef(\ws,
	\startWs, Pseq(loudWavesets, inf),
	\numWs, 5,
	\playRate, 1,
	\repeats, 1,
	\amp, 0.4
).play;
)


////////////////////////// Length Selection ///////////////////////////


(

var lengthThreshold = 50;
var shortWavesets = [];

w.lengths.do { |length, i|
	if(length < lengthThreshold) {
		shortWavesets = shortWavesets.add(i);
	}
};

"Found % short wavesets".format(shortWavesets.size).postln;

Pbindef(\ws,
	\startWs, Pseq(shortWavesets, inf),
	\numWs, 1,
	\playRate, Pwhite(0.8, 1.5),
	\repeats, Pwhite(1, 5)
).play;

)


////////////////////////// Scrubbing ///////////////////////////


(
Pbindef(\ws,
	\startWs, Prand([
		Pseries(0, 1, 100),
		Pseries(100, -1, 100),
		Pseries(0, 2, 50),
		Pseries(100, -2, 50)
	], inf),
	\numWs, 10,
	\playRate, 1,
	\repeats, 1
).play;
)


////////////////////////// Rhythmic ///////////////////////////


(
Pbindef(\ws,
	\startWs, Pwhite(0, w.numXings),
	\numWs, Prand([1, 2, 3], inf),
	\playRate, Prand([1, 2, 0.5], inf),
	\repeats, 1,
	\dur, Pseq([0.125, 0.125, 0.25, 0.125, 0.375], inf)
).play;
)


////////////////////////// Granulation ///////////////////////////


(
Pbindef(\ws,
	\startWs, Pwhite(0, w.numXings),
	\numWs, 5,
	\playRate, Pwhite(0.5, 2.0),
	\repeats, 1,
	\amp, Pwhite(0.1, 0.4),
	\pan, Pwhite(-1.0, 1.0),
	\dur, Pwhite(0.01, 0.05)
).play;
)


////////////////////////// Amplitude Mapping ///////////////////////////


(
Pbindef(\ws,
	\startWs, Pwhite(0, w.numXings),
	\numWs, 10,
	\playRate, Pfunc({ |ev|
		var wsAmp = w.amps[ev[\startWs].asInteger.min(w.numXings - 1)];
		wsAmp.linlin(0.0, 1.0, 0.5, 3.0);
	}),
	\repeats, 1,
	\amp, 0.4
).play;
)


////////////////////////// Freezing ///////////////////////////


(
Pbindef(\ws,
	\startWs, Pstutter(Pwhite(10, 50), Pwhite(0, w.numXings)),
	\numWs, 15,
	\playRate, Pstutter(Pwhite(10, 50), Pwhite(0.5, 2.0)),
	\repeats, 1,
	\amp, 0.4,
	\dur, 0.05
).play;
)


////////////////////////// Probability Filter ///////////////////////////


(
Pbindef(\ws,
	\startWs, Pseries(0, 1, w.numXings).repeat,
	\numWs, 3,
	\playRate, 1,
	\repeats, 1,
	\amp, 0.8,
	\freq, Pfunc({ |ev|
		var wsAmp = w.amps[ev[\startWs].asInteger.min(w.numXings - 1)];
		if(wsAmp > 0.5.rand, 1, \);
	})
).play;
)


////////////////////////// Binary Operations ///////////////////////////


(
SynthDef(\wavesetFold, {|out=0, buf=0, start=0, length=441, playRate=1, sustain=1, amp=0.2, pan=0|
	var phasor = Phasor.ar(0, BufRateScale.ir(buf) * playRate, 0, length) + start;
	var env = EnvGen.ar(Env([amp, amp, 0], [sustain, 0]), doneAction: 2);
	var snd = BufRd.ar(1, buf, phasor);
	snd = snd.fold2(LFNoise2.ar(8).range(0.2, 0.6));
	snd = snd * env;
	OffsetOut.ar(out, Pan2.ar(snd, pan));
}).add;

Pbindef(\ws,
	\instrument, \wavesetFold,
	\startWs, Pwhite(0, w.numXings),
	\numWs, Pwhite(1, 3),
	\playRate, Pwhite(0.8, 1.5),
	\amp, 0.3
).play;
)


////////////////////////// Multi-Layer ///////////////////////////


(
Pdef(\ws1, Pbind(
	\instrument, \waveset,
	\startWs, Pseries(0, 1, w.numXings).repeat,
	\numWs, 1,
	\playRate, 1,
	\buf, w.buffer.bufnum,
	\repeats, 1,
	\amp, 0.15,
	\pan, -0.7,
	[\start, \length, \sustain], Pfunc({ |ev|
		var start, length, wsDur;
		#start, length, wsDur = w.frameFor(ev[\startWs], ev[\numWs]);
		[start, length, wsDur * ev[\repeats] / ev[\playRate].abs]
	}),
	\dur, Pkey(\sustain)
)).play;

Pdef(\ws2, Pbind(
	\instrument, \waveset,
	\startWs, Pwhite(0, w.numXings),
	\numWs, 1,
	\playRate, 3,
	\buf, w.buffer.bufnum,
	\repeats, 1,
	\amp, 0.1,
	\pan, 0.7,
	[\start, \length, \sustain], Pfunc({ |ev|
		var start, length, wsDur;
		#start, length, wsDur = w.frameFor(ev[\startWs], ev[\numWs]);
		[start, length, wsDur * ev[\repeats] / ev[\playRate].abs]
	}),
	\dur, Pkey(\sustain)
)).play;

Pdef(\ws3, Pbind(
	\instrument, \waveset,
	\startWs, Pstutter(5, Pwhite(0, w.numXings)),
	\numWs, 2,
	\playRate, -0.5,
	\buf, w.buffer.bufnum,
	\repeats, 1,
	\amp, 0.15,
	\pan, 0,
	[\start, \length, \sustain], Pfunc({ |ev|
		var start, length, wsDur;
		#start, length, wsDur = w.frameFor(ev[\startWs], ev[\numWs]);
		[start, length, wsDur * ev[\repeats] / ev[\playRate].abs]
	}),
	\dur, Pkey(\sustain)
)).play;
)


////////////////////////// Stop ///////////////////////////


(
Pbindef(\ws).stop;
Pdef(\ws1).stop;
Pdef(\ws2).stop;
Pdef(\ws3).stop;
)
