////////////////////////////////////////////////////////////////
//
//                             CDP
//
////////////////////////////////////////////////////////////////

CDP, Trevor Wishart and Sound Transformation. In the following
examples SuperCollider is mostly used to generate strings with
commands to run in the terminal. The CDP programs are external
and therefor we do not need to load buffers etc. but only give
references to them. The last examples load CDP processed sounds
for simple playback.


(   //   Init buffers and program runner  //

    ~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
    ~brown = ~path ++ "source/brown.wav";
    ~drone = ~path ++ "source/drone.wav";
	~grains = ~path ++ "source/grains.wav";
    ~vocal = ~path ++ "source/vocal.wav";
    ~speach = ~path ++ "source/speach.wav";
    ~generationsPath = ~path++"output/generations/";
    q = "\"";

    ~runner = {|program, input, output, params|
	    var command;
	    command = program+q++input++q+q++output++q+params;
	    command.postln;
	    (command).runInTerminal;
    }
)




/*

The examples below are processes Trevor Wishart used in his pieces we
discussed during class.

*/

//////////////////////// Tongues of Fire ////////////////////////

(

/* Shred, The soundfile is (randomly) segmented, and these segments
   reordered by means of a permutation process. */

var output=~path++"output/fire/shredbx.wav";
var repeats="16", chunklen="0.15";
~runner.value("modify radical 2", ~vocal, output, repeats + chunklen);

)




(

/* Inbetween,Generate a set of sounds in-between the 2 input sounds by
interpolation pegged to zero-crossings */

var input = ~vocal ++ q + q ++ ~grains, count="4", cutoff="500";
var output=~path++"output/fire/inbetween";
~runner.value("submix inbetween2", input, output, count + cutoff);

)




(

/* Replace – The strongest 'wavecycle' in a cyclecnt group replaces the
others. Simplifies the sound. Can lead to sample-and-hold like results. */

var cyclecnt="4", output=~path++"output/fire/replace";
~runner.value("distort replace", ~vocal, output, cyclecnt);

)




(

/* Reform – This process reads each 'wavecycle' and replaces it with a
different waveform of the same length.  */

var output=~path++"output/fire/reform";
~runner.value("distort reform 7", ~grains, output, "");

)


/* Trace, Highlight n loudest partials, at each moment (window) in time */

( // Analyse
var winSize = "-c4096", output=~path++"output/fire/trace-input.ana";
~runner.value("pvoc anal 1", ~vocal, output, winSize);
)

( // Trace
var retain="12", input=~path++"output/fire/trace-input.ana";
var output=~path++"output/fire/trace.ana";
~runner.value("hilite trace 1", input, output, retain);
)

( // Re-synthesize
var input=~path++"output/fire/trace.ana", output=~path++"output/fire/trace.wav";
~runner.value("pvoc synth", input, output, "");
)




//////////////////////// American Tryptic ////////////////////////

/* Stretch Time, stretch/compress duration of infile
without changing the pitch */

( // Analyse
var winSize = "-c1024", output=~path++"/output/tryptic/stretch-input.ana";
~runner.value("pvoc anal 1", ~speach, output, winSize);
)

( // Stretch
var stretch= q ++ ~path++"output/tryptic/stretch.brk" ++ q;
var input=~path++"output/tryptic/stretch-input.ana";
var output=~path++"output/tryptic/stretch.ana";
~runner.value("stretch time 1", input, output, stretch);
)

( // Re-synthesize
var input=~path++"output/tryptic/stretch.ana";
var output=~path++"output/tryptic/stretch.wav";
~runner.value("pvoc synth", input, output, "");
)


(

var input=~grains, output=~path++"output/imago/ceracu.wav";
~runner.value("ceracu ceracu", input, output, "\""++~path++"output/imago/cyclecounts.txt"++"\"" + "0.5 4 10 0 0");

)

//////////////////////// Imago ////////////////////////

(

/* Fugu (back-to-back) Join a time-reversed copy of the
sound to a normal copy. */

var input=~grains, output=~path++"output/imago/fugu.wav";
var jointime="3", splicelength="400";
~runner.value("extend baktobak", input, output, jointime + splicelength);

)




