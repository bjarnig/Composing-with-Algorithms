////////////////////////////////////////////////////////////////
//
//                       Instructions
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


/* The following come from SLUGens SC3 Plugins by Nick Collins.
   These require the sc3-plugins package to be installed.
*/


( // Basic Instruction synthesis

var array, buffer;
array = Array.fill(1024, { |i| if(i.even, { 7.rand }, { 1.0.rand }) });
buffer = Buffer.sendCollection(s, array, 1, action: {
	{ Instruction.ar(buffer.bufnum) * 0.4 ! 2 }.play
});

)



( // Short instruction buffer (more chaotic)

var array, buffer;
array = Array.fill(8, { 1.0.rand });
buffer = Buffer.sendCollection(s, array, 1, action: {
	{ FreeVerb.ar(Instruction.ar(buffer.bufnum) * 0.4, 0.5, 0.8) ! 2 * 2.5 }.play
});

)



( // Instruction with structured buffer

var array, buffer;
// Create pattern: alternating values with occasional jumps
array = Array.fill(256, { |i|
	case
	{ i % 16 == 0 } { rrand(0.5, 1.0) }
	{ i % 4 == 0 }  { rrand(0.1, 0.3) }
	{ true }        { rrand(-0.1, 0.1) }
});
buffer = Buffer.sendCollection(s, array, 1, action: {
	{ HPF.ar(Instruction.ar(buffer.bufnum), 40) * 0.8 ! 2 }.play
});

)



///////////////////////// LPC ERROR //////////////////////////


( // Basic LPCError

{
	LPCError.ar(
		SinOsc.ar(LFNoise0.kr(0.2, 200, 300)),
		SinOsc.kr(0.1, 0, 63, 64)
	) * 0.3 ! 2
}.play

)



( // LPCError with noise input

{
	LPCError.ar(
		PinkNoise.ar(0.5),
		LFNoise1.kr(0.5).range(10, 100)
	) * 0.3 ! 2
}.play

)



( // LPCError modulating itself

{
	var lpc = LPCError.ar(
		SinOsc.ar(100),
		LFNoise2.kr(2).range(20, 80)
	);
	LPCError.ar(lpc, SinOsc.kr(0.2).range(30, 60)) * 0.2 ! 2
}.play

)



( // Filtered LPCError texture

{
	var sig = LPCError.ar(
		Saw.ar(LFNoise0.kr(1).range(50, 200)),
		LFNoise1.kr(0.3).range(20, 100)
	);
	BPF.ar(sig, LFNoise1.kr(0.1).range(500, 2000), 0.5) * 0.4 ! 2
}.play

)


///////////////////////// GRAVITY GRID //////////////////////////



( // GravityGrid with LeastChange modulation

{
	var grid = GravityGrid.ar(0, [30, 60, 90, 120]);
	var mod = SinOsc.ar(5);
	HPF.ar(LeastChange.ar(grid, mod),30) * 0.3 ! 2
}.play

)



( // GravityGrid texture with filtering

{
	var freq = 40;
	var grid = GravityGrid.ar(0, [freq/2, freq/4, freq, freq/16]);
	var saw = Saw.ar(freq);
	var sig = LeastChange.ar(grid, saw);
	HPF.ar(BBandStop.ar(sig, LFNoise1.ar(0.5).range(400, 1000), 12), 40) * 0.6 ! 2
}.play

)



( // Multi-frequency GravityGrid

{
	var freqs = Array.fill(8, { |i| 10 * (i + 1) * rrand(0.8, 1.2) });
	var grid = GravityGrid.ar(0, freqs);
	var mod = PMOsc.ar(10, 500, 1);
	LPF.ar(LeastChange.ar(grid, mod), 200) * 0.05 ! 2
}.play

)
