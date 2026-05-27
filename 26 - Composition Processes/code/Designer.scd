////////////////////////////////////////////////////////////////
//
//                         Designer
//
////////////////////////////////////////////////////////////////

(

~specs = ~specs ? Dictionary.new;   // init once; reuse if already present

~interface = {|testcase|

	SynthDesignerUI(testcase, [], ~specs[testcase],
 	[
		(name: "quite regular", args:[\dur, Pwhite(0.5, 1.0)]),
		(name: "up and down", args:[\dur, Pseq([Pseries(0.05, 0.05, 10), Pseries(1, -0.05, 10)], inf)]),
 		(name: "brownian", args:[\dur, Pbrown(0.05, 0.2, 0.001)]),
 	])
};

SynthDef(\gbman, {
	|out=0, amp=0.3, freq=100, pan=0.0, atk=1.1, dec=0.5, sus=1.0, rel=0.5, gate=1, mod=0.5,
	lop=18000, loprq=1|
	var env, sig;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction:2);
	sig = Saw.ar(Lag.ar(GbmanL.ar(freq/4).range(freq/2,freq)));
	sig = BBandStop.ar(sig, freq * 2, 2);
	sig = RLPF.ar(sig, lop, loprq);
	sig = Pan2.ar(sig * env, pan) * amp;
	OffsetOut.ar(out, sig);
}).add();

~specs[\gbman] = [
[\atk, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\sus, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\rel, ControlSpec(0.001, 2.0, \lin, 0.001, 0.05)],
[\freq, ControlSpec(20, 4000, \lin, 0.1, 100)],
[\mod, ControlSpec(0.0, 1.0, \lin, 0.01, 100)],
[\lop, ControlSpec(40, 18000, \lin, 1, 100)],
[\amp, ControlSpec(0.0, 2.0, \lin, 0.001, 0.5)]];


~testcase = \gbman;
~interface.(~testcase);

)
