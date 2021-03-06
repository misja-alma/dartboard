library playmode;

import 'dart:math';
import 'boardmode.dart';
import 'bgaction.dart';
import 'movevalidator.dart';
import '../boardmap.dart';
import '../position.dart';
import '../checkerplay.dart';
import '../gamestate.dart';
import '../dice.dart';

class PlayMode extends BoardMode {
  MoveValidator moveValidator = new MoveValidator();
  Dice dice = new Dice();
  
  GameState gameState;
  
  PlayMode(GameState gameState) : this.createWithValidator(new MoveValidator(), gameState);
  
  PlayMode.createWithValidator(MoveValidator moveValidator, this.gameState) {
    this.moveValidator = moveValidator;
  }
  
  // when not playing checkers, clicking the dice area means roll.
  // when dice are rolled, clicking the dice area means switch dice order.
  // when a checker has been played, clicking the dice area means nothing.
  List<BGAction> interpretMouseClick(PositionRecord position, Item clickedItem) {
    if(gameState.isRollingPossible() && possibleDiceRoll(clickedItem)) {
      return roll(position);
    }    
    if(gameState.isCheckerPlayPossible()) {
      if(isRollBlocked(position)) {
        if(!moveValidator.isValidMove(gameState.halfMovesPlayed, position)) {
          return [new IllegalAction()];
        }
        return [fullRollPlayed(position)]; 
      }
      if(clickedItem.area == AREA_CHECKER || clickedItem.area == AREA_BAR) {
        return checkerAreaClicked(position, clickedItem);
      }
    }
    return [];
  }
  
  bool isRollBlocked(PositionRecord position) {
    int player = position.playerOnRoll;
    Set<int> distinctDiceLeft = new Set.from(gameState.diceLeftToPlay);
    for(int die in distinctDiceLeft) {
      if(!moveValidator.isDieBlocked(player, die, position)) {
        return false;
      }
    }
    return true;
  }
  
  bool possibleDiceRoll(Item item) {
    if(item.area == AREA_DICE) {
      return true;
    }
    if(item.area == AREA_CUBE) {
      return item.location == CUBELOCATION_OFFERED;
    }
    return false;
  }
  
  List<BGAction> roll(PositionRecord position) {
    // TODO check if initialposition
    List<int> newDice = dice.roll();
    return [new RolledAction(position, gameState, newDice[0], newDice[1], position.playerOnRoll)];
  }
  
  List<BGAction> checkerAreaClicked(PositionRecord position, Item clickedItem) {
    int startingPoint = getStartingPoint(clickedItem, position);
    if(startingPoint > 0 && position.getNrCheckersOnPoint(position.playerOnRoll, startingPoint) > 0) {      
      return findValidCheckerMove(startingPoint, position);
    }
    return [];
  }

  int getStartingPoint(Item clickedItem, PositionRecord position) {
    if(clickedItem.area == AREA_CHECKER) {
      return convertMyPointForPlayerOnRoll(clickedItem.index, position.playerOnRoll);
    } else {
      return 25;
    }
  }
  
  List<BGAction> findValidCheckerMove(int startingPoint, PositionRecord position) {
    int player = position.playerOnRoll;
    for(int index=0; index<gameState.diceLeftToPlay.length; index++) {
      int die = gameState.diceLeftToPlay[index];
      int pointTo = moveValidator.getLandingPoint(player, die, startingPoint, position); 
      if(pointTo != INVALID_MOVE) {
        return playCheckerMove(startingPoint, pointTo, die, player, position);  
      }
    }
    return [];
  }
  
  List<BGAction> playCheckerMove(int startingPoint, int pointTo, int die, int player, PositionRecord position) {
    List<BGAction> result = [];
    result.add(new CheckerPlayedAction(position: position, pointFrom: startingPoint, pointTo: pointTo, playedDie: die, player: player, gameState: gameState));
    if(gameState.diceLeftToPlay.length == 1) {
      result.add(fullRollPlayed(position));
    }
    return result;
  }
  
  BGAction fullRollPlayed(PositionRecord position) {
    return new RollFinishedAction(position, gameState, position.playerOnRoll);
  }
}
