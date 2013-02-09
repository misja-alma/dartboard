library boardcontroller;

import '../common/position.dart';
import '../common/board.dart';
import '../common/boardmap.dart';
import '../common/mode/bgaction.dart';
import '../common/mode/boardmode.dart';
import '../common/mode/editmode.dart';
import '../common/listutils.dart';
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
List<BGAction> lastActions;

  initBoard(String boardName) {
    currentBoardmode = getBoardmode(EDIT_MODE);
    bgBoard = new BgBoard();
    isHomeBoardLeft = true;
    boardElementName = boardName;
    board = query("#${boardName}");
    board.onClick.listen((event) => boardClicked(event));
  }
  
  void setBoardDimensions() {
    CanvasElement board = query("#bgboard");
    // HtmlCanvas ignores the css width and height but takes the html attributes instead.
    // So we have so set them ourselves, using the following callback.
    CssStyleDeclaration style = board.getComputedStyle();
    setDimensionsFromStyle(board, style);
  }
  
  void setDimensionsFromStyle(CanvasElement board, CssStyleDeclaration style) {
    board.width = forceParseInt(style.width);
    board.height = forceParseInt(style.height);
    drawFromPositionId();
  }
  
  void initListeners() {
    Element positionId = query("#positionId");  
    positionId.onBlur.listen((e) => drawFromPositionId());
    positionId.onKeyPress.listen((e) => keyPressedInPositionId(e));
    Element direction = query("#direction");
    direction.onClick.listen((e) => drawFromPositionId());
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
    InputElement selectedType = ids.where((e) => e.checked).first; // TODO is there no find? Check if this works!
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
  
  void checkerPlayed(int player, int from, int to) {
    draw(currentPosition);
  }  
  
  void rolled(int die1, int die2) {
    draw(currentPosition);
  }
  
  void handleClick(num x, num y){
    Item item = boardMap.locateItem(x, y);
    if(item.area == AREA_UNDO) {
      if(lastActions != null) {
        lastActions.forEach((action) => action.undo(this));
      }
    } else {
      List<BGAction> actions = currentBoardmode.interpretMouseClick(currentPosition, item);
      actions.forEach((action) => action.execute(this));
      lastActions = actions;
    }
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


