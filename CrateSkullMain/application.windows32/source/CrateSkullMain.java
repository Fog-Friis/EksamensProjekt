import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CrateSkullMain extends PApplet {

GameStateManager gameStateManager;
JSONObject json;
int highscore,highscore2,highscore3,highscore4,highscore5;
String highscoreName,highscoreName2,highscoreName3,highscoreName4,highscoreName5;

public void setup() {
  
  gameStateManager = new GameStateManager();
  gameStateManager.setupManager();
  cols = width/40;
  rows = height/40;
  
  json = loadJSONObject("Highscore.json");
  highscore = json.getInt("Score");
  highscore2 = json.getInt("Score2");
  highscore3 = json.getInt("Score3");
  highscore4 = json.getInt("Score4");
  highscore5 = json.getInt("Score5");
  highscoreName = json.getString("Name");
  highscoreName2 = json.getString("Name2");
  highscoreName3 = json.getString("Name3");
  highscoreName4 = json.getString("Name4");
  highscoreName5 = json.getString("Name5");
}

public void draw() {
  loadPixels();
  if(!gamePaused){
    background(255);
    pausedScreen = false;
  } else{
    if(!pausedScreen){
      fill(100,100);
      rect(0, 0, width, height);
      pausedScreen = true;
    }
    for (Player p : players) p.keyRelease();
  }
  gameStateManager.manage();
}

public void mousePressed() {
  for (Button b : buttons) b.pressed();
}

public void mouseReleased() {
  for (Button b : buttons) b.released();
}

public void mouseClicked() {
  for (TextBox t : textBoxes) t.pressed(mouseX, mouseY);
}

public void keyPressed() {
  //if (key == ' '&&!gamePaused) gamestate++;
  if (key == 'p'&&gamestate == 3|| key == 'p'&&gamestate == 6) gamePaused = !gamePaused;
  
  if(!gamePaused)
    for (Player p : players) p.keyPress();
  for (TextBox t : textBoxes) t.keyWasTyped(key, (int)keyCode);
}

public void keyReleased() {
  if(!gamePaused) 
    for (Player p : players) p.keyRelease();
}
class Button {

  PVector pos;
  PVector size;

  int col, overCol, pressedCol;

  float radius;

  PVector box1size, box1pos, box2size, box2pos;
  PVector circle1pos, circle2pos, circle3pos, circle4pos;

  boolean clicked = false;

  String Text;
  float textSize;
  
  int visible;

  Button(PVector p, PVector s, float r, int col, int ocol, int pcol, String Text, float textSize, int v) {

    this.pos = p;
    this.size = s;
    this.radius = r;
    this.col = col;
    this.overCol = ocol;
    this.pressedCol = pcol;
    this.Text = Text;
    this.textSize = textSize;
    this.visible = v;


    box1pos = new PVector(pos.x, pos.y-radius/2);
    box2pos = new PVector(pos.x-radius/2, pos.y);

    box1size = new PVector(size.x, size.y+radius);
    box2size = new PVector(size.x+radius, size.y);

    circle1pos = new PVector(pos.x, pos.y);
    circle2pos = new PVector(pos.x+size.x, pos.y);
    circle3pos = new PVector(pos.x+size.x, pos.y+size.y);
    circle4pos = new PVector(pos.x, pos.y+size.y);
  }

  public boolean over() {
    if ((mouseX <= box1pos.x+box1size.x && mouseX >= box1pos.x && mouseY <= box1pos.y+box1size.y && mouseY >= box1pos.y) ||
      (mouseX <= box2pos.x+box2size.x && mouseX >= box2pos.x && mouseY <= box2pos.y+box2size.y && mouseY >= box2pos.y) ||
      (dist(mouseX, mouseY, circle1pos.x, circle1pos.y)<radius/2) ||
      (dist(mouseX, mouseY, circle2pos.x, circle2pos.y)<radius/2) ||
      (dist(mouseX, mouseY, circle3pos.x, circle3pos.y)<radius/2) ||
      (dist(mouseX, mouseY, circle4pos.x, circle4pos.y)<radius/2)) {
      return true;
    } else {
      return false;
    }
  }

  public void pressed() {
    if (over()) {
      clicked = true;
    }
  }

  public void released() {
    clicked = false;
  }

  public void display() {

    noStroke();

    if (clicked) {
      fill(pressedCol);
      clicked=false;
    } else if (over()) {
      fill(overCol);
    } else {
      fill(col);
    }

    rect(box1pos.x, box1pos.y, box1size.x, box1size.y);
    rect(box2pos.x, box2pos.y, box2size.x, box2size.y);

    circle(circle1pos.x, circle1pos.y, radius);
    circle(circle2pos.x, circle2pos.y, radius);
    circle(circle3pos.x, circle3pos.y, radius);
    circle(circle4pos.x, circle4pos.y, radius);

    textAlign(CENTER);
    fill(0, 0, 0);
    textSize(textSize);
    text(Text, pos.x+size.x/2, pos.y+textSize*2/3+size.y*1/3);
    textAlign(CORNER);
  }
  
  public void run(){
    if(visible == gamestate){
      display();
    }
  }
}
int cols, rows;
PImage zb1, zb2, zb3;

class Enemy {
  PVector pos, vel = new PVector();
  int life;
  float theta;
  float attackRate;
  float radius;

  int[][] grid;
  int start, end;

  ArrayList openSet, closedSet;
  ArrayList vertices;
  ArrayList path;

  ArrayList<PVector> points;

  float x1, x2, y1, y2;
  float nextFindTime = 1000, findRate = 1000;

  Enemy(PVector p, float r, int l) {
    pos = p;
    radius = r;
    life = l;

    vel = new PVector();
    points = new ArrayList<PVector>();

    openSet = new ArrayList();
    closedSet = new ArrayList();
    vertices = new ArrayList();
    path = new ArrayList();

    grid = new int[height/40][width/40];
    generateMap();

    zb1 = loadImage("zb1.png");
    zb2 = loadImage("zb2.png");
    zb3 = loadImage("zb3.png");
  }
  
  public void generateMap() {
    Vertex v;
    for ( int ix = 0; ix < width/40.0f; ix+=1 ) {
      for ( int iy = 0; iy < height/40.0f; iy+=1) {
        grid[iy][ix] = 1;
        //for (int i = 0; i < lvl2.rows; i++) {
        //for (int j = 0; j < lvl2.columns; j++) {
        for (LevelTile l : lvl2.levelTiles) {
          for (WallTile w : l.wallTiles) {
            grid[PApplet.parseInt(w.pos.y/40)][PApplet.parseInt(w.pos.x/40)]=-1;
            //}
          }
        }
        if (grid[iy][ix] != -1) {
          vertices.add(new Vertex(ix*40, iy*40));
          grid[iy][ix] = vertices.size()-1;
          if (ix>0) {
            if (grid[iy][ix-1]!=-1) {
              v = (Vertex)vertices.get(vertices.size()-1);
              float cost = random(0.25f, 2);
              v.addNeighbor((Vertex)vertices.get(grid[iy][ix-1]), cost);
              ((Vertex)vertices.get(grid[iy][ix-1])).addNeighbor(v, cost);
            }
          }
          if (iy>0) {
            if (grid[iy-1][ix]!=-1) {
              v = (Vertex)vertices.get(vertices.size()-1);
              float cost = random(0.25f, 2);
              v.addNeighbor((Vertex)vertices.get(grid[iy-1][ix]), cost); 
              ((Vertex)vertices.get(grid[iy-1][ix])).addNeighbor(v, cost);
            }
          }
        }
      }
    }
  }

  public boolean astar(int iStart, int iEnd) {
    float endX, endY;
    endX = ((Vertex)vertices.get(iEnd)).x;
    endY = ((Vertex)vertices.get(iEnd)).y;

    openSet.clear();
    closedSet.clear();
    path.clear();

    openSet.add((Vertex)vertices.get(iStart));
    ((Vertex)openSet.get(0)).p = -1;
    ((Vertex)openSet.get(0)).g = 0;
    ((Vertex)openSet.get(0)).h = heuristic(((Vertex)openSet.get(0)).x, ((Vertex)openSet.get(0)).y, endX, endY);

    Vertex current;
    float tentG;
    boolean tentIsPog;
    float min = 999999999;
    int lowestIndex = -1;

    while (openSet.size() > 0) {
      min = 999999999;
      for (int i = 0; i < openSet.size(); i++) {
        if (((Vertex)openSet.get(i)).g + ((Vertex)openSet.get(i)).h <= min) {
          min = ((Vertex)openSet.get(i)).g + ((Vertex)openSet.get(i)).h;
          lowestIndex = i;
        }
      }
      current = (Vertex)openSet.get(lowestIndex);

      if (current.x == endX && current.y == endY) {
        Vertex v = (Vertex)openSet.get(lowestIndex);
        while (v.p != -1) {
          path.add(v);
          v = (Vertex)vertices.get(v.p);
        }
        return true;
      }
      closedSet.add( (Vertex)openSet.get(lowestIndex));
      openSet.remove(lowestIndex);
      for (int i = 0; i < current.neighbors.size(); i++) {
        if (closedSet.contains( (Vertex)current.neighbors.get(i))) {
          continue;
        }
        tentG = current.g + heuristic(current.x, current.y, ((Vertex)current.neighbors.get(i)).x, ((Vertex)current.neighbors.get(i)).y)*(Float)current.cost.get(i);
        if (!openSet.contains((Vertex)current.neighbors.get(i))) {
          openSet.add( (Vertex)current.neighbors.get(i));
          tentIsPog = true;
        } else if (tentG < ((Vertex)current.neighbors.get(i)).g) {
          tentIsPog = true;
        } else {
          tentIsPog = false;
        }

        if (tentIsPog) {
          ((Vertex)current.neighbors.get(i)).p = vertices.indexOf((Vertex)closedSet.get(closedSet.size()-1)); //!!!!
          ((Vertex)current.neighbors.get(i)).g = tentG;
          ((Vertex)current.neighbors.get(i)).h = heuristic( ((Vertex)current.neighbors.get(i)).x, ((Vertex)current.neighbors.get(i)).y, endX, endY);
        }
      }
    }
    return false;
  }

  public void findNewPath() {
    x1 = pos.x;
    y1 = pos.y;
    x2 = pz.pos.x;
    y2 = pz.pos.y;

    if (grid[PApplet.parseInt(floor(y1/40))][PApplet.parseInt(floor(x1/40))]!=-1) {
      if (start==-1) {
        start = grid[PApplet.parseInt(floor(y1/40))][PApplet.parseInt(floor(x1/40))];
      } 
      if (end==-1) {
        end = grid[PApplet.parseInt(floor(y2/40))][PApplet.parseInt(floor(x2/40))];
        if (end==start) {
          end = -1;
        }
      } else {
        start = -1;
        end = -1;
        path.clear();
      }
    }

    points.clear();
    pos = new PVector(x1, y1);
    points.add(new PVector(x1, y1));

    if (start!=-1 && end!=-1) {
      astar(start, end);
    }
  }

  public boolean inAttackRange(float d) {
    if (dist(pz.pos.x, pz.pos.y, pos.x, pos.y)<=d) {
      return true;
    } else {
      return false;
    }
  }

  public void calcNewPath(float d) {
    if (!inAttackRange(d)) {
      if (inAttackRange(600)) {
        findNewPath();
        addPoints();
        points.add(new PVector(floor(x2/40)*40+8, floor(y2/40)*40+8));
        //nextFindTime = millis() + findRate;
      } else {
        if (millis() > nextFindTime) {
          findNewPath();
          addPoints();
          points.add(new PVector(floor(x2/40)*40+8, floor(y2/40)*40+8));
          nextFindTime = millis() + findRate;
        }
      }
    } else {
      vel = new PVector(0, 0);
    }
  }  

  public void addPoints() {
    for (int i = path.size()-1; i > 0; i--) {
      Vertex v = (Vertex)path.get(i);
      points.add(new PVector(v.x+20, v.y+20));
    }
  }

  public void move(PVector startPoint, PVector endPoint) {
    float theta = atan2(startPoint.y-endPoint.y, startPoint.x-endPoint.x)+PI;
    vel = new PVector(cos(theta)*3, sin(theta)*3);
  }

  public boolean moved(PVector endpoint) {
    if (dist(pos.x, pos.y, endpoint.x, endpoint.y)<8) {
      return true;
    } else {
      return false;
    }
  }  

  public void takeDamage(float damage) {
    life -= damage;
  }

  Vertex t1;
  public void drawGrid() {
    for ( int i = 0; i < vertices.size(); i++ ) {
      t1 = (Vertex)vertices.get(i);
      if (i==start) {
        fill(0, 255, 0);
        //rect(t1.x, t1.y, 40, 40);
      } else if (i==end) {
        fill(255, 0, 0);
        //rect(t1.x, t1.y, 40, 40);
      } else {
        if (path.contains(t1)) {
          fill(255);
          //rect(t1.x, t1.y, 40, 40);
        } else {
          fill(200, 200, 200);
        }
      }
      noStroke();
      rect(t1.x, t1.y, 40, 40);
    }
  }

  public void update() {

    if (points.size() > 1 && path.size() > 1) {
      if (!moved(points.get(1))) {
        move(points.get(0), points.get(1));
      } else {
        points.remove(0);
      }
    }
    theta = atan2(pz.pos.y-pos.y, pz.pos.x-pos.x);//+PI;

    calcNewPath(radius+25);
    if (inAttackRange(radius+pz.radius+5)) {
      hitAnimation();
    }

    pos.add(vel);
  }

  float armpos = 0; 
  float hitdir = 1;
  float cooldown = 0;
  public void hitAnimation() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(178, 178, 204);
    stroke(0);
    rotate(theta);
    rect(armpos-10, 10, radius+10, radius/2);
    rect(armpos-10, -25, radius+10, radius/2);
    popMatrix();
    if (armpos <= 0) cooldown ++;
    if (cooldown > 60) {
      cooldown = 0;
      armpos = 0.5f;
      hitdir = abs(hitdir);
    }
    if (armpos > 0) armpos += hitdir*1;
    if (armpos >= 5 && armpos <= 10) armpos += hitdir*3;
    if (armpos >=15) armpos += hitdir*1;    
    if (armpos >= 20) {
      hitdir = -hitdir ;
      pz.takeDamage(20);
    }
  }

  public void display() {
    pushMatrix();
    stroke(0);
    translate(pos.x, pos.y);
    fill(178, 178, 204);
    rotate(theta);
    circle(0, 0, 2*radius);
    rotate(PI/2);
    if (life > 60) image(zb1, 10-radius, 11-radius);
    if (life <= 60 && life > 30) image(zb2, 10-radius, 11-radius);
    if (life <= 30) image(zb3, 10-radius, 11-radius);
    popMatrix();
  }

  public void run() {
    if (life > 0) { 
      update();
      display();
    }
  }
}

