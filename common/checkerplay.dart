library checkerplay;

class Checkerplay {
  List<HalfMove> halfMoves;
  
  Checkerplay(this.halfMoves);
}

class HalfMove {
  int from;
  int to;
  int player;
  bool hits;
  
  HalfMove(this.from, this.to, this.hits, this.player); 
  
  bool operator == (other) { 
    if(other is HalfMove) {
      return other.from == from && other.to == to && other.hits == hits && other.player == player;
    } else {
      return false;
    }
  }
}
