////////////////////////////////////////////////////////////////
//
//                         Samples
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




/////////////////////////// Samples /////////////////////////////


( // Simple sampler with GUI

~gui.value(
	"My Sampler",                   // The title text
	~path ++ "/output",             // The path for recording
	Color.fromHexString("#1A1B25"), // The GUI color
	\play,                          // The SynthDef name
	[\buf, ~catbike],               // The initial arguments

	// The arguments and control specs. (min, max, curve, step, default)
	[[\rate, ControlSpec(0.0, 4.0, \lin, 0.1, 1)],
	[\freq, ControlSpec(50, 10000, \lin, 1, 1000)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]]
);

)




( // Calculating a trigger frequency ((serverSampleRate / numberOfFrames) * rateScale)

	SynthDef(\trigger, {|out=0,pan=0,rate=1,amp=1.0,buf=0,offset=0.015, trig=1|
		var signal = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate,
		Impulse.kr(s.sampleRate / BufFrames.kr(buf)
		* BufRateScale.kr(buf) * trig),
		startPos: BufFrames.kr(buf) * offset);
	    Out.ar(out, Pan2.ar(signal, pan, amp));
    }).add
)




( // Envelope GUI for triggering

~envGui.value(
	"Trigger",                           // The title text
	~path ++ "/output",                  // The path for recording
	Color.fromHexString("#392061"),      // The GUI color
	\trigger,                            // The SynthDef name
	[\buf, ~branches],                   // The initial arguments

	// The arguments and control specs. (min, max, curve, step, default)
	[[\rate, ControlSpec(0.0, 2.0, \lin, 0.01, 1)],
	[\offset, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\trig, ControlSpec(1, 48, \lin, 1, 1)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]]
);
)




( // BufRd to play buffers, playback phase modulated by cubic noise (try another waveform?)

SynthDef(\bufReader, {|out=0,buf=0,modFreq=10,amp=0.5|
		var sig, phase;
		phase = LFDNoise3.ar(modFreq).range(0, BufFrames.ir(buf));
		sig = BufRd.ar(1, buf, phase, 1, 4);
	    Out.ar(0, (sig * amp) ! 2);
}).add

)

( // BufRd with GUI

~gui.value(
	"BufReader",                    // The title text
	~path ++ "/output",             // The path for recording
	Color.fromHexString("#283845"), // The GUI color
	\bufReader,                     // The SynthDef name
	[\buf, ~catbike],               // The initial arguments

	// The arguments and control specs. (min, max, curve, step, default)
	[[\modFreq, ControlSpec(0.0, 20.0, \lin, 0.01, 10)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]]
);

)




( // BufRd, layers

SynthDef(\bufReaderLayers, {|out=0,buf=0,end=0.5,rate=10,freqFrom=0.01,freqTo=0.75,amp=0.5|
		var sig, trig = Dust.kr(rate), layers = 25;

	    sig = Mix.fill(layers, {
			Pan2.ar(
			BufRd.ar(1, buf,
			SinOsc.ar(TRand.kr(freqFrom, freqTo, trig), 0, 0.5, 0.5)
				* (BufFrames.kr(buf) * end), 0, 4))
		});

	    Out.ar(0, (sig * amp) ! 2);
}).add

)

( // BufRdLayers with GUI

~gui.value(
	"BufReaderLayers",                 // The title text
	~path ++ "/output",                // The path for recording
	Color.fromHexString("#272932"),    // The GUI color
	\bufReaderLayers,                  // The SynthDef name
	[\buf, ~branches],                 // The initial arguments

	// The arguments and control specs.
	[[\end, ControlSpec(0.01, 1.0, \lin, 0.01, 1.0)],
	[\rate, ControlSpec(0.001, 75, \lin, 0.1, 10)],
	[\freqFrom, ControlSpec(0.01, 1.0, \lin, 0.01, 0.1)],
	[\freqTo, ControlSpec(0.01, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]]
);

)