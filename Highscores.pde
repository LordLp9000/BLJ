void loadAllHighscores() {
  seedHighscores.clear();
  // Load highscores for all predefined seeds
  for (long seed : predefinedSeeds) {
    loadSeedHighscores(seed);
  }
}

void loadSeedHighscores(long seed) {
  ArrayList<Integer> scores = new ArrayList<Integer>();
  try {
    String filename = "highscores_" + seed + ".txt";
    String[] lines = loadStrings(filename);
    if (lines != null) {
      for (String line : lines) {
        try {
          int score = Integer.parseInt(line.trim());
          scores.add(score);
        } catch (NumberFormatException e) {
        }
      }
    }
    Collections.sort(scores, Collections.reverseOrder());
    seedHighscores.put(seed, scores);
  } catch (Exception e) {
    println("Could not load highscores for seed " + seed + ": " + e.getMessage());
    seedHighscores.put(seed, new ArrayList<Integer>());
  }
}

void loadCurrentSeedHighscores() {
  if (seedHighscores.containsKey(currentSeed)) {
    highscores = seedHighscores.get(currentSeed);
  } else {
    loadSeedHighscores(currentSeed);
    highscores = seedHighscores.get(currentSeed);
  }
}

void saveCurrentSeedHighscores() {
  Collections.sort(highscores, Collections.reverseOrder());
  while (highscores.size() > maxHighscores) {
    highscores.remove(highscores.size() - 1);
  }
  
  // Update the HashMap
  seedHighscores.put(currentSeed, new ArrayList<Integer>(highscores));
  
  String[] lines = new String[highscores.size()];
  for (int i = 0; i < highscores.size(); i++) {
    lines[i] = String.valueOf(highscores.get(i));
  }
  
  try {
    String filename = "highscores_" + currentSeed + ".txt";
    saveStrings(filename, lines);
  } catch (Exception e) {
    println("Could not save highscores for seed " + currentSeed + ": " + e.getMessage());
  }
}

void saveAllHighscores() {
  for (HashMap.Entry<Long, ArrayList<Integer>> entry : seedHighscores.entrySet()) {
    long seed = entry.getKey();
    ArrayList<Integer> scores = entry.getValue();
    
    Collections.sort(scores, Collections.reverseOrder());
    while (scores.size() > maxHighscores) {
      scores.remove(scores.size() - 1);
    }
    
    String[] lines = new String[scores.size()];
    for (int i = 0; i < scores.size(); i++) {
      lines[i] = String.valueOf(scores.get(i));
    }
    
    try {
      String filename = "highscores_" + seed + ".txt";
      saveStrings(filename, lines);
    } catch (Exception e) {
      println("Could not save highscores for seed " + seed + ": " + e.getMessage());
    }
  }
}

void addHighscore(int score) {
  highscores.add(score);
  Collections.sort(highscores, Collections.reverseOrder());
  while (highscores.size() > maxHighscores) {
    highscores.remove(highscores.size() - 1);
  }
}
