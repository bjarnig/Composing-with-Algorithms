////////////////////////////////////////////////////////////////
//
//                          Basics
//
////////////////////////////////////////////////////////////////

Syntax, Objects, Statements, Expression, Variables, Declarations,
Assignments, Operators, Literals, Boolean logic and Control flow.


////////////////////////// Objects /////////////////////////////

// creation using new
p = Point.new(1, 2)


// creation using a class method
d = Date.getDate


// fixed object slot creation with 'new' omitted
e = Env([0,1], [1])


// dynamic object slot
a = [1,2, "this is an array"]


// r is a rectangle, top an instance variable and moveTo a method.
r = Rect(2, 4, 6, 8)
r.top
r.moveTo(10, 12)


// messages are used to interact with an object
"this is a string".scramble


// messages can be chained
"reverse it and convert to upper".toUpper.reverse


// major is a class method, degrees an instance method
m = Scale.major()
m.degrees()



////////////////////////// Arguments ///////////////////////////

// no arguments specifed
{ SinOsc.ar }.play


// all arguments specifed
{ SinOsc.ar(200, 0, 1, 0) }.play


// only freq and mul specified using argument keywords
{ SinOsc.ar(freq: 200, mul: 0.1) }.play


// specify multiple arguments to a method seperated by a comma
Array.series(10, 5, 2)


// use * to send a list of arguments to be split to values
Array.series(*[10, 5, 2])


 // omit paranthesis if the only message is a function
10.do({'programming'.postln})
10.do{'programming'.postln}



////////////////// Expressions & Statements ////////////////////

// simple expression
2 * 4


// expression with strings
"sono" ++ "logy"


// simple statement
["composing", "music"].choose


// assignment statement
x = [1, 2, 3, 4].rotate(1);


// if statement
if(1.0.rand >= 0.5 ) {"0.5 or higher"} {"lower than 0.5"}



////////////////// Variables & Assignments /////////////////////

// x is an instance variable of point
Point(1, 2).x


// all is an class variable of OSCresponder
OSCresponder.all


// environment variable
~myNumber = 666


// displays all environment variables
currentEnvironment

// interpreter variables (26 a-z defined)
a = "some outside-class string variable"


// the object running the current code
this


// all instances used in the current interpreter.
this.dump


// current running method
thisMethod


// current running thread
thisThread


// single assignment
c = 2 + 4;


// multiple assignments, assign a=1, b=2, c=3
# a, b, c = [1, 2, 3, 4, 5, 6];


// multiple assignments, assign a=1, b=2, c = [3, 4, 5, 6]
# a, b ... c = [1, 2, 3, 4, 5, 6];


// series assignment, with start and end values
a = (0..10);


// series assignment, with start, increment and end values
a = (0,2..64);


// value variables
a = 1
a
b = a
b
a = 2
a
b

// reference variables
c = Ref.new
d = c
c.value = 12
d



////////////////////// Operators & Comments ////////////////////

// binary operators take a left and right operand
[1,2] + [3,4]


// ++ joins two sequencable collections
[1,2] ++ [3,4]


// first the calculation then as string
((1 + 2).asString)


// two strings combined
("1" ++ "2")


// as string then combined
(1.asString ++ 2.asString)


// calculation then to string
"1+2". interpret


// "" equals as string
(1.asString ++ "+2").interpret


// paranthesis can force precedance
1 + (2 * 2)


// unary operators operate on one value only
n = 0.666
n.ceil
n.floor

// unary inversion operator
0.444.neg


// clip by a minimum threshold
(1.0.rand).min(0.8)


Comments can be single or multi lines

// single line comment

/*
    multi
    line
    comment
*/


/////////////////////// Literals and Types /////////////////////

// a float
a = 1.2
a.class


// a character
c = $c
c.class


// a string
s = "don't use s, it's for the server!"
s.class


// a symbol
l = \l
l.class


// it's true
t = True
t.class


// literal array
a = #["array", "that", "can't", "be", "changed"]


// for possible messages send dumpInterface
Array.dumpInterface


// for inspection use .class, .dump, isKindOf
a = 'something'
b = "anything"

a.class
b.dump
a.isKindOf(Symbol)



///////////////////////// Boolean Logic ////////////////////////

// both must be true
1 & 1


// either one is true
(1 == 1) || (1 == 2)


// neither one is true with not operator
not(1 == 2) && not(1 == 3)


// equals
1 == 2


// does not equal
1 != 2


// greater then or equal
1 >= 2


// less then or equal
1 <= 2


// .. less then or equal
1 <= 1


// if true, then do first function otherwise do the second
if("a" == "a", {"it's a!"}, {"it's not a"})


// always true
true.if({"it is true"}, {"it is false"})


// two different options
[true,false].choose.if({"it is ture"}, {"it is false"})


// and is also a methods
("sono" == "logy").and("logy" == "logy")


// or is as well
("sono" == "logy").or("sono" == "sono")



///////////////////////// Conditionals /////////////////////////

// only an if clause
if(Date.getDate.second % 2, { "do stuff only on even seconds" })


// toss a coin for further execution, if and else clauses
if(0.5.coin, {"true it is"}, {"false sometimes"})


// test for further execution
if ( [false, true].choose,
    { "expression was true" },
    { "expression was false" }
)


// switch offers branching for different possibilities
(
var number = [1,2].choose;

switch(number,
	1, {"make noise"},
	2, {"insert silence"})
)


// case is an assignment way of choosing among various options
(
var i, x, z;
z = [0, 1, 2];
i = z.choose;
x = case
    { i == 1 }   { \no }
    { i == 2 } { \wrong }
    { i == 0 }   { \true };
x;
)


//////////////// Brackets, Braces, and Parentheses /////////////

// empty array
a = []


// array with integers
b = [0, 1]


// function for calculating 2 + 4
f = { 2 + 4 }


// function with arguments
g = {arg number; number * 2 }
g.value(8)


// empty event
e = ()
e.play

s

// event with duration and pitch
m = (\dur: 2, \midinote: 24)
m.play


// code block
(
x = 2 + 4.rand;
y = 8 + 16.rand;
x + y
)

///////////////////////// Boolean Logic ////////////////////////

// both must be true
1 & 1


// either one is true
(1 == 1) || (1 == 2)

// neither one is true with not operator
not(1 == 2) && not(1 == 3)

0.3.coin

// equals
1 == 2


// does not equal
1 != 2


// greater then or equal
1 >= 1


// less then or equal
1 <= 2


// .. less then or equal
1 <= 1


// if true, then do first function otherwise do the second
if("a" == "ab", {"it's a!"}, {"it's not a"})


// always true
true.if({"it is true"}, {"it is false"})


// two different options
[true, false].choose.if({"it is true"}, {"it is false"})


// and is also a methods
("sono" == "logy").and("logy" == "logy")


// or is as well
("sono" == "logy").or("sono" == "sono")



///////////////////////// Conditionals /////////////////////////



// only an if clause
if(Date.getDate.second % 2 == 0, a)

// toss a coin for further execution, if and else clauses
if (0.5.coin, {"true it is"}, {"false sometimes"})




// test for further execution
if ( [false, true].choose,
    { "expression was true" },
    { "expression was false" }
)


// switch offers branching for different possibilities
(
var number = [1,2,3].choose;

switch(number,
	1, {"make noise"},
	2, {"insert silence"},
	3, {"asdf"})
)


// case is an assignment way of choosing among various options
(
var i, x, z;
z = [0, 1, 2];
i = z.choose;
x = case
    { i == 1 } { \no }
    { i == 2 } { \wrong }
    { i == 0 } { \true };
x;
)