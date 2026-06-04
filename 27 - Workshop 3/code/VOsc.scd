////////////////////////////////////////////////////////////////
//
//                           VOsc
//
////////////////////////////////////////////////////////////////


Wavetable synthesis with VOsc. VOsc reads a bank of contiguous
wavetable buffers and interpolates between them by buffer index,
so modulating the index morphs the timbre.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


/////////////////////// Wavetable Bank //////////////////////////


// Load every .wav in ./tables as a wavetable.
(

Routine {

	var dir = thisProcess.nowExecutingPath.dirname +/+ "tables";
	~paths = (dir +/+ "*.wav").pathMatch.sort;
	~wt = Buffer.allocConsecutive(~paths.size, s, 2048, 1);
	s.sync;
	~paths.do {|path, i|
		var sf = SoundFile.openRead(path);
		var data = FloatArray.newClear(sf.numFrames * sf.numChannels);
		sf.readData(data);
		sf.close;
		// keep channel 1, resample one cycle to 1024, store as a wavetable
		~wt[i].loadCollection(
			data.unlace(sf.numChannels)[0].as(Signal).resamp1(1024).as(Signal).asWavetable
		);
	};
	s.sync;
	("Loaded" + ~paths.size + "wavetables from" + dir).postln;
}.play;

)


/////////////////////// Reading the Bank ////////////////////////


// Read the first wavetable as a fixed tone

{ VOsc.ar(~wt[1].bufnum, 200, 0, 0.1) ! 2 }.play


// Mouse sweeps the buffer index — morph through the bank

{ VOsc.ar(MouseX.kr(0, ~wt.size - 1) + ~wt[0].bufnum, 150, 0, 0.2) ! 2 }.play


// Slow noise drifts the index for each channel independently

(
{
	var base = ~wt[0].bufnum;
	[
		VOsc.ar(LFNoise2.ar(0.1).range(0, ~wt.size - 1) + base, 150),
		VOsc.ar(LFNoise2.ar(0.13).range(0, ~wt.size - 1) + base, 151)
	] * 0.2
}.play
)


/////////////////////// Smooth Drift ////////////////////////////


// Two detuned voices, drifting index and frequency, slow envelope

(
{
	var base = ~wt[0].bufnum;
	var freq = SinOsc.ar(0.075).range(600, 610);
	var env = EnvGen.ar(Env([0, 1, 0.6, 0], [6, 10, 15], [4, -2, -4]), doneAction: 2);
	var sig = [
		VOsc.ar(LFNoise2.ar(0.04).range(0, ~wt.size - 1) + base, freq),
		VOsc.ar(LFNoise2.ar(0.02).range(0, ~wt.size - 1) + base, freq * 1.01)
	];
	sig = HPF.ar(sig, 200) * env * 0.2;
	Out.ar(0, FreeVerb.ar(sig, 0.3, 0.8));
}.play
)


/////////////////////// Chaotic Drift ///////////////////////////


// Gbman chaos and jitter on the modulation, folded distortion

(
{
	var base = ~wt[0].bufnum;
	var chaos = GbmanL.ar(15).range(0.6, 1.4);
	var mod = SinOsc.ar(0.075 * LFNoise0.ar(2).range(0.75, 1.25)).range(20, 10);
	var jitter = LFNoise0.ar(12).range(0.95, 1.05);
	var freq = SinOsc.ar(mod).range(600, 610) * jitter;
	var env = EnvGen.ar(Env([0, 1, 0.6, 0], [6, 10, 15], [4, -2, -4]), doneAction: 2);
	var sig = [
		VOsc.ar(LFNoise0.ar(0.14).range(0, ~wt.size - 1) + base, freq),
		VOsc.ar(LFNoise0.ar(0.28).range(0, ~wt.size - 1) + base, freq * 1.025)
	];
	sig = (sig * 3).tanh.fold2(0.75);
	sig = HPF.ar(sig, 200) * env * SinOsc.ar(mod * chaos).range(0.05, 0.3);
	Out.ar(0, FreeVerb.ar(sig, 0.35, 0.85));
}.play
)
