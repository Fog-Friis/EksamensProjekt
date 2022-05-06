//bane klasse
class Level {
  ArrayList<LevelTile> levelTiles;
  //LevelTile[][] grid;
  //LevelTile start;

  //ArrayList<LevelTile> openSet, closedSet;
  //ArrayList<LevelTile> tree;
  ArrayList<PVector> points, openSet;
  ArrayList<Connection> cons;
  PVector newPoint, current;

  boolean[] openTop, openBottom, openLeft, openRight;

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
    levelTiles = new ArrayList<LevelTile>();
    rows = height/(cellSize*9);
    columns = width/(cellSize*8);
    points = new ArrayList<PVector>();
    addPoints();
    openSet = new ArrayList<PVector>();
    cons = new ArrayList<Connection>();
    openSet.add(points.get(0));
    openTop = new boolean[points.size()];
    openBottom = new boolean[points.size()];
    openLeft = new boolean[points.size()];
    openRight = new boolean[points.size()];
    randomSeed(seed);
  }

  void addPoints() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        points.add(new PVector(40*8*i+40*4, 40*9*j+40*4.5));
      }
    }
  }

  void drawGrid() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        fill(255);
        rect(40*8*i, 40*9*j, 40*8, 40*9);
      }
    }
  }

  ArrayList<PVector> neighbors(PVector p) {
    ArrayList<PVector> returns = new ArrayList<PVector>();

    for (PVector o : points) {
      if (o.x == p.x) {
        if (o.y == p.y + cellSize*9) {
          returns.add(o);
        }
        if (o.y == p.y - cellSize*9) {
          returns.add(o);
        }
      }
      if (o.y == p.y) {
        if (o.x == p.x + cellSize*8) {
          returns.add(o);
        }
        if (o.x == p.x - cellSize*8) {
          returns.add(o);
        }
      }
    }
    return returns;
  }

  boolean Stuck(PVector p) {
    int nCounter = 0;
    ArrayList<PVector> neighbors = neighbors(p);
    for (PVector o : neighbors) {
      if (openSet.contains(o)) {
        nCounter++;
      }
    }
    if (nCounter == neighbors.size()) {
      return true;
    } else {
      return false;
    }
  }

  void drawGraph() {

    for (int i = 0; i < points.size(); i++) {
      openRight[i] = false;
      openLeft[i] = false;
      openBottom[i] = false;
      openTop[i] = false;
    }

    while (openSet.size() < points.size()) {
      current = openSet.get(openSet.size()-1);

      while (Stuck(current)) {
        current = openSet.get(int(random(0, openSet.size()-1)));
      }

      ArrayList<PVector> neighbors = neighbors(current);
      //println(neighbors.size());
      newPoint = neighbors.get(int(random(0, neighbors.size())));
      if (!openSet.contains(newPoint)) {
        openSet.add(newPoint);
      }

      cons.add(new Connection(current, newPoint));
    }

    for (PVector p : openSet) {
      if (p == openSet.get(openSet.size()-1)) {
        fill(255, 0, 0);
      } else {
        fill(255);
      }
      circle(p.x, p.y, 10);
    }
    for (Connection c : cons) {
      c.display();
    }
  }
  void generateLevel() {
    for (int i = 0; i < points.size(); i++) {
      levelTiles.add(new LevelTile(int(points.get(i).x-4*cellSize), int(points.get(i).y-4.5*cellSize), cellSize));
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
  int type = 0;

  boolean openTop, openBottom, openLeft, openRight;

  //angiver om tilen skal spawne fjender og/eller have en våbenpakke
  boolean spawnTile, hasWeaponCrate;

  //konstruktør
  LevelTile (int i, int j, int cs) {
    pos = new PVector(i, j);
    cellSize = cs;
    tileRows = 8;
    tileColumns = 9;
    rows = height/(cellSize*9);
    columns = width/(cellSize*8);
    spawnTile = true;
    hasWeaponCrate = false;
    wallTiles = new ArrayList<WallTile>();
    neighbors = new ArrayList<LevelTile>();
    type = setType();
    addWallTiles();
  }

  int setType() {

    int type = 0;

    color cUp, cDown, cLeft, cRight;

    cUp = get(int(pos.x + 4*cellSize), int(pos.y + 4.5*cellSize - 20));
    cDown = get(int(pos.x + 4*cellSize), int(pos.y + 4.5*cellSize + 20));
    cLeft = get(int(pos.x + 4*cellSize - 20), int(pos.y + 4.5*cellSize));
    cRight = get(int(pos.x + 4*cellSize + 20), int(pos.y + 4.5*cellSize));

    if (cUp == -16777216) {
      openTop = true;
    } else {
      openTop = false;
    }
    if (cDown == -16777216) {
      openBottom = true;
    } else {
      openBottom = false;
    }
    if (cLeft == -16777216) {
      openLeft = true;
    } else {
      openLeft = false;
    }
    if (cRight == -16777216) {
      openRight = true;
    } else {
      openRight = false;
    }

    if (openTop  && openBottom  && openRight  && openLeft)  type = 0; //println(0);
    if (openTop  && openBottom  && openRight  && !openLeft) type = 1; //println(1);
    if (!openTop && openBottom  && openRight  && openLeft)  type = 2; //println(2);
    if (openTop  && openBottom  && !openRight && openLeft)  type = 3; //println(3);
    if (openTop  && !openBottom && openRight  && openLeft)  type = 4; //println(4);
    if (openTop  && !openBottom && !openRight && openLeft)  type = 8; //println(5);
    if (!openTop && openBottom  && !openRight && openLeft)  type = 7; //println(6);
    if (!openTop && openBottom  && openRight  && !openLeft) type = 6; //println(7);
    if (openTop  && !openBottom && openRight  && !openLeft) type = 5; //println(8);
    if (openTop  && !openBottom && !openRight && !openLeft) type = 9; //println(9);
    if (!openTop && !openBottom && openRight  && !openLeft) type = 10; //println(10);
    if (!openTop && openBottom  && !openRight && !openLeft) type = 11; //println(11);
    if (!openTop && !openBottom && !openRight && openLeft)  type = 12; //println(12);
    if (openTop  && openBottom  && !openRight && !openLeft) type = 13; //println(13);
    if (!openTop && !openBottom && openRight  && openLeft)  type = 14; //println(14);
    return type;
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
          if (i==tileRows - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 4:
          if (j==tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 5:
          if (i == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 6:
          if (i == 0 || j == 0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 7:
          if (i == tileRows - 1 || j==0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 8:
          if (i==tileRows - 1 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;         

        case 9:
          if (i == 0 || i == tileRows - 1 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 10:
          if (i == 0 || j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 11:
          if (i == 0 || i == tileRows - 1 || j == 0) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 12:
          if (i == tileRows - 1 || j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 13:
          if (i == 0 || i == tileRows - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
          break;

        case 14:
          if (j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(int(pos.x)+i*cellSize, int(pos.y)+j*cellSize, cellSize));
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
        PVector displace = new PVector(s.vel.x, s.vel.y);
        if (w.collision(s.pos, s.radius)) {
          //s.vel.mult(0);
          if (w.isUp(s.pos)) {
            s.pos.y = w.pos.y - s.radius - displace.y;
          } else if (w.isDown(s.pos)) {
            s.pos.y = w.pos.y + w.size + s.radius + displace.y;
          }
          if (w.isLeft(s.pos)) {
            s.pos.x = w.pos.x - s.radius - displace.x;
          } else if (w.isRight(s.pos)) {
            s.pos.x = w.pos.x + w.size + s.radius + displace.x;
          }
        }
        for (Bullet b : s.bullets) {
          //fjern bullet når den rammer væg
          if (w.collision(b.pos, b.radius)) {
            b.pos = new PVector(2*width, 2*height);
          }
        }
      }
    }
  }

  PVector getSpawnPoint() {
    if (spawnTile) {
      return new PVector(pos.x+4*cellSize, pos.y+4.5*cellSize);
    } else {
      return null;
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

class Connection {
  PVector current, newPoint;
  Connection(PVector c, PVector nP) {
    current = c;
    newPoint = nP;
  }
  void display() {
    line(current.x, current.y, newPoint.x, newPoint.y);
  }
}
