library die;

import '../common/boardmap.dart';
import '../common/position.dart';
import 'canvasutils.dart';
import "dart:html";
import 'dart:math';


final List<List<List<int>>> pipCoordinates = [
      [[50, 50]],
      [[25, 25],[75, 75]],
      [[25, 25],[50,50],[75,75]],
      [[25, 25],[75,25],[75,75],[25,75]],
      [[25, 25],[75,25],[75,75],[25,75],[50,50]],
      [[25, 25],[75,25],[75,75],[25,75],[25,50],[75,50]]
  ];

class Die {
  int pips;
  
  Die(int pips) {
    this.pips = pips;
  }

  void draw(CanvasRenderingContext2D context, BoardMap boardMap, Area diceArea, int dieIndex) {
    if(pips == DIE_NONE) {
      return;
    }
    Area dieArea = boardMap.getDieArea(diceArea, dieIndex);
    fillRoundedRect(context, dieArea, dieArea.width / 8, "#FFFFFF");
    
    double radius = dieArea.width / 24;
    List<List<int>> coordinatesForPips = pipCoordinates[pips-1];
    for(var i=0; i<coordinatesForPips.length; i++) {
      List<int> xy = coordinatesForPips[i];
      var x = xy[0] * dieArea.width / 100 + dieArea.x;
      var y = xy[1] * dieArea.height / 100 + dieArea.y;
      this.drawPip(context, x, y, radius, "#000000");
    }
  }

  void drawPip(CanvasRenderingContext2D context, double x,  double y, double radius, String color) {
    context.beginPath();
    context.arc(x, y, radius, 0, PI * 2, false);
    context.closePath();
    context.fillStyle = color;
    context.stroke();
    context.fill();
  }
}
