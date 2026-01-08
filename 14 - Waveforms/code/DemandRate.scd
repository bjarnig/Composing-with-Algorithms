////////////////////////////////////////////////////////////////
//
//                       Demand Rate
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


( // Basic Demand with brownian motion

{
	var trig = Impulse.ar(400);
	var movement = Dbrown(-1, 1, 0.8, inf);
	Demand.ar(trig, 0, movement) * 0.5 ! 2
}.play

)



( // Demand sequence with variable trigger frequency

{
	var trig = Impulse.ar(SinOsc.kr(0.1, 0, 4500, 8000));
	var movement = Dseq([
		Dbrown(-0.1, 0.1, 0.5, 32),
		Dbrown(-0.8, 0.8, 0.5, 16)
	], inf);
	Demand.ar(trig, 0, movement) * 0.5 ! 2
}.play

)



( // Sequencing ranges of random values

{
	var da = Dwhite(-1.0, 1.0, Dwhite(2, 128));
	var db = Dwhite(-0.2, 0.2, Dwhite(2, 128));
	var dc = Dwhite(-0.1, 0.1, Dwhite(2, 128));
	var dd = Dwhite(0.0, 0.6, Dwhite(2, 128));
	Demand.ar(Impulse.ar(5000), 0, Dseq([da, db, dc, dd], inf)) ! 2 * 0.3
}.play

)



( // Demand controlling oscillator frequency

{
	var brown = Dbrown(50, 5000, 100, inf);
	var trig = Impulse.kr(500);
	var freq = Demand.kr(trig, 0, brown);
	Pulse.ar(freq) * 0.1 ! 2
}.play

)



( // Multichannel expansion with nested patterns

{
	var times = 10, speed = 25;
	var seq = Dbrown(0, Dwhite(0.1, 1.0, inf), Array.rand(times, 0.01, 0.8));
	var pulse = Impulse.ar(speed);
	var demand = Demand.ar(pulse, 0, seq * 1000);
	Splay.ar(Impulse.ar(demand), level: 0.75)
}.play

)

///////////////////////// Dseq //////////////////////////


( // Basic Dseq - demand rate sequence

{
	var sequence = Dseq([-0.3, 0.5, 0.0, 0.4], inf);
	Demand.ar(Impulse.ar(10), 0, sequence) ! 2
}.plot(1.0)

)



( // Musical sequence with nested randomness

{
	var sequence = Dseq([60, Drand([48, 72], 1), 63, 62.8], inf);
	var freq = Demand.kr(Impulse.kr(8), 0, sequence).midicps;
	Saw.ar(freq) * 0.1 ! 2
}.play

)



( // Scale-based sequencing

{
	var notes = (Scale.minor.degrees + 48).midicps;
	var freq = Demand.kr(Impulse.kr(6), 0, Drand(notes, inf));
	SinOsc.ar(freq) * 0.3 ! 2
}.play

)


///////////////////////// Duty //////////////////////////


( // Basic Duty - variable duration between values

{
	var duty = Duty.ar(Dseq([0.025, 0.05], inf), 0, Dseq([-0.5, 0.5, 0, -1, 1], inf));
	duty ! 2
}.plot(0.6)

)



( // Duty controlling filter frequency

{
	var duty = Duty.ar(Dwhite(0.2, 1.5, inf), 0, Dwhite(100, 1000, inf));
	LPF.ar(WhiteNoise.ar, Lag.ar(duty, 5)) ! 2
}.play

)



( // Duty with SinOsc - basic sequencing

{
	SinOsc.ar(Duty.kr(0.125, 0, Dseq([400, 500, 600, 700], inf))) * 0.3 ! 2
}.play

)



( // Duty with Drand - randomized sequence

{
	SinOsc.ar(Duty.kr(0.1, 0, Drand([300, 400, 500, 600, 800], inf))) * 0.3 ! 2
}.play

)



( // Duty with Dshuf - shuffled sequence (no immediate repeats)

{
	SinOsc.ar(Duty.kr(0.1, 0, Dshuf([300, 500, 700, 900], inf))) * 0.3 ! 2
}.play

)


///////////////////////// Stepper //////////////////////////


( // Stepper counts pulses

{
	SinOsc.ar(Stepper.kr(Impulse.kr(10), 0, 4, 16, 1) * 100) * 0.3 ! 2
}.play

)



( // Stepper with Lag for portamento

{
	var step = Stepper.kr(Impulse.kr(6), 0, 5, 25, -4) * 90;
	SinOsc.ar(Lag.kr(step, 0.2)) * 0.3 ! 2
}.play

)



( // Select chooses from array

{
	var scale = [60, 61, 63, 64, 65, 67, 68, 69, 70].midicps;
	var cycle = scale.size / 2;
	SinOsc.ar(Select.kr(LFSaw.kr(0.4, 1, cycle, cycle), scale)) * 0.3 ! 2
}.play

)



( // Stepper with Select - arpeggiator

{
	var pitchArray = [60, 62, 64, 65, 67, 69, 71, 72].midicps;
	var freq = Select.kr(
		Stepper.kr(Impulse.kr(8), max: pitchArray.size - 1),
		pitchArray
	);
	SinOsc.ar(freq) * 0.4 ! 2
}.play

)



( // Select with Duty for oscillator switching

{
	Select.ar(
		Duty.kr(0.05, 0, Dseq([0, 1, 1, 1, 2, 0, 1], inf)),
		[SinOsc.ar(2000), Saw.ar(3000), WhiteNoise.ar(0.4)]
	) * 0.3 ! 2
}.play

)


///////////////////////// More //////////////////////////


( // Dgeom - geometric series

{
	var seq = Dgeom(100, 1.1, 20);  // start, ratio, length
	var freq = Demand.kr(Impulse.kr(4), 0, Dseq([seq], inf));
	SinOsc.ar(freq) * 0.3 ! 2
}.play

)


( // Dswitch1 - switch between patterns

{
	var patterns = [
		Dseq([60, 62, 64], inf),
		Dseq([72, 71, 69], inf),
		Dbrown(48, 84, 2, inf)
	];
	var switchSeq = Dseq([0, 0, 1, 1, 2], inf);
	var freq = Demand.kr(Impulse.kr(6), 0, Dswitch1(patterns, switchSeq)).midicps;
	SinOsc.ar(freq) * 0.3 ! 2
}.play

)



( // Dwrand - weighted random

{
	var notes = [60, 64, 67, 72];
	var weights = [0.5, 0.3, 0.15, 0.05];  // lower notes more likely
	var seq = Dwrand(notes, weights, inf);
	var freq = Demand.kr(Impulse.kr(5), 0, seq).midicps;
	SinOsc.ar(freq) * 0.3 ! 2
}.play

)



( // Diwhite - integer random

{
	var seq = Diwhite(0, 7, inf);  // integer between 0-7
	var scale = [60, 62, 64, 65, 67, 69, 71, 72].midicps;
	var index = Demand.kr(Impulse.kr(8), 0, seq);
	var freq = Select.kr(index, scale);
	Saw.ar(freq) * 0.2 ! 2
}.play

)
