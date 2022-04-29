class Player {
  PVector pos, vel = new PVector();
  int upKey, downKey, leftKey, rightKey, shootKey, changeKey;
  int dir;
  boolean up, down, left, right, shoot, change;
  float theta = 0;
  color col;
  int currentHealth, maxHealth;
  int visible;
  float time;
  //player constructor
  Player(PVector p, color c, int u, int d, int l, int r, int q,int e, int maxHealth, int v) {
    pos = p;
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

  void update() {
    move();
    theta = 2*dir*PI/8-PI/2;

    if (up || down || left || right)  vel = new PVector(5*cos(theta), 5*sin(theta));
    pos.add(vel);
    vel.mult(0);
    
     if (shoot == true) {
        switch(pzWeaponID) {
        case 1:
        pzGlock.shoot();
       // shoot = false;
        break;
        case 2:
        pzUZI.shoot();
     // shoot = false;
      break;
     }
    }
    if (change == true && time < (second())) {
        time = second()+0.5;
        switch(pzWeaponID) {
        case 1:
        pzWeaponID = 2;
        pzWeaponName = "UZI";
        change = false;
        break;
        case 2:
        pzWeaponID = 1;
        pzWeaponName = "Glock";
      change = false;
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
    fill(255, 0, 0);
    textSize(20);
    switch (pzWeaponID){
    case 1:
    text(pzWeaponName+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets,0,-80);
    break;
    case 2:
    text(pzWeaponName+" "+pzUZI.currentBullets+"/"+pzUZI.maxBullets,0,-80);
    break;
    }
    rect(-maxHealth/2, -70, maxHealth, 20);
    fill(col);        
    rect(-maxHealth/2, -70, currentHealth, 20);
    rotate(theta);
    //rect(-25, -25, 50, 50);
    circle(0, 0, 50);
    fill(128, 128, 128);
    rect(15, 5, 20, 5);
    
    popMatrix();
  }
  

  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
}
