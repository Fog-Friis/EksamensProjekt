class Level {
  ArrayList<WallTile> wallTiles;
  ArrayList<WallTile> loadedTiles;

  int seed;
  int visible;
  boolean[] tiles = new boolean[1297];

  Level(int s, int v) {
    seed = s;
    visible = v;
    wallTiles = new ArrayList<WallTile>();
    loadedTiles = new ArrayList<WallTile>();
    addTiles();
  }

  //skal bruge seed til at generere bane
  void addTiles() {
    for (int i = 0; i < 1297; i++) {
      if (i <= 50) tiles[i] = true;
    }
  }

  void drawGrid() {
    int y = 0;
    int j = 0;
    for (int i = 0; i < 1297; i++) {

      if (tiles[i]==true) {
        wallTiles.add(new WallTile(new PVector(i*40-j*1920-40, y*40), 40));
      } else {
      }


      rect(i*40-j*1920-40, y*40, 40, 40);
      if (i/(j+1)*40==1920) {
        j++; 
        y++;
      }
    }
  }

  void update() {
    if (frameCount%10==0){
      loadedTiles.clear();
      println(loadedTiles);
      
      for (WallTile w : wallTiles){
        if (w.loaded){
          loadedTiles.add(w);
        }
      }
    }
    println(loadedTiles);
    
    for (WallTile w : loadedTiles) {
        for (Player p : players) {
          if (w.collision(p.pos)) {
            p.vel.mult(0);
            if (w.isUp(p.pos)) {
              p.pos.y = w.pos.y - 25;
            } else if (w.isDown(p.pos)) {
              p.pos.y = w.pos.y+40+25;
            }
            if (w.isLeft(p.pos)) {
              p.pos.x = w.pos.x-25;
            } else if (w.isRight(p.pos)) {
              p.pos.x = w.pos.x+40+25;
            }
          }
        }
    }
  }

  void display() {
    fill(255);
    drawGrid();
    for (WallTile w : wallTiles) w.run();
  }

  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
}
