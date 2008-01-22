+!cleanRoom(Room) : at(Room)
   <- !move(Files, shelf, table);
      clean(Shelf);
      clean(Floor).

+!move(Object, From, To) : true
   <- take(Object, From);
      drop(Object, To).
