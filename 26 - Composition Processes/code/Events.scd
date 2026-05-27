////////////////////////////////////////////////////////////////
//
//                       Event Form
//
////////////////////////////////////////////////////////////////


//////////////////////////  Setup  ////////////////////////////

(

s.waitForBoot({

	"SynthDefs.scd".loadRelative;

	SynthDef(\reverb, { |in=0, out=0, mix=0.3|
		var dry = In.ar(in, 2), wet = dry;
		6.do { wet = AllpassN.ar(wet, 0.1, { rrand(0.02, 0.09) }!2, 4) };
		Out.ar(out, (dry * (1 - mix)) + (LPF.ar(wet, 5500) * mix));
	}).add;
	s.newBusAllocators;
	~fxBus = Bus.audio(s, 2);
	~clock = TempoClock(96/60).permanent_(true);
	s.sync;

	~makeNodes = {
		~srcGroup = Group();
		~fxGroup  = Group.after(~srcGroup);
		Synth(\reverb, [in: ~fxBus, out: 0, mix: 0.3], ~fxGroup);
	};
	ServerTree.add(~makeNodes);
	ServerTree.run;

	// Rhythmic layer (Pbindef so events can mutate single keys).
	~clunks = Pbindef(\clunks,
		\instrument, \fold,
		\dur, Pexprand(0.08, 0.5),
		\freq, Pexprand(150, 900),
		\foldfreq, Pkey(\freq) * Pwhite(0.5, 1.5),
		\atk, 0.005, \rel, 0.1, \legato, 0.4,
		\amp, Pexprand(0.1, 0.3),
		\pan, Pwhite(-0.7, 0.7),
		\out, ~fxBus,
		\group, Pfunc({ ~srcGroup }),
	);

	"*** setup complete ***".postln;
});

)


/////////////////////////  The form  //////////////////////////


(
~events = Pseq([

	{
		~bed = 3.collect({ |n|
			Synth(\drone, [freq: (33 + n).midicps, amp: 0.25, drift: 0.08,
				atk: 10, rel: 10, pan: n.linlin(0, 2, -0.3, 0.3),
				out: ~fxBus], ~srcGroup);
		});
		"0: drone".postln;
	},

	{ ~clunks.play(~clock); "1: clunks".postln },

	{
		~bed.do({ |syn, n| syn.set(\freq, (40 + n).midicps) });
		"2: bed up".postln;
	},

	{
		Pbindef(\clunks, \dur, Pexprand(0.2, 1.2), \freq, Pexprand(80, 400));
		"3: clunks sparse".postln;
	},

	{
		~bed.do({ |syn| syn.set(\gate, 0, \rel, 8) });
		~bed = 4.collect({ |n|
			Synth(\add, [freq: (52 + (n * 5)).midicps, amp: 0.12,
				numharm: 8, brightness: 0.6, atk: 8, rel: 8, pan: n.linlin(0, 3, -0.5, 0.5),
				out: ~fxBus], ~srcGroup);
		});
		"4: bed crossfade".postln;
	},

	{
		Pbindef(\clunks, \amp, Pexprand(0.1, 0.3) * Env([1, 0], [12], [-2]).asPseg);
		"5: clunks fade".postln;
	},

	{
		~bed.do({ |syn| syn.set(\gate, 0, \rel, 12) });
		"6: end".postln;
	},

], 1).asStream;


~next = { var f = ~events.next; if(f.notNil) { f.value } };

)

~next.value;


(

~auto = Routine({
	~events.reset;
	[0, 8, 6, 10, 14, 12, 10].do({ |wait| ~next.value; wait.wait });
}).play(~clock);

)

