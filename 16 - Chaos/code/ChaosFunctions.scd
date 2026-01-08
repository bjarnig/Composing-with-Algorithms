////////////////////////////////////////////////////////////////
//
//                       Chaos Functions
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


////////////////////// Plotter Helpers ////////////////////////

(

~plotPattern = {|pattern, count=500|
	var values = pattern.asStream.nextN(count).flatten;
    values.plot(minval: values.minItem.floor,
		maxval: values.maxItem.ceil)
};

~plotSignal = {|signal, duration=2|
	signal.plot(duration)
};

~plotStream = {|stream, count=500|
	var values = stream.nextN(count).flat;
    values.plot(minval: values.minItem.floor,
		maxval: values.maxItem.ceil)
};

~playStreamFreq = {|stream, delta=0.1, times=inf|

	Routine {
		times.do {
			var freq = stream.next();
			Synth(\perc, [\freq, freq]);
			delta.wait
		}
	}.play
}

)


//////////////////////// Iterative functions ///////////////////////

(

// Logistic Map

~logistic = {|r = 3.81699451, x = 0.5, average=1000|
	Routine {

		inf.do
		{
			x = r * x * (1 - x);
			(x * average).yield
		}
	}
};

// Sine Map

~sineMap = {|a = 3.14, b=0.125, r=1.1, x = 0.15, average=1000|
	Routine {

		inf.do
		{
			x = sin(x * a * b * 2.0 * r) * 0.5 + 0.5;
			x.yield;
			(x * average).yield
		}
	}
};

// Tent Map

~tent = {|r=0.92, x = 0.25, average=1000|
	Routine {

		inf.do
		{
			if(x <= 0.5, { x = 2.0 * r * x }, {x = 2 * r * (1.0 - x) });
			x.yield;
			(x * average).yield
		}
	}
};

//  Lehmer's Congruential

~lehmer = {|a = 3.14, b=0.25, m=1.0, x = 0.5, average=1000|
	Routine {

		inf.do
		{
			x = a * x + b % m;
			x.yield;
			(x * average).yield
		}
	}
};

// Hénon Map (2D chaotic attractor)

~henon = {|a = 1.4, b = 0.3, x = 0.1, y = 0.1, average=1000|
	Routine {
		inf.do {
			var xn = 1 - (a * x * x) + y;
			var yn = b * x;
			x = xn; y = yn;
			((x + 1.5) / 3 * average).yield  // normalize to positive
		}
	}
};

// Ikeda Map (laser physics chaotic system)

~ikeda = {|u = 0.9, x = 0.1, y = 0.1, average=1000|
	Routine {
		inf.do {
			var t = 0.4 - (6 / (1 + (x*x) + (y*y)));
			var xn = 1 + (u * ((x * cos(t)) - (y * sin(t))));
			var yn = u * ((x * sin(t)) + (y * cos(t)));
			x = xn; y = yn;
			((x.abs + y.abs) / 4 * average).yield
		}
	}
};

// Gingerbreadman Map (2D symmetric attractor)

~gingerbread = {|x = 0.1, y = 0.1, average=1000|
	Routine {
		inf.do {
			var xn = 1 - y + x.abs;
			var yn = x;
			x = xn; y = yn;
			((x.abs + y.abs) / 10 * average).yield
		}
	}
};

// Tinkerbell Map (continuous 2D chaos)

~tinkerbell = {|a = 0.9, b = -0.6013, c = 2.0, d = 0.5, x = -0.72, y = -0.64, average=1000|
	Routine {
		inf.do {
			var xn = (x*x) - (y*y) + (a*x) + (b*y);
			var yn = (2*x*y) + (c*x) + (d*y);
			x = xn.clip(-10, 10);
			y = yn.clip(-10, 10);
			((x.abs + y.abs) / 4 * average).yield
		}
	}
};

// Duffing Map (discrete Duffing oscillator)

~duffing = {|a = 2.75, b = 0.15, x = 0.1, y = 0.1, average=1000|
	Routine {
		inf.do {
			var xn = y;
			var yn = (a.neg * x) + (b * y) - (y * y * y);
			x = xn.clip(-2, 2);
			y = yn.clip(-2, 2);
			((x + 2) / 4 * average).yield
		}
	}
};

)

///////////////////////// Classic Maps /////////////////////////

~plotStream.value(~logistic.value(3.8))

~plotStream.value(~sineMap.value(2.2))

~plotStream.value(~tent.value)

~playStreamFreq.value(~logistic.value(3.9))

~playStreamFreq.value(~lehmer.value(10))

~playStreamFreq.value(~tent.value(0.55))


///////////////////////// Chaotic Attractors /////////////////////////

~plotStream.value(~henon.value(1.4, 0.3))

~plotStream.value(~ikeda.value(0.9))

~plotStream.value(~gingerbread.value)

~plotStream.value(~tinkerbell.value)

~plotStream.value(~duffing.value(2.75, 0.15))

~playStreamFreq.value(~henon.value(1.38))

~playStreamFreq.value(~ikeda.value(0.85))

~playStreamFreq.value(~gingerbread.value)

~playStreamFreq.value(~tinkerbell.value)

~playStreamFreq.value(~duffing.value(2.5, 0.2))
