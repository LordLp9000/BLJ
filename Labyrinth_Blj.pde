import java.util.Stack;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import processing.sound.*;

static final int STATE_MENU = 0;
static final int STATE_GENERATING = 1;
static final int STATE_PLAYING = 2;
static final int STATE_GAME_OVER = 3;
static final int STATE_SEED_MENU = 4;
long currentSeed = 12345;
String seedInput = "";
boolean typingCustomSeed = false;
long[] predefinedSeeds = {12345, 11111, 54321, 33333, 44444, 55555, 66666};
String[] seedNames = {"Classic", "Twisted", "Challenge", "Simple", "Complex"};

int gameState = STATE_MENU;
int cols, rows;
int w = 80;
Cell[][] grid;
Stack<Cell> stack = new Stack<Cell>();
Cell current;
Cell startCell;
Cell endCell;
float playerX, playerY;
boolean mazeGenerated = false;
float playerRadiusDefault;
float playerRadiusOriginal = 15.0;
float playerRadius;
float targetPlayerRadius;
boolean draggingPlayer = false;
boolean collisionAnimating = false;
int collisionTime = 0;
int collisionDuration = 400;
float shakeAmount = 0;
int gameEndScore = 0;
HashMap<Long, ArrayList<Integer>> seedHighscores = new HashMap<Long, ArrayList<Integer>>();
ArrayList<Integer> highscores = new ArrayList<Integer>(); // Current seed's highscores
int maxHighscores = 10;
long lastFrameTime = 0;
float deltaTime = 0;

// Zeitbegrenzung
float gameTimeLimit = 60.0; // 1 Minute in Sekunden
float gameStartTime = 0;
float remainingTime = 0;


int playerLives = 5;
int maxLives = 5;
boolean key1Collected = false;
boolean key2Collected = false;
boolean key2Spawned = false;
boolean doorOpen = false;
float doorX, doorY;
float key1X, key1Y;
float key2X, key2Y;
float keySize = 20;

// Sound system
SoundFile collisionSound;
SoundFile deathSound;
SoundFile winSound;
SoundFile keySound;
SoundFile doorUnlockSound;
SinOsc beepOsc;
Env beepEnv;


void setup() {
  size(800, 800);
  frameRate(60);
  smooth();
  surface.setTitle("Maze - Mouse Drag, Collisions, Highscores");
  textAlign(CENTER, CENTER);

  // Sound initialisieren
  try {
    collisionSound = new SoundFile(this, "data/collision.mp3");
    println("Collision sound loaded");
  } catch (Exception e) {
    println("Collision sound not found");
  }
  try {
    deathSound = new SoundFile(this, "data/death.mp3");
    println("Death sound loaded");
  } catch (Exception e) {
    println("Death sound not found");
  }
  try {
    winSound = new SoundFile(this, "data/win.mp3");
    println("Win sound loaded");
  } catch (Exception e) {
    println("Win sound not found");
  }
  try {
    keySound = new SoundFile(this, "data/key.mp3");
    println("Key sound loaded");
  } catch (Exception e) {
    println("Key sound not found");
  }
  try {
    doorUnlockSound = new SoundFile(this, "data/doorunlock.mp3");
    println("Door unlock sound loaded");
  } catch (Exception e) {
    println("Door unlock sound not found");
  }
  // Create programmatic beep as fallback
  beepOsc = new SinOsc(this);
  beepEnv = new Env(this);

  loadAllHighscores();
  loadCurrentSeedHighscores();
  initMaze();
}

void draw() {
  if (gameState == STATE_SEED_MENU) {
    drawGridBase(false);
    drawPlayerGhost();
    drawSeedMenu();
    return;
  }
  long currentTime = millis();
  deltaTime = (currentTime - lastFrameTime) / 1000.0f;
  lastFrameTime = currentTime;
  background(40, 45, 50);
  if (gameState == STATE_MENU) {
    drawGridBase(false);
    drawPlayerGhost();
    drawMenu();
    return;
  }
  if (gameState == STATE_GENERATING) {
    long startTime = millis();
    long maxGenerationTimePerFrame = 16;
    while (millis() - startTime < maxGenerationTimePerFrame && !mazeGenerated) {
      for (int s = 0; s < 50 && !mazeGenerated; s++) {
        generateStep();
      }
    }
    drawGridBase(true);
    fill(255);
    textSize(16);
    text("Generating maze...", width / 2, height - 20);
    if (mazeGenerated) {
      gameState = STATE_PLAYING;
      gameStartTime = millis() / 1000.0; // Timer starten
    }
    return;
  }
  if (gameState == STATE_PLAYING) {
    drawGridBase(true);
    handleDraggingMove();
    updateScore();
    drawPlayer();
    drawLives();
    drawTimer();
    drawKeys();
    drawDoor();
    checkKeyCollection();
    
    // Zeitbegrenzung prüfen
    float currentGameTime = millis() / 1000.0;
    remainingTime = gameTimeLimit - (currentGameTime - gameStartTime);
    
    if (remainingTime <= 0) {
      // Zeit abgelaufen - Game Over
      gameEndScore = getCurrentScore();
      addHighscore(gameEndScore);
      saveCurrentSeedHighscores();
      gameState = STATE_GAME_OVER;
    }
    
    fill(255);
    textSize(16);
    int playerCellX = floor(playerX / w);
    int playerCellY = floor(playerY / w);
    if (playerCellX == endCell.x && playerCellY == endCell.y && doorOpen) {
      // Play win sound
      if (winSound != null) {
        winSound.play();
      }
      gameEndScore = getCurrentScore();
      addHighscore(gameEndScore);
      saveCurrentSeedHighscores();
      gameState = STATE_GAME_OVER;
    }
    return;
  }
  if (gameState == STATE_GAME_OVER) {
    drawGridBase(true);
    drawPlayer();
    drawGameOver();
  }
}

