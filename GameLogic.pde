void startGame() {
  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      grid[i][j].visited = false; 
      grid[i][j].walked = false;
    }
  }
  playerX = startCell.x * w + w / 2.0;
  playerY = startCell.y * w + w / 2.0;
  draggingPlayer = false;
  playerRadiusDefault = playerRadiusOriginal;
  playerRadius = playerRadiusDefault;
  targetPlayerRadius = playerRadiusDefault;
  resetScore();
  gameEndScore = 0;
  gameState = STATE_GENERATING;
}

void handleDraggingMove() {
  if (shakeAmount > 0) {
    shakeAmount *= 0.9;
    if (shakeAmount < 0.1) shakeAmount = 0;
    translate(random(-shakeAmount, shakeAmount), random(-shakeAmount, shakeAmount));
  }
  
  if (!draggingPlayer) {
    targetPlayerRadius = playerRadiusDefault;
    return;
  }
  
  targetPlayerRadius = playerRadiusDefault * 0.85;
  
  float oldPlayerX = playerX;
  float oldPlayerY = playerY;
  
  float newPlayerX = mouseX;
  float newPlayerY = mouseY;
  
  boolean collision = checkWallCollision(newPlayerX, newPlayerY, playerRadius) || 
                     checkPathCollision(oldPlayerX, oldPlayerY, newPlayerX, newPlayerY, playerRadius);
  
  if (collision) {
    if (!collisionAnimating) {
      startCollisionAnimation();
    }
    playerX = oldPlayerX;
    playerY = oldPlayerY;
  } else {
    playerX = newPlayerX;
    playerY = newPlayerY;
  }
  
  if (collisionAnimating) {
    int elapsed = millis() - collisionTime;
    if (elapsed > collisionDuration) {
      collisionAnimating = false;
      targetPlayerRadius = draggingPlayer ? playerRadiusDefault * 0.85 : playerRadiusDefault;
    } else {
      float progress = map(elapsed, 0, collisionDuration, 0, 1);
      progress = easeOutElastic(progress);
      targetPlayerRadius = lerp(playerRadiusDefault * 0.5, 
                               draggingPlayer ? playerRadiusDefault * 0.85 : playerRadiusDefault, 
                               progress);
    }
  }
}


float easeOutElastic(float x) {
  float c4 = (2 * PI) / 3;
  if (x == 0 || x == 1) return x;
  return pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
}
boolean checkWallCollision(float x, float y, float radius) {
  if (x - radius < 0 || x + radius > cols * w || 
      y - radius < 0 || y + radius > rows * w) {
    return true;
  }
  
  int minI = floor((x - radius) / w);
  int maxI = floor((x + radius) / w);
  int minJ = floor((y - radius) / w);
  int maxJ = floor((y + radius) / w);
  
  minI = max(0, minI);
  maxI = min(cols - 1, maxI);
  minJ = max(0, minJ);
  maxJ = min(rows - 1, maxJ);
  
  for (int i = minI; i <= maxI; i++) {
    for (int j = minJ; j <= maxJ; j++) {
      Cell cell = grid[i][j];
      
      if (cell.walls[0] && y - radius < j * w) return true;
      if (cell.walls[1] && x + radius > (i + 1) * w) return true;
      if (cell.walls[2] && y + radius > (j + 1) * w) return true;
      if (cell.walls[3] && x - radius < i * w) return true;
    }
  }
  
  return false;
}

boolean checkPathCollision(float x1, float y1, float x2, float y2, float radius) {
  float distance = dist(x1, y1, x2, y2);
  
  if (distance < 2) return false;
  
  int steps = int(distance / 5) + 1;
  
  for (int i = 1; i < steps; i++) {
    float t = (float)i / steps;
    float x = lerp(x1, x2, t);
    float y = lerp(y1, y2, t);
    
    if (checkWallCollision(x, y, radius)) {
      return true;
    }
  }
  
  return false;
}
