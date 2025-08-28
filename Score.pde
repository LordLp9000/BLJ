int score = 1000;
boolean mistakeHappened = false;
int frameCounter = 0;

void updateScore() {
  frameCounter++;
  if (frameCounter >= 60) {
    score += 1;
    frameCounter = 0;
  }
  if (mistakeHappened) {
    score -= 100;
    mistakeHappened = false;
  }
  if (score < 0) score = 0;
}

void resetScore() {
  score = 1000;
  mistakeHappened = false;
  frameCounter = 0;
}

void triggerMistake() {
  mistakeHappened = true;
}

int getCurrentScore() {
  return score;
}
