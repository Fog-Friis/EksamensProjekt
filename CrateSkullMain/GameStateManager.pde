int gamestate;
int killCount=0;
int bonusMultiplier = 1;
float bonuslosetime= 2000;
int points = 0; 
float bonustime;
ArrayList<Player> players;
Player p1, p2, pz;
PImage p1l_pzl;
PImage p2l;
String localName = "", savetext = "Enter name here";
int localNR, localPoints;

int ColpzTarget1 = -5066036;
int ColpzTarget2 = -65536;
//int ColpzTarget2 = -6618981;

int Colp1Target1 = -16711936;
int Colp1Target2 = -16711936;

int Colp2Target1 = -16776961;
int Colp2Target2 = -16776961;

Weapon pzGlock, p1Glock, p2Glock;
Weapon pzUZI, p1UZI, p2UZI;
Weapon pzSword, p1Sword, p2Sword;
Weapon pzShotgun, p1Shotgun, p2Shotgun;
Weapon pzGrenades,p1Grenades,p2Grenades;

WeaponManager WPMp1, WPMp2, WPMpz;
EnemyManager EM;
ArrayList<TextBox> textBoxes;
TextBox tb1, tb2, tbs1, tbs2;
ArrayList<Button> buttons;
Button zs, zss, zb, zggb, dm, dms, db, dggb, cs, cb, sb;
ArrayList<PVector> spawns;
boolean gamePaused;
boolean pausedScreen;
boolean newRun;

ArrayList<Level> levels;
Level lvl1, lvl2;

class GameStateManager {

