class Level {
  ArrayList<LevelTile> levelTiles;

  int rows, columns;
  int cellSize;

  int seed;
  int visible;

  Level(int s, int v, int cs) {
    seed = s;
    visible = v;
    cellSize = cs;
    rows = height/(cellSize*9);
    columns = width/(cellSize*8);


    levelTiles = new ArrayList<LevelTile>();
    addTiles();

    //for (int i=0; i<levelTiles.size()-1; i++) println(i, levelTiles.get(i).pos);
  }

  //skal bruge seed til at generere bane
  void addTiles() {
    randomSeed(seed);
    for (int j=0; j < rows; j++) {
      for (int i=0; i < columns; i++) {
            int type = int(random(0,8));
        levelTiles.add(new LevelTile(i*cellSize*8, j*cellSize*9, cellSize, type, true, false));
      }
    }
  }

  void update() {
  }

  void display() {
    for (LevelTile l : levelTiles) l.run();
  }

  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
}

class LevelTile {
  PVector pos;
  ArrayList<WallTile> wallTiles;

  int cellSize;
  int tileRows, tileColumns;

  int type;
  boolean spawnTile, hasWeaponCrate;


  LevelTile (int i, int j, int cs, int t, boolean s, boolean h) {
    pos = new PVector(i, j);
    cellSize = cs;
    tileRows = 8;
    tileColumns = 9;
    type = t;
    spawnTile = s;
    hasWeaponCrate = h;
    wallTiles = new ArrayList<WallTile>();
    addWallTiles();
    println(int(pos.x), int(pos.y));
  }

  void addWallTiles() {
    
    for (int i = 0; i < tileRows; i++) {
      for (int j = 0; j < tileColumns; j++) {
        switch(type) {           

        case 0:
          break;

        case 1:
          if (i==0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 2:
          if (j==0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 3:
          if (i==tileRows-1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 4:
          if (j==tileColumns-1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 5:
          if (i == 0 || j == tileColumns-1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 6:
          if (i == 0 || j == 0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 7:
          if (i == tileRows-1 || j==0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 8:
          if (i==tileRows - 1 || j == tileColumns-1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;         

        default:
          type = 0;
          break;
        }
      }
    }
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
    //fill(255, 0, 0);
    //rect(pos.x,pos.y,tileRows*cellSize,tileColumns*cellSize);
    for (WallTile w : wallTiles) w.run();
    //text(type, pos.x+50, pos.y+50);
    fill(255);
  }

  void run() {
    update();
    display();
  }
}
