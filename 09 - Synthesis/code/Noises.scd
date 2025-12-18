////////////////////////////////////////////////////////////////
//
//                        Noises
//
////////////////////////////////////////////////////////////////

This class covers examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


//////////////////////////// Noises //////////////////////////////

Search help files for Noise or go to Browse UGens -> Filters


// Equal
{ WhiteNoise.ar(0.5) }.freqscope


// -3 dB per octave
{ PinkNoise.ar(0.5) }.freqscope



// -6 dB per octave
{ BrownNoise.ar(0.5) }.freqscope



// Randomly flipping bits (emphasizes lower frequencies)
{ GrayNoise.ar(0.5) }.freqscope



// Random impulses, first argument specifies density
{ Dust.ar(MouseX.kr(1, 1000).poll, 0.5) }.scope



// Based on a chaotic function.
{ Crackle.ar(1.95, 0.5) }.scope;



// Random walk with Gendyn distributions.
{ LFBrownNoise0.ar(MouseY.kr(100, 10000).poll, 1, MouseX.kr(1, 8), 0.2) }.scope



// Dynamic step noise
{ LFDNoise0.ar(MouseY.kr(100, 10000), 0.1) }.freqscope;



// Randomly generates the values -1 or +1 at a given rate
{ LFClipNoise.ar(MouseY.kr(10, 20000), 0.1) }.freqscope;
