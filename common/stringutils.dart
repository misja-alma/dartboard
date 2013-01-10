library stringutils;

List<int> stringToBytes(str){
  List<int> re = [];
  for (int i = 0; i < str.length; i++) {
      int ch = str.charCodeAt(i); // get char 
      List<int> st = []; // set up "stack"
      do {
          st.add(ch & 0xFF); // push byte to stack
          ch = ch >> 8; // shift value down by 1 byte
      }
      while (ch != 0);
      // add stack contents to result
      // done because chars have "wrong" endianness
      re.addAll(reverse(st));
  }
  // return an array of bytes
  return re;
}
  
 List<int> reverse(List<int> list) {
   List<int> result = [];
   for (int i = list.length - 1; i >= 0; i--) {
     result.add(list[i]);
   }
   return result;
 }

 /**
  * Removes all alphanumerics and then tries a int.parse
  */ 
 int forceParseInt(String string) {
   RegExp regExp = new RegExp(r"[a-z]|[A-Z]");
   String cleanString = string.replaceAll(regExp, ""); 
   return int.parse(cleanString);  
 }