#include <Servo.h> 
 
Servo servoX;
Servo servoY;
int oldXPos = 0;
int newXPos = 0;
int oldYPos = 0;
int newYPos = 0;
boolean getX = true;
 
void setup() { 
  Serial.begin(9600);
  servoX.attach(10);
  servoY.attach(9);
} 
 
void loop() {   
  
    if(Serial.available()){
          newXPos = Serial.parseInt();
          
          if(oldXPos != newXPos && newXPos > 0 && newXPos < 180){
            servoX.write(newXPos);
            oldXPos = newXPos;
          }

          newYPos = Serial.parseInt();
          
          if(oldYPos != newYPos && newYPos > 0 && newYPos < 180){
            servoY.write(newYPos);
            oldYPos = newYPos;
          }
    }
    
} 
