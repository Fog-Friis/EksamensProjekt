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
    SpawnPoints.add(new PVector(40*4, 40*4.5));
    SpawnPoints.add(new PVector(width-40*4, height-40*4.5));
    EnemySpawnRate = 1000;
    ShooterEnemySpawnRate = 5000;
    roundEnemyCount = startEnemyCount;
    roundShooterCount = startShooterCount;
    Enemies.clear();
    ShooterEnemies.clear();
    enemyHealth = 100;
    spawnedEnemies = 0;
  }

  void enemyCollision(ArrayList<Enemy> e, ArrayList<ShooterEnemy> s, Player p) {
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

  void collisionBetween(PVector p1, float r1, PVector p2, float r2) {
    float distance = r1 + r2;
    float theta = atan2(p1.y-p2.y, p1.x - p2.x) + PI;
    if (dist(p1.x, p1.y, p2.x, p2.y) < distance) {
      float dist = distance - dist(p1.x, p1.y, p2.x, p2.y);
      p1 = p1.sub(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
      p2 = p2.add(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
    }
  }

  void nextRound() {
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

  void spawnEnemies() {
    if (spawnedEnemies <= maxEnemyCount && roundEnemyCount > 0) {
      if (millis() > nextEnemySpawn) {
        Enemies.add(new Enemy(new PVector(SpawnPoints.get(int(random(0, SpawnPoints.size()))).x, SpawnPoints.get(int(random(0, SpawnPoints.size()))).y), 30, enemyHealth));
        roundEnemyCount--;
        spawnedEnemies++;
        nextEnemySpawn = millis() + EnemySpawnRate;
      }
    }
    if (spawnedShooters <= maxShooterCount && roundShooterCount > 0) {
      if (millis() > nextShooterEnemySpawn) {
        ShooterEnemies.add(new ShooterEnemy(new PVector(SpawnPoints.get(int(random(0, SpawnPoints.size()))).x, SpawnPoints.get(int(random(0, SpawnPoints.size()))).y), 30, 100, 1000));
        roundShooterCount--;
        spawnedShooters++;
        nextShooterEnemySpawn = millis() + ShooterEnemySpawnRate;
      }
    }
  }

  boolean addedSpawnPoints = false;
  void update() {

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

  void run() {
    update();
  }
}
