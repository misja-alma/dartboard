library position;

import 'dart:math';
import 'listutils.dart';
import 'checkerplay.dart';

part 'position/base64utils.dart';
part 'position/parseutils.dart';
part 'position/bitutils.dart';
part 'position/positionconverter.dart';
part 'position/positionutils.dart';

const int CENTERED_CUBE = 3;

const int GAMESTATE_NOGAMESTARTED = 0;
const int GAMESTATE_PLAYING = 1;
const int GAMESTATE_GAMEOVER = 2;
const int GAMESTATE_RESIGNED = 3;

const int GAMESTATE_ENDBYCUBEDROP = 4;

const int RESIGNATION_NONE = 0;
const int RESIGNATION_SINGLE = 1;
const int RESIGNATION_GAMMON = 2;
const int RESIGNATION_BACKGAMMON = 3;

const int DIE_NONE = 0;

class PositionRecord {
  List<List<int>> checkers; // index 0 is the player: 0 or 1. Index 1 counts the points. Dimensions: 2, 26
  int playerOnRoll; // or the player that did roll
  int cubeValue;
  int cubeOwner; // 3 = centered cube
  bool crawford;
  int gameState; //0=no game started; 1 = playing a game; 2 = game over; 3 = resigned; 4 = end by cube drop
  int decisionTurn; // matters when cube is offered
  bool cubeOffered;
  int resignation; // 0 = no resignation; 1 = resign single; 2= resign gammon; 3 = resign bg
  int die1; // 0 means no dice was rolled; 7 can be used for this as well.
  int die2;
  int matchLength;
  List<int> matchScore; // scores for both players
  // the following fields are the only ones which are not present in the match/posId
  String player1Name;
  String player2Name;
  
  PositionRecord() {    
    setDefaultValues();
  } 
  
  PositionRecord.initialPosition() {
    setDefaultValues();
    
    setNrCheckersOnPoint(0, 6, 5);
    setNrCheckersOnPoint(0, 8, 3);
    setNrCheckersOnPoint(0, 13, 5);
    setNrCheckersOnPoint(0, 24, 2);
    
    setNrCheckersOnPoint(1, 6, 5);
    setNrCheckersOnPoint(1, 8, 3);
    setNrCheckersOnPoint(1, 13, 5);
    setNrCheckersOnPoint(1, 24, 2);
    
    matchScore = [0, 0];
    cubeOwner = 3;
    playerOnRoll = 0;
    cubeValue = 1;
    gameState = GAMESTATE_NOGAMESTARTED;
  }

 /**
  * Returns a position with all checkers off for both players
  *
  * @return a valid PositionRecord
  */
  PositionRecord.createFinalPosition() {
    setDefaultValues();
    
    setNrCheckersOnPoint(0, 0, 15);
    setNrCheckersOnPoint(1, 0, 15);
    matchScore = [0, 0];
    cubeOwner = 3;
    playerOnRoll = 1;
    cubeValue = 1;
  }
  
  void setDefaultValues() {
    checkers = [[], []]; 
    checkers[0] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    checkers[1] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    matchScore = [0,0];
    playerOnRoll = 0; 
    cubeValue = 1;
    cubeOwner = CENTERED_CUBE; 
    crawford = false;
    gameState = GAMESTATE_PLAYING; 
    decisionTurn = 0; 
    cubeOffered = false;
    resignation = RESIGNATION_NONE; 
    die1 = DIE_NONE;
    die2 = DIE_NONE;
    matchLength = 0;
    matchScore = [0,0]; 
    player1Name = "";
    player2Name = "";
  }
  
 /**
  *
  * @param player can be 0 or 1
  * @param point can be 0 (nr of checkers off), 1..24 ( the points numbered for the specified player) or 25 (the bar).
  * @return the number of checkers of the player on the point specified
  */
  int getNrCheckersOnPoint(int player, int point) {
    return checkers[player][point];
  }

  void setNrCheckersOnPoint(int player, int point, int nr) {
    checkers[player][point]= nr;
  }
  
