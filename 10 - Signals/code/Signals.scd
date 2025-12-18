////////////////////////////////////////////////////////////////
//
//                      Signals
//
////////////////////////////////////////////////////////////////

// Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.
Quarks.fetchDirectory(true);
Quarks.install("SafetyNet");
thisProcess.recompile;
)


////////////////////////// Plotting ////////////////////////////


// Plot 0.1 seconds of a sinewave
{ SinOsc.ar(100) }.plot(0.1);


// Plot a numerical dataset
[5, 10, 100, 50, 60].plot;


// Plot an envelope
Env([0, 1, 0], [1, 1], [-10, 2]).plot;


// Scope a sine wave
{ SinOsc.ar(50) }.scope;


// Scope in stereo
(
{
	[
		SinOsc.ar(240, 0, 0.2) + Saw.ar(30, 0.1),
		SinOsc.ar(142, 0, 0.2) + Saw.ar(40, 0.1)
	]
}.scope;
)


// Call scope on the server
{ Impulse.ar(15) ! 8 }.play
s.scope


// FreqScope - visualize frequency spectrum
FreqScope.new(800, 800);

{ SinOsc.ar(SinOsc.kr(10).range(100, 2000)) }.play




/////////////////////// Envelopes ////////////////////////


// Linen for a simple fade in and out
(
{
	PinkNoise.ar(0.5) * Linen.kr(Impulse.kr(1), 0.01, 1, 0.1)
}.play
)


// An amplitude envelope
(
{
	var env = Env([0, 1, 0.5, 1, 0], [2.01, 1.5, 0.2, 0.5]);
	SinOsc.ar([200, 201]) * EnvGen.kr(env, doneAction: 2)
}.play
)


// An envelope that loops
(
{
	Impulse.ar(80) * EnvGen.kr(Env([0, 0.5, 0], [1, 1]).circle, doneAction: 2);
}.play
)


// Envelopes can be generated using methods from Env
Env.linen(1, 2, 1).plot

Env.linen(1, 2, 1).test

Env.triangle(1, 1).test.plot

Env.sine(1, 1).test.plot

Env.cutoff(1, 1, 'sine').test.plot

Env.perc(0.05, 1, 1).test.plot

Env.adsr(0.01, 0.5, 0.5, 0.1, 1.0, 0).plot

Env([0.01, 1, 0.3, 0.01], [1, 0.5, 2], 'exponential').plot

Env([0.01, 1, 0.3, 0.01], [1, 0.5, 2], 'exponential').test.plot

Env([0.01, 1, 0.3, 0.01], [1, 0.5, 2], 'welch').test.plot


// Custom array manipulations
~values = [0, 1, 0.2, 0.3, 0.4, 0.1]
~times = [0.4, 0.8, 0.6, 0.3, 0.5]
Env(~values, ~times).test.plot

~values = ~values.scramble
~times = ~times.scramble
Env(~values, ~times).test.plot


// Envelopes for each partial
(
200.do {
	{
		SinOsc.ar(rrand(50.0, 12000.0), rrand(-1, 1), 0.01)
		* EnvGen.kr(Env([0, 1, 0], [rrand(2, 20), rrand(2, 8)]))
	}.play
}
)


// Frequency envelope
{ SinOsc.ar(EnvGen.kr(Env([100, 200, 80], [2, 4]).circle)) * 0.1 }.play




/////////////////////// SynthDefs ////////////////////////


// Using { }.play is a shortcut for creating a SynthDef and playing it

{ Resonz.ar(Saw.ar(100), LFNoise1.kr(2).range(200, 2000), 0.2) }.play


// The usual workflow is to add the SynthDef and create multiple Synths from it
(
SynthDef("sawFilter", {|frequency = 50|
	Out.ar(0, Resonz.ar(Saw.ar(frequency), LFNoise1.kr(2).range(200, 2000), 0.2) ! 4);
}).add;
)

a = Synth("sawFilter", [\frequency, 10]);
a.set(\frequency, 200)


// Within a SynthDef variables and arguments can be used
(
SynthDef("varSawFilter", {|from = 100, to = 1500|
	var resfreq, sig;
	resfreq = LFNoise1.kr(1).range(from, to);
	sig = Saw.ar(100);
	sig = Resonz.ar(sig, resfreq, 0.1);
	Out.ar(0, sig);
}).add;
)

Synth("varSawFilter", [\to, 500])


