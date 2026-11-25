////////////////////////////////////////////////////////////////
//
//                     Examples: Exercises
//
////////////////////////////////////////////////////////////////

// Twenty short exercises, then six longer ones. The SynthDefs are at the top of
// Patterns.scd: \sine, \gliss, \pluck, \bell, \breath, \blip and \drone, all with
// the arguments freq, amp, sus, pan and slide, and \mono for Pmono.

////////////////////////// Events and Pitch ///////////////////////////

// 1. Play one event on \bell with a frequency of 1234.5 Hz, then one with a \midinote
//    of 60.5.




// 2. A Pbind whose \freq is 110 times the ratios [1, 1.13, 1.47, 2.71], in order.




// 3. Frequencies from Pexprand between 50 and 5000 on \sine, with \sus and \dur of
//    0.02.




// 4. A rest of one second after every eight events.




////////////////////////// Lists and Numbers ///////////////////////////

// 5. Pxrand over four frequencies of your own that are not in a scale.




// 6. Pwrand for the durations: mostly very short, sometimes one of two seconds.




// 7. Pshuf over five instruments, so that each is heard in turn.




// 8. Pbrown on \freq between 200 and 2000, first with a step of 50, then 500.




// 9. Forty durations from Pgeom, starting at 0.5 and multiplied by 0.9 each time.




// 10. A Pseries of \midinote from 30, rising by 1.5 for forty events.




////////////////////////// Shapes and Relations ///////////////////////////

// 11. A Pseg that takes \dur from 0.5 to 0.01 over ten seconds.




// 12. Higher frequencies are shorter: \sus is 200 divided by \freq, with Pkey.




// 13. A Pfunc that returns a rest one time in four, and a duration of 0.1 otherwise.




// 14. Each random frequency repeated between one and six times with Pdup.




////////////////////////// Layers, Form and Pmono ///////////////////////////

// 15. A low \drone layer and a high \blip layer together, with Ppar.




// 16. Three copies of one pattern entering 0, 1 and 2 seconds apart, each given
//    another instrument with Pbindf.




// 17. With Pspawner: a cloud for four seconds, two seconds of silence, then glissandi
//    for four seconds.




// 18. A noise texture in a Pdef, its frequency range changed while it plays.




// 19. Pmono on \mono, gliding between frequencies from Pexprand.




// 20. Two voices phasing: the same six notes with durations of 0.2 and 0.205.




////////////////////////// Longer exercises ///////////////////////////

// 21. Create a three-part form, A B A, with Pspawner. A is sparse and uses a Poisson
//    distribution for its gaps, B is dense and uses a Gaussian distribution, and the
//    returning A is varied.




// 22. Build a texture with a tendency mask whose boundaries follow a random walk.




// 23. Make a piece of several voices in which each voice uses a different
//    distribution.




// 24. Use Pclutch to freeze values in two voices at different rates, so that the holds
//    interlock rhythmically.




// 25. Create a pattern that uses Pfsm to switch between different distributions, one
//    for each state.




// 26. Make a slowly changing drone of at least thirty seconds with Pmono and Pseg, in
//    several layers placed with Pspawner.



