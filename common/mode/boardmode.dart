library boardmode;

import '../boardmap.dart';
import 'boardaction.dart';
import 'editmode.dart';
import 'playmode.dart';
import '../positionrecord.dart';

const String EDIT_MODE = "edit position";
const String PLAY_MODE = "play game";

abstract class Boardmode {
  Boardaction interpretMouseClick(Positionrecord position, Item clickedItem);
}

Boardmode getBoardmode(String name) {
  switch(name) {
    case EDIT_MODE: return new Editmode();
    case PLAY_MODE: return new Playmode();
    default:  throw new Exception("Unknown boardmode: $name");
  }
}

List<String> getAllBoardmodes() {
  return [EDIT_MODE, PLAY_MODE];
}

