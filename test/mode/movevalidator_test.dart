import '../../common/position.dart';
import '../../common/mode/movevalidator.dart';
//import 'package:unittest/html_enhanced_config.dart';
import '../testutils.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

main() {
  //useHtmlEnhancedConfiguration();
  
  MoveValidator moveValidator = new MoveValidator();
  PositionRecord position;
    
  group("getLandingPoint", () {
    
    setUp( (){
      position = new PositionRecord.initialPosition();
    });
    
    test('should return the point the checker lands on, if it is a valid move', () {
      int player = 0;
      int die = 6;
      int startPoint = 24;
      
      int landingPoint = moveValidator.getLandingPoint(player, die, startPoint, position);
      
      expect(landingPoint, equals(18));
    });
    
    test('should return the point the checker lands on, when he enters from the bar', () {
      position = getInitialPositionWithPlayerOnBar();
      int player = 0;
      int die = 5;
      int startPoint = 25;
      
      int landingPoint = moveValidator.getLandingPoint(player, die, startPoint, position);
      
      expect(landingPoint, equals(20));
    });
    
    test('should return INVALID_MOVE, if the endpoint is an opponent point', () {
      int player = 0;
      int die = 5;
      int startPoint = 24;
      
      int landingPoint = moveValidator.getLandingPoint(player, die, startPoint, position);
      
      expect(landingPoint, equals(INVALID_MOVE));
    });
    
    test('should return INVALID_MOVE, if the endpoint <= 0 and it is no bearoff yet', () {
      int player = 0;
      int die = 6;
      int startPoint = 6;
      
      int landingPoint = moveValidator.getLandingPoint(player, die, startPoint, position);
      
      expect(landingPoint, equals(INVALID_MOVE));
    });
  });
}



