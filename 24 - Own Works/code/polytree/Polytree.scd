////////////////////////////////////////////////////////////////
//
//               Polytree -> Folded
//
////////////////////////////////////////////////////////////////

(

f.value(
	200,
	[12, 13, 6, 8], // attacks
	[4000, 6000, 4000, 4000], // lopass filters
	[6050, 7000, 5000, 4000], // frequencies
	[0.2, 0.2, 0.3, 0.3], // amplitudes
	[20, 20, 20, 20], // modFroms
	[16, 8, 4, 2], // modTos
	[20, 30, 10, 15], // modDurs
	[10, 150, 10, 150], // harms
	4, // bboctave
	4000, // bbfrom
	8000, // bbto
	100 // bbdeviation
)

)

(

f.value(
	12,
	Array.rand(1.2, 4, 12), // attacks
	[4000, 6000, 16000, 16000], // lopass filters
	Array.rand(4, 2000, 8000), // frequencies
	[0.5, 0.5, 0.6, 0.6], // amplitudes
	Array.rand(4, 15, 25), // modFroms
	[16, 8, 4, 2], // modTos
	[20, 30, 10, 15], // modDurs
	[10, 150, 10, 150], // harms
	4, // bboctave
	4000, // bbfrom
	8000, // bbto
	100 // bbdeviation
)

)


(

f.value(
	8,
	Array.rand(4, 2, 6), // attacks
	[4000, 6000, 16000, 16000], // lopass filters
	Array.rand(4, 2000, 4000), // frequencies
	[0.5, 0.5, 0.6, 0.6], // amplitudes
	Array.rand(4, 15, 25), // modFroms
	Array.rand(4, 1, 20), // modTos
	Array.rand(4, 8, 25), // modDurs
	[10, 150, 10, 150], // harms
	4, // bboctave
	4000, // bbfrom
	8000, // bbto
	100 // bbdeviation
)

)

(

f.value(
	15,
	Array.rand(0.4, 2, 6), // attacks
	[4000, 6000, 16000, 16000], // lopass filters
	Array.rand(4, 1000, 8000) * 0.25, // frequencies
	[0.5, 0.5, 0.6, 0.6], // amplitudes
	Array.rand(4, 2, 8), // modFroms
	Array.rand(4, 18, 25), // modTos
	Array.rand(4, 8, 25), // modDurs
	[10, 150, 10, 150], // harms
	4, // bboctave
	4000, // bbfrom
	8000, // bbto
	1000 // bbdeviation
)

)


(

f = {|duration, attacks, lopass, freqs, amps, modFroms, modTos, modDurs, harms, bboctave, bbfrom, bbto, bbdeviation|

Routine {

	var times = 4, synths = Array(times), patterns = Array(times + 1);

SynthDef(\folded, {
	arg amp=0.5, freq=6050, harm=10, modFrom=20, modTo=10, modDur=20, amp2=1.0,
	atk=0.5, sus=1, rel=8, mod=0.8, pos=0.125, out=0, gate=1, lpf=19000, bbf=2000, bbo=1;
	var sig, env, pan, offset, brown, frex, trig, base;
	env = EnvGen.ar(Env.asr(atk, sus, rrand(rel/2, rel*2), 4), gate, doneAction:2) * Lag.kr(amp, 0.5);
	sig = Blip.ar(freq, 10).fold2(SinOsc.ar(Line.kr(modFrom, modTo, modDur)));
	sig = BLowPass4.ar(sig, lpf) * amp2;
	sig = BBandStop.ar(sig, bbf, bbo);
	pan = OffsetOut.ar(out, HPF.ar(sig, 40) * env);
	}, 0.8 ! 6).add;

s.sync;

g = Group.new;

	times.do {|index|
		synths.add(Synth(\folded, [
			\atk, attacks[index], \lpf, lopass[index], \freq, freqs[index], \out, index, \amp, amps[index],
			\modFrom, modFroms[index], \modTo, modTos[index], \modDur, modDurs[index], \harm, harms[index]],
			g, \addToHead));
	};

patterns.add(Pbind(
    \type, \set,
    \id, synths[0].nodeID,
	\args, [\freq],
	\freq, Pwhite(6000.0, 6001),
	\dur, 0.2).play);

patterns.add(Pbind(
    \type, \set,
    \id, g.nodeID,
	\args, [\amp2, \bbf, \bbo],
    \dur, 0.2,
	\bbo, bboctave,
	\bbf, Pbrown(bbfrom, bbto, bbdeviation),
	\amp2, Pseg( Pseq([0.5, 0.8, 0.5],inf), Pseq([4, 1, 4],inf))
).play);

duration.wait;
synths.do{|item| item.set(\gate, 0) };
patterns.do {|pat| pat.postln; pat.stop}

}.play

}

)