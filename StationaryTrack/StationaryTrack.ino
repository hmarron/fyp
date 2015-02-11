#include <Servo.h> 
 
Servo servoX;
Servo servoY;

byte oldXPos = 0;
byte newXPos = 0;
byte oldYPos = 0;
byte newYPos = 0;
boolean running = false;

int searchX = 0;
int searchY = 90;
boolean searchDir = false;
boolean searching = false;
 
void flash(int blinks){
  for(int i=0; i<blinks; i++){
    digitalWrite(A0, HIGH);
    delay(200);
    digitalWrite(A0, LOW);
  delay(200);
  }
}

void search(int searchSpeed){
  servoX.write(searchX);
  servoY.write(searchY);
  if(searchDir){
    searchX++;
  }else{
    searchX--;
  }
  if(searchX >= 180 || searchX < 0){
    searchDir = !searchDir;
  }
  if(searchY < 50){
    searchY++;
  }else if(searchY > 50){
    searchY--;
  }
  delay(searchSpeed);
}

void searchStart(){
  searchX = oldXPos;
  searchY = oldYPos;
  searching = true;
  digitalWrite(A0, LOW);
}

void searchEnd(){
  newXPos = searchX;
  searching = false;
}

void updateServos(byte newPosX, byte newPosY){
  newXPos = newPosX;
  newYPos = newPosY;   
  if(oldXPos != newXPos && newXPos > 0 && newXPos < 180){
    servoX.write(newXPos);
    oldXPos = newXPos;
  }
  
  if(oldYPos != newYPos && newYPos > 0 && newYPos < 180){
    servoY.write(newYPos);
    oldYPos = newYPos;
  }
}

void setup() { 
  Serial.begin(9600);
  servoX.attach(9);
  servoY.attach(10);
  pinMode(A0, OUTPUT);
  searchStart();
} 
 
void loop() {
    if(searching){
      search(50);
    }
} 

void serialEvent() {
  searchEnd();
  if(Serial.available()){
    char input[2];
    Serial.readBytes(input, 2);
       
    if(!running){
      if(input[0] > 0 || input[1] > 0){
        running = true;
      }
    }else{
      updateServos(input[0], input[1]);
      digitalWrite(A0, HIGH);
    }
  }
  searchStart();
}

