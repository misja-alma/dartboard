library positionconverter;

import 'positionrecord.dart';
import 'base64utils.dart';
import 'stringutils.dart';
import 'bitutils.dart';
import 'xgparseutils.dart';
import 'dart:math';

/**
 * Intitializes the position record with the data stored in the both id's.
 *
 * @param posId the gnu position id
 * @param matchId the gnu match id
 */
  Positionrecord gnuIdToPosition(String posId, String matchId){
    posId = posId.trim();
    matchId = matchId.trim();
      
    // first we need to know if player zero or player one is on roll. So dissect the matchId first
    Positionrecord position = initializePositionFromMatchId(matchId);
    
    // dissect the position id
    List<int> bytes = stringToBytes(posId);
    int nrPlayersCounted = 0;
    int player = position.playerOnRoll;
    int point = 1;
    int nrOnPoint = 0;
    bool ready = false;
    // create a normalized bitstring first
    List<int> bits = base64ToBits(posId, 160);
    
    for (int c = 0; c < bits.length && !ready; c++) {
        if (bits[c] != 1) {
            // a zero marks the end of a point
            position.checkers[player][point] = nrOnPoint;
            nrOnPoint = 0;
            
            if (point >= 25) {
                nrPlayersCounted++;
                // calculate nr of checkers on point 0;
                int nrOff = 15;
                for (int i = 1; i < 26; i++) {
                    nrOff -= position.checkers[player][i];
                }
                position.checkers[player][0] = nrOff;
                
                if (nrPlayersCounted == 2) {
                    ready = true;
                }
                else {
                    player = (~ player) & 1; // player := not player
                    point = 1;
                }
            }
            else {
                point++;
            }
        }
        else {
            nrOnPoint++;
        }
    }
    return position;
  }
  
  Positionrecord initializePositionFromMatchId(String matchId) {
    Positionrecord position = new Positionrecord();
    // the matchId string looks as follows:
    // every character contains six bits; the bits 5..0 are used.
    // The first character in the string holds bit 2..7; the second bit 0..1 and 12..15; etc.
    
    // first transform the match id into a bit array
    List<int> bits = base64ToBits(matchId, 72);
    
    position.cubeValue = pow(2, bitSubString(bits, 0, 4));
    position.cubeOwner = bitSubString(bits, 4, 6);
    position.playerOnRoll = bitSubString(bits, 6, 7);
    position.crawford = bitSubString(bits, 7, 8) == 1;
    position.gameState = bitSubString(bits, 8, 11);
    position.decisionTurn = bitSubString(bits, 11, 12);
    position.cubeOffered = bitSubString(bits, 12, 13) == 1;
    position.resignation = bitSubString(bits, 13, 15);
    position.die1 = bitSubString(bits, 15, 18);
    if(position.die1 == 7) {
      position.die1 = DIE_NONE;
    }
    position.die2 = bitSubString(bits, 18, 21);
    if(position.die2 == 7) {
      position.die2 = DIE_NONE;
    }
    position.matchLength = bitSubString(bits, 21, 36);
    position.matchScore[0] = bitSubString(bits, 36, 51);
    position.matchScore[1] = bitSubString(bits, 51, 66);
    return position;
 }
  
 /**
  *
  * @return the gnu position id
  */
  String getPositionId(Positionrecord position){
    List<int> bits = [];
    // make a long bit string
    int player = position.playerOnRoll; 
    for (int nrPlayers = 0; nrPlayers < 2; nrPlayers++) {
        int nrCheckersSoFar = 0;
        for (int point = 1; point < 26; point++) {
            int nr = position.checkers[player][point];
            for (int t = 0; t < nr; t++) {
                nrCheckersSoFar++;
                if (nrCheckersSoFar > 15) { 
                    throw("Player $nrPlayers has more than 15 checkers");
                }
                bits.add(1);
            }
            bits.add(0);
        }
        player = (~ player) & 1; // player := not player
    }
    // turn it into characters
    return makeBase64String(bits, 14);
  }
  
  /**
   * @return the gnu match id
   */
  String getMatchId(Positionrecord position){
    List<int> bits = new List(67);
    
    putIntoBitString(bits, getTwoLogOfCube(position.cubeValue), 0, 4);
    putIntoBitString(bits, position.cubeOwner, 4, 6);
    putIntoBitString(bits, position.playerOnRoll, 6, 7);
    putIntoBitString(bits, position.crawford ? 1 : 0, 7, 8);
    putIntoBitString(bits, position.gameState, 8, 11);
    putIntoBitString(bits, position.decisionTurn, 11, 12);
    putIntoBitString(bits, position.cubeOffered ? 1 : 0, 12, 13);
    putIntoBitString(bits, position.resignation, 13, 15);
    putIntoBitString(bits, position.die1 == 0? 7 : position.die1, 15, 18);
    putIntoBitString(bits, position.die2 == 0? 7 : position.die2, 18, 21);
    putIntoBitString(bits, position.matchLength, 21, 36);
    putIntoBitString(bits, position.matchScore[0], 36, 51);
    putIntoBitString(bits, position.matchScore[1], 51, 66);
    
    return makeBase64String(bits, 12);
  }
  
  Positionrecord xgIdToPosition(String xgId){
    xgId = xgId.trim();
    Positionrecord position = new Positionrecord();
    
    position.checkers[1][25] = decodeXGCharcode(xgId.charCodeAt(0)).nrCheckers;
    
    for (int i = 1; i < 25; i++) {
        PlayerWithCheckers checkersAtPoint = decodeXGCharcode(xgId.charCodeAt(i));
        if (checkersAtPoint.player != -1) {       
            int adjustedPoint = checkersAtPoint.player == 1 ? 25 - i : i;
            position.checkers[checkersAtPoint.player][adjustedPoint] = checkersAtPoint.nrCheckers;
        }
    }
    position.checkers[0][25] = decodeXGCharcode(xgId.charCodeAt(25)).nrCheckers;
    
    int charPos = 27;
    
    // TODO The following code might be more efficiently parsed with the split function
    // why this does something like ' int == "string" ' compile. Can we force the compiler to be more strict?
    
    int nextAttributePos = xgId.indexOf(":", charPos);

    String cubeLevel = xgId.substring(charPos, nextAttributePos);
    position.cubeValue = pow(2, int.parse(cubeLevel));
    
    charPos = nextAttributePos + 1;
    nextAttributePos = xgId.indexOf(":", charPos);
    
    String rawCubeOwner = xgId.substring(charPos, nextAttributePos);
    if (rawCubeOwner == 0) {
      position.cubeOwner = CENTERED_CUBE;
    } else {
      position.cubeOwner = rawCubeOwner == "1" ? 0 : 1;
    }
    
    charPos = nextAttributePos + 1;
    nextAttributePos = xgId.indexOf(":", charPos);
    
    String rawPlayerOnRoll = xgId.substring(charPos, nextAttributePos);
    position.playerOnRoll = rawPlayerOnRoll == 1? 0: 1;
      
    charPos = nextAttributePos + 1;
    nextAttributePos = xgId.indexOf(":", charPos);
    
    String rawDice = xgId.substring(charPos, nextAttributePos);
    if(rawDice == "00") {
      position.die1 = DIE_NONE;
      position.die2 = DIE_NONE; 
      position.decisionTurn = position.playerOnRoll;    
    } else if(rawDice == "D") {
      position.die1 = DIE_NONE;
      position.die2 = DIE_NONE; 
      position.decisionTurn = position.playerOnRoll == 0? 1: 0;
      position.cubeOffered = true;
    } // No option yet for double/ beaver/ raccoon (B, R)
    else {
      position.die1 = parseInt(rawDice[0]);
      position.die2 = parseInt(rawDice[1]); 
      position.decisionTurn = position.playerOnRoll;    
    }
    
    charPos = nextAttributePos + 1;
    nextAttributePos = xgId.indexOf(":", charPos);
    
    String rawScore = xgId.substring(charPos, nextAttributePos);
    position.matchScore[0] = parseInt(rawScore);
      
    charPos = nextAttributePos + 1;
    nextAttributePos = xgId.indexOf(":", charPos);
    
    rawScore = xgId.substring(charPos, nextAttributePos);
    position.matchScore[1] = parseInt(rawScore);
      
    charPos = nextAttributePos + 1;
    nextAttributePos = xgId.indexOf(":", charPos);
    
    String rawGameRules = xgId.substring(charPos, nextAttributePos);
    // TODO jacoby, beaver
    position.crawford = rawGameRules == 1;
    
    charPos = nextAttributePos + 1;
    nextAttributePos = xgId.indexOf(":", charPos);
    
    position.matchLength = parseInt(xgId.substring(charPos, nextAttributePos));
    if(position.matchLength == 0) {
      position.crawford = false;
    }
    // maxcube is not used
    return position;
  }


  /**
   * @return the 2-log of the cube
   */
  int getTwoLogOfCube(int cubeValue){
    int twoLog = 0;
    int power = 1;
    while (power < cubeValue) {
        power = power * 2;
        twoLog++;
    }
    return twoLog;
  }
