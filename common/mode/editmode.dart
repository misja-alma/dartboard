library editmode;

import 'boardmode.dart';
import 'bgaction.dart';
import '../boardmap.dart';
import '../positionrecord.dart';

class EditMode extends BoardMode {
  List<BGAction> interpretMouseClick(PositionRecord position, Item clickedItem) {
    if (clickedItem.area == AREA_TURN) {
      return [new SwitchTurnAction(position)];
    } 
    return [];
  }
}
