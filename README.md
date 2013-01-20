Refactoring:
- make all screen elements objects, like Die. Gives them also their own contains() functions.
- positionConverter's methodnames are not consistent
- Use halfMove/ checkerPlay everywhere where appropriate. E.g. in positionrecord and maybe checkerDroppedAction
- Use libraries with parts
  
Improvements:  
- for counterclockwise board, the arrow and cube should stay on the righthand side of the board
- add method to generate xgId. Then, fill the id when the gnu/xg idType radiobutton changes.
