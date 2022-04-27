int pzWeaponID=1;
int killCount=0;
class Pistol { 
int dir;
PVector pos = new PVector();
PVector pos2 = new PVector();
PVector posName = new PVector();
int posx, posy;
int maxDistance=width;  
int targettype;
int maxBullets=20, currentBullets=20;
int minDistance = 1, yDistance, xDistance;
color c;
float fireRate;
int enemycount;
int damage;
float time = 0;
String name;
int WeaponID;
  Pistol(PVector pos,int dir,int posx, int posy, int maxBullets,int currentBullets, int yDistance, int xDistance,color c, float fireRate, int damage,float time,String name,int WeaponID) {
    this.pos = pos;
    this.dir = dir;
    this.posx = posx;
    this.posy = posy;
    this.maxBullets = maxBullets;
    this.currentBullets = currentBullets;
    this.yDistance = yDistance;
    this.xDistance = xDistance;
    this.c = c;
    this.fireRate = fireRate;
    this.damage = damage;
    this.time = time;
    this.name = name;
    this.WeaponID = WeaponID;
  }
void shoot() {
  println("q");
   if (currentBullets>0 && time < (second())) {
     time = second()+fireRate;
     currentBullets -=1;
    pos =  pz.pos.copy(); 
     dir = pz.dir;
      //  println(dir);
         switch(dir) {
      case 0:
      yDistance = minDistance;
      xDistance = minDistance*0;
      break;
      case 1:
      yDistance = minDistance;
      xDistance = minDistance;
      break;
      case 2:
      yDistance = minDistance*0;
      xDistance = minDistance;
      break;
      case 3:
      yDistance = minDistance*-1;
      xDistance = minDistance;
      break;
      case 4:
      yDistance = minDistance*-1;
      xDistance = minDistance*0;
      break;
      case 5:
      yDistance = minDistance*-1;
      xDistance = minDistance*-1;
      break;
      case 6:
      yDistance = minDistance*0;
      xDistance = minDistance*-1;
      break;
      case 7:
      yDistance = minDistance*1;
      xDistance = minDistance*-1;
      break;
      }
      for (int i = minDistance; i < maxDistance;  i+= minDistance) {
      pos.y += yDistance;
      pos.x += xDistance;
     // pos.add(pos2);

      
      int posx = (int) pos.x;
      int posy = (int) pos.y;
      
      c = get(posx,posy);
   //   println(posx+"x"+posy+"y"+"farvekode:"+c);

      if ((c == -65536) //Enemy
      || c == (-65526) || //Shooter Enemy
      c == (-6908266)){ //wall
        if (c == (-65536))  { //RGB(255,0,10)
        targettype = 0;
         hit();
         break; 
        }
         else if (c == (-65526)) {
          targettype = 1;
          hit();
      }
          else {
          println("hit wall");
          
          break; //hit the wall}
           
      }
      }
      }
      
}
else if (time < (second())) {}
else{
  println("no more ammo");

}
}
void switchWP() {

}

void hit(){
   switch(targettype){
     case 0:
      enemycount = EM.Enemies.size();
      println(EM.Enemies.size());
      if (enemycount == 0){
        println("shoot enemy but no enemy found");
        break;
      }
      else{
      for (int x = 0; x <= enemycount;  x+= 1){
          
         pos2 =  EM.Enemies.get(x).pos;
        float d = pos.dist(pos2);
        if (d <= 50){
            EM.Enemies.get(x).life -= damage;
      if (EM.Enemies.get(x).life <= 0) {
      EM.Enemies.remove(x); 
      killCount += 1;
      break;
     
      }
        }
  }
 
  } break;
  case 1:
        enemycount = EM.ShooterEnemies.size();
      println(EM.ShooterEnemies.size());
      if (enemycount == 0){
        println("shoot shooterenemy but no shooterenemy found");
        break;
      }
      else{
      for (int x = 0; x <= enemycount;  x+= 1){
          
         pos2 =  EM.ShooterEnemies.get(x).pos;
        float d = pos.dist(pos2);
        if (d <= 50){
            EM.ShooterEnemies.get(x).life -= damage;
      if (EM.ShooterEnemies.get(x).life <= 0) {
      EM.ShooterEnemies.remove(x); 
      killCount += 1;
      break;
     
      }
        }
  }
 
  } break;
} 
  
}
void update(){
 
}
}
