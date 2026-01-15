////////////////////////////////////////////////////////////////
//
//                         MIDI
//
////////////////////////////////////////////////////////////////


External control with MIDI


///////////////////////// MIDIClient ///////////////////////////

MIDIClient.init; MIDIIn.connectAll;



////////////////////////// MIDIFunc ////////////////////////////

// Post all arguments
MIDIFunc.noteOn({|...args| args.postln});



// Remove a reference to a note number with free
(
a = MIDIFunc.noteOn({|velocity, note|
	Pdef(\seq, Pbind(\midinote, note)).play });
)
a.free



// Respond only to note 57
a =	MIDIFunc.noteOn({|velocity, note| note.postln}, 57);
a =	MIDIFunc.noteOn({|velocity, note| "asdf".postln}, 58);
a.free;



// Set range of notes
a =	MIDIFunc.noteOn({|velocity, note| note.postln},(48..54));
a =	MIDIFunc.noteOn({|velocity, note| "asdf".postln},(50..70));
a.free;


MIDIFunc.cc({|...args| args.postln})




(  // CC for the frequency of a filter

Routine {
var noise;

MIDIFunc.cc({|val|
    noise.set(\freq, val.linlin(0,127,100,10000).postln);
});

SynthDef(\noise1, {|freq=200|
	var sig = RLPF.ar(GrayNoise.ar(0.5), freq);
	Out.ar(0, sig ! 2);
}).add;

s.sync;

noise = Synth(\noise1)

}.play

)




( // Map using ControlSpec

Routine {
var noise;

SynthDef(\noise2, {|freq=200, rq=1|
	var sig = RHPF.ar(Dust.ar(200.5), freq, rq);
	Out.ar(0, sig ! 2);
}).add;

s.sync;

noise = Synth(\noise2);

MIDIFunc.cc({ |val, num|
	var spec = ControlSpec(20,8000,\exponential);

	num.postln;

	if(num == 5, {
		noise.set(\freq, spec.map(val/127.0).postln)
	});

	if (num == 6,{
		noise.set(\rq, val.linexp(0,127,0.1,4.0).postln);
	});
});

}.play

)



( // Trigger synth with midi note numbers

SynthDef(\perc, {
	|out=0,note=60,amp=0.5|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.1, 4), doneAction:2);
	sig = Blip.ar(note.midicps);
	Out.ar(out, sig * amp * env ! 2);
}).add;

MIDIFunc.noteOn({|val, num, chan, src|
	Synth(\perc, [\note, num, \amp, val.linlin(0,127,0.5,1.0)])
})

)




( // Play notes and store in array

var notes = Array.newClear(128);

SynthDef(\Saw, {|note=60, amp = 0.3, gate = 1|
	var signal = Saw.ar([note, note*0.9].midicps);
	Out.ar(0, signal * amp * Linen.kr(gate, releaseTime: 2, doneAction: 2));
}).add;

MIDIFunc.noteOn({|vel, num|
		num.postln;
	if (notes[num].isNil,{
	notes[num] = Synth(\Saw, [\note, num, \amp, vel.linlin(0,127,0.0,1.0)])
})});

MIDIFunc.noteOff({ |vel, num|
	num.postln;
	if (notes[num].notNil,{
	notes[num].set(\gate, 0); notes[num] = nil
})});

)




////////////////////// MIDI and Patterns ///////////////////////


( // With PatternProxy

var pattern, notes;

notes = PatternProxy(Pwhite(20, 80));
pattern = Pbind(\midinote, notes, \dur, 0.2).play;

MIDIFunc.cc({|val|
	val.postln;
	notes.source = Pwhite(val/2, val);
})

)



( // With Pfunc

var clock = TempoClock(1.5), midiVal = 10;

SynthDef(\fm, {
	|out=0,pan=0,note=60,amp=1.0,mod=10,amt=0.0,atk=0.1,sus=0.1,rel=0.1|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = PMOsc.ar(note.midicps, mod, amt);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

Pbind(
	\instrument, \fm,
	\amt, Pwhite(0.1, 10),
	\note, Pfunc { midiVal },
	\dur, 0.5,
	\legato, 1.1
).play(clock);

MIDIFunc.cc({|val|
	val.postln;
	midiVal = val;
})

)
