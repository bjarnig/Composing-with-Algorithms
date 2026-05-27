////////////////////////////////////////////////////////////////
//
//                    JITLib - Node Proxies
//
////////////////////////////////////////////////////////////////


/////////////////  Node Proxy and Ndef  ////////////////////////

(

// Create an audio rate node proxy with 2 channels
a = NodeProxy.audio(s, 2);

// Set the source of the proxy
a.source = { Impulse.ar(50) };

// Start playing the node proxy
a.play;

// Stop playing the node proxy but keep it alive
a.stop;

// Play again
a.play;

// Stop playing and free the synth
a.end

// Clear the source
a.clear;

)


( // Ndef forms an alternative to ProxySpace

// Play to sound out
Ndef(\a).play;

// Set the fade
Ndef(\a).fadeTime = 2;

// Set the source
Ndef(\a, { Pulse.ar([350, 351.3] / 4, 0.4) * 0.2 });

// Play with pattern
Ndef(\a, Pbind(\dur, 0.03, \freq, Pbrown(0, 1, 0.1, inf).linexp(0, 1, 200, 350)));

// Change the source (also needs modulation)
Ndef(\a, { Ringz.ar(Ndef.ar(\b), [350, 351.3] * 8, 0.2) * 4 });

// Set the modulation
Ndef(\b, { Impulse.ar([5, 7]/2, [0, 0.5]) });

)


( // Use Ndef with modulation and GUI

// Play
Ndef(\sound).play;

// Set the fade time
Ndef(\sound).fadeTime = 4;

// Create an LFO
Ndef(\lfo, { LFNoise1.kr(2, 100, 200) });

// Map the LFO
Ndef(\sound).map(\freq, Ndef(\lfo));

// Create the sound
Ndef(\sound, { arg freq, filt=5000; RLPF.ar(Impulse.ar(freq), filt) });

// Switch the lfo
Ndef(\lfo, { LFNoise1.kr(100, 400, 800) });

// Make a GUI
Ndef(\sound).edit

// Make another Ndef
Ndef(\sound2).play;
Ndef(\sound2, { arg freq=200; SinOsc.ar(freq) });

// Make a mixer for all Ndefs
NdefMixer(s);

// Clears after 2 seconds
Ndef(\sound).clear(2);

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
