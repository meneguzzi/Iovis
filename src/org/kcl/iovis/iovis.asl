+norm(Start, End, Norm, Options)[source(Src)] : true
   <- ?acceptNorm(Start, End, Norm, Options, Src);
      !addNorm(Start, End, Norm, Options).
      
+?acceptNorm(Start, End, obligation(Obligation), Options, Src) : true
	<- .print("Accepting obligation to ", Obligation, " from ", Src).

+?acceptNorm(Start, End, prohibition(Prohibition), Options, Src) : true
	<- .print("Accepting prohibition to ", Obligation, " from ", Src).
	
+!addNorm(Start, End, Norm, Options) : true
   <- //add some content
      true.

//Action obligation
+!addNorm(Start, End, obligation(Obligation), Options) : .action(Obligation)
   <- .concat("@obligationStart(",Obligation,")", 
              "+", Start, ": true <- ",
              Obligation,".",OPlan
              );
      .concat("@obligationEnd(", Obligation, ")",
              "+",End, ": true <- ",
              ".remove_plan(@obligationStart(",Obligation,"));",
              ".remove_plan(@obligationEnd(",Obligation,")).",
              EPlan);
      .add_plan([OPlan,EPlan]);
      true.

//Proposition obligation
+!addNorm(Start, End, obligation(Obligation), Options) : .literal(Obligation)
   <- .concat("@obligationStart(",Obligation,")", 
              "+", Start, ": not ",Obligation,
              "<-", "!goalConj([",Obligation,"],
              OPlan).";
      .concat("@obligationEnd(", Obligation, ")",
              "+",End, ": true <- ",
              ".remove_plan(@obligationStart(",Obligation,"));",
              ".remove_plan(@obligationEnd(",Obligation,")).",
              EPlan);
      .add_plan([OPlan,EPlan]);
      true.

+!addNorm(Start, End, prohibition(Prohibition), Options) : .action(Prohibition)
              