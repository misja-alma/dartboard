part of position;

// tables used by match- and positionId code
const String base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
final List<int> positions = [2, 3, 4, 5, 6, 7, 12, 13, 14, 15, 0, 1, 22, 23, 8, 9, 10, 11, 16, 17, 18, 19, 20, 21];  

List<int> base64ToBits(String s, int length){
  // first transform the match id into a bit array
  List<int> bits = new List(88);
  List<int> bytes = stringToBytes(s);
  
  for (int c = 0; c < (s.length / 4 + 1); c++) { // take 4 characters at a time; they will become 3 bytes
    for (int b = 0; b < 4; b++) {
      int index = c * 4 + b;
      if (index >= bytes.length) {
        break;
      }
      
      int ch = base64.indexOf(new String.fromCharCodes([bytes[index]])); // remove 'base 64' encoding 
      int mask = 1;
      // every character represents 6 bits.      
      for (int bit = 0; (bit < 6); bit++) {
        // find the position at which this bit will be located
        int pos = c * 24 + positions[b * 6 + bit];
        bits[pos] = (ch & mask) ~/ mask;
        mask = mask * 2; // ready for the next bit
      }
    }
  }
  return bits;
}

String makeBase64String(List<int> bitString, int length){
  List<int> result = new List(length);
  for(int i=0; i<length; i++) { 
    result[i] = 0;
  }
  
  //  move every bit to its place
  int pos = 0;
  for (int c = 0; c < 4; c++) {
    for (int d = 0; d < 24; d++) {
      int bitIndex = 24 * c + d;
      if (bitIndex < bitString.length) { // we can have more bytes than there are bits.             
        int bit = bitString[bitIndex];
        int bitPos = positions.indexOf(d);
        int bytePos = bitPos ~/ 6;
        setBit(result, c * 4 + bytePos, bitPos % 6, bit);
      }
    }
  }
  
  // base 64 encoding
  List<int> res = [];
  for (int i = 0; i < result.length; i++) {
    res.add(base64.charCodeAt(result[i]));
  }
  return new String.fromCharCodes(res);
}
