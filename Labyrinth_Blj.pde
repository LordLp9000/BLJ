import java.util.Stack;
import java.util.ArrayList;
import java.util.Collections;

static final int STATE_MENU = 0;
static final int STATE_GENERATING = 1;
static final int STATE_PLAYING = 2;
static final int STATE_GAME_OVER = 3;

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
ArrayList<Integer> highscores = new ArrayList<Integer>(); 
int maxHighscores = 10;
long lastFrameTime = 0;
float deltaTime = 0;

void setup() {
  size(800, 800);
  frameRate(60);
  smooth();
  surface.setTitle("Maze - Mouse Drag, Collisions, Highscores");
  textAlign(CENTER, CENTER);
  loadHighscores();
  initMaze();
}

void draw() {
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
    }
    return;
  }
  
  if (gameState == STATE_PLAYING) {
    drawGridBase(true);
    handleDraggingMove();
    updateScore();
    drawPlayer();
    
    fill(255);
    textSize(16);
    text("Score: " + getCurrentScore(), width - 60, 20);
    
    int playerCellX = floor(playerX / w);
    int playerCellY = floor(playerY / w);
    
    if (playerCellX == endCell.x && playerCellY == endCell.y) {
      gameEndScore = getCurrentScore();
      addHighscore(gameEndScore);
      savedHighscores();
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
    startGame();
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

void keyPressed() {
  if (key == 'r' || key == 'R') {
    initMaze();
  }
  if (key == 'n' || key == 'N') {
    initMaze();
    startGame();
  }
}
