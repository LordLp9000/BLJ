class Cell {
  int x, y;
  boolean[] walls = {true, true, true, true};
  boolean visited = false;
  boolean walked = false;
  
  Cell(int i, int j) { 
    x = i;
    y = j;
  }
  
  void show() {
    float x_coord = x * w;
    float y_coord = y * w;
    stroke(255);
    if (walls[0]) line(x_coord, y_coord, x_coord + w, y_coord);
    if (walls[1]) line(x_coord + w, y_coord, x_coord + w, y_coord + w);
    if (walls[2]) line(x_coord + w, y_coord + w, x_coord, y_coord + w);
    if (walls[3]) line(x_coord, y_coord + w, x_coord, y_coord);
    
    if (walked) {
      fill(0, 150, 255, 110);
      noStroke();
      rect(x_coord, y_coord, w, w);
    }
    
    if (this == startCell) {
      fill(0, 255, 0);
      rect(x_coord, y_coord, w, w);
    }
    
    if (this == endCell) {
      fill(255, 0, 0);
      rect(x_coord, y_coord, w, w);
    }
  }
  
  void highlight() {
    float x_coord = x * w;
    float y_coord = y * w;
    fill(255, 0, 128);
    noStroke();
    rect(x_coord, y_coord, w, w);
  }
  
  Cell checkNeighbors() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    
    if (y > 0) {
      Cell top = grid[x][y - 1];
      if (!top.visited) {
        neighbors.add(top);
      }
    }
    
    if (x < cols - 1) {
      Cell right = grid[x + 1][y];
      if (!right.visited) {
        neighbors.add(right);
      }
    }
    
    if (y < rows - 1) {
      Cell bottom = grid[x][y + 1];
      if (!bottom.visited) {
        neighbors.add(bottom);
      }
    }
    
    if (x > 0) {
      Cell left = grid[x - 1][y];
      if (!left.visited) {
        neighbors.add(left);
      }
    }
    
    if (neighbors.size() > 0) {
      int r = (int) random(neighbors.size());
      return neighbors.get(r);
    } else {
      return null;
    }
  }
}
