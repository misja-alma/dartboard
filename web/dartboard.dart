import 'dart:html';
import 'bgboard.dart';
import 'boardcontroller.dart';
import '../common/positionrecord.dart';
import '../common/positionconverter.dart';

void main() {
  reDraw();
}

void reDraw(){
  var direction = query("#direction");
  BoardController board = getBoard("bgboard");
  board.setDirection(direction.checked);
  //board.getBoard().setPointPatternImage(pointPattern);
  Positionrecord position;
  String positionId = query("#positionId").value;
  if (positionId.isEmpty) {
    position = new Positionrecord.initialPosition();
  } else {
    position = xgIdToPosition(positionId);
  }
  board.draw(position);
  var txtGnuId = query("#gnuId");
  txtGnuId.value = "{$getPositionId(position)}{$getMatchId(position)}";
}
