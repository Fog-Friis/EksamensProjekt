//bane klasse
class Level {
  ArrayList<LevelTile> levelTiles;

  //antal rækker og kolonner med leveltiles
  int rows, columns;
  //størrelsen af væggene
  int cellSize;

  //banens seed, bruges til procedural generation
  int seed;
  //om banen er synling eller ej
  int visible;

  //konstruktør
  Level(int s, int v, int cs) {
    seed = s;
    visible = v;
    cellSize = cs;
    rows = height/(cellSize*9);
    columns = width/(cellSize*8);
    levelTiles = new ArrayList<LevelTile>();
    addTiles();
  }

  //skal bruge seed til at generere bane frem for at være predifineret
  void addTiles() {
    //randomSeed(seed);
    
    
    for (int j=0; j < rows; j++) {
      for (int i=0; i < columns; i++) {

        //int type = int(random(0,8));
        
        //laver en bane med vægge yderst
        int type = 0;
        if (j == 0) {
          if (i == 0) type = 6;
          if (i > 0) type = 2;
          if (i == columns - 1) type = 7;
        }

        if (j == 1) {
          if (i == 0) type = 1;
          if (i > 0) type = 0;
          if (i == columns - 1) type = 3;
        }

        if (j == 2) {
          if (i == 0) type = 5;
          if (i > 0) type = 4;
          if (i == columns - 1) type = 8;
        }
        //type = int(random(0,8));
        
        levelTiles.add(new LevelTile(i*cellSize*8, j*cellSize*9, cellSize, type, true, false));
      }
    }
  }

  void update() {
  }
  
  //tegner tiles
  void display() {
    for (LevelTile l : levelTiles) l.run();
  }
  
  //opdaterer og tegner bane hvis den er synlig
  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
}

//laver en 8x9 walltile stor tile
class LevelTile {
  PVector pos;
  ArrayList<WallTile> wallTiles;

  //størrelsen af hver celle
  int cellSize;
  //bredde og højde af tile
  int tileRows, tileColumns;

  //angiver typen af tile, hvor: 
  //0 ingen vægge
  //1 væg til venstre
  //2 væg øverst
  //3 væg til højre
  //4 væg nederst
  //5 vægge til venstre og nederst
  //6 vægge til venstre og øverst
  //7 vægge til højre og øverst
  //8 vægge til højre og nederst
  int type;
  
  //angiver om tilen skal spawne fjender og/eller have en våbenpakke
  boolean spawnTile, hasWeaponCrate;

  //konstruktør
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
  
  //laver en tile med vægge efter type
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
    //check kollision mellem relevante spillere og vægge
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
  
  //tegner vægge
  void display() {
    for (WallTile w : wallTiles) w.run();
  }
  
  //opdatere og tegner tile
  void run() {
    update();
    display();
  }
}
