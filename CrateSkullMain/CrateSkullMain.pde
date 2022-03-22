GameStateManager gameStateManager;

void setup() {
  fullScreen();
  gameStateManager = new GameStateManager();
  gameStateManager.setupManager();
}

void draw() {
  background(255);
  gameStateManager.manage();
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseClicked() {
  for (TextBox t : textBoxes) t.pressed(mouseX, mouseY);
}

void keyPressed() {
  if (key == ' ') gamestate++;

  for (Player p : players) p.keyPress();

  for (TextBox t : textBoxes) t.keyWasTyped(key, (int)keyCode);
}

void keyReleased() {
  for (Player p : players) p.keyRelease();
}
