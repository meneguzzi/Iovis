{include("print.asl")}

logging(true).

+norm(Start, End, Norm, Options)[source(Src)] : true
   <- ?acceptNorm(Start, End, Norm, Options, Src);
      !processNorm(Start, End, Norm, Options).
      
+?acceptNorm(Start, End, obligation(Obligation), Options, Src) : true
	<- !print("Accepting obligation to ", Obligation, " from ", Src).

+?acceptNorm(Start, End, prohibition(Prohibition), Options, Src) : true
	<- !print("Accepting prohibition to ", Prohibition, " from ", Src).
	
+!processNorm(Start, End, Norm, Options) : ignoreNorms
   <- //add some content
      true.

//Action obligation
+!processNorm(Start, End, obligation(Obligation), Options) : org.kcl.iovis.reflect.action(Obligation)
   <- !print("Adding action obligation");
      !addActionObligationStartCondition(Start, Obligation, Options);
      !addActionObligationEndCondition(End, Obligation, Options);
      //.add_plan([OPlan,EPlan]);
      !print("Norm ",obligation(Obligation)," added").

//We have three cases for the start condition of each obligation type

//The start condition is already true, in which case the obligation should
//be carried out immediately
+!addActionObligationStartCondition(Start, Obligation, Options) : Start
   <- !print("Executing action for obligation ", Obligation);
      !addActionObligationStartCondition(now, Obligation, Options);
      +now;
      -now;
      !print("Executed action for obligation ", Obligation).

//The obligation is impossible, so I should ignore it
//******************* Not sure how to prove this, simply false now
+!addActionObligationStartCondition(false, Obligation, Options) : true
   <- !print("Obligation to ", Obligation, " is impossible.").

//The obligation is not yet true, so I should add the plan to react to it
+!addActionObligationStartCondition(Start, Obligation, Options) : not Start
   <- !print("Adding plan for start of obligation to ", Obligation);
      act.puts("@obligationStart(#{Obligation}) ",
               "+#{Start} : true <- #{Obligation}.",
               OPlan);
      .add_plan(OPlan).


//We have three cases for the end condition of each obligation type

//The end condition is true, in which case we should execute the ending
//code immediately
+!addActionObligationEndCondition(End, Obligation, Options) : End
   <- .remove_plan(obligationStart(Obligation)).

//The Obligation will never end, so no need to add a plan to handle this
//******************* Not sure how to prove this, simply false now
+!addActionObligationEndCondition(false, Obligation, Options) : true
   <- !print("Obligation to ", Obligation, " never ends.").

//The end condition is not yet true, so we should add a plan to handle this
+!addActionObligationEndCondition(End, Obligation, Options) : not End
   <- !print("Adding plan for end of obligation to ", Obligation);
      act.puts("@obligationEnd(#{Obligation}) ",
               "+#{End} : true <- .print(\"Removing plan\");",
               ".remove_plan(obligationStart(#{Obligation}));",
               ".remove_plan(obligationEnd(#{Obligation})).",
               EPlan);
      .add_plan(EPlan).
/*---------------------------------------------------------
// How the plans should look
@obligationStart(Obligation)
+!Start : true
  <- Obligation.

@obligationEnd(Obligation)
+!End : true
  <- .remove_plan(obligationStart(Obligation));
  	 .remove_plan(obligationEnd(Obligation)).
---------------------------------------------------------*/

//Proposition obligation
+!processNorm(Start, End, obligation(Obligation), Options) 
	: .literal(Obligation)
	<- !print("Adding literal obligation");
      !addLiteralObligationStartCondition(Start, Obligation, Options);
      !addLiteralObligationEndCondition(End, Obligation, Options);
      //.add_plan([OPlan,EPlan]);
      .print("Norm ",obligation(Obligation)," added").


//Same song second time
//If the start condition is already true, execute the plan
+!addLiteralObligationStartCondition(Start, Obligation, Options) : Start
   <- !print("Executing literal for obligation");
      !goalConj([Obligation]).

+!addLiteralObligationStartCondition(false, Obligation, Options) : true
   <- !print("Obligation to ", Obligation, " is impossible.").
   
+!addLiteralObligationStartCondition(Start, Obligation, Options) : not Start
   <- !print("Adding plan for start of obligation to ", Obligation);
      act.puts("@obligationStart(#{Obligation})",
               "+#{Start} : not #{Obligation}",
               " <- !goalConj([#{Obligation}]).",
               OPlan);
      .add_plan(OPlan).

//End conditions
+!addLiteralObligationEndCondition(End, Obligation, Options) : End
   <- .remove_plan(obligationStart(Obligation)).

+!addLiteralObligationEndCondition(false, Obligation, Options) : true
   <- !print("Obligation to ", Obligation, " never ends.").

+!addLiteralObligationEndCondition(End, Obligation, Options) : not End
   <- !print("Adding plan for end of obligation to ", Obligation);
      act.puts("@obligationEnd(#{Obligation})",
               "+#{End} : true <- ",
               "remove_plan(@obligationStart(#{Obligation}));",
               ".remove_plan(@obligationEnd(#{Obligation})).",
               EPlan);
      .add_plan(EPlan).

/*---------------------------------------------------------
// How the plans should look
@obligationStart(Obligation)
+!Start : true
  <- !goalConj([Obligation]).


//Maybe we should not delete all plans after the obligation is gone
@obligationEnd(Obligation)
+!End : true
  <- .remove_plan(obligationStart(Obligation));
  	 .remove_plan(obligationEnd(Obligation)).
---------------------------------------------------------*/

