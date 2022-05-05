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

  boolean[] openTop, openLeft, openBottom, openRight;

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
    openTop = new boolean[points.size()];
    openBottom = new boolean[points.size()];
    openLeft = new boolean[points.size()];
    openRight = new boolean[points.size()];
    openSet.add(points.get(0));
    createGraph();
    generateLevel();
    addTiles();
  }

  void addPoints() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        points.add(new PVector(8*cellSize*i+4*cellSize, 9*cellSize*j+4.5*cellSize));
      }
    }
  }

  ArrayList<PVector> neighbors(PVector p) {
    ArrayList<PVector> returns = new ArrayList<PVector>();
    for (PVector o : points) {
      if (o.x == p.x) {
        if (o.y == p.y + 40*9) {
          returns.add(o);
        }
        if (o.y == p.y - 40*9) {
          returns.add(o);
        }
      }
      if (o.y == p.y) {
        if (o.x == p.x + 40*8) {
          returns.add(o);
        }
        if (o.x == p.x - 40*8) {
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

  void createGraph() {
    randomSeed(seed);
    int i = 0;
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

      if (!cons.contains(new Connection(current, newPoint)) && !cons.contains(new Connection(newPoint, current))) cons.add(new Connection(current, newPoint));
    }
    //for (Connection c : cons) println(visible/3, c.current, c.newPoint);
  }

  void generateLevel() {
    
    //println(cons.size());
    for (int i = 0; i < points.size(); i++) {
      PVector p = openSet.get(i);
      openRight[i] = false;
      openLeft[i] = false;
      openBottom[i] = false;
      openTop[i] = false;
      ArrayList<PVector> neighbors = neighbors(p);
      for (PVector n : neighbors) {
        Connection check = new Connection(p, n);
        //println(visible/3, check.current, check.newPoint);
        
        if (cons.contains(check)) {
          if (n.x > p.x) openRight[i] = true;
          if (n.x < p.x) openLeft[i] = true;
          if (n.y > p.y) openBottom[i] = true;
          if (n.y < p.y) openTop[i] = true;
          //println(i, openRight[i], openLeft[i], openBottom[i], openTop[i]);
        }
      }
    }
    for (Connection c : cons)println(c.current, c.newPoint);
  }
  
  //skal bruge seed til at generere bane frem for at være predifineret
  void addTiles() {
    //randomSeed(seed);
    int type = 0;

    for (int i = 0; i < points.size(); i++) {
      //println(openTop[i], openBottom[i], openRight[i], openLeft[i]);
      if (openTop[i]  && openBottom[i]  && openRight[i]  && openLeft[i])  type = 0; //println(0);
      if (openTop[i]  && openBottom[i]  && openRight[i]  && !openLeft[i]) type = 1; //println(1);
      if (!openTop[i] && openBottom[i]  && openRight[i]  && openLeft[i])  type = 2; //println(2);
      if (openTop[i]  && openBottom[i]  && !openRight[i] && openLeft[i])  type = 3; //println(3);
      if (openTop[i]  && !openBottom[i] && openRight[i]  && openLeft[i])  type = 4; //println(4);
      if (openTop[i]  && !openBottom[i] && !openRight[i] && openLeft[i])  type = 5; //println(5);
      if (!openTop[i] && openBottom[i]  && !openRight[i] && openLeft[i])  type = 6; //println(6);
      if (!openTop[i] && openBottom[i]  && openRight[i]  && !openLeft[i]) type = 7; //println(7);
      if (openTop[i]  && !openBottom[i] && openRight[i]  && !openLeft[i]) type = 8; //println(8);
      if (openTop[i]  && !openBottom[i] && !openRight[i] && !openLeft[i]) type = 9; //println(9);
      if (!openTop[i] && !openBottom[i] && openRight[i]  && !openLeft[i]) type = 10; //println(10);
      if (!openTop[i] && openBottom[i]  && !openRight[i] && !openLeft[i]) type = 11; //println(11);
      if (!openTop[i] && !openBottom[i] && !openRight[i] && openLeft[i])  type = 12; //println(12);
      if (openTop[i]  && openBottom[i]  && !openRight[i] && !openLeft[i]) type = 13; //println(13);
      if (!openTop[i] && !openBottom[i] && openRight[i]  && openLeft[i])  type = 14; //println(14);
      //println(type);
      levelTiles.add(new LevelTile(int(points.get(i).x-4*cellSize), int(points.get(i).y-4.5*cellSize), cellSize, type, true, false));
    }
  }

  void update() {
  }

  //tegner tiles
  void display() {
    for (LevelTile l : levelTiles) l.run();
    //for (LevelTile l : levelTiles) println(l.type);    
    //for (Connection c: cons) c.display();
    
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

class Connection {
  PVector current, newPoint;
  Connection(PVector c, PVector nP) {
    current = c;
    newPoint = nP;
  }
  
  void display(){
    line(current.x, current.y, newPoint.x, newPoint.y);
  }
}
