GameStateManager gameStateManager;
JSONObject json;
int highscore,highscore2,highscore3,highscore4,highscore5;
String highscoreName,highscoreName2,highscoreName3,highscoreName4,highscoreName5;

void setup() {
  fullScreen();
  gameStateManager = new GameStateManager();
  gameStateManager.setupManager();
  cols = width/40;
  rows = height/40;
  
  json = loadJSONObject("Highscore.json");
  highscore = json.getInt("Score");
  highscore2 = json.getInt("Score2");
  highscore3 = json.getInt("Score3");
  highscore4 = json.getInt("Score4");
  highscore5 = json.getInt("Score5");
  highscoreName = json.getString("Name");
  highscoreName2 = json.getString("Name2");
  highscoreName3 = json.getString("Name3");
  highscoreName4 = json.getString("Name4");
  highscoreName5 = json.getString("Name5");
}

void draw() {
  loadPixels();
  if(!gamePaused){
    background(255);
    pausedScreen = false;
  } else{
    if(!pausedScreen){
      fill(100,100);
      rect(0, 0, width, height);
      pausedScreen = true;
    }
    for (Player p : players) p.keyRelease();
  }
  gameStateManager.manage();
}

void mousePressed() {
  for (Button b : buttons) b.pressed();
}

void mouseReleased() {
  for (Button b : buttons) b.released();
}

void mouseClicked() {
  for (TextBox t : textBoxes) t.pressed(mouseX, mouseY);
}

void keyPressed() {
  //if (key == ' '&&!gamePaused) gamestate++;
  if (key == 'p'&&gamestate == 3|| key == 'p'&&gamestate == 6) gamePaused = !gamePaused;
  
  if(!gamePaused)
    for (Player p : players) p.keyPress();
  for (TextBox t : textBoxes) t.keyWasTyped(key, (int)keyCode);
}

void keyReleased() {
  if(!gamePaused) 
    for (Player p : players) p.keyRelease();
}
