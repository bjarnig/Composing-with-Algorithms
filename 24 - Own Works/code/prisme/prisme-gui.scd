////////////////////////////////////////////////////////////////
//
//                      Prisme. GUI
//
////////////////////////////////////////////////////////////////

(

var patterns = Dictionary();
~croftPatternList = List();
~brownPatternList = List();
~dechlorPatternList = List();
~drackPatternList = List();
~eithnePatternList = List();
~fmPatternList = List();
~fmAstPatternList = List();
~gbManPatternList = List();
~opalPatternList = List();
~modPalPatternList = List();
~pliparPatternList = List();
~sineFbPatternList = List();

///////////////// Croft ////////////////////

~croftPatternList.add(PatternProxy(
	Pbind(\instrument, \cCroft,
	\sus, 0.24, \rel, 0.11, \atk, 0.04, \modFreq, [ 25.041666666667, 150.25 ], \dec, 1.94, \curve, 3.5,
	\freq, Pwhite(200, 400), \dur, 0.02,
	\amp, Env([0.0, 0.08, 0.455, 0.533, 0.79, 0.85, 0.45, 0.0] * 4, [6, 12, 25, 16, 15, 6, 20]),
	\numHarm, Env([150, 140, 5, 15], [50, 30, 15, 5]),
	)
));

~croftPatternList.add(PatternProxy(
	Pbind(\instrument, \cCroft,
	\sus, 0.24, \rel, 0.11, \atk, 0.04, \modFreq, [601/6, 601], \dec, 1.94, \curve, 3.5,
	\freq, Pwhite(200, 600), \dur, 0.04,
	\amp, Env([0, 0.1, 0.6, 0.7] * 0.7, [1, 3, 25]),
	\numHarm, Env([35, 75, 25, 5], [50, 30, 15, 5]),
	)
));

~croftPatternList.add(PatternProxy(
	Pbind(\instrument, \cCroft,
	\sus, 0.24, \rel, 0.05, \atk, 0.03, \modFreq, [ 150.69, 100.167 ], \dec, 1.94, \curve, -2.5,
	\freq, Pwhite(200, 300), \dur, 0.042,
	\hpf, 200, \lpf, 6000,
	\amp, Env([0, 0.1, 0.6, 0.7, 0.05, 0.7, 0.05, 0.7 ] * 0.3, [1, 3, 5, 10, 15, 20]),
	\numHarm, Env([55, 35, 25, 5], [50, 30, 15, 5]),
	)
));

~croftPatternList.add(PatternProxy(
	Pbind(\instrument, \cCroft,
	\sus, 0.24, \rel, 0.02, \atk, 0.15, \modFreq, [601/8, 601], \dec, 0.1, \curve, 3.5,
	\freq, Pwhite(700, 800), \dur, 0.3, \lpf, 1000,
	\amp, Env([0, 0.1, 0.6, 0.7] * 0.2, [1, 3, 25]),
	\numHarm, Env([25, 75, 25, 5], [50, 30, 15, 5]),
	)
));

~croftPatternList.add(PatternProxy(
	Pbind(\instrument, \cCroft,
	\sus, 0.24, \rel, 0.11, \atk, 0.04, \modFreq, [ 33.38, 200.334], \dec, 1.94, \curve, 3.5,
	\freq, Pwhite(200, 600), \dur, 0.04,
	\amp, Env([0, 0.1, 0.6, 0.7], [1, 3, 25]),
	\numHarm, Env([120, 75, 25, 5], [50, 30, 15, 5]),
	)
));

~croftPatternList.add(PatternProxy(
	Pbind(\instrument, \cCroft,
	\sus, 0.5, \dec, 2.5, \rel, 0.05, \atk, 0.1, \freq, 1202, \curve, 2, \numHarm, 151, \dur, 0.15,
	\modFreq, Pseq( [ Pseq([36], 250), Pseq([26], 200), Pseq([16], 50)], inf ),
	\amp, Pn(Penv([0.0, 0.01, 0.508, 0.0] * 2, [5, 12, 15])),
	)
));

~croftPatternList.add(PatternProxy(
	Pbind(\instrument, \cCroft,
	\sus, 0.5, \atk, 0.21, \modFreq, 34, \lpf, 19000, \ampModAmt, 0.99, \rel, 1.5, \curve, 0, \dec, 2.5, \numHarm, 473, \freq, 1716, \ampModFreq, 38.1,
	\dur, 0.1,
	\amp, Pn(Penv([0.0, 0.308, 0.0], [10, 15])),
	)
));

~croftPatternList.add(PatternProxy(
	Pbind(\instrument, \cCroft,
	\sus, 0.5, \atk, 0.21, \lpf, 10000, \ampModAmt, 0.99, \rel, 0.01, \curve, 0, \dec, 2.5, \numHarm, 473, \freq, 601,
	\ampModFreq, Pn(Penv([10, 20, 0.2], [8,2])),
	\hpf, 200,
	\modFreq, 40,
	\amp, Pn(Penv([0.0, 0.508, 0.0], [10, 15])),
	\dur, 0.5
	)
));


///////////////// Brown ////////////////////

~brownPatternList.add(PatternProxy(
	Pbind(\instrument, \cBrown,
		\legato, 0.75,
		\sus, 0.673,
		\mod, 0.91,
		\rel, 0.048,
		\modFreq, 4201,
		\freq, Pwrand([2422, 2500], [0.8, 0.2]),
		\numharm, 60,
		\amp, Pseq([4,2,4, Pwhite(0.0, 6, 4)], inf),
		\modDur, 13.8,
		\dur, Pseq([Penv([0.1, 0.2],[5]), Penv([0.15, 0.05],[5*2]), Penv([0.05, 0.5],[5*4]), Pseq([0.05], 15)], inf),
		\atk, Pkey(\dur)
	)
));


~brownPatternList.add(PatternProxy(
	Pbind(\instrument, \cBrown,
		\legato, 0.7,
		\sus, 1,
		\mod, 0.91,
		\rel, 0.048,
		\modFreq, 201,
		\freq, Pwrand([2422, 2500, 1202], [0.6, 0.3, 0.1]),
		\numharm, Pwhite(10, 50),
		\amp, Pseq([4,0,0.1,4, Pwhite(0.0, 6, 4)], inf),
		\modDur, 1.8,
		\dur, Pbrown(0.1, 0.3, 0.01),
		\atk, Pkey(\dur)
	)
));

~brownPatternList.add(PatternProxy(
	Pbind(\instrument, \cBrown,
		\sus, 0.927, \mod, 0.35, \rel, 0.046, \atk, 0.09,
		\modFreq, 5293, \freq, 2421.6, \numharm, 15, \amp, 2,
		\modDur, 14.5,
		\dur, 0.12
	)
));


~brownPatternList.add(PatternProxy(
	Pbind(\instrument, \cBrown,
		\sus, 0.027, \mod, 0.85, \rel, 0.056, \atk, 0.042,
		\modFreq, 293, \freq, 2421.6, \numharm, 15, \amp, 2.5,
		\modDur, 14.5,
		\dur, 0.05
	)
));

~brownPatternList.add(PatternProxy(
	Pbind(\instrument, \cBrown,
		\sus, 0.927, \mod, 0.35, \rel, 0.156,
		\modFreq, 5293, \freq, 2421.6, \numharm, 25,
		\modDur, 14.5,
		\legato, 0.5,
		\dur, Pseq([Penv([0.15, 0.4, 2], [2, 4]), Pwhite(1.5, 8.0)]),
		\amp, Pkey(\dur).linlin(0.1, 8.0, 0.1, 0.001),
		\atk, Pkey(\dur).linlin(0.1, 8.0, 0.1, 0.5),
	)
));

~brownPatternList.add(PatternProxy(
	Pbind(\instrument, \cBrown,
		\sus, 0.927, \mod, 0.35, \rel, 0.156,
		\modFreq, 5293, \freq, 2421.6, \numharm, 25, \amp, 0.05,
		\modDur, 14.5,
		\legato, 0.5,
		\dur, Pseq([Penv([0.4, 0.25, 0.05], [2, 6]), Pwhite(0.05, 0.1)]),
		\amp, Env([0.1, 2], 8),
		\atk, 0.05
	)
));

/////////////// Dechlor ////////////////////

~dechlorPatternList.add(PatternProxy(
	Pbind(\instrument, \cDechlor,
		\sus, 0.01, \rel, 0.09,  \atk, 0.21,
		\dec, 0.11, \amp, 0.447, \freq, 1218,
		\surface, 0.1,
        \dur, Pbrown(0.2, 0.6, 0.05)
	)
));

~dechlorPatternList.add(PatternProxy(
	Pbind(\instrument, \cDechlor,
		\sus, 1, \rel, 0.1, \speed, 0.5, \atk, 1,
		\amp, 0.464, \surface, 0.5, \freq, 2010,
		\entropy, 0.5, \dur, Pbrown(0.2, 0.6, 0.05)
	)
));

~dechlorPatternList.add(PatternProxy(
	Pbind(\instrument, \cDechlor,
		\sus, 0.668, \rel, 1.907, \speed, 0.72, \atk, 1.47,
		\amp, 1, \surface, 0.85, \freq, 1213, \entropy, 0.54,
		\dur, Pbrown(0.2, 0.6, 0.05)
	)
));

~dechlorPatternList.add(PatternProxy(
	Pbind(\instrument, \cDechlor,
		\sus, 1.929, \rel, 1.263, \speed, 0.17, \atk, 1.518, \amp, 1,
		\surface, 0.57, \freq, 213.1, \entropy, 0.31,
		\dur, Pbrown(2.2, 4.6, 0.5)
	)
));

~dechlorPatternList.add(PatternProxy(
	Pbind(\instrument, \cDechlor,
		\sus, 1.652, \rel, 1.7, \speed, 0.2, \atk, 0.444, \amp, [0.9, 0.1],
		\surface, 0.41, \freq, [1208.3, 2400], \entropy, 0.68,
		\dur, Pbrown(2, 8, 1.5)
	)
));

~dechlorPatternList.add(PatternProxy(
	Pbind(\instrument, \cDechlor,
		\legato, 0.05,
		\atk, Pwhite(0.1, 0.2),
		\dec, 0.02,
		\sus, 0.01,
		\rel, Pwhite(0.1, 0.5),
		\pan, 0,
		\surface, Pbrown(0.1, 0.8, 0.1),
		\dur, Pseq([0.1, 0.2]),
		\mod, 0.8,
		\freq, [50, 170.5],
		\amp, 0.75,
	)
));

///////////////// Drack ////////////////////

~drackPatternList.add(PatternProxy(
	Pbind(\instrument, \cDrack,
		\legato, 0.5,
		\atk, 0.1,
		\dec, 0.2,
		\sus, 0.8,
		\rel, 0.5,
		\pan, 0,
		\lpf, 3000,
		\surface, 0.45,
		\density, 0.5,
		\entropy, Penv([0.9, 0.1], [20]),
		\dur, 0.20,
		\mod, 0.8,
		\freq, [400, 880],
		\amp, 0.9,
	)
));

~drackPatternList.add(PatternProxy(
	Pbind(\instrument, \cDrack,
		\legato, 0.5,
		\atk, 0.05,
		\dec, 0.2,
		\sus, 0.3,
		\rel, 0.2,
		\pan, 0,
		\lpf, 3800,
		\surface, 0.15,
		\density, 0.75,
		\entropy, 0.5,
		\dur, Pseq([0.1, 0.15]),
		\mod, 0.8,
		\freq, [400, 880],
		\amp, 0.7,
	)
));

~drackPatternList.add(PatternProxy(
	Pbind(\instrument, \cDrack,
		\legato, 0.5,
		\atk, 0.1,
		\dec, 0.2,
		\sus, 0.8,
		\rel, 0.5,
		\pan, 0,
		\lpf, 1700,
		\surface, 0.65,
		\density, 0.35,
		\entropy, 0.8,
		\dur, Pseq([0.1, 0.3], inf),
		\mod, 0.8,
		\freq, [400, 900],
		\amp, 3,
	)
));

~drackPatternList.add(PatternProxy(
	Pbind(\instrument, \cDrack,
		\legato, 0.75,
		\atk, 0.1,
		\dec, 0.2,
		\sus, 0.8,
		\rel, 0.5,
		\pan, 0,
		\lpf, 3000,
		\surface, 0.75,
		\density, 0.8445,
		\entropy, 0.24,
		\dur, Pseq([1, 0.25, 0.125], inf),
		\mod, 0.1,
		\freq, [400, 800],
		\amp, 1,
	)
));

////////////////// Eithne //////////////////

~eithnePatternList.add(Pbind(
	\instrument, \cEithne,
	\legato, 0.75,
	\atk, 0.2, //Penv([0.4, 2.0], [20]),
	\dec, 0.2,
	\sus, 0.1,
	\rel, 0.3,
	\pan, 0,
	\dur, Pseq([0.1, 0.2]),
	\curve, -10,
	\freq, 1201,
	\sinFreq, Pseq([60, 80], inf),
	\amp, Penv([ 0.1, 12, 0, 14.4, 0.05 ], [2, 4, 6, 3])
));

~eithnePatternList.add(Pbind(
	\instrument, \cEithne,
	\legato, 0.65,
	\atk, Penv([0.1, 0.2], [40], 'exp'),
	\dec, 0.2,
	\sus, 0.5,
	\rel, Pwhite(0.1, 0.3),
	\pan, 0,
	\dur, 0.1,
	\freq, Pwhite(800.00, 1200.00),
	\amp, Pseq([Pn(Pwhite(1.4, 0.8), 16), Penv([0.0, 1.0, 0.0, 0.8, 0.0], [5, 7, 9, 13])], inf)
));

~eithnePatternList.add(PatternProxy(
	Pbind(\instrument, \cEithne,
		\legato, 0.75,
		\atk, Penv([0.1, 2.0], [20], 'exp'),
		\dec, 0.8,
		\hipass, Pwhite(100, 2000),
		\sus, 0.2,
		\rel, 0.2,
		\pan, 0,
		\dur, 0.05,
		\freq, Pwhite(1000.00, 1200.00),
		\sinFreq, Pseq([80, 90], inf),
		\amp, Penv([0.0, 1.0, 0.0, 2, 0.0], [5, 7, 9, 13], 8),
	)
));

~eithnePatternList.add(PatternProxy(
	Pbind(\instrument, \cEithne,
	\sus, 1.553, \rate, 22.8, \atk, 0.237,
	\freq, 1127.5, \rel, 0.116, \amp, 0.857,
	\dur, Pbrown(0.1, 0.5)
	)
));


//////////////////// fm ////////////////////

~fmPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cFm,
		\freq, 22.3, \rel, 1.198,
		\sus, 0.546, \mod, 2.12, \freqa, 81.4,
		\amp, 0.595, \freqb, 215, \atk, 2.125,
		\freqc, 258.5, \freqd, 205.4,
		\dur, 1,
		\legato, 0.7
	)
));

~fmPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cFm,
		\freq, 22.3, \rel, 1.198, \sus, 0.546, \mod, 3.12,
		\freqa, 81.4, \amp, 0.595, \freqb, 215, \atk, 1.125,
		\freqc, 258.5, \freqd, 205.4,
		\dur, 3.5, \legato, 0.7
	)
));

~fmPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cFm,
		\freq, 104.8, \rel, 0.197, \sus, 0.182, \mod, Env([1.1, 5], [25]), \freqa, 72.7, \amp, 0.244,
		\freqb, 32.3, \atk, 1.321, \freqc, 3253.1, \freqd, 5496.1,
		\dur, Pseq( [ Penv([0.1, 8, 1], [12, 32]), Pwhite(4, 8)])
	)
));

~fmPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cFm,
		\rel, 0.0622, \sus, 0.447, \mod, 1.35, \freqa, 87.4,
		\amp, 0.309, \freqb, 471.2, \atk, 0.162, \freqc, 761.7, \freqd, 354.5,
		\freq, Pwhite(23, 27),
		\dur, Pwhite(4, 6)
	)
));

///////////////// fmAst ////////////////////

~fmAstPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cFmAst,
		\freq, [30, 50],
		\legato, 0.3,
		\amp, Pn(Penv([0.0, 1, 0.2, 0.0], [3,4,3], 4)),
		\atk, 1.4,
		\dec, 0.1,
		\sus, 0.8,
		\dur, 0.1,
		\rel, 0.2,
		\modFreq, [100, 3000],
		\rateFrom, 2,
		\rateTo, 12,
		\curve, 1
	)
));

~fmAstPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cFmAst,
		\freq, [30, 50],
		\legato, 0.3,
		\amp, Pn(Penv([0.0, 1, 0.2, 0.0], [3,4,3], 4)),
		\atk, 1.4,
		\dec, 0.1,
		\sus, 0.8,
		\dur, 0.1,
		\rel, 0.2,
		\modFreq, [100, 3000],
		\rateFrom, 2,
		\rateTo, 12,
		\curve, 1
	)
));

~fmAstPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cFmAst,
		\freq, [30, 50],
		\legato, 0.3,
		\amp, Pn(Penv([0.0, 1, 0.2, 0.0], [3,4,3], 4)) * 0.25,
		\atk, 1.4,
		\dec, 0.1,
		\sus, 0.8,
		\dur, 0.5,
		\rel, 0.2,
		\modFreq, 2000,
		\rateFrom, 4,
		\rateTo, 12,
		\curve, 1
	)
));

~fmAstPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cFmAst,
		\freq, [30, 45],
		\legato, 0.3,
		\amp, Pn(Penv([0.0, 1, 0.2, 0.0], [3,4,3], 4)) * 0.25,
		\atk, 1.4,
		\dec, 0.1,
		\sus, 0.8,
		\dur, 0.2,
		\rel, 0.2,
		\modFreq, 180,
		\rateFrom, 4,
		\rateTo, 12,
		\curve, 1
	)
));

