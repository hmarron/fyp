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

int searchY = 90;
int searchSpeed = 10;
boolean searchDir = false;

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
  
  if(x == SEARCH || y == SEARCH){
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
  turn(currentX,currentY);
} 

void serialEvent() {
  if(Serial.available()){
    char input[2];
    Serial.readBytes(input, 2);
    //byte input = Serial.read();
    currentX = input[0];
    currentY = input[1];
    turn(currentX,currentY);
  }
  delay(1);
}

