library movevalidator;

import '../positionrecord.dart';

class MoveValidator {
  /**
   * Should return DIE_NONE if the move is illegal
   */ 
  int getPlayedDie(List<int> alreadyPlayedDice, int startingPoint, int endPoint, PositionRecord position) {
    return startingPoint - endPoint; // TODO
  }
}
