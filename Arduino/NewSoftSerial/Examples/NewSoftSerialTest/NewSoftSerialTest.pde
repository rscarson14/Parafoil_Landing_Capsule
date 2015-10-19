
#include <NewSoftSerial.h>

NewSoftSerial mySerial(2, 3);

void setup()  
{
  Serial.begin(19200);

  // set the data rate for the NewSoftSerial port
  mySerial.begin(4800);
}

void loop()                     // run over and over again
{

  if (mySerial.available()) {
      Serial.print((char)mySerial.read());
  }
  if (Serial.available()) {
      mySerial.print((char)Serial.read());
  }
}
