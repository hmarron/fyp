import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;

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
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    float faceCenterX = faces[0].x + (faces[0].width / 2);
    float faceCenterY = faces[0].y + (faces[0].height / 2);
    println(faceCenterX + "," + faceCenterY);
    int centerXScaled = Math.round((faceCenterX / 320) * 180);
    int centerYScaled = Math.round((faceCenterY / 240) * 180);
    println(centerXScaled + "," + centerYScaled);
    serial.write(centerXScaled);
  }
  
  
}

void captureEvent(Capture c) {
  c.read();
}


byte[] intToByteArray (final int integer) {  
    byte[] result = new byte[4];  
   
    result[0] = (byte)((integer & 0xFF000000) >> 24);  
    result[1] = (byte)((integer & 0x00FF0000) >> 16);  
    result[2] = (byte)((integer & 0x0000FF00) >> 8);  
    result[3] = (byte)(integer & 0x000000FF);  
   
    return result;  
}  