class Vertex {
  float x, y;
  float g, h;
  int p;
  ArrayList neighbors; //array of vertex objects
  ArrayList cost; //cost multiplier for each corresponding neighbor
  Vertex(float x, float y) {
    this.x = x;
    this.y = y;
    g = 0;
    h = 0;
    p = -1;
    neighbors = new ArrayList();
    cost = new ArrayList();
  }
  public void addNeighbor(Vertex v, float cm) {
    neighbors.add(v);
    cost.add(new Float(cm));
  }
}

public float heuristic(float x1, float x2, float y1, float y2) {
  return sqrt(abs(y2-y1)+abs(x2-x1));
}
class EnemyManager {
  int maxEnemyCount = 60, maxShooterCount = 20;
  int EnemySpawned, ShooterEnemySpawned;
  float EnemySpawnRate, ShooterEnemySpawnRate, nextEnemySpawn, nextShooterEnemySpawn;
  int enemyHealth;
  ArrayList<PVector> SpawnPoints = new ArrayList<PVector>();
  ArrayList<Enemy> Enemies = new ArrayList<Enemy>();
  ArrayList<ShooterEnemy> ShooterEnemies = new ArrayList<ShooterEnemy>();

  int roundNumber = 0;
  int startEnemyCount = 20, startShooterCount = 0;
  int spawnedEnemies, spawnedShooters;
  int roundEnemyCount, roundShooterCount;


  EnemyManager() {
    SpawnPoints.add(new PVector(40*4, 40*4.5f));
    SpawnPoints.add(new PVector(width-40*4, height-40*4.5f));
    EnemySpawnRate = 1000;
    ShooterEnemySpawnRate = 5000;
    roundEnemyCount = startEnemyCount;
    roundShooterCount = startShooterCount;
    Enemies.clear();
    ShooterEnemies.clear();
    enemyHealth = 100;
    spawnedEnemies = 0;
  }

  public void enemyCollision(ArrayList<Enemy> e, ArrayList<ShooterEnemy> s, Player p) {
    for (int i = 0; i < e.size(); i++) {
      for (int j = 0; j < e.size(); j++) {
        if (i != j) {
          collisionBetween(e.get(i).pos, e.get(i).radius, e.get(j).pos, e.get(j).radius);
        }
      }
    }
    for (int i = 0; i < s.size(); i++) {
      for (int j = 0; j < s.size(); j++) {
        if (i != j) {
          collisionBetween(s.get(i).pos, s.get(i).radius, s.get(j).pos, s.get(j).radius);
        }
      }
    }
    for (int i = 0; i < e.size(); i++) {
      for (int j = 0; j < s.size(); j++) {
        collisionBetween(e.get(i).pos, e.get(i).radius, s.get(j).pos, s.get(j).radius);
      }
    }
    for (int i = 0; i < e.size(); i++) {
      collisionBetween(e.get(i).pos, e.get(i).radius, p.pos, p.radius);
    }    
    for (int i = 0; i < s.size(); i++) {
      collisionBetween(s.get(i).pos, s.get(i).radius, p.pos, p.radius);
    }
    for (Enemy E : e) {
      if (E.pos.y <= 0) E.pos.y = E.pos.y + 200;
      if (E.pos.y >= height) E.pos.y = E.pos.y - 200;
      if (E.pos.x <= 0) E.pos.x = E.pos.x + 200;
      if (E.pos.x >= width) E.pos.x = E.pos.x - 200;
    }
    for (ShooterEnemy S : s) {
      if (S.pos.y <= 0) S.pos.y = S.pos.y + 200;
      if (S.pos.y >= height) S.pos.y = S.pos.y - 200;
      if (S.pos.x <= 0) S.pos.x = S.pos.x + 200;
      if (S.pos.x >= width) S.pos.x = S.pos.x - 200;
    }
  }

