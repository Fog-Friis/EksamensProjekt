PImage box;

class WeaponCrate {
  PVector pos;
  int size;

  int lootType = 0;
  float pickupNumber = 0;
  float cooldown, nextSpawnTime = 80000000;
  boolean collected = false;

  String givenLoot = "";
  float showTime;
  float textPos = height-100;

  String upgradeText = "";
  boolean glockUpgrade1, uziUpgrade1, shotgunUpgrade1, grenadeUpgrade1;
  boolean glockUpgrade2, uziUpgrade2, shotgunUpgrade2, grenadeUpgrade2;
  boolean glockUpgrade3, uziUpgrade3, shotgunUpgrade3;
  boolean upgraded;
  float upgradeShowTime = 60, upgradeTextPos = height-100;
  float combo = 0;

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
      fill(0, 255, 0);
      textMode(CENTER);
      textSize(24);
      text(givenLoot, width/2, textPos);
      textMode(CORNER);
      showTime--;
      textPos--;
    }

    if (upgraded && showTime > 0) {
      fill(0, 255, 0);
      textMode(CENTER);
      textSize(24);
      text(upgradeText, width/2, upgradeTextPos);
      textMode(CORNER);
      upgradeShowTime--;
      upgradeTextPos--;
    }
    if (upgradeShowTime < 0) {
      upgraded = false;
      upgradeShowTime = 60;
      upgradeTextPos = height - 100;
    }
  }
  void resetCrate() {
    pickupNumber = 0;
    collected = false;
    glockUpgrade1 = false;
    uziUpgrade1 = false;
    shotgunUpgrade1 = false;
    grenadeUpgrade1 = false;
    glockUpgrade2 = false;
    uziUpgrade2 = false;
    shotgunUpgrade2 = false;
    grenadeUpgrade2 = false;
    glockUpgrade3 = false;
    uziUpgrade3 = false;
    shotgunUpgrade3 = false;
    
    pzGlock.damage = pzGlockDamage;
    pzUZI.damage = pzUZIDamage; 
    pzShotgun.damage = pzShotgunDamage; 
    pzGrenades.damage = pzGrenadesDamage;
    pzGlock.fireRate = pzGlockFireRate; 
    pzUZI.fireRate = pzUZIFireRate; 
    pzShotgun.fireRate = pzShotgunFireRate;
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

    if (points >= 50 && !glockUpgrade3) {
      upgradeText = "Glock Rapid Fire!";
      pzGlock.fireRate = 400;
      upgraded = true;
      glockUpgrade3 = true;
    }

    if (points >= 100 && !glockUpgrade1) {
      upgradeText = "Glock Double Ammo!";
      pzGlock.maxBullets = 40;
      pzGlock.currentBullets = pzGlock.maxBullets;
      updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
      upgraded = true;
      glockUpgrade1 = true;
    }

    if (points >= 200 && !uziUpgrade3) {
      upgradeText = "Uzi Rapid Fire!";
      pzUZI.fireRate = 100;
      upgraded = true;
      uziUpgrade3 = true;
    }

    if (points >= 250 && !uziUpgrade1) {
      upgradeText = "UZI Double Ammo!";
      pzUZI.maxBullets = 80;
      pzUZI.currentBullets = pzUZI.maxBullets;
      updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
      upgraded = true;
      uziUpgrade1 = true;
    }
    if (points >= 400 && !shotgunUpgrade3) {
      upgradeText = "Shotgun Rapid Fire!";
      pzShotgun.fireRate = 250;
      upgraded = true;
      shotgunUpgrade3 = true;
    }
    if (points >= 500 && !shotgunUpgrade1) {
      upgradeText = "Shotgun Double Ammo!";
      pzShotgun.maxBullets = 30;
      pzShotgun.currentBullets = pzShotgun.maxBullets;
      updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
      upgraded = true;
      shotgunUpgrade1 = true;
    }
    if (points >= 1000 && !grenadeUpgrade1) {
      upgradeText = "Grenades Double Ammo!";
      pzGrenades.maxBullets = 30;
      pzGrenades.currentBullets = pzGrenades.maxBullets;
      updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
      upgraded = true;
      grenadeUpgrade1 = true;
    }

    combo = bonusMultiplier;
    if (combo >= 10 && !glockUpgrade2) {
      pzGlock.damage = 200;
    }

    if (combo >= 25 && !uziUpgrade2) {
      pzUZI.damage = 160;
    }

    if (combo >= 50 && !shotgunUpgrade2) {
      pzShotgun.damage = 100;
    }

    if (combo >= 100 && !grenadeUpgrade2) {
      pzGrenades.damage = 200;
    }
  }

  void display() {

    if (!collected) {
      showTime = 1*60;
      textPos = height-100;
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

void updateWeaponText(WeaponManager W, Weapon Glock, Weapon UZI, Weapon Shotgun, Weapon Grenades) {

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