/* Blur,  time-averages the spectrum. It 'blurs' detail
in the time dimension by interpolating between the spectral
envelope values of the start and end windows blurring windows.  */

( // Analyse
var winSize = "-c8192", output=~path++"output/imago/blur-input.ana";
~runner.value("pvoc anal 1", ~brown, output, winSize);
)

( // Blur
var stretch="4", input=~path++"output/imago/blur-input.ana";
var output=~path++"output/imago/blur.ana";
var blurring = "123";
~runner.value("blur blur", input, output, blurring);
)

(// Re-synthesize
var input=~path++"output/imago/blur.ana";
var output=~path++"output/imago/blur.wav";
~runner.value("pvoc synth", input, output, "");
)



(

/* Stack, mix stacked transposed versions of source on top of one
another. Lines the transposition up in such a way that the attacks
of each layer are synced.  */

var input=~vocal, output=~path++"output/imago/stack.wav";
var pitch="5", count="12", lean="0.8", attack="0.8", gain="4", dur="1";
var params = pitch + count + lean + attack + gain + dur;
~runner.value("modify stack", ~vocal, output, params);

)




/*

Below are more CDP processes, Wavecycles, Extend and Spectral.

*/

////////////////////////// Wavecycles ///////////////////////////

( // Omit A out of every B 'wavecycles', replacing with silence

var output=~path++"output/cycles/omit.wav", omit="10", group="12";
~runner.value("distort omit", ~grains, output, omit + group);

)




( // Divide, Distortion by dividing 'wavecycle' frequency

var output=~path++"output/cycles/divide.wav", divider="4";
~runner.value("distort divide", ~vocal, output, divider);

)




( // Multiply, Distortion by multiplying 'wavecycle' frequency

var output=~path++"output/cycles/multiply.wav", multiplier="8";
~runner.value("distort multiply", ~vocal, output, multiplier);

)




( // Fractal, Superimpose 'wavecycles' onto themselves

var output=~path++"output/cycles/fractal.wav", scaling="800", gain="0.6";
~runner.value("distort fractal", ~speach, output, scaling + gain);

)




( // Telescope, Time-contract by telescoping N wavecycles into 1

var output=~path++"output/cycles/telescope.wav", group="8";
~runner.value("distort telescope", ~speach, output, group);

)




( // Delete, Time-contract by telescoping N wavecycles into 1

var output=~path++"output/cycles/delete.wav", delete="16";
~runner.value("distort delete 2", ~grains, output, delete);

)




( // Repeat, Time-expand by repeating N wavecycles

var output=~path++"output/cycles/repeat.wav", repeat=8, group=120;
~runner.value("distort repeat", ~grains, output, repeat + "-c" ++ group);

)




( // Envel, Time-expand by repeating N wavecycles

var output=~path++"output/cycles/envel.wav", group=300, troughing=0.2;
~runner.value("distort envel 2", ~brown, output, group + troughing);

)




////////////////////////// Extend ///////////////////////////

( // Loop, repeat advancing segments inside soundfile

var output=~path++"output/extend/loop.wav", dur="10.5", start="1.0";
var len="65", lstep="-l18.18", wsplen="-w28.0", sscat="-s0.80";
var params= dur + start + len + lstep + wsplen + sscat;
~runner.value("extend loop 2 ", ~vocal, output, params);

)




( // Doublets, divide a sound into segments that repeat

var output=~path++"output/extend/doublets.wav";
var segdur="0.1", repets="4";
var params=segdur + repets;
~runner.value("extend doublets ", ~grains, output, params);

)




( // Drunk, drunken walk through source file

var output=~path++"output/extend/drunk.wav";
var dur="10.5", locus="0.9", amb="2.1", step="0.02", clock="0.1";
var ssplicelen="-s22", cclokrand="-c0.020", overlap="-o0.09";
var params = dur + locus + amb + step + clock + ssplicelen + cclokrand + overlap;
~runner.value("extend drunk 1 ", ~grains, output, params);

)




( // Scramble soundfile and write to any given length

var output=~path++"output/extend/scramble.wav";
var minSeg="0.04", maxSeg="0.08", dur="10.5";
var params= minSeg + maxSeg + dur;
~runner.value("extend scramble 1 ", ~grains, output, params);

)