/////////////// gbMan /////////////////////


~gbManPatternList.add(PatternProxy(
	Pbind(\instrument, \cGbman,
		\sus, 0.62, \rel, 1.2, \atk, 0.37, \modFreq, 94, \dec, 0.29, \curve, 0.5, \freq, 623,
		\amp, Pn(Penv([0.0001, 0.4, 0.0001],[15, 8], 'exp'), 2),
        \dur, Pbrown(0.15, 0.4, 0.002)
	)
));

~gbManPatternList.add(PatternProxy(
	Pbind(\instrument, \cGbman,
		\sus, 0.62, \rel, 1.2, \atk, 0.37, \modFreq, 94, \dec, 0.29, \curve, 0.5, \freq, [603, 1623],
		\amp, Pn(Penv([0.0001, 0.3, 0.0001],[25, 18], 'exp')),
        \dur, Pbrown(0.2, 0.6, 0.02)
	)
));

~gbManPatternList.add(PatternProxy(
	Pbind(\instrument, \cGbman,
		\sus, 0.62, \rel, 1.96, \atk, 0.27, \modFreq, 94, \dec, 0.79, \curve, 0.5, \freq, [201, 1892],
		\amp, Pn(Penv([0.01, 0.15, 0.0],[10, 2])),
        \dur, Pbrown(0.15, 0.4, 0.002)
	)
));

