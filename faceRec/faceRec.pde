import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;
import ddf.minim.*;
import processing.net.*; 

int TURN_RIGHT = 1;
int TURN_LEFT = 2;
int TURN_UP = 3;
int TURN_DOWN = 4;
int STOP = 5;
int SEARCH = 6;

Capture video;
OpenCV opencv;
Serial serial;


void setup() {
  size(320, 240);

  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  
  String portName = Serial.list()[0];
  serial = new Serial(this, portName, 9600);

  //println(portName);
}

void draw() {
  
  opencv.loadImage(video);

  pushMatrix();
  scale(1.0, -1.0);
  image(video, 0, -video.height );
  popMatrix();

  noFill();
  stroke(0, 255, 0);
  strokeWeight(1);
  Rectangle[] faces = opencv.detect();
  
  
  if(faces.length > 0){
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    float faceCenterX = faces[0].x + (faces[0].width / 2);
    float faceCenterY = faces[0].y + (faces[0].height / 2);
    
    byte centerXScaled = (byte)Math.round((faceCenterX / 320) * 180);
    byte centerYScaled = (byte)(Math.round((faceCenterY / 240) * 180)-20);
    
    //byte out[] = {centerXScaled, centerYScaled};
    //println(out[0] + "," + out[1]);
    //serial.write(out);
  }
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  println(key);
  if(key == 'a'){
    serial.write(TURN_LEFT);
  }else if(key == 'd'){
    serial.write(TURN_RIGHT);
  }else if(key == 'w'){
    serial.write(TURN_UP);
  }else if(key == 's'){
    serial.write(TURN_DOWN);
  }else if(key == 'z'){
    serial.write(STOP);
  }else if(key == 'x'){
    serial.write(SEARCH);
  }
}
