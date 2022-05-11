class Player {
  PVector pos, vel = new PVector();
  PImage look, glock, uzi, shotgun1, shotgun2, sword1, sword2;
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
  Player(int playerNR, PVector p, float radius, color c, int u, int d, int l, int r, int q, int e, float maxHealth, int v, int dir, PImage look) {
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
    this.look = look;
    glock = loadImage("Glock.png");
    uzi = loadImage("Uzi.png");
    shotgun1 = loadImage("Shotgung.png");
    shotgun2 = loadImage("Shotgunb.png");
    sword1 = loadImage("Swordg.png");
    sword2 = loadImage("Swordb.png");
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
  
  float armpos = 0; 
  float hitdir = 1;
  float cooldown = 0;
  void swingAnimation(PImage p) {
    pushMatrix();
    image(p, 0, -armpos-50);
    popMatrix();
    if (armpos <= 0) cooldown ++;
    if (cooldown > 30) {
      cooldown = 0;
      armpos = 0.5;
      hitdir = abs(hitdir);
    }
    if (armpos > 0) armpos += hitdir*1;
    if (armpos >= 5 && armpos <= 10) armpos += hitdir*3;
    if (armpos >=15) armpos += hitdir*1;    
    if (armpos >= 20) {
      hitdir = -hitdir ;
    }
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
    rotate(PI/2);
    image(look, 5-radius, 11-radius);
    switch (playerNR) {
    case 1:
      switch(WPMp1.WeaponID){
        case 1:
          image(glock, 10, -33);
          break;
        case 2:
          image(uzi, 10, -33);
          break;
        case 3:
          image(shotgun1, 10, -36);
          break;
        case 4:
          if(shoot) swingAnimation(sword1);
          else image(sword1, 0, -50);
          break;
        case 5:
          fill(0);
          rect(10,-33, 20, 20);
          break;
      }
      break;
    case 2:
      switch(WPMp2.WeaponID){
        case 1:
          image(glock, 10, -33);
          break;
        case 2:
          image(uzi, 10, -33);
          break;
        case 3:
          image(shotgun2, 10, -36);
          break;
        case 4:
          if(shoot) swingAnimation(sword2);
          else image(sword2, 0, -50);
          break;
        case 5:
          fill(0);
          rect(10,-33, 20, 20);
          break;
      }
      break;
    case 3:
      switch(WPMpz.WeaponID){
        case 1:
          image(glock, 10, -33);
          break;
        case 2:
          image(uzi, 10, -33);
          break;
        case 3:
          image(shotgun1, 10, -36);
          break;
        case 4:
          if(shoot) swingAnimation(sword1);
          else image(sword1, 0, -50);
          break;
        case 5:
          fill(0);
          rect(10,-33, 20, 20);
          break;
      }
      break;
    }

    popMatrix();
  }

  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
  void bonus() {
    if (bonustime < millis()) {
      if (bonusMultiplier > 1.1) {
        bonusMultiplier -= 1;
        bonustime = millis()+bonuslosetime/2;
      }
    }
    /*
    do {
     bonusMultiplier -= 0.2;
     bonustime = millis()+(bonuslosetime);
     break;
     }
     while (bonustime < millis() && bonusMultiplier>1.1);
     */
  }

  void points() {
    bonusMultiplier += 1;
    bonustime = millis()+bonuslosetime;
    points += 10*bonusMultiplier;
  }

  void saveHighscore() {
    localNR = 0;
    println(highscore+""+highscore2+""+""+highscore3+""+""+highscore4+""+""+highscore5);
    println(highscoreName+""+highscoreName2+""+""+highscoreName3+""+""+highscoreName4+""+""+highscoreName5);
    println(localName+" "+points);
    if (points > highscore) {
      localNR += 1;
    }
    if (points > highscore2) {
      localNR += 1;
    }
    if (points > highscore3) {
      localNR += 1;
    }
    if (points > highscore4) {
      localNR += 1;
    }
    if (points > highscore5) {
      localNR += 1;
    }
    json = new JSONObject();
    switch (localNR) {
    case 0:
      json.setInt("Score", highscore);
      json.setString("Name", highscoreName);
      json.setInt("Score2", highscore2);
      json.setString("Name2", highscoreName2);
      json.setInt("Score3", highscore3);
      json.setString("Name3", highscoreName3);
      json.setInt("Score4", highscore4);
      json.setString("Name4", highscoreName4);
      json.setInt("Score5", highscore5);
      json.setString("Name5", highscoreName5);
      break;
    case 1:
      json.setInt("Score", highscore);
      json.setString("Name", highscoreName);
      json.setInt("Score2", highscore2);
      json.setString("Name2", highscoreName2);
      json.setInt("Score3", highscore3);
      json.setString("Name3", highscoreName3);
      json.setInt("Score4", highscore4);
      json.setString("Name4", highscoreName4);
      json.setInt("Score5", points);
      json.setString("Name5", localName);
      
      highscore5 = points;
      
      highscoreName5 = localName;
      break;
    case 2:
      json.setInt("Score", highscore);
      json.setString("Name", highscoreName);
      json.setInt("Score2", highscore2);
      json.setString("Name2", highscoreName2);
      json.setInt("Score3", highscore3);
      json.setString("Name3", highscoreName3);
      json.setInt("Score4", points);
      json.setString("Name4", localName );
      json.setInt("Score5", highscore4);
      json.setString("Name5", highscoreName4);
      
                  highscore5 = highscore4;
      highscore4 = points;

      highscoreName5 = highscoreName4;
      highscoreName4 = localName;
      break;
    case 3:
      json.setInt("Score", highscore);
      json.setString("Name", highscoreName);
      json.setInt("Score2", highscore2);
      json.setString("Name2", highscoreName2);
      json.setInt("Score3", points);
      json.setString("Name3", localName);
      json.setInt("Score4", highscore3);
      json.setString("Name4", highscoreName3);
      json.setInt("Score5", highscore4);
      json.setString("Name5", highscoreName4);
      
            highscore5 = highscore4;
      highscore4 = highscore3;
      highscore3 = points;

      highscoreName5 = highscoreName4;
      highscoreName4 = highscoreName3;
      highscoreName3 = localName;
      break;
    case 4:
      json.setInt("Score", highscore);
      json.setString("Name", highscoreName);
      json.setInt("Score2", points);
      json.setString("Name2", localName);
      json.setInt("Score3", highscore2);
      json.setString("Name3", highscoreName2);
      json.setInt("Score4", highscore3);
      json.setString("Name4", highscoreName3);
      json.setInt("Score5", highscore4);
      json.setString("Name5", highscoreName4);
      highscore5 = highscore4;
      highscore4 = highscore3;
      highscore3 = highscore2;
      highscore2 = points;
      
      highscoreName5 = highscoreName4;
      highscoreName4 = highscoreName3;
      highscoreName3 = highscoreName2;
      highscoreName2 = localName;
      
      break;
    case 5:
      json.setInt("Score", points);
      json.setString("Name", localName);
      json.setInt("Score2", highscore);
      json.setString("Name2", highscoreName);
      json.setInt("Score3", highscore2);
      json.setString("Name3", highscoreName2);
      json.setInt("Score4", highscore3);
      json.setString("Name4", highscoreName3);
      json.setInt("Score5", highscore4);
      json.setString("Name5", highscoreName4);
     
      highscore5 = highscore4;
      highscore4 = highscore3;
      highscore3 = highscore2;
      highscore2 = highscore;
      highscore = points;
      
      highscoreName5 = highscoreName4;
      highscoreName4 = highscoreName3;
      highscoreName3 = highscoreName2;
      highscoreName2 = highscoreName;
      highscoreName = localName;
      break;
    }
    saveJSONObject  (json, "data/Highscore.json");
  }
}
