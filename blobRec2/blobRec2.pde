import gab.opencv.*;

PImage img;
OpenCV opencv;
Histogram histogram;

int lowerb = 50;
int range = 10;
int erode1 = 0;
int dilate1 = 0;
int erode2 = 0;
int dilate2 = 0;

void setup() {
  img = loadImage("green.png");
  opencv = new OpenCV(this, img);
  size(opencv.width*2, opencv.height, P2D);
  opencv.useColor(HSB);
}

void draw() {
  opencv.loadImage(img);
  
  image(img, 0, 0);  
  
  opencv.setGray(opencv.getH().clone());
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
  histogram = opencv.findHistogram(opencv.getH(), 255);

  image(opencv.getOutput(),width/2, 0, width/2,height);

  noStroke(); fill(0);
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
  text(lowerb+range, ub+10, height-15);
  
  text("erode 1 (t- y+): " + erode1, 10,10);
  text("dilate 1 (u- i+): " + dilate1, 10,20);
  text("erode 2 (g- h+): " + erode2, 10,30);
  text("dilate 2 (j- k+): " + dilate2, 10,40);
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
}