  void playHalfMove(HalfMove halfMove) {
    int player = halfMove.player;
    int from = halfMove.from;
    int to = halfMove.to;
    checkers[player][from] -= 1;
    checkers[player][to] += 1;
    int opponent = player == 1? 0: 1;
    if(checkers[opponent][25 - to] == 1) {
      checkers[opponent][25 - to] = 0;
      checkers[opponent][25] += 1;
    }
  }
  
  void undoHalfMove(HalfMove halfMove) {
    int player = halfMove.player;
    int from = halfMove.from;
    int to = halfMove.to;
    checkers[player][from] += 1;
    checkers[player][to] -= 1;
    int opponent = player == 1? 0: 1;
    if(halfMove.hits) {
      checkers[opponent][25 - to] += 1;
      checkers[opponent][25] -= 1;
    }
  }
  
  /**
   * @param onlyMeaningfulDoubles If true, doubles semi DMP scores are not counted as possible
   * @return true if the player with the decisionturn had the cube and the matchscore made doubling possible
   */
  bool isDoublePossible(bool onlyMeaningfulDoubles){
    if (gameState != GAMESTATE_PLAYING) {
        return false;
    }
    if (decisionTurn != playerOnRoll) {
        return false;
    }
    if (cubeOwner != CENTERED_CUBE && cubeOwner != playerOnRoll) {
        return false;
    }
    if (crawford) {
        return false;
    }
    
    if (!onlyMeaningfulDoubles) {
        return true;
    }
    else {
        if (matchScore[0] + cubeValue >= matchLength || matchScore[1] + cubeValue >= matchLength) {
            return false;
        } else {
            return true;
        }
    }
  }

  /**
   * @return true if at least 1 die has a value
   */
  bool haveDiceBeenRolled(){
    if ((die1 != 0) && (die1 != 7)) 
        return true;
    if ((die2 != 0) && (die2 != 7)) 
        return true;
    return false;
  }
  
  /**
  *
   * @return true if crawford could be possible
   */
  bool isCrawfordPossible(){
    if ((matchScore[0] != matchLength - 1) && (matchScore[1] != matchLength - 1)) {
        return false;
    }
    else {
        return true;
    }
  }
  
  /**
   * If crawford is true, this method will reset it if crawford is not applicable to this matchscore
   */
  bool validateCrawford (){
      if (crawford) {
          if (!isCrawfordPossible()) {
              crawford = false;
          }
      }
  }
  
  /**
   * If matchLength <> 0 and a score >= matchLength, this score will be reset to zero
   */
  void validateScores(){
    if (matchLength != 0) {
        if (matchScore[0] >= matchLength) 
            matchScore[0] = 0;
        if (matchScore[1] >= matchLength) 
            matchScore[1] = 0;
    }
  }
  
  void switchTurn() {
    decisionTurn = decisionTurn == 0? 1: 0;
    if (!cubeOffered) {
      playerOnRoll = playerOnRoll == 0 ? 1 : 0; 
    }
  }

  PositionRecord clone(){
    PositionRecord p2 = new PositionRecord();
    for (int i = 0; i < 2; i++) {
        arrayCopy(checkers[i], 0, p2.checkers[i], 0, 26);
    }
    p2.matchScore = [matchScore[0], matchScore[1]];
    p2.crawford = crawford;
    p2.cubeOffered = cubeOffered;
    p2.cubeOwner = cubeOwner;
    p2.cubeValue = cubeValue;
    p2.decisionTurn = decisionTurn;
    p2.die1 = die1;
    p2.die2 = die2;
    p2.gameState = gameState;
    p2.matchLength = matchLength;
    p2.player1Name = player1Name;
    p2.player2Name = player2Name;
    p2.playerOnRoll = playerOnRoll;
    p2.resignation = resignation;
    
    return p2;
  }

  void arrayCopy(List ar1, int start1, List ar2, int start2, int length){
    for (int i = 0; i < length; i++) {
        ar2[start2++] = ar1[start1++];
    }
  }
}
