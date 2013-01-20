library playmode;

import 'dart:math';
import 'boardmode.dart';
import 'boardaction.dart';
import 'movevalidator.dart';
import '../boardmap.dart';
import '../positionrecord.dart';
import '../checkerplay.dart';
import '../gamestate.dart';
import '../positionutils.dart';

class PlayMode extends BoardMode {
  MoveValidator moveValidator = new MoveValidator();
  
  List<int> diceLeftToPlay = [];
  List<HalfMove> halfMovesPlayed = [];
  
  GameState gameState = new GameState.newGame();
  
  PlayMode() : this.createWithValidator(new MoveValidator());
  
  PlayMode.createWithValidator(MoveValidator moveValidator) {
    this.moveValidator = moveValidator;
  }
  
  // TODO change interface behaviour.
  // auto-guess picked die; play die immediately from point.
  // so we only have checkerPlayedActions.
  
  // when not playing checkers, clicking the dice area means roll.
  // when dice are rolled, clicking the dice area means switch dice order.
  // when a checker has been played, clicking the dice area means nothing.
  
  List<BoardAction> interpretMouseClick(PositionRecord position, Item clickedItem) {
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
    
    return [];
  }
  
  initializeState(PositionRecord position) {
    diceLeftToPlay = position.getDiceAsList();
    halfMovesPlayed = [];  
  }
  
  List<BoardAction> checkerAreaClicked(PositionRecord position, Item clickedItem) {
    int startingPoint = clickedItem.index;
    if(clickedItem.index > 0 && position.getNrCheckersOnPoint(position.playerOnRoll, startingPoint) > 0) {      
      return findValidCheckerMove(startingPoint, position);
    }
    return [];
  }
  
  List<BoardAction> findValidCheckerMove(int startingPoint, PositionRecord position) {
    int player = position.playerOnRoll;
    for(int index=0; index<diceLeftToPlay.length; index++) {
      int die = diceLeftToPlay[index];
      int pointTo = moveValidator.validateMove(die, startingPoint, position); 
      if(pointTo != INVALID_MOVE) {
        diceLeftToPlay.removeAt(index);
        return playCheckerMove(startingPoint, pointTo, die, player, position);  
      }
    }
    return [];
  }
  
  List<BoardAction> playCheckerMove(int startingPoint, int pointTo, int die, int player, PositionRecord position) {
    List<BoardAction> result = [];
    result.add(new CheckerPlayedAction(startingPoint, pointTo, die, player));
    position.playChecker(player, startingPoint, pointTo);
    halfMovesPlayed.add(new HalfMove(startingPoint, pointTo));
    if(diceLeftToPlay.isEmpty) {
      result.add(fullRollPlayed(position));
    }
    return result;
  }
  
  BoardAction fullRollPlayed(PositionRecord position) {
    gameState.rollFinished();
    position.playerOnRoll = invertPlayer(position.playerOnRoll);
    return new SwitchTurnAction();
  }
}
