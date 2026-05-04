///////////////////////////////////////////////////////////////
//
//                   SCEditors, Examples
//
///////////////////////////////////////////////////////////////

Quarks.install("https://github.com/bjarnig/SCEditors")

///////////////////////  SynthDesignerUI //////////////////////

// The SynthDesignerUI uses a synth, a list of specs and pattern to explore the synth and tweak values.

// Pure sine wave
(
var specs = [
	[\freq, ControlSpec(100, 2000, \exp, 1, 440)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\sine, [], specs,
	[(name: "steady", args:[\dur, 0.5]),
	 (name: "fast", args:[\dur, 0.125]),
	 (name: "random", args:[\dur, Pwhite(0.1, 0.8)])],
	s, "/tmp/")
)

// Filtered sawtooth
(
var specs = [
	[\freq, ControlSpec(50, 2000, \exp, 1, 440)],
	[\cutoff, ControlSpec(200, 8000, \exp, 10, 2000)],
	[\res, ControlSpec(0.1, 1.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\saw, [], specs,
	[(name: "steady", args:[\dur, 0.5]),
	 (name: "staccato", args:[\dur, 0.25, \legato, 0.3]),
	 (name: "flowing", args:[\dur, Pwhite(0.3, 0.8), \legato, 0.9])],
	s, "/tmp/")
)

// Square wave
(
var specs = [
	[\freq, ControlSpec(50, 2000, \exp, 1, 440)],
	[\cutoff, ControlSpec(200, 8000, \exp, 10, 2000)],
	[\res, ControlSpec(0.1, 1.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\square, [], specs,
	[(name: "steady", args:[\dur, 0.5]),
	 (name: "arpeggio", args:[\dur, 0.125, \freq, Pseq([440, 550, 660, 880], inf)])],
	s, "/tmp/")
)

// Pulse with PWM
(
var specs = [
	[\freq, ControlSpec(50, 2000, \exp, 1, 440)],
	[\width, ControlSpec(0.1, 0.9, \lin, 0.01, 0.5)],
	[\cutoff, ControlSpec(200, 8000, \exp, 10, 2000)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\pulse, [], specs,
	[(name: "steady", args:[\dur, 0.5]),
	 (name: "rhythmic", args:[\dur, Pseq([0.25, 0.25, 0.5], inf)])],
	s, "/tmp/")
)

// Triangle with detuning
(
var specs = [
	[\freq, ControlSpec(50, 500, \exp, 1, 100)],
	[\detune, ControlSpec(0.0, 0.5, \lin, 0.001, 0.2)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.05)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.4)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\tri, [], specs,
	[(name: "slow", args:[\dur, 1.0]),
	 (name: "medium", args:[\dur, 0.5]),
	 (name: "evolving", args:[\dur, Pwhite(0.3, 1.5)])],
	s, "/tmp/")
)

// Additive synthesis
(
var specs = [
	[\freq, ControlSpec(50, 1000, \exp, 1, 200)],
	[\numharm, ControlSpec(1, 16, \lin, 1, 8)],
	[\brightness, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\add, [], specs,
	[(name: "bright", args:[\dur, 0.5, \brightness, 0.8]),
	 (name: "dark", args:[\dur, 0.5, \brightness, 0.2]),
	 (name: "varying", args:[\dur, 0.25, \numharm, Pwhite(4, 14)])],
	s, "/tmp/")
)

// Blip oscillator
(
var specs = [
	[\freq, ControlSpec(50, 1000, \exp, 1, 200)],
	[\harmonics, ControlSpec(1, 40, \lin, 1, 10)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\blip, [], specs,
	[(name: "few harmonics", args:[\dur, 0.5, \harmonics, 5]),
	 (name: "many harmonics", args:[\dur, 0.5, \harmonics, 30]),
	 (name: "sweep", args:[\dur, 0.25, \harmonics, Pseries(5, 1, 20)])],
	s, "/tmp/")
)

// White noise
(
var specs = [
	[\freq, ControlSpec(200, 8000, \exp, 10, 1000)],
	[\bw, ControlSpec(0.1, 2.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.3, \lin, 0.01, 0.2)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\white, [], specs,
	[(name: "short bursts", args:[\dur, 0.25, \rel, 0.1]),
	 (name: "sweeping", args:[\dur, 0.5, \freq, Pexprand(500, 4000)])],
	s, "/tmp/")
)

// Pink noise
(
var specs = [
	[\freq, ControlSpec(200, 8000, \exp, 10, 1000)],
	[\bw, ControlSpec(0.1, 2.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.3, \lin, 0.01, 0.2)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\pink, [], specs,
	[(name: "steady", args:[\dur, 0.5]),
	 (name: "percussive", args:[\dur, 0.125, \rel, 0.05])],
	s, "/tmp/")
)

// Brown noise
(
var specs = [
	[\freq, ControlSpec(200, 4000, \exp, 10, 1000)],
	[\res, ControlSpec(0.01, 0.5, \lin, 0.01, 0.1)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.3, \lin, 0.01, 0.2)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\brown, [], specs,
	[(name: "rumble", args:[\dur, 1.0, \freq, 200]),
	 (name: "mid", args:[\dur, 0.5, \freq, 1000])],
	s, "/tmp/")
)

// Dust impulses
(
var specs = [
	[\freq, ControlSpec(200, 8000, \exp, 10, 1000)],
	[\density, ControlSpec(10, 500, \exp, 1, 100)],
	[\atk, ControlSpec(0.001, 0.5, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\dust, [], specs,
	[(name: "sparse", args:[\dur, 2.0, \density, 20]),
	 (name: "dense", args:[\dur, 1.0, \density, 300])],
	s, "/tmp/")
)

// Crackle
(
var specs = [
	[\freq, ControlSpec(200, 8000, \exp, 10, 1000)],
	[\chaos, ControlSpec(1.0, 2.0, \lin, 0.01, 1.5)],
	[\atk, ControlSpec(0.001, 0.5, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.3, \lin, 0.01, 0.2)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\crackle, [], specs,
	[(name: "low chaos", args:[\dur, 0.5, \chaos, 1.2]),
	 (name: "high chaos", args:[\dur, 0.5, \chaos, 1.9])],
	s, "/tmp/")
)

// Simple FM
(
var specs = [
	[\freq, ControlSpec(100, 2000, \exp, 1, 400)],
	[\cmRatio, ControlSpec(0.5, 8.0, \lin, 0.1, 1.5)],
	[\index, ControlSpec(0.0, 10.0, \lin, 0.1, 3)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\fm, [], specs,
	[(name: "bell-like", args:[\dur, 1.0, \cmRatio, 1.4, \index, 6]),
	 (name: "metallic", args:[\dur, 0.5, \cmRatio, 3.7, \index, 8]),
	 (name: "evolving", args:[\dur, 0.25, \cmRatio, Pwhite(1.0, 4.0)])],
	s, "/tmp/")
)

// 4-operator FM
(
var specs = [
	[\freq, ControlSpec(50, 500, \exp, 1, 100)],
	[\mod, ControlSpec(0.5, 8.0, \lin, 0.1, 2.0)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.05)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\fm4op, [], specs,
	[(name: "slow", args:[\dur, 1.0]),
	 (name: "rhythmic", args:[\dur, Pseq([0.5, 0.25, 0.25], inf)]),
	 (name: "varying mod", args:[\dur, 0.5, \mod, Pwhite(1.0, 6.0)])],
	s, "/tmp/")
)

// FM Cascade
(
var specs = [
	[\freq, ControlSpec(100, 2000, \exp, 1, 400)],
	[\modFreq1, ControlSpec(50, 500, \exp, 1, 100)],
	[\modIndex1, ControlSpec(0.0, 10.0, \lin, 0.1, 5)],
	[\modFreq2, ControlSpec(50, 500, \exp, 1, 200)],
	[\modIndex2, ControlSpec(0.0, 10.0, \lin, 0.1, 3)],
	[\modFreq3, ControlSpec(20, 200, \exp, 1, 50)],
	[\modIndex3, ControlSpec(0.0, 10.0, \lin, 0.1, 2)],
	[\atk, ControlSpec(0.001, 1.0, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.01, 2.0, \exp, 0.01, 0.3)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)]
];
SynthDesignerUI(\fmCascade, [], specs,
	[(name: "simple", args:[\dur, 0.5]),
	 (name: "complex", args:[\dur, 0.25, \modIndex1, 8, \modIndex2, 6])],
	s, "/tmp/")
)

// FM Grain
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\mod, ControlSpec(0.1, 2.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.01, 0.5, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\fmgrain, [], specs,
	[(name: "sparse", args:[\dur, 2.0]),
	 (name: "dense", args:[\dur, 0.5])],
	s, "/tmp/")
)

// Plip (AM Blips)
(
var specs = [
	[\freq, ControlSpec(100, 2000, \exp, 1, 400)],
	[\mod, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.01, 0.5, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\plip, [], specs,
	[(name: "no mod", args:[\dur, 0.5, \mod, 0.0]),
	 (name: "full mod", args:[\dur, 0.5, \mod, 1.0]),
	 (name: "varying", args:[\dur, 0.25, \mod, Pwhite(0.2, 0.8)])],
	s, "/tmp/")
)

// Sine with feedback
(
var specs = [
	[\freq, ControlSpec(100, 2000, \exp, 1, 440)],
	[\feedback, ControlSpec(0.0, 1.5, \lin, 0.01, 0.7)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.3, \lin, 0.01, 0.2)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\sinefb, [], specs,
	[(name: "clean", args:[\dur, 0.5, \feedback, 0.3]),
	 (name: "dirty", args:[\dur, 0.5, \feedback, 1.2])],
	s, "/tmp/")
)

// Fold waveshaping
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\foldfreq, ControlSpec(50, 1000, \exp, 1, 300)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\fold, [], specs,
	[(name: "slow fold", args:[\dur, 1.0, \foldfreq, 100]),
	 (name: "fast fold", args:[\dur, 0.5, \foldfreq, 800])],
	s, "/tmp/")
)

// Saw fold
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\fold, ControlSpec(0.1, 2.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\sawfold, [], specs,
	[(name: "light fold", args:[\dur, 0.5, \fold, 0.3]),
	 (name: "heavy fold", args:[\dur, 0.5, \fold, 1.5])],
	s, "/tmp/")
)

// Gingerbreadman
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\chaos, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\lop, ControlSpec(500, 18000, \exp, 10, 18000)],
	[\loprq, ControlSpec(0.1, 2.0, \lin, 0.01, 1)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\gbman, [], specs,
	[(name: "smooth", args:[\dur, 0.5, \chaos, 0.1]),
	 (name: "chaotic", args:[\dur, 0.5, \chaos, 0.8]),
	 (name: "varying", args:[\dur, 0.25, \chaos, Pwhite(0.2, 0.9)])],
	s, "/tmp/")
)

// Henon
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\rate, ControlSpec(50, 500, \exp, 1, 100)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\henon, [], specs,
	[(name: "slow chaos", args:[\dur, 1.0, \rate, 50]),
	 (name: "fast chaos", args:[\dur, 0.25, \rate, 300])],
	s, "/tmp/")
)

// Standard Map
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\rate, ControlSpec(500, 5000, \exp, 10, 1000)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\standard, [], specs,
	[(name: "steady", args:[\dur, 0.5]),
	 (name: "varying rate", args:[\dur, 0.25, \rate, Pexprand(700, 3000)])],
	s, "/tmp/")
)

// Lorenz
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\rate, ControlSpec(2000, 8000, \exp, 10, 4000)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\lorenz, [], specs,
	[(name: "slow", args:[\dur, 1.0]),
	 (name: "fast", args:[\dur, 0.25])],
	s, "/tmp/")
)

// Brownian pitch
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 400)],
	[\mod, ControlSpec(0.0, 2.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.3, \lin, 0.01, 0.2)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\brownpitch, [], specs,
	[(name: "small steps", args:[\dur, 1.0, \mod, 0.2]),
	 (name: "big steps", args:[\dur, 0.5, \mod, 1.5])],
	s, "/tmp/")
)

