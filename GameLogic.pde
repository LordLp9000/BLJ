void startGame() {
  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      grid[i][j].visited = false; 
      grid[i][j].walked = false;
    }
  }
  player = startCell;
  player.walked = true;
  draggingPlayer = false;
  playerRadius = playerRadiusDefault;
  targetPlayerRadius = playerRadiusDefault;
  gameEndTimeSec = 0;
  gameStartMillis = 0;
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
  
  int i = floor(mouseX / w);
  int j = floor(mouseY / w);
  
  if (i < 0 || i >= cols || j < 0 || j >= rows) return;
  
  Cell target = grid[i][j];
  
  int dx = target.x - player.x;
  int dy = target.y - player.y;
  
  if ((abs(dx) == 1 && dy == 0) || (dx == 0 && abs(dy) == 1)) {
    boolean collision = false;
    
    if (dx == 1 && !player.walls[1]) {
      player = target;
      player.walked = true;
    } else if (dx == -1 && !player.walls[3]) {
      player = target;
      player.walked = true;
    } else if (dy == 1 && !player.walls[2]) {
      player = target;
      player.walked = true;
    } else if (dy == -1 && !player.walls[0]) {
      player = target;
      player.walked = true;
    } else {
      collision = true;
    }
    
    if (collision && !collisionAnimating) {
      collisionAnimating = true;
      collisionTime = millis();
      targetPlayerRadius = playerRadiusDefault * 0.5;
      shakeAmount = 5.0;
    }
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
