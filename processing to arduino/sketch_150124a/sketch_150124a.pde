import java.awt.*;
import processing.serial.*;

Serial serial;

void setup() {
  size(320, 240);
  
  String portName = Serial.list()[0];
  serial = new Serial(this, portName, 9600);
  println(portName);
}

void draw() {
  
}

void keyPressed() {
  println(key);
  serial.write(key);
}
