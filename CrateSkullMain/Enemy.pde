int cols, rows;

class Enemy {
  PVector pos, vel = new PVector();
  boolean up, down, left, right;
  int dir;
  int life;
  float theta;
  float attackRate, attackDisplacement;
  PVector playerPos = new PVector();

  Vertex[][] grid;
  ArrayList<Vertex> openSet, closedSet;
  Vertex start, end;
  ArrayList<Vertex> path;

  ArrayList<PVector> points;

  float nextFindTime = 5*60, pathFindRate = 5*60;

  Enemy(PVector p) {
    pos = p;
    attackDisplacement = random(0, 5);

    grid = new Vertex[cols][rows];    

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = new Vertex(i, j);
      }
    }

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j].addNeighbors(grid);
      }
    }

    openSet = new ArrayList<Vertex>();
    closedSet = new ArrayList<Vertex>();

    start = grid[int(pos.x/40)][int(pos.y/40)];
    //lige nu nederst til højre, skal være playerens position.
    end = grid[cols-2][rows-2];

    openSet.add(start);

    path = new ArrayList<Vertex>();
    points = new ArrayList<PVector>();
    trackPlayer();
    addPoints();
  }

  //pathfinding algorithme med a* algorithm    
  void trackPlayer() {
    while (openSet.size() > 0) {
      //keep going
      int lowestIndex = 0;

      for (int i = 0; i < openSet.size(); i++) {
        if (openSet.get(i).f < openSet.get(lowestIndex).f) {
          lowestIndex = i;
        }
      }
      Vertex current = openSet.get(lowestIndex);

      if (current == end) {
        //find path
        Vertex temp = current;
        path.add(temp);
        while (temp.cameFrom != null) {
          path.add(temp.cameFrom);
          temp = temp.cameFrom;
        }

        //println("done");
        break;
      }

      openSet.remove(current);
      closedSet.add(current);

      ArrayList<Vertex> neighbors = current.neighbors;
      for (int i = 0; i < neighbors.size(); i++) {
        Vertex neighbor = neighbors.get(i);

        if (!closedSet.contains(neighbor) && !neighbor.wall) {
          float tempG = current.g+1;

          boolean newPath = false;
          if (openSet.contains(neighbor)) {
            if (tempG < neighbor.g) {
              neighbor.g = tempG;
              newPath = true;
            }
          } else {
            neighbor.g = tempG;
            newPath = true;
            openSet.add(neighbor);
          }

          if (newPath) {
            neighbor.h = heuristic(neighbor, end);
            neighbor.f = neighbor.g + neighbor.f;
            neighbor.cameFrom = current;
          }
        }
      }
    }
  }

  void findNewPath() {
    closedSet.clear();
    openSet.clear();
    path.clear();
    points.clear();
    start = grid[int(pos.x/40)][int(pos.y/40)];
    end = grid[int(pz.pos.x/40)][int(pz.pos.y/40)];
    openSet.add(start);
    //trackPlayer();
    addPoints();
  }

  void addPoints() {
    for (int i = path.size()-1; i > 0; i--) {
      points.add(new PVector(path.get(i).i*40+20, path.get(i).j*40+20));
    }
  }

  void move(PVector startPoint, PVector endPoint) {
    float theta = atan2(startPoint.y-endPoint.y, startPoint.x-endPoint.x)+PI;
    vel = new PVector(cos(theta)*6, sin(theta)*6);
  }

  boolean moved(PVector endpoint) {
    if (dist(pos.x, pos.y, endpoint.x, endpoint.y)<5) {
      return true;
    } else {
      return false;
    }
  }
  
  //boolean bruh;
  
  void update() {
    if (nextFindTime <= frameCount) {
      /*bruh = !bruh;
      println(bruh);*/
      findNewPath();
      nextFindTime = frameCount + pathFindRate;      
    }
    if (points.size() > 1) {
      if (!moved(points.get(1))) {
        move(points.get(0), points.get(1));
      } else {
        points.remove(0);
        path.remove(path.size()-1);
      }

      pos.add(vel);
      vel.mult(0);
    }
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255, 0, 10);
    rotate(theta);
    rect(-20, -20, 40, 40);
    translate(0, 0);
    popMatrix();
  }

  void run() {
    update();
    display();
  }
}

float heuristic(Vertex a, Vertex b) {
  float d = dist(a.i, a.j, b.i, b.j);
  //float d = abs(a.i-b.i) + abs(a.j-b.j);  
  return d;
}

class Vertex {
  int i, j;
  float f, g, h;
  boolean wall;

  ArrayList<Vertex> neighbors;
  Vertex cameFrom;

  Vertex(int i, int j) {
    this.i = i;
    this.j = j;
    f = 0;
    g = 0;
    h = 0;
    neighbors = new ArrayList<Vertex>();
    wall = false;
  }

  void addNeighbors(Vertex[][] g) {
    int i = this.i;
    int j = this.j;
    if (i < cols-1)               neighbors.add(g[i+1][j]);
    if (i > 0)                    neighbors.add(g[i-1][j]);    
    if (j < rows - 1)             neighbors.add(g[i][j+1]);   
    if (j > 0)                    neighbors.add(g[i][j-1]);
    if (i > 0 && j > 0)           neighbors.add(g[i-1][j-1]);
    if (i < cols-1 && j > 0)      neighbors.add(g[i+1][j-1]);
    if (i > 0 && j < rows-1)      neighbors.add(g[i-1][j+1]);
    if (i < cols-1 && j < rows-1) neighbors.add(g[i+1][j+1]);
  }
}
