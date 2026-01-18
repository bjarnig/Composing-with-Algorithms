(

////////
////
// sampleSeqs: methods for sample readers
////
////////

~sampleSeqs = ( );

~sampleSeqs.a = {|ev, synth, buf, dur=16, amp=0.5, note=50, pos=0.8|

var ampLevels, ampTimes, maskHL, maskHT, maskLL, maskLT;

ampLevels = [0.01, 1, 0.8, 0.02, 1, 0] * amp;
ampTimes = [0.1, 0.3, 0.1, 0.3, 0.2] * dur;

maskHL = [0.7, 0.55, 0.8, 0.2, 0.11];
maskHT = [0.3, 0.2, 0.4, 0.1];

maskLL = [0.3, 0.45, 0.2, 0.1, 0.09];
maskLT = [0.3, 0.2, 0.4, 0.1];

Pfindur(dur,
Pbind(
	\instrument, synth,
    \mHi, Pn(Penv(maskHL, maskHT)),
	\mLo, Pn(Penv(maskLL, maskLT)),
	\buf, buf,
	\note, note,
	\amp, Pn(Penv(ampLevels, ampTimes)),
	\dur, Pbrown(1/16, 1/2, 1/64),
	\mod, Pbeta(0.01, 0.9),
    \atk, 0.1,
	\sus, 0.2,
	\rel, Pfunc({|ev| rrand(ev.mHi, ev.mLo) * 2}),
	\pos, pos
));

};


~sampleSeqs.b = {|ev, synth, buf, dur=16, amp=0.4, note=50, pos=0.8|

var ampLevels, ampTimes, maskHL, maskHT, maskLL, maskLT;

ampLevels = [0.01, 0.3, 0.9, 0.6, 1, 0] * amp;
ampTimes = [0.1, 0.3, 0.2, 0.1, 0.3] * dur;

maskHL = [0.2, 0.4, 0.8, 0.9, 0.6];
maskHT = [0.3, 0.2, 0.4, 0.1];

maskLL = [0.1, 0.15, 0.3, 0.1, 0.4];
maskLT = [0.3, 0.2, 0.4, 0.1];

Pfindur(dur,
Pbind(
	\instrument, synth,
    \mHi, Pn(Penv(maskHL, maskHT)),
	\mLo, Pn(Penv(maskLL, maskLT)),
	\buf, buf,
	\note, note,
	\amp, Pn(Penv(ampLevels, ampTimes)),
	\dur, Pbrown(1/16, 1/2, 1/32),
	\mod, Pn(Penv([0.5, 0, 1], [0.5, 0.5] * dur)),
    \atk, Pfunc({|ev| rrand(ev.mHi, ev.mLo) * 2}),
	\sus, 0.2,
	\rel, Pfunc({|ev| rrand(ev.mHi, ev.mLo) * 4}),
	\pos, pos
));

};


~sampleSeqs.c = {|ev, synth, buf, dur=16, amp=0.4, note=50, pos=0.8|

var ampLevels, ampTimes, maskHL, maskHT, maskLL, maskLT;

ampLevels = [0.01, 0.3, 0.9, 0.6, 1, 0] * amp;
ampTimes = [0.1, 0.3, 0.2, 0.1, 0.3] * dur;

maskHL = [0.2, 0.4, 0.8, 0.9, 0.6];
maskHT = [0.3, 0.2, 0.4, 0.1];

maskLL = [0.1, 0.15, 0.3, 0.1, 0.4];
maskLT = [0.3, 0.2, 0.4, 0.1];

Pfindur(dur,
Pbind(
	\instrument, synth,
    \mHi, Pn(Penv(maskHL, maskHT)),
	\mLo, Pn(Penv(maskLL, maskLT)),
	\buf, buf,
	\note, note,
	\amp, Pbrown(amp/8, amp, 0.1),
	\dur, Pn(Penv([1/8, 1/2, 1/4], [0.5, 0.5] * dur)),
	\mod, Pn(Penv([0.2, 0.6, 0.9], [0.5, 0.5] * dur)),
    \atk, Pbrown(0.1, 0.8, 0.1),
	\sus, Pbrown(0.1, 0.8, 0.1),
	\rel, Pbrown(0.5, 1.2, 0.1),
	\pos, pos
));

};


~sampleSeqs.d = {|ev, synth, buf, dur=16, amp=0.5, note=50, pos=0.8|

var ampLevels, ampTimes, maskHL, maskHT, maskLL, maskLT;

ampLevels = [0.01, 0.3, 0.9, 0.6, 1, 0] * amp;
ampTimes = [0.1, 0.3, 0.2, 0.1, 0.3] * dur;

maskHL = [0.2, 0.4, 0.8, 0.9, 0.6];
maskHT = [0.3, 0.2, 0.4, 0.1];

maskLL = [0.1, 0.15, 0.3, 0.1, 0.4];
maskLT = [0.3, 0.2, 0.4, 0.1];

Pfindur(dur,
Pbind(
	\instrument, synth,
    \mHi, Pn(Penv(maskHL, maskHT)),
	\mLo, Pn(Penv(maskLL, maskLT)),
	\buf, buf,
	\note, note,
	\amp, 0.1,
	\dur, 1/4,
	\mod, Pbrown(0.01, 0.8, 0.1),
    \atk, 0.1,
	\sus, 0.1,
	\rel, 0.1,
	\pos, pos
));

};

)