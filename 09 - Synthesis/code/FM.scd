////////////////////////////////////////////////////////////////
//
//                            FM
//
////////////////////////////////////////////////////////////////

This class covers examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

////////////////////// FM Synthesis //////////////////////


// Modulate frequency with LFO (Low Frequency Oscillator)
{ SinOsc.ar(LFSaw.kr(100, 0, 400, 400), 0, 0.5) }.play



// LFTri
{ SinOsc.ar(LFTri.kr(2, 0, 400, 400), 0, 0.5) }.play



// LFPulse
{ SinOsc.ar(LFPulse.kr(3, 1, 0.3, 200, 200),0, 0.7) }.play



// LFPar
{ SinOsc.ar(LFPar.kr(2, 0, 400, 400),0, 0.5) }.play



// LFCub
{ SinOsc.ar(LFCub.kr(2, 0, 400, 400),0, 0.5) }.play



// Other waveforms
{ LFSaw.ar(LFTri.kr(4, 0, 200, 400), 0, 0.7) }.play
{ LFTri.ar(LFSaw.kr(4, 0, 200, 800), 0, 0.7) }.play



// Modulation in audio rate produces new frequencies called sidebands.
{ SinOsc.ar(LFPar.kr(105, 0, 400, 400),0, 0.5) }.play



// FM with two sine waves
(
    var carrierFreq = 400, modFreq = 50, deviation = 100;
    {
	    SinOsc.ar(carrierFreq + SinOsc.ar(modFreq, mul: deviation),mul: 0.3);
    }.scope
)



// FM with index
(
    var carrfreq=440, modfreq=55, modindex=10.5;
    {
        SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)), mul: 0.5)
    }.scope;
)



// Phase Modulation, modulate carfreq
{ PMOsc.ar(Line.kr(600, 10, 3), Line.kr(600, 10, 3), 3, 0, 0.1) }.play;



// Modulate modfreq
{ PMOsc.ar(300, Line.kr(600, 900, 5), 3, 0, 0.1) }.play;



 // Modulate index
{ PMOsc.ar(300, 550, Line.ar(0,20,8), 0, 0.1) }.play;

(
	{
		var carrierFreq = 400, modFreq = 50, index = 3, decayTime = 5;
		EnvGen.kr(Env.perc(0.001,decayTime,0.2),1,doneAction: 2) *
	  	PMOsc.ar(carrierFreq, modFreq, index,0);
	}.scope
)



// FM Synthdef
(
	SynthDef(\fm, {
		|carrierFreq = 400,  cmRatio = 1.5, index = 3, decayTime = 0.01, amp = 1|
		var signal,modFreq;
		modFreq = (carrierFreq * cmRatio.reciprocal);
		signal = EnvGen.kr(Env.perc(0.001,decayTime,0.2),1, amp,doneAction: 2) *
	    PMOsc.ar(carrierFreq, modFreq, index,0);
	    Out.ar(0,signal)
	}).add
)



// Play an instance
Synth(\fm, [\decayTime, 5])


Synth(\fm, [\decayTime, 1, \carrierFreq, 200])




// With routines,random carrierFreqs and random offset between events
(
	Routine({
		{ Synth(\fm, [\carrierFreq, rrand(100.0,1000)]);
	    	rrand(0.001,0.1).wait;
	   	}.loop
 	}).play
)
