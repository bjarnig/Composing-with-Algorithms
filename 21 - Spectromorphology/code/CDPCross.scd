////////////////////////////////////////////////////////////////
//
//                        CDP, Cross
//
////////////////////////////////////////////////////////////////

Cross Synthesis with CDP.


( //   Init buffers and program runner  //

    ~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;

    ~aa = ~path ++ "sounds/abstract/aa.wav";
    ~ab = ~path ++ "sounds/abstract/ab.wav";
	~ca = ~path ++ "sounds/concrete/ca.wav";
    ~cb = ~path ++ "sounds/concrete/cb.wav";

    q = "\"";

    ~runner = {|program, input, output, params|
	    var command;
	    command = program+q++input++q+q++output++q+params;
	    command.postln;
	    (command).runInTerminal;
    }
)


//////////////////////// Cross Synthesis ////////////////////////


/* Cross, replace spectral amplitudes of 1st file with those of 2nd */

( // Analyse
var winSize = "-c1024";
var outputa=~path++"output/cross/cross-inputa.ana";
var outputb=~path++"output/cross/cross-inputb.ana";
~runner.value("pvoc anal 1", ~ca, outputa, winSize);
~runner.value("pvoc anal 1", ~cb, outputb, winSize);
)

( // Cross
var output=~path++"output/cross/cross.ana";
var inputa=~path++"output/cross/cross-inputa.ana";
var inputb=~path++"output/cross/cross-inputb.ana";
var input=inputa ++ q + q ++ inputb;
~runner.value("combine cross", input, output, "");
)

( // Re-synthesize
var input=~path++"output/cross/cross.ana";
var output=~path++"output/cross/cross.wav";
~runner.value("pvoc synth", input, output, "");
)




/* Diff, find difference of two spectra */

( // Analyse
var winSize = "-c1024";
var outputa=~path++"output/cross/diff-inputa.ana";
var outputb=~path++"output/cross/diff-inputb.ana";
~runner.value("pvoc anal 1", ~cb, outputa, winSize);
~runner.value("pvoc anal 1", ~ab, outputb, winSize);
)

( // diff
var output=~path++"output/cross/diff.ana";
var inputa=~path++"output/cross/diff-inputa.ana";
var inputb=~path++"output/cross/diff-inputb.ana";
var input=inputa ++ q + q ++ inputb;
~runner.value("combine diff", input, output, "");
)

( // Re-synthesize
var input=~path++"output/cross/diff.ana";
var output=~path++"output/cross/diff.wav";
~runner.value("pvoc synth", input, output, "");
)




/* Interleave, interleave windows from infiles, leafsize windows per leaf */

( // Analyse
var winSize = "-c1024";
var outputa=~path++"output/cross/interleave-inputa.ana";
var outputb=~path++"output/cross/interleave-inputb.ana";
~runner.value("pvoc anal 1", ~aa, outputa, winSize);
~runner.value("pvoc anal 1", ~ca, outputb, winSize);
)

( // interleave
var output=~path++"output/cross/interleave.ana";
var inputa=~path++"output/cross/interleave-inputa.ana";
var inputb=~path++"output/cross/interleave-inputb.ana";
var input=inputa ++ q + q ++ inputb;
var leafsize = 8;
~runner.value("combine interleave", input, output, leafsize);
)

( // Re-synthesize
var input=~path++"output/cross/interleave.ana";
var output=~path++"output/cross/interleave.wav";
~runner.value("pvoc synth", input, output, "");
)




/* Formants, Impose spectral envelope in a formant file on spectrum in a PVOC analysis file */

( // Analyse
var winSize = "-c2048";
var outputa=~path++"output/cross/formants-inputa.ana";
var outputb=~path++"output/cross/formants-inputb.ana";
~runner.value("pvoc anal 1", ~ca, outputa, winSize);
~runner.value("pvoc anal 1", ~cb, outputb, winSize);
)

( // Extract formants
var winSize = "-c4096";
var inputa=~path++"output/cross/formants-inputa.ana";
var inputb=~path++"output/cross/formants-inputb.ana";
var outputa=~path++"output/cross/formants-inputa.for";
var outputb=~path++"output/cross/formants-inputb.for";
~runner.value("formants get", inputa, outputa, "-f12");
~runner.value("formants get", inputb, outputb, "-f12");
)

( // Impose formants
var output=~path++"output/cross/formants.ana";
var inputa=~path++"output/cross/formants-inputa.ana";
var inputb=~path++"output/cross/formants-inputb.for";
var input=inputa ++ q + q ++ inputb;
~runner.value("formants put 1",input, output, "");
)

( // Re-synthesize
var input=~path++"output/cross/formants.ana";
var output=~path++"output/cross/formants.wav";
~runner.value("pvoc synth", input, output, "");
)




/* Envel Impose, Impose an envelope on an input soundfile */

( // Impose envelope
var output=~path++"output/cross/envel.wav";
var inputa=~ca;
var inputb=~cb;
var input=inputa ++ q + q ++ inputb;
~runner.value("envel impose 1",input, output, "5");
)




/* Spectral Morph, morph one spectrum into another */

( // Analyse
var winSize = "-c1024";
var outputa=~path++"output/cross/morph-inputa.ana";
var outputb=~path++"output/cross/morph-inputb.ana";
~runner.value("pvoc anal 1", ~aa, outputa, winSize);
~runner.value("pvoc anal 1", ~ab, outputb, winSize);
)

( // Morph
var output=~path++"output/cross/morph.ana";
var inputa=~path++"output/cross/morph-inputa.ana";
var inputb=~path++"output/cross/morph-inputb.ana";
var input=inputa ++ q + q ++ inputb;
var as="1", ae="6", fs="2", fe="4", expa="2", expf="1";
var params = as + ae + fs + fe + expa + expf;
~runner.value("morph morph 1", input, output, params);
)

( // Re-synthesize
var input=~path++"output/cross/morph.ana";
var output=~path++"output/cross/morph.wav";
~runner.value("pvoc synth", input, output, "");
)




/* Spectral Vocode, vocode one spectrum with another */

( // Analyse
var winSize = "-c1024";
var outputa=~path++"output/cross/vocode-inputa.ana";
var outputb=~path++"output/cross/vocode-inputb.ana";
~runner.value("pvoc anal 1", ~ca, outputa, winSize);
~runner.value("pvoc anal 1", ~cb, outputb, winSize);
)

( // Vocode
var output=~path++"output/cross/vocode.ana";
var inputa=~path++"output/cross/vocode-inputa.ana";
var inputb=~path++"output/cross/vocode-inputb.ana";
var input=inputa ++ q + q ++ inputb;
var lopass="-l6", group="-f20";
~runner.value("formants vocode", input, output, group + lopass);
)

( // Re-synthesize
var input=~path++"output/cross/vocode.ana";
var output=~path++"output/cross/vocode.wav";
~runner.value("pvoc synth", input, output, "");
)

