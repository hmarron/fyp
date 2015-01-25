import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer searchSound;
AudioPlayer foundSound;
Capture video;
OpenCV opencv;
Serial serial;

boolean running = false;
boolean searching = false;

void setup() {
  size(320, 240);
  
  minim = new Minim(this);
  searchSound = minim.loadFile("sounds/stillthere.wav");
  foundSound = minim.loadFile("sounds/thereyouare.wav");
  
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  
  String portName = Serial.list()[0];
  serial = new Serial(this, portName, 9600);

  println(portName);
}

void draw() {
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
  
  if(faces.length > 0){
    if(searching){
      searching = false;
      foundSound.play();
      foundSound.rewind();
    }
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    float faceCenterX = faces[0].x + (faces[0].width / 2);
    float faceCenterY = faces[0].y + (faces[0].height / 2);
    
    byte centerXScaled = (byte)Math.round((faceCenterX / 320) * 180);
    byte centerYScaled = (byte)(Math.round((faceCenterY / 240) * 180)-20);
    
    byte out[] = {centerXScaled, centerYScaled};
    println(out[0] + "," + out[1]);
    serial.write(out);
  }else{
    if(!searching){
      searching = true;
      searchSound.play();
      searchSound.rewind();
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}
