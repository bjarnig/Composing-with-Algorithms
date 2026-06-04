////////////////////////////////////////////////////////////////
//
//             Composing with Algorithms - Exercises
//
////////////////////////////////////////////////////////////////


/*


//////////////////////// Stochastic Patterns ////////////////////////

Exercise 1: Exponential Cloud
Create a Pbind that draws \freq from Pexprand(80, 5000) with a short \dur.

Exercise 2: Gaussian Centre
Create a Pbind whose \freq is a Pgauss centred on 800 with a deviation of
300. Most events cluster near the centre, a few stray far.

Exercise 3: Extreme Dynamics
Use Pbeta to drive \amp so that most events are either very soft or very
loud (a U-shaped distribution), with few in between.

Exercise 4: Weighted Densities
Use Pwrand to choose \dur from a small set of values where short durations
are much more likely than long ones, giving an irregular, bursty rhythm.

Exercise 5: Drifting Texture
Make both \freq and \dur wander with their own Pbrown, so the texture
evolves slowly and continuously rather than jumping.

Exercise 6: State Machine
Use Pfsm to switch between three frequency "behaviours" (e.g. low drone,
mid cloud, high sparkle) with weighted transitions between them.



//////////////////////////// Synthesis ////////////////////////////

Exercise 7: Resonant Ping
Write a SynthDef that excites a Resonz filter with an Impulse to make a
short resonant ping. Play it from a Pbind with random centre frequencies.

Exercise 8: Inharmonic Bell
Write a SynthDef using DynKlank (or Klank) with inharmonic partials,
excited by an Impulse, to make a bell/metal tone. Play random fundamentals.

Exercise 9: Wind
Write a SynthDef that band-passes WhiteNoise with a smooth Env.linen
envelope. Play a gesture of overlapping events with random centres.

Exercise 10: FM Timbre
Write an FM SynthDef with PMOsc and a variable \index. Sequence it so the
modulation index (and so the brightness) changes on every event.

Exercise 11: Synthetic Grains
Write a single-grain SynthDef (a short sine with a quick percussive
envelope) and trigger a dense cloud of them with a fast Pbind.

Exercise 12: Chaos
Make a sound from a chaotic oscillator (StandardL, HenonN or Crackle) and
slowly sweep its rate or chaos parameter with an LFNoise.

Exercise 13: Folding
Write a SynthDef that wavefolds a sine against a slowly modulated amount
using .fold2, generating extra partials as the fold depth changes.

Exercise 14: Feedback
Write a SynthDef using feedback - either SinOscFB with a varying feedback
amount, or a LocalIn / LocalOut loop, and let it ring.

Exercise 15: Comb Resonance
Excite a CombN (or Klank) with a short burst of noise so the comb's delay
tunes it to a pitch. Randomise the delay time to retune it per event.

Exercise 16: Dynamic Stochastic
Use Gendy1 (Xenakis' dynamic stochastic synthesis) to make a sound, and
expose a couple of its distribution parameters to vary the texture.

Exercise 17: Granulation
Load a sound file into a Buffer and granulate it with TGrains, scattering
grains with randomised position, rate and pan.

Exercise 18: Inharmonic Stack
Use Klang (or Mix.fill) to stack several sine partials at inharmonic
ratios, producing a metallic, non-tonal spectrum.



/////////////////////////// Demand Rate ///////////////////////////

Exercise 19: Server Sequence
Drive an oscillator's frequency from a Dseq read by Demand.kr on each
Impulse, so the stepping happens entirely on the server.

Exercise 20: Wandering Demand
Replace the Dseq with a Dbrown so the demand-driven frequency takes a
bounded random walk on every step.



///////////////////////// Live Coding (Ndef) /////////////////////////

Exercise 21: Node Proxy
Create a running Ndef that plays a filtered noise or saw drone, then change
its parameters live with .set.

Exercise 22: Proxy as Filter
Make one Ndef that processes the audio of another Ndef (for example a
band-pass filter or distortion applied to a source proxy).

Exercise 23: Effect Stack
Stack two effects onto a source Ndef using \filter roles (for example
distortion then reverb), and toggle them while it runs.


//////////////////////// Composition Processes ////////////////////////

Exercise 24: Timed Sections
Write a Routine on a TempoClock that starts one textural pattern, waits,
adds a second, waits, then stops both - a small three-part form.

Exercise 25: Parallel Spawning
Use Pspawner to layer several stochastic patterns over time: start one,
wait, add another, wait, add a third, then let them fade.

*/
