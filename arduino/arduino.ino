#include <Servo.h> 
 
Servo myservo;
int oldPos = 90;
int newPos = 90;
 
void setup() { 
  Serial.begin(9600);
  myservo.attach(9);
} 
 
void loop() {          
    newPos = Serial.parseInt();
    if(oldPos != newPos && newPos != 0){
      myservo.write(newPos);
      oldPos = newPos;
    }
} 
