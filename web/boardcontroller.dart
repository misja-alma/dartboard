library boardcontroller;

import '../common/positionrecord.dart';
import '../common/board.dart';
import '../common/boardmap.dart';
import '../common/positionconverter.dart';
import '../common/mode/bgaction.dart';
import '../common/mode/boardmode.dart';
import '../common/mode/editmode.dart';
import '../common/stringutils.dart';
import 'canvasutils.dart';
import 'bgboard.dart';
import "dart:html";

BoardController controller;

void main() {
  controller = new BoardController();
  controller.initListeners();
  controller.setBoardDimensions();
}

/// Methods Referenced from Html /////
void modeSelected(Event event) {
  controller.modeSelected(event);
}

List<String> getBoardmodes() {
  return getAllBoardmodes();
}

class BoardController implements Board {
  
BgBoard bgBoard;
BoardMap boardMap;
bool isHomeBoardLeft;
String boardElementName;
CanvasElement board;
PositionRecord currentPosition;
BoardMode currentBoardmode;
  
  initBoard(String boardName) {
    currentBoardmode = getBoardmode(EDIT_MODE);
    bgBoard = new BgBoard();
    isHomeBoardLeft = true;
    boardElementName = boardName;
    board = query("#${boardName}");
    board.on.click.add(boardClicked);
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
    InputElement direction = query("#direction");
    setDirection(direction.checked);
    
    String selectedIdType = getSelectedIdType();
    PositionRecord position = convertIdToPosition(selectedIdType);
    draw(position);
  }
  
  void showPositionId(String selectedIdType, PositionRecord position) {
    if(selectedIdType == "XG") {
      showXgId(position);
    } else {
      showGnuId(position);
    }
  }
  
  void modeSelected(Event event) {
    SelectElement select = event.target;
    print("Switching to ${select.value} mode");
    currentBoardmode = getBoardmode(select.value);
  }
  
  PositionRecord convertIdToPosition(String selectedIdType) {
    String positionId = (query("#positionId") as InputElement).value;
    if (positionId.isEmpty) {
      PositionRecord position = new PositionRecord.initialPosition();
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
    List<InputElement> ids = queryAll("[name=idType]"); // TODO normal selector by name doesnt work?
    InputElement selectedType = ids.filter((e) => e.checked).iterator().next(); // TODO is there no find?
    return selectedType.value;
  }
  
  void showGnuId(PositionRecord position) {
    InputElement txtGnuId = query("#positionId");
    String positionId = getPositionId(position);
    String matchId = getMatchId(position);
    txtGnuId.value = "${positionId}${matchId}";
  }
  
  void showXgId(PositionRecord position) {
    InputElement txtXgId = query("#positionId");
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
  
  void setDirection(bool shouldHomeBoardBeLeft){
    isHomeBoardLeft = shouldHomeBoardBeLeft;
  }
  
  void switchTurn(){
    draw(currentPosition);
  }
  
  void checkerPlayed() {
    draw(currentPosition);
  }  
  
  void rolled() {
    draw(currentPosition);
  }
  
  void handleClick(num x, num y){
    Item item = boardMap.locateItem(x, y);
    List<BGAction> actions = currentBoardmode.interpretMouseClick(currentPosition, item);
    actions.forEach((action) => action.execute(this));
  }
  
  void boardClicked(MouseEvent event){
    Point positionInBoard = getRelativePosition(event, board);
    handleClick(positionInBoard.x, positionInBoard.y);
  }
  
  void draw(PositionRecord position){
    currentPosition = position;
    if(bgBoard == null) {
      initBoard("bgboard");
    }
    CanvasRenderingContext2D context = board.getContext("2d");
    boardMap = new BoardMap(0.0, 0.0, 500.0, 400.0, isHomeBoardLeft);
    bgBoard.drawPosition(context, position, boardMap);
  }
  
  String getGnuId(position){
    return "Position ID: ${position.getPositionId()} Match ID: ${position.getMatchId()}";
  }
}