// Storing synths in variables enables changing their arguments or freeing them
a = Synth("varSawFilter")
a.set(\from, 1000)
a.set(\from, rrand(100, 1000), \to, rrand(1001, 2000))
a.free


// A good practice is to use envelopes to free synths using doneActions
(
SynthDef("envSawFilter", {|from = 100, to = 1500, freq = 100|
	var resfreq, sig;
	resfreq = LFNoise1.kr(1).range(from, to);
	sig = Saw.ar(freq);
	sig = Resonz.ar(sig, resfreq, 0.1);
	sig = sig * EnvGen.ar(Env(), doneAction: 2);
	Out.ar(0, sig);
}).add;
)

Synth("envSawFilter", [\to, 500])

(
Routine({
	32.do {
		Synth("envSawFilter", [
			\from, rrand(100, 1000),
			\to, rrand(1001, 2000),
			\freq, rrand(50, 500)
		]);
		rrand(0.2, 2).wait;
	}
}).play
)


// SynthDescLib can be used to organize SynthDefs
(
SynthDef(\sonology, {|freq = 200, amp = 0.1|
	var sig = SinOsc.ar * Line.ar(1, 0, 1, doneAction: 2);
	Out.ar(0, sig * amp ! 2)
}).store
)

Synth(\sonology)

SynthDescLib.global.synthDescs[\sonology]

SynthDescLib.global.browse;


// SynthDefs have an additional argument for lag times
(
SynthDef(\dust, {|density = 100, amp = 0.75|
	var env, sig;
	env = EnvGen.ar(Env.new([0, 1, 0], [10, 100]), doneAction: 2);
	sig = Dust.ar(density.poll) * amp;
	Out.ar(0, sig * env ! 2)
}, [10, 100]).add
)

a = Synth(\dust)
a.set(\density, 10)
a.set(\density, 1000)
a.set(\amp, 0.0)




/////////////////// Multichannel Expansion //////////////////////


// Mix can be used with multichannel expansion to combine sounds
{ Mix.new(Blip.ar(Array.series(16, 100, 10), 50, 0.04)) ! 2 }.play


// Fill using a function
(
var times = 50, amp = 0.02;
{
	[
		Mix.fill(times, { Impulse.ar(rrand(10, 1000), mul: amp) }),
		Mix.fill(times, { Dust.ar(rrand(10, 1000), mul: amp) })
	]
}.play
)


// Splay works in a similar way but spreads over stereo
(
var times = 20;
{
	Splay.ar(
		Formant.ar(
			Array.rand(times, 100, 200),
			Array.rand(times, 1000, 200),
			Array.rand(times, 400, 800)
		),
		1, 0.2
	)
}.play
)


// Scaling values is a common task when designing SynthDefs
{ SinOsc.ar(100, add: 1000, mul: 500) }.plot

{ SinOsc.ar(100, add: 1000, mul: 500).range(4000, 4500) }.plot

{ SinOsc.ar(100).range(1, 10).linexp(1, 10, 10, 100) }.plot

{ SinOsc.ar(100).range(1, 10).explin(1, 10, 10, 100) }.plot


// Using envelopes for mapping allows defining custom curves
(
var env, point = 0.5, map;
env = Env.new([0, 0.1, 0.7, 0.8, 1.0], 0.25 ! 4);
env.plot;
map = env.at(point);
)




///////////////////////// LFO Modulation ////////////////////////////////


// Patches by D.Cottle

// SinOsc LFO (sci-fi)
(
{
	var lfo;
	lfo = SinOsc.ar(freq: 10, mul: 100, add: 400);
	SinOsc.ar(lfo, mul: 0.5)
}.play
)


// Pulse LFO (phone ring)
(
{
	var lfo;
	lfo = LFPulse.ar(freq: 15, mul: 200, add: 1000);
	SinOsc.ar(lfo, mul: 0.5)
}.play
)


// Saw LFO
(
{
	var lfo;
	lfo = LFSaw.ar(freq: 2, mul: -100, add: 600);
	SinOsc.ar(lfo, mul: 0.5)
}.play
)


// Noise LFO (computer)
(
{
	var lfo;
	lfo = LFNoise0.ar(freq: [28, 27], mul: 1000, add: 2000);
	SinOsc.ar(lfo, mul: 0.5)
}.play
)


// Triangle LFO - smooth modulation
(
{
	var lfo;
	lfo = LFTri.kr(freq: 0.5, mul: 200, add: 600);
	SinOsc.ar(lfo, mul: 0.3)
}.play
)


