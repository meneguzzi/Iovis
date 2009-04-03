//logging(true).
//logging(false).

//Printing lists
+!print([]) : true
	<- true.

+!print([H | T]) : logging(true)
    <- //.print("Printing list.");
       !print(H);
       !print(T).

//Printing everything else
+!print(M) : logging(true)
	<- .print(M).

+!print(M) : true
	<- true.

+!print(M1,M2) : logging(true)
	<- .print(M1,M2).

+!print(M1,M2) : true
	<- true.

+!print(M1,M2,M3) : logging(true)
	<- .print(M1,M2,M3).

+!print(M1,M2,M3) : true
	<- true.

+!print(M1,M2,M3,M4) : logging(true)
	<- .print(M1,M2,M3,M4).

+!print(M1,M2,M3,M4) : true
	<- true.

+!print(M1,M2,M3,M4,M5) : logging(true)
	<- .print(M1,M2,M3,M4,M5).

+!print(M1,M2,M3,M4,M5) : true
	<- true.

+!print(M1,M2,M3,M4,M5,M6) : logging(true)
	<- .print(M1,M2,M3,M4,M5,M6).

+!print(M1,M2,M3,M4,M5,M6) : true
	<- true.

+!print(M1,M2,M3,M4,M5,M6,M7) : logging(true)
	<- .print(M1,M2,M3,M4,M5,M6,M7).

+!print(M1,M2,M3,M4,M5,M6,M7) : true
	<- true.

+!print(M1,M2,M3,M4,M5,M6,M7,M8) : logging(true)
	<- .print(M1,M2,M3,M4,M5,M6,M7,M8).

+!print(M1,M2,M3,M4,M5,M6,M7,M8) : true
	<- true.

+!print(M1,M2,M3,M4,M5,M6,M7,M8,M9) : logging(true)
	<- .print(M1,M2,M3,M4,M5,M6,M7,M8,M9).

+!print(M1,M2,M3,M4,M5,M6,M7,M8,M9) : true
	<- true.