////////////////////////////////////////////////////////////////
//
//                       Environment
//
////////////////////////////////////////////////////////////////

This class covers examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


// play through a function
{ Saw.ar(60, 0.1) }.play


// play a SynthDef
SynthDef(\saw, { Out.ar(0, Saw.ar( [60,70], 0.1)) }).play


// show the meter ( CMD m )
s.meter


// scope the signal ( Shift CMD m )
s.scope(2)


// freq scope the signal ( Opt CMD m )
FreqScope.new(400, 200, 0, server: s);


// big volume fader
s.volume.gui


// plot the tree
s.plotTree


// create gui (with record button)
s.makeGui