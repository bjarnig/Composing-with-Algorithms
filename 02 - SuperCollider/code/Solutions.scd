////////////////////////////////////////////////////////////////
//
//               Exercises, worked solutions
//
////////////////////////////////////////////////////////////////

/* One answer each. They are not the only answers, and several of the exercises
   ask you to name a number rather than to write code, so those are answered in
   the comments.

   Every sounding line here was played and metered. Cmd+. stops everything. */

s.boot;


//////////////// 1. Two sines, and where beating becomes a tone ////////////////

// 2 Hz apart: one tone, pulsing twice a second
{ (SinOsc.ar(300) + SinOsc.ar(302)) * 0.1 ! 2 }.play;

// 8 Hz apart: too fast to count, and it starts to sound rough
{ (SinOsc.ar(300) + SinOsc.ar(308)) * 0.1 ! 2 }.play;

// 30 Hz apart: two separate tones, and the beating has gone
{ (SinOsc.ar(300) + SinOsc.ar(330)) * 0.1 ! 2 }.play;

/* The answer: the beating stops being countable at about 8 to 10 Hz, and the two
   tones separate at about 20 to 30 Hz apart. The same threshold appears in class
   11 as the boundary between rhythm and pitch. */


//////////////// 2. Eight sines, with their own amplitudes ////////////////

// equal amplitudes: mechanical, and the top is too strong
{ Mix(SinOsc.ar((1..8) * 110)) * 0.05 ! 2 }.play;

// 1/n, which is roughly a saw and sounds like an instrument
{ Mix(SinOsc.ar((1..8) * 110) * (1..8).reciprocal) * 0.1 ! 2 }.play;

// 1/n^2, darker again, and the ear hears one note rather than eight
{ Mix(SinOsc.ar((1..8) * 110) * (1..8).squared.reciprocal) * 0.2 ! 2 }.play;


//////////////// 3. A saw through RLPF, and resonance ////////////////

{ RLPF.ar(Saw.ar(110), 800, 0.8) * 0.2 ! 2 }.play;   // wide, barely a filter
{ RLPF.ar(Saw.ar(110), 800, 0.2) * 0.2 ! 2 }.play;   // clearly filtered
{ RLPF.ar(Saw.ar(110), 800, 0.03) * 0.2 ! 2 }.play;  // the filter sings at 800 Hz

/* rq is the reciprocal of Q: smaller is narrower. Below about 0.05 the resonance
   is a pitch of its own, whatever the saw underneath is doing. */


//////////////// 4. An LFO on the cutoff ////////////////

{ RLPF.ar(Saw.ar(110), SinOsc.kr(0.3).exprange(200, 4000), 0.2) * 0.2 ! 2 }.play;  // a sweep
{ RLPF.ar(Saw.ar(110), SinOsc.kr(6).exprange(200, 4000), 0.2) * 0.2 ! 2 }.play;    // a wobble
{ RLPF.ar(Saw.ar(110), SinOsc.kr(30).exprange(200, 4000), 0.2) * 0.2 ! 2 }.play;   // sidebands

/* The answer is the same boundary as exercise 1. Under about 10 Hz you hear a
   filter moving; over about 20 Hz you stop hearing movement and start hearing
   extra frequencies, because the modulation is now in the audio range. */


//////////////// 5. One LFO, three destinations ////////////////

(
~lfo = { SinOsc.kr(4) };
)

{ SinOsc.ar(400) * ~lfo.value.range(0, 1) * 0.2 ! 2 }.play;             // amplitude
{ SinOsc.ar(400 * ~lfo.value.range(0.97, 1.03)) * 0.2 ! 2 }.play;       // frequency
{ RLPF.ar(Saw.ar(110), ~lfo.value.exprange(300, 3000), 0.2) * 0.2 ! 2 }.play;  // cutoff

/* Amplitude is the least interesting: it changes how much, not what. Frequency
   and cutoff both change the sound itself, and cutoff usually wins because the
   pitch stays put while the timbre moves. */


//////////////// 6. LFNoise0 against LFNoise1 ////////////////

{ SinOsc.ar([LFNoise0.kr(4), LFNoise1.kr(4)].exprange(200, 1600)) * 0.15 }.play;

/* LFNoise0 holds each random value until the next one, so the left ear steps.
   LFNoise1 interpolates between them, so the right ear glides. Same rate, same
   range, same random numbers: only what happens between them differs. */


//////////////// 7. MouseX and MouseY ////////////////

{ RLPF.ar(Saw.ar(MouseX.kr(50, 400, 1)), MouseY.kr(200, 5000, 1), 0.15) * 0.2 ! 2 }.play;

// print the two numbers while you move, so the interesting corner can be written down
{ RLPF.ar(Saw.ar(MouseX.kr(50, 400, 1).poll(2, "freq")),
	MouseY.kr(200, 5000, 1).poll(2, "cutoff"), 0.15) * 0.2 ! 2 }.play;


//////////////// 8. A comb from echo to pitch ////////////////

// move the delay yourself and watch the poll
{ CombC.ar(Impulse.ar(1) * 0.4, 0.2, MouseX.kr(0.2, 0.002, 1).poll(2, "delay"), 4) ! 2 }.play;

// or let a line do it, from 200 ms to 2 ms over twenty seconds
{ CombC.ar(Impulse.ar(1) * 0.4, 0.2, XLine.kr(0.2, 0.002, 20), 4) ! 2 }.play;

/* The answer: the repetitions fuse into a tone at about 50 ms, which is 20 Hz,
   and by 20 ms the pitch is unmistakable. It is the threshold from exercise 1
   again, arriving from the other side. */


//////////////// 9. A comb tuned to a note ////////////////

(
~note = 57;                        // the A below middle C
~freq = ~note.midicps;             // 220 Hz
~delay = ~freq.reciprocal;         // 1 / 220 = 4.545 ms
[~freq, ~delay].postln;
)

{ CombC.ar(WhiteNoise.ar(0.2) * Decay.ar(Impulse.ar(1.5), 0.01), 0.1, 1/220, 3) ! 2 }.play;

// the same thing built from the variable, so the note can be changed in one place
{ CombC.ar(WhiteNoise.ar(0.2) * Decay.ar(Impulse.ar(1.5), 0.01), 0.1, ~delay, 3) ! 2 }.play;


//////////////// 10. Four of them in one line ////////////////

/* A saw, a filter, an LFO on the cutoff, and a comb tuned to a note. Every number
   in it is one of the answers above. */

{ CombC.ar(RLPF.ar(Saw.ar(55), LFNoise1.kr(0.7).exprange(200, 3000), 0.15), 0.1, 1/220, 0.2) * 0.2 ! 2 }.play;

/* The decay time is 0.2 and not 2. A comb fed a continuous sound keeps adding to
   what is already circulating, so a long decay runs away: at 2 seconds this line
   peaks above 6, which is thirty times too loud. A comb struck by impulses, as in
   exercise 9, can have a long decay safely because it is given silence to ring in. */


CmdPeriod.run;