// Chaos impulse
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\entropy, ControlSpec(0.0, 2.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\chaosimpulse, [], specs,
	[(name: "ordered", args:[\dur, 0.5, \entropy, 0.1]),
	 (name: "chaotic", args:[\dur, 0.5, \entropy, 1.5])],
	s, "/tmp/")
)

// Karplus-Strong pluck
(
var specs = [
	[\freq, ControlSpec(100, 2000, \exp, 1, 440)],
	[\coef, ControlSpec(-0.5, 0.9, \lin, 0.01, 0.1)],
	[\atk, ControlSpec(0.001, 0.1, \exp, 0.001, 0.001)],
	[\rel, ControlSpec(0.5, 5.0, \exp, 0.01, 2.0)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\pluck, [], specs,
	[(name: "short", args:[\dur, 0.5, \rel, 1.0]),
	 (name: "long", args:[\dur, 1.0, \rel, 4.0]),
	 (name: "melody", args:[\dur, 0.25, \freq, Pseq([440, 550, 660, 880], inf)])],
	s, "/tmp/")
)

// Modal synthesis
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\strike, ControlSpec(0.01, 0.5, \exp, 0.01, 0.1)],
	[\atk, ControlSpec(0.001, 0.1, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\modal, [], specs,
	[(name: "soft", args:[\dur, 1.0, \strike, 0.02]),
	 (name: "hard", args:[\dur, 0.5, \strike, 0.3])],
	s, "/tmp/")
)

