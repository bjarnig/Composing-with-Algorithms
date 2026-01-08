////////////////////////////////////////////////////////////////
//
//                        Chaos UGens
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


/////////////////////////// Buffers //////////////////////////


(
~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
~path = ~path ++ "samples/";

~caa = Buffer.read(s, ~path ++ "caa.wav");
~cab = Buffer.read(s, ~path ++ "cab.wav");
~cac = Buffer.read(s, ~path ++ "cac.wav");
)


////////////////////////// All ChaosGen ///////////////////////////


ChaosGen.allSubclasses.do(_.postln)



////////////////////////// Plot ///////////////////////////


{ QuadN.ar(SampleRate.ir/4) }.plot(0.1)

{ CuspN.ar(50) }.plot(0.1)

{ HenonN.ar(EnvGen.kr(Env([10, 1000], [10]))) }.plot(0.1)

{ FBSineN.ar(100, 0.8, 1.2) }.plot(0.1)

{ LorenzL.ar(4000) }.plot(0.1)

{ LinCongC.ar(500, 1.2, 0.8, 0.6).clip(-1, 1) }.plot(0.1)



////////////////////////// Listen ///////////////////////////


{ HenonN.ar(1000) * 0.2 ! 2 }.play

{ GbmanL.ar(2000) * 0.2 ! 2 }.play

{ StandardL.ar(3000) * 0.2 ! 2 }.play

{ CuspL.ar(4000) * 0.2 ! 2 }.play

{ Logistic.ar(LFNoise1.kr(0.1, 0.5, 3.5), LFNoise1.kr(0.2, 500, 1000), 0.25, 0.5) }.play

{ Crackle.ar(LinCongL.ar(2).range(1.0, 2.0), 0.5, 0.5) }.play


////////////////////////// Modulate Frequency ///////////////////////////


(
10.do {
	{
		Pulse.ar(CuspN.ar(rrand(20, 60)).range(100, 2000), 0.5, 0.05) ! 2
	}.play
}
)


(
15.do {
	{
		Blip.ar(
			GbmanN.ar(rrand(10, 100)).range(100, 500),
			LinCongN.ar(rrand(40, 80)).range(10, 200),
			0.3
		) * EnvGen.ar(Env([0, 1, 0], [20.rand, 5.rand])) ! 2
	}.play
}
)


(
{
	var freq = HenonN.ar(100).range(200, 800);
	var width = CuspN.ar(50).range(0.1, 0.9);
	Pulse.ar(freq, width, 0.1) ! 2
}.play
)


(
{
	var freq = StandardL.ar(1000).range(100, 400);
	var numharm = GbmanN.ar(20).range(5, 50);
	Blip.ar(freq, numharm, 0.15) ! 2
}.play
)


////////////////////////// Granular ///////////////////////////


(
{
	var rate = 10, grSize = 0.8, buf = ~caa.bufnum;
	TGrains.ar(2,
		Impulse.kr(LatoocarfianL.ar(150).range(5, 150)),
		buf,
		1,
		LorenzL.ar(100).range(0, BufDur.kr(buf)),
		grSize,
		0, 0.5
	)
}.play
)


(
{
	var buf = ~caa.bufnum;
	TGrains.ar(2,
		Impulse.kr(QuadC.ar(1).range(10, 150)),
		buf,
		CuspN.ar(10000).range(0.5, 1.5),
		LinCongL.ar(1000).range(0, BufDur.kr(buf)),
		HenonN.ar(8000).range(0.1, 1.5)
	) * 2
}.play
)


(
{
	var buf = ~cab.bufnum;
	var trig = Dust.ar(StandardL.ar(10).range(10, 80));
	var pos = LorenzL.ar(50).range(0, BufDur.kr(buf));
	var rate = HenonN.ar(200).range(0.8, 1.2);
	TGrains.ar(2, trig, buf, rate, pos, 0.2, 0, 0.8)
}.play
)


////////////////////////// Resonators ///////////////////////////


(
{
	DynKlank.ar(
		`[
			[CuspN.ar(1).range(100, 800).lag(1), HenonL.ar(2).range(200, 900).lag(3)],
			nil,
			[2, 4]
		],
		Impulse.ar(GbmanN.ar(10).range(1, 10).lag(2), 0, 0.05) ! 2
	)
}.play
)


(
{
	Klank.ar(
		`[[142, 182, 1224, 1448, 2400], [1, 0.5, 0.2, 0.4, 0.2] * 0.01],
		Henon2DC.ar(100, 10000, LFNoise1.kr(0.8, 0.1, 1.3), 0.3)
	) ! 2 * 0.2
}.play
)


