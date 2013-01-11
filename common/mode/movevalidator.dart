library movevalidator;

import '../positionrecord.dart';

class Movevalidator {
  /**
   * Should return DIE_NONE if the move is illegal
   */ 
  int getPlayedDie(List<int> alreadyPlayedDice, int startingPoint, int endPoint, Positionrecord position) {
    return startingPoint - endPoint; // TODO
  }
}
