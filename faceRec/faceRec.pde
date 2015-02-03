import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;
import ddf.minim.*;
import processing.net.*; 

Client myClient; 
String dataIn; 

Capture video;
OpenCV opencv;
Serial serial;

boolean running = false;
boolean tracking = true;
boolean canSearch = true;
byte lastKnownPos[] = {0,0};

void setup() {
  size(320, 240);
  
  myClient = new Client(this, "127.0.0.1", 8888); 
  
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  
  String portName = Serial.list()[0];
  serial = new Serial(this, portName, 9600);

  println(portName);
}

void draw() {
  
  if (myClient.available() > 0) { 
    dataIn = myClient.readString(); 
    if(dataIn.contains("Stop") && dataIn.contains("tracking")){
      tracking = false;
    }else if(dataIn.contains("Track")){
      tracking = true;
    }else if(dataIn.contains("Stop") && dataIn.contains("searching")){
      canSearch = false;
    }else if(dataIn.contains("Search")){
      canSearch = true;
    }
  } 
  println(dataIn);
  
  opencv.loadImage(video);
  opencv.flip(1);

  pushMatrix();
  scale(-1.0, 1.0);
  image(video, -video.width, 0 );
  popMatrix();

  noFill();
  stroke(0, 255, 0);
  strokeWeight(1);
  Rectangle[] faces = opencv.detect();
  
  if(faces.length > 0 && tracking){
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    float faceCenterX = faces[0].x + (faces[0].width / 2);
    float faceCenterY = faces[0].y + (faces[0].height / 2);
    
    byte centerXScaled = (byte)Math.round((faceCenterX / 320) * 180);
    byte centerYScaled = (byte)(Math.round((faceCenterY / 240) * 180)-20);
    
    byte out[] = {centerXScaled, centerYScaled};
    lastKnownPos = out;
    println(out[0] + "," + out[1]);
    serial.write(out);
  }
  if(!tracking && !canSearch){
    serial.write(lastKnownPos);
  }
}

void captureEvent(Capture c) {
  c.read();
}
