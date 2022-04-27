int cols, rows;

class Enemy {
  PVector pos, vel = new PVector();
  boolean up, down, left, right;
  int dir;
  int life = 10;
  float theta;
  float attackRate;
  PVector playerPos = new PVector();

  int[][] grid;
  int start, end;

  ArrayList openSet;
  ArrayList closedSet;
  ArrayList vertices;
  ArrayList path;

  ArrayList<PVector> points;

  float x1, x2, y1, y2;
  float nextFindTime = 1000, findRate = 1000;

  ArrayList<PVector> enemiesPos;

  Enemy(PVector p) {
    pos = p;

    vel = new PVector();
    points = new ArrayList<PVector>();

    openSet = new ArrayList();
    closedSet = new ArrayList();
    vertices = new ArrayList();
    path = new ArrayList();

    grid = new int[height/40][width/40];
    generateMap();

    enemiesPos = new ArrayList<PVector>();
  }
  void generateMap() {

    int q;
    Vertex v;
    for ( int ix = 0; ix < width/40.0; ix+=1 ) {
      for ( int iy = 0; iy < height/40.0; iy+=1) {
        grid[iy][ix] = 1;
        for (LevelTile l : lvl2.levelTiles) {
          for (WallTile w : l.wallTiles) {
            grid[int(w.pos.y/40)][int(w.pos.x/40)]=-1;
          }
        }
        if (grid[iy][ix] != -1) {
          vertices.add(new Vertex(ix*40, iy*40));
          grid[iy][ix] = vertices.size()-1;
          if (ix>0) {
            if (grid[iy][ix-1]!=-1) {
              v = (Vertex)vertices.get(vertices.size()-1);
              float cost = random(0.25, 2);
              v.addNeighbor((Vertex)vertices.get(grid[iy][ix-1]), cost);
              ((Vertex)vertices.get(grid[iy][ix-1])).addNeighbor(v, cost);
            }
          }
          if (iy>0) {
            if (grid[iy-1][ix]!=-1) {
              v = (Vertex)vertices.get(vertices.size()-1);
              float cost = random(0.25, 2);
              v.addNeighbor((Vertex)vertices.get(grid[iy-1][ix]), cost); 
              ((Vertex)vertices.get(grid[iy-1][ix])).addNeighbor(v, cost);
            }
          }
        }
      }
    }
  }

  boolean astar(int iStart, int iEnd) {
    float endX, endY;
    endX = ((Vertex)vertices.get(iEnd)).x;
    endY = ((Vertex)vertices.get(iEnd)).y;

    openSet.clear();
    closedSet.clear();
    path.clear();

    openSet.add((Vertex)vertices.get(iStart));
    ((Vertex)openSet.get(0)).p = -1;
    ((Vertex)openSet.get(0)).g = 0;
    ((Vertex)openSet.get(0)).h = heuristic(((Vertex)openSet.get(0)).x, ((Vertex)openSet.get(0)).y, endX, endY);

    Vertex current;
    float tentG;
    boolean tentIsPog;
    float min = 999999999;
    int lowestIndex = -1;

    while (openSet.size() > 0) {
      min = 999999999;
      for (int i = 0; i < openSet.size(); i++) {
        if (((Vertex)openSet.get(i)).g + ((Vertex)openSet.get(i)).h <= min) {
          min = ((Vertex)openSet.get(i)).g + ((Vertex)openSet.get(i)).h;
          lowestIndex = i;
        }
      }
      current = (Vertex)openSet.get(lowestIndex);

      if (current.x == endX && current.y == endY) {
        Vertex v = (Vertex)openSet.get(lowestIndex);
        while (v.p != -1) {
          path.add(v);
          v = (Vertex)vertices.get(v.p);
        }
        return true;
      }
      closedSet.add( (Vertex)openSet.get(lowestIndex));
      openSet.remove(lowestIndex);
      for (int i = 0; i < current.neighbors.size(); i++) {
        if (closedSet.contains( (Vertex)current.neighbors.get(i))) {
          continue;
        }
        tentG = current.g + heuristic(current.x, current.y, ((Vertex)current.neighbors.get(i)).x, ((Vertex)current.neighbors.get(i)).y)*(Float)current.cost.get(i);
        if (!openSet.contains((Vertex)current.neighbors.get(i))) {
          openSet.add( (Vertex)current.neighbors.get(i));
          tentIsPog = true;
        } else if (tentG < ((Vertex)current.neighbors.get(i)).g) {
          tentIsPog = true;
        } else {
          tentIsPog = false;
        }

        if (tentIsPog) {
          ((Vertex)current.neighbors.get(i)).p = vertices.indexOf((Vertex)closedSet.get(closedSet.size()-1)); //!!!!
          ((Vertex)current.neighbors.get(i)).g = tentG;
          ((Vertex)current.neighbors.get(i)).h = heuristic( ((Vertex)current.neighbors.get(i)).x, ((Vertex)current.neighbors.get(i)).y, endX, endY);
        }
      }
    }
    return false;
  }

