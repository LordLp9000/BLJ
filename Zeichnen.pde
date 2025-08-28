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
  text("Highscores (Seed: " + currentSeed + ")", width / 2, 100);
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
    // Show best score for this seed
    ArrayList<Integer> seedScores = seedHighscores.get(predefinedSeeds[i]);
    String bestScore = "";
    if (seedScores != null && seedScores.size() > 0) {
      bestScore = " - Best: " + seedScores.get(0);
    }
    text(seedNames[i] + " (" + predefinedSeeds[i] + ")" + bestScore, width / 2, y);
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
  text("Highscores (Seed: " + currentSeed + "):", width / 2, height / 3 + 40);
  
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


    
   

void drawHeart(float x, float y, float size) {
  pushMatrix();
  translate(x, y);
  
  // Scale factor for pixelated heart
  float pixelSize = size / 16; // 16x16 pixel grid
  
  // Black outline first (drawn larger)
  fill(0);
  noStroke();
  
  // Heart outline pattern (black pixels)
  int[][] heartOutline = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0},
    {0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0},
    {1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0},
    {0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  };
  
  // Draw black outline
  for (int row = 0; row < heartOutline.length; row++) {
    for (int col = 0; col < heartOutline[row].length; col++) {
      if (heartOutline[row][col] == 1) {
        rect((col - 8) * pixelSize, (row - 6) * pixelSize, pixelSize, pixelSize);
      }
    }
  }
  
  // Red heart fill pattern
  fill(255, 50, 50);
  int[][] heartFill = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0},
    {0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0},
    {0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0},
    {0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0},
    {0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  };
  
  // Draw red fill
  for (int row = 0; row < heartFill.length; row++) {
    for (int col = 0; col < heartFill[row].length; col++) {
      if (heartFill[row][col] == 1) {
        rect((col - 8) * pixelSize, (row - 6) * pixelSize, pixelSize, pixelSize);
      }
    }
  }
  
  popMatrix();
}

void drawEmptyHeart(float x, float y, float size) {
  pushMatrix();
  translate(x, y);
  
  // Scale factor for pixelated heart
  float pixelSize = size / 16; // 16x16 pixel grid
  
  // Black outline (same as full heart)
  fill(0);
  noStroke();
  
  int[][] heartOutline = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0},
    {0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0},
    {1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0},
    {0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  };
  
  // Draw black outline
  for (int row = 0; row < heartOutline.length; row++) {
    for (int col = 0; col < heartOutline[row].length; col++) {
      if (heartOutline[row][col] == 1) {
        rect((col - 8) * pixelSize, (row - 6) * pixelSize, pixelSize, pixelSize);
      }
    }
  }
  
  // Dark gray heart fill for empty/lost hearts
  fill(80, 80, 80);
  int[][] heartFill = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0},
    {0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0},
    {0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0},
    {0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0},
    {0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  };
  
  // Draw gray fill for empty hearts
  for (int row = 0; row < heartFill.length; row++) {
    for (int col = 0; col < heartFill[row].length; col++) {
      if (heartFill[row][col] == 1) {
        rect((col - 8) * pixelSize, (row - 6) * pixelSize, pixelSize, pixelSize);
      }
    }
  }
  
  popMatrix();
}


void drawKey(float x, float y, color keyColor) {
  pushMatrix();
  translate(x, y);
  
  // Glow effect background
  for (int i = 4; i >= 0; i--) {
    fill(red(keyColor), green(keyColor), blue(keyColor), 30 - i * 5);
    ellipse(0, 0, keySize * (2.5 - i * 0.3), keySize * (2.5 - i * 0.3));
  }
  
  // Key shadow for depth
  fill(0, 0, 0, 80);
  translate(2, 2);
  
  // Key head (ornate circle with decorative ring)
  ellipse(0, -keySize * 0.3, keySize * 0.65, keySize * 0.65);
  rect(-keySize * 0.08, -keySize * 0.1, keySize * 0.16, keySize * 0.8);
  rect(keySize * 0.08, keySize * 0.3, keySize * 0.35, keySize * 0.12);
  rect(keySize * 0.08, keySize * 0.5, keySize * 0.25, keySize * 0.12);
  
  translate(-2, -2);
  
  // Main key body with gradient
  fill(keyColor);
  stroke(red(keyColor) * 0.7, green(keyColor) * 0.7, blue(keyColor) * 0.7);
  strokeWeight(1);
  
  // Ornate key head with decorative elements
  ellipse(0, -keySize * 0.3, keySize * 0.65, keySize * 0.65);
  // Inner circle decoration
  fill(red(keyColor) * 1.2, green(keyColor) * 1.2, blue(keyColor) * 1.2);
  ellipse(0, -keySize * 0.3, keySize * 0.35, keySize * 0.35);
  fill(keyColor);
  ellipse(0, -keySize * 0.3, keySize * 0.2, keySize * 0.2);
  
  // Key shaft with rounded ends
  noStroke();
  rect(-keySize * 0.08, -keySize * 0.1, keySize * 0.16, keySize * 0.8, keySize * 0.05);
  
  // Ornate key teeth with better proportions
  rect(keySize * 0.08, keySize * 0.3, keySize * 0.35, keySize * 0.12, keySize * 0.02);
  rect(keySize * 0.08, keySize * 0.5, keySize * 0.25, keySize * 0.12, keySize * 0.02);
  rect(keySize * 0.08, keySize * 0.38, keySize * 0.15, keySize * 0.04);
  
  // Highlight for 3D effect
  fill(red(keyColor) * 1.3, green(keyColor) * 1.3, blue(keyColor) * 1.3, 180);
  ellipse(-keySize * 0.1, -keySize * 0.35, keySize * 0.15, keySize * 0.1);
  
  popMatrix();
}

