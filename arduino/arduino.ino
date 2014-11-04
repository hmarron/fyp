#include <Servo.h> 
 
Servo myservo;
int oldPos = 0;
int newPos = 0;
 
void setup() { 
  Serial.begin(9600);
  myservo.attach(9);
  myservo.write(170);
} 
 
void loop() {       
    newPos = Serial.read();
    if(oldPos != newPos && newPos > 0 && newPos < 180){
      myservo.write(newPos);
      oldPos = newPos;
    }
} 
