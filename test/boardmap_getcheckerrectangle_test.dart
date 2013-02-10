import '../common/boardmap.dart';
import 'package:unittest/unittest.dart';

main() {
  
    group("Clockwise board", () {
      BoardMap boardMap;
      Item item;
      
      setUp( (){
          boardMap = new BoardMap(0.0, 0.0, 200.0, 200.0, true);
          item = new Item();
      });
      
      test("getCheckerRectangle should calculate coordinates of own checker on 1 point to be somewhere in left bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(1, 1, false);
        
        expect(rec.x, lessThan(100));
        expect(rec.y, greaterThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of second own checker on 1 point to be one checker height higher than first checker", (){
        Area recFirst = boardMap.getCheckerRectangle(1, 1, false);
        Area recSecond = boardMap.getCheckerRectangle(1, 2, false);
        
        expect(recSecond.x, equals(recFirst.x));
        expect(recSecond.y, equals(recFirst.y - recFirst.height));
      });
      
      test("getCheckerRectangle should calculate coordinates of own checker on 7 point to be somewhere in right bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(7, 1, false);
        
        expect(rec.x, greaterThan(100));
        expect(rec.y, greaterThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of own checker on 13 point to be somewhere in right top corner", (){
        Area rec = boardMap.getCheckerRectangle(13, 1, false);
        
        expect(rec.x, greaterThan(100));
        expect(rec.y, lessThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of own checker on 19 point to be somewhere in left top corner", (){
        Area rec = boardMap.getCheckerRectangle(19, 1, false);
        
        expect(rec.x, lessThan(100));
        expect(rec.y, lessThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of own checker on 0 point (born off) to be in the very left bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(0, 1, false);
        
        expect(rec.x, lessThan(50));
        expect(rec.y, greaterThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of own checker on 25 point (bar) to be somewhere below in the middle", (){
        Area rec = boardMap.getCheckerRectangle(25, 1, false);
        
        expect(rec.x, greaterThan(75));
        expect(rec.x, lessThan(125));
        expect(rec.y, greaterThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of second own checker on 25 point (bar) to be one diameter below the first", (){
        Area rec1 = boardMap.getCheckerRectangle(25, 1, false);
        Area rec2 = boardMap.getCheckerRectangle(25, 2, false);
        
        expect(rec1.x, equals(rec2.x));
        expect(rec1.y, equals(rec2.y - 2 * boardMap.checkerRadius));
      });
      
      test("getCheckerRectangle should calculate coordinates of opponent's checker on 1 point to be somewhere in left top corner", (){
        Area rec = boardMap.getCheckerRectangle(1, 1, true);
        
        expect(rec.x, lessThan(100));
        expect(rec.y, lessThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of second opponent's checker on 1 point to be one checker height higher than first checker", (){
        Area recFirst = boardMap.getCheckerRectangle(1, 1, true);
        Area recSecond = boardMap.getCheckerRectangle(1, 2, true);
        
        expect(recSecond.x, equals(recFirst.x));
        expect(recSecond.y, equals(recFirst.y + recFirst.height));
      });
      
      test("getCheckerRectangle should calculate coordinates of opponent's checker on 7 point to be somewhere in right top corner", (){
        Area rec = boardMap.getCheckerRectangle(7, 1, true);
        
        expect(rec.x, greaterThan(100));
        expect(rec.y, lessThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of opponent's checker on 13 point to be somewhere in right bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(13, 1, true);
        
        expect(rec.x, greaterThan(100));
        expect(rec.y, greaterThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of opponent's checker on 19 point to be somewhere in left bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(19, 1, true);
        
        expect(rec.x, lessThan(100));
        expect(rec.y, greaterThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of opponent's checker on 0 point (born off) to be int the very left top corner", (){
        Area rec = boardMap.getCheckerRectangle(0, 1, true);
        
        expect(rec.x, lessThan(50));
        expect(rec.y, lessThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of opponent's checker on 25 point (bar) to be somewhere up in the middle", (){
        Area rec = boardMap.getCheckerRectangle(25, 1, true);
        
        expect(rec.x, greaterThan(75));
        expect(rec.x, lessThan(125));
        expect(rec.y, lessThan(100));
      });
      
      test("getCheckerRectangle should calculate coordinates of second opponent's checker on 25 point (bar) to be one diameter above the first", (){
        Area rec1 = boardMap.getCheckerRectangle(25, 1, true);
        Area rec2 = boardMap.getCheckerRectangle(25, 2, true);
        
        expect(rec1.x, equals(rec2.x));
        expect(rec1.y, equals(rec2.y + 2 * boardMap.checkerRadius));
      });
    
    });
    
    group("Counterclockwise board", () {
      BoardMap boardMap;
      Item item;
      
      setUp( (){
          boardMap = new BoardMap(0.0, 0.0, 200.0, 200.0, false);
          item = new Item();
      });
      
      test("should calculate coordinates of own checker on 1 point to be somewhere in right bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(1, 1, false);
        
        expect(rec.x, greaterThan(100));
        expect(rec.y, greaterThan(100));
      });
      
      test("should calculate coordinates of own checker on 7 point to be somewhere in left bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(7, 1, false);
        
        expect(rec.x, lessThan(100));
        expect(rec.y, greaterThan(100));
      });
      
      test("should calculate coordinates of own checker on 13 point to be somewhere in left top corner", (){
        Area rec = boardMap.getCheckerRectangle(13, 1, false);
        
        expect(rec.x, lessThan(100));
        expect(rec.y, lessThan(100));
      });
      
      test("should calculate coordinates of own checker on 19 point to be somewhere in right top corner", (){
        Area rec = boardMap.getCheckerRectangle(19, 1, false);
        
        expect(rec.x, greaterThan(100));
        expect(rec.y, lessThan(100));
      });
      
      test("should calculate coordinates of opponent's checker on 1 point to be somewhere in right top corner", (){
        Area rec = boardMap.getCheckerRectangle(1, 1, true);
        
        expect(rec.x, greaterThan(100));
        expect(rec.y, lessThan(100));
      });
      
      test("should calculate coordinates of opponent's checker on 7 point to be somewhere in left top corner", (){
        Area rec = boardMap.getCheckerRectangle(7, 1, true);
        
        expect(rec.x, lessThan(100));
        expect(rec.y, lessThan(100));
      });
      
      test("should calculate coordinates of opponent's checker on 13 point to be somewhere in left bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(13, 1, true);
        
        expect(rec.x, lessThan(100));
        expect(rec.y, greaterThan(100));
      });
      
      test("should calculate coordinates of opponent's checker on 19 point to be somewhere in right bottom corner", (){
        Area rec = boardMap.getCheckerRectangle(19, 1, true);
        
        expect(rec.x, greaterThan(100));
        expect(rec.y, greaterThan(100));
      });      
    });
}
