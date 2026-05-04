
// UPIC Multi-Voice — Layer multiple frequency trajectories

(
s.waitForBoot({

	var width = 900, canvasH = 450, waveH = 150;
	var numPoints = 1024;
	var freqMin = 60, freqMax = 6000;
	var duration = 6.0;
	var maxVoices = 24;

	// Palette: #7c616c #d1b1cb #ddcad9 #e5e9ec #eafdf8
	var col1 = Color(0.486, 0.380, 0.424); // #7c616c - dark mauve
	var col2 = Color(0.820, 0.694, 0.796); // #d1b1cb - soft pink
	var col3 = Color(0.867, 0.792, 0.851); // #ddcad9 - light rose
	var col4 = Color(0.898, 0.914, 0.925); // #e5e9ec - pale blue-gray
	var col5 = Color(0.918, 0.992, 0.973); // #eafdf8 - mint white
	var bgColor = Color(0.06, 0.05, 0.055);

	// Stroke colors — variations on the palette
	var colors = [
		col5, col2, col3, col4,
		col5.blend(col2, 0.5), col2.blend(col3, 0.5),
		col3.blend(col4, 0.5), col4.blend(col5, 0.5),
		col5.blend(col3, 0.3), col2.blend(col4, 0.3),
		col3.blend(col5, 0.4), col4.blend(col2, 0.4)
	];

	var strokes = List[];
	var currentStroke = nil;
	var waveBuf;
	var waveData = Array.fill(numPoints, { |i| sin(i / numPoints * 2pi).linlin(-1, 1, 0, 1) });
	var synths = List[];
	var isPlaying = false;
	var cursorPos = nil;
	var canvas, waveView;

	var updateWaveBuf = {
		var mapped = waveData.collect { |v| v * 2 - 1 };
		waveBuf.setn(0, mapped);
	};

	// SynthDef
	SynthDef(\upicVoice, { |out = 0, waveBuf, freqBuf, ampBuf, dur = 6, amp = 0.15, gate = 1|
		var phasor = Line.ar(0, 1, dur, doneAction: 2);
		var freq = BufRd.ar(1, freqBuf, phasor * BufFrames.ir(freqBuf), interpolation: 4);
		var wavePhase = Phasor.ar(0, freq / SampleRate.ir * BufFrames.ir(waveBuf), 0, BufFrames.ir(waveBuf));
		var sig = BufRd.ar(1, waveBuf, wavePhase, loop: 1, interpolation: 4);
		var envAmp = BufRd.ar(1, ampBuf, phasor * BufFrames.ir(ampBuf), interpolation: 4);
		var env = EnvGen.kr(Env.asr(0.005, 1, 0.02), gate, doneAction: 2);
		sig = sig * envAmp * env * amp;
		Out.ar(out, Pan2.ar(sig, LFNoise1.kr(0.3).range(-0.5, 0.5)));
	}).add;

	waveBuf = Buffer.alloc(s, numPoints, 1);
	s.sync;
	updateWaveBuf.value;

	{
		var win, waveDrawAt, ctrlY, durNum, presetY;

		waveDrawAt = { |v, x, y|
			var margin = 55;
			var plotW = v.bounds.width - margin - 10;
			var plotH = v.bounds.height - 20;
			var normX = ((x - margin) / plotW).clip(0, 1);
			var normY = 1 - ((y - 10) / plotH).clip(0, 1);
			var idx = (normX * (waveData.size - 1)).round.asInteger.clip(0, waveData.size - 1);
			var lastIdx = v.getProperty(\lastIdx) ? idx;
			var lastVal = v.getProperty(\lastVal) ? normY;
			var startI = min(lastIdx, idx), endI = max(lastIdx, idx);

			if(endI > startI) {
				(startI..endI).do { |i|
					var t = (i - startI) / (endI - startI);
					waveData[i] = if(lastIdx < idx) { lastVal + (t * (normY - lastVal)) } { normY + (t * (lastVal - normY)) };
				};
			} { waveData[idx] = normY };

			v.setProperty(\lastIdx, idx);
			v.setProperty(\lastVal, normY);
			updateWaveBuf.value;
			v.refresh;
		};

		ctrlY = canvasH + waveH + 30;
		presetY = ctrlY;

		win = Window("UPIC Multi-Voice — Xenakis", Rect(50, 50, width + 20, canvasH + waveH + 130))
		.background_(bgColor)
		.front;

		// --- Main canvas: time (x) vs frequency (y) ---
		canvas = UserView(win, Rect(10, 10, width, canvasH));
		canvas.drawFunc = { |v|
			var w = v.bounds.width, h = v.bounds.height;
			var margin = 55;
			var plotW = w - margin - 10;
			var plotH = h - 20;

			Pen.fillColor = bgColor;
			Pen.fillRect(Rect(0, 0, w, h));

			// Grid
			Pen.strokeColor = col1.alpha_(0.3);
			Pen.font = Font("Helvetica", 9);
			[100, 200, 500, 1000, 2000, 4000].do { |f|
				var normY = log(f / freqMin) / log(freqMax / freqMin);
				var y = 10 + (plotH * (1 - normY));
				if(normY >= 0 and: { normY <= 1 }) {
					Pen.line(Point(margin, y), Point(w - 10, y));
					Pen.color = col1;
					Pen.stringAtPoint(f.asString ++ " Hz", Point(2, y - 6));
					Pen.strokeColor = col1.alpha_(0.3);
				};
			};
			(duration.ceil.asInteger).do { |i|
				var normX = (i + 1) / duration;
				if(normX <= 1) {
					var x = margin + (plotW * normX);
					Pen.line(Point(x, 10), Point(x, 10 + plotH));
					Pen.color = col1;
					Pen.stringAtPoint((i+1).asString ++ "s", Point(x - 5, h - 15));
					Pen.strokeColor = col1.alpha_(0.3);
				};
			};
			Pen.stroke;

			// Draw all strokes
			strokes.do { |stroke, si|
				var col = colors[si % colors.size];
				Pen.strokeColor = col;
				Pen.width = 3;
				if(stroke.size > 0) {
					Pen.moveTo(Point(
						margin + (plotW * stroke[0][0]),
						10 + (plotH * (1 - (log(stroke[0][1] / freqMin) / log(freqMax / freqMin)).clip(0,1)))
					));
					stroke.do { |pt|
						var x = margin + (plotW * pt[0]);
						var normY = (log(pt[1] / freqMin) / log(freqMax / freqMin)).clip(0, 1);
						var y = 10 + (plotH * (1 - normY));
						Pen.lineTo(Point(x, y));
					};
					Pen.stroke;
				};
			};

			// Current stroke being drawn
			if(currentStroke.notNil and: { currentStroke.size > 0 }) {
				var col = colors[strokes.size % colors.size];
				Pen.strokeColor = col.alpha_(0.7);
				Pen.width = 3;
				Pen.moveTo(Point(
					margin + (plotW * currentStroke[0][0]),
					10 + (plotH * (1 - (log(currentStroke[0][1] / freqMin) / log(freqMax / freqMin)).clip(0,1)))
				));
				currentStroke.do { |pt|
					var x = margin + (plotW * pt[0]);
					var normY = (log(pt[1] / freqMin) / log(freqMax / freqMin)).clip(0, 1);
					var y = 10 + (plotH * (1 - normY));
					Pen.lineTo(Point(x, y));
				};
				Pen.stroke;
			};

			// Playback cursor
			if(cursorPos.notNil) {
				var x = margin + (plotW * cursorPos);
				Pen.strokeColor = Color.white.alpha_(0.7);
				Pen.width = 1;
				Pen.line(Point(x, 0), Point(x, h));
				Pen.stroke;
			};

			// Label
			Pen.color = col4;
			Pen.font = Font("Helvetica Bold", 12);
			Pen.stringAtPoint("TIME-FREQUENCY CANVAS — voices: " ++ strokes.size.asString ++ "/" ++ maxVoices, Point(margin + 5, h - 15));
		};

		// Mouse interaction on canvas
		canvas.mouseDownAction = { |v, x, y|
			var margin = 55;
			var plotW = v.bounds.width - margin - 10;
			var plotH = v.bounds.height - 20;
			var normX = ((x - margin) / plotW).clip(0, 1);
			var normY = 1 - ((y - 10) / plotH).clip(0, 1);
			var freq = freqMin * ((freqMax / freqMin) ** normY);

			if(strokes.size < maxVoices) {
				currentStroke = List[];
				currentStroke.add([normX, freq, 0.5]);
				canvas.refresh;
			};
		};

		canvas.mouseMoveAction = { |v, x, y|
			var margin = 55;
			var plotW = v.bounds.width - margin - 10;
			var plotH = v.bounds.height - 20;
			var normX = ((x - margin) / plotW).clip(0, 1);
			var normY = 1 - ((y - 10) / plotH).clip(0, 1);
			var freq = freqMin * ((freqMax / freqMin) ** normY);

			if(currentStroke.notNil) {
				currentStroke.add([normX, freq, 0.5]);
				canvas.refresh;
			};
		};

		canvas.mouseUpAction = { |v, x, y|
			if(currentStroke.notNil and: { currentStroke.size > 1 }) {
				strokes.add(currentStroke.copy);
			};
			currentStroke = nil;
			canvas.refresh;
		};

		// --- Waveform view ---
		waveView = UserView(win, Rect(10, canvasH + 20, width, waveH));
		waveView.drawFunc = { |v|
			var w = v.bounds.width, h = v.bounds.height;
			var margin = 55;
			var plotW = w - margin - 10;
			var plotH = h - 20;

			Pen.fillColor = bgColor;
			Pen.fillRect(Rect(0, 0, w, h));

			// Zero line
			Pen.strokeColor = col1.alpha_(0.3);
			Pen.line(Point(margin, 10 + (plotH * 0.5)), Point(w - 10, 10 + (plotH * 0.5)));
			Pen.stroke;

			// Waveform
			Pen.strokeColor = col2;
			Pen.width = 2;
			Pen.moveTo(Point(margin, 10 + (plotH * (1 - waveData[0]))));
			waveData.do { |val, i|
				var x = margin + (plotW * i / (waveData.size - 1));
				var y = 10 + (plotH * (1 - val));
				Pen.lineTo(Point(x, y));
			};
			Pen.stroke;

			Pen.color = col4;
			Pen.font = Font("Helvetica Bold", 11);
			Pen.stringAtPoint("SHARED WAVEFORM — draw to change timbre", Point(margin + 5, h - 15));
		};

		// Drawing on waveform
		waveView.mouseDownAction = { |v, x, y|
			v.setProperty(\lastIdx, nil);
			v.setProperty(\lastVal, nil);
			waveDrawAt.value(v, x, y);
		};
		waveView.mouseMoveAction = waveDrawAt;

		// --- Controls ---
		Button(win, Rect(10, ctrlY, 100, 35))
		.states_([
			["PLAY ALL", bgColor, col5],
			["STOP", Color.white, col1]
		])
		.font_(Font("Helvetica Bold", 13))
		.action_({ |btn|
			if(btn.value == 1) {
				if(strokes.size > 0) {
					isPlaying = true;

					// Fork so s.sync works (needs a Routine)
					{
						strokes.do { |stroke, si|
							var freqArr, ampArr, fb, ab;
							var sorted = stroke.sort({ |a, b| a[0] < b[0] });
							var times = sorted.collect(_[0]);
							var freqs = sorted.collect(_[1]);

							freqArr = Array.fill(numPoints, { |i|
								var t = i / (numPoints - 1);
								var idx = times.indexInBetween(t) ? 0;
								var lo = idx.floor.asInteger.clip(0, freqs.size - 2);
								var hi = (lo + 1).clip(0, freqs.size - 1);
								var frac = idx - lo;
								if(t < times[0] or: { t > times.last }) { 0 } {
									freqs[lo] + (frac * (freqs[hi] - freqs[lo]))
								};
							});

							ampArr = Array.fill(numPoints, { |i|
								var t = i / (numPoints - 1);
								if(t < times[0] or: { t > times.last }) { 0 } { 0.5 };
							});

							fb = Buffer.alloc(s, numPoints, 1);
							ab = Buffer.alloc(s, numPoints, 1);
							s.sync;
							fb.setn(0, freqArr);
							ab.setn(0, ampArr);

							{
								var syn = Synth(\upicVoice, [
									\waveBuf, waveBuf,
									\freqBuf, fb,
									\ampBuf, ab,
									\dur, duration,
									\amp, (0.25 / strokes.size.max(1).sqrt)
								]);
								synths.add([syn, fb, ab]);
							}.defer;
						};
					}.fork;

					Routine({
						var startTime = Main.elapsedTime;
						loop {
							var elapsed = Main.elapsedTime - startTime;
							cursorPos = elapsed / duration;
							if(cursorPos > 1) {
								{ btn.value = 0 }.defer;
								nil.yield;
							};
							{ canvas.refresh }.defer;
							0.03.yield;
						};
					}).play(AppClock);

					{
						duration.wait;
						{
							isPlaying = false;
							cursorPos = nil;
							canvas.refresh;
							btn.value = 0;
							// Synths have already ended via doneAction, just free buffers
							synths.do { |arr| arr[1].free; arr[2].free };
							synths.clear;
						}.defer;
					}.fork(AppClock);
				};
			} {
				isPlaying = false;
				cursorPos = nil;
				synths.do { |arr| arr[0].set(\gate, 0) };
				// Free buffers after synths have released
				{ synths.do { |arr| arr[1].free; arr[2].free }; synths.clear }.defer(0.1);
				canvas.refresh;
			};
		});

		// Duration control
		StaticText(win, Rect(130, ctrlY + 5, 40, 25))
		.string_("Dur:")
		.stringColor_(col4)
		.font_(Font("Helvetica", 11));

		durNum = NumberBox(win, Rect(170, ctrlY + 5, 50, 25))
		.value_(duration)
		.clipLo_(0.5).clipHi_(30)
		.font_(Font("Helvetica", 12))
		.action_({ |nb| duration = nb.value });

		StaticText(win, Rect(225, ctrlY + 5, 15, 25))
		.string_("s")
		.stringColor_(col4);

		// Undo last stroke
		Button(win, Rect(260, ctrlY, 80, 35))
		.states_([["Undo", col5, col1]])
		.font_(Font("Helvetica", 12))
		.action_({
			if(strokes.size > 0) {
				strokes.pop;
				canvas.refresh;
			};
		});

		// Clear all strokes
		Button(win, Rect(350, ctrlY, 80, 35))
		.states_([["Clear", col5, Color.red(0.4, 0.6).blend(col1, 0.5)]])
		.font_(Font("Helvetica", 12))
		.action_({
			strokes.clear;
			canvas.refresh;
		});

		// Waveform presets
		presetY = ctrlY;
		StaticText(win, Rect(460, presetY + 8, 70, 25))
		.string_("Waveform:")
		.stringColor_(col4)
		.font_(Font("Helvetica", 11));

		[\Sine, \Saw, \Square, \Noise].do { |name, i|
			Button(win, Rect(535 + (i * 65), presetY, 60, 35))
			.states_([[name.asString, col5, col1]])
			.font_(Font("Helvetica", 11))
			.action_({
				waveData = switch(name,
					\Sine,   { Array.fill(numPoints, { |i| sin(i / numPoints * 2pi).linlin(-1,1,0,1) }) },
					\Saw,    { Array.fill(numPoints, { |i| i / (numPoints - 1) }) },
					\Square, { Array.fill(numPoints, { |i| if(i < (numPoints/2), 1, 0) }) },
					\Noise,  { Array.fill(numPoints, { 1.0.rand }) }
				);
				updateWaveBuf.value;
				waveView.refresh;
			});
		};

		// Info
		StaticText(win, Rect(10, ctrlY + 42, width, 35))
		.string_("Draw lines on the canvas to create frequency trajectories. Each stroke = one oscillator voice. Draw waveform below to change shared timbre.")
		.font_(Font("Helvetica", 10))
		.stringColor_(col1);

		win.onClose = {
			synths.do { |arr| arr[0].free; arr[1].free; arr[2].free };
			waveBuf.free;
		};

	}.defer;
});
)