////////////////////////// Spectral ///////////////////////////


/* Spectral Morph, morph one spectrum into another */

( // Analyse
var winSize = "-c1024";
var outputa=~path++"/output/spectral/morph-inputa.ana";
var outputb=~path++"/output/spectral/morph-inputb.ana";
~runner.value("pvoc anal 1", ~drone, outputa, winSize);
~runner.value("pvoc anal 1", ~brown, outputb, winSize);
)

( // Morph
var output=~path++"/output/spectral/morph.ana";
var inputa=~path++"/output/spectral/morph-inputa.ana";
var inputb=~path++"/output/spectral/morph-inputb.ana";
var input=inputa ++ q + q ++ inputb;
var as="1", ae="9", fs="2", fe="7", expa="2", expf="1";
var params = as + ae + fs + fe + expa + expf;
~runner.value("morph morph 1", input, output, params);
)

( // Re-synthesize
var input=~path++"output/spectral/morph.ana";
var output=~path++"output/spectral/morph.wav";
~runner.value("pvoc synth", input, output, "");
)




/* Spectral Vocode, vocode one spectrum with another */

( // Analyse
var winSize = "-c1024";
var outputa=~path++"/output/spectral/vocode-inputa.ana";
var outputb=~path++"/output/spectral/vocode-inputb.ana";
~runner.value("pvoc anal 1", ~brown, outputa, winSize);
~runner.value("pvoc anal 1", ~vocal, outputb, winSize);
)

( // Vocode
var output=~path++"/output/spectral/vocode.ana";
var inputa=~path++"/output/spectral/vocode-inputa.ana";
var inputb=~path++"/output/spectral/vocode-inputb.ana";
var input=inputa ++ q + q ++ inputb;
var lopass="-l6", group="-f20";
~runner.value("formants vocode", input, output, group + lopass);
)

( // Re-synthesize
var input=~path++"output/spectral/vocode.ana";
var output=~path++"output/spectral/vocode.wav";
~runner.value("pvoc synth", input, output, "");
)




/*

We now attempt to create generations of transformed sound and
compose through navigating these using SuperCollider samplers.

*/



// First we transform our four sources using four different processes

(

var inputPath = ~path ++ "source/";
var outputPath = ~generationsPath ++ "initial/";
var firstGeneration = SoundFile.collect(inputPath ++ "*");

firstGeneration.do{|src|
	var pathName = PathName(src.path);
	var fileName = pathName.fileNameWithoutExtension.postln;
	var input = inputPath ++ fileName ++ ".wav";
	var outputScred = outputPath ++ fileName ++ "_scred.wav";
	var outputZigZag = outputPath ++ fileName ++ "_zigzag.wav";
	var outputShuffle = outputPath ++ fileName ++ "_shuffle.wav";
	var outputReverse = outputPath ++ fileName ++ "_shrink.wav";
	var shredRep = rrand(2,6), shredLength = rrand(0.2,0.4);
	var zigStart = rrand(0.0, 2.0), zigEnd = rrand(2.5, 4.0);
	var zigDur = 15, zigMin = rrand(0.05, 0.3);
	var zigParams = zigStart + "" + zigEnd + "" + zigDur + "" + zigMin;
	var shuffleDomainImage = " abcd-aacccbdd", shuffleGroup=rrand(10, 100);
	var shuffleParams = shuffleDomainImage + "" + "-c" ++ shuffleGroup;
	var reverseGroup = rrand(1, 150);

	~runner.value("modify radical 2", input, outputScred, shredRep + "" + shredLength);
	~runner.value("extend zigzag 1", input, outputZigZag, zigParams);
	~runner.value("distort shuffle", input, outputShuffle, shuffleParams);
	~runner.value("distort reverse", input, outputReverse, reverseGroup);
}

)




// Now we read the processed files and process those with a different
// set of processes.

