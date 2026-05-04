/*

	Accrete — presentation demos.
	Five scenes, each independently executable.
	Evaluate one (...) block at a time; stop before moving on.

*/


/*

	Triangle.
	3 nodes in a cycle, one walker loops through them.

*/

(
	var a = Accrete(thisProcess.interpreter);
	var g = AcGraph();

	g.addNode(\invdem, a.behaviours[\invdem], (wfmult: 0.6, seqmult: 10, amp: 0.5));
	g.addNode(\vpay,   a.behaviours[\vpay],   (freq: 10, fmod: 10, ffrom: 20, fto: 2250, index: 0.8, amp: 0.2));
	g.addNode(\pulse,  a.behaviours[\pulse],  (freq: 6, fmod: 800, ffrom: 24, fto: 140, index: 0.9, amp: 0.25));

	g.connect(\invdem, \vpay, 0.8, \succession);
	g.connect(\vpay, \pulse, 0.6, \transformation, Dictionary[\freq -> \freq]);
	g.connect(\pulse, \invdem, 0.5, \succession);

	~t = AcTraversal(\walk, g, { rrand(3.0, 6.0) }, fadeTime: 3);
	~t.walk(\invdem);

	~g = g;
	g.print;
)

// stop
~t.stop; ~g.stopAll;














/*

	Two Walkers.
	A 5-node ring with two independent walkers starting at opposite ends.
	One walks slowly, the other quickly. They overlap and diverge.

*/

(
	var a = Accrete(thisProcess.interpreter);
	var g = AcGraph();
	var ids = [\invdem, \shimmer, \breath, \bell, \rumble];

	g.addNodes([
		[\invdem,  a.behaviours[\invdem],  (wfmult: 0.2, seqmult: 10, amp: 0.35)],
		[\shimmer, a.behaviours[\shimmer], (drive: 22, modLo: 55, modHi: 180, lpfFreq: 2200, amp: 0.12)],
		[\breath,  a.behaviours[\breath],  (mod: 380, mf: 0.28, amp: 0.35)],
		[\bell,    a.behaviours[\bell],    (bfmin: 500, bfmax: 2200, freq: 12, amp: 0.15)],
		[\rumble,  a.behaviours[\rumble],  (rate: 11, trigMin: 350, trigMax: 900, freq: 32, amp: 0.3)],
	]);

	AcGrowth.ring(g, ids);
	ids.do {|from, i| g.connect(ids.wrapAt(i + 1), from, rrand(0.2, 0.5), \variation) };

	~slow = AcTraversal(\slow, g,
		durFunc: { rrand(8.0, 14.0) },
		fadeTime: 5,
		deactivateOnLeave: false
	);
	~fast = AcTraversal(\fast, g,
		durFunc: { rrand(2.0, 4.0) },
		fadeTime: 1.5,
		contrastBias: 0.8
	);

	~slow.walk(\invdem);
	~fast.walk(\bell);

	~g = g;
	g.print;
)

// stop
~slow.stop; ~fast.stop; ~g.stopAll;














/*

	Growing Network.
	Starts with a 3-node seed and rapidly grows to 50+ nodes
	via preferential attachment. Three walkers roam the expanding graph.
	AcScope shows the network evolving live.

*/

