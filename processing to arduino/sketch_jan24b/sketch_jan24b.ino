#include <Servo.h> 
 
Servo servoX;
Servo servoY;
byte oldXPos = 0;
byte newXPos = 0;
byte oldYPos = 0;
byte newYPos = 0;
boolean running = false;
 
void flash(int blinks){
  for(int i=0; i<blinks; i++){
    digitalWrite(A0, HIGH);
    delay(200);
    digitalWrite(A0, LOW);
  delay(200);
  }
}

void setup() { 
  Serial.begin(9600);
  servoX.attach(9);
  servoY.attach(10);
  
} 


int searchX = 0;
int searchY = 90;
boolean searchDir = false;
boolean searching = false;

void search(int searchSpeed){
  servoX.write(searchX);
  if(searchDir){
    searchX++;
  }else{
    searchX--;
  }
  if(searchX >= 180 || searchX < 0){
    searchDir = !searchDir;
  }
  delay(searchSpeed);
}

void searchStart(){
  searchX = oldXPos;
  servoY.write(90);
  searching = true;
  digitalWrite(A0, HIGH);
}

void searchEnd(){
  newXPos = searchX;
  searching = false;
  digitalWrite(A0, LOW);
}

void parseCommand(char command){
  if(command == -1){
     searchStart();
   }else if(command == -2){
     searchEnd();
   }
}
 
void loop() {
    if(Serial.available()){
      char command = Serial.read();
      parseCommand(command);
    }
    
    if(searching){
      search(10);
    }
}




