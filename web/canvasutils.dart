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
  num x, y;

  if (event.page.x > 0 || event.page.y > 0) {
      x = event.page.x;
      y = event.page.y;
  }
  else {
      x = event.client.x + document.body.scrollLeft + document.documentElement.scrollLeft;
      y = event.client.y + document.body.scrollTop + document.documentElement.scrollTop;
  }
  Point absPosition = getAbsPosition(element);
  x -= absPosition.x;
  y -= absPosition.y;
  return new Point(x, y);
}

// Calculates the object's absolute position
Point getAbsPosition(Element object){ 
  num x, y;
  
  if (object != null) {
      x = object.offset.left;
      y = object.offset.top;
      
      if (object.offsetParent != null) {
          Point parentpos = getAbsPosition(object.offsetParent);
          x += parentpos.x;
          y += parentpos.y;
      }
  } else {
    x = 0;
    y = 0;
  }
  
  return new Point(x, y);
}
