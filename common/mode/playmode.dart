library playmode;

import 'dart:math';
import 'boardmode.dart';
import 'boardaction.dart';
import 'movevalidator.dart';
import '../boardmap.dart';
import '../positionrecord.dart';

class PlayMode extends BoardMode {
  MoveValidator moveValidator = new MoveValidator();
  
  List<int> alreadyPlayedDice = [];
  int checkerPickedPoint = -1;
  
  PlayMode() : this.createWithValidator(new MoveValidator());
  
  PlayMode.createWithValidator(MoveValidator moveValidator) {
    this.moveValidator = moveValidator;
  }
  
  // States.
  // A. player's turn, B. other's turn, C. nobody's turn. How to know when other is ready with his turn?
  
  // Player can be:
  // playing his checkers -> this is a state in itself.
  // doubling
  // rolling
  // taking
  // surrendering
  // Which of these is possible depends on the gamestate and the internal state.
  
  // quitting is up to the controller to detect, I guess.
  
  BoardAction interpretMouseClick(PositionRecord position, Item clickedItem) {
    // For now:
    // -assume we're playing checkers (and the gamestate allows it)
    // -assume that our side is 0.
    
    // We have to check:
    // after dropping: if the move is ready
    // when picking up: if the checker is one of ours
    // when dropping: if it's a legal place => NOTE: For now we only do a shallow check; i.e. the die is (probably) played, not blocked, etc.
    
    if(clickedItem.area == AREA_CHECKER) {
      return checkerAreaClicked(position, clickedItem);
    }
    
    return new NoAction();
  }
  
  BoardAction checkerAreaClicked(PositionRecord position, Item clickedItem) {
    if(checkerPickedPoint >= 0) {
      return checkerPicked(position, clickedItem);
    }
    if(clickedItem.index > 0 && position.getNrCheckersOnPoint(position.playerOnRoll, clickedItem.index) > 0) {
      checkerPickedPoint = clickedItem.index;
      return new CheckerPickedAction(clickedItem.index);
    }
    return new NoAction();
  }
  

  BoardAction checkerPicked(PositionRecord position, Item clickedItem) {
    int moveStart = checkerPickedPoint;
    int moveEnd = clickedItem.index;
    int playedDie = moveValidator.getPlayedDie(alreadyPlayedDice, moveStart, moveEnd, position);
    if(DIE_NONE == playedDie) {
      return new IllegalAction(); 
    }
    checkerPickedPoint = -1;
    alreadyPlayedDice.add(playedDie);
    position.playChecker(position.playerOnRoll, moveStart, moveEnd);
    // TODO if dies are all played, return checkerPlayedAction
    return new CheckerDroppedAction(moveEnd);
  }
}
