Pistol pzpistol, p1pistol, p2pistol;
class Pistol { 
int dir;
PVector pos = new PVector();
int posx, posy;
int maxDistance=width;  
boolean hit=false;
int maxBullets=20, currentBullets=20;
int minDistance = 1, yDistance, xDistance;
color c;
float firerate;



void shoot() {
  
   if (currentBullets>0){
     //Ændre senere til playerene der skyder
     currentBullets -=1;
     pos = pz.pos;
     dir = pz.dir;
      
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
      for (int i = minDistance; hit== i < maxDistance;  i+= minDistance) {
      pos.y += yDistance;
      pos.x += xDistance;
      int posx = (int) pos.x;
      int posy = (int) pos.x;
      
      c = get(posx,posy);
      println(c);
      if ((c == -65526) //RGB(255,0,10)
      || c == (6579301))   { //RGB(155)
        if (c == (-65526)) { //RGB(255,0,10)
         hit  = true;
         break;
      }
      }
          else break;
      }
  if (hit==true){
    println("pew pew");
    println(pos);
    //Attack hit and deals damage
  }
else{
  println("no more ammo");
}
}
}
}
