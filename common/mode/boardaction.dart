library boardaction;

import '../checkerplay.dart';

const String NO_ACTION = "No action";
const String ILLEGAL_ACTION = "Illegal action";
const String SWITCH_TURN = "Switch turn";
const String CHECKER_PICKED = "Checker picked";
const String CHECKER_DROPPED = "Checker dropped";
const String CHECKER_PLAY = "Checker play";

abstract class BoardAction {
  String getName();  
}

class SwitchTurnAction extends BoardAction {
  String getName() {
    return SWITCH_TURN;
  }
}

class NoAction extends BoardAction {
  String getName() {
    return NO_ACTION;
  }
}

class IllegalAction extends BoardAction {
  String getName() {
    return ILLEGAL_ACTION;
  }
}

class CheckerPickedAction extends BoardAction {
  int point;
  
  CheckerPickedAction(this.point);
  
  String getName() {
    return CHECKER_PICKED;
  }
}

class CheckerDroppedAction extends BoardAction {
  int point;
  
  CheckerDroppedAction(this.point);
  
  String getName() {
    return CHECKER_DROPPED;
  }
}

class CheckerplayAction extends BoardAction {
  Checkerplay checkerplay;
  
  CheckerplayAction(this.checkerplay);
  
  String getName() {
    return CHECKER_PLAY;
  }
}
