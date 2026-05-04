 ////////////////////////////////////////////////////////////////
//
//                          FFT
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




////////////////////// Phase Vocoder ///////////////////////////

(
	SynthDef(\freeze, { |in=4, out=0, mix=1.0, freq=0.4, freeze=0|
		var signal, chain;
		signal = In.ar(in, 2);
		chain = FFT(LocalBuf(2048), signal);
	    chain = PV_MagFreeze(chain, freeze);
		Out.ar(out, (signal * (1 - mix)) + (IFFT(chain).dup * mix));
	}).add;

	SynthDef(\brickwall, { |in=0, out=0, mix=1.0, freq=0.05, amp=4, frames = 2048|
		var signal, chain, bw;
		signal = In.ar(in, 2);
		chain = FFT(LocalBuf(2048), signal);
		chain = PV_BrickWall(chain, freq);
		Out.ar(out, (signal * (1 - mix)) + (IFFT(chain).dup * mix));
	}).add;

	SynthDef(\play, {|out=0,pan=0,rate=1,amp=1.0,buf=0|
		var signal = PlayBuf.ar(1, buf, rate, 1, 0, 1);
	    Out.ar(out, Pan2.ar(signal, pan, amp));
    }).add;
)



( // Freeze

~gui.value(
	"Freeze", ~path ++ "/output", Color.rand,

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\freeze, [\in, 4],
    [[\freeze, ControlSpec(0.0, 1.0, \lin, 0.5, 0)]]
);

)

( // Brickwall

~gui.value(
	"Brickwall", ~path ++ "/output", Color.rand,

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\brickwall, [\in, 4],
    [[\freq, ControlSpec(-1.0, 1.0, \lin, 0.01, 0)]]
);

)
