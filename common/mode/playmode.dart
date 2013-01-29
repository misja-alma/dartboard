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
  
  List<int> diceLeftToPlay = [];
  List<HalfMove> halfMovesPlayed = [];
  
  GameState gameState = new GameState.newGame();
  
  PlayMode() : this.createWithValidator(new MoveValidator());
  
  PlayMode.createWithValidator(MoveValidator moveValidator) {
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
        if(!moveValidator.isValidMove(halfMovesPlayed, position)) {
          return [new IllegalAction()];
        }
        diceLeftToPlay = [];
        halfMovesPlayed = [];
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
    Set<int> distinctDiceLeft = new Set.from(diceLeftToPlay);
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
  
  initializeState(PositionRecord position) {
    diceLeftToPlay = getDiceAsList(position.die1, position.die2);
    gameState = new GameState.fromPosition(position);
    halfMovesPlayed = [];  
  }
  
  List<BGAction> roll(PositionRecord position) {
    List<int> newDice = dice.roll();
    diceLeftToPlay = expandDoubles(newDice);
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
    for(int index=0; index<diceLeftToPlay.length; index++) {
      int die = diceLeftToPlay[index];
      int pointTo = moveValidator.getLandingPoint(player, die, startingPoint, position); 
      if(pointTo != INVALID_MOVE) {
        diceLeftToPlay.removeAt(index);
        return playCheckerMove(startingPoint, pointTo, die, player, position);  
      }
    }
    return [];
  }
  
  List<BGAction> playCheckerMove(int startingPoint, int pointTo, int die, int player, PositionRecord position) {
    List<BGAction> result = [];
    result.add(new CheckerPlayedAction(position: position, pointFrom: startingPoint, pointTo: pointTo, playedDie: die, player: player));
    halfMovesPlayed.add(new HalfMove(startingPoint, pointTo, isHit(player, pointTo, position)));
    if(diceLeftToPlay.isEmpty) {
      result.add(fullRollPlayed(position));
    }
    return result;
  }
  
  bool isHit(int player, int point, PositionRecord position) {
    if(point == 0) {
      return false;
    }
    return (position.getNrCheckersOnPoint(invertPlayer(player), 25 - point) == 1);
  }
  
  BGAction fullRollPlayed(PositionRecord position) {
    return new RollFinishedAction(position, gameState, position.playerOnRoll);
  }
}
