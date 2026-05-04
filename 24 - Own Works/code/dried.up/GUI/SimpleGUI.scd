////////////////////////////////////////////////////////////////
//
//                       A Simple GUI.
//
////////////////////////////////////////////////////////////////


~gui = {|name, outputDir, color, source, sourceArgs, sourceVars, process, processArgs, processVars|

s.waitForBoot({
    var win, play, record;
    var sourceSynth, processSynth;
    var addControls, totalControls;

	totalControls = sourceVars.size + processVars.size;

    // Initialize the window

	win = Window.new(name, Rect(200, 100, 600, 100 +  (70 * totalControls)));
    win.view.decorator = FlowLayout(win.view.bounds, 20@40, 25@25);
    win.background = color;
    win.alpha = 0.95;
    win.front;


    // Variables of the process (and source)

    addControls = {|vars, isSource|
        vars.do {|sv|
        var slider = EZSlider(
        parent: win,
        bounds: 540 @ 40,
        label: sv[0],
        controlSpec: sv[1],
        action: {|ez| if(isSource, {sourceSynth.set(sv[0], ez.value)}, {processSynth.set(sv[0], ez.value)})});

        slider.font =Font("Monaco", 12);
        slider.setColors(
                    stringColor: Color.white,
                    sliderBackground: Color.white(0.9),
                    numNormalColor: Color.black);
        };
    };

    addControls.value(sourceVars, true);
    addControls.value(processVars, false);


    // Add the buttons for playback and recording

    play = Button(win.view, 260@40);
    play.states = [["Play", Color.black, Color.white], ["Stop", Color.black, Color.white]];
    play.action = {|button|

        if (button.value == 1, {
            // Start the process, then play the source
			if(process.isNil == false, {processSynth = Synth(process, processArgs)});
            sourceSynth = Synth(source, sourceArgs);
        },{
            // Free both synth and source
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

