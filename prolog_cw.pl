/* 

* Lucca Anthony Marcondes Browning   <--- so we know who you are
* H00369673                          <--- so we know who you are
* Edinburgh.                         <--- Edinburgh, Dubai, or Malaysia 
* F28PL Coursework 3, Prolog         <--- leave this line unchanged 

* Deadline is *** Friday 9th December *** 2022 at 15:30, local time for your campus (Edinburgh / Dubai / Malaysia).

* It is not your marker's role to debug basic syntax errors.
* Therefore, if your script won't compile then it might not be marked.
* In other words: if swipl does not accept `prolog_cw.ml` successfully, then your marker is not obliged to mark your answers. 

* To do this coursework, FORK, THEN CLONE the gitlab project.

*/
        /* this is an executable prolog file */

/* Answer the following questions by filling in function definitions on the one hand, 
   and writing essay answers in comments on the other; 

   where you asked to provide code examples, be sure that they are NOT enclosed in 
   comments, but can be machine-checked along with the main file contents. */

/* Against each question, there is a marking scheme which is for INDICATIVE purposes only, 
   and may be adapted to circumstances. 

   An additional (5 marks) total may be awarded for code quality: 
   clarity
   comments
   additional test cases
   finding bugs
   etc. */            

/* ****************************** Start of Questions ********************************* */

/* (10 marks total) Question 1: functional vs. logic programming */

    /* consider the following implementation of 'fast' list-reverse in OCaml

    let rec helper xs ys = match xs with 
    | [] -> ys 
    | x :: xs -> helper xs (x :: ys)

    let fast_reverse xs = helper xs [] */

    /* (4 marks) Show how to take the above functional definition
       and translate it into prolog clauses.

    In your answer, pay careful attention to the arity/arities of the predicates involved,
    as well as explaining in your comments how you handle:
    
    a. (2 marks) pattern-matching
    b. (2 marks) recursion
    c. (2 marks) the role of types, if any. */

fast_reverse(List, Reversed) :-
  helper(List, [], Reversed).

helper([], Reversed, Reversed).

helper([Head|Tail], Accumulator, Reversed) :-
  helper(Tail, [Head|Accumulator], Reversed).

/* The first thing I needed to do was convert the Ocaml method to be more akin to english
   to make it easier to convert, so I changed it to read...
   
   let rec helper List Reversed = match List with 
    | [] -> Reversed
    | Head :: Tail -> helper Tail (Head :: Reversed)

    let fast_reverse List = helper List []
    
    Pattern Matching:
    I knew that I had to patten match both a base case, and a recursive case. Therefore, since there isn't
    technically pattern matching in prolog, I decided to overload the predicate helper - One of which would
    take an empty list as its first parameter (the base case) and one of which would take a list with elements
    as its first parameter (the recursive case). This means that one will run if helper is called with a list
    with elements as its first parameter, and the other will run if helper is called with an empty list as its
    first parameter. Hence, with a call to helper in fast_reverse, as there was in the original OCaml expression,
    I was able to mimic the pattern matching.
    
    Recursion:
    Before copying the recursive part of the expression over to OCaml, I had to understand exactly what it did.
    Basically what it does, is put the head from the non-reversed list (whatever that may be in that iteration) to
    the tail of the reversed list. (Head :: Reversed) just means that every new "head" will end up earlier in the list
    than the last. Therefore, the first element of the original list will always end up being placed after the second
    element of the list in the reverse list.
  
  	OCaml: helper Tail (Head :: Reversed);;
    Prolog: helper(Tail, [Head|Accumulator], Reversed).
    
    Inside of the recursive "pattern match", I decided to make a statement that would do the same thing.
    The parameters are as follows: 
    	* The current tail of the original (non-reversed) list. 
        * The current head of the original (non-reversed) list in a list preceeding the current reversed list.
          In the Prolog method, this had to be named something different (Accumulator) due to the nature of 
          the language that will be discussed in a bit.
        * Then the expression/predicate signature differs because in Prolog, one of the parameters needs to
          be a variable that the user enters in their query, which will return the missing value given the
          function of the predicate. That is what the "Reversed" parameter is there for.
    
    The Role of Types:
    There are five variables to be accounted for in the implimentation of this set of predicates:
    	* List - A (unreversed) List type.
        * Reversed - A List type that is returned in the typical use of querying using this predicate
        (However, one can input a reversed list and query the predicate to return the un-reversed List). 
        * Accumulator - A List Type that acts as the current reversed list before it is returned.
        * Head - An integer type that is the current head of the unreversed list.
        * Tail - A List type that is all current elements after the head of the unreversed list.
    
    The reason why there are two seperate variables for Accumulator and Reversed is because one of the 
    parameters needs to be a variable that the user enters in their query, which will return the 
    missing value given the function of the predicate and the other variable needs to "accumulate"
    all elements of the List variable in reverse before helper([], Reversed, Reversed) is called and
    returns the Accumulator as the Reversed list. */

/* ****************************** End of Question 1 ********************************* */

