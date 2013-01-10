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
