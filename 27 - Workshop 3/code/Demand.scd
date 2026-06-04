////////////////////////////////////////////////////////////////
//
//                        Demand Rate
//
////////////////////////////////////////////////////////////////


Demand rate UGens generate values when triggered,
bridging the gap between patterns and the server.
They allow sequencing and control logic to run
directly on the audio server.

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// Demand ///////////////////////////////


// Demand needs a trigger and a demand rate UGen

(
{
	var seq, demand, pulse;
	seq = Dseq([1, 2, 3] * 100, inf);
	pulse = Impulse.ar(10);
	demand = Demand.ar(pulse, 0, seq);
	Saw.ar(demand) * 0.02 ! 2
}.play
)


// Multichannel expansion with nested patterns

(
{
	var seq, demand, pulse, times = 10, speed = 25;
	seq = Dbrown(0, Dwhite(0.1, 1.0, inf), Array.rand(times, 0.01, 0.8));
	pulse = Impulse.ar(speed);
	demand = Demand.ar(pulse, 0, seq * 1000);
	Splay.ar(Impulse.ar(demand), level: 0.5)
}.play
)


// Dseq with irregular intervals and inharmonic partials

(
{
	var trig, seq, freq;
	trig = Impulse.kr(9);
	seq = Dseq([137, 311, 89, 523, 173, 41], inf);
	freq = Demand.kr(trig, 0, seq);
	Ringz.ar(Impulse.ar(freq * 0.01), freq, 0.15) * 0.3 ! 2
}.play
)


// Drand picks from a pool without repetition guarantee

(
{
	var trig, seq;
	trig = Impulse.kr(8);
	seq = Drand([87, 139, 370, 611, 1830], inf);
	RLPF.ar(Saw.ar(Demand.kr(trig, 0, seq)), 3000, 0.2) * 0.15 ! 2
}.play
)


// Dxrand guarantees no immediate repetition

(
{
	var trig, freq;
	trig = Impulse.kr(5);
	freq = Demand.kr(trig, 0, Dxrand([73, 191, 347, 571, 1117], inf));
	PMOsc.ar(freq, freq * 1.37, 4) * 0.1 ! 2
}.play
)


///////////////////////// Dbrown ///////////////////////////////


// Dbrown: bounded random walk

(
{
	var trig = Impulse.kr(12);
	var freq = Demand.kr(trig, 0, Dbrown(80, 3000, 150, inf));
	Pulse.ar(freq, 0.3) * 0.1 ! 2
}.play
)


// Dbrown controlling filter cutoff on noise

(
{
	var trig = Impulse.kr(20);
	var cutoff = Demand.kr(trig, 0, Dbrown(200, 6000, 300, inf));
	RLPF.ar(PinkNoise.ar(0.3), Lag.kr(cutoff, 0.05), 0.2) ! 2
}.play
)


// Dbrown as a slow wandering resonance

(
{
	var trig = Impulse.kr(3);
	var rfreq = Demand.kr(trig, 0, Dbrown(100, 4000, 80, inf));
	Ringz.ar(Dust.ar(15), Lag.kr(rfreq, 0.3), 0.2) * 0.2 ! 2
}.play
)


///////////////////////// Duty //////////////////////////////////


// Duty sets its own timing from a demand rate source

(
{
	var duty = Duty.ar(Dwhite(0.2, 1.5, inf), 0, Dwhite(100, 1000, inf));
	LPF.ar(WhiteNoise.ar, Lag.ar(duty, 5)) ! 2
}.play
)


// Duty with irregular timing

(
{
	var freq = Duty.kr(
		Dseq([0.15, 0.4, 0.1, 0.7, 0.05], inf), 0,
		Dwhite(60, 8000, inf)
	);
	Resonz.ar(Impulse.ar(freq * 0.02), freq, 0.02, 30) ! 2
}.play
)


// Duty with Dgeom for accelerating sequences

(
{
	var dur = Duty.kr(
		Dgeom(0.5, 0.9, 32), 0,
		Dseq(Array.rand(8, 200, 2000), inf)
	);
	Blip.ar(dur, 5) * 0.15 ! 2
}.play
)


///////////////////// Demand as Waveform ////////////////////////


// Demand rate at audio speed creates custom waveforms

(
{
	var trig, movement;
	trig = Impulse.ar(400);
	movement = Dbrown(-1, 1, 0.8, inf);
	Demand.ar(trig, 0, movement) ! 2 * 0.5
}.play
)


// Alternating dense and sparse waveform segments

(
{
	var trig, movement;
	trig = Impulse.ar(SinOsc.kr(0.1, 0, 4500, 8000));
	movement = Dseq([
		Dbrown(-0.1, 0.1, 0.5, 32),
		Dbrown(-0.8, 0.8, 0.5, 16)
	], inf);
	Demand.ar(trig, 0, movement) ! 2 * 0.5
}.play
)


// Sequencing ranges of random density

(
{
	var da, db, dc, dd;
	da = Dwhite(-1.0, 1.0, Dwhite(2, 128));
	db = Dwhite(-0.2, 0.2, Dwhite(2, 128));
	dc = Dwhite(-0.1, 0.1, Dwhite(2, 128));
	dd = Dwhite(0.0, 0.6, Dwhite(2, 128));
	Demand.ar(Impulse.ar(5000), 0, Dseq([da, db, dc, dd], inf))
}.play
)


////////////////// Demand for Modulation ////////////////////////


// Demand rate controlling FM index

(
{
	var trig = Impulse.kr(4);
	var idx = Demand.kr(trig, 0, Dseq([1, 3, 7, 12, 3], inf));
	var freq = Demand.kr(trig, 0, Dwhite(80, 600, inf));
	PMOsc.ar(freq, freq * 1.73, idx) * 0.15 ! 2
}.play
)


// Demand rate for rhythmic amplitude gating

(
{
	var trig = Impulse.kr(16);
	var gate = Demand.kr(trig, 0, Dseq([1, 1, 0, 1, 0, 0, 1, 0], inf));
	var sig = LFSaw.ar([80, 80.5]);
	sig * gate * 0.2
}.play
)


// Demand controlling oscillator frequency at high speed

(
{
	var brown, freq, trig;
	brown = Dbrown(50, 5000, 100, inf);
	trig = Impulse.kr(500);
	freq = Demand.kr(trig, 0, brown);
	Pulse.ar(freq) ! 2 * 0.1
}.play
)


// Demand rate with DynKlank for resonant body

(
{
	var trig = Impulse.ar(Demand.kr(
		Impulse.kr(2), 0,
		Dwhite(3, 15, inf)
	));
	var freqs = Demand.kr(Impulse.kr(0.5), 0,
		Dwhite(80, 600, 4)
	);
	DynKlank.ar(
		`[Array.rand(4, 100, 3000), nil, Array.rand(4, 0.1, 0.5)],
		trig * 0.01
	) ! 2
}.play
)
