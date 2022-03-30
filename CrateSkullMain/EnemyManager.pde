class EnemyManager{
    int EnemyCount, ShooterEnemyCount;
    int EnemySpawned, ShooterEnemySpawned;
    float EnemySpawnRate, ShooterEnemySpawnRate, nextEnemySpawn, nextShooterEnemySpawn;
    //int Escalation;
    ArrayList<SpawnPoint> SpawnPoints;
    ArrayList<Enemy> Enemies;
    ArrayList<ShooterEnemy> ShooterEnemies;
    
    EnemyManager(int e, int s, float eR, float sR, ArrayList<SpawnPoint> s){
      EnemyCount = e;
      ShooterEnemyCount = s;
      EnemySpawnRate = eR;
      ShooterEnemySpawnRate = sR;
      //Escalation = esc;
      SpawnPoints = s;
    }
    
    void update(){
      //Enemy spawn with inteval
      if(millis()>nextEnemySpawn&&EnemyCount>EnemySpawned){
       Enemies.add(new Enemy(SpawnPoints.get(random(0,Spawnpoints.length()))));
       EnemySpawned += 1;
       nextEnemySpawn = millis() + EnemySpawnRate;
      }
      
      //ShooterEnemy spawn with inteval
      if(millis()>nextShooterEnemySpawn&&ShooterEnemyCount>ShooterEnemySpawned){
       ShooterEnemies.add(new ShooterEnemy(SpawnPoints.get(random(0,Spawnpoints.length()))));
       ShooterEnemySpawned += 1;
       nextShooterEnemySpawn = millis() + ShooterEnemySpawnRate;
      }
    } 
