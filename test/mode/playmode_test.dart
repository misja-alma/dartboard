import '../../common/mode/playmode.dart';
import '../../common/mode/movevalidator.dart';
import '../../common/positionrecord.dart';
import '../../common/boardmap.dart';
import '../../common/mode/boardaction.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

class MockMovevalidator extends Mock implements MoveValidator {}

main() {
  PositionRecord position;
  Item item;
  PlayMode playmode;
  MockMovevalidator moveValidator;
  
  setUp( (){
    position = new PositionRecord.initialPosition();
    position.playerOnRoll = 0;
    position.die1 = 3;
    position.die2 = 2;
    item = new Item();
    moveValidator = new MockMovevalidator();
    playmode = new PlayMode.createWithValidator(moveValidator);
  });
  // TODO test pick checkers from bar; item.side comes into play then.
  
  test('Test that picking a checker results in a checkerPickedAction', () {
    item.area = AREA_CHECKER;
    item.index = 6;
    item.height = 3;
    
    BoardAction action = playmode.interpretMouseClick(position, item);
    
    expect(action, new isInstanceOf<CheckerPickedAction>());
    expect((action as CheckerPickedAction).point, equals(6));
  });
  
  test('Test that picking an opponent checker results in a NoAction', () {
    item.area = AREA_CHECKER;
    item.index = 19;
    item.height = 3;
    
    BoardAction action = playmode.interpretMouseClick(position, item);
    
    expect(action, new isInstanceOf<NoAction>());    
  });
  
  test('Test that after picking a checker, dropping a checker on a valid point results in a checkerDroppedAction', () {
    item.area = AREA_CHECKER;
    item.index = 6;
    item.height = 3;
    
    BoardAction action = playmode.interpretMouseClick(position, item);
    
    item.area = AREA_CHECKER;
    item.index = 3;
    item.height = 0;
    
    moveValidator.when(callsTo('getPlayedDie', anything, anything, anything, anything)).alwaysReturn(3);
    
    action = playmode.interpretMouseClick(position, item);
    
    expect(action, new isInstanceOf<CheckerDroppedAction>());
    expect((action as CheckerDroppedAction).point, equals(3)); 
    expect(position.getNrCheckersOnPoint(0, 6), equals(4));
    expect(position.getNrCheckersOnPoint(0, 3), equals(1));
  });
  
  test('Test that after picking a checker, dropping a checker on an invalid point results in a IllegalAction', () {    
    item.area = AREA_CHECKER;
    item.index = 6;
    item.height = 3;
    
    BoardAction action = playmode.interpretMouseClick(position, item);
    
    item.area = AREA_CHECKER;
    item.index = 3;
    item.height = 0;
    
    moveValidator.when(callsTo('getPlayedDie', anything, anything, anything, anything)).alwaysReturn(DIE_NONE);
    
    action = playmode.interpretMouseClick(position, item);
    
    expect(action, new isInstanceOf<IllegalAction>());
  });

  test('Test that picking and dropping of 2 checkers results in a correct checkerPlayAction', () {
 
  });
}

