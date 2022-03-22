class WallTile {
  PVector pos;
  int size;
  ArrayList<PVector> playerPos;
  WallTile(PVector p) {
    pos = p;
    playerPos = new ArrayList<PVector>();

    for (Player pl : players) playerPos.add(pl.getPos());
  }

  boolean isUp(PVector p) {
    if (p.x >= pos.x && p.x <= pos.x + size && p.y < pos.y) {
      return true;
    } else {
      return false;
    }
  }

  boolean isDown(PVector p) {
    if (p.x >= pos.x && p.x <= pos.x + size && p.y > pos.y + size) {
      return true;
    } else {
      return false;
    }
  }

  boolean isLeft(PVector p) {
    if (p.y >= pos.y && p.y <= pos.y + size && p.x < pos.x) {
      return true;
    } else {
      return false;
    }
  }

  boolean isRight(PVector p) {
    if (p.y >= pos.y && p.y <= pos.y + size && p.x > pos.x + size) {
      return true;
    } else {
      return false;
    }
  }

  void update() {
  }

  void display() {
    pushMatrix();
    translate(pos.y, pos.x);
    fill(0);
    rect(0, 0, size, size);
    popMatrix();
  }

  void run() {
    update();
    display();
  }
}