(

var inputPath = ~generationsPath ++ "initial/";
var outputPath = ~generationsPath ++ "second/";
var secondGeneration = SoundFile.collect(inputPath ++ "*");

secondGeneration.do {|file|
	var pathName = PathName(file.path);
	var fileName = pathName.fileNameWithoutExtension.postln;
	var input = inputPath ++ fileName ++ ".wav";
	var outputPitchwrap = outputPath ++ fileName ++ "_pitchwrap.wav";
	var outputRingMod = outputPath ++ fileName ++ "_ringmod.wav";
	var outputRepeat = outputPath ++ fileName ++ "_repeat.wav";
	var outputVibrato = outputPath ++ fileName ++ "_vibrato.wav";
	var octvary = rrand(0.0, 4.0);
	var ringModFreq = rrand(20, 1000);
	var repeatGroup = rrand(2, 10);
	var vibrate = rrand(10, 60), vibdepth = rrand(1, 60);

	~runner.value("distort pitch", input, outputPitchwrap, octvary);
	~runner.value("modify radical 5", input, outputRingMod, ringModFreq);
	~runner.value("distort repeat2", input, outputRepeat, repeatGroup);
	~runner.value("modify speed 6", input, outputVibrato, vibrate + "" + vibdepth);
};

)




// And finally we repeat the process for the third generation.

(

var inputPath =~generationsPath ++ "second/";
var outputPath = ~generationsPath ++ "third/";
var thirdGeneration = SoundFile.collect(inputPath ++ "*");

thirdGeneration.do {|file|
	var pathName = PathName(file.path);
	var fileName = pathName.fileNameWithoutExtension.postln;
	var input = inputPath ++ fileName ++ ".wav";
	var outputOct = outputPath ++ fileName++ "_octdown.wav";
	var outputFilterBank = outputPath ++ fileName++ "_filterbank.wav";
	var outputDelay = outputPath ++ fileName++ "_delay.wav";
	var outputBrassage = outputPath ++ fileName++ "_brassage.wav";
	var delTime = rrand(10, 100), delMix=rrand(0.4,0.8);
	var delTail = rrand(1,4), delFeedback = rrand(0.5, 0.9);
	var delParams = delTime + "" + delMix + "" + delFeedback + "" + delTail;
	var ftightness = rrand(500,3000), fgain=rrand(80,100);
	var flo = rrand(10, 100), fhi = rrand(800,1200);
	var filterParams = ftightness + "" + fgain + "" + flo + "" + fhi;

	~runner.value("modify speed 2", input, outputOct, " -24");
	~runner.value("filter bank 1", input, outputFilterBank, filterParams);
	~runner.value("modify revecho 1", input, outputDelay, delParams);
	~runner.value("modify brassage 4", input, outputBrassage, rrand(100,200));
};

)



// Create a Sampler for buffer playback

(

SynthDef(\sampler, {
	|out=0,pan=0,amp=1.5,buf=0,pos=0.0,angle=1.0,dur=1.0|
	var sig, start, env;
	env = EnvGen.ar(Env.linen(angle, dur, angle), doneAction:2);
	start = BufFrames.kr(buf) * pos;
	sig = PlayBuf.ar(1, buf, 1, 1, start);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

)


// Load the buffers from the folders

(

var loadBuffers = {|path|
    var files = SoundFile.collect(path);
    files.collect { |sf| var buf;
	buf = Buffer.read(Server.local, sf.path)}};

~initial = loadBuffers.value(~generationsPath ++ "initial/*");
~second = loadBuffers.value(~generationsPath ++ "second/*");
~third = loadBuffers.value(~generationsPath ++ "third/*");

)


// Compose something with these sounds.

(

var createPattern = {|list, dur|
	Pfindur(dur,
	Pbind(
	\instrument, \sampler,
	\buf, Prand(~initial, inf),
	\angle, Pwhite(12.0, 14.0),
	\amp, Prand([0.7, 1.2, 0.01, 0.1], inf),
	\dur, Prand([5.6, 3.8, 8], inf),
	\monitor, Pfunc{|ev| ev.postln}));
};

~sections.initial = createPattern.value(~initial, rrand(20, 60));
~sections.second = createPattern.value(~second, rrand(20, 60));
~sections.third = createPattern.value(~third, rrand(20, 60));

Routine({
	10.do {
		~sections.initial.play;
		rrand(20, 60).wait;
		"Section 2".play;
		~sections.second.play;
		rrand(20, 60).wait;
		"Section 3".play;
		~sections.third.play;
		rrand(20, 60).wait;
	}
}).play;

)

