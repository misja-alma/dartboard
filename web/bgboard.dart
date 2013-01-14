library bgboard;

import '../common/boardmap.dart';
import '../common/positionrecord.dart';
import 'canvasutils.dart';
import 'die.dart';
import "dart:html";
import 'dart:math';

class BgBoard {
  ImageElement pointPattern;
  String myCheckerColor;
  String oppCheckerColor;
  
  BgBoard() {
    this.pointPattern = new ImageElement(); 
    this.pointPattern.src = "images/wood.jpg"; // TODO the webui compiler doesn't recognize this path .. So we have to copy the images to the out dir.
    this.myCheckerColor = "#FFFF00";
    this.oppCheckerColor = "#00FFFF"; 
  }

  void setPointPatternImage(pointPatternImage) {
    this.pointPattern = pointPatternImage;
  }
  
  void setMyCheckerColor(color) {
    this.myCheckerColor = color;
  }
  
  void setOppCheckerColor(color) {
    this.oppCheckerColor = color;
  }

  // myCheckers and oppCheckers contain the nr's of checkers for each player on each point on the board. Points are numbered from the player's own orientation
  void drawPosition(CanvasRenderingContext2D context, PositionRecord position, BoardMap boardMap){  
    if(!pointPattern.complete) {
      pointPattern.on.load.add((e) => doDrawPosition(context, position, boardMap));  
    } else {
      doDrawPosition(context, position, boardMap);
    }
  }
  
  void doDrawPosition(CanvasRenderingContext2D context, PositionRecord position, BoardMap boardMap){ 
    this.drawBoard(context, boardMap);
    
    List<int> myCheckers = position.checkers[0];
    List<int> oppCheckers = position.checkers[1];
    bool isItMyTurn = position.decisionTurn == 0;
    
    for (int i = 0; i < myCheckers.length; i++) {
        int myDrawNr = myCheckers[i];
        bool myDrawNrAsText = false;
        if (myDrawNr > 5 && i != 0 && i != 25) {
            myDrawNr = 5;
            myDrawNrAsText = true;
        }
        for (int j = 0; j < myDrawNr; j++) {
            this.drawChecker(context, i, j + 1, false, boardMap, this.myCheckerColor);
        }
        if (myDrawNrAsText) {
            this.drawCheckerTotal(context, i, myCheckers[i], false, boardMap);
        }
    }
    for (int i = 0; i < oppCheckers.length; i++) {
        int myDrawNr = myCheckers[i];
        bool myDrawNrAsText = false;
        if (myDrawNr > 5 && i != 0 && i != 25) {
            myDrawNr = 5;
            myDrawNrAsText = true;
        }
        for (int j = 0; j < oppCheckers[i]; j++) {
            this.drawChecker(context, i, j + 1, true, boardMap, this.oppCheckerColor);
        }
        if (myDrawNrAsText) {
            this.drawCheckerTotal(context, i, myCheckers[i], true, boardMap);
        }
    }
    
    Area arrowX;
    String color;
    if (isItMyTurn) {
        arrowX = boardMap.arrowMyTurn;
        color = this.myCheckerColor;
    }
    else {
        arrowX = boardMap.arrowOppTurn;
        color = this.oppCheckerColor;
    }
    this.drawArrow(context, arrowX, boardMap.isHomeBoardLeft, color);
  
    Area diceArea;
    if(isItMyTurn) {
      diceArea = boardMap.diceMe;
    } else {
      diceArea = boardMap.diceOpp;
    }
    Die die1 = new Die(position.die1);
    die1.draw(context, boardMap, diceArea, 1);
    Die die2 = new Die(position.die2);
    die2.draw(context, boardMap, diceArea, 2);
    
    Area cubeArea;
    // TODO find out/handle the case when cube is offered!
    if(position.cubeOwner == CENTERED_CUBE) {
      cubeArea = boardMap.cubeMiddle;
    } else
    if(position.cubeOwner == 1) {
      cubeArea = boardMap.cubeMe;
    } else {
      cubeArea = boardMap.cubeOpp;
    }
    this.drawCube(context, cubeArea, position.cubeValue);
  }
  
