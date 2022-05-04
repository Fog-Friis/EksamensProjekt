//bane klasse
class Level {
  //ArrayList<LevelTile> levelTiles;
  LevelTile[][] grid;
  LevelTile start;

  ArrayList<LevelTile> openSet, closedSet;
  ArrayList<LevelTile> tree;

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
    openSet = new ArrayList<LevelTile>();
    closedSet = new ArrayList<LevelTile>();
    tree = new ArrayList<LevelTile>();
    grid = new LevelTile[columns][rows];
    addTiles();
    start = grid[0][0];
    openSet.add(start);
    tree.add(start);
    int d = 0;
    while (tree.size() < rows*columns-1) {
      correctTiles();
      d++;
      if (d >= 100) break;
    }
  }

  //skal bruge seed til at generere bane frem for at være predifineret
  void addTiles() {
    randomSeed(seed);


    for (int j=0; j < rows; j++) {
      for (int i=0; i < columns; i++) {

        int[] types;// = int(random(0, 12));
        int type = 0;

        if (j == 0) { 
          if (i == 0) {
            types = new int[]{6, 10, 11};
            type = randomType(types);
          }
        }
        if (i == 5) {
          //type = 7 || 11 || 12
          types = new int[]{7, 11, 12};
          type = randomType(types);
        }
        if (i > 0 && i < 5) {
          //type = 2 || 6 || 7 || 10 || 11 || 12 || 14
          types = new int[]{2, 6, 7, 10, 11, 12, 14};
          type = randomType(types);
        }

        if (j == 1) {
          if (i == 0) {
            //type = 1 || 5 || 6 || 9 || 10 || 11 || 13
            types = new int[]{1, 5, 6, 9, 10, 11, 13};
            type = randomType(types);
          }
          if (i == 5) {
            //type = 3 || 7 || 8 || 9 || 11 || 12 || 13
            types = new int[]{3, 7, 8, 9, 11, 12, 13};
            type = randomType(types);
          }
          if (i > 0 && i < 5) {
            type = int(random(0, 14));
          }
        }

        if (j == 2) {
          if (i == 0) {
            //type = 5 || 9 || 10
            types = new int[]{5, 9, 10};
            type = randomType(types);
          }
          if (i == 5) {
            //type = 8 || 9 || 12
            types = new int[]{8, 9, 12};
            type = randomType(types);
          }
          if (i > 0 && i < 5) {
            //type = 4 || 5 || 8 || 9 || 10 || 12 || 14;
            types = new int[]{4, 5, 8, 9, 10, 12, 14};
            type = randomType(types);
          }
        }

        if (!tree.contains(grid[i][j])) grid[i][j] = new LevelTile(i*cellSize*8, j*cellSize*9, cellSize, type, true, false);
      }
    }
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < columns; i++) {
        grid[i][j].addNeighbors(grid);
        //openSet.add(grid[i][j]);
      }
    }
    //println(openSet.size());
    //println(grid[0][0].pos, grid[0][0].neighbors.get(0).pos, grid[0][0].neighbors.get(1).pos);
  }

  void generateTree() {
    while (openSet.size() > 0) {
      for (int i = 0; i < openSet.size(); i++) {
        for (int j = 0; j < openSet.get(i).neighbors.size(); j++) {
          if (!closedSet.contains(openSet.get(i).neighbors.get(j))) {
            checkNeighbor(openSet.get(i), openSet.get(i).neighbors.get(j));
          }
        }

        closedSet.add(openSet.get(i));
        openSet.remove(openSet.get(i));
      }
    }
  }

  int b = 0;
  //algoritme der sørger for at man kan nå hen til alle leveltiles
  void correctTiles() {
    //for (LevelTile l : tree) println(visible/3 + ": " + l.pos);

    while (tree.size() < rows*columns-1) {

      generateTree();

      seed+=1;
      addTiles();
      ;
      b++;
      if (b <= 100) break;
    }

    if (tree.size() < rows*columns-1) {
      correctTree();
    }
  }

  boolean remove = false;
  void correctTree() {
    for (int i = 0; i < tree.size(); i++) {
      for (int j = 0; j < tree.get(i).neighbors.size(); j++) {
        if (!tree.contains(tree.get(i).neighbors.get(j))) {
          remove = true;
        }
      }
      if (remove) {
        tree.remove(tree.get(i));
        remove = false;
      }
    }
  }



  void checkNeighbor(LevelTile tile, LevelTile neighbor) {
    if (neighbor.pos.x > tile.pos.x) {
      if (tile.openRight && neighbor.openLeft) {
        if (!tree.contains(neighbor)) tree.add(neighbor);
        openSet.add(neighbor);
      }
    }
    if (neighbor.pos.x < tile.pos.x) {
      if (tile.openLeft && neighbor.openRight) {
        if (!tree.contains(neighbor)) tree.add(neighbor);
        openSet.add(neighbor);
      }
    }
    if (neighbor.pos.y > tile.pos.y) {
      if (tile.openBottom && neighbor.openTop) {
        if (!tree.contains(neighbor)) tree.add(neighbor);
        openSet.add(neighbor);
      }
    }
    if (neighbor.pos.y < tile.pos.y) {
      if (tile.openTop && neighbor.openBottom) {
        if (!tree.contains(neighbor)) tree.add(neighbor);
        openSet.add(neighbor);
      }
    }
  }

  void update() {
  }

  //tegner tiles
  void display() {
    //for (LevelTile l : levelTiles) l.run();
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j].run();
      }
    }
  }

  //opdaterer og tegner bane hvis den er synlig
  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
}

