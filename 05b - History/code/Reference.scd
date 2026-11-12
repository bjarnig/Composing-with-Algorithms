////////////////////////////////////////////////////////////////
//
//            The patterns and array methods in History.scd
//
////////////////////////////////////////////////////////////////

One short example for each, in the order they appear in History.scd. Evaluate
a line with Shift+Return. The pattern examples use the default synth, and the
array examples post their result. Cmd+period stops everything.


////////////////////////// Patterns ///////////////////////////

// Pbind: a stream of events, each key set by a value or a pattern
Pbind(\degree, 0, \dur, 0.5).play

// Pseq: the list in order, here three times
Pbind(\degree, Pseq([0, 2, 4, 7], 3), \dur, 0.2).play

// Prand: a random item from the list each time
Pbind(\degree, Prand([0, 2, 4, 7], 16), \dur, 0.2).play

// Pwhite: a random number between a low and a high value
Pbind(\degree, Pwhite(0, 7, 16), \dur, 0.2).play

// patterns can be added, subtracted, multiplied and divided like numbers
Pbind(\degree, Pwhite(0, 7, 16) + Pseq([0, 7], inf), \dur, Pseq([1, 2], inf) / 8).play

// Pdict: looks up each key in a dictionary (an Event)
Pbind(\degree, Pdict((a: 0, e: 2, i: 4), Pseq([\a, \e, \i, \e, \a])), \dur, 0.3).play

// Pswitch: plays the pattern at the position the second pattern gives
Pbind(\degree, Pswitch([Pseq([0, 1, 2]), Pseq([7, 6, 5])], Pseq([0, 1, 1, 0])), \dur, 0.2).play

// Pindex: an item of a list by its position, counted from 0
Pbind(\midinote, Pindex([60, 64, 67, 72], Pseq([0, 1, 2, 3, 2, 1])), \dur, 0.2).play

// Pdup: repeats each value a number of times
Pbind(\degree, Pdup(3, Pseq([0, 4, 7])), \dur, 0.15).play

// Pfunc: runs a function for every event; here it reads the degree the event already has
Pbind(\degree, Pwhite(0, 7, 16), \amp, Pfunc { |event| if(event[\degree] > 4) { 0.4 } { 0.05 } }, \dur, 0.2).play

// Pkey: reads another key of the same event
Pbind(\degree, Pwhite(0, 7, 16), \dur, Prand([0.1, 0.3], inf), \legato, Pkey(\dur) * 2).play

// .select: keeps only the values the function says true for
Pbind(\degree, Pwhite(0, 7, inf).select { |d| d.even }, \dur, 0.15).play

// .trace: posts every value as it plays
Pbind(\degree, Pseq([0, 2, 4]).trace, \dur, 0.3).play

// .play with a TempoClock: here 2 beats per second
Pbind(\degree, Pseq([0, 2, 4, 7]), \dur, 1).play(TempoClock(2))

// Ppar: several patterns at the same time
Ppar([Pbind(\degree, Pseq([0, 2, 4]), \dur, 0.4), Pbind(\degree, Pseq([7, 9, 11, 9]), \dur, 0.3)]).play

// Ptpar: like Ppar, with a start time before each pattern
Ptpar([0, Pbind(\degree, Pseq([0, 2, 4])), 1.5, Pbind(\degree, Pseq([7, 9, 11]))]).play

// Pbindf: a copy of a Pbind with keys added or changed; \stretch scales every duration
a = Pbind(\degree, Pseq([0, 2, 4, 7]), \dur, 0.25); Pbindf(a, \octave, 4, \stretch, 2).play

// Pseg: moves between values over time, here from 200 to 800 Hz in 4 seconds and back
Pbind(\freq, Pseg(Pseq([200, 800, 200]), Pseq([4, 4]), \exp), \dur, 0.1).play

// Pmono: one synth that keeps playing while its values change
Pmono(\default, \freq, Pseg(Pseq([200, 600, 300]), Pseq([2, 2]), \sin), \dur, 0.1).play

// Rest: a silence inside a pattern
Pbind(\degree, Pseq([0, Rest(), 2, Rest(), 4]), \dur, 0.3).play


////////////////////////// Arrays ///////////////////////////

// Array.fill: makes an array by running a function a number of times; i counts from 0
Array.fill(5, { |i| i * 10 }).postln              // [0, 10, 20, 30, 40]

// .choose: a random item
[0, 2, 4].choose.postln

// rrand: a random number between two values
rrand(36, 96).postln

// .collect: a new array with the function applied to every item
[1, 2, 3].collect { |x| x * 2 }.postln            // [2, 4, 6]

// .select: only the items the function says true for
[1, 2, 3, 4, 5, 6].select { |x| x.even }.postln   // [2, 4, 6]

// .flat: joins nested arrays into one
[[1, 2], [3, 4]].flat.postln                      // [1, 2, 3, 4]

// .flop: swaps lines and columns
[[1, 2], [3, 4]].flop.postln                      // [[1, 3], [2, 4]]

// .reverse: the array backwards
[1, 2, 3].reverse.postln                          // [3, 2, 1]

// .permute: ordering number n of the items
[0, 1, 2].permute(1).postln                       // [1, 0, 2]

// .indexOf: the position of an item, counted from 0
[63, 62, 69].indexOf(69).postln                   // 2

// .size: how many items
[0, 2, 4, 7].size.postln                          // 4

// == compares two arrays item by item
([1, 2, 3] == [1, 2, 3]).postln                   // true

// an Event used as a table: look up a value by its name
(a: 55, e: 57)[\e].postln                         // 57


////////////////////////// Strings and numbers ///////////////////////////

// .toLower, .select and .isVowel: the vowels of a text, in lower case
"Ut Queant Laxis".toLower.select { |c| c.isVowel }.postln       // uueaai

// .as(Array) and .asSymbol: a string becomes an array of symbols
"aei".as(Array).collect { |c| c.asSymbol }.postln               // [a, e, i]

// .abs, .even, % (modulo), .sqrt and .reciprocal
[-3.abs, 4.even, 14 % 12, 2.sqrt.reciprocal].postln             // [3, true, 2, 0.70710678118655]

// thisThread.randSeed: the same random numbers every time it is set
thisThread.randSeed = 1; rrand(0, 100).postln
