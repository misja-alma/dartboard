library editmode;

import 'boardmode.dart';
import 'boardaction.dart';
import '../boardmap.dart';
import '../positionrecord.dart';

class Editmode extends Boardmode {
  Boardaction interpretMouseClick(Positionrecord position, Item clickedItem) {
    if (clickedItem.area == AREA_TURN) {
      return new SwitchTurnAction();
    } else {
      return new NoAction();
    }
  }
}
