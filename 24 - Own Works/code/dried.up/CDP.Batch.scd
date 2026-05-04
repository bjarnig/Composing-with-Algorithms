////////////////////////////////////////////////////////////////
//
//                      CDP - Batch
//
////////////////////////////////////////////////////////////////

CDP, Trevor Wishart and Sound Transformation. In the following
examples SuperCollider is mostly used to generate strings with
commands to run in the terminal. The CDP programs are external
and therefor we do not need to load buffers etc. but only give
references to them. The last examples load CDP processed sounds
for simple playback.

( //   Init buffers and program runner  //

	~path = "/Volumes/DATA/Courses/Work/Presentations/Perugia/01 - dried.up/";
    ~generationsPath = ~path++"output/generations/";

    q = "\"";

    ~runner = {|program, input, output, params|
	    var command;
	    command = program+q++input++q+q++output++q+params;
	    command.postln;
	    (command).runInTerminal;
    }
)


// First we transform our four sources using four different processes

(

var inputPath = ~path ++ "input/";
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