// LFO controlling amplitude (tremolo)
(
{
	var tremolo;
	tremolo = SinOsc.kr(freq: 6).range(0, 1);
	SinOsc.ar(440) * tremolo * 0.3
}.play
)


// LFO controlling filter cutoff
(
{
	var cutoff;
	cutoff = LFTri.kr(0.2).range(200, 2000);
	LPF.ar(Saw.ar(100, 0.5), cutoff)
}.play
)




///////////////////////// Sample and Hold ////////////////////////////////


// Latch holds a value until triggered - classic sample and hold
(
{
	var trigger, held;
	trigger = Impulse.kr(4);               // Trigger 4 times per second
	held = Latch.kr(WhiteNoise.kr, trigger); // Sample noise at each trigger
	SinOsc.ar(held.range(200, 800), mul: 0.3)
}.play
)


// Sample and hold with LFNoise0 (built-in sample and hold)
(
{
	var freq;
	freq = LFNoise0.kr(4).range(200, 800);
	SinOsc.ar(freq, mul: 0.3)
}.play
)


// Compare LFNoise types - plot them
{ LFNoise0.kr(10) }.plot(1);  // Step (sample and hold)
{ LFNoise1.kr(10) }.plot(1);  // Linear interpolation
{ LFNoise2.kr(10) }.plot(1);  // Cubic interpolation (smoothest)


// Sample and hold with quantized values (chromatic notes)
(
{
	var trigger, held, freq;
	trigger = Impulse.kr(3);
	held = Latch.kr(WhiteNoise.kr, trigger);
	freq = held.range(48, 72).round(1).midicps;  // Round to semitones
	SinOsc.ar(freq, mul: 0.3)
}.play
)


// Sample and hold controlling multiple parameters
(
{
	var trigger, freqHeld, ampHeld;
	trigger = Impulse.kr(6);
	freqHeld = Latch.kr(WhiteNoise.kr, trigger).range(200, 1000);
	ampHeld = Latch.kr(WhiteNoise.kr, trigger).range(0.1, 0.5);
	SinOsc.ar(freqHeld, mul: ampHeld)
}.play
)


// TRand - triggered random number (another sample and hold approach)
(
{
	var trigger, freq;
	trigger = Impulse.kr(5);
	freq = TRand.kr(300, 900, trigger);  // Random freq on each trigger
	Saw.ar(freq, 0.2)
}.play
)


// TChoose - randomly choose from an array on trigger
(
{
	var trigger, freq;
	trigger = Impulse.kr(4);
	freq = TChoose.kr(trigger, [100, 200, 300, 400, 600, 800]);
	SinOsc.ar(freq, mul: 0.3)
}.play
)




////////////////////////// Patterns ////////////////////////////


// Pfindur can be used to play for a fixed amount of time
(
var pattern, duration = 5, clock;
clock = TempoClock.new(180/60);
pattern = Pbind(\midinote, Pwhite(60, 80), \dur, 0.1);
Pfindur(duration, pattern).play(clock);
)


// Pmono plays one instance of a synth while changing args
(
SynthDef(\gray, {|freq = 200, amp = 0.2|
	var env, sig;
	env = EnvGen.ar(Env.new([0, 1, 0], [10, 10]), doneAction: 2);
	sig = BPF.ar(GrayNoise.ar(amp), freq);
	Out.ar(0, sig * env ! 2)
}).add(nil, {
	Pmono(\gray,
		\dur, Penv([0.01, 0.5, 0.1], [10, 10]),
		\freq, Pwhite(200, 650, inf)
	).play
})
)


// EventStreamPlayer holds a reference to a playing pattern
(
SynthDef(\perc, {|freq = 1200, amp = 1.0|
	var enva, envb, sig;
	enva = EnvGen.ar(Env.perc, doneAction: 2);
	envb = EnvGen.ar(Env.new([150, 80, 60], [0.2, 1]), doneAction: 2);
	sig = SinOsc.ar(envb) * enva;
	Out.ar(0, sig * amp ! 2)
}).add(nil, {
	~pattern = Pbind(
		\instrument, \perc,
		\dur, 0.8
	).play
});
)

~pattern.stop

~pattern.play(TempoClock.new(140/60))

~sound = { Impulse.ar(10) * 0.5 ! 2 }.play

~sound.run(false)

~sound.run(true)
