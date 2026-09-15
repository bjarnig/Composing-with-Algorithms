////////////////////////////////////////////////////////////////
//
//                Oscillators and Modulation
//
////////////////////////////////////////////////////////////////

/* One line per idea, in the order the exercises need them. Every line here was
   played and metered, so none of them clips.

   The whole subject is one sentence: anywhere a UGen takes a number, another
   UGen can go instead. Everything below is that sentence applied somewhere. */

s.boot;


//////////////// Adding sine waves ////////////////

// two sines a hertz apart: you hear one tone beating once a second
{ (SinOsc.ar(300) + SinOsc.ar(301)) * 0.1 ! 2 }.play;

// eight harmonics added together, which is additive synthesis in one line
{ Mix(SinOsc.ar((1..8) * 110)) * 0.05 ! 2 }.play;

// the same eight with falling amplitudes, which is closer to a real spectrum
{ Mix(SinOsc.ar((1..8) * 110) * (1..8).reciprocal) * 0.1 ! 2 }.play;


//////////////// Filtering a saw ////////////////

// a saw has every harmonic; the filter takes the top off
{ RLPF.ar(Saw.ar(110), 800, 0.2) * 0.2 ! 2 }.play;

// the third argument is resonance: smaller is narrower and louder at the cutoff
{ RLPF.ar(Saw.ar(110), 800, 0.05) * 0.2 ! 2 }.play;


//////////////// Modulating with an LFO ////////////////

// the cutoff is no longer a number but a slow oscillator
{ RLPF.ar(Saw.ar(110), SinOsc.kr(0.5).exprange(200, 4000), 0.2) * 0.2 ! 2 }.play;

// the same idea on amplitude: a tremolo
{ SinOsc.ar(400) * SinOsc.kr(3).range(0, 1) * 0.2 ! 2 }.play;

// and on frequency: a vibrato
{ SinOsc.ar(400 * SinOsc.kr(5).range(0.98, 1.02)) * 0.2 ! 2 }.play;


//////////////// LFNoise1 ////////////////

// a random value every quarter second, interpolated between the points
{ SinOsc.ar(LFNoise1.kr(4).exprange(200, 1600)) * 0.2 ! 2 }.play;

// LFNoise0 steps, LFNoise1 glides: the same rate in both ears, left and right
{ SinOsc.ar([LFNoise0.kr(4), LFNoise1.kr(4)].exprange(200, 1600)) * 0.15 }.play;


//////////////// MouseX and MouseY ////////////////

/* The cheapest controller there is, and the fastest way to find the range a
   parameter is worth having. The last argument 1 means an exponential mapping. */

// left to right is frequency
{ SinOsc.ar(MouseX.kr(200, 2000, 1)) * 0.2 ! 2 }.play;

// two dimensions at once: pitch across, cutoff up and down
{ RLPF.ar(Saw.ar(MouseX.kr(50, 400, 1)), MouseY.kr(200, 5000, 1), 0.2) * 0.2 ! 2 }.play;


//////////////// CombC ////////////////

/* A delay with feedback. Above about 50 ms it is an echo; below about 20 ms the
   repetitions fuse and it becomes a pitch of 1 / delaytime. */

// an echo: one impulse a second, repeating every 80 ms for 4 seconds
{ CombC.ar(Impulse.ar(1) * 0.5, 0.2, 0.08, 4) ! 2 }.play;

// the same comb tuned to 220 Hz, struck with a short burst of noise
{ CombC.ar(WhiteNoise.ar(0.2) * Decay.ar(Impulse.ar(1), 0.02), 0.1, 1/220, 3) ! 2 }.play;


CmdPeriod.run;
