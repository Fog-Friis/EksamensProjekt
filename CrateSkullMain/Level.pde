class Level {
  ArrayList<WallTile> wallTiles;

  int rows, columns;
  int cellSize;

  int seed;
  int visible;

  Level(int s, int v, int cs) {
    seed = s;
    visible = v;
    cellSize = cs;
    rows = height/cellSize;
    columns = width/cellSize;

    wallTiles = new ArrayList<WallTile>();
    addTiles();
  }

  //skal bruge seed til at generere bane
  void addTiles() {
    for (int j=0; j < rows; j++) {
      for (int i=0; i < columns; i++) {
        if (j == 0 || j == rows-1 || i == 0 || i == columns-1) wallTiles.add(new WallTile(i, j, cellSize));
      }
    }
  }

  void drawGrid() {
    for (WallTile w : wallTiles) w.run();
  }

  void update() {
    //check collision mellem spiller og væg
    for (WallTile w : wallTiles) {
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
  }

  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
}
