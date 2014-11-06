import gab.opencv.*;
import processing.video.*;

//PImage img;
OpenCV opencv;
Histogram histogram;
Capture img;

int lowerb = 50;
int range = 10;
int erode1 = 0;
int dilate1 = 0;
int erode2 = 0;
int dilate2 = 0;

boolean findEdges = false;
boolean findContours = false;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

void setup() {
  //img = loadImage("green.png");
  //opencv = new OpenCV(this, img);
  img = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  opencv.useColor(RGB);
  
  size(opencv.width*2, opencv.height, P2D);
  opencv.useColor(HSB);
  img.start();
}

void draw() {
  opencv.loadImage(img);
  
  image(img, 0, 0);  
  histogram = opencv.findHistogram(opencv.getH(), 255);
  
  //opencv.setGray(opencv.getH().clone());
  opencv.gray();
  opencv.inRange(lowerb, lowerb+range);
  for(int i=0; i<erode1;i++){
    opencv.erode();
  }
  for(int i=0; i<dilate1;i++){
    opencv.dilate();
  }
  for(int i=0; i<erode2;i++){
    opencv.erode();
  }
  for(int i=0; i<dilate2;i++){
    opencv.dilate();
  }
  
  if(findEdges){
    opencv.findCannyEdges(20,75);
  }
  
  PVector bigX = new PVector(0,0);
  PVector smallX = new PVector(1000,0);
  PVector bigY = new PVector(0,0);
  PVector smallY = new PVector(0,1000);
      
  if(findContours){
    contours = opencv.findContours();
    for (Contour contour : contours) {
      stroke(0, 255, 0);
      contour.draw();
      
      //exact shape
      stroke(255, 0, 0);
      beginShape();
      for (PVector point : contour.getPolygonApproximation().getPoints()) {
        vertex(point.x, point.y);
      }
      endShape();
      
      for (PVector point : contour.getPolygonApproximation().getPoints()) {
        if(point.x > bigX.x){
          bigX = point;
        }
        if(point.x < smallX.x){
          smallX = point;
        }
        if(point.y > bigY.y){
          bigY = point;
        }
        if(point.y < smallY.y){
          smallY = point;
        }
      }
      
    }
    
     //aproximate rectangle
      stroke(0, 0, 255);
      beginShape();
      vertex(smallY.x, smallY.y);
      vertex(bigX.x, bigX.y);
      vertex(bigY.x, bigY.y);
      vertex(smallX.x, smallX.y);
      vertex(smallY.x, smallY.y);
      endShape();
    
  }
  
  //histogram = opencv.findHistogram(opencv.getH(), 255);

  

  image(opencv.getOutput(),width/2, 0, width/2,height);

  /*noStroke(); fill(0);
  histogram.draw(10, height - 230, 400, 200);
  noFill(); stroke(0);
  line(10, height-30, 410, height-30);

  text("Hue", 10, height - (textAscent() + textDescent()));

  float lb = map(lowerb, 0, 255, 0, 400);
  float ub = map(lowerb+range, 0, 255, 0, 400);

  stroke(255, 0, 0); fill(255, 0, 0);
  strokeWeight(2);
  line(lb + 10, height-30, ub +10, height-30);
  ellipse(lb+10, height-30, 3, 3 );
  text(lowerb, lb-10, height-15);
  ellipse(ub+10, height-30, 3, 3 );
  text(lowerb+range, ub+10, height-15);*/
  
  text("erode 1 (t- y+): " + erode1, 10,10);
  text("dilate 1 (u- i+): " + dilate1, 10,20);
  text("erode 2 (g- h+): " + erode2, 10,30);
  text("dilate 2 (j- k+): " + dilate2, 10,40);
  text("edges (x): " + findEdges, 10,50);
  text("contours (z): " + findContours, 10,60);
  
}

void keyPressed() {
  if (key == 'w') {
    range++;
  } else if (key == 's'){
    range--;
  } else if (key == 'a'){
    lowerb--;
  } else if (key == 'd'){
    lowerb++;
  } 
  
  if (key == 'y'){
    erode1++;
  } else if (key == 't'){
    erode1--;
  } else if (key == 'h'){
    erode2++;
  } else if (key == 'g'){
    erode2--;
  }
  
  if (key == 'i'){
    dilate1++;
  } else if (key == 'u'){
    dilate1--;
  } else if (key == 'k'){
    dilate2++;
  } else if (key == 'j'){
    dilate2--;
  }
  
  if (key == 'z'){
    findContours = !findContours;
  } else if (key == 'x'){
    findEdges = !findEdges;
  }
}
