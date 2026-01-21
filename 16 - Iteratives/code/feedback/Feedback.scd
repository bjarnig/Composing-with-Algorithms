////////////////////////////////////////////////////////////////
//
//                        Feedback
//
////////////////////////////////////////////////////////////////

s.boot;


// Feedback A: 4-channel with OnePole filtering

(
SynthDef(\feedbackA, {|feedback=1.0001, delay=0.0945|
	var sig, input, first, second;

	// Signal to process
	sig = Gbman2DN.ar(100) * 0.5;

	// Local in, 4 channels
	input = sig + LocalIn.ar(4);
	first = input.clump(2)[0];
	second = input.clump(2)[1];

	// OnePole filter, the feedback coefficient is effective
	first = OnePole.ar(first, first.linlin(-1.0, 1.0, 0.0, 1.0));
	second = OnePole.ar(second, second.linlin(-1.0, 1.0, 1.0, 0.0));

	// Delay it
	first = DelayC.ar(first, 1, LFNoise2.ar(0.13).range(delay, delay * 1.1));
	second = DelayC.ar(second, 1, LFNoise2.ar(0.17).range(delay * 1.2, delay * 1.3));

	// Local out
	LocalOut.ar((first ++ second) * feedback * LFNoise1.ar(0.1).range(0.8,0.995));

	// Sound out
	Out.ar(0, Limiter.ar(Splay.ar(first ++ second), 0.7))
}).add;

)

x = Synth(\feedbackA);
x.set(\feedback, 1.01);
x.set(\delay, 0.05);
x.free;


// Feedback B: 8-channel with folding

(

SynthDef(\feedbackB, {|feedback=1.0001, delay=0.01|
	var sig, input, snd;

	// Input
	sig = Saw.ar(10);
	input = sig + LocalIn.ar(8);

	// Process and Delay
	snd = input.fold2(SinOsc.ar({1000.rand} ! 8));
	snd = DelayC.ar(snd, 1, LFNoise2.ar({20.rand} ! 8).range(delay, delay * 1.1));

	// Outputs
	LocalOut.ar(snd * feedback * 0.995);
	Out.ar(0, Limiter.ar(Splay.ar(snd) * 0.1))
}).add;

)

x = Synth(\feedbackB);
x.set(\feedback, 1.01);
x.set(\delay, 0.05);
x.free;


// Feedback C: With FreqShift processing

(

SynthDef(\feedbackC, {|feedback=0.98, delay=0.08|
	var sig, input, first, second;

	// Source signal
	sig = DemandEnvGen.ar(
		Dseq([1, [-1, 0.5]], inf),
		Dseq(Array.rand(5, 1, 25), inf) * SampleDur.ir * 0.5
	).atan(SinOsc.ar(LFNoise0.ar(10).range(5, 7))) * 0.5;

	// Local in, 4 channels
	input = sig + LocalIn.ar(4);

	// Process channels 1-2
	first = input.clump(2)[0];
	first = FreqShift.ar(first, LFNoise1.ar(0.7).range(10, 30));

	// Process channels 3-4
	second = input.clump(2)[1];
	second = MostChange.ar(first, FreqShift.ar(first, LFNoise1.ar(20).range(10, 40)));

	// Delay
	first = DelayC.ar(first, 1, LFNoise1.ar(0.1).range(0.04, 0.09));
	second = DelayC.ar(second, 1, LFNoise1.ar(0.1).range(0.08, 0.11));

	// Local out
	LocalOut.ar((first ++ second) * feedback);

	Out.ar(0, CombC.ar(Splay.ar(first ++ second) * 0.2, 0.1, 0.1, 0.2))
}).add;

)

x = Synth(\feedbackC);
x.set(\feedback, 0.95);
x.set(\delay, 0.95);
x.free;
