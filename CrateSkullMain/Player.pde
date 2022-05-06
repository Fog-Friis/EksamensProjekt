class Player {
  PVector pos, vel = new PVector(); 
  int upKey, downKey, leftKey, rightKey, shootKey, changeKey;
  int dir;
  boolean up, down, left, right, shoot, change;
  float theta = 0;
  color col;
  float currentHealth, maxHealth;
  int visible;
  float time;
  int playerNR;
  float radius;
  float speed = 5;

  //player constructor
  Player(int playerNR, PVector p, float radius, color c, int u, int d, int l, int r, int q, int e, float maxHealth, int v, int dir) {
    this.playerNR = playerNR;
    pos = p;
    this.radius = radius;
    col = c;
    upKey = u;
    downKey = d;
    leftKey = l;
    rightKey = r;
    shootKey = q;
    changeKey = e;
    this.maxHealth = maxHealth;
    currentHealth = this.maxHealth;
    visible = v;
    this.dir = dir;
  }

  void keyPress() {
    if (keyCode == upKey || key == upKey) up = true;
    if (keyCode == downKey || key ==  downKey) down = true;
    if (keyCode == leftKey || key == leftKey) left = true;
    if (keyCode == rightKey || key == rightKey) right = true;
    if (keyCode == shootKey || key == shootKey) shoot = true;
    if (keyCode == changeKey || key == changeKey) change = true;
  }

  void keyRelease() {
    if (keyCode == upKey || key == upKey) up = false;
    if (keyCode == downKey || key == downKey) down = false;
    if (keyCode == leftKey || key == leftKey) left = false;
    if (keyCode == rightKey || key == rightKey) right = false; 
    if (keyCode == shootKey || key == shootKey) shoot = false;
    if (keyCode == rightKey || key == rightKey) right = false;
  }

  void move() {
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
  }

  void heal(float healAmount) {
    if (currentHealth < maxHealth) {
      currentHealth += healAmount;
    } else if (currentHealth > maxHealth) {
      currentHealth = maxHealth;
    }
  }

  void takeDamage(float damage) {
    damagedTime = millis();

    currentHealth -= damage;

    if (currentHealth <= 0) dead();
  }

  void dead() {
            killCount = 0;
         pz.currentHealth = pz.maxHealth;
    gamestate += 1;
  }

  float damagedTime = 0;
  float healTime = 7500;
  void update() {

    if (millis() >= damagedTime + healTime) {
      heal(0.5);
      //damagedTime
    }

    move();
    theta = 2*dir*PI/8-PI/2;

    if (up || down || left || right) {
      vel = new PVector(speed*cos(theta), speed*sin(theta));
    }
    pos.add(vel);
    vel.mult(0);
      if (shoot == true) {
      switch(playerNR) {
              case 1:
              WPMp1.WeaponShoot();
            break;
          case 2:
              WPMp2.WeaponShoot();
              break;
          case 3:
          WPMpz.WeaponShoot();
          break;
          }
        }
      if (change == true) {
        switch(playerNR) {
        case 1:
         WPMp1.WeaponChange();
         change=false;
          break;
        case 2:
         WPMp2.WeaponChange(); 
         change=false;
          break;
          case 3:
         WPMpz.WeaponChange();
         change=false;
          break;
        }
      }
    }
  

    PVector getPos() {
      return pos;
    }  

    void display() {
      pushMatrix();
      translate(pos.x, pos.y);
      stroke(0);
      fill(245, 0, 0);
      textSize(20);
      
      switch (playerNR) {
      case 1:
       text(WPMp1.WeaponText, 0, -80);
        break;
      case 2:
        text(WPMp2.WeaponText, 0, -80);
        break;
        case 3:
       text(WPMpz.WeaponText, 0, -80);
       break;
      }
      
      rect(-maxHealth/2, -70, maxHealth, 20);
      fill(col);        
      rect(-maxHealth/2, -70, currentHealth, 20);
      rotate(theta);
      //rect(-25, -25, 50, 50);
      circle(0, 0, 2*radius);
           switch (playerNR) {
      case 1:
               
        break;
      case 2:

        break;
        case 3:
   switch(WPMpz.WeaponID) {
          case 1:
           fill(128, 128, 128);
            rect(15, 0, 20, 5);
          break;
          case 2:
           fill(169, 169, 200);
            rect(15, 0, 30, 10);
          break;
           case 3:
           fill(6, 6, 6);
            rect(15, 0, 40, 10);
           break;
           case 4:
            fill(128, 128, 128);
            rect(25, 0, pzSword.swordSize, 2);
           break;}
           case 5:
            fill(6, 6, 6);
            rect(15, 0, 30, 10);
       break; }
      popMatrix();
    }

  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
}
