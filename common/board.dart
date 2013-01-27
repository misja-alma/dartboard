library board;

import 'position.dart';

abstract class Board {
  void switchTurn();
  
  void draw(PositionRecord position);
  
  void checkerPlayed(int player, int from, int to);
  
  void rolled(int die1, int die2);
}
