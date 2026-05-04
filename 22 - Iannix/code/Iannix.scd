////////////////////////////////////////////////////////////////
//
//                         Iannix
//
////////////////////////////////////////////////////////////////


This document covers sequencing via OSC with Iannix.



/////////////////////////// Synths /////////////////////////////

(

SynthDef(\saw, {
	|out=0,pan=0,freq=100,amp=1.0,res=0.5,atk=0.1,sus=0.1,rel=2.5,lop=8000|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = BLowPass4.ar(Saw.ar(freq), lop);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;


SynthDef(\noise, {
	|out=0,pan=0,bpf=500,amp=1.0,res=0.5,atk=0.1,sus=100.1,rel=0.1|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = BPF.ar(WhiteNoise.ar, bpf, res);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

)

/* The following OSC examples assume that NetAddr.langPort = 57120
   One needs to set Iannix to use the same (it should be by default).
*/




////////////////////////// Example 1 ///////////////////////////


(

var discrete, continous, debug, noise;

noise = Synth(\noise, [\atk, 10, \sus, 50]);

discrete = OSCFunc({|msg|

	// The id of the first trigger, x mapped coordinate used for pitch
	if(msg[1] == 3) { Synth(\saw, [\freq, msg[3].linlin(0,1,50,100), \rel, 5]) }

}, '/trigger');

continous = OSCFunc({|msg|

	// The id of the circle cursor, y mapped coordinate used for filter frequency
	if(msg[1] == 5) { noise.set(\bpf, 1000 * msg[4]) }

}, '/cursor');

debug = OSCFunc({ arg msg; msg.postln }, '/trigger');

)



////////////////////////// Example 2 ///////////////////////////

(

var noise, saw;

OSCFunc({|msg| msg.postln;
    if(msg[1] == 8) { noise = Synth(\noise, [\atk, 10, \sus, 50]) }
}, '/trigger');

OSCFunc({|msg|
    if(msg[1] == 7) { saw = Synth(\saw, [\atk, 10, \sus, 50, \saw, 75]) }
}, '/trigger');

OSCFunc({|msg|
	if(msg[1] == 2) { noise.set(\bpf, 4000 * msg[4]) }
}, '/cursor');

OSCFunc({|msg|
	if(msg[1] == 4) { saw.set(\lop, 2000 * msg[4]) }
}, '/cursor');

)


////////////////////////// Example 3 ///////////////////////////

(

var saw;

saw = Synth(\saw, [\atk, 10, \sus, 50]);

OSCFunc({|msg|
	if(msg[1] == 2) {
		saw.set(\freq, msg[4].linlin(0.0,1.0, 100, 1000));
		saw.set(\lop, msg[3].linlin(0.0,1.0, 50, 1000))
	}
}, '/cursor');

// Send OSC to Iannix, start it simply
f = NetAddr.new("127.0.0.1", 1234);
f.sendMsg("/iannix/play", 1)

)


////////////////////////// Example 4 ///////////////////////////

(

OSCFunc({|msg|

	if(msg[1] > 2000) { Synth(\noise,
		[\amp, 0.1,
		\atk, msg[3].linlin(0,1,0.1,1.0),
		\bpf, msg[4].linlin(0,1,100,4000),
		\sus, rrand(0.5, 1.5)]); }
}, '/trigger');

)