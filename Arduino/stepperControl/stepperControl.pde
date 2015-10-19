/********************************************************
 **         More info about the project at:             **
 **  http://lusorobotica.com/viewtopic.php?t=103&f=106  **
 **   by TigPT         at         [url=http://www.LusoRobotica.com]www.LusoRobotica.com[/url]  **
 *********************************************************/
int dirPin = 2;
int stepperPin = 3;

void setup() {
  pinMode(dirPin, OUTPUT);
  pinMode(stepperPin, OUTPUT);
  Serial.begin(115200);
}

void step(boolean dir,int steps,int hz){
  //digitalWrite(dirPin,dir);
  //delay(50);
  for(int i=0;i<steps;i++){
    stepone(hz);
  }
}
void stepone(int delay){
  digitalWrite(stepperPin, HIGH);
  delayMicroseconds(delay);
  digitalWrite(stepperPin, LOW);
  delayMicroseconds(delay);
}
int speed = 200;
void loop(){
  if(Serial.available())
    speed = serReadInt();
  step(false,1600,speed);

//  for(int i=500;i>2;i--){
//    int time = 200 - i / 5;
//    step(false,time,i);
//   // Serial.println(i);
//  }
  //  step(false,1600,75);
  //  delay(200);  
  //  step(false,1600,125);
  //  delay(200);
  //    step(false,1600,60);
  //      step(false,1600,55);
  //  step(false,1600*20,52);
  //  for(int j = 0;j<20;j++){
  //    for(int i=50;i>24;i--){
  //          step(false,1000,i);
  //    }
  //    for(int i=24;i<50;i++){
  //          step(false,1000,i);
  //    }
  //  }
  //          
  //  delay(200);
  //    step(false,1600,150);
  //  delay(200);
}
int serReadInt()
{
 int i, serAva;                           // i is a counter, serAva hold number of serial available
 char inputBytes [7];                 // Array hold input bytes
 char * inputBytesPtr = &inputBytes[0];  // Pointer to the first element of the array
     
 if (Serial.available()>0)            // Check to see if there are any serial input
 {
   //delay(5);                              // Delay for terminal to finish transmitted
                                              // 5mS work great for 9600 baud (increase this number for slower baud)
   serAva = Serial.available();  // Read number of input bytes
   for (i=0; i<serAva; i++)       // Load input bytes into array
     inputBytes[i] = Serial.read();
   inputBytes[i] =  '\0';             // Put NULL character at the end
   return atoi(inputBytesPtr);    // Call atoi function and return result
 }
 else
   return -1;                           // Return -1 if there is no input
}
