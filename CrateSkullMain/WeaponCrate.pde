PImage box;

class WeaponCrate {
  PVector pos;
  int size;

  int lootType = 0;

  float cooldown, nextSpawnTime;
  boolean collected = false;

  WeaponCrate(PVector p, int s, float c) {
    pos = p;
    size = s;
    cooldown = c;
    box = loadImage("box.png");
  }

  boolean collideWith(Player p, float s) {

    float testX = p.pos.x;
    float testY = p.pos.y;

    if (p.pos.x < pos.x)    testX = pos.x;
    else if (p.pos.x > pos.x+size)  testX = pos.x+size;
    if (p.pos.y < pos.y)    testY = pos.y;
    else if (p.pos.y > pos.y+size)  testY = pos.y+size;

    float distX = p.pos.x-testX;
    float distY = p.pos.y-testY;
    float distance = sqrt(pow(distX, 2)+pow(distY, 2));

    if (distance <= s) {
      return true;
    } else {
      return false;
    }
  }



  void giveLoot(Player p) {

    if (!collected) {
      if (p.currentHealth != p.maxHealth) {
        lootType = int(random(0, 11));
      } else {
        lootType = int(random(3, 11));
      }


      switch(lootType) {
      case 0:
        lootType = 2;
        break;
      case 1:
        lootType = 2;
        break;      
      case 2:
        p.currentHealth = p.maxHealth;
        break;

      case 3:
        lootType = 5;
        break;
      case 4:
        lootType = 5;
        break;
      case 5:
        if (p == pz) pzGlock.currentBullets = pzGlock.maxBullets;
        if (p == p1) p1Glock.currentBullets = p1Glock.maxBullets;
        if (p == p2) p2Glock.currentBullets = p2Glock.maxBullets;
        break;

      case 6:
        lootType = 8;
        break;
      case 7:
        lootType = 8;
        break;
      case 8:
        if (p == pz) pzUZI.currentBullets = pzUZI.maxBullets;
        if (p == p1) p1UZI.currentBullets = p1UZI.maxBullets;
        if (p == p2) p2UZI.currentBullets = p2UZI.maxBullets;
        break;

      case 9:
        lootType = 10;
        break;
      case 10:
        if (p == pz) pzShotgun.currentBullets = pzShotgun.maxBullets;
        if (p == p1) p1Shotgun.currentBullets = p1Shotgun.maxBullets;
        if (p == p2) p2Shotgun.currentBullets = p2Shotgun.maxBullets;
        break;

      case 11:
        if (p == pz) pzGrenades.currentBullets = pzGrenades.maxBullets;
        if (p == p1) p1Grenades.currentBullets = p1Grenades.maxBullets;
        if (p == p2) p2Grenades.currentBullets = p2Grenades.maxBullets;
        break;

      default:
        lootType = 0;
        break;
      }
    }
  }

  void update() {
    if (collected && millis() > nextSpawnTime) {
      collected = false;
      nextSpawnTime = cooldown*1000+millis();
    }
  }

  void display() {

    if (!collected) {
      //show crate
      pushMatrix();
      translate(pos.x, pos.y);
      rect(0, 0, 40, 40);
      image(box, 0, 0);
      popMatrix();
    }
  }

  void run() {
    update();
    display();
  }
}
