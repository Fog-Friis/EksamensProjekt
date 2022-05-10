class WeaponManager{
String WeaponName1 ="Glock", WeaponName2 = "UZI" , WeaponName3= "Shotgun", WeaponName4= "Sword", WeaponName5= "Grenades";
int WeaponID=1;
int PlayerNR;
float time = 0;
float changeTime = 500;
int BulletsCurrent = 20;
String WeaponText;

WeaponManager(int PlayerNR,float time,int WeaponID,String WeaponText,int BulletsCurrent ){
this.PlayerNR = PlayerNR;
this.time = time;
this.WeaponID = WeaponID;
this.WeaponText = WeaponText;
this.BulletsCurrent = BulletsCurrent;
}
void WeaponChange(){
  
switch(PlayerNR){
  case 1:
 if(time < millis()){
   WeaponID += 1;
  switch(WeaponID){
   case 1:
   if  (p1Glock.currentBullets>0){
   WeaponText = WeaponName1+" "+p1Glock.currentBullets+"/"+p1Glock.maxBullets;
   break;
   }else{ WeaponID = WeaponID+1;}
   case 2:
   if  (p1UZI.currentBullets>0){
   WeaponText = WeaponName2+" "+p1UZI.currentBullets+"/"+p1UZI.maxBullets;
      break;
   }else{ WeaponID = WeaponID+1;}
  case 3:
  if  (p1Shotgun.currentBullets>0){
  WeaponText = WeaponName3+" "+p1Shotgun.currentBullets+"/"+p1Shotgun.maxBullets;
  break;
  }else{ WeaponID = WeaponID+1;}
  case 4:
  if  (p1Sword.currentBullets>0){
  WeaponText = WeaponName4;
  break;
  }else{ WeaponID = WeaponID+1;} //<>//
  case 5:  //<>//
  if  (p1Grenades.currentBullets>0){
  WeaponText = WeaponName5+" "+p1Grenades.currentBullets+"/"+p1Grenades.maxBullets;
  }else{ WeaponID = 1;}
  break;
  case 6:
  WeaponID = 1;
  WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
  break;
  } break;
}else{
break;
}
  case 2:
 if(time < millis()){
   WeaponID += 1;
  switch(WeaponID){
   case 1:
   if  (p2Glock.currentBullets>0){
   WeaponText = WeaponName1+" "+p2Glock.currentBullets+"/"+p2Glock.maxBullets;
   break;
   }else{ WeaponID = WeaponID+1;}
   case 2:
   if  (p2UZI.currentBullets>0){
   WeaponText = WeaponName2+" "+p2UZI.currentBullets+"/"+p2UZI.maxBullets;
      break;
   }else{ WeaponID = WeaponID+1;}
  case 3:
  if  (p2Shotgun.currentBullets>0){
  WeaponText = WeaponName3+" "+p2Shotgun.currentBullets+"/"+p2Shotgun.maxBullets;
  break;
  }else{ WeaponID = WeaponID+1;}
  case 4:
  if  (p2Sword.currentBullets>0){
  WeaponText = WeaponName4;
  break;
  }else{ WeaponID = WeaponID+1;}
  case 5: 
  if  (p2Grenades.currentBullets>0){
  WeaponText = WeaponName5+" "+p2Grenades.currentBullets+"/"+p2Grenades.maxBullets;
  }else{ WeaponID = 1;}
  break;
  case 6:
  WeaponID = 1;
  WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
  break;
  } break;
}else{
break;
}
case 3:

 if( time < millis()){
        time = millis()+changeTime;
           WeaponID += 1;
  switch(WeaponID){
   case 1:
   WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
   break;
   case 2:
   if  (pzUZI.currentBullets>0){
   WeaponText = WeaponName2+" "+pzUZI.currentBullets+"/"+pzUZI.maxBullets;
      break;
   }else{ WeaponID = WeaponID+1;}
  case 3:
  if  (pzShotgun.currentBullets>0){
  WeaponText = WeaponName3+" "+pzShotgun.currentBullets+"/"+pzShotgun.maxBullets;
  break;
   }else{ WeaponID = WeaponID+1;}
  case 4:
  if  (pzSword.currentBullets>0){
  WeaponText = WeaponName4;
  break;
  }else{ WeaponID = 1;}
  case 5:
  if  (pzGrenades.currentBullets>0){
  WeaponText = WeaponName5+" "+pzGrenades.currentBullets+"/"+pzGrenades.maxBullets;
    break;
  }else{ WeaponID = 1;}
  case 6:
  WeaponID = 1;
  WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
  break;
  } break;
}else{
break;
}
}
}

void WeaponShoot(){
switch(PlayerNR){
  case 1:
switch(WeaponID){
case 1:
p1Glock.shoot();
WeaponText = WeaponName1+" "+p1Glock.currentBullets+"/"+p1Glock.maxBullets;
break;
case 2:
p1UZI.shoot();
WeaponText = WeaponName2+" "+p1UZI.currentBullets+"/"+p1UZI.maxBullets;
break;
case 3:
p1Shotgun.buckshot();
WeaponText = WeaponName3+" "+p1Shotgun.currentBullets+"/"+p1Shotgun.maxBullets;
break;
case 4:
p1Sword.swing();
break;
case 5:
p1Grenades.bomb();
WeaponText = WeaponName5+" "+p1Grenades.currentBullets+"/"+p1Grenades.maxBullets;
break;
}
break;
case 2:
switch(WeaponID){
case 1:
p2Glock.shoot();
WeaponText = WeaponName1+" "+p2Glock.currentBullets+"/"+p2Glock.maxBullets;
break;
case 2:
p2UZI.shoot();
WeaponText = WeaponName2+" "+p2UZI.currentBullets+"/"+p2UZI.maxBullets;
break;
case 3:
p2Shotgun.buckshot();
WeaponText = WeaponName3+" "+p2Shotgun.currentBullets+"/"+p2Shotgun.maxBullets;
break;
case 4:
p2Sword.swing();
break;
case 5:
p2Grenades.bomb();
WeaponText = WeaponName5+" "+p2Grenades.currentBullets+"/"+p2Grenades.maxBullets;
break;
}
break;
case 3:
switch(WeaponID){
case 1:
pzGlock.shoot();
WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
break;
case 2:
pzUZI.shoot();
WeaponText = WeaponName2+" "+pzUZI.currentBullets+"/"+pzUZI.maxBullets;
break;
case 3:
pzShotgun.buckshot();
WeaponText = WeaponName3+" "+pzShotgun.currentBullets+"/"+pzShotgun.maxBullets;
break;
case 4:
pzSword.swing();
break;
case 5:
pzGrenades.bomb();
WeaponText = WeaponName5+" "+pzGrenades.currentBullets+"/"+pzGrenades.maxBullets;
break;
}break;
}
}
  }
