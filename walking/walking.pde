import damkjer.ocd.*;
import processing.opengl.*;
import controlP5.*;

ControlP5 controlP5;
Camera cam;

CSVMap csvMap;
Recording recording;

FrameController controller;

void setup() {
  size(1000, 600, OPENGL);
  csvMap = new CSVMap("walking_3d.csv");
  csvMap.dataStartRow = 6;
  csvMap.labelRow = 4;
  csvMap.dataStartColumn = 2;
  csvMap.startColumn = 2;

  recording = new Recording(csvMap);
  controller = new FrameController(this, recording, 50, height - 100, width-100);
  
  sphereDetail(10);

}

void draw() {
  
  background(255);

  lights();
  
  stroke(0);
  fill(0);
  text(frameRate, 20, 20);
  controller.update();
  controller.draw();

  pushMatrix();

  translate(300, 500, -100);

  scale(200);
  rotateX(radians(90));

  recording.draw();
  //recording.nextFrame();
  
  popMatrix();

  
}



void mousePressed(){
  controller.mousePressed();
}


void keyPressed(){
  controller.keyPressed();
 
}

void mouseDragged(){
  controller.mouseDragged();
}
