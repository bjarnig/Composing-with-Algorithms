////////////////////////////////////////////////////////////////
//
//                       Errors
//
////////////////////////////////////////////////////////////////


s.boot;

( // run this to load the buffer

~buf = Buffer.read(s, (PathName(thisProcess.nowExecutingPath)).pathOnly ++ "/samples/mahler.wav");

)


///////////////////// Buffer-manipulation //////////////////////


( // Extreme time scrambling

{
	var rate = BufRateScale.kr(~buf);
	var phase = Phasor.ar(0, rate, 0, BufFrames.kr(~buf));
	var jitter = LFNoise1.ar(50!2).range(-5000, 5000);
	BufRd.ar(1, ~buf, phase + jitter) * 0.5;
}.play;

)


( // Backwards/forwards corruption

{
	var rate = BufRateScale.kr(~buf) * LFNoise0.ar(10).range(-2, 2);
	PlayBuf.ar(1, ~buf, rate, loop: 1) ! 2 * 0.5;
}.play;

)


( // Pitch scrambling

{
	var rate = LFNoise1.ar([5, 5.1]).exprange(0.25, 4);
	PlayBuf.ar(1, ~buf, rate, loop: 1) * 0.5;
}.play;

)



( // Sample rate reduction + buffer modulation

{
	var rate = BufRateScale.kr(~buf);
	var phase = Phasor.ar(0, rate, 0, BufFrames.kr(~buf));
	var jitter = LFNoise1.ar(20!2).range(-1000, 1000);
	var buf = BufRd.ar(1, ~buf, phase + jitter);

	var sampleRate = LFNoise1.kr(2).exprange(200, 8000);
	var latchTrig = Impulse.ar(sampleRate);

	Latch.ar(buf, latchTrig) * 0.5;
}.play;

)


////////////////////////// Artifacts ///////////////////////////


( // Transcoding errors (multiple format conversions)

{
	var sig = PlayBuf.ar(2, ~buf);
	sig = sig + Pulse.ar(60, Amplitude.ar(sig));

	// "MP3" compression
	sig = sig.round(0.3);
	sig = Latch.ar(sig, Impulse.ar(8000));

	// "OGG" compression
	sig = sig.round(0.2);
	sig = Latch.ar(sig, Impulse.ar(6000));

	// "AAC" compression
	sig = sig.round(0.15);
	sig = Latch.ar(sig, Impulse.ar(4000));

	sig ! 2 * 0.2;
}.play;

)

( // Codec switching artifacts

{
	var sig = PlayBuf.ar(2, ~buf);
	var codecSwitch = LFNoise0.kr(5).range(0, 3);

	var codecs = [
		// "High quality"
		{ |s| Latch.ar(s.round(0.5), Impulse.ar(22050)) },
		// "Medium quality"
		{ |s| Latch.ar(s.round(0.2), Impulse.ar(11025)) },
		// "Low quality"
		{ |s| Latch.ar(s.round(0.05), Impulse.ar(5512)) },
		// "Terrible quality"
		{ |s| Latch.ar(s.round(0.01), Impulse.ar(2756)) }
	];

	Select.ar(codecSwitch, codecs.collect(_.value(sig))) ! 2 * 0.3;
}.play;

)


( // Codec through bent hardware

{
	var sig = PlayBuf.ar(2, ~buf);
	var unstablePower = LFNoise1.ar(50).range(0.8, 1.2);
	var contact = LFNoise0.ar(100) > 0.3;

	sig = sig.round(0.3);
	sig = Latch.ar(sig, Impulse.ar(5512));
	sig = sig * unstablePower;
	sig = sig * contact;
	sig * 0.3;

}.play;

)

////////////////////////// Time-based ///////////////////////////

( // Granular stutter

{
	var trig = Dust.ar(20);
	var freq = TExpRand.ar(200, 2000, trig);
	var pan = TRand.ar(-1, 1, trig);
	var stutterRate = ToggleFF.ar(Dust.ar(3)).lag(0.01);  // freeze randomly
	GrainSin.ar(2, trig * stutterRate, 0.1, freq, pan) * 0.2;
}.play;

)


( // Random tempo stuttering

{
	var tempo = LFNoise0.kr(5).exprange(2, 20);
	var trig = Impulse.kr(tempo);
	var sig = SinOsc.ar(440);
	var env = EnvGen.kr(Env.perc(0.001, 0.05), trig);
	sig * env ! 2 * 0.3;
}.play;

)


( // Irregular pulsing

{
	var trig = Dust.kr(10);  // random trigger rate
	var freq = TExpRand.kr(200, 2000, trig);
	var sig = SinOsc.ar(freq);
	var env = EnvGen.kr(Env.perc(0.001, 0.1), trig);
	sig * env ! 2 * 0.3;
}.play;

)


( // Time stretching errors

{
	var rate = LFNoise1.kr(1).range(0.1, 10);
	PlayBuf.ar(1, ~buf, BufRateScale.kr(~buf) * rate, loop: 1) ! 2 * 0.5;
}.play;

)


( // Rhythmic glitching

{
	var normalTempo = 8;
	var glitchTempo = 80;
	var isGlitch = LFPulse.kr(0.5, 0, 0.1);
	var tempo = Select.kr(isGlitch, [normalTempo, glitchTempo]);
	var trig = Impulse.kr(tempo);
	var sig = Pulse.ar(330, 0.5);
	var env = EnvGen.kr(Env.perc(0.001, 0.02), trig);
	sig * env ! 2 * 0.3;
}.play;

)


////////////////////////// Dropouts ///////////////////////////


( // Random muting

{
	var sig = SinOsc.ar(440);
	var gate = LFNoise0.kr(10) > 0;  // 50% chance of mute
	sig * gate ! 2 * 0.3;
}.play;

)


( // Weighted dropouts (mostly playing)

{
	var sig = SinOsc.ar(440);
	var gate = LFNoise1.kr(5) > -0.5;  // 75% on, 25% off
	sig * gate ! 2 * 0.3;
}.play;

)


( // Envelope-based cuts

{
	var sig = Pulse.ar([120, 222]);
	var cutTrig = Dust.kr(4);
	var env = EnvGen.kr(Env([1, 0, 1], [0.001, 0.1]), cutTrig);
	sig * env * 0.3;
}.play;

)


( // Random channel dropouts

{
	var sig = SinOsc.ar(440);
	var leftGate = LFNoise0.kr(8) > 0;
	var rightGate = LFNoise0.kr(7) > 0;
	[sig * leftGate, sig * rightGate] * 0.3;
}.play;

)
