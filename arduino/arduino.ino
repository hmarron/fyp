#include <Servo.h> 
 
Servo servoX;
Servo servoY;
byte oldXPos = 0;
byte newXPos = 0;
byte oldYPos = 0;
byte newYPos = 0;
 
void setup() { 
  Serial.begin(9600);
  servoX.attach(9);
  servoY.attach(10);
} 
 
void loop() {   
    if(Serial.available()){
          char newPos[2];
          char newPosX = 0;
          char newPosY = 0;
          
          Serial.readBytes(newPos, 2);
          //newXPos = Serial.read();
          newXPos = newPos[1];
          newYPos = newPos[0];
          
          
          if(oldXPos != newXPos && newXPos > 0 && newXPos < 180){
            servoX.write(newXPos);
            oldXPos = newXPos;
          }

          //newYPos = Serial.read();
          
          if(oldYPos != newYPos && newYPos > 0 && newYPos < 180){
            servoY.write(newYPos);
            oldYPos = newYPos;
          }
    }
} 
