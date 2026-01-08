////////////////////////////////////////////////////////////////
//
//                         Gendy
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

/*

The standard distribution contains three Ugens by Nick
Collins inspired by the stochastic synthesis of Xenakis:

*/


// Basic Gendy1
{ Gendy1.ar * 0.5 }.play


// Frequency range control
{ Gendy1.ar(minfreq: 100, maxfreq: 1000) * 0.5 }.play


{ Gendy1.ar(minfreq: 20, maxfreq: 100) * 0.5 }.play  // bass rumble


// Number of control points (waveform complexity)
{ Gendy1.ar(initCPs: 4) * 0.5 }.play   // simple waveform


{ Gendy1.ar(initCPs: 50) * 0.5 }.play  // complex waveform


// Modulate control points over time (50 → 2)
{ Gendy1.ar(initCPs: 50, knum: XLine.kr(50, 2, 30, doneAction: 2)) * 0.5 }.play


// Distribution types (ampdist/durdist: 0-6)
// 0=linear, 1=cauchy, 2=logist, 3=hyperbcos, 4=arcsine, 5=expon, 6=sinus

{ Gendy1.ar(ampdist: 0) * 0.5 }.play  // linear


{ Gendy1.ar(ampdist: 5) * 0.5 }.play  // exponential


{ Gendy1.ar(durdist: 3) * 0.5 }.play  // hyperbolic cosine duration


{ Gendy1.ar(ampdist: 10, ddparam: 0.001, minfreq: 200) * 0.5 }.play



// Gendy2 uses Lehmer-style random number generator
// a and c parameters create periodicities


{ Gendy2.ar(a: 0.5) * 0.5 }.play


{ Gendy2.ar(a: 1.85, c: 0.92) * 0.5 }.play  // quasi-periodic


{ Gendy2.ar(ampdist: 6, adparam: 0.18, durscale: 0.01) * 0.5 }.play



// Gendy3 forces oscillation at a desired pitch (freq parameter)

{ Gendy3.ar(freq: 440) * 0.5 }.play


{ Gendy3.ar(freq: 100) * 0.5 }.play


{ Gendy3.ar(freq: 60, durscale: 0.1) * 0.5 }.play


{ Gendy3.ar(freq: 800, durscale: 0.8, knum: 12) * 0.5 }.play


{ Gendy3.ar(freq: SinOsc.kr(0.1).range(100, 800)) * 0.5 }.play




( // Multiple Gendy2 layers with random parameters

var layers = 4;
{
	Splay.ar(Array.fill(layers, {
		Gendy2.ar(
			adparam: rrand(0.1, 1),
			ddparam: rrand(0.1, 1),
			minfreq: rrand(50, 200),
			maxfreq: rrand(500, 1200),
			mul: layers.reciprocal
		)
	}))
}.play

)



( // 8-layer Gendy3 with band-stop filtering

{
	Splay.ar(
	HPF.ar(
		BBandStop.ar(
			Gendy3.ar(1.1, 0.1, 0.1, 0.1, Array.rand(8, 10, 50), 0.1, 0.01),
			300, 8, 2
		), 40
	))
}.play

)



// Klank resonator excited by Gendy
{ Klank.ar(`[[142, 182, 1224, 1448, 2400], [1, 0.5, 0.2, 0.4, 0.2] * 0.01], Gendy2.ar) }.play


// Different resonator tuning
{ Klank.ar(`[[100, 345, 1456, 2008, 3700], [1, 0.5, 0.2, 0.4, 0.2] * 0.01], Gendy2.ar) }.play


// Ringz resonator bank
(
{
	var gen = Gendy1.ar(minfreq: 20, maxfreq: 200, mul: 0.1);
	Splay.ar((Ringz.ar(gen, [200, 400, 800, 1600], 0.05, [0.01,0.1])))
}.play
)




// Folding
{ Gendy3.ar(freq: 70).fold2(SinOsc.ar(20)) * 0.25 ! 2 }.play


// Clipping with sine modulation
(
{
	var gen = Gendy2.ar(minfreq: 50, maxfreq: 500);
	gen.clip2(SinOsc.ar(0.5).range(0.1, 1)) * 0.25 ! 2
}.play
)


// Wrap distortion
{ Gendy3.ar(freq: 100).wrap2(SinOsc.ar([10, 11])) * 0.2 }.play





// Gendy as amplitude modulator
(
{
	var carrier = Saw.ar(60);
	var mod = Gendy3.ar(freq: 10).range(0, 1);
	carrier * mod * 0.25 ! 2
}.play
)


// Gendy controlling filter frequency
(
{
	var noise = PinkNoise.ar(0.5);
	var freq = Gendy1.ar(minfreq: 1, maxfreq: 10).range(200, 2000);
	RLPF.ar(noise, freq, 0.1) ! 2
}.play
)


// Gendy as FM modulator
(
{
	var modfreq = 100;
	var mod = Gendy3.ar(freq: modfreq) * 200;
	SinOsc.ar(400 + mod) * 0.3 ! 2
}.play
)




// MostChange: selects whichever signal is changing most
{ MostChange.ar(Gendy2.ar(maxfreq: 10), Gendy3.ar(freq: 100, initCPs: [50,60])) * 0.25 }.play


// Blip + Gendy combination
(
{
	var brown = Dbrown(50, 500, 50, inf);
	var trig = Impulse.kr(LFNoise1.kr(0.3, 5, 8));
	var freq = Demand.kr(trig, 0, brown);
	var sig = Blip.ar(freq, 8, 0.3) + Gendy3.ar(freq: 40, mul: 0.4);
	HPF.ar(sig.fold2(SinOsc.ar(0.5)), 60) ! 2
}.play
)


// PMOsc with Gendy envelope
(
{
	var freq = 25, index = 100;
	var mod = Gendy3.ar(freq: 60).range(0.5, 2);
	var signal = PMOsc.ar(freq, freq * 2, index, 0, 0.1);
	signal * mod ! 2
}.play
)


// Evolving
(
{
	var gen = Gendy1.ar(
		ampdist: LFNoise1.kr(0.1).range(0, 6),
		durdist: LFNoise1.kr(0.15).range(0, 6),
		minfreq: 40,
		maxfreq: LFNoise1.kr(0.2).range(200, 2000),
		initCPs: 12
	);
	LPF.ar(gen, LFNoise1.kr(0.1).range(500, 4000)) * 0.5 ! 2
}.play
)