////////////////////////////////////////////////////////////////
//
//                       CWA19 - GUI
//
////////////////////////////////////////////////////////////////

Graphical user interfaces using SuperCollider.


////////////////////// Window and Rect /////////////////////////

// left, top, width, height
r = Rect(500,200,800,600);


// Title and rect instance
w = Window("Empty Window", r);


// Display the window
w.front


// Scrollable Window
Slider2D(Window("Scroll", scroll: f).front, Rect(0, 0, 1500, 100));


// Action when closed
Window.new.front.onClose_({ { Dust.ar( LFNoise0.kr(2, 10, 50)) }.play });





/////////////////////// Text and Color /////////////////////////

( // Create a window and add static text to it

~myWindow = Window("My Great Window", Rect(200,200,200,200));

t = StaticText(~myWindow, Rect(130,160,100,50));
t.string = "The Text";
t.stringColor = Color.blue;

~myWindow.front

)




( // Blue text and white background

w = Window("White background", Rect(200,200,400,400));
t = StaticText(w, Rect(150,150,200,100));
t.string = "Blue Text";
t.stringColor = Color.blue;
w.background = Color.white;
w.front

)




( // Text with iteration

w = Window("", Rect(200,200,400,400));
w.name = "12 times";

12.do {|i|
	i = i + 1;
	t = StaticText(w, Rect(75,20 + (20 * i),200,100));
	t.string = "Iteration: " + i;
	t.font = Font("Monaco", 10 + i);
};

w.front

)



( // Custom colors and alpha channel

var w, much = 0.02, string, synth;

w = Window("Colorful", Rect(200,200,400,400)).front;
w.background = Color.new255(153, 255, 102).vary;
w.drawFunc = { w.background = Color.new(1, 1.0.rand,1.0.rand,1.0.rand) };
{ while { w.isClosed.not } { w.refresh; 0.1.wait; } }.fork(AppClock);
)




///////////////////// Sliders and Buttons //////////////////////

( // Display slider value in a number box

w = Window("Slider and Box", Rect(200,200,200,200));
b = NumberBox(w, Rect(20, 20, 160, 20));
a = Slider(w, Rect(20, 60, 160, 30));
a.action = { b.value = a.value };

w.front

)


( // Add multiple actions to slider and later remove them

w = Window.new("A Slider");
w.background = Color.new255(210,220,230,240);
a = Slider.new(w, Rect(50, 50, 300, 300));
w.front

)

f = {|slider| slider.value.postln };
a.addAction(f);
a.removeAction(f);

c = {|slider| w.background = Color.rand };
a.addAction(c);
a.removeAction(c);





( // Play a sound on button action

w = Window.new("Impulse", Rect(100,100,200,200));
b = Button(w, Rect(45, 45, 100, 100));
b.states = [["Start", Color.black, Color.white],
	["Stop", Color.white, Color.black]];

b.action = {|button|
	if(button.value == 1) {
		a = { Impulse.ar(40) ! 2 }.play } { a.free }
};


w.front

)






( // SynthDef with Slider and mouseDownAction

var createWin = {
	var win, trigger, slider, synth, spec;

	win = Window.new("SynthDef - Control", Rect(100,100,400,300));
	win.background = Color.fromHexString("#fff");

	spec = ControlSpec(100, 1000, \linear, 10);

	slider = Slider(win, Rect(50, 150, 300, 50));
	slider.action = { synth.set(\freq, spec.map(slider.value)) };

	trigger = Button(win, Rect(50, 50, 300, 50));
	trigger.states = [["Play", Color.black, Color.white],
		["Release", Color.white, Color.black]];
	trigger.mouseDownAction = {|btn| if(btn.value == 0) { synth = Synth(\Pulse) }};
	trigger.action = {|btn| btn.value.postln; if(btn.value == 0, { synth.set(\gate, 0) })};

	win.front
};

SynthDef(\Pulse, {|gate=1, freq=200|
	var env = EnvGen.kr(Env.asr(1, 0.1, 4), gate, doneAction:2);
    Out.ar(0, Impulse.ar(freq) * env ! 2);
}).add();

createWin.value;

)


