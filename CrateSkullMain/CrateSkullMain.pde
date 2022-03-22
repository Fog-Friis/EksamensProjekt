GameStateManager gameStateManager;

void setup(){
  fullScreen();
  gameStateManager = new GameStateManager();
  gameStateManager.setupManager();
}

void draw(){
  background(255);
  gameStateManager.manage();
}

void mousePressed(){
  
}

void mouseReleased(){
  
}

void keyPressed(){
  if (key == ' ') 
}

void keyReleased(){
  
}
