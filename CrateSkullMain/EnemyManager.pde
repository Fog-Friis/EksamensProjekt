class EnemyManager {
  int EnemyCount = 50, ShooterEnemyCount = 1;
  int EnemySpawned, ShooterEnemySpawned;
  float EnemySpawnRate, ShooterEnemySpawnRate, nextEnemySpawn, nextShooterEnemySpawn;
  //int Escalation;
  ArrayList<PVector> SpawnPoints = new ArrayList<PVector>();
  ArrayList<Enemy> Enemies = new ArrayList<Enemy>();
  ArrayList<ShooterEnemy> ShooterEnemies = new ArrayList<ShooterEnemy>();

  EnemyManager() {
    SpawnPoints.add(new PVector(width/2, height/2));
  }
  
  void enemyCollision(ArrayList<Enemy> e, ArrayList<ShooterEnemy> s){
    for (int i = 0; i < e.size(); i++) {
      for (int j = 0; j < e.size(); j++) {
        if (i != j) {
          if (dist(e.get(i).pos.x, e.get(i).pos.y, e.get(j).pos.x, e.get(j).pos.y) <= 40) {
            float theta = atan2(e.get(i).pos.y-e.get(j).pos.y, e.get(i).pos.x-e.get(j).pos.x)+PI;
            e.get(i).pos = e.get(i).pos.add(new PVector(40*cos(theta),40*sin(theta)));
            e.get(j).pos = e.get(j).pos.sub(new PVector(40*cos(theta),40*sin(theta)));
          }
        }
      }
    }
    for (int i = 0; i < s.size(); i++) {
      for (int j = 0; j < s.size(); j++) {
        if (i != j) {
          if (dist(s.get(i).pos.x, s.get(i).pos.y, s.get(j).pos.x, s.get(j).pos.y) <= 50) {
            float theta = atan2(s.get(i).pos.y-s.get(j).pos.y, s.get(i).pos.x-s.get(j).pos.x)+PI;
            s.get(i).pos = s.get(i).pos.add(new PVector(50*cos(theta),50*sin(theta)));
            s.get(j).pos = s.get(j).pos.sub(new PVector(50*cos(theta),50*sin(theta)));
          }
        }
      }
    }
    for (int i = 0; i < s.size(); i++) {
      for (int j = 0; j < e.size(); j++) {      
          if (dist(s.get(i).pos.x, s.get(i).pos.y, e.get(j).pos.x, e.get(j).pos.y) <= 45) {
            float theta = atan2(e.get(j).pos.y-s.get(i).pos.y, e.get(j).pos.x-s.get(i).pos.x)+PI;
            s.get(i).pos = s.get(i).pos.add(new PVector(30*cos(theta),30*sin(theta)));
            e.get(j).pos = e.get(j).pos.sub(new PVector(30*cos(theta),30*sin(theta)));
        }
      }
    }
  }

  void update() {
    //Enemy spawn with inteval
    if (millis()>nextEnemySpawn&&EnemyCount>EnemySpawned) {
      Enemies.add(new Enemy(SpawnPoints.get(int(random(0, SpawnPoints.size())))));
      EnemySpawned += 1;
      nextEnemySpawn = millis() + EnemySpawnRate;
      println(EnemyCount, EnemySpawned);
    }

    //ShooterEnemy spawn with inteval
    if (millis()>nextShooterEnemySpawn&&ShooterEnemyCount>ShooterEnemySpawned) {
      ShooterEnemies.add(new ShooterEnemy(SpawnPoints.get(int(random(0, SpawnPoints.size())))));
      ShooterEnemySpawned += 1;
      nextShooterEnemySpawn = millis() + ShooterEnemySpawnRate;
    }
    if (millis()>5000)enemyCollision(Enemies, ShooterEnemies);
    for (Enemy e : Enemies) e.run();
    for (ShooterEnemy e : ShooterEnemies) e.run();
  }

  void run() {
    update();
  }
}
