import '../common/positionrecord.dart';
import '../packages/unittest/unittest.dart';

main() {
 test('Test constructor', () {
   var positionRecord = new Positionrecord();
   
   expect(positionRecord.cubeValue, equals(1));
   expect(positionRecord.checkers.length, equals(2));
   expect(positionRecord.checkers[0].length, equals(26));
   expect(positionRecord.resignation, equals(RESIGNATION_NONE));
 });
 
 test('Test initial position constructor', () {
   var positionRecord = new Positionrecord.initialPosition();
   
   expect(positionRecord.cubeValue, equals(1));
   expect(positionRecord.checkers.length, equals(2));
   expect(positionRecord.checkers[0].length, equals(26));
   expect(positionRecord.resignation, equals(RESIGNATION_NONE));
   expect(positionRecord.gameState, equals(GAMESTATE_NOGAMESTARTED));
 });
 
 test('Test that clone returns an identical copy', () {
   var positionRecord = new Positionrecord.initialPosition();
   
   var clonedPosition = positionRecord.clone();
   for (var player = 0; player < 2; player++) {
     for (var point = 0; point < 26; point++) {           
       expect(positionRecord.checkers[player][point], equals(clonedPosition.checkers[player][point]),
           reason: "Difference for player $player point $point");
     }
   }
   
   positionRecord.checkers[0][0] = 1;
   expect(positionRecord.checkers[0][0], isNot(clonedPosition.checkers[0][0]));
 });
}
