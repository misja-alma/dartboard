library checkerplay;

class Checkerplay {
  List<HalfMove> halfMoves;
  
  Checkerplay(this.halfMoves);
}

class HalfMove {
  int from;
  int to;
  bool hits;
  
  HalfMove(this.from, this.to, this.hits); 
  
  bool operator == (other) { 
    if(other is HalfMove) {
      return other.from == from && other.to == to && other.hits == hits;
    } else {
      return false;
    }
  }
}
