{include("iovis.asl")}

/*+time(X) : true
   <- !print("Time ",X).*/
   
+create : true
   <- .create_agent(newAgent,"normAgent.asl");
      !print("Created agent").