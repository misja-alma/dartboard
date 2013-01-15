library checkerplay;

class Checkerplay {
  List<HalfMove> halfMoves;
  
  Checkerplay(this.halfMoves);
}

class HalfMove {
  int from;
  int to;
  
  HalfMove(this.from, this.to); 
  
  bool operator == (other) { 
    if(other is HalfMove) {
      return other.from == from && other.to == to;
    } else {
      return false;
    }
  }
}