void mousePressed() {
  if (gameState == STATE_MENU) {
    gameState = STATE_SEED_MENU;
    return;
  }
  if (gameState == STATE_GAME_OVER) {
    initMaze();
    startGame();
    return;
  }
  if (gameState != STATE_PLAYING) return;
  
  float cx = playerX;
  float cy = playerY;
  float d = dist(mouseX, mouseY, cx, cy);
  if (d <= playerRadius) {
    draggingPlayer = true;
  }
}

void mouseReleased() {
  draggingPlayer = false;
}

void backToMenu() {
  gameState = STATE_MENU;
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    initMaze();
  }
  if (key == 'n' || key == 'N') {
    initMaze();
    startGame();
  }
  if (key == 'b' || key == 'B') {
    backToMenu();
  }
  if (key == ' ' || key == ' ') {
    initMaze();
    startGame();
  }
  
  if (gameState == STATE_SEED_MENU && key >= '1' && key <= '7') {
    int seedIndex = key - '1';  // Convert '1' to 0, '2' to 1, etc.
    if (seedIndex < predefinedSeeds.length) {
      currentSeed = predefinedSeeds[seedIndex];
      loadCurrentSeedHighscores(); // Load highscores for the new seed
    }
  }
}

void startCollisionAnimation() {
  collisionAnimating = true;
  collisionTime = millis();
  shakeAmount = 5;
  triggerMistake();

  // Play collision sound
  if (collisionSound != null) {
    collisionSound.play();
  }

  // Leben abziehen
  playerLives--;
  // Spieler wird kleiner
  playerRadiusDefault *= 0.8;
  if (playerLives <= 0) {
    // Play death sound
    if (deathSound != null) {
      deathSound.play();
    }
    gameState = STATE_GAME_OVER;
    gameEndScore = getCurrentScore();
  }
}

void playKeySound() {
  if (keySound != null) {
    keySound.play();
  } else if (beepOsc != null && beepEnv != null) {
    // Fallback: kurzer Beep
    beepOsc.freq(1200);
    beepEnv.play(beepOsc, 0.01, 0.05, 0.8, 0.05);
    println("Key sound not loaded, fallback beep played.");
  } else {
    println("Key sound and fallback beep not available!");
  }
}

void drawLives() {
  // Draw lives as hearts in the top right corner
  float heartSize = 20;
  float spacing = 25;
  float startX = width - (maxLives * spacing + 10);
  float y = 25;
  for (int i = 0; i < maxLives; i++) {
    float x = startX + i * spacing;
    if (i < playerLives) {
      // Full heart (alive) - draw normal pixelated heart
      drawHeart(x, y, heartSize);
    } else {
      // Empty heart (lost life) - draw grayed out version
      drawEmptyHeart(x, y, heartSize);
    }
  }
}

void drawTimer() {
  // Timer neben den Herzen anzeigen
  float heartSize = 20;
  float spacing = 25;
  float heartsWidth = maxLives * spacing;
  float timerX = width - heartsWidth - 90;
  float timerY = 25;
  
  // Timer Hintergrund
  fill(50, 50, 50, 150);
  rect(timerX - 45, timerY - 12, 85, 24, 5);
  
  // Timer Text
  if (remainingTime <= 10) {
    fill(255, 50, 50); // Rot wenn wenig Zeit
  } else if (remainingTime <= 20) {
    fill(255, 200, 50); // Orange als Warnung
  } else {
    fill(255, 255, 255); // Weiß normal
  }
  textAlign(CENTER, CENTER);
  textSize(16);
  text(nf(max(0, remainingTime), 0, 1) + "s", timerX, timerY);
  textAlign(CENTER, CENTER); // Reset alignment
}