( // Iterate controls for additive synthesis

var displayWindow = {

var synth, ampSpec, freqSpec, window;
window = Window("Additive", Rect(100,200,370,350));
window.background = Color.fromHexString("#A96E6E");
freqSpec = ControlSpec(100, 500,'exponential');

4.do {|i|
	var slider, text, offset, number;

	i = i + 1;
	offset = 60 * i;
	number = NumberBox(window, Rect(offset,255,50,20));
	slider = Slider(window, Rect(offset,50,50,200));
	slider.action = {|v| var val=freqSpec.map(v.value);
		synth.set("f"++i,val); number.value=val };
	text = StaticText(window,Rect(offset,30,50,20));
	text.string = "Freq" ++ i;
	text.stringColor = Color.white;
	text.align = \center;
};

	Button(window, Rect(50,285,250,50))
	.states_([["Start"], ["Stop", Color.black, Color.cyan(alpha: 0.2)]])
	.action_({|view| if (view.value == 1)
		{synth = Synth(\additive)}
		{synth.set(\gate, 0) }
	});

	window.front

};

SynthDef(\additive, {
	|f1=400, f2=600, f3=400, f4=600, amp=0.1, gate=1|
	var signal, env;
	env = EnvGen.kr(Env.asr(2,1,2),gate,amp,doneAction:2);
	signal = SinOsc.ar(f1) + SinOsc.ar(f2) + SinOsc.ar(f3) + SinOsc.ar(f4);
	signal = signal * 0.25;
	Out.ar(0,signal * env ! 2);
}).add();

displayWindow.value();

)




//////////////////// Decoration and EZSlider ///////////////////

( // Use FlowLayout to set spaces and arrange automatically

var controls, win = Window("Decorated",Rect(200,200,350,700));
win.background = Color.fromHexString("#DBCDC6");
win.view.decorator= FlowLayout(win.view.bounds, 20@20, 30@30);
controls = Array.fill(32,{Knob(win.view,50@50).background_("#FFF")});
win.front

)


( // EZSlider combines static text, slider and number box.

w= Window("Window", Rect(100,100,400,100));
w.view.decorator = FlowLayout(w.view.bounds);
a = EZSlider(w, 350 @ 40, "Frequency",\freq, labelWidth: 80);
b = EZSlider(w, 350 @ 40, "Amplitude",\freq, labelWidth: 80);
w.front

)




///////////////////////// PopUpMenu ////////////////////////////

( // Items and actions in a PopUpMenu and a button evaluates

var win, menu, snd, actions, button;

win = Window("Pop", Rect(400,400,300,200));
win.background = Color.cyan;
menu = PopUpMenu(win,Rect(10,10,90,20));
menu.items = (["Sine" , "Saw" , "Noise" , "Pulse"]);

actions = [
	{SinOsc.ar(440,0,0.3)!2},
	{Saw.ar(440,0.3)!2},
	{WhiteNoise.ar(0.3)!2},
	{Pulse.ar(440,0.2,0.3)!2}
];

button = Button(win,Rect(110,10,180,20));
button.states = [["Play",Color.white, Color.blue]];
button.mouseDownAction = { snd = actions.at(menu.value).play};
button.action = { snd.free };

win.front

)




//////////////////////// EnvelopeView //////////////////////////

(
var win, env, button, snd;

win = Window("Envelope", Rect(200, 200, 600, 300));
win.background = Color.black;
win.view.decorator = FlowLayout(win.view.bounds);

env = EnvelopeView(win, Rect(0, 0, 590, 200))
	.thumbSize_(5)
	.drawLines_(true)
	.fillColor_(Color.green)
	.selectionColor_(Color.red)
	.strokeColor_(Color.blue)
	.drawRects_(true)
	.value_([(0.0, 0.1 .. 1.0), Array.rand(11, 0.0, 1.0)])
	.setEditable(0,true);

button = Button(win,Rect(110,550,590,80));
button.states = [["Play",Color.white, Color.blue]];
button.mouseDownAction = {
	snd = {
		Saw.ar(EnvGen.kr(Env.new(env.value[1] * 1000, env.value[0] * 2)))
	}.play
};
button.action = { snd.free };

win.front

)



/////////////////////// SoundFileView //////////////////////////

~path = "/Volumes/DATA/Courses/Resources/SuperCollider/_snd/beat.wav";
~buff = Buffer.read(s, ~path);

(

var win, view, file, synth;

synth = SynthDef(\looper, {|start=0, end=10000|
	Out.ar(0,BufRd.ar(1, ~buff.bufnum,
		Phasor.ar(0, BufRateScale.kr(~buff.bufnum), start, end),0.0)!2)
}).play;

win = Window.new("Soundfile - Looper", Rect(200, 400, 740, 300));
win.background = Color.fromHexString("#6B97C8");
view = SoundFileView.new(win, Rect(20, 20, 700, 260));

file = SoundFile.new;
file.openRead(~path);

view.soundfile = file;
view.read(0, file.numFrames);
view.elasticMode = true;

view.timeCursorOn = true;
view.timeCursorColor = Color.red;
view.drawsWaveForm = true;
view.gridOn = true;
view.gridResolution = 0.2;
view.mouseUpAction_({ arg v;
	var pos = (v.selections[0]);
	synth.set(\start, pos[0], \end, pos[0]+pos[1]);
});

win.front

)




////////////////////// MultiSliderView /////////////////////////

