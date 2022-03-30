class WallTile {
  PVector pos;
  int size;
  ArrayList<PVector> playerPos;
  boolean loaded;

  WallTile(int i, int j, int s) {
    pos = new PVector(i, j);
    size = s;
    playerPos = new ArrayList<PVector>();

    for (Player pl : players) playerPos.add(pl.getPos());
  }

  boolean isUp(PVector p) {
    if (p.x >= pos.x && p.x <= pos.x + size && p.y<=pos.y) {
      return true;
    } else {
      return false;
    }
  }

  boolean isDown(PVector p) {
    if (p.x >= pos.x && p.x <= pos.x + size && p.y>=pos.y+size) {
      return true;
    } else {
      return false;
    }
  }

  boolean isLeft(PVector p) {
    if (p.y >= pos.y && p.y <= pos.y + size && p.x <= pos.x) {
      return true;
    } else {
      return false;
    }
  }

  boolean isRight(PVector p) {
    if (p.y+10 >= pos.y && p.y - 10<= pos.y + size && p.x >= pos.x + size) {
      return true;
    } else {
      return false;
    }
  }

  boolean collision(PVector p) {
    float testX = p.x;
    float testY = p.y;

    if (p.x < pos.x)    testX = pos.x;
    else if (p.x > pos.x+size)  testX = pos.x+size;
    if (p.y < pos.y)    testY = pos.y;
    else if (p.y > pos.y+size)  testY = pos.y+size;

    float distX = p.x-testX;
    float distY = p.y-testY;
    float distance = sqrt(pow(distX, 2)+pow(distY, 2));

    if (distance <= 25) {
      return true;
    } else {
      return false;
    }
  }


  void update() {
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(150);
    rect(0, 0, size, size);
    fill(255);
    popMatrix();
  }

  void run() {
    update();
    display();
  }
}
