////////////////////////////////////////////////////////////////
//
//                   Binary Operations
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// Binary operations /////////////////////


// LeastChange: output the input that changed least
{ LeastChange.ar(SinOsc.ar(100), Saw.ar(15)) * 0.2 }.play;


// MostChange: output the input that changed most
{ MostChange.ar(LFNoise0.ar(500), SinOsc.ar(80)) * 0.2 }.play;


// Whitenoise pulses with amclip
{ WhiteNoise.ar(0.4).amclip(SinOsc.ar(100)) }.play;


// Threshold a sine wave with respect to another
{ SinOsc.ar(100).thresh(SinOsc.ar()) }.play;


// Ring modulation only when LFNoise2's polarity is negative
{ LFNoise2.ar(400).scaleneg(LFSaw.ar(1000)) }.play;


// Compare a sine wave with white noise to generate a rectangular wave
{ LeakDC.ar(SinOsc.ar(1000) < WhiteNoise.ar()) }.play;


// Modulate noise with a sweeping saw
{ WhiteNoise.ar(0.4).amclip(Saw.ar(Line.ar(1, 500, 15))) }.play;


// Threshold a Pulse wave with a Sine wave
{ Pulse.ar(50).thresh(SinOsc.ar(1000)) }.play;


// Fold a Blip with a sweeping Sine
{ Blip.ar(100, 150).fold2(SinOsc.ar(Line.ar(10, 100, 20))) }.play;


// Modulo a Saw wave with a LFNoise1
{ Saw.ar([20, 10]).mod(LFNoise1.ar(1000)) * 0.1 }.play;


///////////////////////// Clipping /////////////////////


// Excess: residual of clipping a sine wave
{ SinOsc.ar(100).excess(0.5) }.play;


// Hard clip a driven sine
{ (SinOsc.ar(200) * 4).clip2(1) * 0.3 }.play;


// Soft clip with tanh
{ (SinOsc.ar(200) * 5).tanh * 0.3 }.play;


// Softclip distortion
{ (SinOsc.ar(100) * 3).softclip * 0.3 }.play;


// Distort operator
{ SinOsc.ar(440, 0, 0.5).distort }.play;


///////////////////////// Folding & Wrapping /////////////////////


// Fold a saw with noise control
{ Saw.ar(100).fold2(LFNoise2.ar(10).range(0.2, 0.8)) * 0.3 }.play;


// Wrap a sine with modulated threshold
{ SinOsc.ar(200).wrap2(SinOsc.ar([10, 11]).range(0.2, 0.6)) * 0.3 }.play;


// Fold blip harmonics
{ Blip.ar(60, 20).fold2(LFSaw.ar(1).range(0.1, 0.9)) * 0.3 }.play;


// Wrap noise
{ PinkNoise.ar.wrap2(SinOsc.ar(5).range(0.1, 0.5)) * 0.4 }.play;


///////////////////////// Comparisons /////////////////////


// Greater than creates square wave
{ LeakDC.ar(SinOsc.ar(200) > LFTri.ar(201)) * 0.3 }.play;


// Less than with noise
{ LeakDC.ar(Saw.ar(100) < LFNoise1.ar(1000)) * 0.3 }.play;


// Max selects higher amplitude
{ SinOsc.ar(100).max(Saw.ar(150)) * 0.2 }.play;


// Min selects lower amplitude
{ SinOsc.ar(100).min(LFTri.ar(151)) * 0.3 }.play;


///////////////////////// Bitwise /////////////////////


// Round creates stepped quantization
{ SinOsc.ar(200).round(1) * 0.3 }.play;


// Truncate for harsh stepping
{ SinOsc.ar(200).trunc(0.2) * 0.3 }.play;



///////////////////////// Combinations /////////////////////


// Folded noise through comparison
{ LeakDC.ar(PinkNoise.ar.fold2(0.3) > SinOsc.ar(100)) * 0.3 }.play;


// Threshold with folded signal
{ Saw.ar(80).fold2(0.5).thresh(SinOsc.ar(5)) * 0.4 }.play;


// Chained distortions
{ SinOsc.ar(100).cubed.fold2(0.6).distort * 0.3 }.play;


// LeastChange with wrapped signals
{ LeastChange.ar(SinOsc.ar(50).wrap2(0.4), Saw.ar(51).wrap2(0.4)) * 0.3 }.play;


// MostChange driving harmonics
{ MostChange.ar(Blip.ar(80, 5), Blip.ar(81, 8)).clip2(0.5) * 0.3 }.play;


// Ring mod with clipped carrier
{ SinOsc.ar(200).clip2(0.3).ring1(SinOsc.ar(150)) * 0.3 }.play;


// Noise modulated by folded sine
{ WhiteNoise.ar.amclip(SinOsc.ar(10).fold2(0.5)) * 0.3 }.play;


// Scaleneg with wrapped modulator
{ LFSaw.ar(100).scaleneg(SinOsc.ar(8).wrap2(0.5)) * 0.3 }.play;


// Squared difference with noise
{ SinOsc.ar(200).difsqr(LFNoise1.ar(500)) * 0.2 }.play;


// Complex threshold chain
{ Saw.ar(60).thresh(SinOsc.ar(3)).fold2(LFNoise2.ar(2)) * 0.4 }.play;


/*  Reference: */

.fold2        // fold signal within -b to +b
.wrap2        // wrap signal within -b to +b
.clip2        // clip signal within -b to +b
.distort      // soft distortion
.softclip     // softer distortion
.tanh         // hyperbolic tangent waveshaping
.amclip       // two quadrant multiply (zero when b negative)
.scaleneg     // scale when negative (ring mod when b negative)
.thresh       // zero when below threshold
.mod          // modulo
.pow          // power
.ring1        // (a * b) + a
.ring2        // (a * b) + a + b
.ring3        // a * a * b
.ring4        // (a * a * b) - (a * b * b)
.excess       // residual of clipping
.squared      // square the signal
.cubed        // cube the signal
.difsqr       // difference of squares (a*a - b*b)
.sumsqr       // sum of squares (a*a + b*b)
.absdif       // absolute difference
.round        // quantize
.trunc        // truncate
.max          // maximum of two signals
.min          // minimum of two signals
