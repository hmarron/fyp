import gab.opencv.*;
import processing.video.*;
import controlP5.*;

OpenCV opencv;
Capture video;
ControlP5 controller;

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

String saveFile = "";

void setup() {
  controller = new ControlP5(this);
  controller.addSlider("lowerb",0,255,0,10,250,100,10);
  controller.addSlider("range",0,255,0,10,270,100,10);
  controller.addSlider("erode1",0,10,0,10,290,100,10);
  controller.addSlider("dilate1",0,10,0,10,310,100,10);
  controller.addSlider("erode2",0,10,0,10,330,100,10);
  controller.addSlider("dilate2",0,10,0,10,350,100,10);
  
  controller.addButton("Edges_On",10,260,250,80,20);
  controller.addButton("Edges_Off",10,350,250,80,20);
  controller.addButton("Contours_On",10,260,280,80,20);
  controller.addButton("Contours_Off",10,350,280,80,20);
  
  controller.addTextfield("saveFile").setPosition(260,320).setSize(200,20);
  
  controller.addButton("Save",10,260,360,80,20);
  
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  
  size(opencv.width*2, opencv.height+150, P2D);
  opencv.useColor(HSB);
  video.start();
}

void draw() {
  background(0);
  opencv.loadImage(video);
  
  image(video, 0, 0); 
  
  pushMatrix();
  scale(1.0, -1.0);
  image(video, 0, -video.height);
  popMatrix();
  
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
  image(opencv.getOutput(),width/2, 0, width/2,height/2);
}

void saveConfig(String filename){
  JSONObject json = new JSONObject();

  json.setInt("lowerb", lowerb);
  json.setInt("range", range);
  json.setInt("erode1", erode1);
  json.setInt("dilate1", dilate1);
  json.setInt("erode2", erode2);
  json.setInt("dilate2", dilate2);
  json.setBoolean("edges", true);
  json.setBoolean("contours", true);

  saveJSONObject(json, "data/"+filename+".json");
}

void Edges_On(){
  findEdges = true;
}

void Edges_Off(){
  findEdges = false;
}

void Contours_On(){
  findContours = true;
}

void Contours_Off(){
  findContours = false;
}

void Save(){
  saveConfig(controller.get(Textfield.class,"saveFile").getText());
}
