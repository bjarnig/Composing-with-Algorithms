////////////////////////////////////////////////////////////////
//
//                      CWA21 - Spawner
//
////////////////////////////////////////////////////////////////

(

var section = Pspawner({|sp|

	sp.par(Pbind(\instrument, \gbman,
		\sus, 0.62, \rel, 0.1, \atk, 0.47, \modFreq, 94, \dec, 0.79, \curve, 0.5, \freq, 2300,
		\amp, Pn(Penv([0.01, 0.8, 0.0],[10, 16], \sine)),
		\dur, Pseq([0.1, 0.2, 0.4, 0.05, 0.2, Pbrown(0.1, 0.4, 0.05, 8)], inf)));

	sp.wait(32);

	sp.par(Pbind(\instrument, \gbman,
		\sus, 0.62, \rel, 1.96, \atk, 0.27, \modFreq, 94, \dec, 0.79, \curve, 0.5,
		\freq, Pn(Penv([1423, 1650], [32])),
		\amp, Pn(Penv([0.01, 0.4, 0.0] * 2,[10, 22])),
		\dur, Pbrown(0.15, 0.4, 0.002, 164)));

	sp.wait(12);

	sp.par(Pbind(\instrument, \gbman,
		\sus, 0.62, \rel, 0.2, \atk, 0.27, \dec, 0.79, \curve, 0.5,
		\freq, Pseq([[601, 1897], [606, 1904], [612, 1909], [617, 1914]], inf),
		\amp, Pseq([Penv([0.02, 0.15, 0.02]*2,[10, 2]), Penv([0.01, 0.19, 0.01]*2,[10, 8]), Pbrown(0.02, 0.08, 0.002, 128)]),
		\dur, Pseq([Pbrown(0.15, 0.2, 0.002, 128), Pbrown(0.05, 0.1, 0.002, 128)], inf)));

});

if(~sectionPlayer.isPlaying, {
	~section.source = PatternProxy(section);
}, {
	~section = PatternProxy(section);
	~sectionPlayer = Pseq([~section], 1).play(TempoClock.new(140 / 60))
});

)
