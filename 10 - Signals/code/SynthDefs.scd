////////////////////////////////////////////////////////////////
//
//                      SynthDefs
//
////////////////////////////////////////////////////////////////

// Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.
Quarks.fetchDirectory(true);
Quarks.install("SafetyNet");
thisProcess.recompile;
)


////////////////////////// SynthDef ////////////////////////////


// An easy way to audition sounds is by using {}.play
{ Saw.ar(Line.kr(40, 1000, 5), 0.1) }.play


/*
   This actually creates a 'SynthDef' behind the scenes.
   However, if we would like to change any values or play
   the sound with patterns, we have to create the SynthDef
   ourselves.

   Below is a step-by-step process of creating a SynthDef.
*/




// - STEP 1. Empty SynthDef -

// Empty SynthDef with name, empty block and .add (to server).
SynthDef(\mySynth, { }).add;

// Play the Synth: no sound but SynthCounter goes up.
Synth(\mySynth)




// - STEP 2. Add a Saw Oscillator and Out.ar -

SynthDef(\mySynth, { Out.ar(0, Saw.ar(60)) }).add;

// Play the Synth: static saw wave at 60 Hz.
Synth(\mySynth)




// - STEP 3. Add inputs (arguments) for frequency and amplitude -

SynthDef(\mySynth, {|amp = 0.2, freq = 60|
	Out.ar(0, Saw.ar(freq, amp))
}).add;

// Play the Synth: saw wave at 150 Hz.
Synth(\mySynth, [\amp, 0.5, \freq, 150])




// - STEP 4. Add an ASR envelope for amplitude with doneAction: 2 -

(
SynthDef(\mySynth, {|amp = 0.2, freq = 60, gate = 1|
	var env = EnvGen.ar(Env.asr(1, 1, 1), gate, doneAction: 2);
	var sound = Saw.ar(freq, amp);
	Out.ar(0, sound * env);
}).add;
)

// Play the Synth: a sustained saw.
x = Synth(\mySynth)

// Set the gate to 0 (release the envelope)
x.set(\gate, 0)




// - STEP 5. Add inputs for the envelope -

(
SynthDef(\mySynth, {|amp = 0.2, freq = 60, gate = 1, atk = 1, sus = 1, rel = 1|
	var env = EnvGen.ar(Env.asr(atk, sus, rel), gate, doneAction: 2);
	var sound = Saw.ar(freq, amp);
	Out.ar(0, sound * env);
}).add;
)

x = Synth(\mySynth, [\freq, 75, \atk, 4, \sus, 0.8, \rel, 5])

x.set(\gate, 0)




// - STEP 6. Play with patterns -

(
Pbind(
	\instrument, \mySynth,
	\freq, Pwhite(50, 100)
).play
)




// -----------------------------------------------------------------

//   SynthDef Blueprint

(
SynthDef(\mySynth, {|amp = 0.2, freq = 60, gate = 1, atk = 1, sus = 1, rel = 1|
	var env = EnvGen.ar(Env.asr(atk, sus, rel), gate, doneAction: 2);

	// Replacing the sound with something else?
	var sound = Saw.ar(freq, amp);

	Out.ar(0, sound * env);
}).add;
)




// Example of a substitution
(
SynthDef(\mySynth, {|amp = 0.2, freq = 60, gate = 1, atk = 1, sus = 1, rel = 1|
	var env = EnvGen.ar(Env.asr(atk, sus, rel), gate, doneAction: 2);
	var sound = Impulse.ar(LFNoise1.ar([freq/10, freq/2], 200, 220), 0, 0.2);
	Out.ar(0, sound * env);
}).add;
)

x = Synth(\mySynth, [\freq, 500])

x.set(\gate, 0)




////////////////////////// More SynthDef Examples ////////////////////////////


// Simple sine with percussive envelope
(
SynthDef(\simpleSine, {|freq = 440, amp = 0.3|
	var env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction: 2);
	var sig = SinOsc.ar(freq, mul: amp * env);
	Out.ar(0, sig ! 2);
}).add;
)

Synth(\simpleSine, [\freq, 300])
Synth(\simpleSine, [\freq, 400])
Synth(\simpleSine, [\freq, 500])


// SynthDef with LFO modulation built in
(
SynthDef(\lfoSynth, {|freq = 200, amp = 0.3, lfoRate = 4, lfoDepth = 50|
	var env = EnvGen.kr(Env.perc(0.1, 1), doneAction: 2);
	var lfo = SinOsc.kr(lfoRate, mul: lfoDepth);
	var sig = SinOsc.ar(freq + lfo, mul: amp * env);
	Out.ar(0, sig ! 2);
}).add;
)

Synth(\lfoSynth)
Synth(\lfoSynth, [\lfoRate, 10, \lfoDepth, 100])


// SynthDef with filter
(
SynthDef(\filteredSaw, {|freq = 100, amp = 0.3, cutoff = 1000, rq = 0.3|
	var env = EnvGen.kr(Env.perc(0.01, 0.8), doneAction: 2);
	var sig = Saw.ar(freq);
	sig = RLPF.ar(sig, cutoff, rq);
	Out.ar(0, sig * amp * env ! 2);
}).add;
)

Synth(\filteredSaw, [\cutoff, 500])
Synth(\filteredSaw, [\cutoff, 2000])


// SynthDef with sample and hold
(
SynthDef(\sampleHold, {|baseFreq = 200, amp = 0.3, rate = 4|
	var env = EnvGen.kr(Env.linen(0.5, 2, 0.5), doneAction: 2);
	var trigger = Impulse.kr(rate);
	var freq = Latch.kr(WhiteNoise.kr.range(baseFreq, baseFreq * 4), trigger);
	var sig = SinOsc.ar(freq, mul: amp * env);
	Out.ar(0, sig ! 2);
}).add;
)

Synth(\sampleHold)
Synth(\sampleHold, [\rate, 8, \baseFreq, 100])


// SynthDef with stereo panning
(
SynthDef(\pannedSine, {|freq = 440, amp = 0.3, pan = 0|
	var env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction: 2);
	var sig = SinOsc.ar(freq, mul: amp * env);
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

Synth(\pannedSine, [\pan, -1])  // Left
Synth(\pannedSine, [\pan, 0])   // Center
Synth(\pannedSine, [\pan, 1])   // Right
