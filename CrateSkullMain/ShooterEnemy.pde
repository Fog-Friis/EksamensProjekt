class ShooterEnemy extends Enemy {
  ArrayList<Bullet> bullets;
  float time, nextAttackTime = 1;
  float phi;
  int life;
  float attackRange;

  ShooterEnemy(PVector p, float s, float aR) {
    super(p, s);
    attackRange = aR;
    bullets = new ArrayList<Bullet>();
  }

  void shoot() {
    phi = atan2(pz.pos.y-pos.y, pz.pos.x-pos.x);    
    bullets.add(new Bullet(new PVector(pos.x, pos.y), phi, 25, color(255, 255, 0)));
  }

  void attack() {
    //phi = atan2(pz.pos.y-pos.y, pz.pos.x-pos.x) + PI;
    if (millis() > time+nextAttackTime*1000) {
      shoot();
      time = millis();
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
    calcNewPath(pz.radius+radius+attackRange);
    if (inAttackRange(pz.radius+radius+attackRange)) {
      attack();
    }
    for (int i = bullets.size()-1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      b.run();
      if (b.hitPlayer()){
        pz.takeDamage(20);
      }
      if (b.isDead()) {
        bullets.remove(i);
      }
    }

    pos.add(vel);
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(155, 0, 155);
    circle(0, 0, 2*radius);
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
  float angle;
  float radius;
  float dir;
  color col;
  boolean hasHit = false;

  Bullet(PVector p, float a, float r, color c) {
    pos = p;
    angle = a;
    radius = r;
    col = c;
    vel = new PVector(cos(angle)*6, sin(angle)*6);
  }

  boolean hitPlayer() {
    if (dist(pz.pos.x, pz.pos.y, pos.x, pos.y) <= pz.radius+radius) {
      return true;
    } else {
      return false;
    }
  }

  boolean isDead() {
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0 || hitPlayer()) {
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
    fill(255, 255, 0);
    circle(0, 0, radius*2);
    translate(0, 0);
    popMatrix();
  }

  void run() {
    update();
    display();
  }
}
