////////////////////////////////////////////////////////////////
//
//                      Randomness
//
////////////////////////////////////////////////////////////////


// Random number from a trigger
(
{
	TRand.kr(1, 10, Impulse.kr(1.0)).poll(10)
}.play;
)


// Exponential random number from a trigger
(
{
	TExpRand.kr(1, 10, Impulse.kr(1.0)).poll(10)
}.play;
)


// LFNoise0 generates step noise (sample and hold)
(
{
	Impulse.ar(LFNoise0.ar([4, 8], 200, 220), 0, 0.2)
}.play;
)


// LFNoise1 generates ramp noise (linear interpolation)
(
{
	Impulse.ar(LFNoise1.ar([4, 8], 200, 220), 0, 0.2)
}.play;
)


// LFNoise2 generates smooth noise (cubic interpolation)
(
{
	SinOsc.ar(LFNoise2.kr([1, 1.1]).range(200, 600), mul: 0.3)
}.play;
)


// One random number with exponential distribution
(
{
	Impulse.ar(ExpRand(10, 100), 0, 0.2)
}.play;
)


// One random number with uniform distribution
(
{
	thisThread.randSeed = 7;
	Impulse.ar(NRand(100, 200, 1), 0, 0.2)
}.play;
)


// Use seed for repeated randomness
(
{
	RandSeed.kr(Impulse.kr(4), 1980);
	PinkNoise.ar;
}.play
)




/////////////////////// Random Choices ///////////////////////


// TChoose - randomly select from array on trigger
(
{
	var trigger = Impulse.kr(4);
	var freq = TChoose.kr(trigger, [200, 300, 400, 500, 600]);
	SinOsc.ar(freq, mul: 0.3)
}.play;
)


// TWChoose - weighted random selection
(
{
	var trigger = Impulse.kr(4);
	// Higher weights mean higher probability
	var freq = TWChoose.kr(trigger,
		[200, 400, 800],       // Values
		[0.6, 0.3, 0.1]        // Weights (should sum to 1)
	);
	SinOsc.ar(freq, mul: 0.3)
}.play;
)


// IRand - random integer at initialization (one-time)
(
{
	var numHarmonics = IRand(3, 12);
	Blip.ar(200, numHarmonics, 0.3)
}.play;
)




/////////////////////// Noise Modulation ///////////////////////


// LFNoise controlling frequency
(
{
	var freq = LFNoise0.kr(8).range(200, 800);
	SinOsc.ar(freq, mul: 0.3)
}.play;
)


// LFNoise controlling amplitude
(
{
	var amp = LFNoise1.kr(4).range(0, 0.5);
	Saw.ar(200, amp)
}.play;
)


// LFNoise controlling filter
(
{
	var cutoff = LFNoise2.kr(0.5).range(200, 4000);
	LPF.ar(Saw.ar(100, 0.5), cutoff)
}.play;
)


// Combining multiple noise sources
(
{
	var freq = LFNoise0.kr(3).range(100, 300);
	var cutoff = LFNoise1.kr(0.5).range(500, 3000);
	var amp = LFNoise2.kr(2).range(0.1, 0.4);
	LPF.ar(Saw.ar(freq, amp), cutoff)
}.play;
)




/////////////////////// Dust and Crackle ///////////////////////


// Dust - random impulses at a given density
(
{
	Dust.ar([10, 10]) * 0.5
}.play;
)


// Dust triggering envelopes
(
{
	var trigger = Dust.kr(4);
	var env = EnvGen.kr(Env.perc(0.01, 0.2), trigger);
	SinOsc.ar(400, mul: env * 0.3)
}.play;
)


// Crackle - chaotic noise generator
(
{
	// Parameter ranges from 1.0 to 2.0
	// 1.0 = silence, 1.5 = crackle, 2.0 = noise
	Crackle.ar(MouseX.kr(1.0, 2.0), 0.5)
}.play;
)




/////////////////////// Pitch Quantization ///////////////////////


// Random notes quantized to a scale
(
{
	var trigger = Impulse.kr(4);
	var note = TRand.kr(48, 72, trigger).round(1);  // Chromatic
	SinOsc.ar(note.midicps, mul: 0.3)
}.play;
)


// Random notes quantized to major scale
(
{
	var trigger = Impulse.kr(4);
	var scale = [0, 2, 4, 5, 7, 9, 11];  // Major scale intervals
	var degree = TRand.kr(0, 6.99, trigger).floor;
	var octave = TRand.kr(0, 2.99, trigger).floor;
	var note = 48 + (octave * 12) + Select.kr(degree, scale);
	SinOsc.ar(note.midicps, mul: 0.3)
}.play;
)




// Useful help file:
// Tour of UGens
