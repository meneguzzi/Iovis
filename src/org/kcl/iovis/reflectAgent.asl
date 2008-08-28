{include("iovis.asl")}

ignoreNorms.

/*+time(X) : true
   <- !print("Time ",X).*/

+test : true
	<- !print("Testing reflection of plan steps.");
	   !print("Plan is: '",
	          "+a : true <- a; b.",
	          "'");
	   org.kcl.iovis.reflect.plan_steps("+a : true <- a; b.", Steps);
	   !print("Plan steps are: ", Steps);
	   true.

+test2 : true
	<- !print("Testing reflection of plan context.");
	   !print("Plan is: '",
	          "+a : d & e <- a; b.",
	          "'");
	   org.kcl.iovis.reflect.plan_context("+a : d & e <- a; b.", Context);
	   !print("Context is: ", Context);
	   true.

+test3 : true
	<- !print("Testing reflection of plan trigger.");
	   !print("Plan is: '",
	          "+trig : true <- a; b.",
	          "'");
	   org.kcl.iovis.reflect.plan_trigger("+trig : true <- a; b.", Trigger);
	   !print("Trigger is: ", Trigger);
	   true.

+test4 : true
	<- !print("Testing reflection of plan consequences.");
	   !print("Plan is: '",
	          "+decl : true <- +a; -b; +c.",
	          "'");
	   org.kcl.iovis.reflect.plan_consequences("+decl : true <- +a; -b; +c.", Consequences);
	   !print("Consequences are: ", Consequences);
	   true.
	   
+test5 : true
	<- !print("Testing list unification.");
	   !print("Trying to unify: '",
	          "a([a,b])",
	          "' with '",
	          "a([b,a])",
	          "'");
		!testList.

+!testList : a([a,b]) = a([b,a])
	<- !print("List unifies").


+!testList : true
	<- !print("List does not unify").


+test6 : true
	<- !print("Testing reflection of plan library.");
	   !print("Getting plan library");
	   org.kcl.iovis.reflect.plan_library(Plans);
	   !print(Plans);
	   true.

+test7 : true
   <- !print("Testing contains internal action.");
	   !print("Plan is: '",
	          "+trig : true <- a; b.",
	          "'");
	   org.kcl.iovis.reflect.plan_steps("+trig : true <- a; b.", Steps);
       !print("Plan steps are: ", Steps);
       !print("Testing if steps ", Steps, " contains step 'a'");
       +testContains(Steps, a).

+testContains(List, Element) : org.kcl.iovis.reflect.contains(List, Element)
   <- !print("List ", List, " contains element '", Element, "'").

+testContains(List, Element) : true
   <- !print("List ", List, " does not contain element '", Element, "'").

+test8 : true
   <- !print("Testing !findPlansWithAction for action '.print(x)'");
      Plans = ["+a : true <- .print(X).", "+b : true <- c."]; 
      !print("Plans are: ",
        Plans);
      !findPlansWithAction(.print(X), Plans, SelectedPlans);
      !print("Plans with action: ", SelectedPlans).

+test9 : true
   <- !print("Testing !findPlansWithAction for action '.print' in the plan library");
      org.kcl.iovis.reflect.plan_library(Plans);
      !findPlansWithAction(.print(X), Plans, SelectedPlans);
      !print("Plans with action: ", SelectedPlans).
      
+test10 : true
   <- !print("Testing .puts internal action");
       X = ex;
       Yey = "works";
       act.puts("Testing variable X is #{X} and that variable Yey is #{Yey} and works").

+test11 : true
   <- !print("Testing .puts internal action");
       X = ex;
       Yey = "works";
       act.puts("Testing variable X is #{X} ",
                "and that variable Yey is #{Yey} and works").

@plan1
+!declarativePlan : precond1 & precond2
	<- +effect1;
	   -effect2;
	   +effect3.
	   
@plan2
+!planWithAction : true
	<- .print(a).