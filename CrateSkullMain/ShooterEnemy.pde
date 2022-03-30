class ShooterEnemy extends Enemy {
  ArrayList<Bullet> bullets;
  float time, nextAttackTime = 0.5;
  float phi;
  int life;
  boolean stand = false;

  ShooterEnemy(PVector p) {
    super(p);
    bullets = new ArrayList<Bullet>();
  }

  void shoot() {
    phi = atan2(pos.y-playerPos.y, pos.x-playerPos.x)+PI;
    bullets.add(new Bullet(new PVector(pos.x, pos.y), phi, 15, color(255, 255, 0)));
  }

  void attack() {
    for (int i = bullets.size()-1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      b.run();
      if (b.isDead()) {
        bullets.remove(i);
      }
    }

    if (millis() > time+nextAttackTime*1000) {
      shoot();
      time = millis();
    }
  }

  void update() {    

    if (dist(playerPos.x, playerPos.y, pos.x, pos.y)<75) {
      stand = true;
    } else {
      stand = false;
    }

    attackRate = sin(frameCount/30+attackDisplacement);

    if (attackRate < 0.2) {
      trackPlayer();      
      if (!stand) {
        move();
      }
    }

    if (stand) {
      attack();
    }
    vel.mult(0);
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(155, 0, 155);
    circle(-25, -25, 50);
    translate(0, 0);
    popMatrix();
  }

  void run() {
    update(); 
    display();
  }
}

class Bullet {
  PVector pos, vel;
  float theta;
  float radius;
  float dir;
  color col;
  boolean hasHit = false;

  Bullet(PVector p, float a, float r, color c) {
    pos = p;
    theta = a;
    radius = r;
    col = c;
    vel = new PVector(cos(theta)*6, sin(theta)*6);
    println("spawned bullet");
  }

  boolean isDead() {
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
      return true;
    } else {
      return false;
    }
  }

  void update() {
    if (vel.x == 0 || vel.y == 0 || pos.x < width || pos.x > 0) {
      hasHit = false;
    }
    pos.add(vel);
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(col);
    circle(-radius, -radius, radius*2);
    translate(0, 0);
    popMatrix();
  }

  void run() {
    update();
    display();
  }
}
