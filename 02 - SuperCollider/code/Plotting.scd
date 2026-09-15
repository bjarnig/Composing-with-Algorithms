////////////////////////////////////////////////////////////////
//
//                    Looking at Sound
//
////////////////////////////////////////////////////////////////

/* Everything in SuperCollider that holds numbers can draw itself.  */

s.boot;


//////////////// Arrays ////////////////

// any array of numbers
[1, 2, 9, 133, 344].plot;

// a computed one, which is the useful case
(0..40).collect { |i| i.squared }.plot;

// a series and a geometric series, side by side
[Array.series(24, 0, 1), Array.geom(24, 1, 1.2)].plot;

// random numbers under two different distributions
[{ 1.0.rand } ! 200, { 1.0.sum3rand } ! 200].plot;


//////////////// Envelopes ////////////////

Env.perc(0.01, 1).plot;

Env.adsr(0.1, 0.2, 0.3, 1).plot;

// the shape argument is the part worth seeing
[Env([0, 1, 0], [1, 1], \lin), Env([0, 1, 0], [1, 1], \sine),
 Env([0, 1, 0], [1, 1], \welch), Env([0, 1, 0], [1, 1], -4)].collect(_.asSignal(400)).plot;


//////////////// Waveforms ////////////////

// a function plots the first n seconds of what it would play, without playing it
{ SinOsc.ar(200) }.plot(0.02);

{ Saw.ar(200) }.plot(0.02);

// the same call at three time scales: one cycle, a few, a second
{ LFSaw.ar(200) }.plot(0.01);
{ LFSaw.ar(200) }.plot(0.2);
{ LFSaw.ar(200) }.plot(1);

// two channels come back as two plots
{ [SinOsc.ar(200), Saw.ar(200)] }.plot(0.02);

// modulation is visible: a slow triangle on the width of a pulse
{ VarSaw.ar(200, width: LFTri.ar(20).range(0.05, 0.95)) }.plot(0.05);


//////////////// The graph itself ////////////////

// not the signal but the UGen graph, drawn as a tree
{ RLPF.ar(Saw.ar(200), LFNoise1.kr(1).exprange(200, 3000), 0.2) }.plotGraph;


//////////////// Buffers ////////////////

(
b = Buffer.alloc(s, 1024, 1);
b.sine1([1, 0.5, 0.25, 0.125], asWavetable: false);
)

b.plot;

// a table built by hand, then read as an oscillator
(
c = Signal.newClear(1024);
1024.do { |i| c[i] = sin(2pi * i / 1024) + (0.3 * sin(6pi * i / 1024)) };
c.plot;
)


//////////////// While it runs ////////////////

/* plot draws something that has already happened. These four watch it happening.
   Every one of them is also a menu item in the IDE. */

s.meter;        // Cmd+M          how loud, in and out, in dBFS
s.scope;        // Cmd+Shift+M    the waveform, amplitude against time
s.freqscope;    // Cmd+Alt+M      the spectrum, amplitude against frequency
s.plotTree;     // Cmd+Alt+T      what is running, one line per node

// and the same tree posted rather than drawn
s.queryAllNodes;   // Cmd+T

// a scope for one function, without touching the server windows
{ SinOsc.ar(200) * LFPulse.kr(4) }.scope;

// something to look at while they are open
x = { RLPF.ar(Saw.ar([50, 50.3]), LFNoise2.kr(0.6).exprange(120, 4000), 0.2) * 0.3 }.play;

x.free;

s.freeAll;
