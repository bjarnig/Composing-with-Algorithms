
///////////////////////////////////////////////////////////////////////////
////////////////////////////// cendres O4 /////////////////////////////////
///////////////////////////////////////////////////////////////////////////

(

~scenes4 = Dictionary();

Ndef(\golum).fadeTime = 2;
Ndef(\io).fadeTime = 1;

// Ndef.clear

//
~scenes4[5].value;
~scenes4[0] = {

	" ## scene41 ##".postln;

Ndef(\golum, {|rate=10, grAtk=0.88, grRel=0.2, rq = 1.2|
	var secRate = Array.series(8,rate,rate);
	var trigger= (Impulse.ar(secRate) * 0.8) + (Dust.ar(secRate) * 0.2);
	var env= EnvGen.ar(Env.perc(grAtk, grRel, 1, 4), trigger, 1, 0, (1/rate));
    var sig = HPF.ar(SinOsc.ar([rate/3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul:env), rate * 8, 0.2), 40)*0.8;
		sig = BPeakEQ.ar(sig, 100,2,-6) * XLine.ar(0.001, 1.0, 16);
}).play;

Ndef(\io, {
	var freqs = Array.series(8, 666, 10);
	var noise = LFClipNoise.ar(10000, 0.1);
	var sig = BBandPass.ar(noise, LFNoise2.ar(Array.series(8,0.05,0.05)).range(0.3,1.5) * freqs, 0.08);
	sig = sig * LFNoise1.ar(1.12).range(0.1,0.9) * 0.9;
	sig = sig * EnvGen.ar(Env.perc(0.05, 0.05), Impulse.ar(20));
	sig = BBandStop.ar(sig, LFNoise2.ar(0.1).range(1000,6000), 4)* XLine.ar(0.001, 1.0, 12);
}).play

};

~scenes4[1] = {

	" ## scene42 ##".postln;

Ndef(\golum, {|rate=10, grAtk=0.88, grRel=0.2, rq = 1.2|
	var trigger= (Impulse.ar(rate) * 0.8) + (Dust.ar(rate) * 0.2);
	var env= EnvGen.ar(Env.perc(grAtk, grRel, 1, 4), trigger, 1, 0, (1/rate));
	HPF.ar(SinOsc.ar([rate/3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul:env), rate * Array.series(8,4,4), 0.2), 40)*0.8;
}).play;

Ndef(\io, {
	var freqs = Array.series(8, 1666, 20);
	var noise = LFClipNoise.ar(10000, 0.1);
	var sig = BBandPass.ar(noise, LFNoise2.ar(0.1).range(0.3,1.5) * freqs, 0.08);
	sig = sig * LFNoise1.ar(1.12).range(0.1,0.9) * 0.9;
	sig = sig * EnvGen.ar(Env.perc(0.05, 0.05), Impulse.ar(20));
	sig = BBandStop.ar(sig, LFNoise2.ar(0.1).range(1000,6000), 4);
}).play

};

~scenes4[2] = {

	" ## scene43 ##".postln;

Ndef(\golum, {|rate=20, grAtk=0.82, grRel=0.2, rq = 1.2|
	var secRate = Array.series(8,rate,rate);
	var trigger= (Impulse.ar(secRate) * 0.8) + (Dust.ar(secRate) * 0.2);
	var env= EnvGen.ar(Env.perc(grAtk, grRel, 1, 4), trigger, 1, 0, (1/rate));
    var sig = HPF.ar(SinOsc.ar([rate/3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul:env), rate * 8, 0.15), 40)*0.7;
		sig = BPeakEQ.ar(sig, 100,2,-7);
}).play;

Ndef(\io, {
	var freqs = Array.series(8, 666, 10);
	var noise = LFClipNoise.ar(10000, 0.1);
	var sig = BBandPass.ar(noise, LFNoise2.ar(Array.series(8,0.05,0.05)).range(0.3,1.5) * freqs, 0.08);
	sig = sig * LFNoise1.ar(1.12).range(0.1,0.9) * 0.9;
	sig = sig * EnvGen.ar(Env.perc(0.05, 0.05), Impulse.ar(20));
	sig = BBandStop.ar(sig, LFNoise2.ar(0.2).range(1000,8000), 6)* XLine.ar(0.001, 1.0, 12);
}).play

};

~scenes4[3] = {

	" ## scene44 ##".postln;

Ndef(\golum, {|rate=18, grAtk=0.84, grRel=0.2, rq = 1.2|
	var trigger= (Impulse.ar(rate) * 0.8) + (Dust.ar(rate) * 0.2);
	var env= EnvGen.ar(Env.perc(grAtk, grRel, 1, 4), trigger, 1, 0, (1/rate));
	HPF.ar(SinOsc.ar([rate/3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul:env), rate * Array.series(8,4,4), 0.2), 40)*0.8;
}).play;

Ndef(\io, {
	var freqs = Array.series(8, 1666, 20);
	var noise = LFClipNoise.ar(10000, 0.1);
	var sig = BBandPass.ar(noise, LFNoise2.ar(0.1).range(0.3,1.5) * freqs, 0.08);
	sig = sig * LFNoise1.ar(1.12).range(0.1,0.9) * 0.9;
	sig = sig * EnvGen.ar(Env.perc(0.05, 0.05), Impulse.ar(20));
	sig = BBandStop.ar(sig, LFNoise2.ar(0.4).range(1000,3000), 4);
}).play

};

~scenes4[4] = {

	var durit = 12;

	" ## scene45 ##".postln;

Ndef(\golum, {|rate=25, grAtk=0.88, grRel=0.2, rq = 0.2|
	var trigger= (Impulse.ar(rate) * 0.8) + (Dust.ar(rate) * 0.2);
	var env= EnvGen.ar(Env.perc(XLine.kr(grAtk, grAtk* 0.89, durit), grRel, 1, 4), trigger, 1, 0, (1/rate));
	HPF.ar(SinOsc.ar([rate/3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul:env), rate * Array.series(8,4,4), 0.2), 40);
}).play;

Ndef(\io, {
	var freqs = Array.series(8, 2666, 25);
	var noise = LFClipNoise.ar(10000, 0.1);
	var sig = BBandPass.ar(noise, LFNoise2.ar(0.1).range(0.3,1.5) * freqs, 0.08);
	sig = sig * LFNoise1.ar(1.12).range(0.1,0.9) * 0.9;
	sig = sig * EnvGen.ar(Env.perc(0.05, 0.05), Impulse.ar(20));
	sig = BBandStop.ar(sig, LFNoise2.ar(XLine.ar(0.1, 19, durit)).range(1000,6000), 4);
}).play

};

~scenes4[5] = {

	" ## scene46 ##".postln;

Ndef(\golum, {|rate=30, grAtk=0.88, grRel=0.1, rq = 1.2|
	var trigger= (Impulse.ar(rate) * 0.8) + (Dust.ar(rate) * 0.2);
		var env= EnvGen.ar(Env.perc(XLine.ar(grAtk, grAtk * 1.02, 12), grRel, 1, 4), trigger, 1, 0, (1/rate));
	HPF.ar(SinOsc.ar([rate/3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul:env), rate * Array.series(8,4,4), 0.2), 40);
}).play;

Ndef(\io, {
	var freqs = Array.series(8, 400, 40);
	var noise = LFClipNoise.ar(10000, 0.1);
	var sig = BBandPass.ar(noise, LFNoise2.ar(0.1).range(0.3,1.5) * freqs, 0.08);
	sig = sig * LFNoise1.ar(21.12).range(0.1,0.9) * 1.1;
	sig = sig * EnvGen.ar(Env.perc(0.05, 0.05), Impulse.ar(20));
	sig = BBandStop.ar(sig, LFNoise2.ar(30.1).range(1000,6000), 4);
}).play

};

~scenes4[6] = {

	var durit = 12;

	" ## scene47 ##".postln;

Ndef(\golum, {|rate=25, grAtk=0.88, grRel=0.2, rq = 0.2|
	var trigger= (Impulse.ar(rate) * 0.8) + (Dust.ar(rate) * 0.2);
	var env= EnvGen.ar(Env.perc(XLine.kr(grAtk, grAtk* 0.5, durit), XLine.kr(grRel, grRel* 0.5, durit), 1, 4), trigger, 1, 0, (1/rate));
		HPF.ar(SinOsc.ar([rate/3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul:env), rate * Array.series(8,4,4), 0.2), XLine.ar(40,2000, durit * 2));
}).play;

Ndef(\io, {
	var freqs = Array.series(8, 2666, 25);
	var noise = LFClipNoise.ar(1000, 0.1);
	var sig = BBandPass.ar(noise, LFNoise2.ar(0.1).range(0.3,1.5) * freqs, 0.08);
	sig = sig * LFNoise1.ar(1.12).range(0.1,0.9) * 0.9;
	sig = sig * EnvGen.ar(Env.perc(0.05, 0.05), Impulse.ar(20));
	sig = BBandStop.ar(sig, SinOsc.ar(XLine.ar(0.1, 0.2, durit)).range(1000,6000), 4);
	sig = LPF.ar(sig, XLine.ar(18000,80, durit * 2))
}).play

};

~scenes4[7] = {

	var durit = 9;

	" ## scene48 ##".postln;

Ndef(\golum, {|rate=40, grAtk=0.58, grRel=0.1, rq = 1.2|
	var trigger= (Impulse.ar( XLine.kr(rate, rate*0.25, durit)) * 0.8) + (Dust.ar( XLine.kr(rate, rate*0.25, durit)) * 0.2);
		var env= EnvGen.ar(Env.perc(XLine.ar(grAtk, grAtk * 1.02, 12), grRel, 1, 4), trigger, 1, 0, (1/rate));
		HPF.ar(SinOsc.ar([rate/3, rate], 0, env * 0.5) + BPF.ar(PinkNoise.ar(mul:env), rate * Array.series(8,4,4), 0.2), XLine.kr(2000, 6000, durit));
}).play;



};

)
