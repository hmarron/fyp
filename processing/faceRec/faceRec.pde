import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;
import java.nio.ByteBuffer;

Capture video;
OpenCV opencv;
Serial serial;
boolean sendX = true;

void setup() {
  size(320, 240);
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
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    float faceCenterX = faces[0].x + (faces[0].width / 2);
    float faceCenterY = faces[0].y + (faces[0].height / 2);
    //println(faceCenterX + "," + faceCenterY);
    
    int centerXScaled = (int)Math.round((faceCenterX / 320) * 180);
    int centerYScaled = (int)Math.round((faceCenterY / 240) * 180);
    println(centerXScaled + "," + centerYScaled);
    
    serial.write(intToByteArray(centerXScaled));
    serial.write(intToByteArray(centerYScaled));
    
    
    
  }
}

void captureEvent(Capture c) {
  c.read();
}

byte[] intToByteArray(int i){
  return ByteBuffer.allocate(4).putInt(i).array();
}
