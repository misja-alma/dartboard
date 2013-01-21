library positionutils;

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