/* (10 marks) Q2: triangular numbers */

    /* (5 marks) Q2a. write rules defining a predicate `ints` of arity 2, so that
    
    ints(n,ns) holds exactly when ns = [0, 1, 2, ..., (n-1)], provided n > 0,
                              and ns = [], otherwise

    make clear in your answer if you use any auxiliary, or pre-defined, predicates
    in your solution, and explain their usage. */

ints(Num, List) :- 
    NewNum is Num - 1, /* Takes 1 away from num so the list is only n-1 elements long. */
    intsHelper(0, NewNum, [], List). /* Calls the "pattern matching" recursive helper method. */

/* The following code is the base case that will return the "acc" list as it is if End < Start. */
intsHelper(Start, End, Acc, Acc) :-
    End < Start.

/* The following code is the recursive case that adds the current n to a list before decrementing it
   (value is bound to DecEnd). This case is called until n (End) is -1 or below. */
intsHelper(Start, End, Acc, List) :-
    End >= Start,
    DecEnd is End - 1,
    intsHelper(Start, DecEnd, [End|Acc], List).
    

    /* (5 marks) Q2b. write rules defining a predicate `sum_of_ints` of arity 2, so that
    
    sum_of_ints(n,m) holds exactly when m = 0 + 1 + 2 + ... + (n-1), provided n > 0,
                                    and m = 0, otherwise

    make clear in your answer if you use any auxiliary, or pre-defined, predicates
    in your solution, and explain their usage. */

sum_of_ints(Num, Sum) :-
    ints(Num, ListOfNums), /* Calls the ints method that creates a list up to n-1 with incrementing numbers */
    sum_list(ListOfNums, Sum). /* Calls sum_list on the list to be addded together. */

/* The following code is the base case that will return the sum if there are no more elements to add together. */
sum_of_ints_helper([], 0).

/* The following code is the recursive case that adds the current head element to a sum before moving to the next
   element in the list. This happens until every element in the list has been added to the sum. */
sum_of_ints_helper([H|T], Sum) :-
   sum_of_ints_helper(T, Rest),
   Sum is H + Rest.
    
/* ****************************** End of Question 2 ********************************* */

/* (10 marks total) Question 3: unification */

    /* Consider the definitions of the following two predicates, un/2 and eq/2. */

un(X,X) :- true.
un(X,Y) :- false.

eq(X,Y) :- X is Y.
eq(Y,X) :- Y is X.

 
/*  by considering suitable example queries, involving constants (2 marks),
    constant expressions (2 marks), and also logic variables (2 marks),
    and the output behaviour of the Prolog interpreter on such queries,
    which you should include as comments in your answer, explain (4 marks)
    the difference(s), if any, between the two predicates `un` and `eq`. */


/* To discuss the difference in the way "un" functions and the way that "eq" functions, we
   must first discuss their similarities. Both predicates begin with a condition, which basically
   says: "Do this if un or eq meets this condition.". Afterwards, it returns a value to the user's
   query depending on what the latter part of the predicate specifies.
   
   For example, un(X,X) :- true. means that if both values inputted into un are equal, return true.
   Or, if one value of X is inputted into un, return all cases of what the other one would have to be
   in order to make the predicate true. 
   
   An example of un working with Constants, Constant Expressions, and Logic Variables is below.
   
   Constant 1 var: ?- un(3,x).
                   X = 3
                   false (returned when possible results are exhausted)
   Constant 2 var: ?- un(3,3).
                   true
                   false (returned when possible results are exhausted)
   Constant Expression 1 var: un((3+1),X).
                              X = 3+1
                              false (returned when possible results are exhausted)
   Constant Expression 2 var: un(3+1,3+1).
                              true
                              false (returned when possible results are exhausted)
   Logic Variables 1 var: un(true, X).
						  X = true
                          un(false, X).
                          X = false
   Logic Variables 2 var: un(true, true).
                          true
                          un(false, false).
                          true
   
   The difference between un and eq is that while un returns a simple logic variable depending on the
   nature of the values (A,B), eq returns the result of a function "A is B". This function approach
   can be very problematic for working with certain values.
   
   When eq is given one value and one variable as a parameter, it returns an error. This is because
   "X is Y" cannot be run on a value that does not point to an object yet. You're querying if something
   is nothing, and a computer cannot understand this.
   
   When eq is given two parameters that have the same value, unless they point to the same object 
   (like both being constants), they will return false. This is because it computes whether one value 
   points exact same object as another value (through the function "X is Y"). For example, if I 
   initialised variables A = 2+1. and B = 2+1, they wouldn't point to the same object in memory, 
   and would therefore not be the same thing despite identical behaviour.
   
   eq also does not work with logic variables because functions cannot take logic variables as 
   arguments in prolog.
   
   An example of eq working with Constants and Constant Expressions with two parameters is below.
   
    Constant 2 var: ?- eq(3,3).
				  	true
					true
    Constant Expression 2 var: eq(3+1,3+1).
    						   false */

/* ****************************** End of Question 3 ********************************* */

