 ////////////////////////////////////////////////////////////////
//
//                        Distortion
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




///////////////////////// Distortion ///////////////////////////

(
	SynthDef(\reduce, { |in=0, out=0, mix=0.5, bits=7|
		var signal, distortion;
		signal = In.ar(in, 2);
		distortion = signal.round(2**(bits * -1));
		distortion = distortion.clip(-0.2,0.3).distort.pow(0.5) * 0.5;
		Out.ar(out, (signal * (1 - mix)) + (distortion * mix));
	}).add;


	SynthDef(\square, { |in=0, out=0, mix=0.5, gain=50|
		var signal, distortion;
		signal = In.ar(in, 2);
		distortion = (signal.squared + (gain*signal))/(signal.squared + ((gain-1)*signal) + 1) * 0.01;
		Out.ar(out, (signal * (1 - mix)) + (distortion * mix));
	}).add;


	SynthDef(\crunch, { |in=0, out=0, mix=0.5, rate=5000, bitsize=5|
		var signal, distortion, downsamp;
		signal = In.ar(in, 2);
		downsamp = Latch.ar(signal, LFTri.ar(rate));
		distortion = downsamp.round(0.5 ** bitsize);
		Out.ar(0, LeakDC.ar((signal * (1 - mix)) + (distortion * mix)));
	}).add;
)


(

~gui.value(
	"Crunch", ~path ++ "/output", Color.fromHexString("#2A2D25"),

	// Source
	\play, [\buf, ~catbike, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\crunch, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.5)],
    [\rate, ControlSpec(10, 40000, \lin, 1, 10000)],
	[\bitsize, ControlSpec(1, 16, \lin, 0.1, 14)]]
);

)

(

~gui.value(
	"Square", ~path ++ "/output", Color.fromHexString("#7D1538"),

	// Source
	\play, [\buf, ~catbike, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\square, [\in, 4],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.5)],
	[\gain, ControlSpec(1, 100, \lin, 0.5, 10)]]
);

)



/////////////////////// Waveshaping ////////////////////////////

(

~shape = Buffer.alloc(s, 1024, 1);
~shape.sine1([1, 0.5]);
~shape.plot;

	SynthDef(\wshaper, { |in=0, out=0, mix=1.0, bufnum=0, amp=50|
		var signal, shaper;
		signal = In.ar(in, 2);
		shaper = HPF.ar(Shaper.ar(bufnum, signal), 40) * amp;
		ReplaceOut.ar(out, (signal * (1 - mix)) + (shaper * mix));
	}).add;
)

(

~gui.value(
	"Waveshaper", ~path ++ "/output", Color.fromHexString("#372549"),

	// Source
	\play, [\buf, ~catbike, \rate, 1, \amp, 1, \out, 4],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],

	// Process
	\wshaper, [\in, 4, \bufnum, ~shape.bufnum],
    [[\mix, ControlSpec(0.0, 1.0, \lin, 0.1, 0.5)],
	[\amp, ControlSpec(1, 100, \lin, 0.5, 10)]]
);

)