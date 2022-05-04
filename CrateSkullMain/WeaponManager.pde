class WeaponManager{
String WeaponName1 ="Glock", WeaponName2 = "UZI" , WeaponName3= "Sword", WeaponName4= "Grenade", WeaponName5= "No Name";
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
 if( time < millis()){
        time = millis()+changeTime;
   if (WeaponID ==4){ WeaponID=1;
   }else{ WeaponID = WeaponID+1;}
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
  WeaponText = "Sword";
  break;
  case 4:
  WeaponText = "Grenade";
  break;
  }
}else{
break;
}
case 3:
 if( time < millis()){
        time = millis()+changeTime;
   if (WeaponID ==4){ WeaponID=1;
   }else{ WeaponID = WeaponID+1;}
  switch(WeaponID){
   case 1:
   if  (pzGlock.currentBullets>0){
   WeaponText = WeaponName1+" "+pzGlock.currentBullets+"/"+pzGlock.maxBullets;
   break;
   }else{ WeaponID = WeaponID+1;}
   case 2:
   if  (p1UZI.currentBullets>0){
   WeaponText = WeaponName2+" "+pzUZI.currentBullets+"/"+pzUZI.maxBullets;
      break;
   }else{ WeaponID = WeaponID+1;}
  case 3:
  WeaponText = "Sword";
  break;
  case 4:
  WeaponText = "Grenade";
  break;
  }
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
p1Sword.swing();
break;
case 4:
// Max time like 3 sec then auto cast bomb.
break;
}
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
p2Sword.swing();
break;
case 4:
// Max time like 3 sec then auto cast bomb.
break;
}
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
pzSword.swing();
break;
case 4:
// Max time like 3 sec then auto cast bomb.
break;
}
}
}
  }
