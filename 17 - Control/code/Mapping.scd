////////////////////////////////////////////////////////////////
//
//                         Mapping
//
////////////////////////////////////////////////////////////////

Transfer functions, ranges and custom mappings.


///////////////////// Transfer functions ///////////////////////



( // Add test SynthDef

SynthDef(\test, {|freq=20|
	var sig, control;
	sig = Impulse.ar(freq);
	Out.ar(0, sig ! 2);
}).add;

)



( // linexp (linear input, exponential output)

var synth  = Synth(\test);

MIDIFunc.cc({|val|
	synth.set(\freq, val.linexp(0,127,10,1000).postln);
});

)



( // explin (exponential input, linear output)

var synth  = Synth(\test);

MIDIFunc.cc({|val|
	synth.set(\freq, val.explin(1,127,10,1000).postln);
});

)

// See also:
expexp
curvelin
lincurve
bilin
biexp
gaussCurve
scurve
ramp



///////////////////////// Strategies ///////////////////////////


( // Add SynthDef

SynthDef(\brown, {|freq=1000, rq=0.2|
	var sig, control;
	sig = BPF.ar(BrownNoise.ar(0.1), freq, rq);
	Out.ar(0, sig ! 2);
}).add;

)



( // One-to-One

var synth  = Synth(\brown);

MIDIFunc.cc({|val|
	var env, map;
	env = Env.new([0,0.1,0.7,0.8,1.0] * 1000, [0.2,0.4,0.3,0.1]);
	map = env[val/127.0];
	synth.set(\freq, map);
});

)


Env.new([0,0.1,0.7,0.8,1.0] * 1000, [0.2,0.4,0.3,0.1]).plot



( // One-to-Many

var synth  = Synth(\brown);

MIDIFunc.cc({|val|
	var enva, envb, mapa, mapb;
	enva = Env.new([0,0.1,0.7,0.8,1.0] * 1000, [0.2,0.4,0.3,0.1]);
	envb = Env.new([0,0.1,0.7,0.8,1.0] * 2, [0.2,0.4,0.3,0.1]);
	mapa = enva.at(val/127.0);
	mapb = envb.at(val/127.0);
	synth.set(\freq, mapa);
	synth.set(\rq, mapb);
});

)



( // Limit

var synth  = Synth(\brown);

MIDIFunc.cc({|val|
	var map = val/127.0;
	map = map.clip(0.2, 0.6).linlin(0.0,1.0,100,1000);
	synth.set(\freq, map);
});

)



( // Quantize

var synth  = Synth(\brown);

MIDIFunc.cc({|val|
	var map = val/127.0;
	map = map.round(0.2).linlin(0.0,1.0,100,1000);
	synth.set(\freq, map);
});

)



( // Split

var synth  = Synth(\brown);

MIDIFunc.cc({|val|
	var map = (val/127.0).linlin(0.0,1.0,100,1000);
	synth.set(\freq, map);

	if(map < 200, { synth.set(\rq, 0.1) });
	if(map < 500, { synth.set(\rq, 0.5) });
	if(map < 700, { synth.set(\rq, 2) }, { synth.set(\rq, 4) });

});

)



/////////////////////// Pre-Processing /////////////////////////

// Create an array
a = Array.rand(16, 2, 32)


// Check if the array contains the value 2
a.includes(2)


// Answer whether any item in a collection exists in the receiver
a.includesAny([2,4])


// Answer whether all item in a collection exists in the receiver
a.includesAll([8,2])


// Returns the item count
a.occurrencesOf(3)


// Like includesAny but with a function
List[1, 2, 3].any({|item, i| item.even });


// Like includesAny but with a function
List[1, 2, 3].every({|item, i| item.even });


// Like occurrencesOf but with a function
List[1, 2, 3, 4].count({|item, i| item.even });


// Performs a function on each element and returns a new collection
a.collect({|item, index|  index * item })


// Performs a selection on a collection and returns a new collection
a.select{|item, index|  item.odd }


// Reject items and returns a new collection
a.reject{|item, index|  item.odd }



////////////////////// Post-Processing /////////////////////////

(  // Lag to smooth a control value

Routine {
var synth;

MIDIFunc.cc({|val|
	synth.set(\freq, val.linlin(0,127,100,10000).postln);
});

SynthDef(\pulse, {|freq=20|
	var sig, control;
	control = Lag.kr(freq, 5.0);
	sig = Impulse.ar(control.poll);
	Out.ar(0, sig ! 2);
}).add;

s.sync;
synth = Synth(\pulse);

}.play
)


(  // Latch for sample and hold

Routine {
var synth;

MIDIFunc.cc({|val|
	synth.set(\freq, val.linlin(0,127,100,10000).postln);
});

SynthDef(\pulsb, {|freq=20|
	var sig, control;
	control = Latch.kr(freq, Impulse.kr(1));
	sig = Impulse.ar(control);
	Out.ar(0, sig ! 2);
}).add;

s.sync;
synth = Synth(\pulsb);

}.play

)


/////////////////// Collections & Arrays ///////////////////////

// An array
[1,2,3]


// Binary operation
[1, 2, 3] + [3, 4]


// Iterate collections
List[1, 2, 3, 4].do({ arg item, i; item.postln });


// Generate series
Array.series(12, 2, 1)
(4 .. 16)
3.series(8,16)


// Random numbers
Array.rand(10, 3, 20)
{ rrand(3, 20) } ! 10


// Geometric series
Array.geom(4,2,6)


// Fill arrays
Array.fill(16, {arg i; i + 64.rand})
~ar = Array.fill(4, {arg i; i + 1 }).reverse


// Array operations
~ar.scramble
~ar.mirror
~ar.pyramid(3)


// Weighted random
[1,2,3].wchoose([0.25,0.10,0.65])


// Normalize an array:
[1,0.5,0.3].normalizeSum



///////////////////////// Dictionary ///////////////////////////

// Add with key and value
d = Dictionary.new;
d.put("abc", 10);
d["abc"]

// Key points to value
(
d = Dictionary.new;
d.add(\monkey -> 0).postln;
d.add(\robot -> 1).postln;
d.add(\monkey -> 2).postln;
)



//////////////////////////// Set ///////////////////////////////

Set[1,2,3]

a = Set[60, 68, 72, 88, 90, 100];
b = Set[60, 72, 44, 24];

c = union(a, b);
d = difference(a, b);
e = sect(a, b);




///////////////////////// More Examples ////////////////////////

// Bipolar mapping from unipolar input
~map = {|val| val.linlin(0.0,1.0,-1.0,1.0) };
~map.(0.5)


( // Map to scale degrees
var synth, degrees = [0,2,4,5,7,9,11];
synth = {|freq=440| SinOsc.ar(freq) * 0.2 ! 2}.play;
MIDIFunc.cc({|val|
	var degree = degrees.wrapAt((val/127.0 * degrees.size).floor);
	synth.set(\freq, (60 + degree).midicps);
});
)


( // Slew rate limiter
var synth, lastVal = 0, maxChange = 0.1;
synth = {|freq=440| Saw.ar(freq) * 0.2 ! 2}.play;
MIDIFunc.cc({|val|
	var norm = val/127.0, slewed;
	slewed = norm.clip(lastVal - maxChange, lastVal + maxChange);
	synth.set(\freq, slewed.linexp(0.0,1.0,100,2000));
	lastVal = slewed;
});
)
