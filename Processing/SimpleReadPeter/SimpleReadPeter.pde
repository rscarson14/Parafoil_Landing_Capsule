

import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
float lat=0; // declare variables
float lon=0;
float speed=0;
float testSpeed = 10;
float heading=0;
float altitude=0;
float age=0;
float idealHeading=0;
float headingDifference=0;
float turn=0;
float distance=0;
float accel_x=0, accel_y=0, accel_z=0;
int xPos = 1; 
boolean newAltitude = false;
PFont f;

void setup() {
  // List all the available serial ports
  println(Serial.list());
  size(900, 900);  
  background(0);
  f = loadFont("MiriamFixed-36.vlw");

  // I know that the first port in the serial list on my PC
  // is always the xBee pro, so I open Serial.list()[0].
  myPort = new Serial(this, Serial.list()[0], 19200);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
  myPort.bufferUntil(lf);
}
float lastx =0;
float lasty=0;
float lastz=0;
float lastalt=0;
long lastTime = 0;
float lastYVel = 0;
float lastRealAlt = 0;
long time = millis();
void draw() {        //Call the function draw
  textFont(f);
  fill(255);
  text("VS. Time",425,60);

  time = millis();
  /* The data coming in from the GPS and accelerometer are all different values,
   making a graph based off of one set of coordinate axis impossible to use.
   Here we use the map function to scale each value to our drawing size.
   */
  float x = map((int)accel_x, 0, 1023, 0, height);
  float y = map((int)accel_y, 0, 1023, 0, height);
  float z = map((int)accel_z, 0, 1023, 0, height);
  float alt = map((int)altitude, 0, 400, 0, height);
  float yVel = lastYVel;
  /* Graphing velocity in the Y direction was more tricky than the other values
   because it had to be calculated from the derivative of altitude.  
   */
  if (newAltitude == true) {
    float velocity = abs((( altitude - lastRealAlt ) / ( time - lastTime ))*1000);
    yVel = map((int)velocity, 0, 20, 0, height);
  }
  // print the value retreived for y velocity to the screen
  lastRealAlt = altitude;
  if(x!=0)//if x does not equal zero
  {
    fill(255,155,00);
    text("x-Acc.",255,25);
    stroke(255,155,00);// declare the color of the line
    line(xPos, height - lastx, xPos, height - (int)x);//set the line between two points
    lastx = x;//store the current x variable as last x for the next point.
  }
  if(y!=0)
  {
    fill(27,134,255);
    text("y-Acc.",255,50);
    stroke(27,134,255);
    line(xPos, height - lasty, xPos, height - (int)y);
    lasty = y;
  }
  if(z!=0)
  {
    fill(255,255,0);
    text("z-Acc.",255,75);
    stroke(255,255,0);
    line(xPos, height - lastz, xPos, height - (int)z);
    lastz = z;
  }
  if(alt!=0)
  {
    fill(27,255,155);
    text("Altitude",255,100);
    stroke(27,255,155);
    line(xPos, height - lastalt, xPos, height - (int)alt);
    lastalt = alt;
  }
  if(yVel != 0)
  {
    fill(255,00,155);
    text("y-Velocity",255,125);
    stroke(255,00,155);
    line(xPos, height - lastYVel, xPos, height - (int)yVel);
    lastTime = time;
    lastYVel = yVel;
  }
  // at the edge of the screen, go back to the beginning:


  if (xPos >= width) {
    xPos = 0;
    background(0);
  } 
  else {
    // increment the horizontal position:
    xPos++;
  }
}

void serialEvent (Serial myPort) {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      //print(myString);
      //print(split("Speed: 0.08", ": ")[1]);
      /*This section takes the incoming strings that contain 
       ACSII letters and numbers from the xBee and splits them 
       at a specified point.  This produces a variable that
       can be used in the code that contains only numbers.
       */
      if(match(myString, "Lat/Long: ")!=null)
      {
        String latln = split(myString, ": ")[1];
        //print(latln);
        lat = float(split(latln, ", ")[0]);
        println("lat: "+lat);
        lon = float(split(latln, ", ")[1]);
        println("lon: "+lon);
      }
      else if(match("Speed ", "Speed: ")!=null) {
        speed = float(split(myString, ": ")[1]);
        println("speed "+speed);
      } 
      else if(match(myString, "Heading: ")!=null) {
        heading = float(split(myString, ": ")[1]);
        println("heading "+heading);
      } 
      else if(match(myString, "Altitude: ")!=null) {
        altitude = float(split(myString, ": ")[1]);
        println("altitude "+altitude);
        newAltitude = true;
      } 
      else if(match(myString, "Age: ")!=null) {
        age = float(split(myString, ": ")[1]);
        println("age "+age);
      } 
      else if(match(myString, "idealHeading: ")!=null) {
        idealHeading = float(split(myString, ": ")[1]);
        println("ideal heading "+idealHeading);
      } 
      else if(match(myString, "Diff: ")!=null) {
        headingDifference = float(split(myString, ": ")[1]);
        println("heading difference " + headingDifference);
      } 
      else if(match(myString, "Turn: ")!=null) {
        turn = float(split(myString, ": ")[1]);
        println("turn "+turn);
      } 
      else if(match(myString, "distance: ")!=null) {
        distance = float(split(myString, ": ")[1]);
        println("dist "+distance);
      } 
      else if(match(myString, "accel_x: ")!=null) {
        accel_x = float(split(myString, ": ")[1]);
        // println("x "+accel_x);
      } 
      else if(match(myString, "accel_y: ")!=null) {
        accel_y = float(split(myString, ": ")[1]);
        // println("y "+accel_y);
      } 
      else if(match(myString, "accel_z: ")!=null) {
        accel_z = float(split(myString, ": ")[1]);
        //println("z "+accel_z);
      }
    }
  }
}

