class Level {
  ArrayList<WallTile> wallTiles;

  int seed;
  int visible;
  int[] tiles = new int[1295];

  Level(int s, int v) {
    seed = s;
    visible = v;
    wallTiles = new ArrayList<WallTile>();
  }

  //skal bruge seed til at generere bane
  void addTiles() {
  }

  void drawGrid() {
    int y = 0;
    int j = 0;
    for (int i = 0; i < 1295; i++) {

      rect(i*40-j*1920-40, y*40, 40, 40);
      if (i/(j+1)*40==1920) {
        j++; 
        y++;
      }
    }
  }

  void update() {
    for (Player p : players) {
      for (WallTile w : wallTiles) {
        if (w.isUp(p.pos)) {
          p.vel.y = 0;
          p.pos.y = p.pos.y - w.size/2;
        }
        if (w.isDown(p.pos)) {
          p.vel.y = 0;
          p.pos.y = p.pos.y + w.size/2;
        }
        if (w.isLeft(p.pos)) {
          p.vel.x = 0;
          p.pos.y = p.pos.y + w.size/2;
        }
        if (w.isRight(p.pos)) {
          p.vel.x = 0;
          p.pos.y = p.pos.y + w.size/2;
        }
      }
    }
  }

  void display() {
    fill(0);
    for (WallTile w : wallTiles) w.run();
    fill(255);
    drawGrid();
  }

  void run() {
    if(visible == gamestate){
    update();
    display();
    }
  }
}
