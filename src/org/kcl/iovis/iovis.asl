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
+!addNorm(Start, End, obligation(Obligation), Options) : org.kcl.iovis.reflect.action(Obligation)
   <- .concat("@obligationStart(",Obligation,")", 
              "+", Start, ": true <- ",
              Obligation,".",OPlan
              );
      .concat("@obligationEnd(", Obligation, ")",
              "+",End, ": true <- ",
              ".remove_plan(obligationStart(",Obligation,"));",
              ".remove_plan(obligationEnd(",Obligation,")).",
              EPlan);
      .add_plan([OPlan,EPlan]);
      .print("Norm ",obligation(Obligation)," added").

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
+!addNorm(Start, End, obligation(Obligation), Options) 
	: .literal(Obligation)
	<- 
      .concat("@obligationStart(",Obligation,")", 
              "+", Start, ": not ",Obligation,
              "<-", "!goalConj([",Obligation,"]).",
              OPlan);
      .concat("@obligationEnd(", Obligation, ")",
              "+",End, ": true <- ",
              ".remove_plan(@obligationStart(",Obligation,"));",
              ".remove_plan(@obligationEnd(",Obligation,")).",
              EPlan);
      .add_plan([OPlan,EPlan]);
      .print("Norm ",obligation(Obligation)," added").

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
+!addNorm(Start, End, prohibition(Prohibition), Options) 
	: org.kcl.iovis.reflect.action(Prohibition)
	<- .concat("@prohibitionStart(",Prohibition,")", 
	   		   "+", Start, ": true ",
	   		   "<-", "!findPlansWithAction(",Prohibition, ",SelectedPlans);",
			   "!suppressPlans(SelectedPlans);",
			   "+suppressedPlans(SelectedPlans).", OPlan);
	   .concat("@prohibitionEnd(",Prohibition,")",
	   		   "+", End, ": suppressedPlans(SelectedPlans) ",
	   		   "<-","!unsuppressPlans(SelectedPlans);",
	   		   ".remove_plan(prohibitionStart(",Prohibition,");",
	   		   ".remove_plan(prohibitionEnd(",Prohibition,").", EPlan);
	   .add_plan([OPlan,EPlan]);
       .print("Norm ",prohibition(Prohibition)," added").

/*---------------------------------------------------------
// How the plans should look
@prohibitionStart(Prohibition)
+!Start : true
  <- !findPlansWithAction(Prohibition, SelectedPlans);
	 !suppressPlans(SelectedPlans);
	 +suppressedPlans(SelectedPlans).

@prohibitionEnd(Obligation)
+!End : suppressedPlans(SelectedPlans)
  <- !unsuppressPlans(SelectedPlans);
     .remove_plan(prohibitionStart(Prohibition));
  	 .remove_plan(prohibitionEnd(Prohibition)).
---------------------------------------------------------*/

//Proposition Prohibition
+!addNorm(Start, End, prohibition(Prohibition), Options) 
	: .literal(Prohibition)
	<- .concat("@prohibitionStart(",Prohibition,")", 
	   		   "+", Start, ": true ",
	   		   "<-", "!findPlansWithEffect(",Prohibition, ",SelectedPlans);",
			   "!suppressPlans(SelectedPlans);",
			   "+suppressedPlans(SelectedPlans).", OPlan);
	   .concat("@prohibitionEnd(",Prohibition,")",
	   		   "+", End, ": suppressedPlans(SelectedPlans) ",
	   		   "<-","!unsuppressPlans(SelectedPlans);",
	   		   ".remove_plan(prohibitionStart(",Prohibition,");",
	   		   ".remove_plan(prohibitionEnd(",Prohibition,").", EPlan);
	   .add_plan([OPlan,EPlan]);
       .print("Norm ",prohibition(Prohibition)," added").

/*---------------------------------------------------------
// How the plans should look
@prohibitionStart(Prohibition)
+!Start : true
  <- !findPlansWithEffect(Prohibition, SelectedPlans);
	 !suppressPlans(SelectedPlans);
	 +suppressedPlans(SelectedPlans).

@prohibitionEnd(Obligation)
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
	   !findPlansWithAction(Prohibition, Plans, SelectedPlans).

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

!findPlansWithEffect(Prohibition, [], []) : true
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