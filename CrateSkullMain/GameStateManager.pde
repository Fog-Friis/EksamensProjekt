int gamestate;
class GameStateManager {

  GameStateManager() {
    gamestate = 0;
  }

  void setupManager() {
  }

  void manage() {
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
    text("Controls", width/2, height/6);
    fill(255);
  }

  void deathMatchMenu() {
    fill(0);
    text("DeathMatch", width/2, height/6);
    fill(255);
  }

  void deathMatchScreen() {
  }

  void deathMatchGameOver() {
    fill(0);
    text("Game Over", width/2, height/4);
    fill(255);
  }  

  void survivalMenu() {
    fill(0);
    text("Zombie Survival", width/2, height/6);
    fill(255);
  }

  void survivalScreen() {
    fill(0);
    fill(255);
  }

  void survivalGameOver() {
    fill(0);
    text("Game Over", width/2, height/4);
    fill(255);
  }
}
