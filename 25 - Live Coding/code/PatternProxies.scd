////////////////////////////////////////////////////////////////
//
//                    JITLib - Pattern Proxies
//
////////////////////////////////////////////////////////////////


///////////////////  TaskProxy and Tdef  //////////////////////

( // Tdef keeps a ref to a task that can be replaced while playing.

// Start the task
Tdef(\x, { loop { 0.5.wait; "sono".postln } }).play;

// Update the task
Tdef(\x, { loop { 0.125.wait; "logy".postln } });

// Stop the task
Tdef(\x).stop;

// Start again
Tdef(\x).play;

// Clear it
Tdef(\x).clear;

)

( // Add a SynthDef for the processes below

SynthDef(\perc, {|freq=440, amp=0.1|
	var env = EnvGen.ar(Env.perc(0.01, 0.2), 1, doneAction:2) * amp;
	OffsetOut.ar(0, SinOsc.ar(freq, 0, env) ! 2);
}).add;

)

( //Play the synth with a task

Tdef(\x, {
    loop({
		Synth(\perc);
        0.1.wait;
    })
}).play(quant:2)

)

// Update the tempo clock
TempoClock.default.tempo = 0.5;

( //Update the task

Tdef(\x, {
    loop({
		Synth(\perc, [\freq, rrand(100, 1000)]);
        0.1.wait;
    })
}).play()

)

( // Using .embed and .fork one can control subtasks

Tdef(\a, { 10.do { Synth(\perc, [\freq, rrand(100, 200)]);  0.05.wait } });
Tdef(\b, { 10.do { Synth(\perc, [\freq, rrand(1000, 2000)]);  0.05.wait } });
Tdef(\c, { "C will wait".postln; 2.wait; });

Tdef(\d, {
	loop {
		Tdef(\a).embed; // In sequence
		1.wait;
		Tdef(\b).embed;
		2.wait;
		Tdef(\a).fork; // In parallel
		Tdef(\b).fork;
		Tdef(\c).embed;
	}
}).play
);


( // With Task

a = TaskProxy.new;
b = TaskProxy.new;
a.source = { "sono".postln; 1.wait; "logy".postln };
b.source = { "live".postln; 1.wait; "coding".postln };

Task {

    a.embed;
    b.fork;
    "DONE!".postln;

}.play;

)



/////////////////////////  Patterns  //////////////////////////

( // Pdef has a reference to a stream that can be replaced while playing

Pdef(\x, Pbind(
	\instrument, \perc,
	\freq, Pbrown(500, 600, 0.1, inf),
	\dur, 0.1
)).play;

)

( // While it plays the definition is changed

Pdef(\x, Pbind(
	\instrument, \perc,
	\freq, Pwhite(100, 900, inf),
	\dur, 0.05
))

)

( // Pdefn, non event stream reference definition

Pdefn(\x, Pbrown(100, 500, 10, inf));
Pbind(\instrument, \perc, \freq, Pdefn(\x), \dur, 0.1).play;
Pdefn(\x, Pseq([1,2,4] * 100, inf));

)


( // Pbindef incremental event pattern reference definition

Pbindef(\pat, \instrument, \perc, \freq, Pwhite(100,500), \dur, 0.1).play;
Pbindef(\pat, \freq, Prand([1, 1.2, 2], inf) * 1000);

)


( // Pbindef with quant

Pbindef(\pat, \instrument, \perc).play;

Pbindef(\pat, \dur, 0.05);

Pbindef(\pat).quant = 0.0;

Pbindef(\pat, \dur, 0.5);

)


( // Fdef, Placeholder for functions to calculate with.

SynthDef(\perc, {|freq=440, amp=0.1|
	var env = EnvGen.ar(Env.perc(0.01, 0.2), 1, doneAction:2) * amp;
	OffsetOut.ar(0, SinOsc.ar(freq, 0, env) ! 2);
}).add;

Fdef(\dur, 0.2);

Tdef(\x, {
    loop({
		Synth(\perc);
       Fdef(\dur).value.wait;
    })
}).play(quant:2);

)

Fdef(\dur, { rrand(0.4, 0.12) });
Fdef(\dur, { rrand(0.01, 0.12) });


( // Using Pdefn. A pattern may be used in different places. A change in the pattern definition affects all streams.

Pdefn(\x, Pbrown(0, 6, 0.1, inf));
Pbind(\note, Pdefn(\x), \dur, 0.3).play;
Pbind(\note, Pdefn(\x), \dur, 0.1, \ctranspose, 15).play;

)

Pdefn(\x, Pseq([0, 3, 5, 7, 9, 11], inf));
Pdefn(\x, Pseq([0, 3, 3, 7], inf) + Pseq([0, [0, 3], [0, 5, 7]], inf));


( // History class, to record a live coding performance

History.start;

1 + 2
2 - 1

History.end;

History.saveStory("/Volumes/DATA/bjarni/Desktop/TestHist.scd");

h = History.new.loadStory("/Volumes/DATA/bjarni/Desktop/TestHist.scd");
h.lines.printcsAll; "";

History.play;

)


( // Graphical Controllers

ProxyMixer, TdefAllGui, PdefAllGui, NdefMixer,
TdefGui, PdefGui, MonitorGui, NdefGui, NdefParamGui

)

See also:

Pdef, Pdefn, Tdef, Pbindef, Psym, Pnsym, Fdef
History, Pdef, Pdefn, Tdef, Pbindef, Psym, Pnsym, Fdef
ProxyMixer, TdefAllGui, PdefAllGui, NdefMixer,
TdefGui, PdefGui, MonitorGui, NdefGui, NdefParamGui
