////////////////////////////////////////////////////////////////
//
//                           Filters
//
////////////////////////////////////////////////////////////////

This class covers examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


/////////////////////////// Noises and Filters ////////////////////////////


/* Resonant lopass filter. The resonance is specified with reciprocal of
q (rq) where rq is bandwidth/cutoffFreq, smaller the rq, the narrower the
bandwidth */

(
	{
	RLPF.ar(WhiteNoise.ar(0.2), SinOsc.kr(10, 0, 450, 550), 0.5)
	}.freqscope
)




// Resonant hipass filter.
(
	{
		RHPF.ar(Dust.ar(1200, 0.75), MouseY.kr(10000, 100), MouseX.kr(0.01, 0.9))
	}.freqscope
)




// Bandpass filter
(
	{
		BPF.ar(WhiteNoise.ar(0.5),MouseX.kr(5000, 60), MouseY.kr(0.01, 0.9))
	}.freqscope
)




// BEQSuite lopass, slightly different flavor
(
	{
		BLowPass4.ar(Dust.ar(MouseY.kr(200, 4000), 0.75), MouseY.kr(10000, 100), MouseX.kr(0.005, 0.9))
	}.play
)




// A digital implementation of the Moog VCF (filter)
(
	{ var maxFreq = 8000, modSpeed=0.2;
		MoogFF.ar(WhiteNoise.ar(0.8), maxFreq * SinOsc.kr(modSpeed, 0, 0.5, 0.5), 3)
	}.play
)




// DFM1 is a digitally modelled analog filter. Will oscillate at high frequencies
(
	{
		DFM1.ar(PinkNoise.ar(mul: 0.5), MouseX.kr(20, 8000), MouseY.kr(0.05, 1.3))
	}.play
)




// Play noises with patterns
(
	SynthDef(\noise, {
	|out = 0, pan = 0, gate=1, freq = 1400, atk = 0.01, rel = 0.5, rq = 0.5, amp = 0.1|
		var noise, env, filter, sig;
		noise = WhiteNoise.ar(0.5);
	    env = EnvGen.kr(Env.asr(0, 1, 3), gate);
		filter = BLowPass.ar(noise, freq,  rq);
		sig = filter * env;
		Out.ar(out, Pan2.ar(sig, pan));
	}).add;
)


m = Synth("noise", [\freq, 1000])
m.set(\gate, 0)

Pmono(\noise, \freq, Pwhite(100, 600), \dur, 0.15).play

Pbind(\instrument, \noise, \freq, Pexprand(100, 800), \rq, Pexprand(0.01, 0.4), \dur, 0.5, \amp, 0.05).play;
