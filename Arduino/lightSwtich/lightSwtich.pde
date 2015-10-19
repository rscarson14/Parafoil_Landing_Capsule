// constants won't change. Used here to 
// set pin numbers:
const int ledPin =  7;      // the number of the LED pin
int numBlinks = 3;

// Variables will change:
int ledState = LOW;             // ledState used to set the LED

int interval = 300;           // interval at which to blink (milliseconds)

void setup() {
  // set the digital pin as output:
  pinMode(ledPin, OUTPUT);   
  Serial.begin(57600);  
}

void loop()
{
  char inByte = 0;
  if (Serial.available()) {
    inByte = Serial.read();
    Serial.print(inByte);
    
    if(inByte == '1')
    {
      Serial.println("blink");
      for(int i = 0; i < numBlinks; i++)
      {
        digitalWrite(ledPin, !ledState);   // set the LED on
        delay(interval);              // wait for a second
        digitalWrite(ledPin, ledState);    // set the LED off
        delay(interval/2);              // wait for a second
      }
    }
    if(inByte == '2')
    {
      Serial.println("switch");
      ledState = !ledState;//switch the state of the light
      digitalWrite(ledPin, ledState);
    }
  }
}

