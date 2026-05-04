 ////////////////////////////////////////////////////////////////
//
//                        Resonators
//
////////////////////////////////////////////////////////////////




( // Load Samples and GUI (if needed)

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



//////////////////////// Resonators ////////////////////////////

(
	SynthDef(\klanky, { |in=0, out=0, mix=1.0, amp=0.5|
		var signal, klank;
		signal = In.ar(in, 2);
		klank = Klank.ar(`[Array.series(16,101,120), Array.rand(8, 0.1, 0.4).normalizeSum], signal) * amp;
		ReplaceOut.ar(out, (signal * (1 - mix)) + (klank * mix));
	}).add;


	SynthDef(\dynklanky, { |in=0, out=0, mix=0.7, amp=0.5|
		var signal, resonate, freqs;
		freqs = Control.names([\freqs]).kr([800, 1071, 1153, 1723]);
		signal = In.ar(in, 2);
		resonate = DynKlank.ar(`[freqs, [0.1, 0.2, 0.1, 0.2]], signal) * amp;
		ReplaceOut.ar(out, (signal * (1 - mix)) + (resonate * mix));
	}).add;


	SynthDef(\formlet, { |in=0, out=0, mix=1.0, freq=1000, attack=0.01, decay=0.1|
		var signal, formlet;
		signal = In.ar(in, 2);
		formlet = Formlet.ar(signal, freq, attack, decay);
		ReplaceOut.ar(out, (signal * (1 - mix)) + (formlet * mix));
	}).add;
)


(

~gui.value(
	"Klanky", ~path ++ "/output", Color.fromHexString("#433A3F"),

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\klanky, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.5)]]
);

)


(

~gui.value(
	"Formlet", ~path ++ "/output", Color.fromHexString("#FF7700"),

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\formlet, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.5)],
	[\freq, ControlSpec(100, 2000, \lin, 1, 500)],
	[\attack, ControlSpec(0.001, 1.0, \lin, 0.001, 0.01)],
	[\decay, ControlSpec(0.001, 3.0, \lin, 0.001, 0.1)]]
);

)