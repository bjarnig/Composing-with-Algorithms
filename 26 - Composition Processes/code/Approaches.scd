////////////////////////////////////////////////////////////////
//
//                        Approaches
//
////////////////////////////////////////////////////////////////

StageLimiter.activate;

(

s.waitForBoot({ "SynthDefs.scd".loadRelative; });

)

////////////////////////// Misc ///////////////////////////


// Pfindur can be used to play for a fixed amount of time

(
var pattern, duration=5, clock;
clock = TempoClock.new(90/60);
pattern = Pbind(\midinote, Pwhite(60,80));
Pfindur(duration, pattern).play(clock);
)


// Pmono plays one instance of a synth while changing args

(
SynthDef(\gray, {|freq=200, amp=0.2|
	var env, sig;
	env = EnvGen.ar(Env.new([0,1,0],[10,10]), doneAction:2);
	sig = BPF.ar(GrayNoise.ar(amp), freq);
	Out.ar(0, sig * env ! 2)
}).add(nil, {
	Pmono(\gray,
		\dur, Penv([0.01,0.5,0.1],[10,10]),
		\freq, Pwhite(100, 8000,inf)
	).play
})
)


// EventStreamPlayer holds a reference to a playing pattern

(
SynthDef(\perc, {|freq=200, amp=1.0|
	var enva, envb, sig;
	enva = EnvGen.ar(Env.perc, doneAction:2);
	envb = EnvGen.ar(Env.new([150,80,60],[0.2,1]), doneAction:2);
	sig = SinOsc.ar(envb) * enva ;
	Out.ar(0, sig * amp ! 2)
}).add(nil, {
	~pattern = Pbind(
		\instrument, \perc,
		\dur, 0.8
	).play
});
)

~pattern.stop
~pattern.play(TempoClock.new(140/60))


~sound = {Impulse.ar(10) * 0.5 ! 2 }.play
~sound.run(false)
~sound.run(true)


// SynthDefs have an additional argument for lag times

(
SynthDef(\dust, {|density=100, amp=0.75|
	var env, sig;
	env = EnvGen.ar(Env.new([0,1,0],[10,100]), doneAction:2);
	sig = Dust.ar(density.poll) * amp;
	Out.ar(0, sig * env ! 2)
}, [10,100]).add
)

a = Synth(\dust)
a.set(\density, 10)
a.set(\density, 1000)
a.set(\amp, 0.0)


////////////////////////// Demand rate ///////////////////////////

( // Demand need a trigger and a demand rate Ugen
{
	var seq, demand, pulse;
	seq = Dseq([1,2,3]  * 100, inf);
	pulse = Impulse.ar(10) * 0.5;
	demand = Demand.ar(pulse, 0, seq);
	Saw.ar(demand)
}.play
)


( // Works with multichannel expansion and nested patterns
{
	var seq, demand, pulse, times=10, speed=25;
	seq = Dbrown(0, Dwhite(0.1,1.0,inf), Array.rand(times, 0.01, 0.8));
	pulse = Impulse.ar(speed);
	demand = Demand.ar(pulse, 0, seq * 1000);
	Splay.ar(Pulse.ar(demand), level:1/times)
}.play
)


( // Duty allows to set the demand rate to a list of duration
{
	var duty = Duty.ar(Dwhite(0.2, 1.5,inf), 0, Dwhite(100,1000,inf));
	LPF.ar(WhiteNoise.ar, duty);
}.play
)


( // Demand for waveforms, sequences a varying frequency
{   var trig, movement;
	trig = Impulse.ar(SinOsc.kr(0.1, 0, 6000, 8000));
	movement = Dseq([Dbrown(-0.1,0.1,0.5,32), Dbrown(-0.8,0.8,0.5,16)], inf);
	Demand.ar(trig, 0, movement) ! 2 * 0.5;
}.play;
)



////////////////////////// Processes ///////////////////////////

//////// Many Clocks and nesting tasks inside routines

(
SynthDef(\synth, {
	|freq=400,amp=1.0,atk=0.01,sus=0.1,rel=0.5|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = Pulse.ar([freq,freq*0.5]) * amp;
	Out.ar(0, sig * env);
}).add;
)

(
var clocka, clockb, taska, taskb;

~routine = Routine({
	clocka = TempoClock.new(2);
	clockb = TempoClock.new(4);

	taska = Task({
		loop({
			Synth(\synth, [freq: 300, amp: 0.2]);
			1.5.wait;
			Synth(\synth, [freq: 400, amp: 0.2]);
			[0.75, 0.25].choose.wait;
		});
	}, clocka);

	taskb = Task({
		loop({
			Synth(\synth, [freq: 200, amp: 0.2]);
			0.5.wait;
		});
	}, clockb);

	taska.start;
	nil.yield;
	taskb.start;
	nil.yield;
	clocka.tempo = 4;
	nil.yield;
	clockb.tempo = 8;
	nil.yield;
	taska.stop;
	taskb.stop
});
)

~routine.next;


//////// Score

(
SynthDef("scos",{ |freq = 1000, dur=0.5|
	var chaos, line;
	chaos = HenonC.ar(freq);
	line =  Line.kr(0.5, 0, dur, doneAction: 2);
	Out.ar(0, chaos * line ! 2)
}).add;

// synthdef, nodeID, addAction, targetID, synth args

~scoreList = [
[0.0, [ \s_new, \scos, 4000, 0, 0,  \freq, 2000, \dur, 1 ]],
[0.5, [ \s_new, \scos, 4001, 0, 0,  \freq, 8000, \dur, 2 ]],
[1.0, [ \s_new, \scos, 4002, 0, 0,  \freq, 1000, \dur, 4 ]],
[3.0, [ \s_new, \scos, 4004, 0, 0,  \freq, 500, \dur, 8 ]],
[2.0, [\c_set, 0, 0]]
];

~score = Score(~scoreList);

)

~score.play;


//////// Modular approach, a sampler and a reverb for effects.

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
~rootPath ="/Volumes/DATA/Courses/Resources/SuperCollider/_snd/";
~path = ~rootPath ++ "clicks/*";
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


//////// Serialism

(
SynthDef(\pluck, {
	|amp=0.1, note=60, decay=4, coef=0.1, pan=0|
	var env, sig, pluck, delay;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction:2);
	sig = WhiteNoise.ar(amp);
	delay = note.midicps.reciprocal;
	sig = Pluck.ar(in:sig, delaytime:delay, decaytime:decay, coef:coef);
	Out.ar(0, Pan2.ar(sig * 0.5, pan));
}).add;
)

(
var series, octave;
series = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
octave = [48, 60, 72];

Pbind(
	\instrument, \pluck,
	\note, Prand([
		Pseq(series) + octave.choose, // series
		Pseq(series.reverse) + octave.choose, // retrograde
		Pseq(12 - series) + octave.choose, // inverse
		Pseq((12 - series).reverse) + octave.choose // inverse retrograde
	], inf),
	\dur, Pwhite(0.05, 0.15)
).play;
)
