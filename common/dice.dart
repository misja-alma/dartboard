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
  
  List<int> rollOpening() {
    int die1 = rollDie();
    int die2 = rollDieNot(die1);
    List<int> result = [die1, die2];
    return result;
  }
  
  int rollDie() {
    return random.nextInt(6) + 1;
  }
  
  int rollDieNot(int die) {
    int semiDie = random.nextInt(5) + 1;
    if(semiDie >= die) {
      semiDie++;
    }
    return semiDie;
  }
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
