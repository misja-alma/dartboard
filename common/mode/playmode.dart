library playmode;

import 'boardmode.dart';
import 'boardaction.dart';
import '../boardmap.dart';
import '../positionrecord.dart';

class Playmode extends Boardmode {
  // States.
  // A. player's turn, B. other's turn, C. nobody's turn. How to know when other is ready with his turn?
  
  // Player can be:
  // playing his checkers -> this is a state in itself.
  // doubling
  // rolling
  // taking
  // surrendering
  // Which of these is possible depends on the gamestate and the internal state.
  
  // quitting is up to the controller to detect, I guess.
  
  Boardaction interpretMouseClick(Positionrecord position, Item clickedItem) {
    return new NoAction();
  }
}
