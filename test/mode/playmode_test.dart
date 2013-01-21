import '../../common/mode/playmode.dart';
import '../../common/mode/movevalidator.dart';
import '../../common/positionrecord.dart';
import '../../common/boardmap.dart';
import '../../common/mode/bgaction.dart';
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
    position.die1 = 6;
    position.die2 = 5;
    moveValidator = new MockMovevalidator();
    playmode = new PlayMode.createWithValidator(moveValidator);
    playmode.initializeState(position);
  });
  // TODO test pick checkers from bar; item.side comes into play then.
  
  test('Test that picking a checker results in a checkerPlayedAction with highest die', () {
    moveValidator.when(callsTo('validateMove', 6, 24, anything)).alwaysReturn(18);

    BGAction action = clickOnPointAndExpectOneAction(playmode, position, 24, 1);
    
    expect(action, new isInstanceOf<CheckerPlayedAction>());
    expect((action as CheckerPlayedAction).playedDie, equals(6));
    expect((action as CheckerPlayedAction).pointFrom, equals(24));
    expect((action as CheckerPlayedAction).pointTo, equals(18));
  });
  
  test('Test that picking an opponent checker results in a NoAction', () {
    List<BGAction> actions = clickOnPoint(playmode, position, 19, 3);
    
    expect(actions.length, equals(0));    
  });
  
  test('Test that picking a checker with invalid points for both dice results in  no Action', () {    
    moveValidator.when(callsTo('validateMove', anything, anything, anything)).alwaysReturn(INVALID_MOVE);
    
    List<BGAction> action = clickOnPoint(playmode, position, 6, 0);
    
    expect(action.length, equals(0));
  });

  test('Test that picking the second checker results in a CheckerPlayed- and RollFinishedAction', () {
    moveValidator.when(callsTo('validateMove', 6, 24, anything)).alwaysReturn(18);
    moveValidator.when(callsTo('validateMove', 5, 13, anything)).alwaysReturn(8);
    
    clickOnPointAndExpectOneAction(playmode, position, 24, 0);
    List<BGAction> actions = clickOnPoint(playmode, position, 13, 0);
    
    expect(actions.length, equals(2));
    expect(actions[0], new isInstanceOf<CheckerPlayedAction>());
    expect(actions[1], new isInstanceOf<RollFinishedAction>());
  }); 
}

BGAction clickOnPointAndExpectOneAction(PlayMode playmode, PositionRecord position, int point, int height) {
  List<BGAction> actions = clickOnPoint(playmode, position, point, height);
  expect(actions.length, equals(1));
  return actions[0];
}

List<BGAction> clickOnPoint(PlayMode playmode, PositionRecord position, int point, int height) {
  Item item = new Item();
  item.area = AREA_CHECKER;
  item.index = point;
  item.height = height;
  
  return playmode.interpretMouseClick(position, item);
}



