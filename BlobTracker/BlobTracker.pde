import gab.opencv.*;
import processing.video.*;
import processing.serial.*;

OpenCV opencv;
Histogram histogram;
Capture video;
Serial serial;

int lowerb = 50;
int range = 10;
int erode1 = 0;
int dilate1 = 0;
int erode2 = 0;
int dilate2 = 0;

int numContours = 0;
int accuracy = 50;

Command currentCommands[] = {Command.STOP,Command.STOP};
Command previousCommands[] = {Command.STOP,Command.STOP};
boolean findEdges = false;
boolean findContours = false;

boolean drawContours = true;
boolean drawCentroid = true;
boolean drawAllCentroids = false;

PVector centroid;
ArrayList<Contour> contours;

void setup() {
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  opencv.useColor(RGB);
  
  size(opencv.width*2, opencv.height*2, P2D);
  opencv.useColor(HSB);
  video.start();
  
  loadConfig();
  
  String portName = Serial.list()[0];
  serial = new Serial(this, portName, 9600);
}

void draw() {
  background(0);
  
  opencv.loadImage(video);
  
  pushMatrix();
  scale(1.0, -1.0);
  image(video, 0, -video.height );
  popMatrix();
  
  pushMatrix();
  scale(1.0, -1.0);
  image(video,0, -height, width/2,height/2);
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
  
  opencv.findCannyEdges(20,75);
  
  PVector bigX = new PVector(0,0);
  PVector smallX = new PVector(1000,0);
  PVector bigY = new PVector(0,0);
  PVector smallY = new PVector(0,1000);
  opencv.flip(0);
  if(findContours){
    contours = opencv.findContours();
    ArrayList<PVector> allPoints = new ArrayList<PVector>();
    for (Contour contour : contours) {
      stroke(255, 0, 0);
      beginShape();
      for (PVector point : contour.getPolygonApproximation().getPoints()) {
        vertex(point.x, point.y+height/2);
      }
      endShape();
      
      if(drawAllCentroids){
        PVector centroid = getCentroid(contour.getPolygonApproximation().getPoints());
        ellipse(centroid.x, centroid.y, 5, 5);
      }
      allPoints.addAll(contour.getPolygonApproximation().getPoints());
    }
    
    numContours = contours.size();
    
    centroid = getCentroid(allPoints);
    noFill();
    ellipse(centroid.x, centroid.y, 10, 10);
  }
  
  if((centroid.x-width/4) + (accuracy/2) < 0){
    currentCommands[0] = Command.LEFT;
  }else if((centroid.x-width/4) - (accuracy/2) > 0){
    currentCommands[0] = Command.RIGHT;
  }else{
    currentCommands[0] = Command.STOP;
  }
  
  if((centroid.y-height/4) + (accuracy/2) < 0){
    currentCommands[1] = Command.UP;
  }else if((centroid.y-height/4) - (accuracy/2) > 0){
    currentCommands[1] = Command.DOWN;
  }else{
    currentCommands[1] = Command.STOP;
  }

  //if(currentCommands[0] != previousCommands[0] || currentCommands[1] != previousCommands[1]){
    println((currentCommands[0].getCode() * 10) + currentCommands[1].getCode());
    serial.write((currentCommands[0].getCode() * 10) + currentCommands[1].getCode());
    previousCommands[0] = currentCommands[0];
    previousCommands[1] = currentCommands[1];
    
  //}

  
  image(opencv.getOutput(),width/2, 0, width/2,height/2);
  
  text("erode 1: " + erode1, 10+width/2,10+height/2);
  text("dilate 1: " + dilate1, 10+width/2,20+height/2);
  text("erode 2: " + erode2, 10+width/2,30+height/2);
  text("dilate 2: " + dilate2, 10+width/2,40+height/2);
  text("edges: " + findEdges, 10+width/2,50+height/2);
  text("contours: " + findContours, 10+width/2,60+height/2);
  text("lowerb:" + lowerb,10+width/2,70+height/2);
  text("upperb:" + (lowerb + range),10+width/2,80+height/2);
  text("range:" + range,10+width/2,90+height/2);
  text("Num Contours:" + numContours,10+width/2,100+height/2);
  text("X Distance:" + (centroid.x-width/4),10+width/2,110+height/2);
  text("Y Distance:" + (centroid.y-height/4),10+width/2,120+height/2);
  text("Commands:" + currentCommands[0] + " " + currentCommands[1],10+width/2,130+height/2);
  
  stroke(255, 255, 255);
  ellipse(width/4, height/4, accuracy, accuracy);
  line(centroid.x,centroid.y,width/4,height/4);
  
}

void loadConfig(){
  JSONObject json = new JSONObject();

  json = loadJSONObject("data/config.json");

  lowerb = json.getInt("lowerb");
  range = json.getInt("range");
  erode1 = json.getInt("erode1");
  dilate1 = json.getInt("dilate1"); 
  erode2 = json.getInt("erode2");
  dilate2 = json.getInt("dilate2");
  findEdges = json.getBoolean("edges");
  findContours = json.getBoolean("contours");
}

PVector getCentroid(ArrayList<PVector> vertices){
  float totalX = 0;
  float totalY = 0;
  int count = 0;
  for (PVector vertex : vertices) {
    count++;
    totalX += vertex.x;
    totalY += vertex.y;
  }
  return new PVector(totalX/count,totalY/count);
}
