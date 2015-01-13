import gab.opencv.*;
import processing.video.*;

Capture video;
OpenCV opencv;

int lowerb = 0;
int range = 10;

void setup() {
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, video);
  size(640, 240, P2D);
  opencv.useColor(RGB);
  video.start();
}

void draw() {
  opencv.loadImage(video);
  
  image(video, 0,0);
  //opencv.contrast(lowerb);  
  //opencv.blur(12); 
  opencv.gray(); 
  opencv.blur(12); 
  opencv.inRange(lowerb, lowerb+range); //40 60
  
  opencv.erode();
  opencv.erode();
  opencv.erode();
  
  
  
  

  image(opencv.getOutput(),320, 0, 320,240);
  
  stroke(255, 0, 0); fill(255, 0, 0);
  strokeWeight(2);
  text("lowerb: " + lowerb, 10, 10);
  text("upperb: " + (lowerb + range), 10, 20);
}

void keyPressed() {
 if(key == 'q'){
   lowerb++;
 }else if (key == 'a'){
   lowerb--;
 }else if(key == 'w'){
   range++;
 }else if(key == 's'){
   range--;
 }
}
