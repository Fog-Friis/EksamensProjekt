int gamestate;
ArrayList<Player> players;
Player p1, p2, pz;

ArrayList<TextBox> textBoxes;
TextBox tb1, tb2;

ArrayList<Level> levels;
Level lvl1, lvl2;

class GameStateManager {

  GameStateManager() {
    gamestate = 0;
    players = new ArrayList<Player>();
    textBoxes = new ArrayList<TextBox>();    
    levels = new ArrayList<Level>();
  }

  void setupManager() {
    p1 = new Player(new PVector(width/2-100, height/2), color(0, 255, 0), 'w', 's', 'a', 'd', 100, 3);
    players.add(p1);
    p2 = new Player(new PVector(width/2+100, height/2), color(0, 0, 255), 38, 40, 37, 39, 100, 3);
    //players.add(p2);
    pz = new Player(new PVector(width/2+100, height/2), color(0, 255, 0), 'w', 's', 'a', 'd', 100, 6);
    //players.add(pz);
    tb1 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), false, 4);
    textBoxes.add(tb1);
    tb2 = new TextBox(new PVector(width/2-200, height/2), new PVector(400, 70), false, 7);
    textBoxes.add(tb2);

    lvl1 = new Level(170, 3, 40);
    levels.add(lvl1);
    lvl2 = new Level(2501, 6, 40);
    levels.add(lvl2);
  }

  void manage() {

    for (Level l : levels) l.run();
    for (TextBox t : textBoxes) t.display();
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
  }

  void menuScreen() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("CrateSkull", width/2, height/6);
    fill(255);
  }

  void controlsScreen() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Controls", width/2, height/6);
    fill(255);
  }

  void deathMatchMenu() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("DeathMatch", width/2, height/6);
    fill(255);
  }

  void deathMatchScreen() {
  }

  void deathMatchGameOver() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Game Over", width/2, height/4);
    fill(255);
  }  

  void survivalMenu() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Zombie Survival", width/2, height/6);
    fill(255);
  }

  void survivalScreen() {
    fill(0);
    fill(255);
  }

  void survivalGameOver() {
    fill(0);
    textSize(72);
    textAlign(CENTER);
    text("Game Over", width/2, height/4);
    fill(255);
  }
}
