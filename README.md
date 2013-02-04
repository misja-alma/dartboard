Refactoring:
- make all screen elements objects, like Die. Gives them also their own contains() functions.
- positionConverter's methodnames are not consistent
- Use halfMove/ checkerPlay everywhere where appropriate. E.g. in positionrecord and maybe checkerDroppedAction
  
Improvements:  
- for counterclockwise board, the arrow and cube should stay on the righthand side of the board
  TODO also, make new area left of board, where the undo area should be located. Maybe later also other stuff like surrender etc.
- add method to generate xgId. Then, fill the id when the gnu/xg idType radiobutton changes.
- figure out how to run the testsuite in the browser. Maybe get rid of colortestrunner (and testsuite?) this way.
  Problem: only one main function will be called, so only one testcase can be included.
  Problem 2: cant mix io and html. 
  Only solution seems to be some command line stuff, or maybe a Eclipse plugin.
  Or: have one testsuite which imports all tests (with .. as ..) and calls their main functions.
