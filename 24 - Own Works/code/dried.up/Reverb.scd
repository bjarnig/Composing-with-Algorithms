 ////////////////////////////////////////////////////////////////
//
//                           Reverb
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


/////////////////////////// Reverb /////////////////////////////


(
	SynthDef(\mverb, { |in=0, out=0, mix=0.5, delay=0.1, decay=4|
		var signal, allpass, reverb;
		signal = In.ar(in, 2);
		allpass = signal;
		reverb = Mix.fill(10,{ allpass = AllpassN.ar(allpass, delay, delay.rand, decay)}) * 1.5;
		Out.ar(out, (signal * (1 - mix)) + (reverb * mix));
	}).add;


	SynthDef(\bigverb, {|in=0, out=0, predelay=0.1, decay=2, mix=0.15|
		var signal, predelayed, reflections, reverb;
		signal = In.ar(in, 2);
		predelayed = DelayN.ar(signal, 0.1, predelay);
	    reverb = Mix.ar(Array.fill(7,
		{ CombL.ar(predelayed, 0.05, rrand(0.03, 0.05), decay * 10) }));
		16.do({ reverb = AllpassN.ar(reverb, 0.050, rrand(0.03, 0.05), decay) * 0.8});
	    Out.ar(out, (signal * (1 - mix)) + (reverb * mix));
	}).add;


	SynthDef(\gverb, {|in=0, out=0, roomsize=10, revtime=3, damping=0.5, inputbw=0.5, spread = 15, drylevel=0.5, earlylevel=0.7, taillevel=0.5, mix=0.5|
		var signal, reverb;
		signal = In.ar(in, 2);
		reverb = GVerb.ar(signal, roomsize, revtime, damping, inputbw, spread, drylevel, earlylevel, taillevel, roomsize);
		Out.ar(out, (signal * (1 - mix)) + (reverb * mix));
	}).add;
)




( ~gui.value(

	"Mverb", ~path ++ "/output", Color.fromHexString("#04724D"),

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Reverb
	\mverb, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.2)],
    [\delay, ControlSpec(0.1, 1.0, \lin, 0.01, 0.1)],
	[\decay, ControlSpec(0.1, 6.0, \lin, 0.01, 1.0)]]);
)


( ~gui.value(

	"Bigverb", ~path ++ "/output", Color.fromHexString("#586F7C"),

	// Source
	\play, [\buf, ~dust, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Reverb
	\bigverb, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.2)],
    [\predelay, ControlSpec(0.01, 1.0, \lin, 0.01, 0.1)],
	[\decay, ControlSpec(0.1, 6.0, \lin, 0.01, 1.0)]]);
)


( ~gui.value(

	"Gverb", ~path ++ "/output", Color.fromHexString("#000000"),

	// Source
	\play, [\buf, ~branches, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Reverb
	\gverb, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.2)],
    [\roomsize, ControlSpec(1, 50, \lin, 1, 10)],
    [\damping, ControlSpec(0.01, 1.0, \lin, 0.01, 0.5)],
	[\revtime, ControlSpec(1, 20, \lin, 1, 2)]]);
)
