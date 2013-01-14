import '../common/positionconverter.dart';
import '../common/positionrecord.dart';
import 'package:unittest/unittest.dart';

main() {
 test('Test getMatchId returns the correct Id for a match with player 1 on roll"', () {
   PositionRecord positionRecord = new PositionRecord();
   positionRecord.playerOnRoll = 1;
   positionRecord.decisionTurn = 1;
   positionRecord.crawford = false;
   positionRecord.matchLength = 7;
   positionRecord.matchScore[0] = 1;
   positionRecord.matchScore[1] = 2;
   positionRecord.gameState = 0;
   positionRecord.cubeValue = 1;
   
   expect(getMatchId(positionRecord), equals("cIj/ABAAEAAA"));
 });
 
 test('Test getPositionId returns the correct Id for an empty position"', () {
     PositionRecord positionRecord = new PositionRecord();
     expect(getPositionId(positionRecord), equals("AAAAAAAAAAAAAA"));
 });
   
 test("Test getPositionId returns the correct Id for the initial position", (){
   PositionRecord positionRecord = new PositionRecord.initialPosition();
   expect(getPositionId(positionRecord), equals("4HPwATDgc/ABMA"));
 });
 
 test("Test thaat initializePositionFromMatchId should dissect moneygame matchid correctly", (){
   PositionRecord positionRecord = initializePositionFromMatchId("cIgfAAAAAAAA");
   
   expect(positionRecord.playerOnRoll, equals(1));
   expect(positionRecord.crawford, isFalse);
   expect(positionRecord.matchLength, equals(0));
   expect(positionRecord.matchScore[0], equals(0));
   expect(positionRecord.matchScore[1], equals(0));
 });
 
 test("Test that initializePositionFromMatchId should dissect match with player 1 on roll correctly", (){
   PositionRecord positionRecord = initializePositionFromMatchId("cIj/ABAAEAAA");
   
   expect(positionRecord.decisionTurn, equals(1));
   expect(positionRecord.playerOnRoll, equals(1));
   expect(positionRecord.cubeOffered, isFalse);
   expect(positionRecord.crawford, isFalse);
   expect(positionRecord.matchLength, equals(7));
   expect(positionRecord.matchScore[0], equals(1));
   expect(positionRecord.matchScore[1], equals(2));
   expect(positionRecord.die1, equals(DIE_NONE));
   expect(positionRecord.die2, equals(DIE_NONE));
 });
 
 test("Test that initializePositionFromMatchId should dissect match with player 1 having rolled 3-2 correctly", (){
   PositionRecord positionRecord = initializePositionFromMatchId("cInpAAAAAAAA");
   
   expect(positionRecord.decisionTurn, equals(1));
   expect(positionRecord.playerOnRoll, equals(1));
   expect(positionRecord.crawford, isFalse);
   expect(positionRecord.matchLength, equals(7));
   expect(positionRecord.matchScore[0], equals(0));
   expect(positionRecord.matchScore[1], equals(0));
   expect(positionRecord.die1, equals(3));
   expect(positionRecord.die2, equals(2));
 });

 test("Test that xgIdToPosition should initialize some middlegame position without errors", (){
   PositionRecord positionRecord = xgIdToPosition("-a-B--E-B-a-dDB--b-bcb----:1:1:-1:63:0:0:0:3:8");
   
   expect(positionRecord.checkers[0][6], equals(5));
   expect(positionRecord.checkers[1][6], equals(2));
   expect(positionRecord.checkers[0][0], equals(0));
   expect(positionRecord.checkers[1][0], equals(0));
   expect(positionRecord.checkers[0][13], equals(4));
   expect(positionRecord.checkers[1][5], equals(3));
   
   expect(positionRecord.playerOnRoll, equals(1));
   expect(positionRecord.cubeOwner, equals(0));
   expect(positionRecord.cubeValue, equals(2));
   expect(positionRecord.die1, equals(6));
   expect(positionRecord.die2, equals(3));
   expect(positionRecord.matchLength, equals(3));
   expect(positionRecord.matchScore[0], equals(0));
   expect(positionRecord.matchScore[1], equals(0));
   expect(positionRecord.crawford, isFalse);
 });
}
