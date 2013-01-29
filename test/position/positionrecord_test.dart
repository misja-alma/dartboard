import 'package:unittest/html_enhanced_config.dart';
import '../../common/position.dart';
import 'package:unittest/unittest.dart';

main() {
  useHtmlEnhancedConfiguration(); 
  
 test('Test constructor', () {
   var positionRecord = new PositionRecord();
   
   expect(positionRecord.cubeValue, equals(1));
   expect(positionRecord.checkers.length, equals(2));
   expect(positionRecord.checkers[0].length, equals(26));
   expect(positionRecord.resignation, equals(RESIGNATION_NONE));
 });
 
 test('Test initial position constructor', () {
   var positionRecord = new PositionRecord.initialPosition();
   
   expect(positionRecord.cubeValue, equals(1));
   expect(positionRecord.checkers.length, equals(2));
   expect(positionRecord.checkers[0].length, equals(26));
   expect(positionRecord.resignation, equals(RESIGNATION_NONE));
   expect(positionRecord.gameState, equals(GAMESTATE_NOGAMESTARTED));
 });
 
 test('Test that clone returns an identical copy', () {
   var positionRecord = new PositionRecord.initialPosition();
   
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
 
 test('Test that playchecker adjusts position correctly', () {
   var positionRecord = new PositionRecord.initialPosition();
   
   positionRecord.playChecker(0, 13, 11);
   
   expect(positionRecord.getNrCheckersOnPoint(0, 13), equals(4));
   expect(positionRecord.getNrCheckersOnPoint(0, 11), equals(1));
 });
 
 test('Test that playchecker, when it hits, adjusts position correctly', () {
   var positionRecord = new PositionRecord.initialPosition();
   positionRecord.setNrCheckersOnPoint(0, 22, 1);
   positionRecord.setNrCheckersOnPoint(0, 24, 1);
   
   positionRecord.playChecker(1, 6, 3);
   
   expect(positionRecord.getNrCheckersOnPoint(1, 6), equals(4));
   expect(positionRecord.getNrCheckersOnPoint(1, 3), equals(1));
   expect(positionRecord.getNrCheckersOnPoint(0, 22), equals(0));
   expect(positionRecord.getNrCheckersOnPoint(0, 25), equals(1));
 });
}