(
	var a = Accrete(thisProcess.interpreter);
	var g = AcGraph();
	var walkers;

	var behaviourPool = [
		[\invdem,  { a.behaviours[\invdem] },  { (wfmult: exprand(0.05, 0.8), seqmult: rrand(3, 30), amp: rrand(0.1, 0.4)) }],
		[\vpay,    { a.behaviours[\vpay] },    { (freq: exprand(4, 40), fmod: exprand(2, 60), ffrom: rrand(10, 200), fto: rrand(400, 4000), index: rrand(0.3, 2.0), amp: rrand(0.04, 0.15)) }],
		[\pulse,   { a.behaviours[\pulse] },   { (freq: exprand(2, 24), fmod: exprand(80, 900), ffrom: rrand(8, 80), fto: rrand(40, 400), index: rrand(0.4, 1.4), amp: rrand(0.02, 0.05)) }],
		[\shimmer, { a.behaviours[\shimmer] }, { (drive: rrand(12, 40), modLo: rrand(30, 90), modHi: rrand(90, 350), lpfFreq: exprand(400, 6000), amp: rrand(0.04, 0.12)) }],
		[\rumble,  { a.behaviours[\rumble] },  { (rate: rrand(4, 22), trigMin: rrand(120, 800), trigMax: rrand(400, 2500), freq: exprand(12, 55), amp: rrand(0.03, 0.06)) }],
		[\breath,  { a.behaviours[\breath] },  { (mod: exprand(80, 900), mf: rrand(0.15, 0.45), amp: rrand(0.25, 0.55), from: rrand(1, 6), to: rrand(8, 35)) }],
		[\bell,    { a.behaviours[\bell] },    { (bfmin: exprand(200, 1200), bfmax: exprand(800, 4000), freq: exprand(4, 28), bw: rrand(6, 22), amp: rrand(0.15, 0.45)) }],
		[\crackle, { a.behaviours[\crackle] }, { (dustRate: rrand(40, 220), crackle: rrand(0.75, 1.85), timeUp: rrand(2, 14), timeDown: rrand(3, 16), amp: rrand(0.02, 0.05)) }],
	];

	3.do {|i|
		var spec = behaviourPool.choose;
		g.addNode(("s" ++ i).asSymbol, spec[1].value, spec[2].value);
	};
	AcGrowth.ring(g, [\s0, \s1, \s2]);

	walkers = [
		AcTraversal(\fast, g, { rrand(1.5, 3.0) }, fadeTime: 1, contrastBias: 0.8),
		AcTraversal(\mid,  g, { rrand(3.0, 6.0) }, fadeTime: 2, contrastBias: 0.5,
			deactivateOnLeave: false),
		AcTraversal(\slow, g, { rrand(6.0, 12.0) }, fadeTime: 4, contrastBias: 0.3,
			deactivateOnLeave: false),
	];
	walkers[0].walk(\s0);
	walkers[1].walk(\s1);
	walkers[2].walk(\s2);

	~scope = g.scope(walkers, 900, 900);
	~scope.nodeRadius = 12;

	~grower = Routine({
		var count = 3;
		while { count < 50 } {
			var spec = behaviourPool.choose;
			var id = ("n" ++ count).asSymbol;
			rrand(1.0, 3.0).wait;
			AcGrowth.preferentialAttachment(g, id, spec[1].value, spec[2].value, rrand(1, 3));
			if(0.3.coin and: { g.nodes.size > 5 }) {
				var keys = g.nodes.keys.asArray;
				var a = keys.choose, b = keys.choose;
				if(a != b) { g.connect(a, b, rrand(0.2, 0.8),
					[\succession, \contrast, \variation, \transformation].choose) };
			};
			count = count + 1;
			if(count % 10 == 0) {
				"--- % nodes, % edges ---".format(g.nodes.size, g.edges.size).postln;
			};
		};
		"--- Growth complete: % nodes, % edges ---".format(g.nodes.size, g.edges.size).postln;
	}).play;

	~g = g;
	~walkers = walkers;
)

// re-layout once the graph is large
~scope.layoutForce(150); ~scope.userView.refresh;

// stop
~scope.close; ~grower.stop; ~walkers.do(_.stop); ~g.stopAll;














/*

	Processing Chain.
	All nodes route through a private bus. Processors stack on
	the master Ndef using slot-based filtering. Add, tweak, and
	remove processors live without touching the graph.

*/

(
	var a = Accrete(thisProcess.interpreter);
	var g = AcGraph(2, 0);
	g.initRouting(\master);

	g.addNodes([
		[\invdem,  a.behaviours[\invdem],  (wfmult: 0.2, seqmult: 10, amp: 0.4)],
		[\vpay,    a.behaviours[\vpay],    (freq: 12, fmod: 10, ffrom: 20, fto: 2250, index: 0.8, amp: 0.2)],
		[\pulse,   a.behaviours[\pulse],   (freq: 6, fmod: 380, ffrom: 22, fto: 130, amp: 0.25)],
		[\shimmer, a.behaviours[\shimmer], (drive: 25, modLo: 48, modHi: 200, lpfFreq: 2800, amp: 0.15)],
		[\bell,    a.behaviours[\bell],    (bfmin: 520, bfmax: 2600, freq: 11, amp: 0.15)],
	]);

	AcGrowth.ring(g, [\invdem, \vpay, \pulse, \shimmer, \bell]);

	~t = AcTraversal(\walk, g,
		durFunc: { rrand(4.0, 8.0) },
		fadeTime: 3,
		deactivateOnLeave: false
	);
	~t.walk(\invdem);

	g.addProcess(\verb, a.processing[\verb]);
	g.setProcess(\verb, \room, 40, \damp, 0.4, \mix, 0.4);

	g.addProcess(\fold, a.processing[\fold]);
	g.setProcess(\fold, \foldFreq, 12, \amount, 0.3);

	~g = g;
	~scope = g.scope([~t]);
	g.print;
)

