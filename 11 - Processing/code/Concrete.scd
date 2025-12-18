////////////////////////////////////////////////////////////////
//
//                          Concrete
//
////////////////////////////////////////////////////////////////

This document covers sampling, buffers, recording and sample
playback techniques.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


/////////////////////////// Buffers ////////////////////////////

/* A buffer is most often used to hold sampled audio, such as a
soundfile loaded into memory. */

s = Server.local


// Open a dialog to choose a sample.
b = Buffer.loadDialog(s);

(

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
~path = ~path ++ "sounds/";
~noise = ~path ++ "branches.wav";
~vocal = ~path ++ "vocal.wav";

)

// Read from path
b = Buffer.read(s, ~noise);


// Once loaded we can query the buffer
b.query
b.play
b.plot
b.duration
b.bufnum


// List all server buffers
s.cachedBuffersDo { arg buf; [buf.bufnum, buf.path].postln }



// FreeSelfWhenDone to free after playing
(
    {
	    var sig;
	    sig = PlayBuf.ar(1, b.bufnum, BufRateScale.ir(b.bufnum), loop: 1);
	    FreeSelfWhenDone.kr(sig);
	    Out.ar(0, sig);
	}.play
)



// Streaming
b = Buffer.cueSoundFile(s, ~noise, 0, 1);

(
	{
		var sig;
		sig = DiskIn.ar(1, b.bufnum, 0);
		Out.ar(0, sig);
	}.play
)



// PlayBuf
b = Buffer.read(s, ~noise);



// Normal playback
{ PlayBuf.ar(1, b.bufnum, 0.5, 1, loop: 1) }.play



// Half rate
{ PlayBuf.ar(1, b.bufnum, 0.5, loop: 1) }.play



// Mouse for rate
{ PlayBuf.ar(1, b.bufnum, rate: MouseX.kr(0.1,8), loop: 1) }.play



// Use BufRateScale to adjust to sample rate
{ PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum), loop: 1) }.play



// BufFrames.kr(bufnum) for current number of allocated frames, use for offset
(
	{
		var offset = 0.9;
		PlayBuf.ar(1, b.bufnum, startPos: BufFrames.kr(b.bufnum) * offset, loop: 0)
	}.play
)



// Reset playback using a trigger (Impulse)
(
	{
		var offset = 1/2;
		PlayBuf.ar(1, b.bufnum,
			trigger: Impulse.kr(5).poll,
			startPos: BufFrames.kr(b.bufnum) * offset, loop: 0)
	}.play
)


(

SynthDef(\sampler, {|buf|
	var sound;
	sound = PlayBuf.ar(1, buf);
	FreeSelfWhenDone.kr(sound);
	Out.ar(0, sound);

}).add

)

Synth(\sampler, [\buf, b])




// Calculating a trigger frequency ((serverSampleRate / numberOfFrames) * rateScale)
(
	{
		var offset = 0, frames = 1;
		PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum),
		Impulse.kr(s.sampleRate / (BufFrames.kr(b.bufnum) * frames)
		* BufRateScale.kr(b.bufnum)),
		startPos: BufFrames.kr(b.bufnum) * offset)
	}.play
)




// BufRd to play buffers
(
	{
		var sig, phase, mouse;
		mouse = MouseY.kr(0.1, 20, \exponential);
		phase = LFDNoise3.ar(mouse).range(0, BufFrames.ir(b.bufnum));
		sig = BufRd.ar(1, b.bufnum, phase, 1, 4);
		Out.ar(0, sig);
	}.play
)




// BufRd, read buffer once using BufDur
(
    {
	    BufRd.ar(1,b.bufnum,
	    	Line.ar(0,BufFrames.kr(b.bufnum), BufDur.kr(b.bufnum), doneAction: 2)
	    )
    }.play
)




// BufRd, go through buffer in 25 seconds
(
    {
	    BufRd.ar(1,b.bufnum, Line.ar(0,BufFrames.kr(b.bufnum), 25, doneAction: 2))
    }.play
)




// BufRd, read through buffer with a warped envelope
(
    {
	    BufRd.ar(1,b.bufnum, EnvGen.ar(
	    	Env([0,b.numFrames,b.numFrames * 0.5,b.numFrames],[1,0.5,0.7]
	    ),
		timeScale: 10.0, doneAction: 2))
    }.play
)




// BufRd, read through the buffer with a sine
(
    {
	    var freq = 0.1;
	    BufRd.ar(1, b.bufnum, SinOsc.ar(freq, mul: 0.5, add: 0.5)
	    * BufFrames.kr(b.bufnum), 0, 4)
    }.play
)




// BufRd, layers
(
	{
		var trig = Dust.kr(10), layers = 25, freqFrom=0.01, freqTo=0.75;
		Mix.fill(layers, {
			Pan2.ar(
			BufRd.ar(1, b.bufnum,
			SinOsc.ar(TRand.kr(freqFrom, freqTo, trig), 0, 0.5, 0.5)
			* BufFrames.kr(b.bufnum), 0, 4))
		})
	}.play
)


// Load files from a folder

~loadFolder = {|folder|
	var sndPath = folder ++ "/*";
	var files = SoundFile.collect(sndPath);
	files.collect { |sf| Buffer.read(Server.local, sf.path)}
};

// Replace the path with your own folder!
~sounds = ~loadFolder.("/Volumes/DATA/Music/SND/grm/2.material/changing");

~sounds[1].play



// TGrains, granulate the buffer (normal playback with phasor)
(
    {
	    TGrains.ar(2,Impulse.kr(50), b.bufnum, 1,
		LFSaw.kr(BufDur.kr(b.bufnum).reciprocal,1,0.5,0.5)
		* BufDur.kr(b.bufnum),
		0.1, 0, 0.3, 1);
    }.play
)




// TGrains, layers with slightly different start positions and durations
(
	{
		var trate = 100, amp = 0.2, stretch = 10;
		var trigger = Impulse.kr(trate);
	     Mix.fill(5,{
			TGrains.ar(2,trigger, b.bufnum, 1,
			Line.kr(0.3.rand,BufDur.kr(b.bufnum) + 0.3.rand,
			BufDur.kr(b.bufnum) * stretch, doneAction: 2)
			+ TRand.kr(0,0.01,trigger),
			0.1,TRand.kr(-1,1,trigger),amp,1);
	})
	}.play
)




// TGrains, navigate buffer with a sine wave
(
	{
		var trate = 50, amp = 0.3, reader;
		reader = SinOsc.ar(MouseX.kr(0.01, 4), 0, 0.5, 0.5);
		TGrains.ar(2,Impulse.kr(trate), b.bufnum, 1,reader
		* BufDur.kr(b.bufnum),0.1,0,amp,1);
	}.play
)




// TGrains, trigger with dust
(
	{
		var trate = 50, amp = 0.3, trigger;
		trigger = Dust.kr(trate);
		TGrains.ar(2,trigger, b.bufnum, 1,TRand.kr(0,1,trigger)
		* BufDur.kr(b.bufnum),0.1,TRand.kr(-1,1,trigger),amp,1);
	}.play
)




// TGrains, layers of triggering with Dust
(
	{
		var trigger = Impulse.kr(100);
	     Mix.fill(5,{
			TGrains.ar(2,Impulse.kr(TRand.kr(10, 100, trigger)),
			b.bufnum, 1,TRand.kr(0,1,trigger)
			* BufDur.kr(b.bufnum),0.1,TRand.kr(-1,1,trigger), 0.2, 1);
		})
	}.play
)

Buffer.freeAll