void drawDoor() {
  // Position door at the end cell
  float x = endCell.x * w + w / 2;
  float y = endCell.y * w + w / 2;
  
  if (!doorOpen) {
    // Draw shadow for depth
    fill(0, 0, 0, 100);
    rect(x - w * 0.38, y - w * 0.38, w * 0.8, w * 0.8, w * 0.05);
    
    // Draw closed door with gradient effect
    // Door frame (stone/metal)
    fill(80, 80, 90);
    stroke(60, 60, 70);
    strokeWeight(3);
    rect(x - w * 0.4, y - w * 0.4, w * 0.8, w * 0.8, w * 0.05);
    
    // Main door (wooden with metal reinforcements)
    fill(101, 67, 33);
    stroke(80, 53, 26);
    strokeWeight(2);
    rect(x - w * 0.35, y - w * 0.35, w * 0.7, w * 0.7, w * 0.03);
    
    // Wood grain effect
    stroke(120, 80, 40);
    strokeWeight(1);
    for (int i = 0; i < 4; i++) {
      float lineY = y - w * 0.2 + i * w * 0.1;
      line(x - w * 0.3, lineY, x + w * 0.3, lineY);
    }
    
    // Metal reinforcements
    fill(120, 120, 130);
    noStroke();
    rect(x - w * 0.32, y - w * 0.15, w * 0.64, w * 0.05);
    rect(x - w * 0.32, y + w * 0.1, w * 0.64, w * 0.05);
    rect(x - w * 0.1, y - w * 0.32, w * 0.05, w * 0.64);
    
    // Ornate door handle
    fill(200, 160, 50);
    stroke(180, 140, 30);
    strokeWeight(1);
    ellipse(x + w * 0.22, y, w * 0.08, w * 0.08);
    fill(220, 180, 70);
    ellipse(x + w * 0.22, y, w * 0.05, w * 0.05);
    
    // Lock mechanism if keys not collected
    if (!key1Collected || !key2Collected) {
      // Large ornate lock
      fill(60, 60, 70);
      stroke(40, 40, 50);
      strokeWeight(2);
      rect(x - w * 0.12, y - w * 0.08, w * 0.24, w * 0.16, w * 0.02);
      
      // Lock shackle
      noFill();
      stroke(60, 60, 70);
      strokeWeight(4);
      arc(x, y - w * 0.08, w * 0.15, w * 0.15, PI, TWO_PI);
      
      // Keyhole
      fill(0);
      ellipse(x, y, w * 0.04, w * 0.04);
      triangle(x - w * 0.01, y + w * 0.02, x + w * 0.01, y + w * 0.02, x, y + w * 0.05);
      
      // Status text with better styling
      fill(255, 80, 80);
      stroke(0);
      strokeWeight(1);
      textAlign(CENTER, CENTER);
      textSize(10);
      text("LOCKED", x, y + w * 0.25);
      
      // Required keys indicator
      fill(255, 255, 100);
      textSize(8);
      String keyText = "Need: ";
      if (!key1Collected && !key2Collected) keyText += "Both Keys";
      else if (!key1Collected) keyText += "Gold Key";
      else keyText += "Silver Key";
      
      text(keyText, x, y + w * 0.32);
    }
  } else {
    // Draw open door - ornate archway
    noFill();
    
    // Stone archway
    stroke(120, 120, 130);
    strokeWeight(6);
    rect(x - w * 0.4, y - w * 0.4, w * 0.8, w * 0.8, w * 0.05);
    
    // Inner glow effect
    for (int i = 3; i >= 0; i--) {
      stroke(0, 255 - i * 40, 0, 150 - i * 30);
      strokeWeight(4 - i);
      rect(x - w * 0.35 + i * 2, y - w * 0.35 + i * 2, 
           w * 0.7 - i * 4, w * 0.7 - i * 4, w * 0.05);
    }
    
    // Exit portal effect
    fill(0, 255, 100, 100);
    noStroke();
    ellipse(x, y, w * 0.3, w * 0.3);
    
    // EXIT text with glow
    fill(255);
    stroke(0, 255, 0);
    strokeWeight(2);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("EXIT", x, y);
    
    // Sparkle effects around the exit
    fill(255, 255, 255, 200);
    noStroke();
    for (int i = 0; i < 6; i++) {
      float angle = i * PI / 3;
      float sparkleX = x + cos(angle) * w * 0.25;
      float sparkleY = y + sin(angle) * w * 0.25;
      ellipse(sparkleX, sparkleY, 3, 3);
    }
  }
}
