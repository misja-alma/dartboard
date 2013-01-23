import '../../common/mode/playmode.dart';
import '../../common/mode/movevalidator.dart';
import '../../common/positionrecord.dart';
import '../../common/boardmap.dart';
import '../../common/mode/bgaction.dart';
import '../../common/checkerplay.dart';
import '../testutils.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

class MockMovevalidator extends Mock implements MoveValidator {}

main() {
  PositionRecord position;
  PlayMode playmode;
  MockMovevalidator moveValidator;
  
  group("Player 0 has rolled 6-5", () {
  
    setUp( (){
      position = new PositionRecord.initialPosition();
      position.playerOnRoll = 0;
      position.die1 = 6;
      position.die2 = 5;
      moveValidator = new MockMovevalidator();
      playmode = new PlayMode.createWithValidator(moveValidator);
      playmode.initializeState(position);
    });
    
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
      CheckerPlayedAction checkerAction = actions[0] as CheckerPlayedAction;
      expect(checkerAction.pointFrom, equals(13));
      expect(checkerAction.pointTo, equals(8));
      expect(actions[1], new isInstanceOf<RollFinishedAction>());
    }); 
  });
  
  group("Player 0 has rolled 6-5 from the bar", () {
  
    setUp( (){
      position = getInitialPositionWithPlayerOnBar();
      position.playerOnRoll = 0;
      position.die1 = 6;
      position.die2 = 5;
      moveValidator = new MockMovevalidator();
      playmode = new PlayMode.createWithValidator(moveValidator);
      playmode.initializeState(position);
    });
    
    test('Test that picking a checker from the bar results in a checkerPlayedAction with the only possible die', () {
      moveValidator.when(callsTo('validateMove', 6, 25, anything)).alwaysReturn(INVALID_MOVE);
      moveValidator.when(callsTo('validateMove', 5, 25, anything)).alwaysReturn(20);
      
      BGAction action = clickOnPointAndExpectOneAction(playmode, position, 25, 1);
      
      expect(action, new isInstanceOf<CheckerPlayedAction>());
      expect((action as CheckerPlayedAction).playedDie, equals(5));
      expect((action as CheckerPlayedAction).pointFrom, equals(25));
      expect((action as CheckerPlayedAction).pointTo, equals(20));
    });
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



