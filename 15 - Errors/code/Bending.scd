////////////////////////////////////////////////////////////////
//
//                         Bending
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

( // Run this to load the buffer

~buf = Buffer.read(s, (PathName(thisProcess.nowExecutingPath)).pathOnly ++ "/samples/mahler.wav");

)


////////////////////////// Iterative Loss ///////////////////////////

/*

****** Process audio → write to file → reprocess → repeat ... ******

*/

~folder = (PathName(thisProcess.nowExecutingPath)).pathOnly ++ "/samples/iterations";



// - Approach 1: Real-time iterative processing -

(

// The Sound
x = {

	var freq=10, fmod=200, ffrom=20, fto=400, index=7.8, amp=0.125;
	var mod = Lag.ar(LFDClipNoise.ar(fmod).range(ffrom,fto), [0.01,0.001]);
	PMOsc.ar(freq, mod, index, 0) * amp

}.play;

// Record It
s.record(~folder +/+ "gen_0.wav");

)

s.stopRecording; x.free; // Stop recording and sound


( // Function to process and rerecord

~iterativeProcess = { |inFile, outFile, numIterations = 10|

	fork {
		var currentFile = inFile;

		numIterations.do { |i|
			var nextFile = outFile ++ "gen_" ++ (i+1) ++ ".wav";
			var buf, synth;

			("Processing generation " ++ (i+1) ++ "...").postln;
			("  Reading: " ++ currentFile).postln;
			("  Writing: " ++ nextFile).postln;

			// Load current generation
			buf = Buffer.read(s, currentFile);
			s.sync;
			("  Buffer loaded, duration: " ++ buf.duration ++ " seconds").postln;

			// Start recording
			s.record(nextFile);
			0.1.wait;

			// Process and play
			synth = {
				var sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop: 0, doneAction: 2);

				// Apply degradation
				sig = FreeVerb.ar(sig, 0.8, 0.9, 0.5);  // reverb
				sig = sig.round(rrand(0.05,0,01)); // bit reduction
				sig = Latch.ar(sig, Impulse.ar(rrand(6000,10000)));  // sample rate reduction
				sig = Normalizer.ar(sig, 0.9);
				sig ! 2;
			}.play;

			// Wait for buffer to finish playing
			(buf.duration + 0.1).wait;

			// Stop recording
			s.stopRecording;
			("Recording stopped").postln;

			0.1.wait;

			// Clean up
			buf.free;

			// Update to next file for next iteration
			currentFile = nextFile;

			(" Generation " ++ (i+1) ++ " complete!").postln;
		};

		("Done. Processed " ++ numIterations ++ " generations.").postln;
	};
};

)

( // Repeat the function five times

~iterativeProcess.value(
	~folder +/+ "gen_0.wav",
	~folder,
	5
);

)



// - Approach 2: Non-Real-Time (NRT) batch processing -


