void drawGridBase(boolean showVisited) {
  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      if (showVisited && grid[i][j].visited) {
        float x = i * w;
        float y = j * w;
        noStroke();
        fill(255, 100);
        rect(x, y, w, w);
      }
      grid[i][j].show();
    }
  }
}



void drawPlayerGhost() {
  float x = startCell.x * w + w / 2.0;
  float y = startCell.y * w + w / 2.0;
  fill(0, 150, 255, 150);
  noStroke();
  ellipse(x, y, playerRadiusDefault * 2, playerRadiusDefault * 2);
}

void drawMenu() {
  fill(40, 45, 50, 220);
  noStroke();
  rect(width/4, 20, width/2, 200);
  
  fill(0, 200, 255);
  textSize(32);
  text("Labyrinth", width / 2, 60);
  
  fill(0, 200, 255);
  textSize(22);
  text("Highscores", width / 2, 100);
  textSize(18);
  if (highscores.size() == 0) {
    text("Keine Punkte bisher", width / 2, 130);
  } else {
    int show = min(5, highscores.size());
    for (int i = 0; i < show; i++) {
      String line = (i + 1) + ". " + highscores.get(i);
      text(line, width / 2, 130 + i * 20);
    }
  }
}

void drawSeedMenu() {
  fill(40, 45, 50, 220);
  noStroke();
  rect(width/4, 20, width/2, height - 40);
  
  fill(0, 200, 255);
  textSize(28);
  text("Choose Maze Seed", width / 2, 60);
  
  // Draw predefined seed options
  textSize(18);
  fill(255);
  text("Predefined Mazes:", width / 2, 100);
  
  for (int i = 0; i < predefinedSeeds.length && i < seedNames.length; i++) {
    float y = 130 + i * 35;
    
    // Highlight selected seed
    if (currentSeed == predefinedSeeds[i]) {
      fill(0, 150, 255, 100);
      noStroke();
      rect(width/4 + 10, y - 15, width/2 - 20, 30);
    }
    
    fill(255);
    textSize(16);
    text(seedNames[i] + " (" + predefinedSeeds[i] + ")", width / 2, y);
  }
  
  // Back button
  fill(150);
  textSize(14);
  text("Press 'B' to go back", width / 2, height - 60);
  
  // Start button
  fill(0, 200, 255);
  textSize(18);
  text("Press SPACE to start with selected seed", width / 2, height - 30);
}

void drawGameOver() {
  fill(0, 150);
  rect(0, 0, width, height);
  
  fill(255);
  textSize(32);
  text("Game Over!", width / 2, height / 3 - 50);
  
  textSize(24);
  text("Your Score: " + gameEndScore, width / 2, height / 3);
  
  textSize(20);
  text("Highscores:", width / 2, height / 3 + 40);
  
  int show = min(maxHighscores, highscores.size());
  for (int i = 0; i < show; i++) {
    String line = (i + 1) + ". " + highscores.get(i);
    text(line, width / 2, height / 3 + 70 + i * 25);
  }
  
  textSize(16);
  text("Click anywhere to play again", width / 2, height - 50);
}

void drawPlayer() {
  float animationSpeed = 10.0 * deltaTime;
  if (animationSpeed < 0.05) animationSpeed = 0.05;
  if (animationSpeed > 0.3) animationSpeed = 0.3;
  
  playerRadius = lerp(playerRadius, targetPlayerRadius, animationSpeed);
  
  float x = playerX;
  float y = playerY;
  
  noStroke();
  
  float glowSize = playerRadius * 2.2;
  if (collisionAnimating) {
    float pulseAmount = sin((millis() - collisionTime) * 0.02) * 0.2 + 1.0;
    glowSize *= pulseAmount;
    fill(255, 100, 100, 80);
  } else {
    fill(0, 150, 255, 80);
  }
  ellipse(x, y, glowSize, glowSize);
  
  if (collisionAnimating) {
    fill(255, 100, 150);
  } else {
    fill(0, 150, 255);
  }
  ellipse(x, y, playerRadius * 2, playerRadius * 2);
  
  fill(255, 255, 255, 150);
  ellipse(x - playerRadius * 0.3, y - playerRadius * 0.3, playerRadius * 0.8, playerRadius * 0.8);
}