  // index is the bg pointnumber, indexOnPoint starts with 1
  void drawChecker(CanvasRenderingContext2D context, int index, int indexOnPoint, bool isHomeBoardUp, BoardMap boardMap, String color){
    double pointWidth = boardMap.pointWidth;
    double radius = boardMap.checkerRadius;
    double inset = (pointWidth - radius * 2) / 2;
    Area coordinates = boardMap.getCheckerRectangle(index, indexOnPoint, isHomeBoardUp);
    
    context.strokeStyle = "#000";
    context.fillStyle = color;
    context.beginPath();
    context.arc(coordinates.x + radius + inset, coordinates.y + radius, radius, 0, PI * 2, true);
    context.closePath();
    context.stroke();
    context.fill();
  }

  void drawCheckerTotal(CanvasRenderingContext2D context, int index, int total, bool isHomeBoardUp, BoardMap boardMap){
    double pointWidth = boardMap.pointWidth;
    Area coordinates = boardMap.getCheckerRectangle(index, 6, isHomeBoardUp);
    
    context.fillStyle = "#000";
    double textWidth = context.measureText(total.toString()).width;
    double textInset = (pointWidth - textWidth) / 2;
    context.fillText(total.toString(), coordinates.x + textInset, coordinates.y + boardMap.checkerRadius * 1.4);
  }

  void drawBoard(CanvasRenderingContext2D context, BoardMap boardMap){
    context.fillStyle = "#FFFFFF";
    context.fillRect(boardMap.x, boardMap.y, boardMap.width, boardMap.height);
    
    context.fillStyle = "#000000";
    this.drawPointNumbers(context, boardMap);
    
    context.beginPath();
    drawRect(context, boardMap.board);
    this.drawBar(context, boardMap);
    context.closePath();
    context.strokeStyle = "#000";
    context.stroke();
    
    context.beginPath();
    double pointWidth = boardMap.pointWidth;
    for (int i = 0; i < 6; i++) {
        this.drawPoint(context, true, boardMap.board.x, i, boardMap);
    }
    for (int i = 0; i < 6; i++) {
        this.drawPoint(context, true, boardMap.board.x + boardMap.board.width / 2 + boardMap.bar.width / 2, i, boardMap);
    }
    for (int i = 0; i < 6; i++) {
        this.drawPoint(context, false, boardMap.board.x, i, boardMap);
    }
    for (int i = 0; i < 6; i++) {
        this.drawPoint(context, false, boardMap.board.x + boardMap.board.width / 2 + boardMap.bar.width / 2, i, boardMap);
    }
    
    context.closePath();
    context.fillStyle = context.createPattern(this.pointPattern, 'repeat');
    context.strokeStyle = "#000";
    context.stroke();
    context.fill();
  }

  void drawPointNumbers(CanvasRenderingContext2D context, BoardMap boardMap){
    int fontHeight = (boardMap.pointNumberHeight * 0.5).toInt();
    context.font = "bold ${fontHeight}px sans-serif";
    
    int pointNumber;
    int increment;
    if (boardMap.isHomeBoardLeft) {
        pointNumber = 1;
        increment = 1;
    }
    else {
        pointNumber = 12;
        increment = -1;
    }
    double baseLine = boardMap.board.y + boardMap.board.height + boardMap.pointNumberHeight * 0.6;
    double startX = boardMap.board.x;
    this.draw6PointNumbers(context, pointNumber, increment, startX, baseLine, boardMap.pointWidth, true);
    pointNumber += 6 * increment;
    
    startX = boardMap.board.x + boardMap.board.width / 2 + boardMap.bar.width / 2;
    this.draw6PointNumbers(context, pointNumber, increment, startX, baseLine, boardMap.pointWidth, true);
    
    if (boardMap.isHomeBoardLeft) {
        pointNumber = 13;
    }
    else {
        pointNumber = 24;
    }
    
    baseLine = boardMap.board.y - boardMap.pointNumberHeight * 0.25;
    this.draw6PointNumbers(context, pointNumber, increment, startX, baseLine, boardMap.pointWidth, false);
    pointNumber += 6 * increment;
    
    startX = boardMap.board.x;
    this.draw6PointNumbers(context, pointNumber, increment, startX, baseLine, boardMap.pointWidth, false);
  }

