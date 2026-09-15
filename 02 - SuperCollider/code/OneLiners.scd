////////////////////////////////////////////////////////////////
//
//                       One Liners
//
////////////////////////////////////////////////////////////////

/* Ten sounds, one line each. Cmd+. stops everything. */

s.boot;


// 1. six pulse waves at once, most of them below hearing, through one sweep    0.33
{ RLPF.ar(Splay.ar(Pulse.ar([10, 25, 80, 9, 4, 3], 0.5, 0.1)), XLine.kr(8000, 400, 5), 0.05) }.play;


// 2. Xenakis: twelve control points taking a bounded random walk                0.25
{ Gendy1.ar(1, 1, 1, 1, 60, 2080, 0.6, 0.4, 12, 12, 0.25) ! 2 }.play;


// 3. something short and broad striking something narrow that rings             0.42
{ Ringz.ar(Dust.ar(6) * 0.4, LFNoise0.kr(6).exprange(50, 4000), 0.6) ! 2 * 0.5 }.play;


// 4. sixtenn partials, each at its own rate, spread across the stereo field 0.13
{ Splay.ar(SinOsc.ar((1..16) * 110) * LFPulse.kr((1..16) / 4)) * 0.1 }.play;


// 5. a comb delay long enough to be an echo, short enough to be a pitch         0.49
{ CombN.ar(Dust.ar(2) * 0.5, 0.2, LFNoise0.kr(1).range(0.01, 0.2), 8) ! 2 }.play;


// 6. a band-limited pulse walking in both frequency and harmonic count          0.20
{ Blip.ar(LFNoise0.kr(9).exprange(40, 4000), LFNoise0.kr(4).exprange(2, 60)) * 0.2 ! 2 }.play;


// 7. two saws a third of a hertz apart, through a resonant ladder filter        0.23
{ MoogFF.ar(Saw.ar([50, 50.3]), LFNoise2.kr(0.6).exprange(120, 4000), 3.2) * 0.7 }.play;


// 8. phase modulation, with the index wandering between 0 and 12                0.15
{ PMOsc.ar(LFNoise0.kr(3).exprange(80, 800), 220, LFNoise1.kr(2).range(0, 12)) * 0.15 ! 2 }.play;


// 9. a plucked string: noise into a delay that is the length of the string      0.75
{ Pluck.ar(WhiteNoise.ar(0.6), Impulse.kr(2), 0.05, LFNoise0.kr(2).exprange(0.002, 0.02), 8, 0.3) ! 2 }.play;


// 10. one sine, sampled at a rate that keeps changing, which is aliasing        0.29
{ LeakDC.ar(Latch.ar(SinOsc.ar(300), Impulse.ar(LFNoise0.kr(13).exprange(200, 6000)))) * 0.2 ! 2 }.play;


CmdPeriod.run;
