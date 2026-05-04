////////////////////////////////////////////////////////////////
//
//                Copaline (Synthesis & Interrupts)
//
////////////////////////////////////////////////////////////////

(

Ndef(\kevlar, {
	arg a = 9, b = 5, min=0.1, max=0.3, modFreq=0.01, lpf=1000, mul=1.0, add=0.0;
	var sd = SampleDur.ir;
    var snd = DemandEnvGen.ar(
		Dseq([min, min.neg, [max.neg, max]], inf),
		Dseq([sd * a, sd * b], inf)
	).fold2(SinOsc.ar([modFreq, modFreq * 1.2])) * 0.3;
	LPF.ar(snd, lpf)
}).play

)

(

Ndef(\foil, {
	arg rate=12, trig=0.5, a = 8, b = 3, min=0.1, max=0.2;
	var trigger, seq, freq, sd = SampleDur.ir;
	trigger = Impulse.kr(trig);
	seq = Dseq([
		Dbrown(rate * 0.1, rate, rate * 0.1, rate * 1.6),
		Dwhite(rate * 0.1, rate, 8)], inf);
	freq = Demand.kr(trigger, 0, seq);
	HPF.ar(DemandEnvGen.ar(
		Dseq([min, min.neg, [max.neg, max]], inf),
		Dseq([sd * a, sd * b], inf)
	).fold2(SinOsc.ar([freq, freq*0.5])), 20, 0.25) * XLine.ar(0.01,0.6,40);
}).play

)

~interrupt.value(\foil)

~drop.value(\kevlar)


(

~interrupt = {|name, freq=10|
	var localDist = ("interrupt_" ++ name).asSymbol;
	var f1 = rrand(2.3, 7.5), f2 = rrand(3.2, 8.5);

	Routine {
		Ndef(localDist, {
			var lpf=150, hpf=8000, gaina=1000, gainb=200, son = \in.ar([0,0]);
			HPF.ar(SoftClipAmp8.ar(son, pregain:gaina) * EnvGen.ar(Env([0.2,0.1,0.0], [3,4,15])),
			Lag.ar(LFNoise0.ar(f1).range(hpf, hpf*2))) +
		    BBandStop.ar(LPF.ar(SoftClipAmp8.ar(son, pregain:gainb) *
			EnvGen.ar(Env([0.2,0.1,0.0], [2,5,15])), Lag.ar(LFNoise0.ar(f2).range(lpf*0.25, lpf))),80, 0.1);
		}).play;

		0.1.wait;
		Ndef(name).stop;
		Ndef(name) <>> Ndef(localDist);
		Ndef(localDist).play;

		25.wait;
		Ndef(localDist).stop;
	}.play;

	^Ndef(localDist)
};

~drop = {|name|
	var local = ("drop_" ++ name).asSymbol, dur = rrand(12, 14);

	Routine {
		Ndef(local, {
			var son = \in.ar([0,0]);
			var modTo = EnvGen.ar(Env(Array.geom(4, rrand(6,10), rrand(2,4)), [dur/2,dur/4,dur/6]));
			var filter = EnvGen.ar(Env(Array.series(4, rrand(1000,5000), rrand(1500,4500)), [dur/2,dur/4,dur/6]));
			var hpfSound = HPF.ar(son.tanh.distort, LFPar.ar( LFNoise1.ar(rrand(1,10)).range(modTo/4,modTo)).range(filter/4,filter));
			CombC.ar(hpfSound, 0.8, 0.2, 0.4) * EnvGen.ar(Env([1,0.75,0.5,0.0], [dur/6,dur/4,dur/2]));
		}).play;

		0.1.wait;
		Ndef(name) <>> Ndef(local);
		Ndef(local).play;
		Ndef(name).stop;

		dur.wait;
		Ndef(local).stop;
	}.play;

	^Ndef(local)
};

)
