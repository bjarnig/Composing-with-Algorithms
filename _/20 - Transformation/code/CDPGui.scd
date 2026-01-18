////////////////////////////////////////////////////////////////
//
//                       CDP3
//
////////////////////////////////////////////////////////////////

(

// Set the directory to your working directory or specify it per process
~directory =  thisProcess.nowExecutingPath.dirname ++ "/sounds/concrete/";
s.boot; // Boot the server for playback

)


Quarks.install("https://github.com/bjarnig/CDP.sc")

////////////////////// GUI - Wavecycles ////////////////////////


( // Delete, Time-contract by telescoping N wavecycles into 1

CDPGui( "distort delete 2", "Delete", ~directory, [ (name:"delete", prepend:"", spec: ControlSpec(4, 32, \linear, 1)) ] );

)


( // Repeat, Time-expand by repeating N wavecycles

CDPGui( "distort repeat", "Repeat", ~directory, [ (name:"repeat", prepend:"", spec: ControlSpec(4, 32, \linear, 1)), (name:"group", prepend:"-c", spec: ControlSpec(10, 250, \linear, 1)) ], );

)


( // Omit A out of every B 'wavecycles', replacing with silence

CDPGui( "distort omit", "Omit", ~directory, [ (name:"omit", prepend:"", spec: ControlSpec(4, 16, \linear, 1)), (name:"group", prepend:"", spec: ControlSpec(4, 16, \linear, 1)), ] );

)


( // Divide, Distortion by dividing 'wavecycle' frequency

CDPGui( "distort divide", "Divide", ~directory, [ (name:"divider", prepend:"", spec: ControlSpec(2, 16, \linear, 1)) ]);

)



( // Multiply, Distortion by multiplying 'wavecycle' frequency

CDPGui( "distort multiply", "Multiply", ~directory, [ (name:"multiplier", prepend:"", spec: ControlSpec(2, 16, \linear, 1)) ]);

)



( // Fractal, Superimpose 'wavecycles' onto themselves

CDPGui( "distort fractal", "Fractal", ~directory, [ (name:"scaling", prepend:"", spec: ControlSpec(200, 1000, \linear, 1)), (name:"gain", prepend:"", spec: ControlSpec(0.1, 1.0, \linear, 0.1)) ]);

)


( // Telescope, Time-contract by telescoping N wavecycles into 1

CDPGui( "distort telescope", "Telescope", ~directory, [ (name:"group", prepend:"", spec: ControlSpec(2, 100, \linear, 1)) ]);

)


( // Envel, Impose envelope on groups

CDPGui( "distort envel 2", "Envel", ~directory, [ (name:"group", prepend:"", spec: ControlSpec(2, 100, \linear, 1)), (name:"troughing", prepend:"-t", spec: ControlSpec(0.01, 1.0, \linear, 0.01)) ]);

)


( // Replace Cycles

CDPGui( "distort replace", "Replace", ~directory, [(name:"cyclecnt", prepend:"", spec: ControlSpec(4, 16, \linear, 1))]);

)


/////////////////////// GUI - Extend //////////////////////////

( // Doublets, divide a sound into segments that repeat

CDPGui( "extend doublets", "Doublets", ~directory, [ (name:"segdur", prepend:"", spec: ControlSpec(0.01, 2.0, \linear, 0.01)), (name:"repeats", prepend:"", spec: ControlSpec(2, 12.0, \linear, 1)) ]);

)

( // Scramble soundfile and write to any given length

CDPGui( "extend scramble 1", "Scramble", ~directory, [ (name:"minSeg", prepend:"", spec: ControlSpec(0.01, 1.0, \linear, 0.01)), (name:"maxSeg", prepend:"", spec: ControlSpec(0.01, 4.0, \linear, 0.01)), (name:"dur", prepend:"", spec: ControlSpec(1, 20, \linear, 0.1)) ]);

)

( // Shred, Sound is shredded, within its existing duration

CDPGui( "modify radical 2", "Shred", ~directory, [ (name:"repeats", prepend:"", spec: ControlSpec(4, 16, \linear, 1)), (name:"chunklen", prepend:"", spec: ControlSpec(0.1, 0.8, \linear, 0.1)) ]);

)

