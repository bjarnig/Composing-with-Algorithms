////////////////////////////////////////////////////////////////
//
//        Fb1 Single Sample Feedback (by Daniel Mayer)
//
////////////////////////////////////////////////////////////////


( // Install miSCellaneous if needed

Quarks.install("miSCellaneous");
thisProcess.recompile;

)

(

s.options.blockSize = 8;
s.quit.reboot;

)

s.freqscope;
s.scope;


//////////////////////// Filters ////////////////////////

( // OnePole with Fb1

x = {
    Fb1.ar(
        { |in, out| (in[0] * 0.05) + (out[1] * 0.95) },
        in: WhiteNoise.ar(0.3),
        blockSize: s.options.blockSize
    ) ! 2
}.play

)

x.release


// Compare with built-in OnePole

{ OnePole.ar(WhiteNoise.ar(0.3), 0.95) ! 2 }.play



//////////////////////// Nonlinear Operators ////////////////////////


( // The modulo operator '%'

x = {
    var sig = SinOsc.ar([20, 20.1]);
    var lfo = LFDNoise1.kr(2).linexp(-1, 1, 0.5, 1);
    LPF.ar(
        Fb1.ar(
            { |in, out| in[0] - (out[1] % lfo) },
            sig, 2, blockSize: s.options.blockSize
        ),
        15000
    ) * 0.3 ! 2
}.play

)


( // Using Select for selection decisions

x = {

	var src = LFDNoise3.ar(1, 0.1);
    var mod1 = LFDNoise3.ar(1).range(0.01, 0.2);
    var mod2 = LFDNoise3.ar(1).range([0.0001, 0.0002], 0.0049);

    Fb1.ar({ |in, out|
        var src = in[0][0];
        var mod1 = in[0][1];
        var mod2 = in[0][2];
        softclip(
            Select.kr(
                out[0] % 0.005 < mod2,
                [out[1].neg * mod1, out[0] * 0.1]
            ) + src + out[0]
        )
    }, [src, mod1, mod2], 2, 1, [[1, 2]],
        blockSize: s.options.blockSize,
        blockFactor: 8 / s.options.blockSize,

    ) * 0.75

}.play

)

x.release
