#include <NewSoftSerial.h>
#include <TinyGPS.h>


TinyGPS gps;
NewSoftSerial nss(2, 3);
unsigned long time;
float tflat = 43.07222; //target latitude
float tflon = -89.41273; //target longitude
unsigned long start;
unsigned long accelstart;
const int xpin = A3;                  // x-axis of the accelerometer
const int ypin = A2;                  // y-axis
const int zpin = A1;    

void setup()  
{

  Serial.begin(19200);

  // set the data rate for the NewSoftSerial port
  nss.begin(4800);
  
  Serial.print("Sizeof(gpsobject) = "); Serial.println(sizeof(gps));
  Serial.print("Sizeof(NewSoftSerial) = "); Serial.println(sizeof(NewSoftSerial));
  Serial.println();
  long previousMillis = 0; 
  while(feedgps() == false)
  {
    unsigned long currentMillis = millis();
 
    if(currentMillis - previousMillis > 100) {
      // save the last time you blinked the LED 
      
      handleAccel();
      previousMillis = currentMillis;   
    }
  }
  Serial.println("got fix");
}
void loop()
{
  if (millis() - accelstart < 30)//only allow the GPS to update for the first 30 out of every 50 msec to 
  //allow the lines time to clean up before reading the accelerometer
  {
    feedgps();
  }
  if (millis() - start > 500)//only update once per second, otherwise just feedgps
  {
    handleGPS();
    start = millis();//restart the timer to have the update 500ms from now
  }
  if (millis() - accelstart > 50)
  {
    //Serial.println(millis() - accelstart);
    handleAccel();
    accelstart = millis();//restart the timer to have the update 100ms from now
  }
}
void handleGPS()
{
  float flat, flon;
  unsigned long age;
  gps.f_get_position(&flat, &flon, &age);
  // returns speed in 100ths of a knot
  float fmps = gps.f_speed_mps(); // speed in m/sec
  // course in degrees
  float fc = gps.f_course();
  float falt = gps.f_altitude();
  
  unsigned long period = millis() - time;

  if(age < period)
  {
    Serial.println();
    Serial.print("Lat/Long: "); printFloat(flat, 5); Serial.print(", "); printFloat(flon, 5);
    Serial.println();
    Serial.print("Speed: ");Serial.println(fmps);Serial.print("Heading: ");Serial.println(fc);
    Serial.print("Altitude: ");Serial.println(falt);
    Serial.print("Age: "); Serial.println(age);
    float idealHeading = calculateIdealHeading(flat,flon);
    float headingDiff = idealHeading - fc;
    if(headingDiff > 180)
      headingDiff = -360+headingDiff;//get heading to closest value 
    if(headingDiff < -180)
      headingDiff = 360+headingDiff;
    Serial.print("Diff: "); Serial.println(headingDiff);
    int turn = 0;
    //turn = -180.0*(1/(1+pow(2.71,headingDiff/7.0))-.5);//use a sigmoid funtion to generate an appropriate turn angle for the servos
    turn = headingDiff/1.4;
    if(turn < -88){
      turn = -88;}
    if(turn > 88){
      turn = 88;}
    //from the difference of the ideal heading from the actual heading
  
    Serial.print("Turn: "); Serial.println(turn);

    float dist = distance(flat,flon);
    time = millis();
  }
}
void handleAccel()
{
  // print the sensor values:
  Serial.print("accel_x: ");
  Serial.print(analogRead(xpin));
  // print a tab between values:
  Serial.println();
  Serial.print("accel_y: ");
  Serial.print(analogRead(ypin));
  // print a tab between values:
  Serial.println();
  Serial.print("accel_z: ");
  Serial.print(analogRead(zpin));
  Serial.println();
}
bool feedgps()
{
  while (nss.available() )
  {
    if (gps.encode(nss.read()))
      return true;
  }
  return false;
}
float calculateIdealHeading(float flat, float flon) //lat = 49.2632, lon = 89.3456
{
  float flat1=flat;     // flat1 = our current latitude. flat is from the gps data. 
  float flon1=flon;  // flon1 = our current longitude. flon is from the fps data.
  float x2lat=tflat;  //enter a latitude point here   this is going to be your waypoint
  float x2lon=tflon;  // enter a longitude point here  this is going to be your waypoint
  flat1=radians(flat1);    //convert current latitude to radians
  x2lat=radians(x2lat);  //convert waypoint latitude to radians
  flon1 = radians(flon1);  //also must be done in radians
  x2lon = radians(x2lon);  //radians duh.
  float heading = atan2(sin(x2lon-flon1)*cos(x2lat),cos(flat1)*sin(x2lat)-sin(flat1)*cos(x2lat)*cos(x2lon-flon1));//magic
  heading = heading*180/3.1415926535;  // convert from radians to degrees
  int head =heading; //make it a integer now
  if(head<0){
    heading+=360;   //if the heading is negative then add 360 to make it positive
  }
  Serial.print("idealHeading: ");
  Serial.println(heading);  
  return heading;
}
float distance(float flat, float flon){
  float flat1=flat;     // flat1 = our current latitude. flat is from the gps data. 
  float flon1=flon;  // flon1 = our current longitude. flon is from the fps data.
  float dist_calc=0;
  float dist_calc2=0;
  float diflat=0;
  float diflon=0;
  float x2lat=tflat;  //enter a latitude point here   this is going to be your waypoint
  float x2lon=tflon;  // enter a longitude point here  this is going to be your waypoint
  //------------------------------------------ distance formula below. Calculates distance from current location to waypoint
  diflat=radians(x2lat-flat1);  //notice it must be done in radians
  flat1=radians(flat1);    //convert current latitude to radians
  x2lat=radians(x2lat);  //convert waypoint latitude to radians
  diflon=radians((x2lon)-(flon1));   //subtract and convert longitudes to radians
  dist_calc = (sin(diflat/2.0)*sin(diflat/2.0));
  dist_calc2= cos(flat1);
  dist_calc2*=cos(x2lat);
  dist_calc2*=sin(diflon/2.0);                                       
  dist_calc2*=sin(diflon/2.0);
  dist_calc +=dist_calc2;
  dist_calc=(2*atan2(sqrt(dist_calc),sqrt(1.0-dist_calc)));
  dist_calc*=6371000.0; //Converting to meters
  Serial.print("distance: ");
  Serial.println(dist_calc);    //print the distance in meters
  return dist_calc;
}
void printFloat(double number, int digits)
{
  // Handle negative numbers
  if (number < 0.0)
  {
     Serial.print('-');
     number = -number;
  }

  // Round correctly so that print(1.999, 2) prints as "2.00"
  double rounding = 0.5;
  for (uint8_t i=0; i<digits; ++i)
    rounding /= 10.0;
  
  number += rounding;

  // Extract the integer part of the number and print it
  unsigned long int_part = (unsigned long)number;
  double remainder = number - (double)int_part;
  Serial.print(int_part);

  // Print the decimal point, but only if there are digits beyond
  if (digits > 0)
    Serial.print("."); 

  // Extract digits from the remainder one at a time
  while (digits-- > 0)
  {
    remainder *= 10.0;
    int toPrint = int(remainder);
    Serial.print(toPrint);
    remainder -= toPrint; 
  } 
}
