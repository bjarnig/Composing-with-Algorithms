////////////////////////////////////////////////////////////////
//
//                          Modelling
//
////////////////////////////////////////////////////////////////

This class covers examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


////////////////////// Physical Modeling ////////////////////////


(
SynthDef("pluck", {arg beat=1.0, dec=1.0, pitch=60, amp=0.5;
	var sig, delay, trig, source;
	// calculate the delay time from MIDI pitch:
	delay = pitch.midicps.reciprocal;
	// a clock:
	trig = Impulse.ar(beat);
	// a sound source to process:
	source = GrayNoise.ar(amp);
	// a triggered percussive envelope on the source:
	sig = Decay2.ar(trig, 0.003, 0.05, source);
	// comb filter (delay with feedback) on the percussive signal:
	sig = CombL.ar(sig, 0.2, [delay, delay*1.01], dec);
	// remove the DC offset that comes from the comb:
	sig = LeakDC.ar(sig);
	// send the signal to the output:
	Out.ar(0, sig)
	}).add;
)



// Test it with a single synth:
y = Synth("pluck", [\beat, 1, \pitch, 80, \dec, 1.5, \amp, 0.4 ])
y.free



// Use whitenoise for excitation
(
	{
		var burstEnv, att = 0, dec = 0.001;
		var burst, delayTime, delayDecay = 0.5;
		var midiPitch = 40; // A 440
		delayTime = midiPitch.midicps.reciprocal;
		burstEnv = EnvGen.kr(Env.perc(att, dec),
		gate: Impulse.kr(1/delayDecay));
		burst = WhiteNoise.ar(burstEnv);
		CombL.ar(burst, delayTime, delayTime, delayDecay, add:burst);
	}.play
)



// Use pinknoise for excitation
(
	{
		var burstEnv, att = 0, dec = 0.001;
		var burst, delayTime, delayDecay = 0.5;
		var midiPitch = 70;
		delayTime = midiPitch.midicps.reciprocal;
		burstEnv = EnvGen.kr(Env.perc(att, dec),
		gate: Impulse.kr(1/delayDecay));
		burst = PinkNoise.ar(burstEnv);
		CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
	}.play
)
