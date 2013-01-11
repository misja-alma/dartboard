library boardaction;

const String NO_ACTION = "No action";
const String ILLEGAL_ACTION = "Illegal action";
const String SWITCH_TURN = "Switch turn";
const String CHECKER_PICKED = "Checker picked";
const String CHECKER_DROPPED = "Checker dropped";

abstract class Boardaction {
  String getName();  
}

class SwitchTurnAction extends Boardaction {
  String getName() {
    return SWITCH_TURN;
  }
}

class NoAction extends Boardaction {
  String getName() {
    return NO_ACTION;
  }
}

class IllegalAction extends Boardaction {
  String getName() {
    return ILLEGAL_ACTION;
  }
}

class CheckerPickedAction extends Boardaction {
  int point;
  
  CheckerPickedAction(this.point);
  
  String getName() {
    return CHECKER_PICKED;
  }
}

class CheckerDroppedAction extends Boardaction {
  int point;
  
  CheckerDroppedAction(this.point);
  
  String getName() {
    return CHECKER_DROPPED;
  }
}
