part of position;

int invertPlayer(int player) {
  return player ^ 1;
}

int invertDecisionTurn(int turn) {
  return turn ^ 1;
}

int convertMyPointForPlayerOnRoll(int point, int player) {
  if(player == 0 || point == 0 || point == 25) {
    return point;
  }
  return 25 - point;
}

int getFurthestChecker(int player, PositionRecord position) {
  for(int i=25; i>0; i--) {
    if(position.getNrCheckersOnPoint(player, i) > 0) {
      return i;
    }
  }
  return 0;
}
