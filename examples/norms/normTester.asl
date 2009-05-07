{include("../../src/org/kcl/iovis/iovis.asl")}

/*+time(X) : true
   <- !print("Time ",X).*/

@plan_print_X
+print(X) : true
   <- .print(X);
      !print("Golly, I printed the message ****").

@plan_achieve_g2
+achieve(g2) : true
	<- +g2;
	   .puts("Achieving #{g2} too").

@plan_goalConj_g1
+!goalConj([g1]) : true
   <- !print("Achieving g1");
      +g1.

@plan_goalConj_g2
+!goalConj([g2]) : true
	<- +g2.

+endSimulation : false
	<- .stopMAS.