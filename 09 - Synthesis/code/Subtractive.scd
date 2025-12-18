////////////////////////////////////////////////////////////////
//
//                        Subtractive
//
////////////////////////////////////////////////////////////////

This class covers examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


//////////////////////////////////////// Subtractive Synthesis /////////////////////////////////


{ Saw.ar(40.midicps, 0.3) }.play


{ Saw.ar( LFPulse.kr(2).range(20, 60).midicps, 0.2) }.play


{ Resonz.ar(Saw.ar(100), LFNoise1.kr(10).range(100, 1500), 0.2) }.play


{ RLPF.ar(Saw.ar([100, 150], 0.5), LFNoise1.kr(0.1).range(100, 1200), 0.1) }.play



// Blip (buzz), all harmonics have equal amplitude but number of harmonics is configurable.
(
	{
		Blip.ar(100, LFNoise1.kr(10.1).range(10, 200), 0.4) ! 2
	}.freqscope;
)




// Saw is band limited
(
	{
		Saw.ar(200 *MouseX.kr(1,100), 0.4) ! 2
	}.freqscope;
)




// LFSaw is not band limited
(
	{
		LFSaw.ar(200 *MouseX.kr(1,100), 0, 0.1) ! 2
	}.freqscope;
)




// With filtering
(
	{
		Resonz.ar(
			Mix(Saw.ar([0.98, 0.99, 1.01]*200,0.3)),
			MouseX.kr(100,20000,\exponential), // Cutoff frequency
			MouseY.kr(0.1, 1.0, \linear), // Resonance
			0.7);
	}.play
)




// LFO for amplitude (tremolo)
(
	{
		var sig, lfo;
		lfo = SinOsc.kr(MouseX.kr(1,20));
		sig = Saw.ar(83, lfo) * 0.5;
		sig!2
	}.play
)




// LFO for pitch variation (vibrato)
(
	{
		var sig, mod;
		mod = SinOsc.ar(MouseY.kr(40, 0.5), 0, MouseX.kr(5, 20));
		sig = Blip.ar(369 + mod, 100, 0.8);
		sig!2
	}.play
)
