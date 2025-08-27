void loadHighscores() {
  highscores.clear();
  try {
    String[] lines = loadStrings("highscores.txt");
    if (lines != null) {
      for (String line : lines) {
        try {
          int score = Integer.parseInt(line.trim());
          highscores.add(score);
        } catch (NumberFormatException e) {
        }
      }
    }
    Collections.sort(highscores, Collections.reverseOrder());
  } catch (Exception e) {
    println("Could not load highscores: " + e.getMessage());
  }
}

void savedHighscores() {
  Collections.sort(highscores, Collections.reverseOrder());
  while (highscores.size() > maxHighscores) {
    highscores.remove(highscores.size() - 1);
  }
  
  String[] lines = new String[highscores.size()];
  for (int i = 0; i < highscores.size(); i++) {
    lines[i] = String.valueOf(highscores.get(i));
  }
  
  try {
    saveStrings("highscores.txt", lines);
  } catch (Exception e) {
    println("Could not save highscores: " + e.getMessage());
  }
}

void addHighscore(int score) {
  highscores.add(score);
  Collections.sort(highscores, Collections.reverseOrder());
  while (highscores.size() > maxHighscores) {
    highscores.remove(highscores.size() - 1);
  }
}