  void draw6PointNumbers(CanvasRenderingContext2D context, int pointNumber, int pointNumberIncrement, double startX, double baseLine, double pointWidth, bool fromLeftToRight){
    int start;
    int increment;
    int end;
    if (fromLeftToRight) {
        start = 0;
        end = 5;
        increment = 1;
    }
    else {
        start = 5;
        end = 0;
        increment = -1;
    }
    for (int i = start; i != (end + increment); i += increment) {
        num textWidth = context.measureText(pointNumber.toString()).width;
        double textInset = (pointWidth - textWidth) / 2;
        context.fillText(pointNumber.toString(), startX + i * pointWidth + textInset, baseLine);
        pointNumber += pointNumberIncrement;
    }
  }

  void drawBar(CanvasRenderingContext2D context, BoardMap boardMap){
    context.moveTo(boardMap.bar.x, boardMap.bar.y);
    context.lineTo(boardMap.bar.x, boardMap.bar.y + boardMap.bar.height);
    context.moveTo(boardMap.bar.x + boardMap.bar.width, boardMap.bar.y);
    context.lineTo(boardMap.bar.x + boardMap.bar.width, boardMap.bar.y + boardMap.bar.height);
  }

  void drawPoint(CanvasRenderingContext2D context, bool upwards, double startX, int index, BoardMap boardMap){
    double x = startX + index * boardMap.pointWidth;
    if (upwards) {
        context.moveTo(x, boardMap.board.y);
        context.lineTo(x + boardMap.pointWidth / 2, boardMap.board.y + boardMap.pointHeight);
        context.lineTo(x + boardMap.pointWidth, boardMap.board.y);
    }
    else {
        context.moveTo(x, boardMap.board.y + boardMap.board.height);
        context.lineTo(x + boardMap.pointWidth / 2, boardMap.board.y + boardMap.board.height - boardMap.pointHeight);
        context.lineTo(x + boardMap.pointWidth, boardMap.board.y + boardMap.board.height);
    }
  }

  // the x and y point to the left top corner of the drawing box
  void drawArrow(CanvasRenderingContext2D context, Area arrowArea, bool leftWards, String color){
    int direction = leftWards ? 1 : -1;
    
    double x = arrowArea.x + arrowArea.width * 0.1;
    double y = arrowArea.y + arrowArea.height * 0.25;
    double width = arrowArea.width * 0.8;
    double height = arrowArea.height * 0.5;
    
    y += height / 2;
    if (!leftWards) {
        x += width;
    }
    
    context.beginPath();
    context.moveTo(x, y);
    context.lineTo(x + direction * width / 2, y + height / 2);
    context.lineTo(x + direction * width / 2, y + height / 3);
    context.lineTo(x + direction * width, y + height / 3);
    context.lineTo(x + direction * width, y - height / 3);
    context.lineTo(x + direction * width / 2, y - height / 3);
    context.lineTo(x + direction * width / 2, y - height / 2);
    context.lineTo(x, y);
    context.closePath();
    context.fillStyle = color;
    context.stroke();
    context.fill();
  }

  void drawCube(CanvasRenderingContext2D context, Area cubeArea, int cubeValue) {
    double cubeWidth = cubeArea.width * 0.75;
    double cubeInset = (cubeArea.width - cubeWidth) / 2;
    Area realCubeArea = new Area();
    realCubeArea.x = cubeArea.x + cubeInset;
    realCubeArea.y = cubeArea.y + cubeInset;
    realCubeArea.width = cubeWidth;
    realCubeArea.height = cubeWidth;
    fillRoundedRect(context, realCubeArea, cubeWidth/8, "#FFFFFF");
    
    int fontHeight;
    if(cubeValue < 10) {
      fontHeight = (cubeWidth * 0.5).toInt();
    } else 
    if(cubeValue < 100) {
      fontHeight = (cubeWidth * 0.35).toInt();
    } else {
      fontHeight = (cubeWidth * 0.25).toInt();
    }
    context.font = "bold ${fontHeight}px sans-serif";
    
    num textWidth = context.measureText(cubeValue.toString()).width;
    double horizontalTextInset = (cubeWidth - textWidth) / 2;
    double verticalTextInset = cubeWidth/2 + fontHeight/4;
    context.fillStyle = "#000000";
    context.fillText(cubeValue.toString(), realCubeArea.x + horizontalTextInset, realCubeArea.y + verticalTextInset);
  }
}