~gbManPatternList.add(PatternProxy(
	Pbind(\instrument, \cGbman,
		\sus, 0.62, \rel, 1.96, \atk, 0.27, \modFreq, 94, \dec, 0.79, \curve, 0.5, \freq, 1423,
		\amp, Pn(Penv([0.01, 0.01, 0.0],[10, 22])),
        \dur, Pbrown(0.15, 0.4, 0.002)
	)
));

///////////////// ModPal //////////////////////


~modPalPatternList.add(PatternProxy(
	Pbind(\instrument, \cModpal,
		\sus, 0.32, \rel, 0.78, \atk, 0.12,  \dec, 2.16, \curve, 0.5, \freq, 600, \ampModFreq, 0.5,
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.08, 0.155, 0.133, 0.19, 0.25, 0.15, 0.0], [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Env([0.0, 0.1, 0.8, 0.01], [20, 10, 70]),
		\dur, Pbrown(0.05, 0.2, 0.001)
	)
));

~modPalPatternList.add(PatternProxy(
	Pbind(\instrument, \cModpal,
		\sus, 0.32, \rel, 0.78, \atk, 0.12, \dec, 2.16, \curve, 0.5, \freq, [601/6, 601], \ampModFreq, Env([16, 2], [20]),
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.2, 0.155, 0.333, 0.19, 0.25, 0.15, 0.0] * 0.6, [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Pn(Penv([0.0, 0.75, 0.0],[10, 15])),
		\dur, Pbrown(0.05, 0.4, 0.001)
	)
));

