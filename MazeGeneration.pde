void initMaze() {
  randomSeed(12345);
  cols = floor(width / w);
  rows = floor(height / w);
  grid = new Cell[cols][rows];
  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      grid[i][j]= new Cell(i, j); 
    }
  }
  startCell = grid[0][0];
  endCell = grid[cols - 1][rows - 1];
  player = startCell;

  playerRadiusDefault = w * 0.4;
  playerRadius = playerRadiusDefault;
  targetPlayerRadius = playerRadiusDefault;
  
  current = grid[0][0];
  current.visited = true;
  mazeGenerated = false;
  stack.clear();
  gameState = STATE_MENU;
}

void generateStep() {
  current.visited = true;
  Cell next = current.checkNeighbors();
  
  if (next != null) {
    stack.push(current);
    removeWalls(current, next);
    current = next;
    current.visited = true;
  } else if (!stack.empty()) {
    current = stack.pop();
  } else {
    mazeGenerated = true;
  }
}

void removeWalls(Cell a, Cell b) {
  int dx = a.x - b.x;
  int dy = a.y - b.y;

  if (dx == 1) { a.walls[3] = false; b.walls[1] = false; }
  else if (dx == -1) { a.walls[1] = false; b.walls[3] = false; }

  if (dy == 1) { a.walls[0] = false; b.walls[2] = false; }
  else if (dy == -1) { a.walls[2] = false; b.walls[0] = false; }
}
