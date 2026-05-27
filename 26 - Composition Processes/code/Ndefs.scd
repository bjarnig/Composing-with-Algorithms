////////////////////////////////////////////////////////////////
//
//                           Ndefs
//
////////////////////////////////////////////////////////////////


//////////////////////////  Setup  ////////////////////////////

s.boot;
"SynthDefs.scd".loadRelative;
Ndef.clear;


/////////////////////////  Layers  ////////////////////////////

(

Ndef(\drone, {
	var freq = 36.midicps;
	var sig = SinOsc.ar(
		freq * [1, 2, 3, 5, 7] * LFNoise1.kr([0.1, 0.13, 0.07, 0.12, 0.09]).range(0.99, 1.01),
		mul: [1, 0.5, 0.3, 0.15, 0.1]
	);
	Mix(sig) * 0.1 ! 2;
});

Ndef(\texture, {
	var sig = Dust.ar(120) + Crackle.ar(1.5, 0.5);
	BPF.ar(sig, LFNoise1.kr(0.3).exprange(400, 4000), 0.4) ! 2 * 0.5;
});

Ndef(\pulse, {
	var trig = Impulse.kr(LFNoise0.kr(0.3).range(4, 10));
	var freq = Demand.kr(trig, 0, Dseq([40, 47, 43, 50], inf).midicps);
	var sig = RLPF.ar(Saw.ar(freq * [1, 1.01]), freq * 6, 0.3);
	sig * EnvGen.ar(Env.perc(0.005, 0.2), trig) * 0.2;
});

Ndef(\lead)[0] = Pbind(
	\instrument, \fm,
	\dur, Prand([0.25, 0.5, 0.5, 1], inf),
	\midinote, Pxrand([60, 64, 67, 71, 72, 74], inf),
	\cmRatio, Pwhite(1.0, 2.0), \index, Pwhite(2, 7),
	\atk, 0.01, \rel, 0.3, \legato, 0.1, \amp, 0.2
);

[\drone, \texture, \pulse, \lead].do({ |k| Ndef(k).fadeTime = 4 });

)


/////////////////////  Master + global FX  ////////////////////

(

Ndef(\master, {
	var d = Ndef(\drone).ar(2)   * \lDrone.kr(0).lag(6);
	var t = Ndef(\texture).ar(2) * \lTex.kr(0).lag(6);
	var p = Ndef(\pulse).ar(2)   * \lPulse.kr(0).lag(6);
	var l = Ndef(\lead).ar(2)    * \lLead.kr(0).lag(6);
	Mix([d, t, p, l]);
}).play;

Ndef(\master).filter(10, { |in| Compander.ar(in, in, 0.4, 1, 0.4, 0.01, 0.1) });
Ndef(\master).filter(20, { |in| in + FreeVerb.ar(in, 0.25, 0.85, 0.4) });
Ndef(\master).filter(30, { |in| Limiter.ar(in, 0.95) });

)

Ndef(\master).set(\lDrone, 1);
Ndef(\master).set(\lTex, 0.6);
Ndef(\master).set(\lPulse, 0.8);
Ndef(\master).set(\lLead, 0.7);


///////////////////////  The conductor  ///////////////////////

(

Tdef(\conductor, {
	"intro".postln;
	Ndef(\master).set(\lDrone, 1, \lTex, 0, \lPulse, 0, \lLead, 0);
	16.wait;

	"build".postln;
	Ndef(\master).set(\lTex, 0.6);
	12.wait;
	Ndef(\master).set(\lPulse, 0.8);
	12.wait;

	"climax".postln;
	Ndef(\master).set(\lLead, 0.7, \lDrone, 0.7);
	24.wait;

	"outro".postln;
	Ndef(\master).set(\lLead, 0, \lPulse, 0, \lTex, 0);
	12.wait;
	Ndef(\master).set(\lDrone, 0);
	"--- done ---".postln;
});

)

Tdef(\conductor).play;
Tdef(\conductor).stop;
