// Score-Verwaltung für das Labyrinth-Spiel

// Score-Variablen
int score = 1000;
boolean mistakeHappened = false; // Simuliert Fehler, z.B. Kollision

// Score-Funktionen
void updateScore() {
  score -= 1; // Pro Frame 1 Punkt abziehen
  if (mistakeHappened) {
    score -= 50; // Bei Fehler 50 Punkte abziehen
    mistakeHappened = false; // Fehler zurücksetzen
  }
  if (score < 0) score = 0;
}

void resetScore() {
  score = 1000;
  mistakeHappened = false;
}

void triggerMistake() {
  mistakeHappened = true;
}

int getCurrentScore() {
  return score;
}
