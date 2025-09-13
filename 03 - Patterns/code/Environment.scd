////////////////////////////////////////////////////////////////
//
//                        SC Environment
//
////////////////////////////////////////////////////////////////

// Evaluate one line using Shift - Enter
1 + 1

( // Evaluate a block using CMD - Enter

a = 1 + 1;
b = a * 2;

)

// Boot the server (CMD + b)
s.boot

// Display the meter (CMD + m)
s.meter

// Main volume control
s.volume.gui;

// Stop everything (CMD + .)
CmdPeriod.run

// Clear Post window shortcut:
Ctrl + Shift + P.

// Use postln to display information in the post window
"This should be a random number from 1 to 10: ".postln; rrand(1,10);

// Ctrl + d for help file
Pbind

// Use .help to look it up
"Pbrown".help

// Start recording
s.record;

// Stop recording
s.stopRecording;

// Server UI with volume, recording etc.
s.makeWindow

// Plot the synth nodes
s.plotTree;

