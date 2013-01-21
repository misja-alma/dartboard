library movevalidator;

import '../positionrecord.dart';

const int INVALID_MOVE = -1;

class MoveValidator {
  /**
   * Returns INVALID_MOVE if the move is illegal, otherwise returns the endpoint.
   * NOTE: playerOnRoll should be checked!
   */ 
  int validateMove(int die, int startingPoint, PositionRecord position) {
    return startingPoint - die; 
    // TODO
    // changed the interface; no endpoint, pass in a candidate die, so also no alreadyPlayedDice. Caller should iterate over all dice, if needed.
    // check if the endpoint is blocked, within the board (except when bearing off)
  }
}
