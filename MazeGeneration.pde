
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
    // Spawn first key when maze generation is complete
    spawnFirstKey();
    // Sperre die Endzelle nach der Maze-Generierung
    lockEndCell();
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

