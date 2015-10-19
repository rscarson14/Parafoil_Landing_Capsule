//Created August 15 2006
//Heather Dewey-Hagborg
//http://www.arduino.cc
//reworked to GPS reader
//Dirk, december 2006

#include <ctype.h>
#include <string.h>

#define bit9600Delay 84
#define halfBit9600Delay 42
#define bit4800Delay 188
#define halfBit4800Delay 94

byte rx = 6;
byte tx = 7;
byte SWval;
char dataformat[7] = "$GPRMC";
char messageline[80] = "";
int i= 0;

void setup() {
  pinMode(rx,INPUT);
  pinMode(tx,OUTPUT);
  digitalWrite(tx,HIGH);
  digitalWrite(13,HIGH); //turn on debugging LED
  SWprint('h');  //debugging hello
  SWprint('i');
  SWprint(10); //carriage return
  Serial.begin(9600);
}

void SWprint(int data)
{
  byte mask;
  //startbit
  digitalWrite(tx,LOW);
  delayMicroseconds(bit4800Delay);
  for (mask = 0x01; mask>0; mask <<= 1) {
    if (data & mask){ // choose bit
	digitalWrite(tx,HIGH); // send 1
    }
    else{
	digitalWrite(tx,LOW); // send 0
    }
    delayMicroseconds(bit4800Delay);
  }
  //stop bit
  digitalWrite(tx, HIGH);
  delayMicroseconds(bit4800Delay);
}

char SWread()
{
  byte val = 0;
  while (digitalRead(rx));
  //wait for start bit
  if (digitalRead(rx) == LOW) {
    delayMicroseconds(halfBit4800Delay);
    for (int offset = 0; offset < 8; offset++) {
	delayMicroseconds(bit4800Delay);
	val |= digitalRead(rx) << offset;
    }
    //wait for stop bit + extra
    delayMicroseconds(bit4800Delay);
    delayMicroseconds(bit4800Delay);
    return val;
  }
}
void char2string()
{
  i = 0;
  messageline[0] = SWread();
  if (messageline[0] == 36) //string starts with $
  {
    i++;
    messageline[i] = SWread();
    while(messageline[i] != 13 & i<80) //carriage return or max size
    {
	i++;
	messageline[i] = SWread();
    }
    messageline[i+1] = 0; //make end to string
  }
}
void loop()
{
  digitalWrite(13,HIGH);
 //only print string with the right dataformat
  char2string();
  if (strncmp(messageline, dataformat, 6) == 0 & i>4)
  {
    for (int i=0;i<strlen(messageline);i++)
    {
	Serial.print(messageline[i], BYTE);
    }
  }

  //Serial.print(SWread(),BYTE); //use this to get all GPS output, comment out from char2string till here

}
 

