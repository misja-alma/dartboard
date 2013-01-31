import '../../common/mode/playmode.dart';
import '../../common/mode/movevalidator.dart';
import '../../common/position.dart';
import '../../common/boardmap.dart';
import '../../common/mode/bgaction.dart';
import '../../common/checkerplay.dart';
import '../../common/board.dart';
import '../testutils.dart';
//import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

class MockMovevalidator extends Mock implements MoveValidator {}

class MockBoard extends Mock implements Board {}

main() {
//  useHtmlEnhancedConfiguration();
  
  PositionRecord position;
  PlayMode playmode;
  MockMovevalidator moveValidator;
  MockBoard board = new MockBoard();
  
  group("Player 0 has rolled 6-5", () {
  
    setUp( (){
      position = new PositionRecord.initialPosition();
      position.playerOnRoll = 0;
      position.die1 = 6;
      position.die2 = 5;
      moveValidator = new MockMovevalidator();
      moveValidator.when(callsTo('isDieBlocked', anything, anything, anything)).alwaysReturn(false);
      playmode = new PlayMode.createWithValidator(moveValidator);
      playmode.initializeState(position);
    });
    
    test('Test that picking a checker results in a checkerPlayedAction with highest die', () {
      moveValidator.when(callsTo('getLandingPoint', 0, 6, 24, anything)).alwaysReturn(18);
  
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
  
    test('Test that picking the second checker results in a CheckerPlayed- and RollFinishedAction', () {
      moveValidator.when(callsTo('getLandingPoint', 0, 6, 24, anything)).alwaysReturn(18);
      moveValidator.when(callsTo('getLandingPoint', 0, 5, 13, anything)).alwaysReturn(8);
      
      clickOnPointAndExpectOneAction(playmode, position, 24, 0).execute(board);
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
      moveValidator.when(callsTo('isDieBlocked', anything, anything, anything)).alwaysReturn(false);
      playmode = new PlayMode.createWithValidator(moveValidator);
      playmode.initializeState(position);
    });
    
    test('Test that picking a checker from the bar results in a checkerPlayedAction with the only possible die', () {
      moveValidator.when(callsTo('getLandingPoint', 0, 6, 25, anything)).alwaysReturn(INVALID_MOVE);
      moveValidator.when(callsTo('getLandingPoint', 0, 5, 25, anything)).alwaysReturn(20);
      
      BGAction action = clickOnBarAndExpectOneAction(playmode, position, 1, 0);
      
      expect(action, new isInstanceOf<CheckerPlayedAction>());
      expect((action as CheckerPlayedAction).playedDie, equals(5));
      expect((action as CheckerPlayedAction).pointFrom, equals(25));
      expect((action as CheckerPlayedAction).pointTo, equals(20));
    });
    
    test('Test that after playing the checker from the bar, the 6 can be played correctly', () {
      moveValidator.when(callsTo('getLandingPoint', 0, 6, 25, anything)).alwaysReturn(INVALID_MOVE);
      moveValidator.when(callsTo('getLandingPoint', 0, 5, 25, anything)).alwaysReturn(20);
      
      clickOnBarAndExpectOneAction(playmode, position, 1, 0).execute(board);
      moveValidator.when(callsTo('getLandingPoint', 0, 6, 24, anything)).alwaysReturn(18);
      List<BGAction> actions = clickOnPoint(playmode, position, 24, 0);
      
      expect(actions.length, equals(2));
      expect(actions[0], new isInstanceOf<CheckerPlayedAction>());
      CheckerPlayedAction checkerAction = actions[0] as CheckerPlayedAction;
      expect(checkerAction.pointFrom, equals(24));
      expect(checkerAction.pointTo, equals(18));
      expect(actions[1], new isInstanceOf<RollFinishedAction>());
    });
  });
  
  group("Player 0 has rolled 6-6 from the bar", () {
    
    setUp( (){
      position = getInitialPositionWithPlayerOnBar();
      position.playerOnRoll = 0;
      position.die1 = 6;
      position.die2 = 6;
      moveValidator = new MockMovevalidator();
      moveValidator.when(callsTo('isDieBlocked', 0, 6, anything)).alwaysReturn(true);
      moveValidator.when(callsTo('isValidMove', anything, anything)).alwaysReturn(true);
      playmode = new PlayMode.createWithValidator(moveValidator);
      playmode.initializeState(position);
    });
    
    test('Test that clicking on the bar results in a RollFinishedAction', () {
      BGAction action = clickOnBarAndExpectOneAction(playmode, position, 1, 0);
      
      expect(action, new isInstanceOf<RollFinishedAction>());
    });
    
    test('Test that clicking on a checker results in a RollFinishedAction', () {
      BGAction action = clickOnPointAndExpectOneAction(playmode, position, 24, 1);
      
      expect(action, new isInstanceOf<RollFinishedAction>());
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

BGAction clickOnBarAndExpectOneAction(PlayMode playmode, PositionRecord position, int height, int side) {
  List<BGAction> actions = clickOnBar(playmode, position, height, side);
  expect(actions.length, equals(1));
  return actions[0];
}

List<BGAction> clickOnBar(PlayMode playmode, PositionRecord position, int height, int side) {
  Item item = new Item();
  item.area = AREA_BAR;
  item.index = 25;
  item.height = height;
  item.side = side;
  
  return playmode.interpretMouseClick(position, item);
}



