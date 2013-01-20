library editmode;

import 'boardmode.dart';
import 'boardaction.dart';
import '../boardmap.dart';
import '../positionrecord.dart';

class EditMode extends BoardMode {
  List<BoardAction> interpretMouseClick(PositionRecord position, Item clickedItem) {
    if (clickedItem.area == AREA_TURN) {
      return [new SwitchTurnAction()];
    } 
    
    return [];
  }
}
