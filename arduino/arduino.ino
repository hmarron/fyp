#include <Servo.h> 
 
Servo servoX;
Servo servoY;
byte oldXPos = 0;
byte newXPos = 0;
byte oldYPos = 0;
byte newYPos = 0;
 
void setup() { 
  Serial.begin(9600);
  //Serial2.begin(9600);
  servoX.attach(9);
  //servoY.attach(10);
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

    if(Serial.available()){  
      newXPos = Serial.read();
      //Serial2.write(newXPos);
      //newYPos = Serial1.read();
      if(oldXPos != newXPos && newXPos > 0 && newXPos < 180){
        servoX.write(newXPos);
        oldXPos = newXPos;
      }
      
      /*if(oldYPos != newYPos && newYPos > 0 && newYPos < 180){
        servoY.write(newYPos);
        oldXPos = newYPos;
      }*/

    }
    
} 
