////////////////////////////////////////////////////////////////
//
//                     Wavetables
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

( // Load as array for VOsc (consecutive buffers)

~tablePath = (PathName(thisProcess.nowExecutingPath)).pathOnly ++ "tables/";

~loadWavetablesAsArray = { |path, callback|
	var files = SoundFile.collect(path ++ "*.wav").sort({ |a, b|
		// Sort by filename to ensure consistent order
		a.path.split($/).last < b.path.split($/).last
	});

	Routine({
		var buffers = [];

		files.do { |sf, i|
			var signal, file, wavetable;

			file = SoundFile.new;
			file.openRead(sf.path);
			s.sync;

			signal = Signal.newClear(file.numFrames);
			file.readData(signal);
			file.close;
			s.sync;

			wavetable = signal.asWavetable;
			buffers = buffers.add(Buffer.loadCollection(s, wavetable));
			s.sync;

			("Loaded table " ++ (i + 1) ++ ": " ++ sf.path.split($/).last).postln;
		};

		callback.(buffers);
	}).play;
};

// Load into ~wtArray for sequential access
~loadWavetablesAsArray.(~tablePath, { |buffers|
	~wtArray = buffers;
	("Loaded " ++ buffers.size ++ " wavetables into ~wtArray").postln;
});

)

///////////////////////// OSC //////////////////////////


( // Test loaded wavetables from array

{
	var index = ~wtArray.size.rand;
	("Playing table index: " ++ index).postln;
	Osc.ar(~wtArray[index], 100, mul: 0.4) ! 2
}.play

)



( // Morph through file-based wavetables

{
	var numTables = ~wtArray.size;
	var bufpos = ~wtArray[0].bufnum + SinOsc.kr(0.1).range(0, numTables - 1.01);
	VOsc.ar(bufpos, 80, mul: 0.4) ! 2
}.play

)



( // Random selection from dictionary

{
	var trig = Dust.kr(4);
	var index = TIRand.kr(0, ~wtArray.size - 1, trig);
	var buf = Select.kr(index, ~wtArray.collect { |k| k.bufnum });
	var freq = TExpRand.kr(60, 200, trig);

	Osc.ar(buf, freq, mul: 0.4) ! 2
}.play

)

///////////////////////// VOsc //////////////////////////

( // Basic VOsc - morph between wavetables

{
	var bufpos = ~wtArray[0].bufnum + SinOsc.kr(0.2).range(0, 7);
	VOsc.ar(bufpos, 80, mul: 0.4) ! 2
}.play

)



( // VOsc with LFNoise modulation (smooth morphing)

{
	var bufpos = ~wtArray[0].bufnum + LFNoise2.kr(0.5).range(0, 7);
	var freq = 100;
	VOsc.ar(bufpos, freq, mul: 0.4) ! 2
}.play

)



( // Stereo VOsc with independent buffer indices

{
	var freq = 80;
	var bufposL = ~wtArray[0].bufnum + LFNoise2.kr(0.3).range(0, 6);
	var bufposR = ~wtArray[0].bufnum + LFNoise2.kr(0.4).range(1, 7);
	[VOsc.ar(bufposL, freq), VOsc.ar(bufposR, freq * 1.003)] * 0.4
}.play

)



( // VOsc with chaotic buffer index

{
	var chaos = StandardN.ar(5).range(0, 6);
	var freq = 100;
	var bufpos = ~wtArray[0].bufnum + chaos;
	VOsc.ar(bufpos, freq, mul: 0.3) ! 2
}.play

)



( // Multi-layer VOsc with detuning

{
	var numLayers = 4;
	var freq = 40;

	var sig = Mix.fill(numLayers, { |i|
		var detune = 1 + (i * 0.008);
		var bufpos = ~wtArray[0].bufnum + LFNoise2.kr(0.2 + (i * 0.1)).range(0, 7);
		VOsc.ar(bufpos, freq * detune) / numLayers
	});

	sig ! 2 * 0.5
}.play

)


///////////////////////// VOsc3 //////////////////////////


( // VOsc3 - smoother transitions (mixes 3 adjacent tables)

{
	var bufpos = ~wtArray[0].bufnum + SinOsc.kr(0.15).range(0, 5);
	var freq = 60;
	VOsc3.ar(bufpos, freq, freq * 1.01, freq * 0.99, mul: 0.3) ! 2
}.play

)



( // VOsc3 with rhythmic buffer switching

{
	var trig = Impulse.kr(3);
	var pattern = Dseq([0, 2, 5, 1, 4, 3], inf);
	var bufoffset = Demand.kr(trig, 0, pattern);
	var bufpos = ~wtArray[0].bufnum + Lag.kr(bufoffset, 0.1);
	var freq = 70;

	VOsc3.ar(bufpos, freq, freq * 1.005, freq * 0.995, mul: 0.4) ! 2
}.play

)