~modPalPatternList.add(PatternProxy(
	Pbind(\instrument, \cModpal,
		\sus, 0.32, \rel, 0.48, \atk, 0.08,  \dec, 2.16, \curve, 0.5, \freq, [600/8, 300 + (600/32)], \ampModFreq, 5.5,
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.2, 0.155, 0.333, 0.19, 0.25, 0.15, 0.0], [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Pn(Penv([0.0, 0.75, 0.0],[10, 15])),
		\dur, Pbrown(0.05, 0.2, 0.001) + Env([1, 2, 0.1],[20, 30])
 	)
));

~modPalPatternList.add(PatternProxy(
	Pbind(\instrument, \cModpal,
		\sus, 0.32, \rel, 0.78, \atk, 0.08,  \dec, 2.16, \curve, 0.5, \freq, [600/4, 300 + (600/3)], \ampModFreq, 5.5,
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.2, 0.155, 0.333, 0.19, 0.25, 0.15, 0.0], [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Pn(Penv([0.0, 0.75, 0.0],[10, 15])),
		\dur, Pbrown(0.05, 0.2, 0.001) * Env([1, 10, 0.3],[10, 15]),
		\rel, Pkey(\dur).linlin(0.05, 0.2, 0.1, 0.8)
 	)
));


///////////////// Opal /////////////////////

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\legato, 0.05,
		\atk, Pwhite(0.2, 0.7),
		\dec, 0.02,
		\sus, 0.01,
		\rel, Pwhite(0.1, 0.5),
		\pan, 0,
		\dur, Pseq([0.1, 0.2]),
		\mod, 0.8,
		\freq, [50, 170.5],
		\amp, 2,
	)
));

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\legato, 0.03,
		\atk, Pwhite(0.25, 0.27),
		\dec, 0.02,
		\sus, 0.02,
		\rel, Pwhite(0.6, 0.7),
		\pan, 0,
		\dur, Pseq([0.1, 0.2], inf),
		\mod, 0.8,
		\freq, [50, 601],
		\amp, 0.6,
	)
));

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\legato, 0.1,
		\atk, Pwhite(0.1, 0.4),
		\dec, 0.2,
		\sus, 0.8,
		\rel, Pwhite(0.1, 1.0),
		\pan, 0,
		\dur, Pseq([0.1, 0.15]),
		\mod, 0.8,
		\freq, [30, 341],
		\amp, Pexprand(0.01, 0.75),
	)
));

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\legato, 0.1,
		\atk, Pwhite(0.1, 0.3),
		\dec, 0.2,
		\sus, 0.4,
		\rel, Pwhite(0.5, 1.2),
		\pan, 0,
		\dur, Pseq([0.05, 0.15]),
		\mod, 0.8,
		\freq, [60, 170.5],
		\amp, Pexprand(0.01, 0.75),
	)
));

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\sus, 0.32, \rel, 0.78, \atk, 0.12,  \dec, 2.16, \curve, 0.5, \freq, 600, \ampModFreq, 15.5,
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.08, 0.155, 0.133, 0.19, 0.25, 0.15, 0.0], [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Env([0.0, 0.1, 0.8, 0.01], [20, 10, 70]),
		\dur, Pbrown(0.05, 0.2, 0.001)
	)
));

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\sus, 0.32, \rel, 0.78, \atk, 0.12,  \dec, 2.16, \curve, 0.5, \freq, [601/6, 601], \ampModFreq, Env([16, 2], [20]),
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.2, 0.155, 0.333, 0.19, 0.25, 0.15, 0.0] * 0.6, [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Pn(Penv([0.0, 0.75, 0.0],[10, 15])),
		\dur, Pbrown(0.05, 0.4, 0.001)
	)
));

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\sus, 0.32, \rel, 0.78, \atk, 0.08,  \dec, 2.16, \curve, 0.5, \freq, [600/8, 600 + (600/8)], \ampModFreq, 5.5,
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.2, 0.155, 0.333, 0.19, 0.25, 0.15, 0.0], [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Pn(Penv([0.0, 0.75, 0.0],[10, 15])),
		\dur, Pbrown(0.05, 0.2, 0.001) + Env([1, 2, 0.1],[20, 30])
 	)
));

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\sus, 0.12, \rel, 0.08, \atk, 0.08,  \dec, 0.16, \curve, 0.5, \freq, [600/4, 600 + (600/3)], \ampModFreq, 5.5,
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.2, 0.155, 0.333, 0.19, 0.25, 0.15, 0.0], [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Pn(Penv([0.0, 0.75, 0.0],[10, 15])),
		\dur, Pbrown(0.05, 0.2, 0.001) * Env([1, 10, 0.3],[10, 15]),
		\rel, Pkey(\dur).linlin(0.05, 0.2, 0.1, 0.8)
 	)
));