  void findNewPath() {
    x1 = pos.x;
    y1 = pos.y;
    x2 = pz.pos.x;
    y2 = pz.pos.y;

    if (grid[int(floor(y1/40))][int(floor(x1/40))]!=-1) {
      if (start==-1) {
        start = grid[int(floor(y1/40))][int(floor(x1/40))];
      } 
      if (end==-1) {
        end = grid[int(floor(y2/40))][int(floor(x2/40))];
        if (end==start) {
          end = -1;
        }
      } else {
        start = -1;
        end = -1;
        path.clear();
      }
    }

    points.clear();
    pos = new PVector(x1, y1);
    points.add(new PVector(x1, y1));

    if (start!=-1 && end!=-1) {
      astar(start, end);
    }
  }

  void calcNewPath() {
    if (dist(pz.pos.x, pz.pos.y, pos.x, pos.y)>30) {
      findNewPath();
      addPoints();
      points.add(new PVector(floor(x2/40)*40+8, floor(y2/40)*40+8));
      nextFindTime = millis() + findRate;
    }
  }  

  void addPoints() {
    for (int i = path.size()-1; i > 0; i--) {
      Vertex v = (Vertex)path.get(i);
      points.add(new PVector(v.x+20, v.y+20));
    }
  }

  void move(PVector startPoint, PVector endPoint) {
    float theta = atan2(startPoint.y-endPoint.y, startPoint.x-endPoint.x)+PI;
    vel = new PVector(cos(theta)*6, sin(theta)*6);
  }

  boolean moved(PVector endpoint) {
    if (dist(pos.x, pos.y, endpoint.x, endpoint.y)<8) {
      return true;
    } else {
      return false;
    }
  }

  Vertex t1;
  void drawGrid() {
    for ( int i = 0; i < vertices.size(); i++ ) {
      t1 = (Vertex)vertices.get(i);
      if (i==start) {
        fill(0, 255, 0);
        //rect(t1.x, t1.y, 40, 40);
      } else if (i==end) {
        fill(255, 0, 0);
        //rect(t1.x, t1.y, 40, 40);
      } else {
        if (path.contains(t1)) {
          fill(255);
          //rect(t1.x, t1.y, 40, 40);
        } else {
          fill(200, 200, 200);
        }
      }
      noStroke();
      rect(t1.x, t1.y, 40, 40);
    }
  }

  void update() {

    if (points.size() > 1 && path.size() > 1) {
      if (!moved(points.get(1))) {
        move(points.get(0), points.get(1));
      } else {
        points.remove(0);
      }
    }
    calcNewPath();

    pos.add(vel);
    vel.mult(0);
  }

  void display() {
    //drawGrid();
    fill(255, 0, 0);
    circle(pos.x, pos.y, 40);
    /*for (int i = 0; i < points.size(); i++) {
     fill(0, 0, 255);
     circle(points.get(i).x, points.get(i).y, 4);
     fill(0, 255, 0);
     textSize(10);
     text(i, points.get(i).x, points.get(i).y);
     }*/
  }

  void run() {
    if (life > 0){ 
    update();
    display();
  }
}
}

class Vertex {
  float x, y;
  float g, h;
  int p;
  ArrayList neighbors; //array of node objects, not indecies
  ArrayList cost; //cost multiplier for each corresponding
  Vertex(float x, float y) {
    this.x = x;
    this.y = y;
    g = 0;
    h = 0;
    p = -1;
    neighbors = new ArrayList();
    cost = new ArrayList();
  }
  void addNeighbor(Vertex v, float cm) {
    neighbors.add(v);
    cost.add(new Float(cm));
  }
}

float heuristic(float x1, float x2, float y1, float y2) {
  return sqrt(abs(y2-y1)+abs(x2-x1));
}
