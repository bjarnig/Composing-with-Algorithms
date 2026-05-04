////////////////////////////////////////////////////////////////
//
//                   A Simple Envelope GUI.
//
////////////////////////////////////////////////////////////////


~envGui = {|name, outputDir, color, source, sourceArgs, sourceVars, process, processArgs, processVars, points=4|

s.waitForBoot({
    var win, play, record, scroll;
    var sourceSynth, processSynth;
    var addControls, addEnvRoutines, totalControls, granularity=0.1;
	var duration, durationSlider, sourceEnvelopes, processEnvelopes, envelopeRoutines;

	totalControls = sourceVars.size + processVars.size;
	sourceEnvelopes = List(sourceVars.size);
	processEnvelopes = List(processVars.size);

	// Initialize the window

	if(totalControls > 4, {scroll = true}, {scroll = false});

	win = Window.new(name, Rect(200, 100, 600, 200 +  (130 * totalControls)), scroll: scroll);
    win.view.decorator = FlowLayout(win.view.bounds, 20@20, 25@15);
    win.background = color;
    win.alpha = 0.95;
    win.front;


	// Variables of the process (and source)

    addControls = {|vars, isSource|
        vars.do {|sv, index|
				var text, env;
				env = Env((sv[1].default.linlin(sv[1].minval, sv[1].maxval, 0.0, 1.0)) ! points, (0.1 ! (points - 1)).normalizeSum);
				if(isSource, { sourceEnvelopes.add(env)} , {processEnvelopes.add(env)});

				text = StaticText(win, 150@15);
				text.string = sv[0].asString + "(" ++ sv[1].minval + "-" + sv[1].maxval ++ ")";
				text.stringColor = Color.white;
				text.font = Font("Monaco", 12);

				EnvelopeView(win, Rect(25, 55, 550, 100))
				.setEnv(env)
				.drawLines_(true)
				.selectionColor_(Color.red)
				.drawRects_(true)
				.step_(0.01)
				.keepHorizontalOrder_(true)
				.action_({arg b;
					env.levels = b.value[1];
					env.times = b.value[0].differentiate.drop(1);
					env.duration_(1);

					if(isSource, { sourceEnvelopes[index] = env} , {processEnvelopes[index] = env});
				}).thumbSize_(18);
        };
    };

	// Add the controls for source and process
    addControls.value(sourceVars, true);
    addControls.value(processVars, false);

	durationSlider = EZSlider(
        parent: win,
        bounds: 545 @ 40,
        label: "Duration",
        controlSpec: ControlSpec(1.0, 10, \lin, 0.01, 3),
        action: {|ez| });

        durationSlider.font =Font("Monaco", 12);
        durationSlider.setColors(
                    stringColor: Color.white,
                    sliderBackground: Color.white(0.9),
                    numNormalColor: Color.black);


	// Create the play functionality
	addEnvRoutines = {|vars, isSource|

				vars.do {|sv, index|
					var steps = durationSlider.value / granularity;
					envelopeRoutines.add(Routine{
						steps.do{|i|
							var value;

						    if(isSource, {
							    value = sv[1].map(sourceEnvelopes[index].at((i/steps)));
							    sourceSynth.set(sv[0], value)
						    }, {
								value = sv[1].map(processEnvelopes[index].at((i/steps)));
								processSynth.set(sv[0], value)
						    });

							granularity.wait;
						};
					}.play);
				};
	};


    // Add the buttons for playback and recording

    play = Button(win.view, 260@40);
    play.states = [["Play", Color.black, Color.white], ["Stop", Color.black, Color.white]];
    play.action = {|button|

        if (button.value == 1, {
			// Start the process, then play the source
			if(process.isNil == false, {processSynth = Synth(process, processArgs)});
			envelopeRoutines = List(sourceVars.size + processVars.size);
			sourceSynth = Synth(source, sourceArgs);
			addEnvRoutines.value(processVars, false);
			addEnvRoutines.value(sourceVars, true);
        },{
            // Free both synth and source
			envelopeRoutines.do{|routine| routine.stop};
            sourceSynth.free;
            processSynth.free;
        });
    };

    record = Button(win.view,260@40);
    record.states = [
			["Prepare Record", Color.red, Color.white],
			["Start Record", Color.red, Color.white],
            ["Stop Record", Color.red, Color.white]];

    record.action = {|button|
		var str = outputDir +/+ name.replace(" ", "") ++ "_" ++ (Date.getDate).hourStamp ++ ".wav";
		if(button.value == 1, { s.prepareForRecord(str)});
		if(button.value == 2, { s.record});
		if(button.value == 0, { s.stopRecording});
	};

win.front

});

};

// TEMP & TESTING

/*
SynthDef(\play, {|out=0,pan=0,rate=1,amp=1.0,buf=0|
	var signal = PlayBuf.ar(1, buf, rate, 1, 0, 1);
	Out.ar(out, Pan2.ar(signal, pan, amp));
}).add;

	SynthDef(\ampMod, {|in=0, out=0, modFreq=10, modAmt=0.1|
		var signal, rev;
	    signal = In.ar(in, 2);
		signal = signal * SinOsc.ar(modFreq.poll, 0.5, 0.5);
		ReplaceOut.ar(out, signal)
	}).add;*/

// Synth(\play, [\buf, b])


/*~envGui.value(
	"Evolution", ~path ++ "/output", Color.fromHexString("#16001E"), 3,
	\play, [\buf, b, \rate, 1, \amp, 1],
	[[\rate, ControlSpec(-8.0, 8.0, \lin, 0.01, 1)],
	[\pan, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]]

	// Process
	\ampMod, [\modAmt, 0.5],
    [[\modFreq, ControlSpec(0.1, 25, \lin, 0.1, 10)],
    [\modAmt, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)],
	[\modFreq, ControlSpec(0.1, 25, \lin, 0.1, 10)],
    [\modAmt, ControlSpec(0.0, 1.0, \lin, 0.01, 0.5)]]
);*/

// (
//
// ~gui.value(
// 	// Gloabl
// 	"Amplitude Modulation", ~path ++ "/output", Color.fromHexString("#04151F"),
//
// 	// Source
// 	\player, [\buf, b],
// 	[[\rate, ControlSpec(0.2, 2.0, \lin, 0.1, 1)],
// 	[\amp, ControlSpec(0.0, 1.0, \lin, 0.001, 0.5)]],
//
// );
// )
