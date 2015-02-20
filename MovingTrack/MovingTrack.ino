#include <Servo.h> 

#define TURN_RIGHT 1
#define TURN_LEFT 2
#define TURN_UP 3
#define TURN_DOWN 4
#define STOP 5
#define SEARCH 6
 
Servo servoX;
Servo servoY;

boolean running = false;

int moveSpeedAngle = 1;
int moveSpeedDelay = 500;
int currentX = 5;
int currentY = 5;
int posX = 90;
int posY = 90;

void turn(int x, int y){
  if(x == TURN_LEFT){
    posX -= moveSpeedAngle;
    delay(moveSpeedDelay);
  }else if(x == TURN_RIGHT){
    posX += moveSpeedAngle;
    delay(moveSpeedDelay);
  }else if(x == STOP){
    
  }
  
  if(y == TURN_UP){
    posY -= moveSpeedAngle;
    delay(moveSpeedDelay);
  }else if(y == TURN_DOWN){
    posY += moveSpeedAngle;
    delay(moveSpeedDelay);
  }else if(y == STOP){
    
  }

  servoX.write(posX);
  servoY.write(posY);
}

void setup() { 
  Serial.begin(9600);
  servoX.attach(9);
  servoY.attach(10);
  servoX.write(posX);
  servoY.write(posY);
} 

void loop() {
  if(Serial.available()){
    while(Serial.available() > 1){
      Serial.read();
    }
    int currentXY = Serial.read();
    currentY = currentXY % 10;
    currentX = currentXY / 10;
    turn(currentX,currentY);
  }
  delay(1);
} 
