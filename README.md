Refactoring:
- make all screen elements objects, like Die. Gives them also their own contains() functions.
- positionConverter's methodnames are not consistent
  
Improvements:  
- add method to generate xgId. Then, fill the id when the gnu/xg idType radiobutton changes.
- figure out how to run the testsuite in the browser. Maybe get rid of colortestrunner (and testsuite?) this way.
  Problem: only one main function will be called, so only one testcase can be included.
  Problem 2: cant mix io and html. 
  Only solution seems to be some command line stuff, or maybe a Eclipse plugin.
  Or: have one testsuite which imports all tests (with .. as ..) and calls their main functions.
- Highlight mode of choice (edit/ game)