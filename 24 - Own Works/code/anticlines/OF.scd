
( /* Installation */

Quarks.install("https://github.com/bjarnig/OF")

)

/*

01 - Dynamic waveform generation and transformations.

*/

(

// Initialize OF
o = OF(this);

// Parameters for waveform duration size and minimum and maximum duration
a = o.waveform.opca(\op, 100); a.play;

// Runtime parameters for cycle duration and modulation
a.set(\sdm, rrand(0.1,0.5),\mod, rrand(1,10));

// Modulate a parameter
a.modulate(\sdm, { LFNoise1.kr(10, 0.1, 0.2) } );

// Append a transformation operation
a.transform( o.processing.foldorm() );

// Parameter movement for amplitude
a.control( o.control.brownian(\amp, 0.2, 0.01, 1.2 ));

// Another transformation
a.transform( o.processing.dualdist() );

// Interrump through an action
o.action.interrupt(\op);

)

/*

02 - Transformation sequences and pipelines

*/

( /* Stacking transformations */

o = OF(this); a = o.waveform.hectn(\pl);
a = a.stack([\clip, \minsaw, \bfold, \minsaw].scramble, o).play;

)


( /* Transformations and intervals */

o = OF(this); a = o.waveform.hectn(\ti); a.play;
a.stackd([\clip, \clip, \minsaw, \minsaw, \minsaw, \bfold], o, 2, 3).play;

)


( /* Parameters, processing and random order */

o = OF(this);
a = o.synthesis.vsaw(\vsaw);
a.stackprand([
	[\bfold, (\bffreq: 2, \bfstop: 100)],
	[\drift, ()]
], o, 20, 2);

a.transform( o.processing.diffuse ).play

)



( /* Nested pipelines with parameters and duration */

o = OF(this);

a = o.waveform.costa(\co);

a.stackpd([
	[\bfold, 3, (\bffreq: 20, \bfstop: 100)],
	[\drift, 14, ()],
	[\wloss, 21, ()],
	[\nmod, 12, (\nfreq: 1000)]
], o);

b = o.waveform.hectn(\pl);
b.stack([\clip, \minsaw, \bfold, \minsaw].scramble, o);

c = o.waveform.dramp(\dramp);
c.stackd([\clip, \clip, \minsaw, \minsaw, \minsaw, \bfold], o, 3, 5);

// Submit the three pipelines to a switching algorithm
o.behaviour.switchx( OFPool[a,b,c] ).play

)



/*

03 - Direct access, observers and reactions for content-based triggers and actions.

*/

( /* Pipelines and Observers */

// Start OF
o = OF(this);

// Generate a waveform
a = o.waveform.foral(\fo); a.play;

// Couple an observer
o.observe.adapt(\fo);

// Apply disturbance
o.action.disturb(\fo);

// Attach a behaviour
o.behaviour.mfb(\fo).play

)



/*

04 - Anticlines Examples

*/

(

o = OF(this);

a = o.synthesis.drol(\drol).play(16);  b = o.waveform.leaf(\leaf).play(18); b.set(\to, 40); b.set(\from, 0.2);

a.variatestack(a,b,[
	[\fold7, 10],
	[\amclip, 14],
	[\wloss2, 8],
	[\fold6, 6],
	[\lfdnamp, 11],
	[\amclip, 11],
	[\lfdnamp, 8],
	[\filtfold2, 12],
	[\rmsfold2, 9],
	[\freqshift, 6],
	[\fold6, 6]
], o);

)