// Formant synthesis
(
var specs = [
	[\freq, ControlSpec(50, 400, \exp, 1, 100)],
	[\form1, ControlSpec(200, 2000, \exp, 10, 800)],
	[\form2, ControlSpec(500, 3000, \exp, 10, 1200)],
	[\form3, ControlSpec(1000, 4000, \exp, 10, 2400)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\formant, [], specs,
	[(name: "vowel a", args:[\dur, 0.5, \form1, 800, \form2, 1200, \form3, 2400]),
	 (name: "vowel e", args:[\dur, 0.5, \form1, 500, \form2, 1800, \form3, 2500]),
	 (name: "vowel i", args:[\dur, 0.5, \form1, 300, \form2, 2300, \form3, 3000])],
	s, "/tmp/")
)

// Grain texture
(
var specs = [
	[\freq, ControlSpec(200, 2000, \exp, 10, 500)],
	[\rate, ControlSpec(5, 50, \exp, 1, 10)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\grain, [], specs,
	[(name: "sparse", args:[\dur, 2.0, \rate, 5]),
	 (name: "dense", args:[\dur, 1.0, \rate, 30])],
	s, "/tmp/")
)

// Upper register texture
(
var specs = [
	[\freq, ControlSpec(500, 4000, \exp, 10, 1000)],
	[\entropy, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\upper, [], specs,
	[(name: "calm", args:[\dur, 2.0, \entropy, 0.2]),
	 (name: "agitated", args:[\dur, 0.5, \entropy, 0.9])],
	s, "/tmp/")
)

// Metal resonance
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\decay, ControlSpec(0.5, 5.0, \exp, 0.01, 1.0)],
	[\atk, ControlSpec(0.001, 0.1, \exp, 0.001, 0.01)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\metal, [], specs,
	[(name: "short ring", args:[\dur, 1.0, \decay, 0.5]),
	 (name: "long ring", args:[\dur, 2.0, \decay, 3.0])],
	s, "/tmp/")
)

// Basic Gendy
(
var specs = [
	[\freq, ControlSpec(50, 500, \exp, 1, 100)],
	[\minfreq, ControlSpec(20, 200, \exp, 1, 50)],
	[\maxfreq, ControlSpec(200, 2000, \exp, 10, 500)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\gendy, [], specs,
	[(name: "narrow range", args:[\dur, 1.0, \minfreq, 80, \maxfreq, 200]),
	 (name: "wide range", args:[\dur, 1.0, \minfreq, 30, \maxfreq, 1000])],
	s, "/tmp/")
)

// Gendy3
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\durscale, ControlSpec(0.01, 1.0, \exp, 0.01, 0.1)],
	[\knum, ControlSpec(2, 30, \lin, 1, 12)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\gendy3, [], specs,
	[(name: "smooth", args:[\dur, 1.0, \durscale, 0.3, \knum, 6]),
	 (name: "rough", args:[\dur, 0.5, \durscale, 0.05, \knum, 20])],
	s, "/tmp/")
)

