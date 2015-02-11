import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Histogram histogram;
Capture video;

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

  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  opencv.useColor(RGB);
  
  size(opencv.width*2, opencv.height, P2D);
  opencv.useColor(HSB);
  video.start();
}

void draw() {
 
  opencv.loadImage(video);
  
  image(video, 0, 0); 
  
  pushMatrix();
  scale(1.0, -1.0);
  image(video, 0, -video.height );
  popMatrix();
  
  histogram = opencv.findHistogram(opencv.getH(), 255);
  
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
  
  opencv.flip(0);
  image(opencv.getOutput(),width/2, 0, width/2,height);
  
  text("erode 1 (t- y+): " + erode1, 10,10);
  text("dilate 1 (u- i+): " + dilate1, 10,20);
  text("erode 2 (g- h+): " + erode2, 10,30);
  text("dilate 2 (j- k+): " + dilate2, 10,40);
  text("edges (x): " + findEdges, 10,50);
  text("contours (z): " + findContours, 10,60);
  text("lowerb:" + lowerb,10,70);
  text("upperb:" + (lowerb + range),10,80);
  text("range:" + range,10,90);
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
  
  if (key == 'p'){
    saveConfig();
  }
}

void saveConfig(){
  JSONObject json = new JSONObject();

  json.setInt("lowerb", lowerb);
  json.setInt("range", range);
  json.setInt("erode1", erode1);
  json.setInt("dilate1", dilate1);
  json.setInt("erode2", erode2);
  json.setInt("dilate2", dilate2);
  json.setBoolean("edges", findEdges);
  json.setBoolean("contours", findContours);

  saveJSONObject(json, "data/config.json");
}
