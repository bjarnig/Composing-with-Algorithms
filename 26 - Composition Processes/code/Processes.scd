////////////////////////////////////////////////////////////////
//
//                         Processes
//
////////////////////////////////////////////////////////////////


////////////////////////// Globals ///////////////////////////

(

~rootPath = (PathName(thisProcess.nowExecutingPath)).pathOnly;

)

////////////////////////// Modules ///////////////////////////


// Create a sampler to read sounds and a reverb to play them through

(
SynthDef(\clickSampler, {
	|out=4, note=60, amp=0.7, buf=0, atk=0.0, rel=1.0, grez|
	var sig, rate, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	rate = BufRateScale.ir(buf) * (note / 60.0);
	sig = PlayBuf.ar(1, buf, rate, 1, 0) * amp;
	OffsetOut.ar(out, Pan2.ar(sig) * env);
}).add;

SynthDef(\clickDelay, {|in=4, out=0, mix=0.05, decay=1|
	var signal, effect, delay=0.08;
	signal = In.ar(in, 2);
	effect = Mix.ar(Array.fill(7,{ CombL.ar(signal, delay, rrand(delay/2, delay), decay) }));
	6.do({ effect = AllpassN.ar(effect, delay, rrand(delay/2, delay), decay) });
	Out.ar(out, (signal * (1 - mix)) + (effect * (1 * mix)););
}).add;
)

// Load sounds from a folder to an array of buffers

(

~path = ~rootPath ++ "sounds/clicks/*";
~files = SoundFile.collect(~path);
~buffers = ~files.collect { |sf| var b;
b = Buffer.read(Server.local, sf.path)}

)

// Make small sequences

(

~tempo = 0.1;
~pitch = 1.0;

~pata = Pbind(
	\instrument,\clickSampler,
	\buf, Pseq([~buffers[0].bufnum, ~buffers[1].bufnum], inf),
	\note, 60 * Pfunc({ ~pitch }),
	\dur, Pseq([Pseq([1,3], 8), Pseq([4,6], 4)], 1) *  Pfunc({ ~tempo }),
	\amp, 1.0,
	\out, 4);

~patb = Pbind(
	\instrument,\clickSampler,
	\buf, Pseq([~buffers[3].bufnum, ~buffers[4].bufnum], inf),
	\note, 60 * Pfunc({ ~pitch }),
	\dur, Pwrand([1,2,4], [7,2,1].normalizeSum, 16) * Pfunc({ ~tempo }),
	\amp, 1.0,
	\out, 4);

~patc = Pbind(
	\instrument,\clickSampler,
	\buf, Pwrand([~buffers[6].bufnum,~buffers[7].bufnum], [0.2, 0.8], inf),
	\note, 60 * Pfunc({ ~pitch }),
	\dur, Pwrand([1,2], [0.2, 0.8], inf) * Pfunc({ ~tempo }),
	\amp, Pwrand([0.2, 0.5, 1.0], [0.2, 0.2, 0.6], 32),
	\out, 4);

~patd = Pbind(
	\instrument,\clickSampler,
	\buf, ~buffers[5].bufnum,
	\note, 60 * Pfunc({ ~pitch }),
	\dur, 1 * Pfunc({ ~tempo }),
	\amp, Pseg( Pseq([0.001, 1.0], inf), Pseq([4, 4],inf), Pseq([\linear, \exp], 1)),
	\out, 4);
)


// Test and listen to them
Synth(\clickDelay, [\in, 4, \out, 0]);
~pata.play;
~patb.play;
~patc.play;
~patd.play;


// Combine them in different ways
(
~tempo = 0.1;
~pitch = 1.0;
Synth(\clickDelay, [\in, 4, \out, 0]);
Pseq([~pata,~patb,~patc,~patd],inf).play
)

(
~tempo = 0.2;
~pitch = 0.6;
Synth(\clickDelay, [\in, 4, \out, 0]);
Pseq([Ppar([~pata, ~patb]), Ppar([~patc,~patd])],inf).play
)

(
~tempo = 0.05;
~pitch = 8;
Synth(\clickDelay, [\in, 4, \out, 0]);
Pseq([Ppar([~patc, ~pata]), Ppar([~patd,~patb])],inf).play
)





//////////////////////////// Score ///////////////////////////////////

(

SynthDef(\scoreTone, { |out=0, freq=440, amp=0.2, atk=0.01, rel=0.8, pan=0|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = SinOsc.ar(freq * [1, 2.01], 0, [0.6, 0.4]).sum;
	Out.ar(out, Pan2.ar(sig * env * amp, pan));
}).add;

)

(

x = [
	[0.0, [\s_new, \scoreTone, 1000, 0, 0, \freq, 1413, \rel, 1.0]],
	[0.5, [\s_new, \scoreTone, 1001, 0, 0, \freq, 712,  \rel, 1.0]],
	[1.0, [\s_new, \scoreTone, 1002, 0, 0, \freq, 417,  \rel, 2.0]],
	[3.0, [\c_set, 0, 0]]
];

z = Score(x);

)

z.play;


(

var scale = Scale.minorPentatonic.degrees;
var root = 48, id = 2000, t = 0.0;
var lines = List.new;

[0.5, 0.3, 0.15].do({ |step|
	8.do({ |i|
		var note = root + scale.wrapAt(i) + (12 * (i div: scale.size));
		lines.add([ t, [\s_new, \scoreTone, id = id + 1, 0, 0,
			\freq, note.midicps,
			\amp, 0.2,
			\rel, step * 4,
			\pan, rrand(-0.6, 0.6) ]]);
		t = t + step;
	});
	t = t + 0.5;
});
lines.add([ t + 2, [\c_set, 0, 0] ]);
~scoreEnd = t + 2.5;

~bigScore = Score(lines.asArray);

)

~bigScore.play;


(

~bigScore.recordNRT(
	outputFilePath: "~/score-render.wav".standardizePath,
	sampleRate: 48000,
	headerFormat: "WAV",
	sampleFormat: "int24",
	options: ServerOptions.new.numOutputBusChannels_(2),
	duration: ~scoreEnd,
	action: { "render complete".postln }
);

)
