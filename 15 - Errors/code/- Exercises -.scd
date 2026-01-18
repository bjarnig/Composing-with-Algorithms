////////////////////////////////////////////////////////////////
//
//                          Exercises
//
////////////////////////////////////////////////////////////////



////////////////////////// Audification //////////////////////////


/*
Exercise 1: Pattern to Buffer

Use the ~patternToBuffer function to create a buffer from a Pbrown pattern.
Play it back at different speeds using MouseX to control the rate.

Hint: Pbrown(-1.0, 1.0, stepSize) creates brownian motion
*/

(

)


////////////////////////// Binary Operations //////////////////////////


/*
Exercise 2: Fold Distortion

Create a SinOsc and fold it using .fold2 with a modulated threshold.
Use LFNoise2 to slowly change the fold amount between 0.1 and 0.9.
*/

(

)


/*
Exercise 3: Signal Comparison

Use the < (less than) operator to compare a Saw wave with a SinOsc.
Wrap the result in LeakDC.ar to remove the DC offset.
Experiment with different frequencies for each oscillator.
*/

(

)


////////////////////////// Errors & Glitches //////////////////////////


/*
Exercise 4: Sample Rate Reduction

Use Latch.ar and Impulse.ar to reduce the sample rate of a signal.
Control the sample rate with MouseX between 500 and 10000 Hz.
*/

(

)


////////////////////////// Wavesets //////////////////////////


/*
Exercise 5: Waveset Time Stretch

Modify the waveset playback to repeat each waveset multiple times.
Use \repeats to stretch the sound in time.

Hint: The sustain calculation needs to account for repeats
*/

(


)


/*
Exercise 6: Random Waveset Selection

Instead of playing wavesets sequentially, use Pwhite to
randomly select which waveset to play.
*/

(


)


////////////////////////// Bending & Corruption //////////////////////////



/*
Exercise 7: Direction Scrambling

Use PlayBuf with a rate that randomly switches between
positive and negative values using LFNoise0.
This creates forwards/backwards playback switching.
*/

(


)


////////////////////////// Instructions (requires sc3-plugins) //////////////////////////


/*
Exercise 8: Instruction Synthesis

Create a buffer with random values and use the Instruction UGen
to synthesize sound from it. Experiment with different buffer sizes.

Note: Requires sc3-plugins to be installed.
*/

(


)


/*
Exercise 9: LPCError Texture

Use LPCError.ar with a noise input and modulated prediction order.
Filter the result with BPF to tame the harshness.

( Requires sc3-plugins to be installed. )
*/

(


)