//Action Prohibition
+!processNorm(Start, End, prohibition(Prohibition), Options) 
	: org.kcl.iovis.reflect.action(Prohibition)
	<- act.puts("@prohibitionStart(#{Prohibition})",
	            "+#{Start} : true <- ",
	            "!findPlansWithAction(#{Prohibition},SelectedPlans);",
	            "!suppressPlans(SelectedPlans);",
	            "+suppressedPlans(SelectedPlans).",
	            OPlan);
	   act.puts("@prohibitionEnd(#{Prohibition})",
	            "+#{Start} : suppressedPlans(SelectedPlans) <- ",
	            "!unsuppressPlans(SelectedPlans);",
	            ".remove_plan(prohibitionStart(#{Prohibition}));",
	            ".remove_plan(prohibitionEnd(#{Prohibition})).",
	            EPlan);
	   .add_plan([OPlan,EPlan]);
       .print("Norm ",prohibition(Prohibition)," added").

/*---------------------------------------------------------
// How the plans should look
@prohibitionStart(Prohibition)
+!Start : true
  <- !findPlansWithAction(Prohibition, SelectedPlans);
	 !suppressPlans(SelectedPlans);
	 +suppressedPlans(SelectedPlans).

@prohibitionEnd(Prohibition)
+!End : suppressedPlans(SelectedPlans)
  <- !unsuppressPlans(SelectedPlans);
     .remove_plan(prohibitionStart(Prohibition));
  	 .remove_plan(prohibitionEnd(Prohibition)).
---------------------------------------------------------*/

//Proposition Prohibition
+!processNorm(Start, End, prohibition(Prohibition), Options) 
	: .literal(Prohibition)
	<- act.puts("@prohibitionStart(#{Prohibition})",
	            "+#{Start} : true <- ",
	            "!findPlansWithEffect(#{Prohibition},SelectedPlans);",
	            "!suppressPlans(SelectedPlans);",
	            "+suppressedPlans(SelectedPlans).",
	            OPlan);
	   act.puts("@prohibitionEnd(#{Prohibition})",
	            "+#{End} : suppressedPlans(SelectedPlans) <- ",
	            ".remove_plan(prohibitionStart(#{Prohibition}));",
	            ".remove_plan(prohibitionEnd(#{Prohibition})).",
	            EPlan);
	   .add_plan([OPlan,EPlan]);
       .print("Norm ",prohibition(Prohibition)," added").

/*---------------------------------------------------------
// How the plans should look
@prohibitionStart(Prohibition)
+!Start : true
  <- !findPlansWithEffect(Prohibition, SelectedPlans);
	 !suppressPlans(SelectedPlans);
	 +suppressedPlans(SelectedPlans).

@prohibitionEnd(Prohibition)
+!End : suppressedPlans(SelectedPlans)
  <- !unsuppressPlans(SelectedPlans);
     .remove_plan(prohibitionStart(Prohibition));
  	 .remove_plan(prohibitionEnd(Prohibition)).
---------------------------------------------------------*/

//-----------------------------------------------------------------------------
// Helper plans
//-----------------------------------------------------------------------------

//Plans to detect other plans containing a certain action
+!findPlansWithAction(Prohibition, SelectedPlans) : true
	<- //First get the agent's plan library
	   org.kcl.iovis.reflect.plan_library(Plans);
	   !print("Finding plans with action '",Prohibition,"'");
	   !findPlansWithAction(Prohibition, Plans, SelectedPlans);
	   !print("Found: ",SelectedPlans).

+!findPlansWithAction(Prohibition, [], []) : true
	<- true.

+!findPlansWithAction(Prohibition, [Plan | Plans], SelectedPlans) 
    : org.kcl.iovis.reflect.plan_steps(Plan, Steps) &
	  org.kcl.iovis.reflect.contains(Steps, Prohibition)
	<- !findPlansWithAction(Prohibition, Plans, SP);
	   .concat(Plan,SP,SelectedPlans).

+!findPlansWithAction(Prohibition, [Plan | Plans], SelectedPlans) 
    : true
	<- !findPlansWithAction(Prohibition, Plans, SelectedPlans);
	   true.
//-------------------------------------

//-------------------------------------
//Plans to detect other plans containing 
// a certain effect
+!findPlansWithEffect(Prohibition, SelectedPlans) : true
	<- //First get the agent's plan library
	   org.kcl.iovis.reflect.plan_library(Plans);
	   !findPlansWithEffect(Prohibition, Plans, SelectedPlans).

+!findPlansWithEffect(Prohibition, [], []) : true
	<- true.

+!findPlansWithEffect(Prohibition, [Plan | Plans], SelectedPlans) 
    : org.kcl.iovis.reflect.plan_consequences(Plan, Effects) &
	  org.kcl.iovis.reflect.contains(Effects, Prohibition)
	<- !findPlansWithEffect(Prohibition, Plans, SP);
	   .concat(Plan,SP,SelectedPlans).

+!findPlansWithEffect(Prohibition, [Plan | Plans], SelectedPlans) 
    : true
	<- !findPlansWithEffect(Prohibition, Plans, SelectedPlans);
	   true.
//-------------------------------------

//-------------------------------------
//Plans to suppress plans
//!suppressPlans(SelectedPlans)

+!suppressPlans([]) : true
	<- true.

+!suppressPlans([Plan | Plans]) : true
	<- !suppressPlans(Plans);
	   !suppressPlan(Plan).

//-------------------------------------
//Plans to unsuppress plans
//!unsuppressPlans(SelectedPlans)

+!unsuppressPlans([]) : true
	<- true.

+!unsuppressPlans([Plan | Plans]) : true
	<- !unsuppressPlans(Plans);
	   !unsuppressPlan(Plan).