  GameStateManager() {
    gamestate = 0; //<>//
    gamePaused = false;
    pausedScreen = false; //<>//
    p1l_pzl = loadImage("pz-p1.png");
    p2l = loadImage("p2.png");
    players = new ArrayList<Player>(); //<>//
    textBoxes = new ArrayList<TextBox>();  
    buttons = new ArrayList<Button>(); //<>//
    spawns = new ArrayList<PVector>();
    levels = new ArrayList<Level>();
  }
  // -6618981 shooter
  // -65536 enemy
  void setupManager() {
    pzGlock = new Weapon (new PVector(width/2+100, height/2),0,0,0,20,20,color(1),800,100,0,ColpzTarget1,ColpzTarget2,0,3);
    pzUZI = new Weapon (new PVector(width/2+100, height/2),0,0,0,40,40,color(1),300,80,0,ColpzTarget1,ColpzTarget2,0,3);//
    pzSword = new Weapon (new PVector(width/2+100, height/2),0,0,0,1,1,color(1),500,100,0,ColpzTarget1,ColpzTarget2,0,3);
    pzShotgun = new Weapon (new PVector(width/2+100, height/2),0,0,0,15,15,color(1),500,50,0,ColpzTarget1,ColpzTarget2,0,3);   
    pzGrenades = new Weapon (new PVector(width/2+100, height/2),0,0,0,10,10,color(1),500,100,0,ColpzTarget1,ColpzTarget2,0,3);

    p1Glock = new Weapon (new PVector(width/2+100, height/2),0,0,0,20,20,color(1),800,75,0,Colp1Target1,Colp1Target2,4,1);
  p1UZI = new Weapon (new PVector(width/2+100, height/2),0,0,0,40,40,color(1),100,70,0,Colp1Target1,Colp1Target2,4,1);
 p1Sword = new Weapon (new PVector(width/2+100, height/2),0,0,0,1,1,color(1),500,80,0,Colp1Target1,Colp1Target2,4,1);;
  p1Shotgun = new Weapon (new PVector(width/2+100, height/2),0,0,0,15,15,color(1),500,80,0,Colp1Target1,Colp1Target2,4,1);
  p1Grenades = new Weapon (new PVector(width/2+100, height/2),0,0,0,10,10,color(1),500,100,0,Colp1Target1,Colp1Target2,4,1);
    
 p2Glock = new Weapon (new PVector(width/2+100, height/2),0,0,0,20,20,color(1),800,15,0,Colp2Target1,Colp2Target2,8,2);
  p2UZI = new Weapon (new PVector(width/2+100, height/2),0,0,0,40,40,color(1),100,10,0,Colp2Target1,Colp2Target2,8,2);
  p2Sword = new Weapon (new PVector(width/2+100, height/2),0,0,0,1,1,color(1),500,10,0,Colp2Target1,Colp2Target2,8,2);
  p2Shotgun = new Weapon (new PVector(width/2+100, height/2),0,0,0,15,15,color(1),500,20,0,Colp2Target1,Colp2Target2,8,2);
  p2Grenades = new Weapon (new PVector(width/2+100, height/2),0,0,0,10,10,color(1),500,100,0,Colp2Target1,Colp2Target2,8,2);

    p1 = new Player(1, new PVector(width/2-100, height/2), 25, color(0, 255, 0), 'w', 's', 'a', 'd', 'q', 'e', 100, 3, 0, p1l_pzl);
    players.add(p1);
    p2 = new Player(2, new PVector(width/2+100, height/2), 25, color(0, 0, 255), 38, 40, 37, 39, 0, 0, 100, 3, 0, p2l);//Change shootkey and changekey
    players.add(p2);
    pz = new Player(3, new PVector(width/2+100, height/2), 25, color(0, 255, 0), 'w', 's', 'a', 'd', 'q', 'e', 100, 6, 0, p1l_pzl);
    players.add(pz);

    tb1 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), false, 4);
    textBoxes.add(tb1);
    tb2 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), false, 7);
    textBoxes.add(tb2);
    tbs1 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), false, 2);
    textBoxes.add(tbs1);
    tbs2 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), false, 5);
    textBoxes.add(tbs2);

    zs = new Button(new PVector(width/2-175, height*0.4-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Zombie Survival", 48, 0);
    buttons.add(zs);
    dm = new Button(new PVector(width/2-175, height*0.6-60), new PVector(350, 120), 5, color(150), color(160), color(140), "1v1 Deathmatch", 48, 0);
    buttons.add(dm);
    cs = new Button(new PVector(width/2-175, height*0.8-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Controls", 48, 0);
    buttons.add(cs);

    cb = new Button(new PVector(width/2-175, height*0.9-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 1);
    buttons.add(cb);
    db = new Button(new PVector(width/2-175, height*0.9-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 2);
    buttons.add(db);
    dggb = new Button(new PVector(width/2-175, height*0.9-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 4);
    buttons.add(dggb);
    zb = new Button(new PVector(width/2-175, height*0.9-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 5);
    buttons.add(zb);
    zggb = new Button(new PVector(width/2-175, height*0.9-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Back", 48, 7);
    buttons.add(zggb);
    sb = new Button(new PVector(width/2-175, height*0.9-200), new PVector(350, 120), 5, color(150), color(160), color(140), "Save", 48, 7);
    buttons.add(sb);

    dms = new Button(new PVector(width/2-175, height*0.75-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Start", 48, 2);
    buttons.add(dms);
    zss = new Button(new PVector(width/2-175, height*0.75-60), new PVector(350, 120), 5, color(150), color(160), color(140), "Start", 48, 5);
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

  void manage() {
    for (Level l : levels) l.run();
    for (TextBox t : textBoxes) t.display();
    if (!gamePaused)
      for (Player p : players) p.run();

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
      break;

    case 5:
      survivalMenu();
      break;

    case 6:
      survivalScreen();
      break;

    case 7:
      survivalGameOver();
      break;


    default:
      gamestate = 0;
      break;
    }
    for (Button b : buttons) b.run();
  }

  void menuScreen() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("CrateSkull", width/2, height/6);
    if (zs.clicked) gamestate = 5;
    if (dm.clicked) gamestate = 2;
    if (cs.clicked) gamestate = 1;
    fill(255);
  }

  void controlsScreen() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Controls", width/2, height/6);
    if (cb.clicked) gamestate = 0;
    fill(255);
  }

  void deathMatchMenu() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("DeathMatch", width/2, height/6);
    textSize(32);
    text("Indsæt seed:", width/2, height/2-20);
    lvl1.seed = int(tbs1.Text);
    if (dms.clicked) gamestate = 3;
    if (db.clicked) gamestate = 0;
    fill(255);
  }

  boolean lvlGend1 = false;
  void deathMatchScreen() {
    if (!lvlGend1) {
      lvl1.drawGraph();
      lvl1.generateLevel();
      lvlGend1 = true;
    }
    p1Grenades.Display();
    p2Grenades.Display();
  }

  void deathMatchGameOver() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Game Over", width/2, height/4);
    if (dggb.clicked) gamestate = 0;
    fill(255);
  }  

  void survivalMenu() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Zombie Survival", width/2, height/6);
    textSize(32);
    text("Indsæt seed:", width/2, height/2-20);
    lvl2.seed = int(tbs2.Text);
    if (zss.clicked) gamestate = 6;
    if (zb.clicked) gamestate = 0;
    points = 0;
    newRun = true;
    savetext = "Enter name here";
    fill(255);
  }

  boolean lvlGend2 = false;
  void survivalScreen() {
    if (!lvlGend2) {
      lvl2.drawGraph();
      lvl2.generateLevel();
      lvlGend2 = true;
    }
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("Score: "+points+"         x"+bonusMultiplier, width/2,25);
    if (!gamePaused)
      EM.run();
      pz.bonus();
      pzGrenades.Display();
  }

  void survivalGameOver() {
    fill(0);
    textSize(52);
    textAlign(CENTER);
    if (newRun == true){
    localPoints = points;
    newRun = false;
    }
    if (sb.clicked) {
    localName = tb2.Text;
    pz.saveHighscore();
    points = 0;
    savetext = "Scored saved";
    }
    text(savetext, width/2, height/4+240);
    textSize(72);
    text("Game Over:"+localPoints, width/2, height/4);
    if (zggb.clicked) gamestate = 0;
    fill(255);
  }
}
