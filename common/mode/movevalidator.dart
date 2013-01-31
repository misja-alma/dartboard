library movevalidator;

import '../position.dart';
import '../checkerplay.dart';

const int INVALID_MOVE = -1;

class MoveValidator {
  /**
   * Returns INVALID_MOVE if the move is illegal, otherwise returns the endpoint.
   */ 
  int getLandingPoint(int player, int die, int startingPoint, PositionRecord position) {
    int landingPoint = startingPoint - die;
    if(landingPoint <= 0) {
      return checkIfCheckerCanBearOff(player, startingPoint, position);
    }
    int nrOppOnPoint = position.getNrCheckersOnPoint(invertPlayer(player), 25 - landingPoint);
    if(nrOppOnPoint >= 2) {
      return INVALID_MOVE;
    }
    return landingPoint;
  }
 
  bool isDieBlocked(int player, int die, PositionRecord position) {
    for(int startingPoint in getPossibleStartingPoints(player, position)) {
      if(getLandingPoint(player, die, startingPoint, position) != INVALID_MOVE) {
        return false;
      }
    }
    return true;
  }
  
  List<int> getPossibleStartingPoints(int player, PositionRecord position) {
    if(position.getNrCheckersOnPoint(player, 25) > 0) {
      return [25];
    }
    List<int> result = [];
    for(int point=1; point<25; point++) {
      if(position.getNrCheckersOnPoint(player, point) > 0) {
        result.add(point);
      }
    }
    return result;
  }
  
  /**
   * Does not check if all individual halfMoves were playable; but checks if the move, even if not all dice were played, is still a valid move.
   */
  bool isValidMove(List<HalfMove> halfMoves, PositionRecord position) {
    // if all dice played return true;
    // if roll is a double and left dice are/is really blocked return true (otherwise false)
    // if roll is a non double and higher die is played (and other die not playable, otherwise false); try to:
    // - revert the halfmove
    // - play the low die first
    // - now play the high die. return false if possible, otherwise true
    // if roll is a non double, lower die is played; try to: 
    // - revert the halfmove
    // - play the higher die first. Return false if possible, otherwise true.
    return true; // TODO 
  }

  checkIfCheckerCanBearOff(int player, int startingPoint, PositionRecord position) {
    if(getFurthestChecker(player, position) > 6) {
      return INVALID_MOVE;
    }
    return 0;
  }
}
