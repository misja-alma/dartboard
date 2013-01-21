library boardmode;

import '../boardmap.dart';
import 'bgaction.dart';
import 'editmode.dart';
import 'playmode.dart';
import '../positionrecord.dart';

const String EDIT_MODE = "edit position";
const String PLAY_MODE = "play game";

abstract class BoardMode {
  List<BGAction> interpretMouseClick(PositionRecord position, Item clickedItem);
}

BoardMode getBoardmode(String name) {
  switch(name) {
    case EDIT_MODE: return new EditMode();
    case PLAY_MODE: return new PlayMode();
    default:  throw new Exception("Unknown boardmode: $name");
  }
}

List<String> getAllBoardmodes() {
  return [EDIT_MODE, PLAY_MODE];
}