( // Loop, repeat advancing segments inside soundfile

CDPGui( "extend loop 2", "Loop", ~directory, [ (name:"dur", prepend:"", spec: ControlSpec(1, 50, \linear, 1)), (name:"start", prepend:"", spec: ControlSpec(0.0, 8.0, \linear, 0.01)), (name:"len", prepend:"", spec: ControlSpec(10, 300, \linear, 1)), (name:"lstep", prepend:"-l", spec: ControlSpec(1, 30, \linear, 1)), (name:"wsplen", prepend:"-w", spec: ControlSpec(2, 40, \linear, 1)), (name:"sscat", prepend:"-s", spec: ControlSpec(0.01, 1.0, \linear, 0.01)), ]);

)

( // Drunk, drunken walk through source file

CDPGui( "extend drunk 1", "Drunk", ~directory, [ (name:"dur", prepend:"", spec: ControlSpec(1, 20, \linear, 0.1)), (name:"locus", prepend:"", spec: ControlSpec(0.01, 1.0, \linear, 0.01)), (name:"amb", prepend:"", spec: ControlSpec(0.01, 4.0, \linear, 0.01)), (name:"step", prepend:"", spec: ControlSpec(0.01, 2.0, \linear, 0.01)), (name:"clock", prepend:"", spec: ControlSpec(0.01, 2.0, \linear, 0.01)), (name:"ssplicelen", prepend:"-s", spec: ControlSpec(10, 100, \linear, 0.1)), (name:"cclokrand", prepend:"-c", spec: ControlSpec(0.0, 1.0, \linear, 0.001)), (name:"overlap", prepend:"-o", spec: ControlSpec(0.0, 1.0, \linear, 0.001)), ]);

)

/////////////////////// GUI - Spectral /////////////////////////

( // Stretch time

CDPFft( "stretch time 1", "Stretch", ~directory, [ (name:"factor", prepend:"", spec: ControlSpec(4, 32, \linear, 1)) ]);

)

( // Blur

CDPFft( "blur blur", "Blur", ~directory, [ (name:"factor", prepend:"", spec: ControlSpec(10, 400, \linear, 1)) ]);

)

( // Hilite frequencies

CDPFft( "hilite trace 4", "Trace", ~directory, [ (name:"retain", prepend:"", spec: ControlSpec(4, 32, \linear, 1)), (name:"lofrq", prepend:"", spec: ControlSpec(10, 20000, \linear, 1)), (name:"hifrq", prepend:"", spec: ControlSpec(10, 20000, \linear, 1)) ]);

)

( // Shift frequencies

CDPFft( "strange shift 1", "Shift", ~directory, [ (name:"shift", prepend:"", spec: ControlSpec(-1000, 1000, \linear, 1)) ]);

)

( // Invert

CDPFft( "strange invert 2", "Shift", ~directory, params:[]);

)

( // Accumulate

CDPFft( "focus accu", "Accumulate", ~directory, [ (name:"decay", prepend:"-d", spec: ControlSpec(0.001, 1.0, \linear, 0.002)), (name:"glis", prepend:"-g", spec: ControlSpec(-5, 5, \linear, 1)) ]);

)

( // Exaggerate

CDPFft( "focus exag", "Exaggerate", [ (name:"exagger", prepend:"", spec: ControlSpec(0.1, 1000, \linear, 0.002)) ]);

)


///////////////////////// GUI - Cross ///////////////////////////

( // Vocode two sounds

CDPCross( "formants vocode", "Vocode", ~directory, [ (name:"leafsize", prepend:"-f", spec: ControlSpec(10, 40, \linear, 2, 20)), (name:"lopass", prepend:"-l", spec: ControlSpec(8, 20, \linear, 2, 4)) ]);

)

( // Morph two sounds

CDPCross( "morph morph 1", "Morph", ~directory, [ (name:"as", prepend:"", spec: ControlSpec(0, 8, \linear, 0.1, 4)), (name:"ae", prepend:"", spec: ControlSpec(0, 8, \linear, 0.1, 4)), (name:"fs", prepend:"", spec: ControlSpec(0, 8, \linear, 0.1, 4)), (name:"fe", prepend:"", spec: ControlSpec(0, 8, \linear, 0.1, 4)), (name:"expa", prepend:"", spec: ControlSpec(1, 8, \linear, 0.1, 4)), (name:"expf", prepend:"", spec: ControlSpec(1, 8, \linear, 0.1, 4)) ]);

)

( // Interleave two sounds

CDPCross( "combine interleave", "Interleave", ~directory, [ (name:"leafsize", prepend:"", spec: ControlSpec(4, 32, \linear, 2, 8)) ]);

)

( // Diff two sounds

CDPCross( "combine diff", "Diff", ~directory, [ (name:"crossover", prepend:"-c", spec: ControlSpec(0.0, 1.0, \linear, 0.01, 0.5)) ]);

)
