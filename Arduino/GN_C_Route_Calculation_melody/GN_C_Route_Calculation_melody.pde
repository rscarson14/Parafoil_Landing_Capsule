 long launchingLatitude=0;
 long launchingLongitude=0;
 long tagetLatitude=0;
 long tagetLongitude=0;
 long xl=0;
 long yl=0;
 long latitudeUnit=0;
 long longitudeUnit=0;
 long heading=0;

 setup (){ // Input-launchingLatitude,launchingLongitude,tagetLatitude,tagetLongitude
  
 }

 void route(){
  // Input-launchingLatitude,launchingLongitude,tagetLatitude,tagetLongitude
 latitudeUnit=111.133-0.599*cos(2*tagetLatitude);
 longitudeUnit=111.413*cos(tagetLatitude)-0.094*cos(3*tagetLatitude);

 xl=(launchingLatitude-tagetLatitude)*latitudeUnit;
 yl=(launchingLongitude-tagetLongitude)*longitudeUnit;
 
 radians
 
 if (xl>=0&&y<0){
 heading=atan(yl/xl)-3*3.1415926/2;
} 
 else {
   heading
 }
