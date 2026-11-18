////////////////////////////////////////////////////////////////
//
//                     Koenig: Tendency
//
////////////////////////////////////////////////////////////////

(
SynthDef(\sine, { |out=0, freq=440, amp=0.2, sus=0.05, pan=0|
	var env = EnvGen.kr(Env.perc(0.01, sus), doneAction: 2);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq) * env, pan, amp));
}).add;

~plotPattern = { |pattern, count = 500|
	pattern.asStream.nextN(count).plot(discrete: true)
};
)


////////////////////////// Tendency masks ///////////////////////////

~plotPattern.(Pwhite(Pseries(0.0, 0.05), Pseries(100.0, -0.05)), 1000);

(
Pbind(\instrument, \sine,
	\midinote, Pwhite(Pseg([36, 70, 60], [10, 10]), Pseg([96, 72, 62], [10, 10])),
	\dur, 0.05, \amp, 0.1).play
)


////////////////////////// Exercise ///////////////////////////

// Implement a stochastic process where the high and low limits of a distribution
// change in time. They should start by being very wide, far apart, but narrow as
// the process unfolds.

( // a solution: limits that start wide and narrow towards 64 over thirty seconds
Pbind(\instrument, \sine,
	\midinote, Pwhite(Pseg([30, 63], [30]), Pseg([100, 65], [30])),
	\dur, 0.08).play
)
