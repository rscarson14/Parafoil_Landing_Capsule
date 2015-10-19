#include <Servo.h> 
 

#define INLENGTH 160
#define INTERMINATOR 10
Servo rightServo;
Servo leftServo;

int turn = 0;
char inString[INLENGTH+1];
int inCount;

void setup()
{  
  Serial.begin(19200);
  leftServo.attach(9); 
  rightServo.attach(10);
  leftServo.write(90); 
  rightServo.write(90); 
}
int byteCount = 0;
void loop()
{
  inCount = 0;
  do {
    while (!Serial.available());             // wait for input
    inString[inCount] = Serial.read();       // get it
    if (inString [inCount] == INTERMINATOR) break;
  } while (++inCount < INLENGTH);
  inString[inCount] = 0;     // null terminate the string
  String serialBuffer = (String)inString; 

  if(serialBuffer.startsWith("Turn: "))
  {
    serialBuffer = serialBuffer.substring(6);
    char numstring[3];
    numstring[0] = serialBuffer[0];//dirty, dirty hack because string::tochararray is broken
    numstring[1] = serialBuffer[1];
    numstring[2] = serialBuffer[2];
    turn = atoi(numstring);
    if(turn < -80)
    {
      turn = -80; 
    }
    Serial.println(turn);
    leftServo.write(turn + 90);
    turn = -turn;
    rightServo.write(turn+90);
    
  }
  Serial.flush();//make sure only recent data is read
}
