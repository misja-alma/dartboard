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
  drawFromPositionId();
}

void initListeners() {
  Element positionId = query("#positionId");  
  positionId.on.blur.add((e) => drawFromPositionId());
  positionId.on.keyPress.add((e) => keyPressedInPositionId(e));
  Element direction = query("#direction");
  direction.on.click.add((e) => drawFromPositionId());
}

void drawFromPositionId(){
  Element direction = query("#direction");
  BoardController board = getBoard("bgboard");
  board.setDirection(direction.checked);
  
  String selectedIdType = getSelectedIdType();
  Positionrecord position = convertIdToPosition(selectedIdType);
  board.draw(position);
}

void showPositionId(String selectedIdType, Positionrecord position) {
  if(selectedIdType == "XG") {
    showXgId(position);
  } else {
    showGnuId(position);
  }
}

Positionrecord convertIdToPosition(String selectedIdType) {
  String positionId = query("#positionId").value;
  if (positionId.isEmpty) {
    Positionrecord position = new Positionrecord.initialPosition();
    showPositionId(getSelectedIdType(), position);
    return position;
  } else {
    if(selectedIdType == "XG") { 
      return xgIdToPosition(positionId);
    } else {
      return gnuIdToPosition(positionId.substring(0, 14), positionId.substring(14, positionId.length));
    }
  }
}

String getSelectedIdType() {
  var ids = queryAll("[name=idType]"); // TODO normal selector by name doesnt work?
  Element selectedType = ids.filter((e) => e.checked).iterator().next(); // TODO is there no find?
  return selectedType.value;
}

void showGnuId(Positionrecord position) {
  Element txtGnuId = query("#positionId");
  String positionId = getPositionId(position);
  String matchId = getMatchId(position);
  txtGnuId.value = "${positionId}${matchId}";
}

void showXgId(Positionrecord position) {
  Element txtXgId = query("#positionId");
  //txtXgId.value = "${getXgId(position)}}"; TODO implement
}

bool keyPressedInPositionId(KeyboardEvent event) { 
  if (event.keyCode == 13) {
    drawFromPositionId();
    return false;
  } else {
    return true;
  }
}
