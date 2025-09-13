////////////////////////////////////////////////////////////////
//
//                     Functions & Iteration
//
////////////////////////////////////////////////////////////////

Functions, Arguments, Variables & Iteration.


////////////////////////// Functions ///////////////////////////


// simple function
a = { 'I am a function' }

a.value

// simple function with name
(
var myFunction;

myFunction = {10 * 2};

myFunction.value.postln;
)


// function with arguments, variables and calculation
f = { |a, b|  var c;   c = a * b; c * 2 }

f.value(1, 2)


// empty funcion
{ 6; 8 }.value


// function that returns a calculated value
{ 1 + 1 }.value


// function causes side-effects
n = 4
f = { n = 8 }
f.value
n


// display the translated byte code for a function
~function = { 2 + 4 }
~function.def.dumpByteCodes




////////////////////////// Arguments ///////////////////////////

// function with arguments
f = {arg a,b; a.pow(b)}

f.value(5,3)


// function with arguments using vertical bars (pipe style)
~combineNames = {|first, second| "The composers name is" + first + second}


~combineNames.value("Giacinto", "Scelsi")


// function with an unknown number of arguments
f = {|... numbers| numbers.sum }
f.value(1,2,3)


// function with default arguments and arg keyword
~omlette = {|eggs=4, cheese=0.5, butter=1, ham=2|
eggs * cheese * butter * ham}
~omlette.value(ham: 4)


// function where the default value is an expression
{ |rand = (10.rand)| "Random number is" + rand }.value





///////////////////////// Decomposition ////////////////////////

// a code for a melody all in one function
(

~myLongPiece = {
var pitches, durations;

	pitches = [60, 64];
	pitches = pitches ++ (pitches * 2);
	pitches = pitches ++ (pitches * 0.5);

	durations = [0.5, 0.2];
	durations = durations ++ (durations * 4);
	durations = durations ++ (durations * 0.2);
	durations.postln;

	Pbind(
		\midinote, Pseq(pitches, inf),
		\dur, Pseq(durations, inf)
	).play
};

~myLongPiece.value;
)

// decomposing the code using functions
(

~add = {|list, amount| list ++ (list * amount) };

~player = {|pitches, durations|
	Pbind(
		\midinote, Pseq(pitches, inf),
		\dur, Pseq(durations, inf)
).play };

~myShortPiece = {
	~player.value(
		~add.value(~add.value([60, 64], 1.2), 0.5),
		~add.value(~add.value([0.5, 0.2], 4), 0.2))
}.value;
)




/////////////////////////// Iteration //////////////////////////

// iterate a list of items and multiplies by ten
do ( [1,2,3,4], {|item, index| (item * 10 + index).postln } )


// do something a number of times
7.do ( { rrand(10,100).postln } )


// goes from 10 to 50 and prints each step
for (10, 50, { arg i; i.postln });


// goes from 10 to 100 by a stepsize of 10
forBy (10, 100, 10,  { arg i; i.postln });


// fille p with random pitches until it has at least 32 ones
p = [];
while ({p.size < 32}, {p = p ++ Array.series(rrand(2, 4), 64.rand, 1)});
p


// repeat a pattern and ask for its next 32 values
x = Prand([10, 12]).loop.asStream;
x.nextN(32);

// loop using a routine and yield

~routine = {
	loop {
		(degree: 10.rand, dur: 0.5, amp: 0.1.rand).play;
		0.05.rand.wait;
	}
};

~routine.fork;
~routine.stop;
