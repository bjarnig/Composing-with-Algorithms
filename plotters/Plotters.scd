////////////////////////////////////////////////////////////////
//
//                        Plotters
//
////////////////////////////////////////////////////////////////


/*

UserView / Pen plotters for the things SuperCollider does not draw by itself:
bifurcation diagrams, phase portraits and a live event scatter.

For waveforms and spectra use the stock tools instead, they are already good:

	Signal.sineFill(512, [1, 0, 1/3]).plot;   // a wavetable
	{ SinOsc.ar(200) }.plot(0.02);            // a moment of a signal
	FreqScope.new;                            // running spectrum
	s.scope;                                  // running scope

The compute and the draw halves are kept apart on purpose: the ~...Points
functions are plain data, so they can be checked without opening a window,
and the ~plot... functions only turn points into pixels.

Palette matches the course decks and the Accrete/Ora scopes.

*/


( // Evaluate this one block to load every plotter

~plotColor = (
	bg:     Color.new255(23, 27, 33),
	ink:    Color.new255(120, 165, 210),
	mint:   Color.new255(140, 225, 180),
	gold:   Color.new255(210, 185, 95),
	rose:   Color.new255(210, 120, 120),
	muted:  Color.new255(154, 164, 181),
	edge:   Color.new255(80, 88, 100)
);

// Map a value from one range onto another, clipping to the target.
~plotMap = {|value, inLo, inHi, outLo, outHi|
	var t = if(inHi == inLo, 0, { (value - inLo) / (inHi - inLo) });
	(outLo + (t.clip(0, 1) * (outHi - outLo)))
};

// Count values into equal bins across [lo, hi]. Returns an Array of counts.
~plotHistogram = {|values, lo, hi, bins = 40|
	var counts = Array.fill(bins, 0);
	values.do {|v|
		var t;
		if(v.isNumber and: { v.isNaN.not }) {
			t = if(hi == lo, 0, { (v - lo) / (hi - lo) });
			t = t.clip(0, 0.9999);
			counts[(t * bins).floor.asInteger] = counts[(t * bins).floor.asInteger] + 1;
		}
	};
	counts
};



////////////////////// Computation: points only //////////////////////

/*
Bifurcation points for a one dimensional map.

mapFunc takes the current value and the swept parameter and returns the next
value: { |x, r| r * x * (1 - x) }

Returns [params, values] as two FloatArrays, one entry per plotted point.
*/
~bifurcationPoints = {|mapFunc, paramLo = 2.4, paramHi = 4.0, x0 = 0.5,
	columns = 460, transient = 200, keep = 90|

	var params = FloatArray.new(columns * keep);
	var values = FloatArray.new(columns * keep);

	columns.do {|i|
		var r = paramLo + ((paramHi - paramLo) * (i / (columns - 1).max(1)));
		var x = x0;
		// let the orbit settle before anything is recorded
		transient.do { x = mapFunc.value(x, r) };
		keep.do {
			x = mapFunc.value(x, r);
			if(x.isNumber and: { x.isNaN.not and: { x.abs < 1e6 } }) {
				params = params.add(r);
				values = values.add(x);
			}
		};
	};

	[params, values]
};

/*
Phase portrait points for a two dimensional map.

mapFunc takes x and y and returns the next pair: { |x, y| [1 - (1.4 * x * x) + y, 0.3 * x] }

Returns [xs, ys] as two FloatArrays.
*/
~phasePoints = {|mapFunc, x0 = 0.1, y0 = 0.1, transient = 400, keep = 12000, limit = 1e6|
	var xs = FloatArray.new(keep), ys = FloatArray.new(keep);
	var x = x0, y = y0, pair;

	transient.do {
		pair = mapFunc.value(x, y);
		x = pair[0]; y = pair[1];
	};

	// block/break, because assigning to keep cannot stop a do loop that has
	// already been given its count
	block {|break|
		keep.do {
			pair = mapFunc.value(x, y);
			x = pair[0]; y = pair[1];
			if(x.isNaN or: { y.isNaN } or: { x.abs > limit } or: { y.abs > limit }) {
				break.value    // the orbit has escaped; stop rather than plot nonsense
			};
			xs = xs.add(x); ys = ys.add(y);
		};
	};

	[xs, ys]
};


////////////////////////////// Drawing ///////////////////////////////

/*
Scatter of xs against ys. Used by both the bifurcation diagram and the phase
portrait, since both are just a lot of small points in a box.
*/
~plotScatter = {|xs, ys, title = "plot", xLabel = "x", yLabel = "y",
	width = 900, height = 460, dotColor, marker|

	var window, view, margin = 42;
	var xLo, xHi, yLo, yHi;
	var colour = dotColor ? ~plotColor[\ink];

	xLo = xs.minItem; xHi = xs.maxItem;
	yLo = ys.minItem; yHi = ys.maxItem;

	window = Window(title, Rect(140, 140, width, height))
		.background_(~plotColor[\bg])
		.front;

	view = UserView(window, Rect(0, 0, width, height))
		.background_(~plotColor[\bg])
		.drawFunc_({|v|
			var w = v.bounds.width, h = v.bounds.height;
			var left = margin, right = w - 12, top = 12, bottom = h - margin;

			// frame
			Pen.strokeColor = ~plotColor[\edge];
			Pen.width = 1;
			Pen.addRect(Rect(left, top, right - left, bottom - top));
			Pen.stroke;

			// all points in one fill: far faster than filling each separately
			Pen.fillColor = colour.copy.alpha_(0.35);
			xs.size.do {|i|
				var px = ~plotMap.value(xs[i], xLo, xHi, left, right);
				var py = ~plotMap.value(ys[i], yLo, yHi, bottom, top);   // y up
				Pen.addRect(Rect(px, py, 1, 1));
			};
			Pen.fill;

			// a vertical marker, for "the parameter is here"
			if(marker.notNil) {
				Pen.strokeColor = ~plotColor[\gold];
				Pen.width = 1.5;
				Pen.line(
					Point(~plotMap.value(marker, xLo, xHi, left, right), top),
					Point(~plotMap.value(marker, xLo, xHi, left, right), bottom)
				);
				Pen.stroke;
			};

			// axes
			Pen.stringAtPoint(
				xLabel ++ ":  " ++ xLo.round(0.001) ++ " to " ++ xHi.round(0.001),
				Point(left, bottom + 8),
				Font("Helvetica", 10), ~plotColor[\muted]
			);
			Pen.stringAtPoint(
				yLabel ++ ":  " ++ yLo.round(0.001) ++ " to " ++ yHi.round(0.001),
				Point(left, bottom + 22),
				Font("Helvetica", 10), ~plotColor[\muted]
			);
			Pen.stringAtPoint(
				xs.size.asString ++ " points",
				Point(right - 90, top + 2),
				Font("Helvetica", 10), ~plotColor[\muted]
			);
		});

	window
};

// Bifurcation diagram: sweep the parameter, plot the attractor vertically.
~plotBifurcation = {|mapFunc, paramLo = 2.4, paramHi = 4.0, x0 = 0.5,
	marker, title = "bifurcation", columns = 460, transient = 200, keep = 90|

	var pts = ~bifurcationPoints.value(mapFunc, paramLo, paramHi, x0, columns, transient, keep);
	~plotScatter.value(pts[0], pts[1], title, "parameter", "x",
		900, 460, ~plotColor[\ink], marker)
};

// Phase portrait: x against y for a two dimensional map.
~plotPhase = {|mapFunc, x0 = 0.1, y0 = 0.1, title = "phase portrait",
	transient = 400, keep = 12000|

	var pts = ~phasePoints.value(mapFunc, x0, y0, transient, keep);
	~plotScatter.value(pts[0], pts[1], title, "x", "y",
		700, 700, ~plotColor[\mint], nil)
};


///////////// Live event scatter: time, pitch, amplitude /////////////

/*
Returns an Event with .add and .window. Feed it from a Routine or a Pbind:

	~ep = ~eventPlotter.value;
	Pbind(
		\instrument, \perc,
		\dur, Pwhite(0.08, 0.3),
		\freq, Pwhite(200, 900),
		\amp, Pwhite(0.1, 0.4)
	).collect {|ev| ~ep[\push].value(ev[\freq], ev[\amp]); ev }.play;

Use ~ep[\push], not ~ep.push: Event inherits add and clear from Dictionary, so
dot syntax on a colliding key calls the Dictionary method instead of the stored
function. Retrieval with [] always works.
*/
~eventPlotter = {|title = "events", width = 900, height = 420,
	span = 8, freqLo = 100, freqHi = 2000, bins = 40|

	var events = List.new;          // [time, freq, amp]
	var window, view, margin = 42;
	var plotter;

	window = Window(title, Rect(160, 160, width, height))
		.background_(~plotColor[\bg])
		.front;

	view = UserView(window, Rect(0, 0, width, height))
		.background_(~plotColor[\bg])
		.animate_(true)
		.frameRate_(30)
		.drawFunc_({|v|
			var w = v.bounds.width, h = v.bounds.height;
			var left = margin, right = w - 12;
			var splitY = (h * 0.62).round;
			var now = Main.elapsedTime;
			var amps;

			// drop anything older than the visible span
			while({ events.size > 0 and: { events[0][0] < (now - span) } }, {
				events.removeAt(0)
			});

			Pen.strokeColor = ~plotColor[\edge]; Pen.width = 1;
			Pen.addRect(Rect(left, 12, right - left, splitY - 24));
			Pen.stroke;

			// upper: one dot per event, log frequency up the axis
			Pen.fillColor = ~plotColor[\ink].copy.alpha_(0.65);
			events.do {|e|
				var px = ~plotMap.value(e[0], now - span, now, left, right);
				var py = ~plotMap.value(e[1].max(1).log2, freqLo.log2, freqHi.log2,
					splitY - 16, 18);
				var rad = 1.5 + (e[2].clip(0, 1) * 5);
				Pen.addArc(Point(px, py), rad, 0, 2pi);
			};
			Pen.fill;

			// lower: histogram of the frequencies drawn so far
			amps = events.collect {|e| e[1] };
			if(amps.size > 1) {
				var counts = ~plotHistogram.value(amps, freqLo, freqHi, bins);
				var peak = counts.maxItem.max(1);
				var bw = (right - left) / bins;
				Pen.fillColor = ~plotColor[\mint].copy.alpha_(0.75);
				counts.do {|c, i|
					var bh = (c / peak) * (h - margin - splitY - 8);
					if(bh > 0.5) {
						Pen.addRect(Rect(left + (i * bw), h - margin - bh, bw - 1, bh))
					}
				};
				Pen.fill;
			};

			Pen.stringAtPoint(
				"last " ++ span ++ " s,  " ++ freqLo ++ " to " ++ freqHi ++ " Hz,  "
					++ events.size ++ " events",
				Point(left, h - margin + 8),
				Font("Helvetica", 10), ~plotColor[\muted]
			);
		});

	plotter = (
		window: window,
		view: view,
		events: events,
		// call this once per event, as ~ep[\push].value(freq, amp)
		push: {|freq, amp = 0.2|
			events.add([Main.elapsedTime, freq.asFloat, amp.asFloat]);
			if(events.size > 4000) { events.removeAt(0) };
		},
		reset: { events.clear }
	);

	plotter
};

)


