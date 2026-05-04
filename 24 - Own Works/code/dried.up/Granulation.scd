////////////////////////////////////////////////////////////////
//
//                         Granulation
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


/////////////////////////// Grains /////////////////////////////


// TGrains, layers with slightly different start positions and durations
( SynthDef(\grainLayers, {|out=0,pan=0,rate=1,amp=1.0,buf=0,stretch = 5|
		var trate = 100, signal;
		var trigger = Impulse.kr(trate);
	    signal = Mix.fill(5,{
			TGrains.ar(2,trigger, buf, rate,
			Line.kr(0.3.rand,BufDur.kr(buf) + 0.3.rand,
			BufDur.kr(buf) * stretch, doneAction: 2)
			+ TRand.kr(0,0.01,trigger),
			0.1,TRand.kr(-1,1,trigger),amp,1)});
	    Out.ar(out, Pan2.ar(signal, pan, amp));
     }).add
)

(

~gui.value(
	"Granular Layers", ~path ++ "/output", Color.fromHexString("#383B53"),

	// Source
	\grainLayers, [\buf, ~branches, \rate, 1, \amp, 1],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\stretch, ControlSpec(0.1, 10, \lin, 0.1, 5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]]
);

)




( // Limit the granulation to a position in the buffer with from and to

SynthDef(\dustGrains, {|out=0,rate=1,amp=1.0,buf=0,trate=50,from=0.0,to=1.0|
		var trigger, signal;
		trigger = Dust.kr(trate);
		signal = TGrains.ar(2,trigger, buf, rate, TRand.kr(from,to,trigger)
		* BufDur.kr(buf),0.1,TRand.kr(-1,1,trigger),amp,1);
	    Out.ar(out, signal * amp);
    }).add;
)

(

~gui.value(
	"Granular Dust", ~path ++ "/output", Color.fromHexString("#5F5AA2"),
	\dustGrains, [\buf, ~melodic, \rate, 1, \amp, 1],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\from, ControlSpec(0.0, 1.0, \lin, 0.01, 0.0)],
	[\to, ControlSpec(0.0, 1.0, \lin, 0.01, 1.0)],
	[\trate, ControlSpec(1, 100, \lin, 1, 50)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]]
);

)


( // Variation with Impulse and changing grainlength

SynthDef(\grainPosition, {|out=0,rate=1,amp=1.0,buf=0,trate=50,pos=0.5,dur=0.3|
		var trigger, signal;
		trigger = Impulse.kr(trate);
	signal = TGrains.ar(2,trigger, buf, rate, TRand.kr(pos/2, pos, trigger)
		* BufDur.kr(buf), SinOsc.ar(trigger/100).range(dur/2,dur*2), TRand.kr(-0.5, 0.5, trigger),amp,1);
	    Out.ar(out, signal * amp);
    }).add;
)


(

~gui.value(
	"Granular Position", ~path ++ "/output", Color.fromHexString("#AD7F50"),
	\grainPosition, [\buf, ~melodic, \rate, 1, \amp, 1],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pos, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\dur, ControlSpec(0.05, 2.0, \lin, 0.01, 0.1)],
	[\trate, ControlSpec(0.1, 20, \lin, 0.1, 10)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]]
);

)