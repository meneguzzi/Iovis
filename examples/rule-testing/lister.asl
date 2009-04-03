

filter([], _, []).

filter([Term | Tail], Term, [Term | ListOut]) :- filter(Tail,Term,ListOut).

filter([H | Tail], Term, ListOut) :- filter(Tail,Term, ListOut).


+test(List) : true
   <- ?filter(List,ho,ListOut);
      .print("Filtered List", ListOut).