class EnemyManager {
  int EnemyCount = 20, ShooterEnemyCount = 0;
  int EnemySpawned, ShooterEnemySpawned;
  float EnemySpawnRate, ShooterEnemySpawnRate, nextEnemySpawn, nextShooterEnemySpawn;
  //int Escalation;
  ArrayList<PVector> SpawnPoints = new ArrayList<PVector>();
  ArrayList<Enemy> Enemies = new ArrayList<Enemy>();
  ArrayList<ShooterEnemy> ShooterEnemies = new ArrayList<ShooterEnemy>();

  EnemyManager() {
    SpawnPoints.add(new PVector(width/2, height/2));
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
          
          /*float distance = s.get(i).radius + s.get(j).radius;
          float theta = atan2(s.get(i).pos.y-s.get(j).pos.y, s.get(i).pos.x-s.get(j).pos.x)+PI;

          if (dist(s.get(i).pos.x, s.get(i).pos.y, s.get(j).pos.x, s.get(j).pos.y) < distance) {
            float dist = distance - dist(s.get(i).pos.x, s.get(i).pos.y, s.get(j).pos.x, s.get(j).pos.y);
            s.get(i).pos = s.get(i).pos.sub(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
            s.get(j).pos = s.get(j).pos.add(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
          }*/
        }
      }
    }
    for (int i = 0; i < e.size(); i++) {
      for (int j = 0; j < s.size(); j++) {
        collisionBetween(e.get(i).pos, e.get(i).radius, s.get(j).pos, s.get(j).radius);
        
        /*float distance = e.get(i).radius + s.get(j).radius;
        float theta = atan2(e.get(i).pos.y-s.get(j).pos.y, e.get(i).pos.x-s.get(j).pos.x)+PI;

        if (dist(e.get(i).pos.x, e.get(i).pos.y, s.get(j).pos.x, s.get(j).pos.y) < distance) {
          float dist = distance - dist(e.get(i).pos.x, e.get(i).pos.y, s.get(j).pos.x, s.get(j).pos.y);
          e.get(i).pos = e.get(i).pos.sub(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
          s.get(j).pos = s.get(j).pos.add(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
        }*/
      }
    }

    for (int i = 0; i < e.size(); i++) {
      collisionBetween(e.get(i).pos, e.get(i).radius, pz.pos, pz.radius);
      /*float distance = e.get(i).radius + p.radius;
      float theta = atan2(e.get(i).pos.y-p.pos.y, e.get(i).pos.x - p.pos.x) + PI;
      if (dist(e.get(i).pos.x, e.get(i).pos.y, p.pos.x, p.pos.y) < distance) {
        float dist = distance - dist(e.get(i).pos.x, e.get(i).pos.y, p.pos.x, p.pos.y);
        e.get(i).pos = e.get(i).pos.sub(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
        p.pos = p.pos.add(new PVector(dist/2*cos(theta), dist/2*sin(theta)));
      }*/
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
        ShooterEnemies.add(new ShooterEnemy(SpawnPoints.get(int(random(0, SpawnPoints.size()))), 30));
        ShooterEnemySpawned += 1;
        nextShooterEnemySpawn = millis() + ShooterEnemySpawnRate;
      }
      if (millis()>5000)enemyCollision(Enemies, ShooterEnemies, pz);
      for (Enemy e : Enemies) e.run();
      for (ShooterEnemy e : ShooterEnemies) e.run();
    }

    void run() {
      update();
    }
  }