(

var win, size=12, multislider, player, snd, times=64, tempo=0.1;

snd = {arg freq=330; Impulse.ar(freq,0,0.2)}.play;

win = Window("Multislider", Rect(200 , 450, 10 + (size * 17), 10 + (size * 17)));
win.view.decorator = FlowLayout(win.view.bounds);

multislider = MultiSliderView(win, Rect(0, 0, size * 17, size * 17));
multislider.value_( Array.fill(size,{|i| i/size}) );
multislider.background_(Color.rand);
multislider.action = {arg point;
	snd.set(\freq, 200+(1000*point.value.at(point.index)))};
multislider.elasticMode = 1;
multislider.showIndex = true;

win.front;

player = Routine({
	times.do({ arg i;
		multislider.index_(i%size);
		multislider.doAction;
		tempo.wait;
	});
});

AppClock.play(player);

)




/////////////////////// Drag and Drop //////////////////////////

( // DragSource defines a function and DragSink evaluates it

var win, sine, impulse, dest;

win = Window("Drag and Drop", Rect(400,400,400,250));
win.background = Color.white;
win.front;

sine = DragSource(win, Rect(10, 20, 150, 20)).align_(\center);
sine.object =  { { SinOsc.ar(400) }.play };
sine.string = "Sine";
sine.dragLabel = "Sine";

impulse = DragSource(win, Rect(10, 50, 150, 20)).align_(\center);
impulse.object = { { Impulse.ar(80) }.play };
impulse.string = "Impulse";
impulse.dragLabel = "Impulse";

dest = DragSink(win, Rect(170, 20, 200, 200)).align_(\center);
dest.string = "Drop here to play";
dest.canReceiveDragHandler = { View.currentDrag.isKindOf(Function) };

dest.receiveDragHandler = { arg v;
	dest.object = View.currentDrag.value;
	dest.string = "click here for silence";
	dest.background_(Color.red)
};

dest.mouseDownAction = {
	dest.object.free;
	dest.string = "I evaluate a (sound) function";
	dest.background_(Color.clear)
};

)




////////////////////// Keyboard actions ////////////////////////

// As Ugen (a is 0)
{ Dust.ar(KeyState.kr(0, 200, 10, 4)) }.play;


( // Clicking on a view

SynthDef(\perc, {|freq=400|
	var sig, env;
	env = EnvGen.ar(Env.perc);
	sig = PMOsc.ar(freq, freq * 2, 0.5);
	Out.ar(0, sig * env ! 2);
}).add();

w = Window.new("Keys", Rect(200, 300, 400, 400));
w.background = Color.magenta;
w.view.keyDownAction = {|view, char|
	Synth(\perc, [\freq, char.ascii.midicps])
};

w.front

)


//////////////////////// Mouse actions /////////////////////////

// As UGen for clicking
{ Impulse.ar(MouseButton.kr(20, 200, 4), 0, 0.5) }.play;


// As Ugen for position
{ HPF.ar(Impulse.ar(MouseX.kr(20, 1000, 1), 0, 0.2), MouseY.kr(20, 10000, 1)) }.play;


( // Click on a view

SynthDef(\fm, {|carr=400, mod=200|
	var sig, env;
	env = EnvGen.ar(Env.sine);
	sig = PMOsc.ar(carr, mod, 10, mul:0.5);
	Out.ar(0, sig * env ! 2);
}).add();

w = Window.new("Mouse", Rect(200, 300, 600, 600));
w.background = Color.yellow;
w.view.mouseDownAction = {|view, x, y|
	Synth(\fm, [\carr, x, \mod, y ])
};

w.front

)



// More examples here:
ScIDE.open("examples/GUI examples/GUI_examples1.scd");
ScIDE.open("examples/GUI examples/GUI_examples2.scd");


// And in these help files:
What's new in Qt GUI
Resize behaviour
List of GUI classes
Introduction to GUI




///////////////////////// More Examples ////////////////////////

( // Knob with ControlSpec

var synth, knob, num, spec;
spec = ControlSpec(200, 2000, \exp);
Window("Knob", Rect(200,200,120,120)).front.layout_(
	VLayout(
		knob = Knob().mode_(\vert),
		num = NumberBox()
	)
);

synth = {|freq=440| Saw.ar(freq) * 0.1 ! 2}.play;
knob.action = {|v| var f = spec.map(v.value); num.value_(f); synth.set(\freq, f) };

)


( // Slider2D controlling two parameters

var synth;
synth = {|x=440, y=0.5| SinOsc.ar(x) * y ! 2}.play;
Window("XY", Rect(200,200,300,300)).front.layout_(
	VLayout(Slider2D().action_({|v| synth.set(\x, v.x.linexp(0,1,100,2000), \y, v.y) }))
);

)