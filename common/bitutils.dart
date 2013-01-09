library bitutils;

import 'dart:math';

void setBit(List<int> byteStr, int index, int bitPos, int value){
  int mask = pow(2, bitPos);
  if (value == 1) {
      byteStr[index] = (byteStr[index] | mask);
  } else {
      byteStr[index] = (byteStr[index] & (~ mask));
  }
}

/**
 * Note: bitString[0] is the least important bit.
 *
 * @param bitString[]
 * @param start the position at which the substring starts
 * @param end the first bit that is not part of the substring anymore; end > start
 * @return the accumulated value of the bitRange
 */
int bitSubString(List<int> bitString, int start, int end){
  int result = bitString[--end];
  while (start < end) {
      result = 2 * result + bitString[--end];
  }
  return result;
}

/**
 * Fills the bitstring with the contents of the value; only the bits that fit between start and end are copied.
 * 
 * @param end the first bit that is not part of the substring anymore; end > start
 */
void putIntoBitString(List<int> bitString, int value, int start, int end){
  int pos = start;
  int mask = 1;
  while (pos < end) {
      bitString[pos] = (value & mask) ~/ mask;
      mask = mask * 2;
      pos++;
  }
}
