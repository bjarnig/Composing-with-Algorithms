////////////////////////////////////////////////////////////////
//
//                     Xenakis: Exercises
//
////////////////////////////////////////////////////////////////

// Twelve short exercises, then five longer ones. The SynthDefs \sine and \gliss
// are at the top of Xenakis.scd.


////////////////////////// Distributions ///////////////////////////

// 1. Play notes with Pwhite pitches between 60 and 72. Then change only the
//    distribution to Pexprand.




// 2. Use Pgauss for pitch with a mean of 60, and try deviations of 1, 6 and 24.




// 3. Draw 1000 values from Pbeta(0, 1, 0.3, 0.3) and plot their histogram. Then
//    try a = b = 3.




// 4. Give the durations a Pexprand between 0.05 and 1, with the pitch fixed.




// 5. Use Pbrown for pitch between 48 and 72 with a step of 1, then with a step
//    of 12.




// 6. Write the walk from 5 as a Pseries with Pwhite steps, folded between 48 and
//    72.





////////////////////////// Combined with patterns ///////////////////////////

// 7. A Pseq of three sections of 16 notes each: Pwhite, then Pgauss, then
//    Pexprand pitches.




// 8. Draw the amplitude from Pexprand(0.02, 0.2) and use Pkey so that louder
//    notes are shorter.




// 9. Two Pbinds in Ppar, one with Pbrown pitches and one with Pgauss pitches.




// 10. Change the Markov chain so that 72 can return to 60, then add a fifth
//    state.




// 11. Draw the eight levels of the Achorripsis row with a Poisson mean of 2, and
//    play the row they give.




// 12. Glissandi whose Gaussian speed deviation grows from 0 to 24 over twenty
//    seconds, using Pseg.





////////////////////////// Longer exercises ///////////////////////////

// 13. Implement a stochastic process that uses a different distribution for
//    amplitude, frequency and duration of events.




// 14. Implement a stochastic process where sequences of different distributions
//    are used.




// 15. Implement a rhythmic sequence where a Markov chain is used for duration
//    values.




// 16. Implement a sequence of Pbinds where each uses a brownian motion, Pbrown,
//    for controlling pitches in different ways. These should then be sequenced in
//    time using Pspawner.
