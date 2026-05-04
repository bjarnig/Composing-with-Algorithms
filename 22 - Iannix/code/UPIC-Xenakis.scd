
// UPIC - Xenakis-inspired Drawing-to-Sound in SuperCollider

(
s.waitForBoot({

	var width = 800, height = 200;
	var numPoints = 512;

	// Palette: #7c616c #d1b1cb #ddcad9 #e5e9ec #eafdf8
	var col1 = Color(0.486, 0.380, 0.424); // #7c616c - dark mauve
	var col2 = Color(0.820, 0.694, 0.796); // #d1b1cb - soft pink
	var col3 = Color(0.867, 0.792, 0.851); // #ddcad9 - light rose
	var col4 = Color(0.898, 0.914, 0.925); // #e5e9ec - pale blue-gray
	var col5 = Color(0.918, 0.992, 0.973); // #eafdf8 - mint white

	// Colors for each view
	var freqColor = col5;  // mint - frequency
	var waveColor = col2;  // pink - waveform
	var ampColor  = col3;  // rose - amplitude
	var bgColor   = Color(0.06, 0.05, 0.055);
	var gridColor = col1.alpha_(0.3);
	var labelColor = col4;

	// Data arrays (0..1 normalized)
	var freqData = Array.fill(numPoints, { 0.3 });
	var waveData = Array.fill(numPoints, { |i| sin(i / numPoints * 2pi).linlin(-1, 1, 0, 1) });
	var ampData  = Array.fill(numPoints, { 0.7 });

	// State
	var waveBuf, freqBuf, ampBuf;
	var synth = nil;
	var duration = 4.0;
	var freqMin = 80, freqMax = 4000;
	var isPlaying = false;
	var cursorRoutine = nil;
	var freqView, waveView, ampView;
	var playBtn, durSlider, durLabel;

	// --- Helper: draw a curve into a UserView ---
	var drawCurve = { |view, data, color, label, yAxisLabels|
		view.drawFunc = { |v|
			var w = v.bounds.width;
			var h = v.bounds.height;
			var margin = 40;
			var plotW = w - margin - 10;
			var plotH = h - 20;
			var cursorPos = v.getProperty(\cursorPos);

			// Background
			Pen.fillColor = bgColor;
			Pen.fillRect(Rect(0, 0, w, h));

			// Grid lines
			Pen.strokeColor = gridColor;
			5.do { |i|
				var y = 10 + (plotH * i / 4);
				Pen.line(Point(margin, y), Point(w - 10, y));
			};
			Pen.stroke;

			// Y-axis labels
			if(yAxisLabels.notNil) {
				Pen.color = col1;
				Pen.font = Font("Helvetica", 9);
				yAxisLabels.do { |pair|
					var val = pair[0], txt = pair[1];
					var y = 10 + (plotH * (1 - val));
					Pen.stringAtPoint(txt, Point(2, y - 6));
				};
			};

			// The curve
			Pen.strokeColor = color;
			Pen.width = 2;
			Pen.moveTo(Point(margin, 10 + (plotH * (1 - data[0]))));
			data.do { |val, i|
				var x = margin + (plotW * i / (data.size - 1));
				var y = 10 + (plotH * (1 - val));
				Pen.lineTo(Point(x, y));
			};
			Pen.stroke;

			// Playback cursor
			if(cursorPos.notNil) {
				var x = margin + (plotW * cursorPos);
				Pen.strokeColor = Color.white.alpha_(0.7);
				Pen.width = 1;
				Pen.line(Point(x, 0), Point(x, h));
				Pen.stroke;
			};

			// Label
			Pen.color = labelColor;
			Pen.font = Font("Helvetica Bold", 13);
			Pen.stringAtPoint(label, Point(margin + 5, h - 18));
		};
	};

	// --- Helper: mouse drawing into data array ---
	var setupDrawing = { |view, data, updateFunc|
		var drawAtMouse = { |v, x, y|
			var margin = 40;
			var plotW = v.bounds.width - margin - 10;
			var plotH = v.bounds.height - 20;
			var normX = ((x - margin) / plotW).clip(0, 1);
			var normY = 1 - ((y - 10) / plotH).clip(0, 1);
			var idx = (normX * (data.size - 1)).round.asInteger.clip(0, data.size - 1);
			var lastIdx = v.getProperty(\lastDrawIdx) ? idx;
			var startIdx = min(lastIdx, idx);
			var endIdx = max(lastIdx, idx);
			var lastVal = v.getProperty(\lastDrawVal) ? normY;

			if(endIdx > startIdx) {
				(startIdx..endIdx).do { |i|
					var t = (i - startIdx) / (endIdx - startIdx);
					var interpVal = if(lastIdx < idx) {
						lastVal + (t * (normY - lastVal))
					} {
						normY + (t * (lastVal - normY))
					};
					data[i] = interpVal;
				};
			} {
				data[idx] = normY;
			};

			v.setProperty(\lastDrawIdx, idx);
			v.setProperty(\lastDrawVal, normY);
			v.refresh;
			updateFunc.value;
		};

		view.mouseDownAction = { |v, x, y|
			v.setProperty(\lastDrawIdx, nil);
			v.setProperty(\lastDrawVal, nil);
			drawAtMouse.value(v, x, y);
		};
		view.mouseMoveAction = drawAtMouse;
	};

	// --- Update buffer functions (setn via OSC, no temp files) ---
	var updateFreq = {
		var mapped = freqData.collect { |v| freqMin * ((freqMax / freqMin) ** v) };
		freqBuf.setn(0, mapped);
	};

	var updateWave = {
		var mapped = waveData.collect { |v| v * 2 - 1 };
		waveBuf.setn(0, mapped);
	};

	var updateAmp = {
		ampBuf.setn(0, ampData);
	};

	// --- SynthDef ---
	SynthDef(\upic, { |out = 0, waveBuf, freqBuf, ampBuf, dur = 4, gate = 1|
		var phasor = Line.ar(0, 1, dur, doneAction: 2);
		var freq = BufRd.ar(1, freqBuf, phasor * BufFrames.ir(freqBuf), loop: 0, interpolation: 4);
		var wavePhase = Phasor.ar(0, freq / SampleRate.ir * BufFrames.ir(waveBuf), 0, BufFrames.ir(waveBuf));
		var sig = BufRd.ar(1, waveBuf, wavePhase, loop: 1, interpolation: 4);
		var amp = BufRd.ar(1, ampBuf, phasor * BufFrames.ir(ampBuf), loop: 0, interpolation: 4);
		var env = EnvGen.kr(Env.asr(0.01, 1, 0.05), gate, doneAction: 2);
		sig = sig * amp * env * 0.3;
		Out.ar(out, sig ! 2);
	}).add;

	// Allocate buffers and wait
	waveBuf = Buffer.alloc(s, numPoints, 1);
	freqBuf = Buffer.alloc(s, numPoints, 1);
	ampBuf  = Buffer.alloc(s, numPoints, 1);
	s.sync;

	// Initialize with setn (pure OSC, no temp files)
	updateFreq.value;
	updateWave.value;
	updateAmp.value;

	// --- GUI ---
	{
		var win = Window("UPIC - Xenakis", Rect(100, 100, width + 20, height * 3 + 140))
		.background_(bgColor)
		.front;

		// --- Frequency View ---
		freqView = UserView(win, Rect(10, 10, width, height));
		drawCurve.value(freqView, freqData, freqColor, "FREQUENCY TRAJECTORY (time ->)",
			[[0, freqMin.asString ++ " Hz"], [0.5, (freqMin * ((freqMax/freqMin) ** 0.5)).round.asString], [1, freqMax.asString ++ " Hz"]]
		);
		setupDrawing.value(freqView, freqData, updateFreq);

		// --- Waveform View ---
		waveView = UserView(win, Rect(10, height + 20, width, height));
		drawCurve.value(waveView, waveData, waveColor, "WAVEFORM / TIMBRE (one cycle)",
			[[0, "-1"], [0.5, "0"], [1, "+1"]]
		);
		setupDrawing.value(waveView, waveData, updateWave);

		// --- Amplitude View ---
		ampView = UserView(win, Rect(10, height * 2 + 30, width, height));
		drawCurve.value(ampView, ampData, ampColor, "AMPLITUDE ENVELOPE (time ->)",
			[[0, "0"], [0.5, "0.5"], [1, "1.0"]]
		);
		setupDrawing.value(ampView, ampData, updateAmp);

		// --- Controls ---
		playBtn = Button(win, Rect(10, height * 3 + 45, 120, 35))
		.states_([
			["PLAY", bgColor, col5],
			["STOP", Color.white, col1]
		])
		.font_(Font("Helvetica Bold", 14))
		.action_({ |btn|
			if(btn.value == 1) {
				updateFreq.value;
				updateWave.value;
				updateAmp.value;
				synth = Synth(\upic, [
					\waveBuf, waveBuf,
					\freqBuf, freqBuf,
					\ampBuf, ampBuf,
					\dur, duration
				]);
				isPlaying = true;

				cursorRoutine = Routine({
					var startTime = Main.elapsedTime;
					loop {
						var elapsed = Main.elapsedTime - startTime;
						var pos = elapsed / duration;
						if(pos > 1) {
							{ btn.value = 0; }.defer;
							nil.yield;
						};
						{
							[freqView, waveView, ampView].do { |v|
								v.setProperty(\cursorPos, pos);
								v.refresh;
							};
						}.defer;
						0.03.yield;
					};
				}).play(AppClock);

				{
					duration.wait;
					{
						if(isPlaying) {
							btn.value = 0;
							isPlaying = false;
							[freqView, waveView, ampView].do { |v|
								v.setProperty(\cursorPos, nil);
								v.refresh;
							};
						};
					}.defer;
				}.fork(AppClock);
			} {
				if(synth.notNil) { synth.set(\gate, 0); synth = nil; };
				if(cursorRoutine.notNil) { cursorRoutine.stop; cursorRoutine = nil; };
				isPlaying = false;
				[freqView, waveView, ampView].do { |v|
					v.setProperty(\cursorPos, nil);
					v.refresh;
				};
			};
		});

		durLabel = StaticText(win, Rect(150, height * 3 + 50, 60, 25))
		.string_("Dur: " ++ duration.asString ++ "s")
		.font_(Font("Helvetica", 11))
		.stringColor_(labelColor);

		durSlider = Slider(win, Rect(215, height * 3 + 50, 200, 25))
		.value_(duration / 20)
		.background_(col1)
		.knobColor_(col5)
		.action_({ |sl|
			duration = (sl.value * 20).max(0.5);
			durLabel.string = "Dur: " ++ duration.round(0.1).asString ++ "s";
		});

		// Preset buttons
		[\Sine, \Saw, \Square].do { |name, i|
			Button(win, Rect(440 + (i * 85), height * 3 + 50, 80, 25))
			.states_([[name.asString, col5, col1]])
			.font_(Font("Helvetica", 11))
			.action_({
				waveData = switch(name,
					\Sine,   { Array.fill(numPoints, { |i| sin(i / numPoints * 2pi).linlin(-1, 1, 0, 1) }) },
					\Saw,    { Array.fill(numPoints, { |i| i / (numPoints - 1) }) },
					\Square, { Array.fill(numPoints, { |i| if(i < (numPoints/2), 1, 0) }) }
				);
				updateWave.value;
				drawCurve.value(waveView, waveData, waveColor, "WAVEFORM / TIMBRE (one cycle)",
					[[0, "-1"], [0.5, "0"], [1, "+1"]]);
				waveView.refresh;
			});
		};

		Button(win, Rect(695, height * 3 + 50, 80, 25))
		.states_([["Clear All", col5, Color.red(0.4, 0.6).blend(col1, 0.5)]])
		.font_(Font("Helvetica", 11))
		.action_({
			freqData = Array.fill(numPoints, { 0.3 });
			waveData = Array.fill(numPoints, { |i| sin(i / numPoints * 2pi).linlin(-1, 1, 0, 1) });
			ampData = Array.fill(numPoints, { 0.7 });
			updateFreq.value;
			updateWave.value;
			updateAmp.value;
			drawCurve.value(freqView, freqData, freqColor, "FREQUENCY TRAJECTORY (time ->)",
				[[0, freqMin.asString ++ " Hz"], [0.5, (freqMin * ((freqMax/freqMin) ** 0.5)).round.asString], [1, freqMax.asString ++ " Hz"]]);
			drawCurve.value(waveView, waveData, waveColor, "WAVEFORM / TIMBRE (one cycle)",
				[[0, "-1"], [0.5, "0"], [1, "+1"]]);
			drawCurve.value(ampView, ampData, ampColor, "AMPLITUDE ENVELOPE (time ->)",
				[[0, "0"], [0.5, "0.5"], [1, "1.0"]]);
			[freqView, waveView, ampView].do(_.refresh);
		});

		// Info text
		StaticText(win, Rect(10, height * 3 + 90, width, 40))
		.string_("UPIC (Xenakis): Draw in each panel to define sound. Frequency = pitch over time, Waveform = timbre, Amplitude = dynamics.")
		.font_(Font("Helvetica", 11))
		.stringColor_(col1);

		win.onClose = {
			if(synth.notNil) { synth.free };
			if(cursorRoutine.notNil) { cursorRoutine.stop };
			[waveBuf, freqBuf, ampBuf].do(_.free);
		};

		win.front;
	}.defer;
});
)