void drawKeys() {
  // Draw first key if not collected
  if (!key1Collected) {
    drawKey(key1X, key1Y, color(255, 215, 0)); // Gold color
  }
  // Draw second key if spawned and not collected
  if (key2Spawned && !key2Collected) {
    drawKey(key2X, key2Y, color(192, 192, 192)); // Silver color
  }
}

void spawnFirstKey() {
  // Schlüsselpositionen werden unabhängig vom Maze-Seed zufällig bestimmt
  long oldSeed = getSeed();
  randomSeed(millis());
  key1X = random(w, width - w);
  key1Y = random(w, height - w);
  randomSeed(oldSeed); // Maze-Seed wiederherstellen
}

void spawnSecondKey() {
  long oldSeed = getSeed();
  randomSeed(millis() + 1000);
  key2X = random(w, width - w);
  key2Y = random(w, height - w);
  randomSeed(oldSeed);
}

long getSeed() {
  // Hilfsfunktion, um den aktuellen Seed zu holen
  // Processing speichert den Seed nicht direkt, daher workaround:
  // Wir nutzen currentSeed, der für das Maze verwendet wird
  return currentSeed;
}

void lockEndCell() {
  // Sperre die Endzelle nach der Maze-Generierung
  if (endCell != null) {
    // Finde heraus, welche Wand zur Endzelle führt und sperre nur diese
    if (endCell.x > 0) {
      endCell.walls[3] = true; // Linke Wand sperren
      grid[endCell.x - 1][endCell.y].walls[1] = true; // Rechte Wand der Nachbarzelle
    }
    if (endCell.y > 0) {
      endCell.walls[0] = true; // Obere Wand sperren
      grid[endCell.x][endCell.y - 1].walls[2] = true; // Untere Wand der Nachbarzelle
    }
  }
}

// Rufe spawnFirstKey() nach Maze-Generierung auf
void initMaze() {
  randomSeed(currentSeed); // Maze wird immer gleich für gleichen Seed
  cols = floor(width / w);
  rows = floor(height / w);

  // Reset life system
  playerLives = maxLives;

  // Reset key system
  key1Collected = false;
  key2Collected = false;
  key2Spawned = false;
  doorOpen = false;

  grid = new Cell[cols][rows];
  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      grid[i][j]= new Cell(i, j);
    }
  }
  startCell = grid[0][0];
  endCell = grid[cols - 1][rows - 1];

  // Position door at end cell
  doorX = endCell.x * w + w / 2;
  doorY = endCell.y * w + w / 2;

  playerX = startCell.x * w + w / 2.0;
  playerY = startCell.y * w + w / 2.0;

  playerRadiusDefault = w * 0.4;
  playerRadius = playerRadiusDefault;
  targetPlayerRadius = playerRadiusDefault;

  current = grid[0][0];
  current.visited = true;
  mazeGenerated = false;
  stack.clear();
  gameState = STATE_MENU; // Starte immer im Menü

  spawnFirstKey(); // Schlüssel spawnen weiterhin zufällig
}

// Passe die Logik in checkKeyCollection() an
void checkKeyCollection() {
  // Ersten Schlüssel einsammeln
  if (!key1Collected && dist(playerX, playerY, key1X, key1Y) < playerRadius + keySize / 2) {
    key1Collected = true;
    playKeySound();
    // Zweiten Schlüssel generieren
    if (!key2Spawned) {
      spawnSecondKey();
      key2Spawned = true;
    }
  }
  // Zweiten Schlüssel einsammeln
  if (key2Spawned && !key2Collected && dist(playerX, playerY, key2X, key2Y) < playerRadius + keySize / 2) {
    key2Collected = true;
    playKeySound();
  }
  // Tür öffnen, wenn beide Schlüssel eingesammelt
  if (key1Collected && key2Collected && !doorOpen) {
    doorOpen = true;
    // Entferne Wände der Endzelle
    if (endCell.x > 0) {
      endCell.walls[3] = false; // Linke Wand öffnen
      grid[endCell.x - 1][endCell.y].walls[1] = false; // Rechte Wand der Nachbarzelle
    }
    if (endCell.y > 0) {
      endCell.walls[0] = false; // Obere Wand öffnen
      grid[endCell.x][endCell.y - 1].walls[2] = false; // Untere Wand der Nachbarzelle
    }
    // Play door unlock sound
    if (doorUnlockSound != null) {
      doorUnlockSound.play();
    } else if (beepOsc != null && beepEnv != null) {
      // Fallback: tieferer Beep für Tür
      beepOsc.freq(400);
      beepEnv.play(beepOsc, 0.02, 0.15, 0.6, 0.15);
    }
  }
}
