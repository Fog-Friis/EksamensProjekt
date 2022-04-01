class Pistol { 
int dir;
PVector pos = new PVector();
int posx, posy;
int maxDistance=width;  
boolean hit=false;
int maxBullets, currentBullets;
int minDistance = 1, yDistance, xDistance;
color c;

void shoot() {
   if (currentBullets>0){
     currentBullets -=1; 
      // player.getPos();
       //pos = Player.pos;
      // dir = Player.dir;
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
      c = get(pos.x, pos.y);
      if ((c == (255, 0, 10)) || c == (155))  {
        if (c == (255, 0, 10) {
         hit  = true;
      }
      }
          else break;
      }
  if (hit==true){
    println("shot at distance ");
    break;
  }
else{
  println("no more ammo");
}
}
}
}
