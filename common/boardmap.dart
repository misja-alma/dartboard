library boardmap;

const String AREA_BAR = "BAR";
const String AREA_TURN = "TURN";
const String AREA_CHECKER = "CHECKER";
const String AREA_DICE = "DICE";
const String AREA_CUBE = "CUBE";
const String AREA_BEAROFF = "BEAROFF";
const String AREA_UNDO = "UNDO";

const String CUBELOCATION_OWNED = "CUBE_OWNED";
const String CUBELOCATION_MIDDLE = "CUBE_MIDDLE";
const String CUBELOCATION_OFFERED = "CUBE_OFFERED";

class Item {
  String area;
  String location;
  int side;
  int index;
  int height;
  
  Item clone() {
    Item newItem = new Item();
    newItem.area = this.area;
    newItem.location = this.location;
    newItem.side = this.side;
    newItem.index = this.index;
    newItem.height = this.height;
    
    return newItem;
  }
}

class Area {
  double x;
  double y;
  double width;
  double height;
    
  bool contains(num x, num y){
    if (x >= this.x && x < this.x + this.width) {
        if (y >= this.y && y < this.y + this.height) {
            return true;
        }
    }
    return false;
  }
  
  Area clone(){
    Area newArea = new Area();
    newArea.x = this.x;
    newArea.y = this.y;
    newArea.width = this.width;
    newArea.height = this.height;
    
    return newArea;
  }
}


// There are 2 kinds of area's: the area's where an item Could be drawn, and the area where it Is drawn.
//      The BoardMap defines the wider area's; the implementations can use insets to define real outlines.
//      However for reverse mapping, i.e. when the mouse has been clicked, the wider area's will be used.
//      Use area objects for all of the area's.
//      Finally: Some 'meta area's' exist, like the 'bear off area'. This is still subdivided into little
//      area's for every born off checker, however these have to be calculated on the fly; one reason is 
//      that multiple checkers could occupy the same place.
// BoardMap always assumes that 'me' is playing at the bottom and 'opp' at the top.
class BoardMap {
  double x;
  double y;
  double width;
  double height;
  bool isHomeBoardLeft;
  double pointNumberHeight;
  double bearOffMarginWidth;
  double cubeMarginWidth;
  Area board;
  Area bar;
  double pointWidth;
  double checkerRadius;
  double pointHeight;
  Area arrowMyTurn;
  Area arrowOppTurn;
  Area zeroPointMe;
  Area zeroPointOpp;
  double zeroPointCheckerHeight;
  Area barMe;
  Area barOpp;
  Area diceMe;
  Area diceOpp;
  Area cubeMe;
  Area cubeOpp;
  Area cubeMiddle;
  Area cubeOfferedByMe;
  Area cubeOfferedByOpp;
  Area undo;
  
