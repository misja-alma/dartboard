import '../../common/position.dart';
import '../../common/mode/movevalidator.dart';
import '../colortestrunner.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';

main() {
  useColorTestRunner(); 
  
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
  });
}



