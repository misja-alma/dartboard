library boardaction;

import '../checkerplay.dart';
import '../board.dart';

abstract class BoardAction {
  execute(Board board);
}

class SwitchTurnAction extends BoardAction {
  execute(Board board) {
    board.switchTurn();
  }
}

class NoAction extends BoardAction {
  execute(Board board) {}
}

class IllegalAction extends BoardAction {
  execute(Board board) {}
}

class CheckerPlayedAction extends BoardAction {
  int pointFrom;
  int pointTo;
  int playedDie;
  int player;
  
  CheckerPlayedAction(this.pointFrom, this.pointTo, this.playedDie, this.player);
  
  execute(Board board) {
    //board.dropChecker(point, player); TODO
  }
}

