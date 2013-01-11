library boardaction;

const String NO_ACTION = "No action";
const String SWITCH_TURN = "Switch turn";

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