  BoardMap(double boardX, double boardY, double boardWidth, double boardHeight, bool isHomeBoardLeft){
    x = boardX;
    y = boardY;
    width = boardWidth;
    height = boardHeight;
    
    this.isHomeBoardLeft = isHomeBoardLeft;
    pointNumberHeight = height / 14;
    bearOffMarginWidth = width / 14;
    cubeMarginWidth = width / 8;
    
    board = new Area();
    if (isHomeBoardLeft) {
      board.x = x + bearOffMarginWidth;
    } else {
      board.x = x; // + cubeMarginWidth;
    }
    board.y = y + pointNumberHeight;
    board.width = width - bearOffMarginWidth - cubeMarginWidth;
    board.height = height - 2 * pointNumberHeight;
    
    bar = new Area();
    bar.width = getBarWidth(board.width);
    bar.height = board.height;
    bar.x = board.x + board.width / 2 - bar.width / 2;
    bar.y = board.y;
    
    pointWidth = getPointWidth(board.width);
    checkerRadius = (pointWidth / 2.2);
    pointHeight = checkerRadius * 10;
    
    arrowMyTurn = new Area();
    arrowOppTurn = new Area();
    
    double arrowWidth = cubeMarginWidth - 2;
    double arrowHeight = board.height / 5;
    double arrowX = board.x + board.width + 1; //isHomeBoardLeft ? board.x + board.width + 1 : x + 1;
    
    arrowMyTurn.x = arrowX;
    arrowMyTurn.y = board.y + (board.height * 3) / 5;
    arrowMyTurn.width = arrowWidth;
    arrowMyTurn.height = arrowHeight;
    
    arrowOppTurn.x = arrowX;
    arrowOppTurn.y = board.y + board.height / 5;
    arrowOppTurn.width = arrowWidth;
    arrowOppTurn.height = arrowHeight;
    
    zeroPointMe = new Area();
    zeroPointOpp = new Area();
    
    double zeroPointX = isHomeBoardLeft ? x : board.x + board.width + 1;
    zeroPointCheckerHeight = checkerRadius / 2;
    
    zeroPointOpp.y = board.y;
    zeroPointOpp.x = zeroPointX;
    zeroPointOpp.width = pointWidth;
    zeroPointOpp.height = pointHeight;
    
    zeroPointMe.y = board.y + board.height - checkerRadius * 2;
    zeroPointMe.x = zeroPointX;
    zeroPointMe.width = pointWidth;
    zeroPointMe.height = pointHeight;
    
    double barCheckerX = bar.x + 1;
    
    barMe = new Area();
    barOpp = new Area();
    
    barMe.x = barCheckerX;
    barMe.y = board.y + board.height - checkerRadius * 10;
    barMe.width = bar.width - 2;
    barMe.height = pointHeight;
    
    barOpp.x = barCheckerX;
    barOpp.y = board.y + checkerRadius * 8;
    barOpp.width = bar.width - 2;
    barOpp.height = pointHeight;
    
    diceMe = new Area();
    diceOpp = new Area();
    double diceY = board.y + pointHeight;
    double diceWidth = 6 * pointWidth;
    double diceHeight = board.height - 2 * pointHeight;
    
    // Dice and cube don't care about isHomeBoardLeft ..
    diceMe.x = bar.x + bar.width;
    diceOpp.x = board.x;  
    diceMe.y = diceY;
    diceMe.width = diceWidth;
    diceMe.height = diceHeight;
    diceOpp.y = diceY;
    diceOpp.width = diceWidth;
    diceOpp.height = diceHeight; 
    // what about first and second die?  
    
    cubeMe = new Area();
    cubeOpp = new Area();
    cubeMiddle = new Area(); 
    cubeOfferedByMe = new Area();
    cubeOfferedByOpp = new Area();
  
    double cubeHeight = cubeMarginWidth; 
    double cubeX = isHomeBoardLeft ? board.x + board.width + 1: x + 1; 
    cubeMe.width = cubeHeight;
    cubeMe.height = cubeHeight;
    cubeMe.x = cubeX;
    cubeMe.y = board.y + board.height - cubeHeight;
    
    cubeOpp.width = cubeHeight;
    cubeOpp.height = cubeHeight;
    cubeOpp.x = cubeX;
    cubeOpp.y = board.y;
    
    cubeMiddle.width = cubeHeight;
    cubeMiddle.height = cubeHeight;
    cubeMiddle.x = cubeX;
    cubeMiddle.y = board.y + pointHeight;
    
    cubeOfferedByMe.width = cubeHeight;
    cubeOfferedByMe.height = cubeHeight;
    cubeOfferedByMe.x = bar.x + bar.width + 2 * pointWidth;
    cubeOfferedByMe.y = board.y + pointHeight;
    
    cubeOfferedByOpp.width = cubeHeight;
    cubeOfferedByOpp.height = cubeHeight;
    cubeOfferedByOpp.x = board.x + 2 * pointWidth;
    cubeOfferedByOpp.y = board.y + pointHeight;
    
    undo = new Area();
    undo.width = arrowWidth; // TODO: give own field?
    undo.height = arrowHeight;
    undo.x = arrowX;
    undo.y = board.y;
  }


