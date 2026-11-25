////////////////////////////////////////////////////////////////
//
//                     Koenig: Exercises
//
////////////////////////////////////////////////////////////////

// Twenty-five short exercises, then seven longer ones. The SynthDefs are at the top
// of Koenig.scd: \sine, \gliss, \pluck, \bell, \breath, \blip and \drone, all with
// the arguments freq, amp, sus, pan and slide.

////////////////////////// Selection Principles ///////////////////////////

// 1. Play the list [60, 62, 63, 65, 67, 68, 70] as a Sequence, then as Alea.




// 2. Play the same list as a Series: every value once in a random order, with a new
//    order each time.




// 3. Play it as Ratio, with the first two values much more likely than the rest.




// 4. Play it as Group: each random value repeated between two and five times.




// 5. A Tendency between limits that start at 60 and 62 and widen to 36 and 96 over
//    twenty seconds.




// 6. One Pbind with a different selection principle for pitch, duration and
//    instrument.




////////////////////////// Combined with Earlier Classes ///////////////////////////

// 7. A Pseq of three Pbinds of eight notes, each using a different selection principle
//    for pitch.




// 8. The Streichquartett method: choose four of seven pitches, repeat each one to five
//    times, scramble and play.




// 9. A Gaussian pitch, Pgauss, whose mean follows a Pseg from 48 to 84 over fifteen
//    seconds.




// 10. Ratio for the durations and a random walk, Pbrown, for the pitch.




// 11. The same Pbind played three times in a row with Pseed and the seeds 1, 2 and 1.




// 12. Three Pbinds in Ppar with Pseq cycles of three, four and five pitches.




////////////////////////// Instruments ///////////////////////////

// 13. One phrase played by each of the seven instruments in turn, using Pdup on the
//    instrument.




// 14. Choose the instrument by Ratio: mostly \pluck, sometimes \bell, rarely \drone.




// 15. Give \drone a \sus of 3 and a Gaussian \slide around 0, with a new note every
//    second.




// 16. Glissandi on \drone between the five Terminus frequencies, so that none leaves
//    the range.




////////////////////////// Koenig's Programs ///////////////////////////

// 17. Use ~regularity on the same list with the values 1, 4 and 7, one after the
//    other.




// 18. List, Table, Ensemble: group 24 pitches with clump(4), choose a group every
//    eight events and a pitch from it every event.




// 19. Three \drone layers of different lengths in Ptpar that end together.




////////////////////////// Transition Tables ///////////////////////////

// 20. Derive the zero-order weights of a melody of your own and play it with Pwrand.




// 21. Write a first-order table for four notes in which every note can follow every
//    other but not itself.




// 22. Derive a first-order table from a melody with doAdjacentPairs and play it on
//    \bell.




// 23. Change 22 to a second-order table and compare how much of the melody returns.




////////////////////////// Xenakis and Koenig ///////////////////////////

// 24. Fill ten seconds with exponential gaps around a density of 8, then with 80 entry
//    delays chosen by Alea and scaled to fill the same ten seconds.




// 25. Draw a mask in the Tendency Mask tool, copy the pattern under it into a Pbind
//    and play it on \pluck.




////////////////////////// Longer exercises ///////////////////////////

// 26. Create three collections of pre-selected pitches and a process that will play
//    first some events from the first collection, then some from the other and finally
//    some from the third. The way notes are selected should be different at each time.




// 27. Create a process consisting of two layers where one plays low notes and the
//    other high notes. A tendency mask should be created for controlling the balance
//    between the two processes. It should start by favouring high notes and end
//    towards low ones.




// 28. Create a chord progression where the duration of each chord increases in time.
//    The pitches that form the chords should be selected from a predefined group(s) of
//    pitches.




// 29. Implement a process that selects durations from a collection of predefined
//    durations (rhythmic values). To the selected duration a variable number should be
//    added each time. This number should be very small in the beginning of the process
//    but increase as it unfolds.




// 30. Implement a tendency mask for frequency and duration values where the high and
//    low boundaries are determined by a random walk.




// 31. Implement a sequence of chords where the number of notes a chord consists of is
//    low at the start of the process but increases as it unfolds.




// 32. Implement a stochastic process where the high and low limits of a distribution
//    change in time. They should start by being very wide, far apart, but narrow as
//    the process unfolds.



