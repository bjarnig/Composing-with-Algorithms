 ////////////////////////////////////////////////////////////////
//
//                      Delays
//
////////////////////////////////////////////////////////////////




( // Load Samples, Player and GUI (if needed)

~path = thisProcess.nowExecutingPath.dirname;
~inputPath = ~path ++ "/input/";
~guiPath = ~path ++ "/GUI/";

~branches = Buffer.read(s, ~inputPath ++ "branches.wav");
~catbike = Buffer.read(s, ~inputPath ++ "catbike.wav");
~synthesis = Buffer.read(s, ~inputPath ++ "synthesis.wav");

this.compileFile(~guiPath ++ "SimpleGUI.scd").value;
this.compileFile(~guiPath ++ "SimpleEnvGUI.scd").value;

SynthDef(\play, {|out=0,pan=0,rate=1,amp=1.0,buf=0|
	var signal = PlayBuf.ar(1, buf, rate, 1, 0, 1);
	Out.ar(out, Pan2.ar(signal, pan, amp));
}).add;

)



/////////////////////////// Delays /////////////////////////////

(

	// Feedback echo using local in for feedback.
	SynthDef(\echo,{|in=0, out=0, length = 0.5, fb = 0.8, sep = 0.012|
		var source, feedback, echo;
		source = In.ar(in, 2);
		feedback = LocalIn.ar(2);
		echo = LeakDC.ar(feedback*fb + source);
		LocalOut.ar(DelayC.ar(echo, 1, LFNoise2.ar(12).range([length,length+sep],[length+sep,length])));
		ReplaceOut.ar(out, echo);
	}).add;


	// Comb delay.
    SynthDef(\comb, { |in=0, out=0, mix=0.5, delay=0.1, decay=2|
		var source, signal;
		source = In.ar(in, 2);
		signal = CombL.ar(source, 0.5, delay, decay);
		ReplaceOut.ar(out, (source * (1 - mix)) + (signal * mix));
	}).add;
)


( // Comb and Playback

~gui.value(
	"Comb", ~path ++ "/output", Color.fromHexString("#442F38"),

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\comb, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.5)],
    [\delay, ControlSpec(0.01, 0.5, \lin, 0.01, 0.1)],
	[\decay, ControlSpec(0.01, 5, \lin, 0.01, 0.1)]]
);

)


( // Echo and Playback

~gui.value(
	"Echo", ~path ++ "/output", Color.fromHexString("#3D0814"),

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\echo, [\in, 4],
    [[\fb, ControlSpec(0.0, 1.0, \lin, 0.1, 0.2)],
    [\length, ControlSpec(0.01, 1.0, \lin, 0.01, 0.5)],
	[\sep, ControlSpec(0.01, 0.9, \lin, 0.01, 0.02)]]
);

)