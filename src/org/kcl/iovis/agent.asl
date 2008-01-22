{include("iovis.asl")}

+test : true
	<- org.kcl.iovis.reflect.plan_steps("+a : true <- a; b.", Steps);
	   .print(Steps);
	   true.

+test2 : true
	<- org.kcl.iovis.reflect.plan_context("+a : d & e <- a; b.", Context);
	   .print(Context);
	   true.

+test3 : true
	<- org.kcl.iovis.reflect.plan_trigger("+trig : true <- a; b.", Trigger);
	   .print(Trigger);
	   true.

+test4 : true
	<- org.kcl.iovis.reflect.plan_consequences("+decl : true <- +a; -b; +c.", Consequences);
	   .print(Consequences);
	   true.
	   
+test5 : true
	<- !testList.

+!testList : a([a,b]) = a([b,a])
	<- .print("List unifies").


+!testList : true
	<- .print("List does not unify").
@plan1
+!declarativePlan : precond1 & precond2
	<- +effect1;
	   -effect2;
	   +effect3.