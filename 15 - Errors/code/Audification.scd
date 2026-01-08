////////////////////////////////////////////////////////////////
//
//                       Audification
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;


/////////////////// Load File as Buffer ///////////////////


(

var file = File.open(~path ++ "data/atoms.pdf", "rb");
var signal = file.readAllSignal;

signal.normalize;
signal = signal.reject({arg item; item.isNaN });

~pdfBuf = Buffer.alloc(s, signal.size);
~pdfBuf.loadCollection(signal);

)

{ PlayBuf.ar(1, ~pdfBuf, loop: 1) ! 2 }.play



/////////////////// Pattern to Waveform ///////////////////


( // Uses a Pattern to write a Waveform

~patternToBuffer = { |pattern, dur=3|
	var n = s.sampleRate * dur;
	var data = pattern.asStream.nextN(n).flat.reject(_.isNil);
	var buf = Buffer.alloc(s, data.size);
	buf.loadCollection(data);
	buf
};

)

( // Example Pattern and Play the Buffer

var pattern = Pdup(
	Pexprand(10, 20),
	Pclump(Pexprand(1, 150), Pbrown(-0.8, 0.8, 0.1))
).flatten;

~patBuf = ~patternToBuffer.(pattern, 2);

)

{ PlayBuf.ar(1, ~patBuf, loop: 1) ! 2 * 0.5 }.play



( // Second Example

var pattern = Pseq([
	Pgeom(0.01, 1.1, 50),
	Pgeom(1.0, 0.9, 50)
], inf);

~clickBuf = ~patternToBuffer.(pattern, 1);

)

{ PlayBuf.ar(1, ~clickBuf, MouseX.kr(0.5, 8), loop: 1) ! 2 * 0.3 }.play


( // Pwrand example

var pattern = Pwrand(
	[Pwhite(-1.0, 1.0, 1), Pseq([0], 10)],
	[0.1, 0.9],
	inf
);

~sparseBuf = ~patternToBuffer.(pattern, 2);

)

{ PlayBuf.ar(1, ~sparseBuf, loop: 1) ! 2 * 0.75 }.play




/////////////////// Array to Audio ///////////////////


( // 1

var arr = Array.fill(8192, { |i|
	sin(i * 0.1) * (1 - (i / 8192)) + (0.3.rand2)
});

~arrBuf = Buffer.alloc(s, arr.size);
~arrBuf.loadCollection(arr);

)

{ PlayBuf.ar(1, ~arrBuf, MouseX.kr(1, 20), loop: 1) ! 2 * 0.3 }.play


( // 2

var arr = Array.series(4096, -1, 2/4096).collect { |x|
	if(0.1.coin, { x.neg }, { x })
};

~glitchSaw = Buffer.alloc(s, arr.size);
~glitchSaw.loadCollection(arr);

)

{ PlayBuf.ar(1, ~glitchSaw, MouseY.kr(10,200), loop: 1) ! 2 * 0.3 }.play


( // 3

var arr = Array.fill(2048, { |i|
	var phase = i / 2048 * 2pi;
	sin(phase) + (sin(phase * 7) * 0.3) + ((i % 32) / 32 - 0.5) * 0.2
});

~weirdWave = Buffer.alloc(s, arr.size);
~weirdWave.loadCollection(arr);

)

{ PlayBuf.ar(1, ~weirdWave, MouseX.kr(20, 400), loop: 1) ! 2 * 0.3 }.play


