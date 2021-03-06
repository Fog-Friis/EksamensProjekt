class Weapon {
  int dir;
  float time2;
  int animation;
  float theta;
  int Random1, Random2;
  PVector pos = new PVector();
  PVector pos2 = new PVector();
  PVector pos3 = new PVector();
  int posx, posy;
  int localx, localy;
  int maxDistance=width, maxDistanceShutgun=500;
  int targettype;
  int maxBullets=20, currentBullets=20;
  int minDistance = 1, yDistance, xDistance;
  float fireRate;
  int enemycount;
  int damage;
  float time = 0;
  String name;
  int WeaponID;
  int playerNR;
  int Life;
  int swordSize = 60;
  int bombRange = 100, drawBombRange =0; 
  color c;
  int explosionRange = 200;
  float bombDelay = 700;
  int colorTarget1, colorTarget2, colorTargetBonus;
  boolean hasExploded = true;
  Weapon(PVector pos, int dir, int posx, int posy, int maxBullets, int currentBullets, color c, float fireRate, int damage, float time, int colorTarget1, int colorTarget2, int colorTargetBonus, int playerNR ) { //int animation, float time2, boolean hasExploded
    this.pos = pos;
    this.dir = dir;
    this.posx = posx;
    this.posy = posy;
    this.maxBullets = maxBullets;
    this.currentBullets = currentBullets;
    this.c = c;
    this.fireRate = fireRate;
    this.damage = damage;
    this.time = time;
    this.colorTarget1 = colorTarget1;
    this.colorTarget2 = colorTarget2;
    this.colorTargetBonus = colorTargetBonus;
    this.playerNR = playerNR;
    // this.animation = animation;
    // this.time2 = time2;
    // this.hasExploded = hasExploded;
  }
  void shoot() {

    if (currentBullets>0 && time < (millis()) &&!gamePaused) {
      time = millis()+fireRate;
      currentBullets -=1;
      switch(playerNR) {
      case 1:
        pos =  p1.pos.copy();
        pos3 = pos.copy();
        dir = p1.dir;
        break;
      case 2:
        pos =  p2.pos.copy();
        pos3 = pos.copy();
        dir = p2.dir;
        break;
      case 3:
        pos =  pz.pos.copy();
        pos3 = pos.copy();
        dir = pz.dir;
        break;
      }
      updatePixels();

      switch(dir) {
      case 0:
        yDistance = minDistance*-1;
        xDistance = minDistance*0;
        break;
      case 1:
        yDistance = minDistance*-1;
        xDistance = minDistance;
        break;
      case 2:
        yDistance = minDistance*0;
        xDistance = minDistance;
        break;
      case 3:
        yDistance = minDistance;
        xDistance = minDistance;
        break;
      case 4:
        yDistance = minDistance*1;
        xDistance = minDistance*0;
        break;
      case 5:
        yDistance = minDistance*1;
        xDistance = minDistance*-1;
        break;
      case 6:
        yDistance = minDistance*0;
        xDistance = minDistance*-1;
        break;
      case 7:
        yDistance = minDistance*-1;
        xDistance = minDistance*-1;
        break;
      }
      for (int i = minDistance; i <  maxDistance; i+= minDistance) {
        pos.y += yDistance;
        pos.x += xDistance;
        int posx = (int) pos.x;
        int posy = (int) pos.y;
        c = get(posx, posy);
        if ((c == colorTarget1 ) //Enemy
          || c == (colorTarget2) || //Shooter Enemy
          c == (-6908266)) { //wall
          if (c == (colorTarget1)) { //RGB(255,0,0) -65536
            targettype = 0+colorTargetBonus;
            hit();
            break;
          } else if (c == (colorTarget2)) { //RGB(255,0,10) -65526
            targettype = 1+colorTargetBonus;
            hit();
            break;
          } else {
            break; //hit the wall}
          }
        }
      }
    }
  }

  void buckshot() {
    if (currentBullets>0 && time < (millis()) &&!gamePaused) {
      time = millis()+fireRate;
      currentBullets -=1;

      switch(playerNR) {
      case 1:
        pos =  p1.pos.copy();
        pos3 = pos.copy();
        dir = p1.dir;
        break;
      case 2:
        pos =  p2.pos.copy();
        pos3 = pos.copy();
        dir = p2.dir;
        break;
      case 3:
        pos =  pz.pos.copy();
        pos3 = pos.copy();
        dir = pz.dir;
        break;
      }
      updatePixels();
      switch(dir) {
      case 0:
        yDistance = minDistance*-1;
        xDistance = minDistance*0;
        break;
      case 1:
        yDistance = minDistance*-1;
        xDistance = minDistance;
        break;
      case 2:
        yDistance = minDistance*0;
        xDistance = minDistance;
        break;
      case 3:
        yDistance = minDistance*1;
        xDistance = minDistance;
        break;
      case 4:
        yDistance = minDistance*1;
        xDistance = minDistance*0;
        break;
      case 5:
        yDistance = minDistance*1;
        xDistance = minDistance*-1;
        break;
      case 6:
        yDistance = minDistance*0;
        xDistance = minDistance*-1;
        break;
      case 7:
        yDistance = minDistance*-1;
        xDistance = minDistance*-1;
        break;
      }
      localx = xDistance;
      localy = yDistance;
      Random1 = (int) random(1, 8);
      Random2 = (int) random(1, 8);

      if (Random2 == Random1)
      {
        if (Random2 == 7) {
          Random2 = Random2-1;
        } else {
          Random2 = Random2+1;
        }
      }
      if (Random1 != 1 && Random2 != 1) {
        for (int i =minDistance; i < (maxDistanceShutgun); i+= minDistance) {
          pos.x = pos.x+(xDistance*2);
          pos.y = pos.y+(yDistance*2);
          int posx = (int) pos.x;
          int posy = (int) pos.y;
          c = get(posx, posy);
          if ((c == colorTarget1 ) //Enemy
            || c == (colorTarget2) || //Shooter Enemy
            c == (-6908266)) { //wall
            if (c == (colorTarget1)) {
              targettype = 0+colorTargetBonus;
              hit();
              break;
            } else if (c == (colorTarget2)) { //RGB(255,0,10) -65526
              targettype = 1+colorTargetBonus;
              hit();
              break;
            } else {
              break; //hit the wall}
            }
          }
        }
      } else {
      }
      pos = pos3.copy();
      xDistance = localx;
      yDistance = localy;
      updatePixels();
      if (Random1 != 2 && Random2 != 2) {
        updatePixels();
        for (int i =minDistance; i < (maxDistanceShutgun); i+= minDistance) {
          pos.x = pos.x+(xDistance*2);
          pos.y = pos.y+(yDistance*1);
          int posx = (int) pos.x;
          int posy = (int) pos.y;
          c = get(posx, posy);
          if ((c == colorTarget1 ) //Enemy
            || c == (colorTarget2) || //Shooter Enemy
            c == (-6908266)) { //wall
            if (c == (colorTarget1)) {
              targettype = 0+colorTargetBonus;
              hit();
              break;
            } else if (c == (colorTarget2)) { //RGB(255,0,10) -65526
              targettype = 1+colorTargetBonus;
              hit();
              break;
            } else {
              break; //hit the wall}
            }
          }
        }
      } else {
      }
      pos = pos3.copy();
      xDistance = localx;
      yDistance = localy;
      updatePixels();
      if (Random1 != 3 && Random2 != 3) {
        for (int i =minDistance; i < (maxDistanceShutgun); i+= minDistance) {
          pos.x = pos.x+(xDistance*1);
          pos.y = pos.y+(yDistance*2);
          int posx = (int) pos.x;
          int posy = (int) pos.y;
          c = get(posx, posy);
          if ((c == colorTarget1 ) //Enemy
            || c == (colorTarget2) || //Shooter Enemy
            c == (-6908266)) { //wall
            if (c == (colorTarget1)) {
              targettype = 0+colorTargetBonus;
              hit();
              break;
            } else if (c == (colorTarget2)) { //RGB(255,0,10) -65526
              targettype = 1+colorTargetBonus;
              hit();
              break;
            } else {
              break; //hit the wall}
            }
          }
        }
      } else {
      }
      pos = pos3.copy();
      xDistance = localx;
      yDistance = localy;
      updatePixels();
      if (Random1 != 4 && Random2 != 4) {
        for (int i =minDistance; i < (maxDistanceShutgun); i+= minDistance) {
          pos.x = pos.x+(xDistance*3);
          pos.y = pos.y+(yDistance*3);
          int posx = (int) pos.x;
          int posy = (int) pos.y;
          c = get(posx, posy);
          if ((c == colorTarget1 ) //Enemy
            || c == (colorTarget2) || //Shooter Enemy
            c == (-6908266)) { //wall
            if (c == (colorTarget1)) {
              targettype = 0+colorTargetBonus;
              hit();
              break;
            } else if (c == (colorTarget2)) { //RGB(255,0,10) -65526
              targettype = 1+colorTargetBonus;
              hit();
              break;
            } else {
              break; //hit the wall}
            }
          }
        }
      } else {
      }
      pos = pos3.copy();
      xDistance = localx;
      yDistance = localy;
      updatePixels();
      if (Random1 != 5 && Random2 != 5) {
        for (int i =minDistance; i < (maxDistanceShutgun); i+= minDistance) {
          pos.x = pos.x+(xDistance*3);
          pos.y = pos.y+(yDistance*1);
          int posx = (int) pos.x;
          int posy = (int) pos.y;
          c = get(posx, posy);
          if ((c == colorTarget1 ) //Enemy
            || c == (colorTarget2) || //Shooter Enemy
            c == (-6908266)) { //wall
            if (c == (colorTarget1)) {
              targettype = 0+colorTargetBonus;
              hit();
              break;
            } else if (c == (colorTarget2)) { //RGB(255,0,10) -65526
              targettype = 1+colorTargetBonus;
              hit();
              break;
            } else {
              break; //hit the wall}
            }
          }
        }
      } else {
      }
      pos = pos3.copy();
      xDistance = localx;
      yDistance = localy;
      updatePixels();

      if (Random1 != 6 && Random2 != 6) {
        for (int i =minDistance; i < (maxDistanceShutgun); i+= minDistance) {
          pos.x = pos.x+(xDistance*5);
          pos.y = pos.y+(yDistance*2);
          int posx = (int) pos.x;
          int posy = (int) pos.y;
          c = get(posx, posy);
          if ((c == colorTarget1 ) //Enemy
            || c == (colorTarget2) || //Shooter Enemy
            c == (-6908266)) { //wall
            if (c == (colorTarget1)) {
              targettype = 0+colorTargetBonus;
              hit();
              break;
            } else if (c == (colorTarget2)) { //RGB(255,0,10) -65526
              targettype = 1+colorTargetBonus;
              hit();
              break;
            } else {
              break; //hit the wall}
            }
          }
        }
      } else {
      }
      pos = pos3.copy();
      xDistance = localx;
      yDistance = localy;
      updatePixels();

      if (Random1 != 7 && Random2 != 7) {
        for (int i =minDistance; i < (maxDistanceShutgun); i+= minDistance) {
          pos.x = pos.x+(xDistance*4);
          pos.y = pos.y+(yDistance*5);
          int posx = (int) pos.x;
          int posy = (int) pos.y;
          c = get(posx, posy);
          if ((c == colorTarget1 ) //Enemy
            || c == (colorTarget2) || //Shooter Enemy
            c == (-6908266)) { //wall
            if (c == (colorTarget1)) {
              targettype = 0+colorTargetBonus;
              hit();
              break;
            } else if (c == (colorTarget2)) { //RGB(255,0,10) -65526
              targettype = 1+colorTargetBonus;
              hit();
              break;
            } else {
              break; //hit the wall}
            }
          }
        }
      }
    }
  }


  void swing() {
    if (time < (millis()) && !gamePaused) {
      time = millis()+fireRate;
      switch(playerNR) {
      case 1:
        pos =  p1.pos.copy();
        dir = p1.dir;
        break;
      case 2:
        pos =  p2.pos.copy();
        dir = p2.dir;
        break;

      case 3:
        pos =  pz.pos.copy();
        dir = pz.dir;
        break;
      }
      switch(dir) {
      case 0:
        yDistance = (swordSize/2)*-1;
        xDistance = (swordSize/2)*0;
        break;
      case 1:
        yDistance = (swordSize/2)*-1;
        xDistance = (swordSize/2);
        break;
      case 2:
        yDistance = (swordSize/2)*0;
        xDistance = (swordSize/2);
        break;
      case 3:
        yDistance = (swordSize/2)*1;
        xDistance = (swordSize/2);
        break;
      case 4:
        yDistance = (swordSize/2)*1;
        xDistance = (swordSize/2)*0;
        break;
      case 5:
        yDistance = (swordSize/2)*1;
        xDistance = (swordSize/2)*-1;
        break;
      case 6:
        yDistance = (swordSize/2)*0;
        xDistance = (swordSize/2)*-1;
        break;
      case 7:
        yDistance = (swordSize/2)*-1;
        xDistance = (swordSize/2)*-1;
        break;
      }
      pos.x = pos.x+xDistance;
      pos.y = pos.y+yDistance;
      targettype = 2+colorTargetBonus;
      hit();
    }
  }



  void bomb() {
    if (time < (millis()) &&!gamePaused && currentBullets>0) {
      time = millis()+fireRate;
      currentBullets -=1;
      switch(playerNR) {
      case 1:
        pos =  p1.pos.copy();
        dir = p1.dir;
        break;
      case 2:
        pos =  p2.pos.copy();
        dir = p2.dir;
        break;
      case 3:
        pos =  pz.pos.copy();
        dir = pz.dir;
        break;
      }
      updatePixels();
      switch(dir) {
      case 0:
        yDistance = minDistance*-1;
        xDistance = minDistance*0;
        break;
      case 1:
        yDistance = minDistance*-1;
        xDistance = minDistance;
        break;
      case 2:
        yDistance = minDistance*0;
        xDistance = minDistance;
        break;
      case 3:
        yDistance = minDistance*1;
        xDistance = minDistance;
        break;
      case 4:
        yDistance = minDistance*1;
        xDistance = minDistance*0;
        break;
      case 5:
        yDistance = minDistance*1;
        xDistance = minDistance*-1;
        break;
      case 6:
        yDistance = minDistance*0;
        xDistance = minDistance*-1;
        break;
      case 7:
        yDistance = minDistance*-1;
        xDistance = minDistance*-1;
        break;
      }
      drawBombRange = 0;
      for (int i = minDistance; i <=  bombRange; i+= minDistance) {
        drawBombRange += 1;
        pos.y += yDistance;
        pos.x += xDistance;
        int posx = (int) pos.x;
        int posy = (int) pos.y;
        c = get(posx, posy);
        if (c == (-6908266)) { //wall
          pos.y -= yDistance;
          pos.x -= xDistance;
          break; //hit the wall}
        }
      }
      time2 = millis()+bombDelay;
      hasExploded = false;
      animation=1;
    }
  }



  void hit() {
    switch(targettype) {
    case 0:
      enemycount = EM.Enemies.size();
      if (enemycount == 0) {
        break;
      } else {
        for (int x = 0; x <= enemycount-1; x+= 1) {
          pos2 =  EM.Enemies.get(x).pos;
          float d = pos.dist(pos2);
          if (d < 50) {
            EM.Enemies.get(x).life -= damage;

            if (EM.Enemies.get(x).life <= 0) {
              EM.Enemies.remove(x);
              pz.points();
              x = x-1;  //N??r man fjerner et element fra en arraylist bliver alle elementer indexnr med en h??jere v??rdi end den der blev fjernet minuset med 1
            } else {
            }
            enemycount = enemycount-1;
            break;
          }
        }
      }
      break;
    case 1:
      enemycount = EM.ShooterEnemies.size();
      if (enemycount == 0) {
        break;
      } else {
        for (int x = 0; x <= enemycount-1; x+= 1) {
          pos2 =  EM.ShooterEnemies.get(x).pos;

          float d = pos.dist(pos2);
          if (d <= 50) {
            EM.ShooterEnemies.get(x).life -= damage;
            if (EM.ShooterEnemies.get(x).life <= 0) {

              EM.ShooterEnemies.remove(x);
              x = x-1;
              pz.points();
            } else {
              EM.ShooterEnemies.get(x).life=Life;
            }
            break;
          }
        }
      }
      break;

    case 2:
      //Enemy
      enemycount = EM.Enemies.size();
      if (enemycount == 0) {
      } else {
        for (int x = 0; x < enemycount; x++) {
          pos2 =  EM.Enemies.get(x).pos;
          float d = pos.dist(pos2);

          if (d <= swordSize*1.5) {
            EM.Enemies.remove(x);
            pz.points();
            x -= x;
          }
          enemycount = enemycount-1;
        }
      }
      //Shooter enemy
      enemycount = EM.ShooterEnemies.size();
      if (enemycount == 0) {
      } else {
        for (int x = 0; x < enemycount; x++) {
          pos2 =  EM.ShooterEnemies.get(x).pos;
          float d = pos.dist(pos2);
          x -= x;
          if (d <= swordSize) {
            EM.ShooterEnemies.remove(x);
            pz.points();
          }
        }
      }
      break;
    case 3:
      hasExploded = true;
      animation = 0;
      enemycount = EM.Enemies.size();
      if (enemycount == 0) {
        break;
      }
      for (int x = 0; x <= enemycount-1; x+= 1) {
        pos2 =  EM.Enemies.get(x).pos;
        float d = pos.dist(pos2);
        if (d <= explosionRange) {
          int d2= (int) d;
          Life  =  EM.Enemies.get(x).life;
          Life = Life - ((explosionRange/d2)*damage); //Skaden bliver dermed mindre desto l??ngerede v??k man er granaten (Hvis fjenderne binder sig i explosion radiusen.
          if (Life <= 0) {
            pz.points();
            EM.Enemies.get(x).life=Life;
            EM.Enemies.remove(x);
            x-=1;
          } else {
            EM.Enemies.get(x).life=Life;
          }
        }
        enemycount-= 1;
      }
      //Shooter enemy
      enemycount = EM.ShooterEnemies.size();
      if (enemycount == 0) {
      } else {
        for (int x = 0; x <= enemycount; x+= 1) {
          if (enemycount == 0) {
            break;
          }
          pos2 =  EM.ShooterEnemies.get(x).pos;
          float d = pos.dist(pos2);
          if (d <= explosionRange) {
            int d2= (int) d;
            Life  =  EM.ShooterEnemies.get(x).life;
            Life = Life - ((explosionRange/d2)*damage); //Adjust damage
            if (Life <= 0) {
              pz.points();
              EM.ShooterEnemies.get(x).life=Life;
              EM.ShooterEnemies.remove(x);
              x-=1;
            } else {
              EM.ShooterEnemies.get(x).life=Life;
            }
          }
          enemycount-= 1;
        }
      }

      break;
    case 4:
      pos2 =  p2.pos;
      float d = pos.dist(pos2);
      if (d < 50) {
        p2.currentHealth -= damage;
      }
      if (p2.currentHealth <= 0) {
        scorep1 += 1;
        p2.dead();
      }
      break;
    case 5:
      pos2 =  p2.pos;
      float x = pos.dist(pos2);   //d dublicate local variable error
      if (x < 50) {
        p2.currentHealth -= damage;
      }
      if (p2.currentHealth <= 0) {
        scorep1 += 1;
        p2.dead();
      }
      break;
    case 6:
      pos2 =  p2.pos;
      float z = pos.dist(pos2);  //d dublicate local variable error
      if (z <= swordSize*1.5) {
        p2.currentHealth -= damage;
      }
      if (p2.currentHealth <= 0) {
        scorep1 += 1;
        p2.dead();
      }
      break;
    case 7:
      hasExploded = true;
      animation = 0;
      pos2 =  p2.pos;
      float c = pos.dist(pos2);  //d dublicate local variable error
      if (c <= explosionRange) {
        int c2= (int) c;
        p2.currentHealth -= ((explosionRange/c2)*damage);
      }
      if (p2.currentHealth <= 0) {
        scorep1 += 1;
        p2.dead();
      }
      break;
    case 8:
      pos2 =  p1.pos;
      float v = pos.dist(pos2);
      if (v < 50) {
        p1.currentHealth -= damage;
      }
      if (p1.currentHealth <= 0) {
        scorep2 += 1;
        p1.dead();
      }
      break;
    case 9:
      pos2 =  p1.pos;
      float b = pos.dist(pos2);
      if (b < 50) {
        p1.currentHealth -= damage;
      }
      if (p1.currentHealth <= 0) {
        scorep2 += 1;
        p1.dead();
      }
      break;
    case 10:
      pos2 =  p1.pos;
      float n = pos.dist(pos2);
      if (n <= swordSize*1.5) {
        p1.currentHealth -= damage;
      }
      if (p1.currentHealth <= 0) {
        scorep2 += 1;
        p1.dead();
      }
      break;
    case 11:
      hasExploded = true;
      animation = 0;
      pos2 =  p1.pos;
      float m = pos.dist(pos2);
      if (m <= explosionRange) {
        int m2= (int) m;
        p1.currentHealth -= ((explosionRange/m2)*damage);
      }
      if (p1.currentHealth <= 0) {
        scorep2 += 1;
        p1.dead();
      }
      break;
    }
  }

  void Display() {

    switch(animation) {
    case 0:
      break;
    case 1:
      pushMatrix();
      translate(pos.x, pos.y);
      theta = 2*dir*PI/8-PI/2;
      // rotate(theta);
      fill(5, 5, 5);
      rect(0+(xDistance*drawBombRange), 0+(yDistance*drawBombRange), 20, 20);
      popMatrix();
      break;
    }
  }
}
