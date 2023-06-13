const int analogPin = A0; 

void setup() {
  Serial.begin(9600);
}

void loop() {
  int sensorValue = analogRead(analogPin);

  Serial.println(sensorValue);  
  delay(20);
}