~opalPatternList.add(PatternProxy(
	Pbind(\instrument, \cOpal,
		\sus, 0.32, \rel, 0.018, \atk, 0.04,  \dec, 0.16, \curve, 0.5, \freq, 600/4, \ampModFreq, 0.5,
		\modFreq, Penv([1969, 1968, 1900], [20, 68]),
		\amp, Env([0.0, 0.2, 0.155, 0.333, 0.19, 0.25, 0.15, 0.0], [6, 12, 25, 16, 15, 6, 20]),
		\ampModAmt, Env([0.0, 0.1, 0.8, 0.01], [20, 10, 70]),
		\dur, Env([0.1, 0.25, 0.08, 0.15, 0.5],[5, 15, 10, 15] * 0.1)
	)
));


//////////////// Plipar //////////////////////////

~pliparPatternList.add(PatternProxy(
	Pbind(\instrument, \cPlipar,
		\legato, 0.1,
		\atk, Pn(Penv([0.01, 0.05, 0.02], [10, 15])),
		\dec, 0.2,
		\sus, 0.2,
		\rel, Pwhite(0.01, 0.2),
		\pan, 0,
		\dur, Pn(Penv([0.05, 0.1, 0.02], [10, 15])),
		\mod, 0.4,
		\freq, Pseq([100, 2000, 1250], inf),
		\amp, Pseq([2, 1.75, 1.3], inf),
	)
));

~pliparPatternList.add(PatternProxy(
	Pbind(\instrument, \cPlipar,
		\legato, 0.1,
		\atk, 0.04,
		\dec, 0.2,
		\sus, 0.2,
		\rel, Pwhite(0.01, 0.2),
		\pan, 0,
		\dur, Pbrown(0.03, 0.09),
		\mod, 0.4,
		\freq, Pseq([100, 1800, 1250], inf),
		\amp, Pseq([1.2, 3, 2.6], inf),
	)
));

~pliparPatternList.add(PatternProxy(
	Pbind(\instrument, \cPlipar,
	\legato, 0.6,
	\duration, 1.863, \rel, 0.085, \freq, 1260.5, \sus, 0.956,
	\numHarmonics, 17, \atk, 0.04, \amp, 0.85,
	\dur, Pn(Penv([0.05, 0.2, 0.02], [10, 15])),

	)
));

~pliparPatternList.add(PatternProxy(
	Pbind(\instrument, \cPlipar,
	\legato, 0.2,
	\duration, 2.863, \rel, 0.105,
	\freq, Pseq([3800, 1250], inf),
	\sus, 0.956,
	\numHarmonics, 27, \atk, 0.04, \amp, 1.45,
	\dur, Pseq([Pwhite(0.04, 0.08, 35), Pwhite(0.1, 0.2, 12), Pn(Penv([0.05, 0.2, 0.02], [4, 5]))])
	)
));

~pliparPatternList.add(PatternProxy(
	Pbind(\instrument, \cPlipar,
	\duration, 0.1, \rel, 0.986, \freq, 53.7, \sus, 0.37,
	\numHarmonics, 30, \atk, 1.644, \amp, 0.7,
    \dur, 8
	)
));

~pliparPatternList.add(PatternProxy(
	Pbind(\instrument, \cPlipar,
	\lop, 3000,
	\duration, Pwhite(3, 5, inf), \rel, 0.986, \freq, [1800, 1250], \sus, 0.37,
	\numHarmonics, 30, \atk, 1.644, \amp, 0.2,
    \dur, 8
	)
));

