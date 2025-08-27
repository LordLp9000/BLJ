import java.util.Stack;
import java.util.ArrayList;
import java.util.Collections;

static final int STATE_MENU = 0;
static final int STATE_GENERATING = 1;
static final int STATE_PLAYING = 2;
static final int STATE_GAME_OVER = 3;

int gameState = STATE_MENU;
int cols, rows;
int w = 15;
Cell[][] grid;
Stack<Cell> stack = new Stack<Cell>();
Cell current;
Cell startCell;
Cell endCell;
Cell player;
boolean mazeGenerated = false;
float playerRadiusDefault;
float playerRadius;
float targetPlayerRadius;
boolean draggingPlayer = false;
boolean collisionAnimating = false;
int collisionTime = 0;
int collisionDuration = 400;
float shakeAmount = 0;
int lastCollisionDirection = -1;
float gameStartMillis = 0;
float gameEndTimeSec = 0;
ArrayList<Float> highscores = new ArrayList<Float>(); 
int maxHighscores = 10;
long lastFrameTime = 0;
float deltaTime = 0;

void setup() {
  size(500, 500);
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
    drawStartEnd();
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
    drawStartEnd();
    
    fill(255);
    textSize(16);
    text("Generating maze...", width / 2, height - 20);
    
    if (mazeGenerated) {
      gameState = STATE_PLAYING;
      gameStartMillis = millis();
    }
    return;
  }
  
  if (gameState == STATE_PLAYING) {
    drawGridBase(true);
    drawStartEnd();
    handleDraggingMove();
    drawPlayer();
    
    fill(255);
    textSize(16);
    text(nf((millis() - gameStartMillis) / 1000.0, 0, 2) + "s", width - 40, 20);
    
    if (player == endCell) {
      gameEndTimeSec = (millis() - gameStartMillis) / 1000.0;
      addHighscore(gameEndTimeSec);
      savedHighscores();
      gameState = STATE_GAME_OVER;
    }
    return;
  }
  
  if (gameState == STATE_GAME_OVER) {
    drawGridBase(true);
    drawStartEnd();
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
  
  float cx = player.x * w + w / 2.0;
  float cy = player.y * w + w / 2.0;
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
