////////////////////////////////////////////////////////////////
//
//     Functional Iteration Synthesis (by Daniel Mayer)
//
////////////////////////////////////////////////////////////////

/*

Di Scipio, Agostino (1999). "Synthesis Of Environmental Sound Textures by
Iterated Nonlinear Functions" in: Proceedings of the 2nd COST G-6 Workshop
on Digital Audio Effects (DAFx99), NTNU, Trondheim, December 9-11, 1999.

Di Scipio, Agostino (2001). "Iterated Nonlinear Functions as a Sound-Generating
Engine" Leonardo, Vol. 34, No. 3 (2001), pp. 249-254, MIT Press.

This approach uses the GFIS UGen (General Functional Iteration Synthesis)
to iterate nonlinear functions sample-by-sample, producing complex textures.

*/


( // Install miSCellaneous if needed

Quarks.install("miSCellaneous");
thisProcess.recompile;

)


//////////////////////// SineMap ////////////////////////

/*

The sine map:  f(x) = sin(r * x)
r is interesting between 2 and 4

*/


( // Plot: 3rd iteration, vary r, fixed x0

~x0 = 5;
f = { |r| sin(r * sin(r * sin(r * ~x0))) };
f.plotGraph(500, 0, 4);

)


( // Plot: 3rd iteration, vary x0, fixed r

~r = 3;
g = { |x0| sin(~r * sin(~r * sin(~r * x0))) };
g.plotGraph(500, 0, 10);

)


( // LF oscillation of r produces noisy textures

{
    var r = LFDNoise3.ar(10).range(3.5, 4);
    GFIS.ar({ |x| sin(r * x) }, init: 0.3, n: 9) * 0.2 ! 2
}.play

)


( // Producing pitch by periodically oscillating parameters

{
    var osc = SinOsc.ar([30, 30.5]);
    GFIS.ar({ |x|
        var src = osc + LFDNoise3.ar(0.15);
        sin(src.linlin(-2, 2, 3.2, 4) * x)
    }, 0.5, 9) * 0.1
}.play

)


( // Using a recording as variation of r

p = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
b = Buffer.read(s, p);

)


( // FIS adds partials, balance with low playback rates

{
    var p = PlayBuf.ar(1, b,
        rate: ToggleFF.ar(Dust.ar(15)).linlin(0, 1, -0.55, 0.25),
        loop: 1
    );
    // Map playback to critical sine map range
    GFIS.ar({ |x| sin(x * p.linlin(-1, 1, 3.73, 3.9)) }, [0.2, 0.203], 6) * 0.2
}.play

)


( // Varying init value instead

{
    var p = PlayBuf.ar(1, b,
        rate: ToggleFF.ar(Dust.ar(15)).linlin(0, 1, -0.55, 0.25),
        loop: 1
    );
    GFIS.ar({ |x| sin(x * [3.2, 3.21]) }, p / 10 + 0.8, 6) * 0.1
}.play

)

y.release


////////////////////// The Logistic Map ///////////////////////

/*

The logistic map (Verhulst):  f(x) = r * x * (1 - x)

Be careful with amplitudes. Can cause blowups with r > 4

*/

( // Time-varying factor r

{
    var r = SinOsc.ar(50).range(3, 4);
    var x0 = MouseX.kr(0, 1).poll;
	Limiter.ar(GFIS.ar({ |x| r * x * (1 - x) }, x0, 6)) * 0.5 ! 2
}.play

)


( // Time-varying init value x0

y = {
    var r = MouseX.kr(3, 4).poll;
    var x0 = SinOsc.ar(50).range(0.1, 0.9);
	Limiter.ar(GFIS.ar({ |x| r * x * (1 - x) }, x0, 6),0.9) ! 2
}.play

)