// Gendy with resonator
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\minfreq, ControlSpec(10, 100, \exp, 1, 20)],
	[\maxfreq, ControlSpec(100, 500, \exp, 10, 200)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\gendyres, [], specs,
	[(name: "harmonic", args:[\dur, 1.0, \freq, 200]),
	 (name: "inharmonic", args:[\dur, 0.5, \freq, Pexprand(150, 600)])],
	s, "/tmp/")
)

// Self-oscillating resonator
(
var specs = [
	[\freq, ControlSpec(200, 2000, \exp, 1, 440)],
	[\drive, ControlSpec(5, 20, \lin, 0.1, 10)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\resself, [], specs,
	[(name: "sine-like", args:[\dur, 0.5, \drive, 6]),
	 (name: "distorted", args:[\dur, 0.5, \drive, 18])],
	s, "/tmp/")
)

// Dual resonator
(
var specs = [
	[\freq, ControlSpec(200, 2000, \exp, 1, 440)],
	[\freq2, ControlSpec(200, 2000, \exp, 1, 880)],
	[\res, ControlSpec(0.01, 0.2, \lin, 0.001, 0.05)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\dualres, [], specs,
	[(name: "consonant", args:[\dur, 1.0, \freq, 440, \freq2, 880]),
	 (name: "dissonant", args:[\dur, 0.5, \freq, 440, \freq2, 666])],
	s, "/tmp/")
)

// Formlet cascade
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\dens, ControlSpec(50, 500, \exp, 1, 100)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\formcascade, [], specs,
	[(name: "sparse", args:[\dur, 2.0, \dens, 50]),
	 (name: "dense", args:[\dur, 1.0, \dens, 300])],
	s, "/tmp/")
)