///////////////// SineFB ////////////////////

~sineFbPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cSineFB,
		\legato, 0.9,
		\atk, Pwhite(0.4, 1.2),
		\dec, 1,
		\sus, Pwhite(1, 2),
		\rel, Pwhite(0.8, 2.5),
		\dur, Pseq([1.5, 3], inf),
		\freq, Pseq([Pn(400, 10), Pn(404, 20), Pn(408, 20), Pn(432, 32)], inf),
		\feedbackb, Pn(Penv([0.7, 0.9, 0.6], [4, 5])),
		\brFreq, Pn(Penv([400, 2000, 100], [8, 15])),
		\amp, 0.8,
	)
));

~sineFbPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cSineFB,
		\legato, 0.9,
		\atk, Pwhite(0.2, 0.6),
		\dec, 1,
		\sus, Pwhite(1, 2),
		\rel, Pwhite(0.1, 0.2),
		\ampModFreq, Pn(Penv([10, 25, 1], [8, 15])),
		\dur, Pn(Penv([0.5, 2.5, 0.1], [8, 15])),
		\freq, Pseq([Pn(430, 10), Pn(425, 20)], inf),
		\amp, 0.9,
	)
));

~sineFbPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cSineFB,
		\legato, 0.5,
		\dec, 1,
		\sus, 1,
		\rel, 0.2,
		\dur, Pseq([Penv([0.2, 2.5, 0.1], [8, 4]), Pseq([Pbrown(0.75, 2, 0.1, 10), Pwhite(0.08, 0.16, 100)])], inf),
		\atk, Pfunc {|ev| if(ev.dur < 0.15, {0.1}, {0.5}) },
		\freq, [400, 1900],
	    \ampModFreq, 30,
		\feedbackb, 0.9,
		\feedbacka, Pn(Penv([0.2, 0.8, 0.1], [10, 12])),
		\brFreq, Pn(Penv([200, 2000, 100], [10, 12])),
		\amp, [0.8, 0.2],
	)
));

~sineFbPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cSineFB,
		\legato, 0.9,
		\atk, Pwhite(0.2, 0.8),
		\dec, 1,
		\sus, Pwhite(1, 2),
		\rel, Pwhite(0.1, 0.55),
		\dur, Pseq([1/8, 1/8, 1, 1/4, 1/16]),
		\freq, Pwhite(200, 210),
		\feedbacka, 1.8,
		\feedbackb, Pwhite(0.2, 1.2),
		\brFreq, Pwhite(200, 2000),
		\amp, [0.8, 0.2] * Pwhite(0.01, 1.2)
	)
));

~sineFbPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cSineFB,
		\legato, 0.8,
		\sus, 0.418, \ampModFreq, 14.59, \rel, 1.035, \atk, 0.933,
		\feedbackb, 0.32, \freq, 446.4, \amp, 1.19, \feedbacka, 0.86,
		\ampModAmt, 0.93, \dur, 6,
		\brFreq, 200
	)
));

~sineFbPatternList.add(PatternProxy(
	Pbind(
		\instrument, \cSineFB,
		\sus, 0.109, \ampModFreq, 49.51, \rel, 1.356, \atk, 1.986,
		\feedbackb, 0.54, \freq, 375.4, \amp, 1.19, \feedbacka, 0.4,
		\ampModAmt, 0.73, \dur, 6,
		\brFreq, 200
	)
));


////////////////////////////////////////////

patterns["SineFB"] = ~sineFbPatternList;
patterns["Plipar"] = ~pliparPatternList;
patterns["ModPal"] = ~modPalPatternList;
patterns["Opal"] = ~opalPatternList;
patterns["GmMan"] = ~gbManPatternList;
patterns["FmAst"] = ~fmAstPatternList;
patterns["Fm"] = ~fmPatternList;
patterns["Eithne"] = ~eithnePatternList;
patterns["Drack"] = ~drackPatternList;
patterns["Croft"] = ~croftPatternList;
patterns["Brown"] = ~brownPatternList;
patterns["Dechlor"] = ~dechlorPatternList;

PatternLauncherUI(patterns, 12);

)