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
int moveSpeedDelay = 100;
int currentDir = 5;
int posX = 90;
int posY = 90;

int searchY = 90;
int searchSpeed = 50;
boolean searchDir = false;

void turn(int dir){
  if(dir == TURN_LEFT){
    posX -= moveSpeedAngle;
    delay(moveSpeedDelay);
  }else if(dir == TURN_RIGHT){
    posX += moveSpeedAngle;
    delay(moveSpeedDelay);
  }else if(dir == TURN_UP){
    posY -= moveSpeedAngle;
    delay(moveSpeedDelay);
  }else if(dir == TURN_DOWN){
    posY += moveSpeedAngle;
    delay(moveSpeedDelay);
  }else if(dir == STOP){
    
  }else if(dir == SEARCH){
    search();
  }
  servoX.write(posX);
  servoY.write(posY);
}
 
void flash(int blinks){
  for(int i=0; i<blinks; i++){
    digitalWrite(A0, HIGH);
    delay(200);
    digitalWrite(A0, LOW);
  delay(200);
  }
}

void search(){
  servoX.write(posX);
  servoY.write(posY);
  if(searchDir){
    posX++;
  }else{
    posX--;
  }
  if(posX >= 180 || posX < 0){
    searchDir = !searchDir;
  }
  if(posY > searchY){
    posY--;
  }else if(posY < searchY){
    posY++;
  }
  delay(searchSpeed);
}


void setup() { 
  Serial.begin(9600);
  servoX.attach(9);
  servoY.attach(10);
  pinMode(A0, OUTPUT);
  servoX.write(posX);
  servoY.write(posY);
} 
 
void loop() {
  turn(currentDir);
} 

void serialEvent() {
  if(Serial.available()){
    byte input = Serial.read();
    currentDir = input;
    turn(input);
  }
  delay(1);
}