// live tweaking
~g.setProcess(\verb, \mix, 0.7, \room, 80);

(
	var a = Accrete(thisProcess.interpreter);
	~g.addProcess(\shift, a.processing[\shift]);
	~g.setProcess(\shift, \shiftFreq, 50, \mod, 0.3);
)

~g.removeProcess(\fold);
~g.removeProcess(\shift);

// stop
~scope.close; ~t.stop; ~g.free;














/*

	Averse Network.
	Buffer-playback patterns from Averse converted into network behaviours.
	The walker moves through different rhythmic textures.
	Edges decay and regrow; periodic collapses reshape the network.

*/

(
s.waitForBoot {
	var bufferPath = "/Users/bjarni/Library/Application Support/SuperCollider/Extensions/Accrete/examples/perc";
	var a, g;

	a = Accrete(thisProcess.interpreter);

	fork {
		a.loadAverse(thisProcess.interpreter, bufferPath);
		s.sync;

		g = AcGraph(2, 0);
		g.initRouting(\averse);

		g.addNodes(a.averseNames.collect {|name| [name, a.averse[name]] });

		AcGrowth.ring(g, a.averseNames, decayRate: rrand(0.01, 0.04));
		AcGrowth.crossLinks(g, 2, decayRate: rrand(0.02, 0.06));

		~t1 = AcTraversal(\fast1, g,
			durFunc: { rrand(1.0, 3.0) }, fadeTime: 1, contrastBias: 0.7);
		~t2 = AcTraversal(\fast2, g,
			durFunc: { rrand(1.0, 2.5) }, fadeTime: 1, contrastBias: 0.6,
			deactivateOnLeave: false);
		~t3 = AcTraversal(\mid, g,
			durFunc: { rrand(1.5, 3.0) }, fadeTime: 1.5,
			deactivateOnLeave: false);
		~t1.walk(\r01);
		~t2.walk(\s08);
		~t3.walk(\q01);

		~evo = Routine({
			var allBehaviours = g.nodes.collect {|n| [n.id, n.behaviour] };
			var nextCollapse = rrand(3, 5);
			var cycle = 0;
			loop {
				rrand(6.0, 10.0).wait;
				cycle = cycle + 1;

				AcGrowth.decayEdges(g, rrand(2.0, 5.0));

				if(cycle >= nextCollapse and: { g.nodes.size > 4 }) {
					AcGrowth.collapse(g, rrand(3, 6));
					nextCollapse = cycle + rrand(3, 5);
				};

				if(g.nodes.size < 14) {
					var missing = allBehaviours.select {|pair| g.nodes[pair[0]].isNil };
					var toAdd = missing.asArray.scramble.keep(rrand(1, 3).min(missing.size));
					toAdd.do {|pair|
						var existing = g.nodes.keys.asArray;
						g.addNode(pair[0], pair[1]);
						existing.scramble.keep(rrand(2, 3).min(existing.size)).do {|k|
							g.connect(pair[0], k, rrand(0.4, 0.9),
								[\succession, \contrast, \variation, \transformation].choose,
								nil, rrand(0.03, 0.07));
							g.connect(k, pair[0], rrand(0.2, 0.6),
								[\succession, \contrast, \variation, \transformation].choose,
								nil, rrand(0.03, 0.07));
						};
					};
				};

				if(0.3.coin) { AcGrowth.smallWorldRewire(g, 0.15) };
				"--- %: % nodes, % edges ---".format(cycle, g.nodes.size, g.edges.size).postln;
			}
		}).play;

		g.addProcess(\verb, {|in, mix = 0.2, room = 15, damp = 0.6|
			FreeVerb2.ar(in[0], in.last, mix, room / 100, damp)
		});

		~g = g;
		{ ~scope = g.scope([~t1, ~t2, ~t3], 900, 900); ~scope.nodeRadius = 12 }.defer;
		g.print;
	};
}
)

// re-layout
~scope.layoutForce(150); ~scope.userView.refresh;

// stop
~scope.close; ~evo.stop; ~t1.stop; ~t2.stop; ~t3.stop; ~g.free;
