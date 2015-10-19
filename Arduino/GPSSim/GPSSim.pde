void setup() 
{ 
  Serial.begin(9600); 

  // prints title with ending line break 
  Serial.println("Begin Transmission"); 
} 


float lat = 4916.46;
float lon = 8912.34;
void loop() 
{ 
  Serial.print("lat:");
  Serial.print(lat);
  Serial.print(";lon:");
  Serial.println(lon); 
  delay(500);
} 
