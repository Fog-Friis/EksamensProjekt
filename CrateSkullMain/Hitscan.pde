class Pistol { 
int dir;
PVector pos = new PVector();
int posx, posy;
int maxdistance=1920;  
boolean hit=false;
int maxBullets, currentBullets;
int minDistance = 1;


void shoot() {
   if (currentBullets>0){
     currentBullets -=1; 
    //  pos = Player.pos.x;
    // dir = Player.dir;
  for (int i = 0; hit== i < maxdistance;  i+= minDistance) {
  
  
  
    
  if (hit==true){
    println("shot at distance "+i);
    break;
  }
}
}
else{
  println("no more ammo");
}
}
}
/*
//Hvad der sennere skal ind i player-classen
    if (keyCode ==  qKey) currentWeapon += 1;
    
    int currentWeapon,weaponCounter;
*/
