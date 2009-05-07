{include("../../src/org/kcl/iovis/iovis.asl")}

+!cleanRoom(Room) : at(Room)
   <- +clean(Room).

+!goalConj([clean(room1)]) : true
	<- +at(room1);
	   .puts("Cleaning room1");
	   !cleanRoom(room1).

@debug
+!goalConj([clean(classifRoom)]) : true
	<- +at(classifRoom);
	   .puts("Cleaning classified room");
	   !cleanRoom(classifRoom).

+cleanClassif : true
	<- !goalConj([clean(classifRoom)]).