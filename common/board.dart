library board;

import 'position.dart';

abstract class Board {
  void switchTurn();
  
  void draw(PositionRecord position);
  
  void checkerPlayed();
  
  void rolled();
}
