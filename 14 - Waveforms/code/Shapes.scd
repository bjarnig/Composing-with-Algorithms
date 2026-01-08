////////////////////////////////////////////////////////////////
//
//                          Shapes
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


////////////////////////// Waveforms ///////////////////////////


( // Envelopes for waveforms

{   var freq = 5, points = 10256, env, values, durations;
	values = Array.fill(points, { rrand(-1.0, 1.0)});
	durations = Array.fill(points, { rrand(0.0, 1.0)}).normalizeSum;
	env = Env(values, durations).circle;
	EnvGen.ar(env, timeScale:freq.reciprocal) * 0.2;
}.play;

)




( // Envelopes again, frequency varies

{   var freq, points = 512, env, values, durations;
	values = Array.fill(points, { rrand(-1.0, 1.0)});
	durations = Array.fill(points, { rrand(0.0, 1.0)}).normalizeSum;
	env = Env(values, durations).circle;
	freq = 100 * SinOsc.kr(0.1, mul: 0.4, add: 0.5);
	EnvGen.ar(env, timeScale:freq.reciprocal) * 0.2 ! 2;
}.play;

)




( // Generate a buffer and read with Osc

    var wavetable, buffer, conditions;
    conditions = {arg i; if(i % 8 == 0, {0.1.rand},{0.8.rand})};
    wavetable = Signal.fill(8192,conditions).asWavetable;
    buffer = Buffer.loadCollection(Server.default, wavetable, 1, {
    { Osc.ar(buffer,1,mul:0.5) ! 2 }.play });
)




( // Different buffer and varying frequency

    var wavetable, buffer, conditions, mod;
    conditions = { arg i;
	if(i % 8 == 0, {rrand(0.1, 0.2)});
	if(i % 4 == 0, {rrand(0.3, 0.4)});
	if(i % 2 == 0, {rrand(0.6, 0.8)}, {rrand(0.7, 0.9)})};
    wavetable = Signal.fill(4096,conditions).asWavetable;
    buffer = Buffer.loadCollection(Server.default, wavetable, 1, {
	{   var mod = mod = SinOsc.kr(0.01, 0, 1, 2);
		Osc.ar(buffer, 10 * LFNoise0.kr(mod, 0.5, 0.4), mul:0.5) ! 2 }.play });
)



( // Sine wave with additive noise (periodic backbone, noisy details)

var size = 4096;
var noiseAmount = 0.15;
var signal = Signal.fill(size, { |i|
	var phase = i / size * 2pi;
	sin(phase) + rrand(noiseAmount.neg, noiseAmount)
});
var wavetable = signal.asWavetable;

Buffer.loadCollection(s, wavetable, 1, { |buf|
	{ Osc.ar(buf, 80, mul: 0.4) ! 2 }.play
});
)



( // Quantized sine (periodic structure, stepped noise)

var size = 4096;
var quantLevels = 8;  // number of amplitude levels
var signal = Signal.fill(size, { |i|
	var phase = i / size * 2pi;
	var val = sin(phase);
	// Quantize to discrete levels
	(val * quantLevels).round / quantLevels + rrand(-0.03, 0.03)
});
var wavetable = signal.asWavetable;

Buffer.loadCollection(s, wavetable, 1, { |buf|
	{ Osc.ar(buf, 90, mul: 0.4) ! 2 }.play
});
)



( // Odd harmonics only (square-like) with noisy amplitudes

var size = 4096;
var numHarmonics = 5;
var signal = Signal.fill(size, { |i|
	var phase = i / size * 2pi;
	var sum = 0;
	numHarmonics.do { |h|
		var harmonic = (h * 2) + 1;  // 1, 3, 5, 7, 9...
		var amp = rrand(0.5, 1.0) / harmonic;
		sum = sum + (sin(phase * harmonic) * amp);
	};
	sum
}).normalize;
var wavetable = signal.asWavetable;

Buffer.loadCollection(s, wavetable, 1, { |buf|
	{ Osc.ar(buf, 70, mul: 0.4) ! 2 }.play
});
)



( // Wavetable with probability-based segments

var size = 4096;
var signal = Signal.fill(size, { |i|
	var phase = i / size;
	var val;
	// Different probability zones
	val = case
		{ phase < 0.25 } { sin(phase * 8pi) * rrand(0.8, 1.0) }  // fast sine
		{ phase < 0.5 }  { rrand(-0.3, 0.3) }                     // noise zone
		{ phase < 0.75 } { sin(phase * 4pi) * rrand(0.6, 0.9) }   // medium sine
		{ true }         { phase.linlin(0.75, 1.0, 0.5, -0.5) + rrand(-0.1, 0.1) };  // ramp + noise
	val
});
var wavetable = signal.asWavetable;

Buffer.loadCollection(s, wavetable, 1, { |buf|
	{ Osc.ar(buf, 40, mul: 0.4) ! 2 }.play
});
)