// Multi-oscillator stack
(
var specs = [
	[\freq, ControlSpec(50, 500, \exp, 1, 100)],
	[\detune, ControlSpec(0.0, 0.1, \lin, 0.001, 0.02)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\stack, [], specs,
	[(name: "tight", args:[\dur, 0.5, \detune, 0.005]),
	 (name: "wide", args:[\dur, 0.5, \detune, 0.05])],
	s, "/tmp/")
)

// Harmonic drone
(
var specs = [
	[\freq, ControlSpec(50, 400, \exp, 1, 100)],
	[\drift, ControlSpec(0.0, 0.3, \lin, 0.01, 0.1)],
	[\atk, ControlSpec(0.5, 5.0, \exp, 0.01, 1.0)],
	[\rel, ControlSpec(0.5, 5.0, \exp, 0.01, 1.0)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\drone, [], specs,
	[(name: "stable", args:[\dur, 4.0, \drift, 0.02]),
	 (name: "unstable", args:[\dur, 4.0, \drift, 0.2])],
	s, "/tmp/")
)

// Ring modulation
(
var specs = [
	[\freq, ControlSpec(100, 1000, \exp, 1, 200)],
	[\modfreq, ControlSpec(20, 500, \exp, 1, 50)],
	[\atk, ControlSpec(0.01, 1.0, \exp, 0.001, 0.1)],
	[\rel, ControlSpec(0.1, 2.0, \exp, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 0.5, \lin, 0.01, 0.3)],
	[\pan, ControlSpec(-1, 1, \lin, 0.01, 0)]
];
SynthDesignerUI(\ring, [], specs,
	[(name: "slow mod", args:[\dur, 1.0, \modfreq, 30]),
	 (name: "fast mod", args:[\dur, 0.5, \modfreq, 200]),
	 (name: "varying", args:[\dur, 0.5, \modfreq, Pexprand(40, 300)])],
	s, "/tmp/")
)

////////////////////  PatternInteractionUI ////////////////////

// The PatternInteractionUI loads a pattern, specs and arguments to tweak pattern settings.

(
	var item = ();

	item.specs = [
		[\amp, ControlSpec(0.001, 4.0, \exp, 0.001, 1)],
		[\rate, ControlSpec(0.1, 8, \lin, 0.01, 1)],
		[\mod, ControlSpec(0.001, 8, \lin, 0.001, 1)],
		[\dur, ControlSpec(0.1, 8, \lin, 0.1, 1)]
	];

	item.arguments = Dictionary();
	item.specs.do{|sp| item.arguments[sp[0]] = sp[1].default };

	item.pattern = PbindProxy(
		\instrument, \gbman,
		\atk, 0.21, \dec, 2.5, \sus, 0.5, \rel, 0.2, \modp, 44, \ampp, 1, \durp, 1,
		\freqp, [2423, 1650], \lpf, 1600,  \curve, 0, \out, 0,
		\ampModAmt, 0.99, \numHarm, 2,  \ampModFreq, 28.1,
		\rate, Pfunc { item.arguments[\rate] },
		\durc, Pfunc { item.arguments[\dur] },
		\ampc, Pfunc { item.arguments[\amp] },
		\modc, Pfunc { item.arguments[\mod] },
		\freq, Pkey(\freqp) * Pkey(\rate),
	    \modFreq, Pkey(\modc) * Pkey(\modp),
		\dur, Pkey(\durp) * Pkey(\durc),
		\amp, Pkey(\ampc) * Pkey(\ampp)
	);

	PatternInteractionUI(item, Server.default);
)


///////////////////////  PatternLauncherUI ///////////////////////

// The PatternLauncherUI loads a pattern dictionary and creates a grid of buttons to switch between patterns.

(

var patterns = Dictionary(), r = List(), t = List(), q = List();

r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 24, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 14, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 44, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.3)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 54, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.4)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 74, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.5)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 84, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 94, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 34, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.3)));
patterns["rhythms"] = r;

