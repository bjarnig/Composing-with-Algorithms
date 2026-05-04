 ////////////////////////////////////////////////////////////////
//
//                         Dynamics
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



////////////////////// Dynamics ////////////////////////////////

(
	SynthDef(\compressor, { |in=0, out=0, mix=1.0, threshold= 0.01|
		var signal, compressor;
		signal = In.ar(in, 2);
		compressor = Compander.ar(signal, signal, threshold, 1, 0.1, 0.01, 0.01);
		Out.ar(out, (signal * (1 - mix)) + (compressor * mix));
	}).add;

	SynthDef(\limiter, { |in=0, out=0, mix=1.0, threshold= 0.01, dur=0.01|
		var signal, limiter;
		signal = In.ar(in, 2);
		limiter = Limiter.ar (signal, threshold, dur);
		Out.ar(out, (signal * (1 - mix)) + (limiter * mix));
	}).add;

	SynthDef(\sustainer, { |in=0, out=0, mix=1.0, thresh=0.01|
		var signal, sustainer;
		signal = In.ar(in, 2);
		sustainer = Compander.ar(signal, signal, thresh, 0.1, 1, 0.01, 0.01);
		Out.ar(out, (signal * (1 - mix)) + (sustainer * mix));
	}).add;
)

(

~gui.value(
	"Sustainer", ~path ++ "/output", Color.fromHexString("#0E1A13"),

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\sustainer, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.5)],
	[\thresh, ControlSpec(0.001, 0.2, \lin, 0.001, 0.01)]]
);

)