int randomType(int[] n) {
  return n[int(random(0, n.length))];
}

//laver en 8x9 walltile stor tile
class LevelTile {
  PVector pos;
  ArrayList<WallTile> wallTiles;
  ArrayList<LevelTile> neighbors;

  //størrelsen af hver celle
  int cellSize;
  //bredde og højde af tile
  int tileRows, tileColumns;

  int rows;
  int columns;

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

  boolean openTop, openBottom, openLeft, openRight;

  //angiver om tilen skal spawne fjender og/eller have en våbenpakke
  boolean spawnTile, hasWeaponCrate;

  //konstruktør
  LevelTile (int i, int j, int cs, int t, boolean s, boolean h) {
    pos = new PVector(i, j);
    cellSize = cs;
    tileRows = 8;
    tileColumns = 9;
    rows = height/(cellSize*9);
    columns = width/(cellSize*8);
    type = t;
    spawnTile = s;
    hasWeaponCrate = h;
    wallTiles = new ArrayList<WallTile>();
    neighbors = new ArrayList<LevelTile>();
    openTop = true;
    openBottom = true;
    openLeft = true; 
    openRight = true;

    addWallTiles();
  }

  void addNeighbors(LevelTile[][] g) {
    int i = int(pos.x/(cellSize*8));
    int j = int(pos.y/(cellSize*9));
    if (i > 0) neighbors.add(g[i-1][j]);
    if (i < columns - 1 ) neighbors.add(g[i+1][j]);
    if (j > 0) neighbors.add(g[i][j-1]);
    if (j < rows - 1 ) neighbors.add(g[i][j+1]);
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
          openLeft = false;
          break;

        case 2:
          if (j==0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openTop = false;
          break;

        case 3:
          if (i==tileRows - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openRight = false;
          break;

        case 4:
          if (j==tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openBottom = false;
          break;

        case 5:
          if (i == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openLeft = false;
          openBottom = false;
          break;

        case 6:
          if (i == 0 || j == 0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openLeft = false;
          openTop = false;
          break;

        case 7:
          if (i == tileRows - 1 || j==0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openRight = false;
          openTop = false;
          break;

        case 8:
          if (i==tileRows - 1 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openRight = false;
          openBottom = false;
          break;         

        case 9:
          if (i == 0 || i == tileRows - 1 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openRight = false;
          openLeft = false;
          openBottom = false;
          break;

        case 10:
          if (i == 0 || j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openTop = false;
          openLeft = false;
          openBottom = false;
          break;

        case 11:
          if (i == 0 || i == tileRows - 1 || j == 0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openTop = false;
          openLeft = false;
          openRight = false;
          break;

        case 12:
          if (i == tileRows - 1 || j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openTop = false;
          openRight = false;
          openBottom = false;
          break;

        case 13:
          if (i == 0 || i == tileRows - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openRight = false;
          openLeft = false;
          break;

        case 14:
          if (j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          openTop = false;
          openBottom = false;
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
        if (w.collision(p.pos, p.radius)) {
          if (w.isUp(p.pos)) {
            p.pos.y = w.pos.y - p.radius;
          } else if (w.isDown(p.pos)) {
            p.pos.y = w.pos.y + w.size + p.radius;
          }
          if (w.isLeft(p.pos)) {
            p.pos.x = w.pos.x - p.radius;
          } else if (w.isRight(p.pos)) {
            p.pos.x = w.pos.x + w.size + p.radius;
          }
        }
      }
      for (Enemy e : EM.Enemies) {
        PVector displace = new PVector(e.vel.x, e.vel.y);
        if (w.collision(e.pos, e.radius)) {
          //e.vel.mult(0);
          if (w.isUp(e.pos)) {
            e.pos.y = w.pos.y - e.radius - displace.y;
          } else if (w.isDown(e.pos)) {
            e.pos.y = w.pos.y + w.size + e.radius + displace.y;
          }
          if (w.isLeft(e.pos)) {
            e.pos.x = w.pos.x - e.radius - displace.x;
          } else if (w.isRight(e.pos)) {
            e.pos.x = w.pos.x + w.size + e.radius + displace.x;
          }
        }
      }
      for (ShooterEnemy s : EM.ShooterEnemies) {
        //kollision mellem shooterenemy og væg
        for (Bullet b : s.bullets) {
          //fjern bullet når den rammer væg
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
