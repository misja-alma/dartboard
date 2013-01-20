library board;

import 'positionrecord.dart';

abstract class Board {
  void switchTurn();
  
  void draw(PositionRecord position);
  
  void pickUpChecker(int point, int player);
  
  void dropChecker(int point, int player);
}
