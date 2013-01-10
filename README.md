Refactoring:
- make all screen elements objects, like Die. Gives them also their own contains() functions.
- positionConverter's methodnames are not consistent
- for counterclockwise board, the arrow and cube should stay on the righthand side of the board
- gamestate should probably not be part of positionrecord but have its own class? Controller have something like this to 
  determine how to interpret mouseEvents. Maybe there should be both a gameState and an inputMode.