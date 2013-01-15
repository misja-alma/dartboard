import '../../common/mode/playmode.dart';
import '../../common/mode/movevalidator.dart';
import '../../common/positionrecord.dart';
import '../../common/boardmap.dart';
import '../../common/mode/boardaction.dart';
import '../../common/checkerplay.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

class MockMovevalidator extends Mock implements MoveValidator {}

main() {
  PositionRecord position;
  PlayMode playmode;
  MockMovevalidator moveValidator;
  
  setUp( (){
    position = new PositionRecord.initialPosition();
    position.playerOnRoll = 0;
    position.die1 = 3;
    position.die2 = 2;
    moveValidator = new MockMovevalidator();
    playmode = new PlayMode.createWithValidator(moveValidator);
  });
  // TODO test pick checkers from bar; item.side comes into play then.
  
  test('Test that picking a checker results in a checkerPickedAction', () {
    BoardAction action = clickOnPoint(playmode, position, 6, 3);
    
    expect(action, new isInstanceOf<CheckerPickedAction>());
    expect((action as CheckerPickedAction).point, equals(6));
  });
  
  test('Test that picking an opponent checker results in a NoAction', () {
    BoardAction action = clickOnPoint(playmode, position, 19, 3);
    
    expect(action, new isInstanceOf<NoAction>());    
  });
  
  test('Test that after picking a checker, dropping a checker on a valid point results in a checkerDroppedAction', () {
    clickOnPoint(playmode, position, 6, 0);    
    
    moveValidator.when(callsTo('getPlayedDie', anything, anything, anything, anything)).alwaysReturn(3);
    
    BoardAction action = clickOnPoint(playmode, position, 3, 0);    
    
    expect(action, new isInstanceOf<CheckerDroppedAction>());
    expect((action as CheckerDroppedAction).point, equals(3)); 
    expect(position.getNrCheckersOnPoint(0, 6), equals(4));
    expect(position.getNrCheckersOnPoint(0, 3), equals(1));
  });
  
  test('Test that after picking a checker, dropping a checker on an invalid point results in a IllegalAction', () {    
    clickOnPoint(playmode, position, 6, 0);
    
    moveValidator.when(callsTo('getPlayedDie', anything, anything, anything, anything)).alwaysReturn(DIE_NONE);
    
    BoardAction action = clickOnPoint(playmode, position, 3, 0);
    
    expect(action, new isInstanceOf<IllegalAction>());
  });

  test('Test that picking and dropping of 2 checkers results in a correct checkerPlayAction', () {
    moveValidator.when(callsTo('getPlayedDie', anything, 6, 3, anything)).alwaysReturn(3);
    moveValidator.when(callsTo('getPlayedDie', anything, 6, 4, anything)).alwaysReturn(2);
    
    clickOnPoint(playmode, position, 6, 0);
    clickOnPoint(playmode, position, 3, 0);
    
    clickOnPoint(playmode, position, 6, 0);
    BoardAction action = clickOnPoint(playmode, position, 4, 0);
    
    expect(action, new isInstanceOf<CheckerplayAction>());
    Checkerplay checkerplay = (action as CheckerplayAction).checkerplay;
    expect(checkerplay.halfMoves, unorderedEquals([new HalfMove(6, 3), new HalfMove(6, 4)]));
  }); 
}

BoardAction clickOnPoint(PlayMode playmode, PositionRecord position, int point, int height) {
  Item item = new Item();
  item.area = AREA_CHECKER;
  item.index = point;
  item.height = height;
  
  return playmode.interpretMouseClick(position, item);
}