(

~nrtIterativeProcess = { |sourceFile, numGenerations = 10|
	var basePath = PathName(sourceFile).pathOnly +/+ "nrt_gen";

	fork {

		 // Sound processor
		SynthDef(\degrader, {
			var sig = PlayBuf.ar(1, \buf.ir(0), BufRateScale.kr(\buf.ir(0)), loop: 0, doneAction: 2);
			sig = FreeVerb.ar(sig, 0.7, 0.9, 0.5);
			sig = sig.round(0.2);
			sig = sig.fold2(SinOsc.ar(Rand(1,100)));
			Out.ar(0, sig ! 2);
		}).load(s);

		s.sync;

		numGenerations.do { |gen|
			var inputFile = if(gen == 0, {sourceFile}, {basePath ++ "_" ++ (gen-1) ++ ".wav"});
			var outputFile = basePath ++ "_" ++ gen ++ ".wav";
			var oscFile = PathName.tmp +/+ "score_" ++ gen ++ ".osc";
			var buf, duration, score;
			var condition = Condition.new;
			var startTime;

			("NRT Generation " ++ gen ++ " starting...").postln;
			("  Input: " ++ inputFile).postln;
			("  Output: " ++ outputFile).postln;

			buf = Buffer.read(s, inputFile);
			s.sync;

			duration = buf.duration + 1.0;  // Tail
			buf.free;

			// Create score
			score = Score([
				[0.0, [\b_allocRead, 0, inputFile]],
				[0.0, [\s_new, \degrader, 1000, 0, 0, \buf, 0]],
				[duration, [\c_set, 0, 0]]  // End after duration
			]);

			startTime = Main.elapsedTime;

			// Render (positional arguments, not keyword arguments)
			score.recordNRT(
				oscFile,           // oscFilePath
				outputFile,        // outputFilePath
				nil,               // inputFilePath
				44100,             // sampleRate
				"wav",             // headerFormat
				"int16",           // sampleFormat
				ServerOptions.new.numOutputBusChannels_(2),  // options
				"",                // completionString
				duration,          // duration
				{                  // action - called when render completes
					var renderTime = (Main.elapsedTime - startTime).round(0.01);
					(" Did: " ++ gen ++ " in " ++ renderTime ++ " : " ++ duration.round(0.1)).postln;
					File.delete(oscFile);  // Clean up OSC file
					condition.unhang;  // Signal completion
				}
			);

			condition.hang;
		};

		("Processed: " ++ numGenerations ++ " generations.").postln;
	};
};

)

( // Run it

~nrtIterativeProcess.value( ~folder +/+ "gen_0.wav", 10)

)


//////////////////// Direct Buffer Manipulation ////////////////////////

/*

Corruption A: load audio, manipulate specific parts, write back.

*/

(

~zeroRandomSections = { |buffer, numSections = 20|
	buffer.loadToFloatArray(action: { |array|
		var output = array.copy;
		var len = array.size;
		var newBuf;
		var totalZeroed = 0;

		("Original length: " ++ len ++ " samples").postln;

		numSections.do { |i|
			var start = len.rand;
			var duration = rrand(2000, 22000);
			var end = min(start + duration, len);

			// Zero out this section
			(start..end-1).do { |idx|
				output[idx] = 0;
			};

			totalZeroed = totalZeroed + (end - start);
			("  S:" + (i+1) ++ ": zeroed " ++ (end - start) ++ " samples at: " ++ start).postln;
		};

		("Total : " ++ totalZeroed ++ " samples (" ++ (totalZeroed / 44100).round(0.01) ++ " seconds)").postln;
		("Percentage corrupted: " ++ ((totalZeroed / len * 100).round(0.1)) ++ "%").postln;

		// Write back to a new buffer
		newBuf = Buffer.loadCollection(s, output, buffer.numChannels);
		s.sync;

		// Save to disk
		newBuf.write(~folder +/+ "zeroed.wav", "wav", "int16");

		("Corrupted buffer created: " ++ (~folder +/+ "zeroed.wav")).postln;
		newBuf;
	});
};

)


(
	~zeroRandomSections.value(~buf, 100);
)

/*

Corruption B: Random value corruption (bit-flip style)

*/

(

~randomValueCorruption = { |buffer, numSections = 15|
	buffer.loadToFloatArray(action: { |array|
		var output = array.copy;
		var len = array.size;
		var newBuf;

		("Corrupting with random values...").postln;

		numSections.do {|i|
			var start = len.rand;
			var duration = rrand(5000, 30000);
			var end = min(start + duration, len);

			// Replace with random noise
			(start..end-1).do { |idx|
				output[idx] = rrand(-1.0, 1.0);
			};

			("  S: " ++ (i+1) ++ ": randomized " ++ (end - start) ++ " samples").postln;
		};

		newBuf = Buffer.loadCollection(s, output, buffer.numChannels);
		s.sync;

		newBuf.write(~folder +/+ "random_corrupted.wav", "wav", "int16");
		("Random corruption done: " ++ (~folder +/+ "random_corrupted.wav")).postln;
		newBuf;
	});
};

)


(
	~randomValueCorruption.value(~buf, 10);
)

