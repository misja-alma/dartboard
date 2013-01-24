library dice;

import 'dart:math';
import 'position.dart';
import 'listutils.dart';

class Dice {
  Random random = new Random();
  
  List<int> roll() {
    List<int> result = [rollDie(), rollDie()];
    sortDescending(result);
    return result;
  }
  
  int rollDie() {
    return random.nextInt(6) + 1;
  }
}

List<int> expandDoubles(List<int> dicel) {
  if(dicel[0] == dicel[1]) {
    return [dicel[0], dicel[1], dicel[0], dicel[1]];
  }
  return new List.from(dicel);
}

List<int> getDiceAsList(int die1, int die2) {
  List<int> result = [];
  if(die1 == die2) {
    addDie(result, die1);
    addDie(result, die1);
    addDie(result, die1);
    addDie(result, die1);
  } else {
    addDie(result, die1);
    addDie(result, die2);
  }
  return result;
}

addDie(List<int> dice, int die) {
  if(die != DIE_NONE) {
    dice.add(die);
  }
}
