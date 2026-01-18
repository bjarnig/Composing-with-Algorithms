////////////////////////////////////////////////////////////////
//
//                       Solutions
//
////////////////////////////////////////////////////////////////


/* Exercise 1 Solution */
(
var pattern = Pbrown(-1.0, 1.0, 0.05);
~ex1Buf = ~patternToBuffer.(pattern, 2);
)
{ PlayBuf.ar(1, ~ex1Buf, MouseX.kr(0.5, 8), loop: 1) ! 2 * 0.4 }.play


/* Exercise 2 Solution */
{ SinOsc.ar(200).fold2(LFNoise2.ar(0.5).range(0.1, 0.9)) * 0.3 ! 2 }.play


/* Exercise 3 Solution */
{ LeakDC.ar(Saw.ar(100) < SinOsc.ar(101)) * 0.3 ! 2 }.play


/* Exercise 4 Solution */
{
	var sig = SinOsc.ar(440);
	var rate = MouseX.kr(500, 10000);
	Latch.ar(sig, Impulse.ar(rate)) * 0.3 ! 2
}.play


/* Exercise 5 Solution */
(
Pbind(
	\instrument, \waveset,
	\startWs, Pseries(0, 1, w.numXings),
	\numWs, 1,
	\playRate, 1,
	\buf, w.buffer.bufnum,
	\repeats, 8,  // repeat each waveset 8 times
	\amp, 0.4,
	[\start, \length, \sustain], Pfunc({ |ev|
		var start, length, wsDur;
		#start, length, wsDur = w.frameFor(ev[\startWs], ev[\numWs]);
		[start, length, wsDur * ev[\repeats] / ev[\playRate].abs]
	}),
	\dur, Pkey(\sustain)
).play;
)


/* Exercise 6 Solution */
(
Pbind(
	\instrument, \waveset,
	\startWs, Pwhite(0, w.numXings - 1),
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
)


/* Exercise 7 Solution */
{
	var rate = BufRateScale.kr(~buf) * LFNoise0.kr(3).range(-2, 2);
	PlayBuf.ar(1, ~buf, rate, loop: 1) ! 2 * 0.5
}.play


/* Exercise 8 Solution (requires sc3-plugins) */
(
var array = Array.fill(64, { 1.0.rand });
var buffer = Buffer.sendCollection(s, array, 1, action: {
	{ Instruction.ar(buffer.bufnum) * 0.3 ! 2 }.play
});
)


/* Exercise 9 Solution (requires sc3-plugins) */
{
	var sig = LPCError.ar(
		PinkNoise.ar(0.5),
		LFNoise1.kr(0.3).range(20, 80)
	);
	BPF.ar(sig, LFNoise1.kr(0.2).range(400, 2000), 0.3) * 0.4 ! 2
}.play
