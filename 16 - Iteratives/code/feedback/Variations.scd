////////////////////////////////////////////////////////////////
//
//                 Feedback Variations
//
////////////////////////////////////////////////////////////////


//////////////////////// FB ////////////////////////


/*

Bandpass filter and Fb(

*/

(

SynthDef(\fbBandpass, {|feedback=0.98, minFreq=100, maxFreq=1000|
    var sig, effect;

    // Test source (replace with your input)
    sig = Gendy3.ar(freq:100) ! 2;

    effect = Fb({|fbSig|
        BPF.ar(
            fbSig * feedback + sig,
            LFNoise1.ar(5).range(minFreq, maxFreq),
            4
        ).round(0.01);  // Bit crushing
    }, 2, EnvGen.ar(Env([1.8, 0.1], [20], [-5]).circle));

    Out.ar(0, Limiter.ar(effect))
}).add;

)

x = Synth(\fbBandpass);
x.set(\feedback, 0.95);
x.set(\minFreq, 200, \maxFreq, 2000);
x.free;


////////////////////// PitchShift Feedback ///////////////////////

/*

Feedback with pitch shifting for varying harmonics

*/

(

SynthDef(\pitchFb, {|feedback=0.7, ratio=1.5, grainSize=0.1, dispersion=0.01|
    var sig, effect;

    sig = Saw.ar(45) * 0.5 ! 2;

    effect = sig + LocalIn.ar(2);
    effect = PitchShift.ar(effect, grainSize, ratio, dispersion, dispersion);
	effect = LPF.ar(effect, LFNoise1.ar(1).range(1000,10000));  // Tame the highs

    LocalOut.ar(effect.tanh * feedback);
    Out.ar(0, Limiter.ar(effect * 0.5))
}).add;

)

x = Synth(\pitchFb);
x.set(\ratio, 0.5);   // Descending
x.set(\ratio, 1.5);   // Ascending
x.set(\ratio, 2);     // Octave up
x.set(\feedback, 0.99);
x.free;



////////////////////// Spectral Freezing Feedback //////////////////////

/*

Combines Fb feedback with spectral freezing

*/

~freezeBuf = Buffer.alloc(s, 2048);

(

SynthDef(\spectralFb, {|feedback=0.95, freezeRate=0.1, filterFreq=2000, bufnum|
    var sig, effect, chain, thres;

	sig = Gendy5.ar(initCPs:[5,10]) * 0.3;

    // Fb feedback with filtering
    effect = Fb({|fbSig|
        BPF.ar(
            fbSig * feedback + sig,
            LFNoise1.kr(1, 200, filterFreq),
            4
        ).tanh;
    }, 0.2);

    // Spectral processing
    chain = FFT(bufnum, effect[0]);
    thres = Duty.ar(Dwhite(0.01, freezeRate, inf), 0, Dwhite(0.4, 0.6, inf));
    chain = PV_Freeze(chain, thres > 0.5);

    Out.ar(0, IFFT(chain) ! 2)
}).add;

)

x = Synth(\spectralFb, [\bufnum, ~freezeBuf.bufnum]);
x.set(\freezeRate, 0.05);
x.set(\filterFreq, 1000);
x.free;


//////////////////////// Comb Feedback ////////////////////////

/*

Multiple comb filters in feedback create richness

*/

(
SynthDef(\combCascade, {|feedback=0.8, baseDelay=0.02, decay=2|
    var sig, effect;

    // Test source
    sig = Dust.ar(2) * 0.5 ! 2;

    effect = sig + LocalIn.ar(2);

    // Cascade of comb filters
    effect = Mix.fill(5, {|i|
        CombC.ar(
            effect,
            0.1,
            baseDelay * (i + 1) * LFNoise1.kr(0.1).range(0.95, 1.05),
            decay
        )
    }) / 5;

    effect = LeakDC.ar(effect);
    LocalOut.ar(effect.tanh * feedback);
    Out.ar(0, Limiter.ar(effect) * 0.8)
}).add;
)

x = Synth(\combCascade);
x.set(\baseDelay, 0.01);
x.set(\decay, 4);
x.set(\feedback, 0.9);
x.free;


//////////////////////// WaveFolder Feedback ////////////////////////

/*

Nonlinear waveshaping in feedback loop

*/

(

SynthDef(\wavefoldFb, {|feedback=0.8, foldAmt=2, filterFreq=4000|
    var sig, effect;

    // Test source
    sig = LFTri.ar([40, 40.1]) * 0.2;

    effect = sig + LocalIn.ar(2);

    // Wavefolding
    effect = (effect * foldAmt).fold2(1);
    effect = LPF.ar(effect, filterFreq);
    effect = LeakDC.ar(effect);

    LocalOut.ar(effect * feedback);
    Out.ar(0, Limiter.ar(effect * 0.5))
}).add;

)

x = Synth(\wavefoldFb);
x.set(\foldAmt, 4);
x.set(\filterFreq, 2000);
x.set(\feedback, 0.9);
x.free;

