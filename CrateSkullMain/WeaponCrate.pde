PImage box;

class WeaponCrate {
  PVector pos;
  int size;

  int lootType = 0;
  float pickupNumber = 0;
  float cooldown, nextSpawnTime = 80000000;
  boolean collected = false;

  String givenLoot = "";
  float stopShowTime, showTime;

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

  void updateWeaponText(WeaponManager W, Weapon Glock, Weapon UZI, Weapon Shotgun, Weapon Grenades) {
    println(W.WeaponID);

    switch(W.WeaponID) {
    case 1:
      W.WeaponText = W.WeaponName1+" "+Glock.currentBullets+"/"+Glock.maxBullets;
      break;

    case 2:
      W.WeaponText = W.WeaponName2+" "+UZI.currentBullets+"/"+UZI.maxBullets;  
      break;

    case 3:
      W.WeaponText = W.WeaponName3+" "+Shotgun.currentBullets+"/"+Shotgun.maxBullets;  
      break;

    case 4:
      W.WeaponText = W.WeaponName4;
      break;

    case 5:
      W.WeaponText = W.WeaponName5+" "+Grenades.currentBullets+"/"+Grenades.maxBullets;
      break;
    }
  }

  void giveLoot(Player p) {
    if (!collected) {
      if (p.currentHealth != p.maxHealth) {
        lootType = int(random(0, 4));
      } else {
        lootType = int(random(1, 4));
      }

      switch(lootType) {
      case 0:
        givenLoot = "Health Restored!";
        p.currentHealth = p.maxHealth;
        break;

      case 1:
        givenLoot = "Picked Up Glock Ammo!";
        if (p == pz) { 
          pzGlock.currentBullets = pzGlock.maxBullets;
          updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
        }
        if (p == p1) {
          p1Glock.currentBullets = p1Glock.maxBullets;
          updateWeaponText(WPMp1, p1Glock, p1UZI, p1Shotgun, p1Grenades);
        }
        if (p == p2) {
          p2Glock.currentBullets = p2Glock.maxBullets;
          updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
        }
        break;

      case 2:
        givenLoot = "Picked Up UZI ammo!";
        if (p == pz) {
          pzUZI.currentBullets = pzUZI.maxBullets;
          updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
        }
        if (p == p1) {
          p1UZI.currentBullets = p1UZI.maxBullets;
          updateWeaponText(WPMp1, p1Glock, p1UZI, p1Shotgun, p1Grenades);
        }
        if (p == p2) {
          p2UZI.currentBullets = p2UZI.maxBullets;
          updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
        }
        break;

      case 3:
        givenLoot = "Picked Up Shotgun Ammo!";
        if (p == pz) {
          pzShotgun.currentBullets = pzShotgun.maxBullets;
          updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
        }
        if (p == p1) {
          p1Shotgun.currentBullets = p1Shotgun.maxBullets;
          updateWeaponText(WPMp1, p1Glock, p1UZI, p1Shotgun, p1Grenades);
        }
        if (p == p2) {
          p2Shotgun.currentBullets = p2Shotgun.maxBullets;
          updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
        }
        break;

      case 4:
        givenLoot = "Picked Up Grenade Ammo";
        if (p == pz) {
          pzGrenades.currentBullets = pzGrenades.maxBullets;
          updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
        }
        if (p == p1) {
          p1Grenades.currentBullets = p1Grenades.maxBullets;
          updateWeaponText(WPMp1, p1Glock, p1UZI, p1Shotgun, p1Grenades);
        }
        if (p == p2) {
          p2Grenades.currentBullets = p2Grenades.maxBullets;
          updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
        }
        break;

      default:
        lootType = 0;
        break;
      }
    }
  }

  void showLootText() {
    if (collected && showTime > 0) {
      fill(0,255,0);
      textMode(CENTER);
      textSize(24);
      text(givenLoot, width/2, height-100);
      textMode(CORNER);
      showTime--;
    }
  }

  void update() {
    if (collected && pickupNumber == 0) {
      nextSpawnTime = cooldown*1000+millis();
      pickupNumber++;
    }

    if (collected && millis() > nextSpawnTime) {
      collected = false;
      nextSpawnTime = cooldown*1000+millis();
    }
  }

  void display() {

    if (!collected) {
      showTime = 2*60;
      //show crate
      pushMatrix();
      translate(pos.x, pos.y);
      rect(0, 0, 40, 40);
      image(box, 0, 0);
      popMatrix();
    }
    showLootText();
  }

  void run() {
    update();
    display();
  }
}
