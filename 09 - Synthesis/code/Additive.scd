////////////////////////////////////////////////////////////////
//
//                          Additive
//
////////////////////////////////////////////////////////////////

This class covers examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)



////////////////////// Additive Synthesis //////////////////////


// play with defaults and through a function
{ SinOsc.ar(110) }.play



// with arguments
{ SinOsc.ar(200, 0, 0.5) }.play



// add two sine waves with plus operator
{ SinOsc.ar(100, 0, 0.2) + SinOsc.ar(1200, 0, 0.2) + SinOsc.ar(200,0,0.2) }.play



// Expand and scope
{ SinOsc.ar([400, 800, 25, 500],0,0.1) }.scope



// Repeat and with randomness
{ SinOsc.ar([100,200,300], 0, LFNoise2.kr(1, 0.8)) }.play



// Use iteration to add multiple sine waves
(

10.do {

	{ SinOsc.ar(exprand(100.0, 2000.0), 0, 0.1) ! 2 }.play
}

)

(

50.do {

	{
		var sine = SinOsc.ar(exprand(100.0, 800.0), 0, 0.5);
		var mod =  LFNoise2.kr(rrand(0.01, 10), 0.02, 0.05);
		(sine * mod) ! 2
}.play

}

)



// Use DynKlang (Dynamic sine oscillator bank) instead of individual sine waves
(
	{
	(DynKlang.ar(`[
			[200, 1000, 2000], // frequencies
			[0.5, 0.4, 0.1] // amplitudes
	]) * 0.1) ! 2
	}.freqscope;
)
