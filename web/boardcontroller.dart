library boardcontroller;

import '../common/positionrecord.dart';
import '../common/boardmap.dart';
import '../common/positionconverter.dart';
import 'canvasutils.dart';
import 'bgboard.dart';
import "dart:html";

BoardController theController;

BoardController getBoard(String boardName){
  if (theController == null) {
      theController = new BoardController(boardName);
  }
  return theController;
}

class BoardController {
  BgBoard bgBoard;
  BoardMap boardMap;
  bool isHomeBoardLeft;
  String boardElementName;
  CanvasElement board;
  Positionrecord currentPosition;
  
  BoardController(String boardName) {
    this.bgBoard = new BgBoard();
    this.isHomeBoardLeft = true;
    this.boardElementName = boardName;
    this.board = query("#{$boardName}");
    this.board.addEventListener("click", boardClicked, false);
  }

  void setDirection(bool shouldHomeBoardBeLeft){
    this.isHomeBoardLeft = shouldHomeBoardBeLeft;
  }
  
  void switchTurn(){
    this.currentPosition.switchTurn();
  }
  
  BgBoard getBoard(){
    return this.bgBoard;
  }

  void handleClick (num x, num y){
    var item = this.boardMap.locateItem(x, y);
    if (item.area == AREA_TURN) {
        this.switchTurn();
        this.draw(this.currentPosition);
    }
  }

  void boardClicked(MouseEvent event){
    int x;
    int y;
    if (event.pageX > 0 || event.pageY > 0) { // TODO check if this makes sense
        x = event.pageX;
        y = event.pageY;
    }
    else {
        x = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
        y = event.clientY + document.body.scrollTop + document.documentElement.scrollTop;
    }
    Point absPosition = getAbsPosition(board);
    x -= absPosition.x;
    y -= absPosition.y;
    handleClick(x, y);
  }

  void draw(Positionrecord position){
    this.currentPosition = position;
    CanvasRenderingContext2D context = this.board.getContext("2d");
    this.boardMap = this.bgBoard.drawPosition(context, position, this.isHomeBoardLeft, 0.0, 0.0, 500.0, 400.0);
  }

  Positionrecord parseBgId(String id){
    String posId = parsePositionId(id);
    if (posId != null) {
        String xgId = parseXGId(id);
        return xgIdToPosition(xgId);
    } else {
        String matchId = parseMatchId(id);
        return gnuIdToPosition(posId, matchId);
    }
  }

  String parseXGId(xgId){
    int index = xgId.indexOf("XGID=");
    if (index >= 0) {
        return xgId.substring(index + 5);
    }
    return null;
  }
  
  String parsePositionId(gnuId){
    int index = gnuId.indexOf("Position ID: ");
    if (index >= 0) {
        return gnuId.substring(index + 13);
    }
    return null;
  }
  
  String parseMatchId(gnuId){
    int index = gnuId.indexOf("Match ID: ");
    if (index >= 0) {
        return gnuId.substring(index + 9);
    }
    return null;
  }
  
  String getGnuId(position){
    return "Position ID: {$position.getPositionId()} Match ID: {$position.getMatchId()}";
  }

  // Calculates the object's absolute position
  Point getAbsPosition(Element object){ 
    Point position = new Point(0, 0);
    
    if (object != null) {
        position.x = object.offsetLeft;
        position.y = object.offsetTop;
        
        if (object.offsetParent > 0) {
            Point parentpos = getAbsPosition(object.offsetParent);
            position.x += parentpos.x;
            position.y += parentpos.y;
        }
    }
    
    return position;
  }
}