t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 24, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 14, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 44, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.3)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 54, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.4)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 74, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.5)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 84, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 94, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 34, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.3)));
patterns["drones"] = t;

q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 24, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 14, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 44, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.3)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 54, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.4)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 74, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.5)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 84, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 94, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 34, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.3)));
patterns["noises"] = q;

patterns["rhythm2"] = r; patterns["noise2"] = q; patterns["drone2"] = t;

PatternLauncherUI(patterns);

)

///////////////////////  NdefLauncherUI ///////////////////////

// The NdefLauncherUI loads an Ndef dictionary and creates a grid of buttons to switch between Ndefs.

(
var ndefs = Dictionary();
var fast = List(), slow = List(), evolving = List();

// Define the base Ndef
Ndef(\blips, {|rate=10, freqMin=1000, freqMax=5000, amp=0.3|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.05), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
});

// Fast rhythms category
fast.add(Ndef(\blipsFast1).clear.source_({|rate=20, freqMin=2000, freqMax=5000, amp=0.2|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.03), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

fast.add(Ndef(\blipsFast2).clear.source_({|rate=30, freqMin=1500, freqMax=4000, amp=0.15|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.02), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

fast.add(Ndef(\blipsFast3).clear.source_({|rate=25, freqMin=3000, freqMax=8000, amp=0.18|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.04), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

// Slow rhythms category
slow.add(Ndef(\blipsSlow1).clear.source_({|rate=3, freqMin=500, freqMax=2000, amp=0.4|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.01, 0.1), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

slow.add(Ndef(\blipsSlow2).clear.source_({|rate=5, freqMin=300, freqMax=1500, amp=0.35|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.005, 0.08), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

slow.add(Ndef(\blipsSlow3).clear.source_({|rate=2, freqMin=800, freqMax=2500, amp=0.45|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.002, 0.12), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

// Evolving patterns with LFOs
evolving.add(Ndef(\blipsEvolve1).clear.source_({|amp=0.3|
	var rate = LFNoise1.kr(0.5).range(5, 20);
	var freqMin = LFNoise1.kr(0.3).range(500, 2000);
	var freqMax = LFNoise1.kr(0.3).range(2000, 6000);
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.05), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

evolving.add(Ndef(\blipsEvolve2).clear.source_({|amp=0.25|
	var rate = LFTri.kr(0.2).range(8, 30);
	var freqMin = LFNoise0.kr(0.5).range(1000, 3000);
	var freqMax = freqMin + 2000;
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.03), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

evolving.add(Ndef(\blipsEvolve3).clear.source_({|amp=0.28|
	var rate = SinOsc.kr(0.1).range(2, 15);
	var freqMin = LFNoise2.kr(0.4).range(400, 1800);
	var freqMax = LFNoise2.kr(0.4).range(2500, 7000);
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.06), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

// Organize into dictionary
ndefs["fast"] = fast;
ndefs["slow"] = slow;
ndefs["evolving"] = evolving;

// Launch the UI
NdefLauncherUI(ndefs);
)

////////////////////  PatternInteractionUI ////////////////////

// The PatternInteractionUI loads a pattern, specs and arguments to tweak pattern settings.

(
	var item = ();

	item.specs = [
		[\amp, ControlSpec(0.001, 4.0, \exp, 0.001, 1)],
		[\rate, ControlSpec(0.1, 8, \lin, 0.01, 1)],
		[\mod, ControlSpec(0.001, 8, \lin, 0.001, 1)],
		[\dur, ControlSpec(0.1, 8, \lin, 0.1, 1)]
	];

	item.arguments = Dictionary();
	item.specs.do{|sp| item.arguments[sp[0]] = sp[1].default };

	item.pattern = PbindProxy(
		\instrument, \gbman,
		\atk, 0.21, \dec, 2.5, \sus, 0.5, \rel, 0.2, \modp, 44, \ampp, 1, \durp, 1,
		\freqp, [2423, 1650], \lpf, 1600,  \curve, 0, \out, 0,
		\ampModAmt, 0.99, \numHarm, 2,  \ampModFreq, 28.1,
		\rate, Pfunc { item.arguments[\rate] },
		\durc, Pfunc { item.arguments[\dur] },
		\ampc, Pfunc { item.arguments[\amp] },
		\modc, Pfunc { item.arguments[\mod] },
		\freq, Pkey(\freqp) * Pkey(\rate),
	    \modFreq, Pkey(\modc) * Pkey(\modp),
		\dur, Pkey(\durp) * Pkey(\durc),
		\amp, Pkey(\ampc) * Pkey(\ampp)
	);

	PatternInteractionUI(item, Server.default);
)


///////////////////////  PatternLauncherUI ///////////////////////

// The PatternLauncherUI loads a pattern dictionary and creates a grid of buttons to switch between patterns.

(

var patterns = Dictionary(), r = List(), t = List(), q = List();

r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 24, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 14, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 44, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.3)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 54, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.4)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 74, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.5)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 84, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 94, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
r.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 34, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.3)));
patterns["rhythms"] = r;

t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 24, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 14, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 44, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.3)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 54, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.4)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 74, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.5)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 84, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 94, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
t.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 34, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.3)));
patterns["drones"] = t;

q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 24, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 14, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 44, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.3)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 54, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.4)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 74, \dec, 0.29, \curve, 0.5, \freq, 423, \amp, 0.1, \dur, 0.5)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 84, \dec, 0.29, \curve, 0.5, \freq, 623, \amp, 0.1, \dur, 0.1)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 94, \dec, 0.29, \curve, 0.5, \freq, 123, \amp, 0.1, \dur, 0.2)));
q.add(PatternProxy(Pbind(\instrument, \gbman, \sus, 0.62, \modFreq, 34, \dec, 0.29, \curve, 0.5, \freq, 223, \amp, 0.1, \dur, 0.3)));
patterns["noises"] = q;

