////////////////////////////////////////////////////////////////
//
//                      Proxy Space
//
////////////////////////////////////////////////////////////////


( // Synth used later

SynthDef(\blip, {|amp=1,freq=150,mod=25|
	var snd = Blip.ar(freq ! 2).fold2(SinOsc.ar(mod));
	var env = EnvGen.ar(Env.sine,doneAction:2);
	Out.ar(0, snd * env * amp);
}).add

)

// push a proxy space
p = ProxySpace.push(s);

// set the proxy space fade time
p.fadeTime = 2;

// start an LFNoise
~lfn = { LFNoise1.ar(1000 ! 2, 0.2) }

// play the LFNoise
~lfn.play

// adjust the volume (vol is not a synth argument)
~lfn.vol = 0.5;

// stop it with a fadeof 3 seconds
~lfn.stop(3);

// process it
~verb = { GVerb.ar(HPF.ar(~lfn.ar[0], LFNoise0.ar(7).range(1000,4000))) }; ~verb.play;

// use the lfn as modulation source
~snd = { PMOsc.ar(200!2, ~lfn.ar.linlin(-1,1,100,200), 1, mul:0.3)  }; ~snd.play

// now, play a pattern
~blip = Pbind(\instrument,\blip,\dur,0.5,\freq,150); ~blip.play;

// create a modulation for the blip mod parameter
~mod = { LFDNoise1.kr(3).range(20,60) };

//then set an argument on the pattern against the control rate proxy
~blip.set(\mod, ~mod)