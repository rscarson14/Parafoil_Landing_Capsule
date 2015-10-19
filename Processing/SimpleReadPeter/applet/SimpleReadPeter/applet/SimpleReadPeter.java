import processing.core.*; 
import processing.xml.*; 

import processing.serial.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class SimpleReadPeter extends PApplet {

// Example by Tom Igoe



int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
float lat;
float lon;
float speed;
float heading;
float altitude;
float age;
float idealHeading;
float headingDifference;
float turn;
float distance;

public void setup() {
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Keyspan adaptor, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[1], 57600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
}

public void draw() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      print(myString);
      if(match(myString, "Lat/Long: ")!=null){
      {
        String latln = split(myString, ": ")[1];
        lat = PApplet.parseFloat(split(latln, ", ")[0]);
        lon = PApplet.parseFloat(split(latln, ", ")[1]);
      }
      if(match(myString, "Speed: ")!=null) {
        speed = PApplet.parseFloat(split(myString, ": ")[1]);
        print(speed);
      } else if(match(myString, "Heading: ")!=null) {
        heading = PApplet.parseFloat(split(myString, ": ")[1]);
        print(heading);
      } else if(match(myString, "Altitude: ")!=null) {
        altitude = PApplet.parseFloat(split(myString, ": ")[1]);
        print(altitude);
      } else if(match(myString, "Age: ")!=null) {
        age = PApplet.parseFloat(split(myString, ": ")[1]);
        print(age);
      } else if(match(myString, "idealHeading: ")!=null) {
        idealHeading = PApplet.parseFloat(split(myString, ": ")[1]);
        print(idealHeading);
      } else if(match(myString, "Diff: ")!=null) {
        headingDifference = PApplet.parseFloat(split(myString, ": ")[1]);
        print(headingDifference);
      } else if(match(myString, "Turn: ")!=null) {
        turn = PApplet.parseFloat(split(myString, ": ")[1]);
        print(turn);
      } else if(match(myString, "distance: ")!=null) {
        distance = PApplet.parseFloat(split(myString, ": ")[1]);
        print(distance);
      }
    }
  }
}
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#ECE9D8", "SimpleReadPeter" });
  }
}