patterns["rhythm2"] = r; patterns["noise2"] = q; patterns["drone2"] = t;

PatternLauncherUI(patterns);

)

///////////////////////  NdefLauncherUI ///////////////////////

// The NdefLauncherUI loads an Ndef dictionary and creates a grid of buttons to switch between Ndefs.

(
var ndefs = Dictionary();
var fast = List(), slow = List(), evolving = List();

// Define the base Ndef
Ndef(\blips, {|rate=10, freqMin=1000, freqMax=5000, amp=0.3|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.05), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
});

// Fast rhythms category
fast.add(Ndef(\blipsFast1).clear.source_({|rate=20, freqMin=2000, freqMax=5000, amp=0.2|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.03), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

fast.add(Ndef(\blipsFast2).clear.source_({|rate=30, freqMin=1500, freqMax=4000, amp=0.15|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.02), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

fast.add(Ndef(\blipsFast3).clear.source_({|rate=25, freqMin=3000, freqMax=8000, amp=0.18|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.04), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

// Slow rhythms category
slow.add(Ndef(\blipsSlow1).clear.source_({|rate=3, freqMin=500, freqMax=2000, amp=0.4|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.01, 0.1), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

slow.add(Ndef(\blipsSlow2).clear.source_({|rate=5, freqMin=300, freqMax=1500, amp=0.35|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.005, 0.08), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

slow.add(Ndef(\blipsSlow3).clear.source_({|rate=2, freqMin=800, freqMax=2500, amp=0.45|
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.002, 0.12), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

// Evolving patterns with LFOs
evolving.add(Ndef(\blipsEvolve1).clear.source_({|amp=0.3|
	var rate = LFNoise1.kr(0.5).range(5, 20);
	var freqMin = LFNoise1.kr(0.3).range(500, 2000);
	var freqMax = LFNoise1.kr(0.3).range(2000, 6000);
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.05), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

evolving.add(Ndef(\blipsEvolve2).clear.source_({|amp=0.25|
	var rate = LFTri.kr(0.2).range(8, 30);
	var freqMin = LFNoise0.kr(0.5).range(1000, 3000);
	var freqMax = freqMin + 2000;
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.03), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

evolving.add(Ndef(\blipsEvolve3).clear.source_({|amp=0.28|
	var rate = SinOsc.kr(0.1).range(2, 15);
	var freqMin = LFNoise2.kr(0.4).range(400, 1800);
	var freqMax = LFNoise2.kr(0.4).range(2500, 7000);
	var trig = Impulse.ar(rate);
	var freq = TRand.ar(freqMin, freqMax, trig);
	var env = EnvGen.ar(Env.perc(0.001, 0.06), trig);
	var sig = SinOsc.ar(freq) * env;
	sig * amp;
}));

// Organize into dictionary
ndefs["fast"] = fast;
ndefs["slow"] = slow;
ndefs["evolving"] = evolving;

// Launch the UI
NdefLauncherUI(ndefs);
)