  // Locates the checker from player 'me'-'s perspective
  bool locateChecker(Item item, num x, num y){
      for (int index = 1; index <= 24; index++) {
          Area point = this.getPointArea(index, false);
          if (point.contains(x, y)) {
              item.area = AREA_CHECKER;
              item.side = 0;
              item.index = index;
              if (index <= 12) {
                  item.height = (((point.y + point.height - y) / (2 * this.checkerRadius))).toInt() + 1;
              }
              else {
                  item.height = (((y - point.y) / (2 * this.checkerRadius))).toInt() + 1;
              }
              return true;
          }
      }
      return false;
  }

  bool locateCube(Item item, num x, num y){
    if(this.cubeMe.contains(x, y)) {
      item.area = AREA_CUBE;
      item.side = 0;
      item.location = CUBELOCATION_OWNED;
      return true;
    }
    if(this.cubeMiddle.contains(x, y)) {
      item.area = AREA_CUBE;
      item.location = CUBELOCATION_MIDDLE;
      return true;
    }
    if(this.cubeOpp.contains(x, y)) {
      item.area = AREA_CUBE;
      item.side = 1;
      item.location = CUBELOCATION_OWNED;
      return true;
    }
    if(this.cubeOfferedByMe.contains(x, y)) {
      item.area = AREA_CUBE;
      item.side = 0;
      item.location = CUBELOCATION_OFFERED;
      return true;
    }
    if(this.cubeOfferedByOpp.contains(x, y)) {
      item.area = AREA_CUBE;
      item.side = 1;
      item.location = CUBELOCATION_OFFERED;
      return true;
    }
    return false;
  }

  bool locateDice(Item item, num x, num y){
      if (this.diceMe.contains(x, y)) {
          item.area = AREA_DICE;
          item.side = 0;
          return true;
      }
      if (this.diceOpp.contains(x, y)) {
          item.area = AREA_DICE;
          item.side = 1;
          return true;
      }
      return false;
  }

  bool locateBearOff(Item item, num x, num y){
      if (this.zeroPointMe.contains(x, y)) {
          item.area = AREA_BEAROFF;
          item.side = 0;
          double bearOffMeTop = this.zeroPointMe.y + this.zeroPointMe.height;
          item.height = (((bearOffMeTop - y) / this.zeroPointCheckerHeight)).toInt() + 1;
          return true;
      }
      if (this.zeroPointOpp.contains(x, y)) {
          item.area = AREA_BEAROFF;
          item.side = 1;
          item.height = (((y - this.zeroPointOpp.y) / this.zeroPointCheckerHeight)).toInt() + 1;
          return true;
      }
      return false;
  }

  bool locateBar(Item item, num x, num y){
      // Counting of the height starts from the middle of the bar
      if (this.barMe.contains(x, y)) {
          item.area = AREA_BAR;
          item.side = 0;
          item.height = (((y - this.barMe.y) / this.checkerRadius)).toInt() + 1;
          return true;
      }
      if (this.barOpp.contains(x, y)) {
          item.area = AREA_BAR;
          item.side = 1;
          double barOppTop = this.barOpp.y + this.barOpp.height - 1;
          item.height = (((barOppTop - y) / this.checkerRadius)).toInt() + 1;
          return true;
      }
      return false;
  }

  bool locateTurn(Item item, num x, num y){
      if (this.arrowMyTurn.contains(x, y)) {
          item.area = AREA_TURN;
          item.side = 0;
          return true;
      }
      if (this.arrowOppTurn.contains(x, y)) {
          item.area = AREA_TURN;
          item.side = 1;
          return true;
      }
      return false;
  }
  
  bool locateUndo(Item item, num x, num y){
    if (this.undo.contains(x, y)) {
      item.area = AREA_UNDO;
      return true;
    }
    return false;
  }

