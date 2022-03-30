class Enemy {
  PVector pos, vel = new PVector();
  boolean up, down, left, right;
  int dir;
  int life;
  float theta;
  float attackRate, attackDisplacement;
  PVector playerPos = new PVector();

  Enemy(PVector p) {
    pos = p;
    attackDisplacement = random(0, 5);
  }

  /*void trackPlayer() {
    attackRate = sin(frameCount/60);
    //playerPos = player.getPos();

    if (playerPos.x - pos.x > 1) {
      right = true;
      left = false;
    } else if (playerPos.x - pos.x < -1) {
      left = true;
      right = false;
    } else {
      right = false;
      left = false;
    }
    if (playerPos.y - pos.y > 1) {
      down = true;
      up = false;
    } else if (playerPos.y - pos.y < -1) {      
      up = true;
      down = false;
    } else {
      up = false;
      down = false;
    }
  }*/

  /*void move() {
    if (up) {
      dir = 0;
      if (right) dir = 1;
      if (left) dir = 7;
    }
    if (right) {
      dir = 2;
      if (up) dir = 1;
      if (down) dir = 3;
    }
    if (down) {
      dir = 4;
      if (right) dir = 3;
      if (left) dir = 5;
    }
    if (left) {
      dir = 6;
      if (up) dir = 7;
      if (down) dir = 5;
    }
    theta = 2*dir*PI/8-PI/2;
    vel = new PVector(3*cos(theta), 3*sin(theta));    
    pos.add(vel);
    vel.mult(0);
  }*/

  void update() {    
    attackRate = sin(frameCount/30+attackDisplacement);

    if (attackRate < 0.2) {
      //trackPlayer();
      //move();
    }

    vel.mult(0);
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255, 0, 0);
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
