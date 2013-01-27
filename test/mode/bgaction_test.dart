import '../../common/board.dart';
import '../../common/position.dart';
import '../../common/mode/bgaction.dart';
import '../colortestrunner.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

class MockBoard extends Mock implements Board {}

main() {
  useColorTestRunner(); 
  
  PositionRecord position;
  MockBoard board = new MockBoard();
    
  group("SwtichTurnAction", () {
    SwitchTurnAction action;
    
    setUp( (){
      position = new PositionRecord.initialPosition();;
      position.playerOnRoll = 0;
      position.die1 = 6;
      position.die2 = 5;
      action = new SwitchTurnAction(position);
    });
    
    test('should switch the turn in board and position', () {
      action.execute(board);
      
      expect(position.playerOnRoll, equals(1));
      board.getLogs(callsTo('switchTurn')).verify(happenedOnce);
    });
  });
  
  group("CheckerPlayedAction", () {
    CheckerPlayedAction action;
    
    setUp( (){
      position = new PositionRecord.initialPosition();;
      position.playerOnRoll = 0;
      position.die1 = 6;
      position.die2 = 5;
      action = new CheckerPlayedAction(position: position, pointFrom: 24, pointTo: 18, playedDie: 6, player: 0);
    });
    
    test('should play the checker in the position and on the board', () {
      action.execute(board);
      
      expect(position.getNrCheckersOnPoint(0, 24), equals(1));
      expect(position.getNrCheckersOnPoint(0, 18), equals(1));
      board.getLogs(callsTo('checkerPlayed')).verify(happenedOnce);
      expect(board.getLogs(callsTo('checkerPlayed')).first.args, equals([0, 24, 18]));
    });
  });
}