  // Returns the outer-rectangle starting at the topleftcorner of the checker; includes the checker + its insets
  Area getCheckerRectangle(int index, int indexOnPoint, bool isHomeBoardUp){
      Area rec = this.getPointArea(index, isHomeBoardUp);
      rec.height = this.checkerRadius * 2;
      
      if (index == 0) {
          if (isHomeBoardUp) {
              rec.y = rec.y + this.zeroPointCheckerHeight * (indexOnPoint - 1);
          }
          else {
              rec.y = rec.y - this.zeroPointCheckerHeight * (indexOnPoint - 1);
          }
          return rec;
      }
      
      int cappedPointIndex = indexOnPoint > 5 ? 5 : indexOnPoint;
      
      if (index == 25) {
          if (isHomeBoardUp) {
              rec.y = rec.y - 2 * this.checkerRadius * (cappedPointIndex - 1);
          }
          else {
              rec.y = rec.y + 2 * this.checkerRadius * (cappedPointIndex - 1);
          }
          return rec;
      }
      
      double heightOnPoint = (cappedPointIndex - 1) * rec.height;
      if (isHomeBoardUp) {
          if (index <= 12) {
              rec.y = rec.y + heightOnPoint;
          }
          else {
              rec.y = rec.y + this.pointHeight - heightOnPoint - rec.height;
          }
      }
      else {
          if (index <= 12) {
              rec.y = rec.y + this.pointHeight - heightOnPoint - rec.height;
          }
          else {
              rec.y = rec.y + heightOnPoint;
          }
      }
      return rec;
  }
  
  Area getDieArea(Area diceArea, int dieIndex) {
    double dieWidth = diceArea.height * 0.6;
    double spaceBetweenDice = dieWidth / 4;
    double dieXInset = (diceArea.width - 2 * dieWidth - spaceBetweenDice) / 2;
    Area dieArea = new Area();
    dieArea.x = diceArea.x + dieXInset;
    if(dieIndex == 2) {
      dieArea.x += dieWidth + spaceBetweenDice;
    }
    dieArea.y = diceArea.y + (diceArea.height - dieWidth) / 2;
    dieArea.width = dieWidth;
    dieArea.height = dieWidth;
    return dieArea;
  }

  Area getPointArea(int index, bool isHomeBoardUp){
      Area rec;
      
      if (index == 0) {
          if (isHomeBoardUp) {
              rec = this.zeroPointOpp.clone();
          }
          else {
              rec = this.zeroPointMe.clone();
          }
          return rec;
      }
      
      if (index == 25) {
          if (isHomeBoardUp) {
              rec = this.barOpp.clone();
          }
          else {
              rec = this.barMe.clone();
          }
          return rec;
      }
      
      rec = new Area();
      rec.width = this.pointWidth;
      rec.height = this.pointHeight;
      int pointsFromLeft;
      if (this.isHomeBoardLeft) {
          if (index <= 12) {
              pointsFromLeft = index - 1;
          }
          else {
              pointsFromLeft = (24 - index);
          }
      }
      else {
          if (index <= 12) {
              pointsFromLeft = 12 - index;
          }
          else {
              pointsFromLeft = index - 13;
          }
      }
      rec.x = this.board.x + pointsFromLeft * rec.width;
      if (pointsFromLeft > 5) {
          rec.x += this.bar.width;
      }
      // determine y coordinate
      rec.y = this.board.y;
      if (isHomeBoardUp) {
          if (index > 12) {
              rec.y += this.board.height - this.pointHeight;
          }
      }
      else {
          if (index <= 12) {
              rec.y += this.board.height - this.pointHeight;
          }
      }
      
      return rec;
  }

  double getPointWidth(double boardWidth){
      double barWidth = this.getBarWidth(boardWidth);
      double pointWidth = (boardWidth - barWidth) / 12;
      return pointWidth;
  }
  
  double getBarWidth(double boardWidth){
      double barWidth = boardWidth / 12;
      return barWidth;
  }

  Item locateItem(num x, num y){
      Item item = new Item();
      
      if (locateChecker(item, x, y)) {
          return item;
      }
      
      if (locateCube(item, x, y)) {
          return item;
      }
      
      if (locateDice(item, x, y)) {
          return item;
      }
      
      if (locateBearOff(item, x, y)) {
          return item;
      }
      
      if (locateBar(item, x, y)) {
          return item;
      }
      
      if (locateTurn(item, x, y)) {
          return item;
      }
      
      if (locateUndo(item, x, y)) {
        return item;
      }
      return item;
  }
}
