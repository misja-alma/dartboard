part of position;

PlayerWithCheckers decodeXGCharcode(int character) {
  String charString = new String.fromCharCodes([character]);
  PlayerWithCheckers info = new PlayerWithCheckers();
  if (charString == "-") {
      info.player = -1;
      info.nrCheckers = 0;
      return info;
  }
  int ch = base64.indexOf(charString);
  
  if (ch >= 26) {
      info.player = 1;
      info.nrCheckers = ch - 26 + 1;
  }
  else {
      info.player = 0;
      info.nrCheckers = ch + 1;
  }
  return info;
}

class PlayerWithCheckers {
  int player;
  int nrCheckers;
}

/**
 * Parses a string representation of a point into an index within the checkers arrays
 */
int parsePoint(String point){
  if ("bar"==point.toLowerCase()) {
      return 25;
  }
  if ("off"==point.toLowerCase()) {
      return 0;
  }
  else {
      return int.parse(point);
  }
}