  public void collisionBetween(PVector p1, float r1, PVector p2, float r2) {
    float distance = r1 + r2;
    float theta = atan2(p1.y-p2.y, p1.x - p2.x) + PI;
    if (dist(p1.x, p1.y, p2.x, p2.y) < distance) {
      float dist = distance - dist(p1.x, p1.y, p2.x, p2.y);
      p1 = p1.sub(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
      p2 = p2.add(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
    }
  }

  public void nextRound() {
    if (Enemies.size() + ShooterEnemies.size() == 0) {
      roundNumber++;
      roundEnemyCount = startEnemyCount + roundNumber * 5;
      spawnedEnemies = 0;
      spawnedShooters = 0;
      enemyHealth += 10;

      if (EnemySpawnRate > 500) {
        EnemySpawnRate -= 25;
      }

      if (roundNumber >= 4) {
        roundShooterCount = startShooterCount + roundNumber - 3;
      }
    }
  }

  public void spawnEnemies() {
    if (spawnedEnemies <= maxEnemyCount && roundEnemyCount > 0) {
      if (millis() > nextEnemySpawn) {
        Enemies.add(new Enemy(new PVector(SpawnPoints.get(PApplet.parseInt(random(0, SpawnPoints.size()))).x, SpawnPoints.get(PApplet.parseInt(random(0, SpawnPoints.size()))).y), 30, enemyHealth));
        roundEnemyCount--;
        spawnedEnemies++;
        nextEnemySpawn = millis() + EnemySpawnRate;
      }
    }
    if (spawnedShooters <= maxShooterCount && roundShooterCount > 0) {
      if (millis() > nextShooterEnemySpawn) {
        ShooterEnemies.add(new ShooterEnemy(new PVector(SpawnPoints.get(PApplet.parseInt(random(0, SpawnPoints.size()))).x, SpawnPoints.get(PApplet.parseInt(random(0, SpawnPoints.size()))).y), 30, 100, 1000));
        roundShooterCount--;
        spawnedShooters++;
        nextShooterEnemySpawn = millis() + ShooterEnemySpawnRate;
      }
    }
  }

  boolean addedSpawnPoints = false;
  public void update() {

    spawnEnemies();
    enemyCollision(Enemies, ShooterEnemies, pz);
    for (Enemy e : Enemies) e.run();
    for (ShooterEnemy s : ShooterEnemies) s.run();    

    // textMode(CENTER);
    fill(0);
    textSize(48);
    text(roundNumber+1, width/2, 100);
    //   textMode(CORNER);

    nextRound();
  }

  public void run() {
    update();
  }
}
int gamestate;
int killCount=0;
int bonusMultiplier = 1;
float bonuslosetime= 4000;
int points = 0; 
float bonustime;
ArrayList<Player> players;
Player p1, p2, pz;
PImage p1l_pzl;
PImage p2l;
String localName = "", savetext = "Enter name here";
int localNR, localPoints;
String[] text;
int scorep1 = 0;
int scorep2 = 0;

int ColpzTarget1 = -5066036;
int ColpzTarget2 = -65536;
//int ColpzTarget2 = -6618981;

int Colp1Target1 = -16776961;

int Colp1Target2 = -16776961;

int Colp2Target1 =  -16711936;
int Colp2Target2 = -16711936;

Weapon pzGlock, p1Glock, p2Glock;
Weapon pzUZI, p1UZI, p2UZI;
Weapon pzSword, p1Sword, p2Sword;
Weapon pzShotgun, p1Shotgun, p2Shotgun;
Weapon pzGrenades, p1Grenades, p2Grenades;
int pzGlockDamage = 80, pzUZIDamage = 45, pzShotgunDamage = 50, pzGrenadesDamage = 100;
float pzGlockFireRate = 800, pzUZIFireRate = 200, pzShotgunFireRate = 500;

WeaponManager WPMp1, WPMp2, WPMpz;
EnemyManager EM;
ArrayList<TextBox> textBoxes;
TextBox tb1, tb2, tbs1, tbs2;
ArrayList<Button> buttons;
Button zs, zss, zb, zggb, dm, dms, db, dggb, cs, cb, sb, dmpa;
ArrayList<PVector> spawns;
boolean gamePaused;
boolean pausedScreen;
boolean newRun;

ArrayList<Level> levels;
Level lvl1, lvl2;  

class GameStateManager {

  GameStateManager() {
    gamestate = 0;  
    gamePaused = false;   
    pausedScreen = false;  
    p1l_pzl = loadImage("pz-p1.png"); 
    p2l = loadImage("p2.png");  
    players = new ArrayList<Player>(); 
    text = loadStrings("Controls.txt"); 
    players = new ArrayList<Player>(); 
    textBoxes = new ArrayList<TextBox>();  
    buttons = new ArrayList<Button>(); 
    spawns = new ArrayList<PVector>();
    levels = new ArrayList<Level>();
  }
  // -6618981 shooter
  // -65536 enemy
  public void setupManager() {
    pzGlock = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 20, 20, color(1), pzGlockFireRate, pzGlockDamage, 0, ColpzTarget1, ColpzTarget2, 0, 3);
    pzUZI = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 40, 40, color(1), pzUZIFireRate, pzUZIDamage, 0, ColpzTarget1, ColpzTarget2, 0, 3);//

    pzSword = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 1, 1, color(1), 900, 500, 0, ColpzTarget1, ColpzTarget2, 0, 3);
    pzShotgun = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 15, 15, color(1), pzShotgunFireRate, pzShotgunDamage, 0, ColpzTarget1, ColpzTarget2, 0, 3);   
    pzGrenades = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 10, 10, color(1), 500, pzGrenadesDamage, 0, ColpzTarget1, ColpzTarget2, 0, 3);

    p1Glock = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 20, 20, color(1), 800, 15, 0, Colp1Target1, Colp1Target2, 4, 1);
    p1UZI = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 40, 40, color(1), 100, 10, 0, Colp1Target1, Colp1Target2, 4, 1);
    p1Sword = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 1, 1, color(1), 900, 80, 0, Colp1Target1, Colp1Target2, 4, 1);
    p1Shotgun = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 15, 15, color(1), 500, 5, 0, Colp1Target1, Colp1Target2, 4, 1);
    p1Grenades = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 10, 10, color(1), 500, 100, 0, Colp1Target1, Colp1Target2, 4, 1);

    p2Glock = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 20, 20, color(1), 800, 15, 0, Colp2Target1, Colp2Target2, 8, 2);
    p2UZI = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 40, 40, color(1), 100, 10, 0, Colp2Target1, Colp2Target2, 8, 2);
    p2Sword = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 1, 1, color(1), 900, 80, 0, Colp2Target1, Colp2Target2, 8, 2);
    p2Shotgun = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 15, 15, color(1), 500, 5, 0, Colp2Target1, Colp2Target2, 8, 2);
    p2Grenades = new Weapon (new PVector(width/2+100, height/2), 0, 0, 0, 10, 10, color(1), 500, 100, 0, Colp2Target1, Colp2Target2, 8, 2);

    p1 = new Player(1, new PVector(40*4, 40*4.5f), 25, color(0, 255, 0), 'w', 's', 'a', 'd', 32, 'e', 100, 3, 0, p1l_pzl);
    players.add(p1);
    p2 = new Player(2, new PVector(width - 40*4, height - 40*4.5f), 25, color(0, 0, 255), 38, 40, 37, 39, ',', '.', 100, 3, 0, p2l);//Change shootkey and changekey
    players.add(p2);
    pz = new Player(3, new PVector(width/2+100, height/2), 25, color(0, 255, 0), 'w', 's', 'a', 'd', 32, 'e', 100, 6, 0, p1l_pzl);
    players.add(pz);

    //  tb1 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), false, 4);
    //  textBoxes.add(tb1);
    tb2 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), 7);
    textBoxes.add(tb2);
    tbs1 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), 2);
    textBoxes.add(tbs1);
    tbs2 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), 5);
    textBoxes.add(tbs2);

    zs = new Button(new PVector(width/2-200, height*0.4f-60), new PVector(400, 120), 5, color(150), color(160), color(140), "Zombie Survival", 48, 0);
    buttons.add(zs);
    dm = new Button(new PVector(width/2-200, height*0.6f-60), new PVector(400, 120), 5, color(150), color(160), color(140), "1v1 Deathmatch", 48, 0);
    buttons.add(dm);
    cs = new Button(new PVector(width/2-200, height*0.8f-60), new PVector(400, 120), 5, color(150), color(160), color(140), "Controls", 48, 0);
    buttons.add(cs);

    cb = new Button(new PVector(width/2-175, height*0.9f-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 1);
    buttons.add(cb);
    db = new Button(new PVector(width/2-175, height*0.9f-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 2);
    buttons.add(db);
    dggb = new Button(new PVector(width/2-175, height*0.9f-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 4);
    buttons.add(dggb);
    dmpa = new Button(new PVector(width/2-175, height*0.9f-200), new PVector(350, 120), 5, color(150), color(160), color(140), "Play Again", 48, 4);
    buttons.add(dmpa);
    zb = new Button(new PVector(width/2-175, height*0.9f-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 5);
    buttons.add(zb);
    zggb = new Button(new PVector(width/2-175, height*0.9f-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 7);
    buttons.add(zggb);
    sb = new Button(new PVector(width/2-175, height*0.9f-200), new PVector(350, 120), 5, color(150), color(160), color(140), "Save", 48, 7);
    buttons.add(sb);

    dms = new Button(new PVector(width/2-175, height*0.75f-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Start", 48, 2);
    buttons.add(dms);
    zss = new Button(new PVector(width/2-175, height*0.75f-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Start", 48, 5);
    buttons.add(zss);

    lvl1 = new Level(1, 3, 40);
    levels.add(lvl1);
    lvl2 = new Level(1, 6, 40);
    levels.add(lvl2);

    EM = new EnemyManager();

    WPMp1 = new WeaponManager(1, 0, 1, "Glock 20/20", 20);
    WPMp2 = new WeaponManager(2, 0, 1, "Glock 20/20", 20);
    WPMpz = new WeaponManager(3, 0, 1, "Glock 20/20", 20);

    spawns.add(new PVector(width/2, height/2));
  }

  public void manage() {
    for (Level l : levels) l.run();
    for (TextBox t : textBoxes) t.display();
    if (!gamePaused)
      for (Player p : players) p.Update();

    switch(gamestate) {
    case 0:
      menuScreen();
      break;

    case 1:
      controlsScreen();
      break;

    case 2:
      deathMatchMenu();
      break;      

    case 3:
      deathMatchScreen();
      break;      

    case 4:
      deathMatchGameOver();
      resetDeathMatch();
      break;

    case 5:
      survivalMenu();
      break;

    case 6:
      survivalScreen();
      break;

    case 7:
      survivalGameOver();
      resetSurvival();
      break;


    default:
      gamestate = 0;
      break;
    }
    for (Button b : buttons) b.run();
    for (Player p : players) p.Display();
  }

  public void menuScreen() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("CrateSkull", width/2, height/6);
    if (zs.clicked) gamestate = 5;
    if (dm.clicked) gamestate = 2;
    if (cs.clicked) gamestate = 1;
    fill(255);
    
    stroke(0);
    fill(200, 200, 200);
    rect(width-450, 50, 400, 450);
    fill(0);
    textSize(42);
    text("Leaderboard:", width-250, 100);
    textSize(32);
    text(highscoreName + ": " + highscore, width-250, 170);
    text(highscoreName2 + ": " + highscore2, width-250, 240);
    text(highscoreName3 + ": " + highscore3, width-250, 310);
    text(highscoreName4 + ": " + highscore4, width-250, 380);
    text(highscoreName5 + ": " + highscore5, width-250, 450);
    
  }

  public void controlsScreen() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Controls", width/2, height/6);
    textSize(29);
    for (int i = 0; text.length > i; i++)
      text(text[i], width/2, height/2+i*32-200);
    if (cb.clicked) gamestate = 0;
    fill(255);
  }

  public void deathMatchMenu() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("DeathMatch", width/2, height/6);
    textSize(32);
    text("Enter seed:", width/2, height/2-20);
    lvl1.seed = PApplet.parseInt(tbs1.Text);
    if (dms.clicked) gamestate = 3;
    if (db.clicked) gamestate = 0;
    fill(255);
    p1.healTime = 100000;
    p2.healTime = 100000;
    scorep1 = 0;
    scorep2 = 0;
  }

  boolean lvlGend1 = false;
  public void deathMatchScreen() {
    if (!lvlGend1) {
      lvl1.drawGraph();
      lvl1.generateLevel();
      lvlGend1 = true;
    }
    p1Grenades.Display();
    p2Grenades.Display();
    if (!gamePaused) {
      if (p1Grenades.time2< millis()&& p1Grenades.hasExploded ==false) {
        p1Grenades.targettype = 3+p1Grenades.colorTargetBonus;
        p1Grenades.hit();
      }
      if (p2Grenades.time2< millis()&& p2Grenades.hasExploded ==false) {
        p2Grenades.targettype = 3+p2Grenades.colorTargetBonus;
        p2Grenades.hit();
      }
    }
  }

  public void deathMatchGameOver() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text(scorep1+" v "+scorep2, width/2, height/4);
    if (dmpa.clicked) gamestate = 3; 
    if (dggb.clicked) gamestate = 0;
    p2Grenades.hasExploded = true;
    p1Grenades.hasExploded = true;
    fill(255);
  }  

  public void survivalMenu() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Zombie Survival", width/2, height/6);
    textSize(32);
    text("Enter seed:", width/2, height/2-20);
    lvl2.seed = PApplet.parseInt(tbs2.Text);
    if (zss.clicked) gamestate = 6;
    if (zb.clicked) gamestate = 0;
    points = 0;
    newRun = true;
    savetext = "Enter name here";
    fill(255);
  }

  boolean lvlGend2 = false;
  public void survivalScreen() {
    if (!lvlGend2) {
      lvl2.drawGraph();
      lvl2.generateLevel();
      lvlGend2 = true;
    }
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("Score: "+points+"         x"+bonusMultiplier, width/2, 25);
    if (!gamePaused)
      EM.run();
    pz.bonus();
    pzGrenades.Display();
    if (pzGrenades.time2< millis()&& pzGrenades.hasExploded ==false) {
      pzGrenades.targettype = 3+pzGrenades.colorTargetBonus;
      pzGrenades.hit();
    }
  }

  public void survivalGameOver() {
    fill(0);
    textSize(52);
    textAlign(CENTER);
    if (newRun == true) {
      localPoints = points;
      newRun = false;
      pzGrenades.hasExploded = true;
    }
    if (sb.clicked) {
      localName = tb2.Text;   
      if (points > highscore) {
        link("https://docs.google.com/document/d/1BDvwcpiaByMPB89EZXgYqP3h22itbywldKxY0k7Xgh4/edit?usp=sharing");
      }
      pz.saveHighscore();
      points = 0;
      savetext = "Scored saved";
    }
    textSize(32);
    text(savetext, width/2, height/4+240);
    textSize(72);
    text("Game Over:"+localPoints, width/2, height/4);
    if (zggb.clicked) gamestate = 0;
    fill(255);
  }

  public void resetDeathMatch() {
    p1.currentHealth = p1.maxHealth;
    p2.currentHealth = p2.maxHealth;
    p1.pos = new PVector(4*40, 4.5f*40);
    p2.pos = new PVector(width-4*40, height-4.5f*40);
    p1Grenades.hasExploded = true;
    p2Grenades.hasExploded = true;
    resetWeapons(p1Glock, p1UZI, p1Shotgun, p1Grenades, WPMp1);
    resetWeapons(p2Glock, p2UZI, p2Shotgun, p2Grenades, WPMp2);
    for (WeaponCrate w : lvl1.weaponCrates) w.resetCrate();

    lvl1.reset();
    lvlGend1 = false;
  }

  public void resetSurvival() {
    EM = new EnemyManager();
    pz.currentHealth = pz.maxHealth;
    pz.pos = new PVector(width/2+100, height/2);
    pzGrenades.hasExploded = true;
    resetWeapons(pzGlock, pzUZI, pzShotgun, pzGrenades, WPMpz);
    for (WeaponCrate w : lvl2.weaponCrates) w.resetCrate();

    lvl2.reset();
    lvlGend2 = false;
  }

  public void resetWeapons(Weapon g, Weapon u, Weapon s, Weapon gr, WeaponManager WPM) {
    g.maxBullets = 20;
    u.maxBullets = 40;
    s.maxBullets = 15;
    gr.maxBullets = 15;

    g.currentBullets = g.maxBullets;
    u.currentBullets = u.maxBullets;
    s.currentBullets = s.maxBullets;
    gr.currentBullets = gr.maxBullets;

    updateWeaponText(WPM, g, u, s, g);
    WPM.WeaponID = 1;
  }
}
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
  int c;
  int explosionRange = 200;
  float bombDelay = 700;
  int colorTarget1, colorTarget2, colorTargetBonus;
  boolean hasExploded = true;
  Weapon(PVector pos, int dir, int posx, int posy, int maxBullets, int currentBullets, int c, float fireRate, int damage, float time, int colorTarget1, int colorTarget2, int colorTargetBonus, int playerNR ) { //int animation, float time2, boolean hasExploded
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
  public void shoot() {

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

  public void buckshot() {
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


  public void swing() {
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



  public void bomb() {
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



  public void hit() {
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
              x = x-1;  //Når man fjerner et element fra en arraylist bliver alle elementer indexnr med en højere værdi end den der blev fjernet minuset med 1
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

          if (d <= swordSize*1.5f) {
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
          Life = Life - ((explosionRange/d2)*damage); //Skaden bliver dermed mindre desto længerede væk man er granaten (Hvis fjenderne binder sig i explosion radiusen.
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
      if (z <= swordSize*1.5f) {
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
      if (n <= swordSize*1.5f) {
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

  public void Display() {

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
//bane klasse
class Level {
  ArrayList<LevelTile> levelTiles;

  ArrayList<WeaponCrate> weaponCrates;
  int crateSpawnRate, nextCrateTime;
  int currentCrates, maxCrates = 3;

  ArrayList<PVector> points, openSet;
  ArrayList<Connection> cons;
  PVector newPoint, current;

  //antal rækker og kolonner med leveltiles
  int rows, columns;
  //størrelsen af væggene
  int cellSize;

  //banens seed, bruges til procedural generation
  int seed;
  //om banen er synling eller ej
  int visible;  

  //konstruktør
  Level(int s, int v, int cs) {
    seed = s;
    visible = v;
    cellSize = cs;
    levelTiles = new ArrayList<LevelTile>();
    rows = height/(cellSize*9);
    columns = width/(cellSize*8);
    points = new ArrayList<PVector>();
    addPoints();
    openSet = new ArrayList<PVector>();
    cons = new ArrayList<Connection>();
    openSet.add(points.get(0));
    randomSeed(seed);

    weaponCrates = new ArrayList<WeaponCrate>();
    addCrates();
  }

  public void reset() {
    levelTiles = new ArrayList<LevelTile>();
    rows = height/(cellSize*9);
    columns = width/(cellSize*8);
    points = new ArrayList<PVector>();
    addPoints();
    openSet = new ArrayList<PVector>();
    cons = new ArrayList<Connection>();
    openSet.add(points.get(0));
    randomSeed(seed);
    
    weaponCrates = new ArrayList<WeaponCrate>();
    addCrates();
  }

  public void addPoints() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        points.add(new PVector(40*8*i+40*4, 40*9*j+40*4.5f));
      }
    }
  }

  public ArrayList<PVector> neighbors(PVector p) {
    ArrayList<PVector> returns = new ArrayList<PVector>();

    for (PVector o : points) {
      if (o.x == p.x) {
        if (o.y == p.y + cellSize*9) {
          returns.add(o);
        }
        if (o.y == p.y - cellSize*9) {
          returns.add(o);
        }
      }
      if (o.y == p.y) {
        if (o.x == p.x + cellSize*8) {
          returns.add(o);
        }
        if (o.x == p.x - cellSize*8) {
          returns.add(o);
        }
      }
    }
    return returns;
  }

  public boolean Stuck(PVector p) {
    int nCounter = 0;
    ArrayList<PVector> neighbors = neighbors(p);
    for (PVector o : neighbors) {
      if (openSet.contains(o)) {
        nCounter++;
      }
    }
    if (nCounter == neighbors.size()) {
      return true;
    } else {
      return false;
    }
  }

  public void drawGraph() {
    randomSeed(seed);

    while (openSet.size() < points.size()) {
      current = openSet.get(openSet.size()-1);

      while (Stuck(current)) {
        current = openSet.get(PApplet.parseInt(random(0, openSet.size()-1)));
      }

      ArrayList<PVector> neighbors = neighbors(current);
      newPoint = neighbors.get(PApplet.parseInt(random(0, neighbors.size())));
      if (!openSet.contains(newPoint)) {
        openSet.add(newPoint);
      }

      cons.add(new Connection(current, newPoint));
    }
    for (Connection c : cons) {
      c.display();
    }
  }
  public void generateLevel() {
    for (int i = 0; i < points.size(); i++) {
      levelTiles.add(new LevelTile(PApplet.parseInt(points.get(i).x-4*cellSize), PApplet.parseInt(points.get(i).y-4.5f*cellSize), cellSize));
    }
  }

  public void addCrates() {
    randomSeed(seed);
    for (int i = 0; i < maxCrates; i++) {
      PVector spawnPoint = new PVector(points.get(PApplet.parseInt(random(0, points.size()))).x, points.get(PApplet.parseInt(random(0, points.size()))).y);
      weaponCrates.add(new WeaponCrate(spawnPoint, 40, 60));
    }
  }

  public void update() {

    if (visible == 6) {
      for (int i = 0; i < weaponCrates.size(); i++) {
        if (weaponCrates.get(i).collideWith(pz, pz.radius)) {
          //give player loot

          weaponCrates.get(i).giveLoot(pz);
          weaponCrates.get(i).collected = true;
        }
      }
    }

    if (visible == 3) {
      for (int i = 0; i < weaponCrates.size(); i++) {
        if (weaponCrates.get(i).collideWith(p1, p1.radius)) {
          //give player loot
          weaponCrates.get(i).giveLoot(p1);
          weaponCrates.get(i).collected = true;
        }
      }

      for (int i = 0; i < weaponCrates.size(); i++) {
        if (weaponCrates.get(i).collideWith(p2, p2.radius)) {
          //give player loot

          weaponCrates.get(i).giveLoot(p2);
          weaponCrates.get(i).collected = true;
        }
      }
    }
  }

  //tegner tiles
  public void display() {
    for (LevelTile l : levelTiles) l.run();
    for (WeaponCrate w : weaponCrates) w.run();
  }

  //opdaterer og tegner bane hvis den er synlig
  public void run() {
    if (visible == gamestate) {
      update();
      display();
    }
  }
}

//laver en 8x9 walltile stor tile
class LevelTile {
  PVector pos;
  ArrayList<WallTile> wallTiles;

  //størrelsen af hver celle
  int cellSize;
  //bredde og højde af tile
  int tileRows, tileColumns;

  int rows, columns;

  //angiver typen af tile, hvor: 
  //0 ingen vægge
  //1 væg til venstre
  //2 væg øverst
  //3 væg til højre
  //4 væg nederst
  //5 vægge til venstre og nederst
  //6 vægge til venstre og øverst
  //7 vægge til højre og øverst
  //8 vægge til højre og nederst
  int type = 0;

  boolean openTop, openBottom, openLeft, openRight;

  //konstruktør
  LevelTile (int i, int j, int cs) {
    pos = new PVector(i, j);
    cellSize = cs;
    tileRows = 8;
    tileColumns = 9;
    rows = height/(cellSize*9);
    columns = width/(cellSize*8);
    //spawnTile = true;
    //hasWeaponCrate = false;
    wallTiles = new ArrayList<WallTile>();
    type = setType();
    addWallTiles();
  }

  public int setType() {

    int type = 0;

    int cUp, cDown, cLeft, cRight;

    cUp = get(PApplet.parseInt(pos.x + 4*cellSize), PApplet.parseInt(pos.y + 4.5f*cellSize - 50));
    cDown = get(PApplet.parseInt(pos.x + 4*cellSize), PApplet.parseInt(pos.y + 4.5f*cellSize + 50));
    cLeft = get(PApplet.parseInt(pos.x + 4*cellSize - 50), PApplet.parseInt(pos.y + 4.5f*cellSize));
    cRight = get(PApplet.parseInt(pos.x + 4*cellSize + 50), PApplet.parseInt(pos.y + 4.5f*cellSize));

    if (cUp ==     -6618981) {
      openTop = true;
    } else {
      openTop = false;
    }
    if (cDown ==     -6618981) {
      openBottom = true;
    } else {
      openBottom = false;
    }
    if (cLeft ==     -6618981) {
      openLeft = true;
    } else {
      openLeft = false;
    }
    if (cRight ==     -6618981) {
      openRight = true;
    } else {
      openRight = false;
    }

    if (openTop  && openBottom  && openRight  && openLeft)  type = 0;
    if (openTop  && openBottom  && openRight  && !openLeft) type = 1; 
    if (!openTop && openBottom  && openRight  && openLeft)  type = 2; 
    if (openTop  && openBottom  && !openRight && openLeft)  type = 3;
    if (openTop  && !openBottom && openRight  && openLeft)  type = 4; 
    if (openTop  && !openBottom && !openRight && openLeft)  type = 8; 
    if (!openTop && openBottom  && !openRight && openLeft)  type = 7; 
    if (!openTop && openBottom  && openRight  && !openLeft) type = 6; 
    if (openTop  && !openBottom && openRight  && !openLeft) type = 5; 
    if (openTop  && !openBottom && !openRight && !openLeft) type = 9;
    if (!openTop && !openBottom && openRight  && !openLeft) type = 10; 
    if (!openTop && openBottom  && !openRight && !openLeft) type = 11; 
    if (!openTop && !openBottom && !openRight && openLeft)  type = 12; 
    if (openTop  && openBottom  && !openRight && !openLeft) type = 13; 
    if (!openTop && !openBottom && openRight  && openLeft)  type = 14; 
    return type;
  }

  //laver en tile med vægge efter type
  public void addWallTiles() {

    for (int i = 0; i < tileRows; i++) {
      for (int j = 0; j < tileColumns; j++) {
        switch(type) {           

        case 0:
          break;

        case 1:
          if (i==0) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 2:
          if (j==0) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 3:
          if (i==tileRows - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 4:
          if (j==tileColumns - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 5:
          if (i == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 6:
          if (i == 0 || j == 0) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 7:
          if (i == tileRows - 1 || j==0) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 8:
          if (i==tileRows - 1 || j == tileColumns - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;         

        case 9:
          if (i == 0 || i == tileRows - 1 || j == tileColumns - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 10:
          if (i == 0 || j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 11:
          if (i == 0 || i == tileRows - 1 || j == 0) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 12:
          if (i == tileRows - 1 || j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 13:
          if (i == 0 || i == tileRows - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        case 14:
          if (j == 0 || j == tileColumns - 1) wallTiles.add(new WallTile(PApplet.parseInt(pos.x)+i*cellSize, PApplet.parseInt(pos.y)+j*cellSize, cellSize));
          break;

        default:
          type = 0;
          break;
        }
      }
    }
  }

  public void update() {
    //check kollision mellem relevante spillere og vægge
    for (WallTile w : wallTiles) {
      for (Player p : players) {
        if (w.collision(p.pos, p.radius)) {
          if (w.isUp(p.pos)) {
            p.pos.y = w.pos.y - p.radius;
          } else if (w.isDown(p.pos)) {
            p.pos.y = w.pos.y + w.size + p.radius;
          }
          if (w.isLeft(p.pos)) {
            p.pos.x = w.pos.x - p.radius;
          } else if (w.isRight(p.pos)) {
            p.pos.x = w.pos.x + w.size + p.radius;
          }
        }
      }
      for (Enemy e : EM.Enemies) {
        PVector displace = new PVector(e.vel.x, e.vel.y);
        if (w.collision(e.pos, e.radius)) {
          //e.vel.mult(0);
          if (w.isUp(e.pos)) {
            e.pos.y = w.pos.y - e.radius - displace.y;
          } else if (w.isDown(e.pos)) {
            e.pos.y = w.pos.y + w.size + e.radius + displace.y;
          }
          if (w.isLeft(e.pos)) {
            e.pos.x = w.pos.x - e.radius - displace.x;
          } else if (w.isRight(e.pos)) {
            e.pos.x = w.pos.x + w.size + e.radius + displace.x;
          }
        }
      }
      for (ShooterEnemy s : EM.ShooterEnemies) {
        //kollision mellem shooterenemy og væg
        PVector displace = new PVector(s.vel.x, s.vel.y);
        if (w.collision(s.pos, s.radius)) {
          //s.vel.mult(0);
          if (w.isUp(s.pos)) {
            s.pos.y = w.pos.y - s.radius - displace.y;
          } else if (w.isDown(s.pos)) {
            s.pos.y = w.pos.y + w.size + s.radius + displace.y;
          }
          if (w.isLeft(s.pos)) {
            s.pos.x = w.pos.x - s.radius - displace.x;
          } else if (w.isRight(s.pos)) {
            s.pos.x = w.pos.x + w.size + s.radius + displace.x;
          }
        }
        for (Bullet b : s.bullets) {
          //fjern bullet når den rammer væg
          if (w.collision(b.pos, b.radius)) {
            b.pos = new PVector(2*width, 2*height);
          }
        }
      }
    }
  }

  //tegner vægge
  public void display() {
    for (WallTile w : wallTiles) w.run();
  }

  //opdatere og tegner tile
  public void run() {
    update();
    display();
  }
}

class Connection {
  PVector current, newPoint;
  Connection(PVector c, PVector nP) {
    current = c;
    newPoint = nP;
  }
  public void display() {
    stroke(155,0,155);
    line(current.x, current.y, newPoint.x, newPoint.y);
  }
}
class Player {
  PVector pos, vel = new PVector();
  PImage look, glock, uzi, shotgun1, shotgun2, sword1, sword2;
  int upKey, downKey, leftKey, rightKey, shootKey, changeKey;
  int dir;
  boolean up, down, left, right, shoot, change;
  float theta = 0;
  int col;
  float currentHealth, maxHealth;
  int visible;
  float time;
  int playerNR;
  float radius;
  float speed = 5;

  //player constructor
  Player(int playerNR, PVector p, float radius, int c, int u, int d, int l, int r, int q, int e, float maxHealth, int v, int dir, PImage look) {
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

  public void keyPress() {
    if (keyCode == upKey || key == upKey) up = true;
    if (keyCode == downKey || key ==  downKey) down = true;
    if (keyCode == leftKey || key == leftKey) left = true;
    if (keyCode == rightKey || key == rightKey) right = true;
    if (keyCode == shootKey || key == shootKey) shoot = true;
    if (keyCode == changeKey || key == changeKey) change = true;
  }

  public void keyRelease() {
    if (keyCode == upKey || key == upKey) up = false;
    if (keyCode == downKey || key == downKey) down = false;
    if (keyCode == leftKey || key == leftKey) left = false;
    if (keyCode == rightKey || key == rightKey) right = false;
    if (keyCode == shootKey || key == shootKey) shoot = false;
  }

  public void move() {
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

  public void heal(float healAmount) {
    if (currentHealth < maxHealth) {
      currentHealth += healAmount;
    } else if (currentHealth > maxHealth) {
      currentHealth = maxHealth;
    }
  }

  public void takeDamage(float damage) {
    damagedTime = millis();

    currentHealth -= damage;

    if (currentHealth <= 0) dead();
  }

  public void dead() {
    gamestate += 1;
  }

  float damagedTime = 0;
  float healTime = 7500;
  public void update() {

    if (millis() >= damagedTime + healTime) {
      heal(0.5f);
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


  public PVector getPos() {
    return pos;
  }
  
  float armpos = 0; 
  float hitdir = 1;
  float cooldown = 0;
  public void swingAnimation(PImage p) {
    pushMatrix();
    image(p, 0, -armpos-50);
    popMatrix();
    if (armpos <= 0) cooldown ++;
    if (cooldown > 54) {
      cooldown = 0;
      armpos = 0.5f;
      hitdir = abs(hitdir);
    }
    if (armpos > 0) armpos += hitdir*1;
    if (armpos >= 5 && armpos <= 10) armpos += hitdir*3;
    if (armpos >=15) armpos += hitdir*1;    
    if (armpos >= 20) {
      hitdir = -hitdir ;
    }
  }

  public void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    stroke(0);
    fill(245, 0, 0);
    textSize(20);
    switch (playerNR) {
    case 1:
      text(WPMp1.WeaponText, 0, -80);
            if (WPMp1.WeaponID == 4 && p1Sword.time < (millis())){
          fill(255,102,0);
        rect(-28, -48, 55, 7);
      }
       else if (WPMp1.WeaponID == 4 && p1Sword.time >= (millis())){
          fill(155,140);
        rect(-28, -48, 55, 7);
      }
      break;
    case 2:
      text(WPMp2.WeaponText, 0, -80);
            if (WPMp2.WeaponID == 4 && p2Sword.time < (millis())){
          fill(255,102,0);
        rect(-28, -48, 55, 7);
      }
       else if (WPMp2.WeaponID == 4 && p2Sword.time >= (millis())){
          fill(155,140);
        rect(-28, -48, 55, 7);
      }
      break;
    case 3:
      text(WPMpz.WeaponText, 0, -80);
      if (WPMpz.WeaponID == 4 && pzSword.time < (millis())){
          fill(255,102,0);
        rect(-28, -48, 55, 7);
      }
       else if (WPMpz.WeaponID == 4 && pzSword.time >= (millis())){
          fill(155,140);
        rect(-28, -48, 55, 7);
      }
      break;
    }
    fill(225,0,0);
    rect(-maxHealth/2, -70, maxHealth, 20);
    fill(col);
    rect(-maxHealth/2, -70, currentHealth, 20);

    fill(col);
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

  public void Update() {
    if (visible == gamestate) {
      update();
      //display();
    }
  }
  
  public void Display(){
    if (visible == gamestate){
      display();
    }
  }
  public void bonus() {
    if (bonustime < millis()) {
      if (bonusMultiplier > 3.1f) {
        bonusMultiplier -= 2;
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

  public void points() {
    bonusMultiplier += 1;
    bonustime = millis()+bonuslosetime;
    points += 10*bonusMultiplier;
  }

  public void saveHighscore() {
    localNR = 0;
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
class ShooterEnemy extends Enemy {
  ArrayList<Bullet> bullets;
  float time, nextAttackTime = 1;
  float phi;
  int life;
  float attackRange;
  PImage se;

  ShooterEnemy(PVector p, float s, float aR, int l) {
    super(p, s, l);
    life = l;
    attackRange = aR;
    bullets = new ArrayList<Bullet>();
    se = loadImage("se.png");
  }

  public void shoot() {
    bullets.add(new Bullet(new PVector(pos.x, pos.y), phi, 25, color(255, 255, 0)));
  }

  public void attack() {
    //phi = atan2(pz.pos.y-pos.y, pz.pos.x-pos.x) + PI;
    if (millis() > time+nextAttackTime*1000) {
      shoot();
      time = millis();
    }
  }

  public void update() {    
    phi = atan2(pz.pos.y-pos.y, pz.pos.x-pos.x);    
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
        pz.takeDamage(25);
      }
      if (b.isDead()) {
        bullets.remove(i);
      }
    }

    pos.add(vel);
  }

  public void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255,0,0);
    circle(0, 0, 2*radius);
    rotate(phi+PI/2);
    image(se, 10-radius, 11-radius);
    popMatrix();
  }

  public void run() {
    update(); 
    display();
  }
}

class Bullet {
  PVector pos, vel;
  float angle;
  float radius;
  int col;
  boolean hasHit = false;

  Bullet(PVector p, float a, float r, int c) {
    pos = p;
    angle = a;
    radius = r;
    col = c;
    vel = new PVector(cos(angle)*6, sin(angle)*6);
  }

  public boolean hitPlayer() {
    if (dist(pz.pos.x, pz.pos.y, pos.x, pos.y) <= pz.radius+radius) {
      return true;
    } else {
      return false;
    }
  }

  public boolean isDead() {
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0 || hitPlayer()) {
      return true;
    } else {
      return false;
    }
  }

  public void update() {
    pos.add(vel);
  }

  public void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(col);
    noStroke();
    circle(0, 0, radius*2);
    translate(0, 0);
    popMatrix();
  }

  public void run() {
    update();
    display();
  }
}
class TextBox {

  //position and size
  PVector position, size;

  //visibility
  int visible;

  //colors
  int Background = color(140, 140, 140);
  int Foreground = color(0, 0, 0);
  int BackgroundSelected = color(160, 160, 160);
  int Border = color(30, 30, 30);

  //border
  boolean BorderEnable = false;
  int BorderWeight = 1;

  //text and textsize
  int TEXTSIZE = 48;
  String Text = "";
  int TextLength = 0;

  //if button is clicked
  boolean selected = false;

  //constructor
  TextBox(PVector position, PVector size, int visible) {
    this.position = position;
    this.size = size;
    this.visible = visible;
  }

  //display and run textbox
  public void display() {

    pushMatrix();

    if (visible == gamestate) {
      // DRAWING THE BACKGROUND
      if (selected) {
        fill(BackgroundSelected);
      } else {
        fill(Background);
      }

      if (BorderEnable) {
        strokeWeight(BorderWeight);
        stroke(Border);
      } else {
        noStroke();
      }

      rectMode(CORNER);

      rect(position.x, position.y, size.x, size.y);

      // DRAWING THE TEXT ITSELF
      fill(Foreground);
      textSize(TEXTSIZE);
      textAlign(CORNER);

        text(Text, position.x + (textWidth("a") / 2), position.y + TEXTSIZE);
    } else {
      //sletter texten når man ikke er på menuen længere
      clearText();
    }
    popMatrix();
  }

  //check if key has been typed
  public boolean keyWasTyped(char KEY, int KEYCODE) {

    if (visible == gamestate) {
      if (selected) {
        if (KEYCODE == (int)BACKSPACE) {
          backSpace();
        } else if (KEYCODE == 32) {
            addText(' ');
        } else if (KEYCODE == (int)ENTER) {
          return true;
        } else {
          // CHECK IF THE KEY IS A LETTER OR A NUMBER
          boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Ø');
          boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'ø');
          boolean isKeyNumber = (KEY >= '0' && KEY <= '9');
          boolean isKeySign = (KEY >= 30 && KEY <= 200);


          if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber || isKeySign) {
            addText(KEY);
          }
        }
      }
    }
    return false;
  }

  //add text to textbox
  public void addText(char text) {
    if (textWidth(Text + text) < (size.x)) {
      Text += text;
      TextLength++;
    }
  }

  //remove text if backspace is pressed
  public void backSpace() {
    if (TextLength - 1 >= 0) {
      Text = Text.substring(0, TextLength - 1);
      TextLength--;
    }
  }

  //check if mouse is over box
  public boolean overBox(int x, int y) {
    if (x >= position.x && x <= position.x + size.x) {
      if (y >= position.y && y <= position.y + size.y ) {
        return true;
      }
    }

    return false;
  }

  //check if mouse has been pressed
  public void pressed(int x, int y) {
    if (overBox(x, y)) {
      selected = true;
    } else {
      selected = false;
    }
  }

  //remove all text
  public void clearText() {
    TextLength = 0;
    Text = "";
  }
}
class WallTile {
  PVector pos;
  int size;
  ArrayList<PVector> playerPos;

  WallTile(int i, int j, int s) {
    pos = new PVector(i, j);
    size = s;
  }

  public boolean isUp(PVector p) {
    if (p.x >= pos.x && p.x <= pos.x + size && p.y <= pos.y) {
      return true;
    } else {
      return false;
    }
  }

  public boolean isDown(PVector p) {
    if (p.x >= pos.x && p.x <= pos.x + size && p.y >=pos.y+size) {
      return true;
    } else {
      return false;
    }
  }

  public boolean isLeft(PVector p) {
    if (p.y >= pos.y && p.y <= pos.y + size && p.x <= pos.x) {
      return true;
    } else {
      return false;
    }
  }

  public boolean isRight(PVector p) {
    if (p.y >= pos.y && p.y <= pos.y + size && p.x >= pos.x + size) {
      return true;
    } else {
      return false;
    }
  }

  public boolean collision(PVector p, float s) {
    
    float testX = p.x;
    float testY = p.y;

    if (p.x < pos.x)    testX = pos.x;
    else if (p.x > pos.x+size)  testX = pos.x+size;
    if (p.y < pos.y)    testY = pos.y;
    else if (p.y > pos.y+size)  testY = pos.y+size;

    float distX = p.x-testX;
    float distY = p.y-testY;
    float distance = sqrt(pow(distX, 2)+pow(distY, 2));

    if (distance <= s) {
      return true;
    } else {
      return false;
    }
  }


  public void update() {
  }

  public void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(150);
    rect(0, 0, size, size);
    fill(255);
    popMatrix();
  }

  public void run() {
    update();
    display();
  }
}
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

  String unlockedText = "";
  float unlockedShowTime = 60, unlockedTextPos = height-100;
  boolean unlockedUZI, unlockedShotgun, unlockedGrenades;
  boolean unlocked;


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
    pzGlock.currentBullets = pzGlock.maxBullets;
    pzUZI.currentBullets = 0;
    pzShotgun.currentBullets = 0;
    pzGrenades.currentBullets = 0;
  }

  public boolean collideWith(Player p, float s) {

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

  public void giveLoot(Player p) {
    if (!collected) {
      if (p.currentHealth != p.maxHealth) {
        lootType = PApplet.parseInt(random(0, 5));
      } else {
        lootType = PApplet.parseInt(random(1, 5));
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
        if (p == pz) {
          if (!unlockedUZI) {
            givenLoot = "Picked Up Glock Ammo!";
            pzGlock.currentBullets = pzGlock.maxBullets;
            updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
          } else {
            if (pzUZI.currentBullets == 0) {
              givenLoot = "Picked Up UZI!";
            } else {
              givenLoot = "Picked Up UZI Ammo!";
            }
            pzUZI.currentBullets = pzUZI.maxBullets;
            updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
          }
        }
        if (p == p1) {
          if (p1UZI.currentBullets == 0) {
            givenLoot = "Picked Up UZI!";
          } else {
            givenLoot = "Picked Up UZI Ammo!";
          }
          p1UZI.currentBullets = p1UZI.maxBullets;
          updateWeaponText(WPMp1, p1Glock, p1UZI, p1Shotgun, p1Grenades);
        }
        if (p == p2) {
          if (p1UZI.currentBullets == 0) {
            givenLoot = "Picked Up UZI!";
          } else {
            givenLoot = "Picked Up UZI Ammo!";
          }
          p2UZI.currentBullets = p2UZI.maxBullets;
          updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
        }
        break;

      case 3:
        if (p == pz) {
          if (!unlockedShotgun) {
            givenLoot = "Picked Up Glock Ammo!";
            pzGlock.currentBullets = pzGlock.maxBullets;
            updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
          } else {
            if (pzShotgun.currentBullets == 0) {
              givenLoot = "Picked Up Shotgun!";
            } else {
              givenLoot = "Picked Up Shotgun Ammo!";
            }
            pzShotgun.currentBullets = pzShotgun.maxBullets;
            updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
          }
        }
        if (p == p1) {
          if (p1Shotgun.currentBullets == 0) {
            givenLoot = "Picked Up Shotgun!";
          } else {
            givenLoot = "Picked Up Shotgun Ammo!";
          }
          p1Shotgun.currentBullets = p1Shotgun.maxBullets;
          updateWeaponText(WPMp1, p1Glock, p1UZI, p1Shotgun, p1Grenades);
        }
        if (p == p2) {
          if (p2Shotgun.currentBullets == 0) {
            givenLoot = "Picked Up Shotgun!";
          } else {
            givenLoot = "Picked Up Shotgun Ammo!";
          }
          p2Shotgun.currentBullets = p2Shotgun.maxBullets;
          updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
        }
        break;

      case 4:
        if (p == pz) {
          if (!unlockedGrenades) {
            givenLoot = "Picked Up Glock Ammo!";
            pzGlock.currentBullets = pzGlock.maxBullets;
            updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
          } else {
            if (pzGrenades.currentBullets == 0) {
              givenLoot = "Picked Up Grenades!";
            } else {
              givenLoot = "Picked Up Grenade Ammo!";
            }
            pzGrenades.currentBullets = pzGrenades.maxBullets;
            updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
          }
        }
        if (p == p1) {
          if (p1Grenades.currentBullets == 0) {
            givenLoot = "Picked Up Grenades!";
          } else {
            givenLoot = "Picked Up Grenade Ammo!";
          }
          p1Grenades.currentBullets = p1Grenades.maxBullets;
          updateWeaponText(WPMp1, p1Glock, p1UZI, p1Shotgun, p1Grenades);
        }
        if (p == p2) {
          if (p2Grenades.currentBullets == 0) {
            givenLoot = "Picked Up Grenades!";
          } else {
            givenLoot = "Picked Up Grenade Ammo!";
          }
          p2Grenades.currentBullets = p2Grenades.maxBullets;
          updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
        }
        break;

      default:
        lootType = 1;
        break;
      }
    }
  }

  public void showLootText() {
    if (collected && showTime > 0) {
      fill(0, 255, 0);
      textMode(CENTER);
      textSize(24);
      text(givenLoot, width/2, textPos);
      textMode(CORNER);
      showTime--;
      textPos--;
    }

    if (upgraded && upgradeShowTime > 0) {
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

    if (unlocked && unlockedShowTime > 0) {
      fill(0, 255, 0);
      textMode(CENTER);
      textSize(24);
      text(unlockedText, width/2, unlockedTextPos);
      textMode(CORNER);
      unlockedShowTime--;
      unlockedTextPos--;
    }

    if (unlockedShowTime < 0) {
      unlocked = false;
      unlockedShowTime = 60;
      unlockedTextPos = height - 100;
    }
  }
  public void resetCrate() {
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
    unlockedUZI = false;
    unlockedShotgun = false;
    unlockedGrenades = false;

    pzGlock.damage = pzGlockDamage;
    pzUZI.damage = pzUZIDamage; 
    pzShotgun.damage = pzShotgunDamage; 
    pzGrenades.damage = pzGrenadesDamage;
    pzGlock.fireRate = pzGlockFireRate; 
    pzUZI.fireRate = pzUZIFireRate; 
    pzShotgun.fireRate = pzShotgunFireRate;
  }

  public void update() {
    if (collected && pickupNumber == 0) {
      nextSpawnTime = cooldown*1000+millis();
      pickupNumber++;
    }

    if (collected && millis() > nextSpawnTime) {
      collected = false;
      nextSpawnTime = cooldown*1000+millis();
    }

    if (points >= 1000 && !glockUpgrade3) {
      upgradeText = "Glock Rapid Fire!";
      pzGlock.fireRate = 400;
      upgraded = true;
      glockUpgrade3 = true;
    }

    if (points >= 2500 && !glockUpgrade1) {
      upgradeText = "Glock Double Ammo!";
      pzGlock.maxBullets = 40;
      pzGlock.currentBullets = pzGlock.maxBullets;
      updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
      upgraded = true;
      glockUpgrade1 = true;
    }

    if (points >= 5000 && !uziUpgrade3) {
      upgradeText = "Uzi Rapid Fire!";
      pzUZI.fireRate = 100;
      upgraded = true;
      uziUpgrade3 = true;
    }

    if (points >= 10000 && !uziUpgrade1) {
      upgradeText = "UZI Double Ammo!";
      pzUZI.maxBullets = 80;
      pzUZI.currentBullets = pzUZI.maxBullets;
      updateWeaponText(WPMpz, pzGlock, pzUZI, pzShotgun, pzGrenades);
      upgraded = true;
      uziUpgrade1 = true;
    }
    if (points >= 15000 && !shotgunUpgrade3) {
      upgradeText = "Shotgun Rapid Fire!";
      pzShotgun.fireRate = 250;
      upgraded = true;
      shotgunUpgrade3 = true;
    }
    if (points >= 20000 && !shotgunUpgrade1) {
      upgradeText = "Shotgun Double Ammo!";
      pzShotgun.maxBullets = 30;
      pzShotgun.currentBullets = pzShotgun.maxBullets;
      updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
      upgraded = true;
      shotgunUpgrade1 = true;
    }
    if (points >= 25000 && !grenadeUpgrade1) {
      upgradeText = "Grenades Double Ammo!";
      pzGrenades.maxBullets = 20;
      pzGrenades.currentBullets = pzGrenades.maxBullets;
      updateWeaponText(WPMp2, p2Glock, p2UZI, p2Shotgun, p2Grenades);
      upgraded = true;
      grenadeUpgrade1 = true;
    }

    combo = bonusMultiplier;
    if (combo >= 5 && !unlockedUZI) {
      unlocked = true;
      unlockedUZI = true;
      pzUZI.currentBullets = pzUZI.maxBullets;
      unlockedText = "Picked Up UZI!";
    }
    if (combo >= 15 && !unlockedShotgun) {
      unlocked = true;
      unlockedShotgun = true;
      pzShotgun.currentBullets = pzShotgun.maxBullets;
      unlockedText = "Picked Up Shotgun!";
    }
    if (combo >= 30 && !unlockedGrenades) {
      unlocked = true;
      unlockedGrenades = true;
      pzGrenades.currentBullets = pzGrenades.maxBullets;
      unlockedText = "Picked Up Grenades!";
    }

    if (combo >= 50 && !glockUpgrade2) {
      pzGlock.damage = 160;
    }

    if (combo >= 100 && !uziUpgrade2) {
      pzUZI.damage = 90;
    }

    if (combo >= 150 && !shotgunUpgrade2) {
      pzShotgun.damage = 100;
    }

    if (combo >= 200 && !grenadeUpgrade2) {
      pzGrenades.damage = 200;
    }
  }

  public void display() {

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

  public void run() {
    update();
    display();
  }
}

public void updateWeaponText(WeaponManager W, Weapon Glock, Weapon UZI, Weapon Shotgun, Weapon Grenades) {

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
class WeaponManager { //<>//
  String WeaponName1 ="Glock", WeaponName2 = "UZI", WeaponName3= "Shotgun", WeaponName4= "Sword", WeaponName5= "Grenades";
  int WeaponID=1;
  int PlayerNR;
  float time = 0;
  float changeTime = 500;
  int BulletsCurrent = 20;
  String WeaponText;

  WeaponManager(int PlayerNR, float time, int WeaponID, String WeaponText, int BulletsCurrent ) {
    this.PlayerNR = PlayerNR;
    this.time = time;
    this.WeaponID = WeaponID;
    this.WeaponText = WeaponText;
    this.BulletsCurrent = BulletsCurrent;
  }
  public void WeaponChange() {

    switch(PlayerNR) {
    case 1:
      if (time < millis()) {
        WeaponID += 1;
        time = millis()+changeTime;
        switch(WeaponID) {
        case 1:
          if  (p1Glock.currentBullets>0) {
            WeaponText = WeaponName1+" "+p1Glock.currentBullets+"/"+p1Glock.maxBullets;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 2:
          if  (p1UZI.currentBullets>0) {
            WeaponText = WeaponName2+" "+p1UZI.currentBullets+"/"+p1UZI.maxBullets;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 3:
          if  (p1Shotgun.currentBullets>0) {
            WeaponText = WeaponName3+" "+p1Shotgun.currentBullets+"/"+p1Shotgun.maxBullets;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 4:
          if  (p1Sword.currentBullets>0) {
            WeaponText = WeaponName4;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 5: 
          if  (p1Grenades.currentBullets>0) {
            WeaponText = WeaponName5+" "+p1Grenades.currentBullets+"/"+p1Grenades.maxBullets;
          } else { 
            WeaponID = 1;
          }
          break;
        case 6:
          WeaponID = 1;
          WeaponText = WeaponName1+" "+p1Glock.currentBullets+"/"+p1Glock.maxBullets;
          break;
        } 
        break;
      } else {
        break;
      }
    case 2:
      if (time < millis()) {
        WeaponID += 1;
        time = millis()+changeTime;
        switch(WeaponID) {
        case 1:
          if  (p1Glock.currentBullets>0) {
            WeaponText = WeaponName1+" "+p2Glock.currentBullets+"/"+p2Glock.maxBullets;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 2:
          if  (p2UZI.currentBullets>0) {
            WeaponText = WeaponName2+" "+p2UZI.currentBullets+"/"+p2UZI.maxBullets;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 3:
          if  (p2Shotgun.currentBullets>0) {
            WeaponText = WeaponName3+" "+p2Shotgun.currentBullets+"/"+p2Shotgun.maxBullets;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 4:
          if  (p2Sword.currentBullets>0) {
            WeaponText = WeaponName4;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 5: 
          if  (p2Grenades.currentBullets>0) {
            WeaponText = WeaponName5+" "+p2Grenades.currentBullets+"/"+p2Grenades.maxBullets;
          } else { 
            WeaponID = 1;
          }
          break;
        case 6:
          WeaponID = 1;
          WeaponText = WeaponName1+" "+p2Glock.currentBullets+"/"+p2Glock.maxBullets;
          break;
        } 
        break;
      } else {
        break;
      } 
    case 3:
      if ( time < millis()) {
        time = millis()+changeTime;
        WeaponID += 1;
        switch(WeaponID) {
        case 1:
          WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
          break;
        case 2:
          if  (pzUZI.currentBullets>0) {
            WeaponText = WeaponName2+" "+pzUZI.currentBullets+"/"+pzUZI.maxBullets;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 3:
          if  (pzShotgun.currentBullets>0) {
            WeaponText = WeaponName3+" "+pzShotgun.currentBullets+"/"+pzShotgun.maxBullets;
            break;
          } else { 
            WeaponID = WeaponID+1;
          }
        case 4:
          if  (pzSword.currentBullets>0) {
            WeaponText = WeaponName4;
            break;
          } else { 
            WeaponID = 1;
          }
        case 5:
          if  (pzGrenades.currentBullets>0) {
            WeaponText = WeaponName5+" "+pzGrenades.currentBullets+"/"+pzGrenades.maxBullets;
            break;
          } else { 
            WeaponID = 1;
          }
        case 6:
          WeaponID = 1;
          WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
          break;
        } 
        break;
      } else {
        break;
      }
    }
  }

  public void WeaponShoot() {
    switch(PlayerNR) {
    case 1:
      switch(WeaponID) {
      case 1:
        p1Glock.shoot();
        WeaponText = WeaponName1+" "+p1Glock.currentBullets+"/"+p1Glock.maxBullets;
        break;
      case 2:
        p1UZI.shoot();
        WeaponText = WeaponName2+" "+p1UZI.currentBullets+"/"+p1UZI.maxBullets;
        break;
      case 3:
        p1Shotgun.buckshot();
        WeaponText = WeaponName3+" "+p1Shotgun.currentBullets+"/"+p1Shotgun.maxBullets;
        break;
      case 4:
        p1Sword.swing();
        break;
      case 5:
        p1Grenades.bomb();
        WeaponText = WeaponName5+" "+p1Grenades.currentBullets+"/"+p1Grenades.maxBullets;
        break;
      }
      break;
    case 2:
      switch(WeaponID) {
      case 1:
        p2Glock.shoot();
        WeaponText = WeaponName1+" "+p2Glock.currentBullets+"/"+p2Glock.maxBullets;
        break;
      case 2:
        p2UZI.shoot();
        WeaponText = WeaponName2+" "+p2UZI.currentBullets+"/"+p2UZI.maxBullets;
        break;
      case 3:
        p2Shotgun.buckshot();
        WeaponText = WeaponName3+" "+p2Shotgun.currentBullets+"/"+p2Shotgun.maxBullets;
        break;
      case 4:
        p2Sword.swing();
        break;
      case 5:
        p2Grenades.bomb();
        WeaponText = WeaponName5+" "+p2Grenades.currentBullets+"/"+p2Grenades.maxBullets;
        break;
      }
      break;
    case 3:
      switch(WeaponID) {
      case 1:
        pzGlock.shoot();
        WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
        break;
      case 2:
        pzUZI.shoot();
        WeaponText = WeaponName2+" "+pzUZI.currentBullets+"/"+pzUZI.maxBullets;
        break;
      case 3:
        pzShotgun.buckshot();
        WeaponText = WeaponName3+" "+pzShotgun.currentBullets+"/"+pzShotgun.maxBullets;
        break;
      case 4:
        pzSword.swing();
        break;
      case 5:
        pzGrenades.bomb();
        WeaponText = WeaponName5+" "+pzGrenades.currentBullets+"/"+pzGrenades.maxBullets;
        break;
      }
      break;
    }
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "CrateSkullMain" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