////////////////////////// Examples ////////////////////////////


// The logistic map: period doubling, then chaos
~plotBifurcation.value({|x, r| r * x * (1 - x) }, 2.4, 4.0, 0.5, 3.81699451, "logistic map")


// The tent map
~plotBifurcation.value({|x, r| if(x <= 0.5, { 2 * r * x }, { 2 * r * (1 - x) }) },
	0.4, 1.0, 0.25, 0.92, "tent map")


// Henon, as an attractor rather than a time series
~plotPhase.value({|x, y| [1 - (1.4 * x * x) + y, 0.3 * x] }, 0.1, 0.1, "Henon attractor")


// Gingerbreadman, from a seed that is actually on the chaotic orbit
~plotPhase.value({|x, y| [1 - y + x.abs, x] }, -0.1, 0, "gingerbreadman")


// Ikeda
(
~plotPhase.value({|x, y|
	var t = 0.4 - (6 / (1 + (x * x) + (y * y)));
	[1 + (0.9 * ((x * cos(t)) - (y * sin(t)))), 0.9 * ((x * sin(t)) + (y * cos(t)))]
}, 0.1, 0.1, "Ikeda attractor")
)


// Live event scatter, driven by a pattern
(
SynthDef(\perc, {|freq = 440, amp = 0.1|
	var env = EnvGen.ar(Env.perc(0.01, 0.2), 1, doneAction: 2) * amp;
	OffsetOut.ar(0, SinOsc.ar(freq, 0, env) ! 2);
}).add;
)

(
~ep = ~eventPlotter.value("Pwhite events", 900, 420, 8, 150, 1200);

~seq = Pbind(
	\instrument, \perc,
	\dur, Pwhite(0.08, 0.3),
	\freq, Pwhite(200, 900),
	\amp, Pwhite(0.1, 0.4)
).collect {|ev|
	~ep[\push].value(ev[\freq], ev[\amp]);
	ev
}.play;
)

~seq.stop; ~ep[\window].close;
