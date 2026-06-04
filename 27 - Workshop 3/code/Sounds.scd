////////////////////////////////////////////////////////////////
//
//                          Sounds
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


// Demand rate as a modulation source

(
{
	var trig = Impulse.kr(10);
	var seq = Dseq([2, 4, 8], inf).midicps;
	var freq = Demand.kr(trig, 0, seq);
	SinOsc.ar(LFCub.kr([freq, freq / 2], 0, 50, 200))
}.play
)


// Non-standard synthesis: demand waveform shaped by a sine

(
{
	var sd = SampleDur.ir * 0.15;
	DemandEnvGen.ar(
		Dseq([1, [-1, 0.5]], inf),
		Dseq(Array.rand(5, 1, 25), inf) * sd
	).mod(SinOsc.ar(LFNoise0.ar(1).range(5, 25))) * 0.5;
}.play
)


// Soft sine bass feedback

(
{ DFM1.ar(SinOsc.ar([60, 70], 0, 0.1), 1600, SinOsc.kr(0.1).range(0.92, 0.99), 1, 0, 0.001, 1.5) }.play
)


// Saw bank under a noisy filter and grain envelope

(
{
	RLPF.ar(Mix.ar(Saw.ar(Array.series(4, 50, 300), 0.1)), LFNoise2.ar(8).range(800, 8000))
	* EnvGen.ar(Env.perc(0.1, 0.15), Dust.ar(15)) ! 2;
}.play
)


// Saw chords with a sparse percussive envelope

(
{ RLPF.ar(Saw.ar([75, 50, 60, 80]), 600) * EnvGen.ar(Env.perc(0.1, 0.15), Dust.ar(1)) ! 2 }.play
)


// Crossfading modulation (dry / wet)

(
{
	var signal = Saw.ar(LFNoise2.ar(10).range(20, 60));
	var mod = SinOsc.ar(10 ! 2, 0, 0.5, 0.5);
	XFade2.ar(signal, signal * mod, LFNoise2.ar(0.5).range(-1, 1)) * 0.5;
}.play
)


// Boomy FM cluster gated by dust

(
{
	Splay.ar(16.collect { PMOsc.ar(LFTri.ar(0.001, 0, 80, 100), rrand(10, 1000), rrand(0.2, 2.3)) * 0.15 })
	* EnvGen.ar(Env.perc(0.1, 0.15), Dust.ar(10));
}.play
)


// Allpass network on dusty decays

(
{
	var sig = Decay.ar(Dust.ar([1, 0.5]), 0.1, WhiteNoise.ar) * 2;
	8.do {
		sig = LPF.ar(AllpassL.ar(sig, 0.02, LFNoise1.ar(0.1).range(0.001, 0.002), LFNoise1.ar(1).range(2, 20)), 8000);
	};
	sig
}.play
)


// Blip as an FM carrier swept by LFCub

(
{
	var freqFrom = 1, freqTo = 20, dur = 2, fm = 2800, harm = 15;
	Splay.ar(Blip.ar(LFCub.kr([Line.ar(freqFrom, freqTo * 1.1, dur), Line.ar(freqFrom, freqTo, dur * 2)], 0, fm / 2, fm), harm));
}.play
)


// Modulated LFDNoise0 with a tracking highpass

(
{
	var from = 100, to = 8000;
	HPF.ar(
		LFDNoise0.ar(LFNoise2.ar([from * 0.01, from * 0.02]).range(from, to).clip(from, to)) * 0.2,
		LFNoise2.ar(from * 0.1).range(from * 0.01, to).clip(from * 0.01, to)
	);
}.play
)
