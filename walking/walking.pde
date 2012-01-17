import processing.opengl.*;

CSVMap csvMap;
//Recording recording;

Comparison comparison;

FrameController controller;
ArrayList<GaitPhase> phases;

int rot = 0;

void setup() {
  size(1000, 600, OPENGL);
  csvMap = new CSVMap("walking_3d.csv");
  csvMap.dataStartRow = 6;
  csvMap.labelRow = 4;
  csvMap.dataStartColumn = 2;
  csvMap.startColumn = 2;

  comparison = new Comparison();

  Recording recording = new Recording(csvMap);
  comparison.addRecording(recording, 0, recording.totalFrames-1);
  
  controller = new FrameController(this, comparison, 50, height - 100, width-100);

  phases = recording.detectPhases();

  println("num phases: " + phases.size());

  for (int i = 0; i < phases.size(); i++) {
    GaitPhase phase = phases.get(i); 
    println("beginning frame: " + phase.beginningFrame + "end frame: " + phase.endingFrame +  " type: " + phase.type);
  }
}

void draw() {
  background(255);
  lights();
  stroke(0);
  fill(0);
  
  
  
  controller.update();
  controller.draw();
  
  text(int(frameRate), 20, 20);
  
  Recording recording = comparison.recordings.get(0);
  
  fill(0, 255, 0);
  text("Right ankle height: " + recording.joints.get(3).positionAtFrame(recording.currentFrame).z, 20, 50);
  text("Right ankle dZ: " + recording.joints.get(3).slopeAtFrame(recording.currentFrame).z, 20, 65);
  text("Right ankle dX: " + recording.joints.get(3).slopeAtFrame(recording.currentFrame).x, 20, 80);
  

  fill(255, 0, 0);
  text("Left ankle height: " + recording.joints.get(9).positionAtFrame(recording.currentFrame).z, 20, 95);
  text("Left ankle dZ: " + recording.joints.get(9).slopeAtFrame(recording.currentFrame).z, 20, 110);
  text("Left ankle dX: " + recording.joints.get(9).slopeAtFrame(recording.currentFrame).x, 20, 125);

  

  pushMatrix();
    translate(300, 500, -100);
    scale(200);
    rotateX(radians(90));
    
    // for some reason this makes things incredibly slow
    /*translate(0,0, 500);
    rotateZ(radians(map(mouseX, 0, width, -180, 180)));
    translate(0,0,-500);
    */
    comparison.update();
    comparison.draw();
  popMatrix();
}

void mousePressed() {
  controller.mousePressed();
}


void keyPressed() {
  controller.keyPressed();
}

void mouseDragged() {
  controller.mouseDragged();
}

