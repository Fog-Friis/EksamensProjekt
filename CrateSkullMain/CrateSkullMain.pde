GameStateManager gameStateManager;

void setup() {
  fullScreen();
  gameStateManager = new GameStateManager();
  gameStateManager.setupManager();
  cols = width/40;
  rows = height/40;
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
  //for (Button b : buttons) println(b.clicked);
}

void mouseReleased() {
  for (Button b : buttons) b.released();
}

void mouseClicked() {
  for (TextBox t : textBoxes) t.pressed(mouseX, mouseY);
}

void keyPressed() {
  if (key == ' '&&!gamePaused) gamestate++;
  if (key == 'p'&&gamestate == 3|| key == 'p'&&gamestate == 6) gamePaused = !gamePaused;
  
  if(!gamePaused)
    for (Player p : players) p.keyPress();
  for (TextBox t : textBoxes) t.keyWasTyped(key, (int)keyCode);
}

void keyReleased() {
  if(!gamePaused) 
    for (Player p : players) p.keyRelease();
}
