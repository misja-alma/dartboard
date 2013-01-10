import 'dart:html';
import 'bgboard.dart';
import 'boardcontroller.dart';
import '../common/positionrecord.dart';
import '../common/positionconverter.dart';
import '../common/stringutils.dart';

void main() {
  initListeners();
  setBoardDimensions();
}

void setBoardDimensions() {
  CanvasElement board = query("#bgboard");
  // HtmlCanvas ignores the css width and height but takes the html attributes instead.
  // So we have so set them ourselves, using the following callback.
  board.computedStyle.then((style) => setDimensionsFromStyle(board, style));
}

void setDimensionsFromStyle(CanvasElement board, CssStyleDeclaration style) {
  board.width = forceParseInt(style.width);
  board.height = forceParseInt(style.height);
  reDraw();
}

void initListeners() {
  Element positionId = query("#positionId");  
  positionId.on.blur.add((e) => reDraw());
  positionId.on.keyPress.add((e) => keyPressedInPositionId(e));
  Element direction = query("#direction");
  direction.on.click.add((e) => reDraw());
}

void reDraw(){
  Element direction = query("#direction");
  BoardController board = getBoard("bgboard");
  board.setDirection(direction.checked);
  Positionrecord position;
  String positionId = query("#positionId").value;
  if (positionId.isEmpty) {
    position = new Positionrecord.initialPosition();
  } else {
    position = xgIdToPosition(positionId); // TODO parse either xgid, or gnu pos + matchid
  }
  board.draw(position);
  Element txtGnuId = query("#gnuId");
  txtGnuId.value = "${getPositionId(position)}${getMatchId(position)}";
}

bool keyPressedInPositionId(KeyEvent event) { // TODO not tested yet
  if (event.keyCode == 13) {
    reDraw();
    return false;
  } else {
    return true;
  }
}
