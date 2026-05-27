////////////////////////////////////////////////////////////////
//
//                          JITLib
//
////////////////////////////////////////////////////////////////

Simple introduction to JITLib and Proxies.

/////////////////////////  ProxySpace  ////////////////////////

/* Proxy space replaces the current environment */

// Create a new environment, store it in variable p
p = ProxySpace.new(s);

// Push for it to replace the current environment
p.push;

// Verify the current environment
currentEnvironment.postln;

// Simple access creates and empty NodeProxy
~a

// Computing with placeholders works without errors
~a + ~b

// Post the placeholders
p.postln;

// Set the value and redo the calculation
~a = 1
~b + 2

// Returns a BinaryOpPlug used on the server
~a + ~b




/* ProxySpace allows for easily creating NodeDefs */

// Create AND replace the environment
p = ProxySpace.push(s.boot);

// Start the NodeProxy
~synth.play;

// Define the NodeProxy
~synth = ~osc.distort * 0.5;

// Set the oscillator
~osc = { Impulse.ar([10, 80]) };

// Clear the synth and oscillation
~synth.clear;
~osc.clear;

// Release the environment
p.pop;




/* Change between proxies */

// Starts to play on a private bus
~x = { RLPF.ar(Impulse.ar(8,10), [800, 1000], 0.2) }

// Gets routed to an audible public bus
~x.play

// There is a fade time that can be set for changes
~x.fadeTime = 5;

// Change the proxy
~x = { RLPF.ar(Impulse.ar(30,20), [1200, 1600], 0.2) }

// Stop listening, the proxies run in the background.
~x.stop

// Finally set the proxy to nil
~x = nil;


/* Set parameters and update */

// Start the proxy
~y.play;

// Set the source with parameters
~y = { arg freq=70; Saw.ar([freq,freq*2]) * 0.1 };

// Set the fade time
~y.fadeTime = 10;

// Update the frequency with set (no fade)
~y.set(\freq, 40);

// Update the frequency with xset (fade)
~y.xset(\freq, 15);

// Create a modulation
~m = { LFNoise0.ar.range(100, 200) };

// Map with fade
~y.xmap(\freq, ~m);

)


/* Clocks can be set for a proxy space */

p = ProxySpace.push();
p.clock = TempoClock.default;
p.quant = 1.0;

~a.play;
~b.play;

// Start a
~a = { Ringz.ar(Impulse.ar(2), [400, 800], 0.8) ! 2 * 0.1};

// Start b in sync
~b = { Ringz.ar(Impulse.ar(2), [200, 1000], 0.8) ! 2 * 0.1};

// Update a tempo in sync
~a = { Ringz.ar(Impulse.ar(4), [1000, 2000], 0.8) ! 2 * 0.1};

// Slow down b
~b = { Ringz.ar(Impulse.ar(0.5), [100, 500], 0.8) ! 2 * 0.1};

( // Sync faster

~a = { Ringz.ar(Impulse.ar(10), [300, 500], 0.8) ! 2 * 0.1};
~b = { Ringz.ar(Impulse.ar(5), [100, 200], 0.8) ! 2 * 0.1};

)



( // Graphical Controllers

ProxyMixer, TdefAllGui, PdefAllGui, NdefMixer,
TdefGui, PdefGui, MonitorGui, NdefGui, NdefParamGui

)

See also:

Pdef, Pdefn, Tdef, Pbindef, Psym, Pnsym, Fdef
History, Pdef, Pdefn, Tdef, Pbindef, Psym, Pnsym, Fdef
ProxyMixer, TdefAllGui, PdefAllGui, NdefMixer,
TdefGui, PdefGui, MonitorGui, NdefGui, NdefParamGui