/* (20 marks total) Question 4: program comprehension */

    /* The following database of facts and rules defines a fragment of the ScotRail
    network of trainlines and towns between Edinburgh Waverley and Leuchars stations,
    together with the travel times between them in minutes
    (these travel times should be taken as specimens, and need not reflect real-world times!)

    Study the facts and rules carefully, then answer the questions below in comments,
    EXCEPT where you are asked to extend the database in Q4d. 
    */

/* some slow lines */

slow(waverley,10,haymarket).
slow(haymarket,17,inverkeithing).
slow(inverkeithing,12,kirkcaldy).
slow(kirkcaldy,19,cupar).
slow(cupar,13,leuchars).

/* some fast lines */

fast(waverley,20,inverkeithing).
fast(haymarket,20,kirkcaldy).
fast(kirkcaldy,20,leuchars).

/* a line is either slow or fast, but takes as long as it takes */

line(X,T,Y) :- slow(X,T,Y).
line(X,T,Y) :- fast(X,T,Y).

/* the longest journey begins with a single step */

journey(X,N,Z) :- line(X,L,Y), journey(Y,M,Z), N is L+M. 
journey(X,0,X) :- !.

long_journey(X,N,Z) :- long_journey(X,L,Y), long_journey(Y,M,Z), N is L+M. 
long_journey(X,0,X) :- !.

/* how long does it take? */
/*
total_journey_time(X,Y) :- journey(X,N,Y), N > 0, write("Total journey time is: "), write(N), write(" minutes\n").
total_journey_time(X,X) :- write("No need to take the train! Just stay where you are: "), write(X), write("\n").*/

total_journey_time(X,Y) :- shortest_journey(X,T,Y), T > 0, write("Total journey time is: "), write(T), write(" minutes\n").
total_journey_time(X,X) :- write("No need to take the train! Just stay where you are: "), write(X), write("\n").

    /* Q4a: querying the database */

    /* (2 marks) write a query to show all the possible routes from waverley to leuchars */
		/* journey(waverly,N,leuchars). */

    /* (2 marks) which of these routes takes the shortest time? the longest? */
		/* Shortest: 50. Longest: 71. */

    /* (2 marks) write a query to show all the possible routes from *any* station to leuchars */
		/* journey(X,N,leuchars). */

    /* (2 marks) which of these routes takes the shortest time? the longest? */
		/* If you include a route to itself, the shortest time is from Leuchars and lasts 0 mins.
		   If you don't include a route to isself, the shortest route is from Cupar and lasts 13 mins.
           The longest route is from Waverley and lasts 71 mins. */

    /* (2 marks) explain why the total_journey_time/2 predicate does NOT
       necessarily write out journey times in ascending/descending order? */
		/* The reason for this is that it queries all the routes in the order that they are written in
		   the actual .pl file. This means all of the slow ones starting with waverley, and all the fast ones,
           ending with kirkcaldy, and finally a route to itself are printed in that order. */

    /* Q4b: understanding the database */

    /* (2 marks) why would you avoid queries involving the `long_journey` predicate? */
  		/* The short answer is that the stack limit is exceded, and there is probable infinite recursion
		   (according to the compiler). The long answer is that long_journey has no garuantee it will ever
           reach the base case. This is primarily because it only calls itself, instead of calling the journey
           or line predicates, which are methods that lead to a direct interaction with the facts above. */

    /* Q4c: modifying the database */

    /* (2 marks) what change could you make to the above program to try fast lines before slow ones? */
		/* As previously mentioned, prolog queries all the routes in the order that they are written in
		   the actual .pl file. Therefore, we could just put the fast routes before the slow ones in the .pl
           file, instead of the way they are organised now with the slow routes before the fast ones. */

    /* (2 marks) what change could you make to the above program to show the intermediate stations along any journey? */
		/* One could add another statement inside of the journey predicate that prints the current line, which includes
		   information like the starting station for that leg of the journey, the ending station for that leg of the journey,
           as well as how long it takes to get from the starting station for that leg to the ending station of that leg.
           You can do this like so:
           
           journey(X,N,Z) :- line(X,L,Y), write(line(X,L,Y)), journey(Y,M,Z), N is L+M. 
		   journey(X,0,X) :- !. */

    /* BONUS Question Q4d: extending the database */

    /* (4 marks) how might you extend the database with a new predicate, shortest_journey/2

    which will compute the *shortest* journey time between any two towns in the database?

    Explain carefully how you arrived at your solution, and what additional predicates,
    if any, predefined or otherwise, you may need in your answer.
    
    */

shortest_journey(X,T,Y) :- findall(L,journey(X,L,Y),Times), min_list(Times,T).

	/* One way to extend the database with a new predicate, shortest_journey, is to add a new predicate
	for calculating the shortest journey time between any two stations. This rule can use the existing
	journey predicate to determine the available train lines between two stations (using findall), 
	and then use a built-in minimum function (min_list) to calculate the shortest journey time from 
	the list of available train lines.

	To use this new rule, the total_journey_time predicate can be modified to use the shortest_journey
	predicate instead of the journey predicate. This change can be seen above below the original 
    total_journey_time predicate. */

/* ****************************** End of Questions ********************************* */
