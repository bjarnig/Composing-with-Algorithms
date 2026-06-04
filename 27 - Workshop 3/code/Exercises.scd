////////////////////////////////////////////////////////////////
//
//              Exercises — Organizing Sounds
//
////////////////////////////////////////////////////////////////


Fill in each empty block.


////////////////////////// Wrapping Sounds //////////////////////////


/*
Exercise 1: Sound as an Ndef

Take any { }.play example from Sounds.scd and put its function inside
an Ndef(\sound, { ... }). Set its fadeTime to 4, play it, then stop it
with a fade so it doesn't cut abruptly.

Hint: Ndef(\sound).fadeTime = 4; Ndef(\sound).play; ... Ndef(\sound).stop;
*/

(

)


/*
Exercise 2: Sound as a SynthDef

Turn one Timbral.scd recipe into a SynthDef with \amp and \out arguments.
Wrap the body so it ends in Out.ar(out, sig * amp), then play it with Synth.
This makes the sound reusable as an instrument.

Hint: SynthDef(\name, {|amp=0.2, out=0| var sig = ...; Out.ar(out, sig * amp) }).add;
*/

(

)


////////////////////////// Layering //////////////////////////


/*
Exercise 3: Two-layer drone

Pick two Ndefs from Timbral.scd and play them at the same time.
Balance them with .vol so neither one dominates.

Hint: Ndef(\a).vol = 0.5; Ndef(\b).vol = 0.3;
*/

(

)


/*
Exercise 4: A simple timeline

Use a Routine to bring in three different sounds one after another,
waiting a few seconds between each entrance.

Hint: Routine({ ~a.play; 5.wait; ~b.play; 5.wait; ~c.play }).play;
*/

(

)


////////////////////////// Live Coding Setup //////////////////////////


/*
Exercise 5: ProxySpace crossfade

Push a ProxySpace and set its fadeTime. Host two sounds as ~a and ~b.
Bring one in and take the other out by changing their .vol live.

Hint: p = ProxySpace.push(s); p.fadeTime = 3; ~a.play; ~a.vol = 0.0; ~b.vol = 0.6;
*/

(

)


/*
Exercise 6: One sound filtering another

Make a source Ndef (e.g. a Demand.scd texture) and a filter Ndef that
processes it through \in.ar (a lowpass, reverb, or comb). Route the
source into the filter and play the filter.

Hint: Ndef(\fx, {|in| GVerb.ar(\in.ar) }); Ndef(\fx).set(\in, Ndef(\src).asMap);
*/

(

)



////////////////////////// Form & Transitions //////////////////////////


/*
Exercise 7: Two sections in sequence

Make two Pbinds (~secA and ~secB) from different sound material.
Play them back to back, each for a fixed time, using Pfindur and Pseq.

Hint: Pseq([Pfindur(8, ~secA), Pfindur(8, ~secB)], 1).play;
*/

(

)


/*
Exercise 8: Arrange with Pspawner

Sketch a short piece: introduce sound A, wait, add sound B in parallel,
wait, then suspend everything to end.

Hint: Pspawner({|sp| sp.par(~a); sp.wait(8); sp.par(~b); sp.wait(8); sp.suspendAll }).play;
*/

(

)


////////////////////////// Patterns & Modules //////////////////////////


/*
Exercise 9: Sequence a sound

Wrap a short percussive example (e.g. a Ringz ping with a perc envelope)
in a SynthDef and drive it with a Pbind. Use Pseq for \freq and a steady \dur.

Hint: Pbind(\instrument, \ping, \freq, Pseq([200, 300, 500], inf), \dur, 0.25).play;
*/

(

)


/*
Exercise 10: Effect bus

Make a synth that writes to a private bus (\out) and an effect synth
(delay or reverb) that reads that bus and plays to channel 0.
Send a pattern through the bus so everything passes through the effect.

Hint: ~bus = Bus.audio(s, 2); Synth(\fx, [\in, ~bus]); Pbind(..., \out, ~bus).play;
*/

(

)