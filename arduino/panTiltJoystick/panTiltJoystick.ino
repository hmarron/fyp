#include <Servo.h> 
 
Servo servoY;
Servo servoX;
 
int posY = 90;
int offsetY = -20;

int posX = 90;
int offsetX = -8;

int xSensor = A1;
float xSensorVal = 0;

int ySensor = A0;
float ySensorVal = 0;
 
void setup() {
  Serial.begin(9600);
  servoX.attach(10);
  servoY.attach(9);
} 
 
void loop() { 
    xSensorVal = analogRead(xSensor);
    ySensorVal = analogRead(ySensor);
    Serial.println(mapAngle(ySensorVal));
    Serial.println(mapAngle(xSensorVal));
    servoY.write(mapAngle(ySensorVal) + offsetY);
    servoX.write(mapAngle(xSensorVal) + offsetX);
    //delay(1000);
}

int mapAngle(float val){
  return ((val/1024) * 180);
}


