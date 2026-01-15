
////////////////////////// SynthDefs ////////////////////////////

(

~specs = Dictionary();

SynthDef(\uSimpler, {|buf=0, amp=0.2, note=60, atk=0.01, sus=0.5, rel=0.5, mod=0.1, pos=0.125|
	var sig, rate, env, pan, offset;
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, sus, rel]), levelScale:amp, doneAction:2);
	rate = BufRateScale.ir(buf) * (note / 60.0);
	offset = BufFrames.kr(buf) * mod;
	sig = PlayBuf.ar(1, buf, rate, 1, offset);
	pan = Pan2.ar(sig * env, pos);
	OffsetOut.ar(0, pan);
}).add;

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

)