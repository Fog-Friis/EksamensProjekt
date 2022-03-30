class EnemyManager {
  int EnemyCount, ShooterEnemyCount;
  int EnemySpawned, ShooterEnemySpawned;
  float EnemySpawnRate, ShooterEnemySpawnRate, nextEnemySpawn, nextShooterEnemySpawn;
  //int Escalation;
  ArrayList<PVector> SpawnPoints = new ArrayList<PVector>();
  ArrayList<Enemy> Enemies = new ArrayList<Enemy>();
  ArrayList<ShooterEnemy> ShooterEnemies = new ArrayList<ShooterEnemy>();

  EnemyManager(int e, int s, float eR, float sR, ArrayList<PVector> sp) {
    EnemyCount = e;
    ShooterEnemyCount = s;
    EnemySpawnRate = eR;
    ShooterEnemySpawnRate = sR;
    //Escalation = esc;
    SpawnPoints = sp;
  }

  void update() {
    //Enemy spawn with inteval
    if (millis()>nextEnemySpawn&&EnemyCount>EnemySpawned) {
      Enemies.add(new Enemy(SpawnPoints.get(int(random(0, SpawnPoints.size())))));
      EnemySpawned += 1;
      nextEnemySpawn = millis() + EnemySpawnRate;
    }

    //ShooterEnemy spawn with inteval
    if (millis()>nextShooterEnemySpawn&&ShooterEnemyCount>ShooterEnemySpawned) {
      ShooterEnemies.add(new ShooterEnemy(SpawnPoints.get(int(random(0, SpawnPoints.size())))));
      ShooterEnemySpawned += 1;
      nextShooterEnemySpawn = millis() + ShooterEnemySpawnRate;
    }
    for (Enemy e : Enemies) e.run();
    for (ShooterEnemy e : ShooterEnemies) e.run();
    
  }
}
