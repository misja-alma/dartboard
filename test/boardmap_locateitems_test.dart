import '../common/boardmap.dart';
import 'colortestrunner.dart';
import 'package:unittest/unittest.dart';

main() {
  useColorTestRunner(); 
  
    BoardMap boardMap;
    Item item;
    
    setUp( (){
        boardMap = new BoardMap(0.0, 0.0, 200.0, 200.0, true);
        item = new Item();
    });

    test("Test that locateChecker should map location on point 1 to proper area, index and height", (){
        boardMap.locateChecker(item, boardMap.board.x + 1, boardMap.board.y + boardMap.board.height - 1);
        
        expect(item.area, equals(AREA_CHECKER));
        expect(item.side, equals(0));
        expect(item.index, equals(1));
        expect(item.height, equals(1));
    });
  
   test("Test that locateChecker should map location of second checker on point 1 to proper area, index and height", (){
        boardMap.locateChecker(item, boardMap.board.x + 1, boardMap.board.y + boardMap.board.height - boardMap.checkerRadius * 2 - 1);
        
        expect(item.area, equals(AREA_CHECKER));
        expect(item.side, equals(0));
        expect(item.index, equals(1));
        expect(item.height, equals(2));
    });
    
    test("Test that locateChecker should map location on point 7 to proper area, index and height", (){
        boardMap.locateChecker(item, boardMap.bar.x + boardMap.bar.width + 1, boardMap.board.y + boardMap.board.height - 1);
        
        expect(item.area, equals(AREA_CHECKER));
        expect(item.side, equals(0));
        expect(item.index, equals(7));
        expect(item.height, equals(1));
    });
    
    test("Test that locateChecker should map location of second checker on point 13 to proper area, index and height", (){
        boardMap.locateChecker(item, boardMap.board.x + boardMap.board.width - 1, boardMap.board.y + boardMap.checkerRadius * 2 + 1);
        
        expect(item.area, equals(AREA_CHECKER));
        expect(item.side, equals(0));
        expect(item.index, equals(13));
        expect(item.height, equals(2));
    });
    
    test("Test that locateChecker should map location on point 19 to proper area, index and height", (){
        boardMap.locateChecker(item, boardMap.bar.x - 1, boardMap.board.y + 1);
        
        expect(item.area, equals(AREA_CHECKER));
        expect(item.side, equals(0));
        expect(item.index, equals(19));
        expect(item.height, equals(1));
    });
    
   ///////////////////// locateBar
    
    test("Test that locateBar should map location in top of own bar area to proper area and height", (){
        boardMap.locateBar(item, boardMap.barMe.x + 1, boardMap.barMe.y);
        
        expect(item.area, equals(AREA_BAR));
        expect(item.side, equals(0));
        expect(item.height, equals(1));
    });
    
    test("Test that locateBar should map location in top of opponent's bar area to proper area and height", (){
        boardMap.locateBar(item, boardMap.barOpp.x + 1, boardMap.barOpp.y + boardMap.barOpp.height - 1);
        
        expect(item.area, equals(AREA_BAR));
        expect(item.side, equals(1));
        expect(item.height, equals(1));
    });
    
    test("Test that locateBar should map location in third checker of own bar area to proper area and height", (){
        boardMap.locateBar(item, boardMap.barMe.x + 1, boardMap.barMe.y + boardMap.checkerRadius * 3 - 1);
        
        expect(item.area, equals(AREA_BAR));
        expect(item.side, equals(0));
        expect(item.height, equals(3));
    });
    
    test("Test that locateBar should map location in third checker of opponent's bar area to proper area and height", (){
        boardMap.locateBar(item, boardMap.barOpp.x + 1, boardMap.barOpp.y + boardMap.barOpp.height + 1 - boardMap.checkerRadius * 3);
        
        expect(item.area, equals(AREA_BAR));
        expect(item.side, equals(1));
        expect(item.height, equals(3));
    });

    //////////////////////// locateBearOff
    
    test("Test that locateBearOff should map location in bottom of own bearoff area to proper area and height", (){
        boardMap.locateBearOff(item, boardMap.zeroPointMe.x + 1, boardMap.zeroPointMe.y + boardMap.zeroPointMe.height - 1);
        
        expect(item.area, equals(AREA_BEAROFF));
        expect(item.side, equals(0));
        expect(item.height, equals(1));
    });
    
    test("Test that locateBearOff should map location in bottom of opponent's bearoff area to proper area and height", (){
        boardMap.locateBearOff(item, boardMap.zeroPointOpp.x + 1, boardMap.zeroPointOpp.y);
        
        expect(item.area, equals(AREA_BEAROFF));
        expect(item.side, equals(1));
        expect(item.height, equals(1));
    });
    
    test("Test that locateBearOff should map location in third checker of own bearoff area to proper area and height", (){
        boardMap.locateBearOff(item, 
                               boardMap.zeroPointMe.x + 1, 
                               boardMap.zeroPointMe.y + boardMap.zeroPointMe.height - 1 - boardMap.zeroPointCheckerHeight * 2);
        
        expect(item.area, equals(AREA_BEAROFF));
        expect(item.side, equals(0));
        expect(item.height, equals(3));
    });
    
    test("Test that locateBearOff should map location in third checker of opponent's bearoff area to proper area and height", (){
        boardMap.locateBearOff(item, 
                              boardMap.zeroPointOpp.x + 1, 
                              boardMap.zeroPointOpp.y + boardMap.zeroPointCheckerHeight * 2 + 1);
        
        expect(item.area, equals(AREA_BEAROFF));
        expect(item.side, equals(1));
        expect(item.height, equals(3));
    });
}