(
{
	var freqs = LinCongN.ar(10).range(200, 2000) * [1, 1.5, 2, 2.5];
	Klank.ar(`[freqs, nil, 0.5 ! 4], Dust.ar(20, 0.1)) ! 2
}.play
)


////////////////////////// Filtering ///////////////////////////


(
{
	DFM1.ar(
		Dust.ar(400),
		LatoocarfianN.ar(10).range(20, 8000),
		QuadC.ar(20).range(0.05, 1.3)
	) * 0.2 ! 2
}.play
)


(
{
	RLPF.ar(
		Saw.ar([100, 101]),
		HenonN.ar(15).range(200, 4000).min(4000).max(200),
		GbmanL.ar(10).range(0.1, 0.8)
	) * 0.2
}.play
)


(
{
	BBandStop.ar(
		LPF.ar(Crackle.ar(LFNoise2.ar(12).range(1.01, 1.5), 0.5), 12000),
		StandardL.ar(5.4).range(100, 300),
		6
	) * 2 ! 2
}.play
)


(
{
	var sig = WhiteNoise.ar(0.3);
	var freq = CuspL.ar(20).range(500, 5000);
	var rq = QuadN.ar(10).range(0.01, 0.2);
	BPF.ar(sig, freq, rq) ! 2
}.play
)


////////////////////////// Reverb ///////////////////////////


(
{
	var signal = LatoocarfianC.ar(
		SampleRate.ir/3,
		LFNoise2.kr(2, 1.5, 1.5),
		LFNoise2.kr(2, 1.5, 1.5),
		LFNoise2.kr(2, 0.5, 1.5),
		LFNoise2.kr(2, 0.5, 1.5)
	) * 0.1;

	Mix.fill(10, { signal = AllpassN.ar(signal, 0.01, [0.01.rand, 0.02.rand], 2) });
}.play
)


////////////////////////// Triggers ///////////////////////////


(
{
	Ringz.ar(StandardTrig.ar(10, 20), 2205, 0.02).fold2(0.5).dup
}.play
)


(
{
	var trig = HenonTrig.ar(5, 10);
	var offset = 1/2;
	PlayBuf.ar(1, ~caa,
		trigger: trig,
		startPos: BufFrames.kr(~caa) * offset,
		loop: 0
	) ! 2
}.play
)


(
{
	var trig = GbmanTrig.ar(20, 100);
	var freq = TRand.ar(200, 800, trig);
	SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.001, 0.1), trig) * 0.2 ! 2
}.play
)


////////////////////////// FM ///////////////////////////


(
{
	var mod = GbmanL.ar(LFNoise1.kr(0.1, 0.5, 3.5), LFNoise1.kr(0.2, 500, 1000), 0.25, 0.5);
	var freq = 60;
	PMOsc.ar(
		[LFNoise2.kr(0.05, freq/5, freq), LFNoise2.kr(0.01, freq/10, freq/2)],
		Lag.ar(mod.range(freq, freq * 15), 0.1),
		10,
		0,
		0.2
	)
}.play
)


(
{
	var relb = GbmanL.ar(10).range(2.5, 3.5);
	var rela = 90;
	var diff = rela + (rela * 0.5);
	var diffb = relb + (relb * 1.75);

	SinOsc.ar(LFCub.kr([rela + (rela * 0.5), rela], 0, diff * 10, rela * rela), 0, 0.05) +
	SinOsc.ar(LFCub.kr([relb + (relb * 0.5), relb], 0, diffb * 10, relb * relb), 0, 0.1) * 0.8
}.play
)


(
{
	var modFreq = StandardL.ar(100).range(50, 500);
	var carFreq = 200;
	var index = HenonN.ar(50).range(1, 10);
	PMOsc.ar(carFreq, modFreq, index, 0, 0.05) ! 2
}.play
)


////////////////////////// Layered ///////////////////////////


(
{
	var sig = Mix.fill(5, {
		var freq = LorenzL.ar(rrand(50, 200)).range(100, 500);
		SinOsc.ar(freq, 0, 0.05)
	});
	sig ! 2
}.play
)


(
{
	Mix.fill(8, {
		var freq = HenonN.ar(rrand(100, 500)).range(80, 4000);
		var amp = CuspN.ar(rrand(10, 50)).range(0.01, 0.08);
		SinOsc.ar(freq) * amp
	}) ! 2
}.play
)


////////////////////////// Multidimensional ///////////////////////////


(
{
	var x, y, z;
	#x, y, z = RosslerL.ar(LFNoise1.ar(10, 100, 5000));
	Impulse.ar(x.range(50, 500), y.range(0.0, 1.0)).distort * 0.6 ! 2
}.play
)


(
{
	var x, y, z;
	#x, y, z = FincoSprottL.ar(TRand.kr(10, 500, Dust.kr(10)));
	RLPF.ar(Saw.ar(x.range(100, 200)) * 0.1, y.range(100, 1000), z.range(0.2, 1.2)) ! 2
}.play
)


(
{
	var x, y, z;
	#x, y, z = LorenzL.ar(SampleRate.ir, 10, 28, 2.67);
	var sig = SinOsc.ar(x.range(100, 500)) * 0.1;
	sig = Pan2.ar(sig, y.range(-1, 1));
	sig * z.range(0.5, 1)
}.play
)


////////////////////////// Combinations ///////////////////////////


(
{
	var chaos = StandardL.ar(5000);
	var filtered = RLPF.ar(chaos, HenonN.ar(50).range(500, 4000), 0.2);
	var verb = FreeVerb.ar(filtered, 0.5, 0.8);
	verb * 0.3 ! 2
}.play
)


(
{
	var src = GbmanN.ar(8000) * 0.3;
	var mod = LorenzL.ar(100).range(0.2, 1);
	var filt = BPF.ar(src * mod, CuspN.ar(20).range(500, 3000), 0.1);
	filt ! 2
}.play
)


(
{
	var trig = Dust.ar(StandardL.ar(5).range(5, 40));
	var freq = HenonN.ar(100).range(200, 1000);
	var sig = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.01, 0.2), trig) * 0.3;
	var verb = FreeVerb.ar(sig, 0.6, 0.9, 0.2);
	verb ! 2
}.play
)

