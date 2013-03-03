library bgaction;

import '../checkerplay.dart';
import '../gamestate.dart';
import '../position.dart';
import '../board.dart';

abstract class BGAction {
  execute(Board board);
  
  undo(Board board); // TODO implement everywhere
}

class SwitchTurnAction extends BGAction {
  PositionRecord position;
  
  SwitchTurnAction(this.position);
  
  execute(Board board) {
    position.switchTurn();
    board.switchTurn();
  }
  
  undo(Board board) {
    position.switchTurn();
    board.switchTurn();
  }
}

class NoAction extends BGAction {
  execute(Board board) {}
  
  undo(Board board) {}
}

class IllegalAction extends BGAction {
  execute(Board board) {}
  
  undo(Board board) {}
}

class CheckerPlayedAction extends BGAction {
  int pointFrom;
  int pointTo;
  int playedDie;
  int player;
  PositionRecord position;
  GameState gameState;
  
  CheckerPlayedAction({this.position, this.pointFrom, this.pointTo, this.playedDie, this.player, this.gameState});
  
  execute(Board board) {
    HalfMove halfMove = new HalfMove(pointFrom, pointTo, isHit(player, pointTo, position), player);
    position.playHalfMove(halfMove);
    board.checkerPlayed(player, pointFrom, pointTo); 
    gameState.diceLeftToPlay.remove(playedDie);
    gameState.halfMovesPlayed.add(halfMove);
  }
  
  undo(Board board) {
    HalfMove halfMove = new HalfMove(pointFrom, pointTo, isHit(player, pointTo, position), player);
    position.undoHalfMove(halfMove);
    gameState.diceLeftToPlay.add(playedDie);
    gameState.halfMovesPlayed.removeLast();
    board.draw(position);
  }
  
  bool isHit(int player, int point, PositionRecord position) {
    if(point == 0) {
      return false;
    }
    return (position.getNrCheckersOnPoint(invertPlayer(player), 25 - point) == 1);
  }
}

class RollFinishedAction extends BGAction {
  int player;
  PositionRecord position;
  GameState gameState;
  
  int savedDie1;
  int savedDie2;
  List<int> savedDiceLeft;
  List<HalfMove> savedHalfMoves;
  
  RollFinishedAction(this.position, this.gameState, this.player);
  
  execute(Board board) {
    gameState.rollFinished();
    position.playerOnRoll = invertPlayer(position.playerOnRoll);
    position.decisionTurn = invertDecisionTurn(position.decisionTurn);
    savedDie1 = position.die1;
    savedDie2 = position.die2;
    savedDiceLeft = gameState.diceLeftToPlay;
    savedHalfMoves = gameState.halfMovesPlayed;
    position.die1 == DIE_NONE;
    position.die2 == DIE_NONE; 
    gameState.diceLeftToPlay = [];
    gameState.halfMovesPlayed = [];
  }
  
  undo(Board board) {
    gameState.currentState = STATE_ROLLED;
    position.playerOnRoll = invertPlayer(position.playerOnRoll);
    position.decisionTurn = invertDecisionTurn(position.decisionTurn);
    gameState.diceLeftToPlay = savedDiceLeft;
    gameState.halfMovesPlayed = savedHalfMoves;
    position.die1 = savedDie1;
    position.die2 = savedDie2;
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
    gameState.playerRolled(die1, die2);
    board.rolled(die1, die2); 
  }
  
  undo(Board board) {
    // No Undo possible (for now)
  }
}

