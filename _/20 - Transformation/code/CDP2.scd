////////////////////////////////////////////////////////////////
//
//                      CDP (continued)
//
////////////////////////////////////////////////////////////////

In the following examples SuperCollider is mostly used to generate
strings with commands to run in the terminal.


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



( // Granular timestretch

var output=~path++"output/grainverb.wav";
var parameters="4 0.2 1";
~runner.value("modify brassage 3", ~aa, output, parameters);

)


( // Distort overload (Clip the signal with noise or a (possibly timevarying) waveform)

var output=~path++"output/overloadf.wav";
var clip_level="0.1";
var depth="0.85";
var freq = "1223.26";
~runner.value("distort overload 2", ~aa, output, clip_level + depth + freq);

)



( // Distort average (Average the waveshape over N 'wavecycles')

var output=~path++"output/averagec.wav";
var cyclecnt= ~path + "output/count.txt";
~runner.value("distort average", ~aa, output, cyclecnt);

)



( // Distort replim (Timestretch by repeating 'wavecycles' (below a specified frequency))

var output=~path++"output/replim.wav";
var multiplier="8";
var ccyclecnt = "-c30";
var freqbelow = "-f2000";
~runner.value("distort replim", ~cb, output, multiplier + ccyclecnt + freqbelow);

)



( // Distort interpolate (Time-stretch file by repeating 'wavecycles' and interpolating between them)

var output=~path++"output/interpolate.wav";
var factor="8";
~runner.value("distort replim", ~aa, output, factor);

)



( // Degrade a sound (Sound is converted to a lower sample rate or bit-resolution)

var output=~path++"output/degrade.wav";
var bits="4";
var srate_division="8";
~runner.value("modify radical 4", ~ab, output, bits + srate_division);

)



( // Feedback delay (with feedback & mix (0 = dry) of original and delayed signal)

var output=~path++"output/delay.wav";
var delay = "1.49";
var mix = "0.5";
var feedback = "0.8";
var tail = "2.8";
~runner.value("modify revecho 1", ~cb, output, delay + mix + feedback + tail);

)


////////////////////////// Wavecycles ///////////////////////////

( // Omit A out of every B 'wavecycles', replacing with silence

var output=~path++"output/cycles/omit.wav", omit="10", group="12";
~runner.value("distort omit", ~aa, output, omit + group);

)

( // Divide, Distortion by dividing 'wavecycle' frequency

var output=~path++"output/cycles/divide.wav", divider="4";
~runner.value("distort divide", ~ca, output, divider);

)

( // Multiply, Distortion by multiplying 'wavecycle' frequency

var output=~path++"output/cycles/multiply.wav", multiplier="8";
~runner.value("distort multiply", ~ca, output, multiplier);

)

( // Fractal, Superimpose 'wavecycles' onto themselves

var output=~path++"output/cycles/fractal.wav", scaling="800", gain="0.6";
~runner.value("distort fractal", ~ab, output, scaling + gain);

)

( // Telescope, Time-contract by telescoping N wavecycles into 1

var output=~path++"output/cycles/telescope.wav", group="8";
~runner.value("distort telescope", ~ab, output, group);

)

( // Delete, Time-contract by telescoping N wavecycles into 1

var output=~path++"output/cycles/delete.wav", delete="16";
~runner.value("distort delete 2", ~aa, output, delete);

)

( // Repeat, Time-expand by repeating N wavecycles

var output=~path++"output/cycles/repeat.wav", repeat=8, group=120;
~runner.value("distort repeat", ~aa, output, repeat + "-c" ++ group);

)

( // Envel, Time-expand by repeating N wavecycles

var output=~path++"output/cycles/envel.wav", group=300, troughing=0.2;
~runner.value("distort envel 2", ~cb, output, group + troughing);

)


////////////////////////// Extend ///////////////////////////

( // Loop, repeat advancing segments inside soundfile

var output=~path++"output/extend/loop.wav", dur="10.5", start="1.0";
var len="65", lstep="-l18.18", wsplen="-w28.0", sscat="-s0.80";
var params= dur + start + len + lstep + wsplen + sscat;
~runner.value("extend loop 2 ", ~ca, output, params);

)


( // Doublets, divide a sound into segments that repeat

var output=~path++"output/extend/doublets.wav";
var segdur="0.1", repets="4";
var params=segdur + repets;
~runner.value("extend doublets ", ~aa, output, params);

)


( // Drunk, drunken walk through source file

var output=~path++"output/extend/drunk.wav";
var dur="10.5", locus="0.9", amb="2.1", step="0.02", clock="0.1";
var ssplicelen="-s22", cclokrand="-c0.020", overlap="-o0.09";
var params = dur + locus + amb + step + clock + ssplicelen + cclokrand + overlap;
~runner.value("extend drunk 1 ", ~aa, output, params);

)


( // Scramble soundfile and write to any given length

var output=~path++"output/extend/scramble.wav";
var minSeg="0.04", maxSeg="0.08", dur="10.5";
var params= minSeg + maxSeg + dur;
~runner.value("extend scramble 1 ", ~aa, output, params);

)


////////////////////////// Spectral ///////////////////////////

/* Spectral Morph, morph one spectrum into another */

( // Analyse
var winSize = "-c1024";
var outputa=~path++"/output/spectral/morph-inputa.ana";
var outputb=~path++"/output/spectral/morph-inputb.ana";
~runner.value("pvoc anal 1", ~ca, outputa, winSize);
~runner.value("pvoc anal 1", ~cb, outputb, winSize);
)

( // Morph
var output=~path++"/output/spectral/morph.ana";
var inputa=~path++"/output/spectral/morph-inputa.ana";
var inputb=~path++"/output/spectral/morph-inputb.ana";
var input=inputa ++ q + q ++ inputb;
var as="1", ae="7", fs="2", fe="5", expa="2", expf="1";
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
var outputa=~path++"output/spectral/vocode-inputa.ana";
var outputb=~path++"output/spectral/vocode-inputb.ana";
~runner.value("pvoc anal 1", ~cb, outputa, winSize);
~runner.value("pvoc anal 1", ~ca, outputb, winSize);
)

( // Vocode
var output=~path++"output/spectral/vocode.ana";
var inputa=~path++"output/spectral/vocode-inputa.ana";
var inputb=~path++"output/spectral/vocode-inputb.ana";
var input=inputa ++ q + q ++ inputb;
var lopass="-l6", group="-f20";
~runner.value("formants vocode", input, output, group + lopass);
)

( // Re-synthesize
var input=~path++"output/spectral/vocode.ana";
var output=~path++"output/spectral/vocode.wav";
~runner.value("pvoc synth", input, output, "");
)

