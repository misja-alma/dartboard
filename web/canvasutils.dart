library canvasutils;

import '../common/boardmap.dart';
import 'dart:html';

void fillRoundedRect(CanvasRenderingContext2D context, Area area, num cornerRadius, String color){
  context.beginPath();
  context.moveTo(area.x + cornerRadius, area.y);
  context.lineTo(area.x + area.width - cornerRadius, area.y);
  context.quadraticCurveTo(area.x + area.width, area.y, area.x + area.width, area.y + cornerRadius);
  context.lineTo(area.x + area.width, area.y + area.height - cornerRadius);
  context.quadraticCurveTo(area.x + area.width, area.y + area.height, area.x + area.width - cornerRadius, area.y + area.height);
  context.lineTo(area.x + cornerRadius, area.y + area.height);
  context.quadraticCurveTo(area.x, area.y + area.height, area.x, area.y + area.height - cornerRadius);
  context.lineTo(area.x, area.y + cornerRadius);
  context.quadraticCurveTo(area.x, area.y, area.x + cornerRadius, area.y);
  context.closePath();
  context.fillStyle = color;
  context.stroke();
  context.fill();
}

void drawRect(CanvasRenderingContext2D context, Area area){
  context.moveTo(area.x, area.y);
  context.lineTo(area.x + area.width, area.y);
  context.lineTo(area.x + area.width, area.y + area.height);
  context.lineTo(area.x, area.y + area.height);
  context.lineTo(area.x, area.y);
}

Point getRelativePosition(MouseEvent event, Element element) {
  num x;
  num y;
  if (event.pageX > 0 || event.pageY > 0) {
      x = event.pageX;
      y = event.pageY;
  }
  else {
      x = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
      y = event.clientY + document.body.scrollTop + document.documentElement.scrollTop;
  }
  Point absPosition = getAbsPosition(element);
  x -= absPosition.x;
  y -= absPosition.y;
  return new Point(x, y);
}

// Calculates the object's absolute position
Point getAbsPosition(Element object){ 
  Point position = new Point(0, 0);
  
  if (object != null) {
      position.x = object.offsetLeft;
      position.y = object.offsetTop;
      
      if (object.offsetParent != null) {
          Point parentpos = getAbsPosition(object.offsetParent);
          position.x += parentpos.x;
          position.y += parentpos.y;
      }
  }
  
  return position;
}
