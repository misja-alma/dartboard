library bgaction;

import '../checkerplay.dart';
import '../gamestate.dart';
import '../position.dart';
import '../board.dart';

abstract class BGAction {
  execute(Board board);
}

class SwitchTurnAction extends BGAction {
  PositionRecord position;
  
  SwitchTurnAction(this.position);
  
  execute(Board board) {
    position.switchTurn();
    board.switchTurn();
  }
}

class NoAction extends BGAction {
  execute(Board board) {}
}

class IllegalAction extends BGAction {
  execute(Board board) {}
}

class CheckerPlayedAction extends BGAction {
  int pointFrom;
  int pointTo;
  int playedDie;
  int player;
  PositionRecord position;
  
  CheckerPlayedAction({this.position, this.pointFrom, this.pointTo, this.playedDie, this.player});
  
  execute(Board board) {
    position.playChecker(player, pointFrom, pointTo);
    board.checkerPlayed(player, pointFrom, pointTo); 
  }
}

class RollFinishedAction extends BGAction {
  int player;
  PositionRecord position;
  GameState gameState;
  
  RollFinishedAction(this.position, this.gameState, this.player);
  
  execute(Board board) {
    gameState.rollFinished();
    position.playerOnRoll = invertPlayer(position.playerOnRoll);
    position.decisionTurn = invertDecisionTurn(position.decisionTurn);
    position.die1 == DIE_NONE;
    position.die2 == DIE_NONE; 
  }
}

class RolledAction extends BGAction {
  int die1;
  int die2;
  int player;
  PositionRecord position;
  GameState gameState;
  
  RolledAction(this.position, this.gameState, this.die1, this.die2, this.player);
  
  execute(Board board) {
    position.die1 = die1;
    position.die2 = die2;
    gameState.playerRolled();
    board.rolled(die1, die2); 
  }
}

