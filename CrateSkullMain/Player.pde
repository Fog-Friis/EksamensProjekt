class Player {
  PVector pos, vel = new PVector(); 
  PImage look;
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
      fill(128, 128, 128);
      rect(15, 5, 20, 5);
      rotate(PI/2);
      image(look, 5-radius, 11-radius);
      popMatrix();

    }

  void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
  void bonus(){
    if (bonustime < millis()){
    if (bonusMultiplier > 1.1){
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
  json.setInt("Score",highscore);
  json.setString("Name", highscoreName);
  json.setInt("Score2",highscore2);
  json.setString("Name2", highscoreName2);
  json.setInt("Score3",highscore3);
  json.setString("Name3", highscoreName3);
  json.setInt("Score4",highscore4);
  json.setString("Name4", highscoreName4);
  json.setInt("Score5",highscore5);
  json.setString("Name5", highscoreName5);
  break;
  case 1:
  json.setInt("Score",highscore);
  json.setString("Name", highscoreName);
  json.setInt("Score2",highscore2);
  json.setString("Name2", highscoreName2);
  json.setInt("Score3",highscore3);
  json.setString("Name3", highscoreName3);
  json.setInt("Score4",highscore4);
  json.setString("Name4", highscoreName4);
  json.setInt("Score5",points);
  json.setString("Name5", localName);
  break;
  case 2:
  json.setInt("Score",highscore);
  json.setString("Name", highscoreName);
  json.setInt("Score2",highscore2);
  json.setString("Name2", highscoreName2);
  json.setInt("Score3",highscore3);
  json.setString("Name3", highscoreName3);
  json.setInt("Score4",points);
  json.setString("Name4",localName );
  json.setInt("Score5",highscore4);
  json.setString("Name5", highscoreName4);
  break;
  case 3:
    json.setInt("Score",highscore);
  json.setString("Name", highscoreName);
  json.setInt("Score2",highscore2);
  json.setString("Name2", highscoreName2);
  json.setInt("Score3",points);
  json.setString("Name3",localName);
  json.setInt("Score4",highscore3);
  json.setString("Name4",highscoreName3);
  json.setInt("Score5",highscore4);
  json.setString("Name5", highscoreName4);
  break;
  case 4:
      json.setInt("Score",highscore);
  json.setString("Name", highscoreName);
  json.setInt("Score2",points);
  json.setString("Name2",localName);
  json.setInt("Score3",highscore2);
  json.setString("Name3",highscoreName2);
  json.setInt("Score4",highscore3);
  json.setString("Name4",highscoreName3);
  json.setInt("Score5",highscore4);
  json.setString("Name5", highscoreName4);
  break;
  case 5:
  json.setInt("Score",points);
  json.setString("Name", localName);
  json.setInt("Score2",highscore);
  json.setString("Name2",highscoreName);
  json.setInt("Score3",highscore2);
  json.setString("Name3",highscoreName2);
  json.setInt("Score4",highscore3);
  json.setString("Name4",highscoreName3);
  json.setInt("Score5",highscore4);
  json.setString("Name5", highscoreName4);
  break;
  }
  saveJSONObject  (json, "data/Highscore.json"); 
  }
}
