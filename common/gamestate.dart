library gamestate;

const int STATE_NEW_GAME = 0;
const int STATE_DOUBLE_DECISION = 1;
const int STATE_TAKE_DECISION = 2;
const int STATE_BEFORE_ROLL = 3;
const int STATE_ROLLED = 4;
const int STATE_GAME_FINISHED = 5;

class GameState {
  int currentState;  
  
  GameState(this.currentState);
  
  GameState.newGame() {
    currentState = STATE_NEW_GAME;
  }
  
  void playerRolled() {
    currentState = STATE_ROLLED;
  }
  
  void rollFinished() {
    currentState = STATE_DOUBLE_DECISION;
  }
  
  bool isCheckerPlayPossible() {
    return currentState == STATE_ROLLED; 
  }
  
  bool isRollingPossible() {
    return currentState == STATE_NEW_GAME || currentState == STATE_DOUBLE_DECISION;
  }
}
