////////////////////////////////////////////////////////////////
//
//                      CWA21 - Routines
//
////////////////////////////////////////////////////////////////


////////////////////////// Load ///////////////////////////

(
	s = Server.local;
	s.waitForBoot({

	    ~rootPath = (PathName(thisProcess.nowExecutingPath)).pathOnly;

	    this.compileFile(~rootPath ++ "instruments/Synths.scd").value;
		this.compileFile(~rootPath ++ "sequences/SampleSeqs.scd").value;

	    ~buffersPath = Array.new(2);
	    ~buffersPath.add(~rootPath ++ "sounds/abstract/*");
	    ~buffersPath.add(~rootPath ++ "sounds/concrete/*");
		~buffersPath.add(~rootPath ++ "output/*");

	    ~files = Array.new(2);
		~buffers = Array.new(2);

	    2.do {|index|
		~files.add(SoundFile.collect(~buffersPath[index]));
		~buffers.add(~files[index].collect { |sf| var buf;
		buf = Buffer.read(Server.local, sf.path) }) };

	    "Done loading".postln;
    });
)




///////////////////////////  Section 1  /////////////////////////////

(

~section1 = {|clock|

	Routine({
		"~section1 - 1".postln;
		~sampleSeqs.a(\uSimpler, ~buffers[0][1], 70, 0.8).play(clock);
		10.wait;
		~sampleSeqs.b(\uSimpler, ~buffers[0][0], 30, 0.8).play(clock);
		5.wait;

	}).play
};

)





///////////////////////////  Section 2  /////////////////////////////

(

~section1 = {|clock|

	Routine({
		"~section1 - 1".postln;
		~sampleSeqs.c(\uSimpler, ~buffers[1][0], 30, 0.8).play(clock);
		10.wait;
		~sampleSeqs.d(\uSimpler, ~buffers[1][1], 30, 0.8).play(clock);
		5.wait;

	}).play
};

)




///////////////////////////  Execution  /////////////////////////////

(

var clocka = TempoClock((90) / 60);

Routine({

	~section1.value(clocka);
	"~section1".postln;
	10.wait;
	"~section2".postln;
	~section2.value(clocka);

}).play

)