///////////////////////// COSC //////////////////////////


( // COsc - built-in chorusing effect

{
	var freq = 100;
	var beats = 0.5;  // detuning amount in Hz
	COsc.ar(~wtArray.choose, freq, beats, mul: 0.4) ! 2
}.play

)



( // COsc with modulated beat frequency

{
	var freq = 80;
	var beats = SinOsc.kr(0.1).range(0.1, 2);
	COsc.ar(~wtArray.choose, freq, beats, mul: 0.4) ! 2
}.play

)



( // Layered COsc at different frequencies

{
	var freqs = [60, 90, 120];
	var sig = Mix(freqs.collect { |f, i|
		var beats = LFNoise1.kr(0.2).range(0.2, 1.5);
		COsc.ar(~wtArray.choose, f, beats, mul: 0.1)
	});
	sig ! 2
}.play

)


///////////////////////// MORE //////////////////////////

( // Brownian walk through wavetables

{
	var bufpos = ~wtArray[0].bufnum + LFBrownNoise1.kr(2).range(0, 7);
	var freq = 100;
	VOsc.ar(bufpos, freq, mul: 0.4) ! 2
}.play

)



( // Demand-rate wavetable sequencing

{
	var trig = Impulse.kr(8);
	var pattern = Dxrand([0, 1, 2, 3, 4, 5, 6, 7], inf);
	var bufoffset = Demand.kr(trig, 0, pattern);
	var bufpos = ~wtArray[0].bufnum + Lag.kr(bufoffset, 0.02);
	var freq = Demand.kr(trig, 0, Dseq([80, 100, 120, 80], inf));

	VOsc.ar(bufpos, Lag.kr(freq, 0.05), mul: 0.4) ! 2
}.play

)



( // Audio-rate buffer modulation (extreme)

{
	var modFreq = 5;
	var bufpos = ~wtArray[0].bufnum + SinOsc.ar(modFreq).range(0, 6);
	var freq = 80;
	VOsc.ar(bufpos, freq, mul: 0.3) ! 2
}.play

)



( // Cross-modulated wavetable position

{
	var freq = 100;
	var mod1 = SinOsc.kr(0.13);
	var mod2 = SinOsc.kr(0.17);
	var bufpos = ~wtArray[0].bufnum + ((mod1 * mod2 + 1) * 3.5);

	VOsc.ar(bufpos, freq, mul: 0.4) ! 2
}.play

)


///////////////////////// WAVETABLE + WAVESHAPING //////////////////////////


( // VOsc with wrap distortion

{
	var bufpos = ~wtArray[0].bufnum + LFNoise2.kr(0.2).range(0, 7);
	var freq = 60;
	var sig = VOsc.ar(bufpos, freq);
	sig = sig.wrap2(SinOsc.ar([0.5, 0.51]).range(0.2, 0.6));
	sig * 0.4
}.play

)



( // Ring modulation between two VOsc

{
	var freq = 80;
	var bufpos1 = ~wtArray[0].bufnum + LFNoise2.kr(0.2).range(0, 5);
	var bufpos2 = ~wtArray[0].bufnum + LFNoise2.kr(0.15).range(2, 7);
	var sig1 = VOsc.ar(bufpos1, freq);
	var sig2 = VOsc.ar(bufpos2, freq * 1.5);

	(sig1 * sig2) * 0.5 ! 2
}.play

)



///////////////////////// TEXTURES //////////////////////////


( // Evolving drone

{
	var numVoices = 6;
	var baseFreq = 50;

	var sig = Mix.fill(numVoices, { |i|
		var freq = baseFreq * [1, 1.5, 2, 2.5, 3, 4][i];
		var bufpos = ~wtArray[3].bufnum + LFNoise2.kr(0.1 + (i * 0.02)).range(0, 7);
		var amp = 1 / (i + 1);
		VOsc.ar(bufpos, freq * LFNoise1.kr(0.05).range(0.99, 1.01)) * amp
	});

	sig = sig / numVoices;
	sig = LPF.ar(sig, LFNoise1.kr(0.1).range(1000, 4000));
	sig ! 2 * 0.5
}.play

)



( // Granular-like wavetable

{
	var trig = Dust.kr(20);
	var bufpos = ~wtArray[6].bufnum + TRand.kr(0, 7, trig);
	var freq = TExpRand.kr(60, 200, trig);
	var amp = TRand.kr(0.1, 0.4, trig);

	var sig = VOsc.ar(bufpos, freq) * amp;
	sig = sig * EnvGen.ar(Env.perc(0.001, 0.1), trig);
	Splay.ar(sig ! 4, 0.8)
}.play

)

