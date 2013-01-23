library testutils;

import '../common/positionrecord.dart';

PositionRecord getInitialPositionWithPlayerOnBar() {
  PositionRecord result = new PositionRecord();
  
  result.setNrCheckersOnPoint(0, 6, 5);
  result.setNrCheckersOnPoint(0, 8, 3);
  result.setNrCheckersOnPoint(0, 13, 5);
  result.setNrCheckersOnPoint(0, 24, 1);
  result.setNrCheckersOnPoint(0, 25, 1);
  
  result.setNrCheckersOnPoint(1, 6, 5);
  result.setNrCheckersOnPoint(1, 8, 3);
  result.setNrCheckersOnPoint(1, 13, 5);
  result.setNrCheckersOnPoint(1, 24, 2);
  
  return result;
}