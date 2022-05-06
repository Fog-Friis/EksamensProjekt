class EnemyManager {
  int EnemyCount =20, ShooterEnemyCount = 5;
  int EnemySpawned, ShooterEnemySpawned;
  float EnemySpawnRate, ShooterEnemySpawnRate, nextEnemySpawn, nextShooterEnemySpawn;
  //int Escalation;
  ArrayList<PVector> SpawnPoints = new ArrayList<PVector>();
  ArrayList<Enemy> Enemies = new ArrayList<Enemy>();
  ArrayList<ShooterEnemy> ShooterEnemies = new ArrayList<ShooterEnemy>();

  EnemyManager() {
    SpawnPoints.add(new PVector(40*4, 40*4.5));
    SpawnPoints.add(new PVector(width-40*4, height-40*4.5));
    EnemySpawnRate = 1000;
    ShooterEnemySpawnRate = 1000;
  }

  void enemyCollision(ArrayList<Enemy> e, ArrayList<ShooterEnemy> s, Player p) {
    for (int i = 0; i < e.size(); i++) {
      for (int j = 0; j < e.size(); j++) {
        if (i != j) {
          collisionBetween(e.get(i).pos, e.get(i).radius, e.get(j).pos, e.get(i).radius);
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
      collisionBetween(e.get(i).pos, e.get(i).radius, pz.pos, pz.radius);
    }    
    for (int i = 0; i < s.size(); i++){
      collisionBetween(s.get(i).pos, s.get(i).radius, pz.pos, pz.radius);
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

  void collisionBetween(PVector p1, float r1, PVector p2, float r2) {
    float distance = r1 + r2;
    float theta = atan2(p1.y-p2.y, p1.x - p2.x) + PI;
    if (dist(p1.x, p1.y, p2.x, p2.y) < distance) {
      float dist = distance - dist(p1.x, p1.y, p2.x, p2.y);
      p1 = p1.sub(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
      p2 = p2.add(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
    }
  }

  boolean addedSpawnPoints = false;
  void update() {

    //Enemy spawn with inteval
    if (millis()>nextEnemySpawn&&EnemyCount>EnemySpawned) {
      Enemies.add(new Enemy(SpawnPoints.get(int(random(0, SpawnPoints.size()))), 30));
      EnemySpawned += 1;
      nextEnemySpawn = millis() + EnemySpawnRate;
      println(EnemyCount, EnemySpawned);
    }

    //ShooterEnemy spawn with inteval
    if (millis()>nextShooterEnemySpawn&&ShooterEnemyCount>ShooterEnemySpawned) {
      ShooterEnemies.add(new ShooterEnemy(SpawnPoints.get(int(random(0, SpawnPoints.size()))), 30, 100));
      ShooterEnemySpawned += 1;
      nextShooterEnemySpawn = millis() + ShooterEnemySpawnRate;
    }
    enemyCollision(Enemies, ShooterEnemies, pz);
    for (Enemy e : Enemies) e.run();
    for (ShooterEnemy s : ShooterEnemies) s.run();
  }

  void run() {
    update();
  }
}
