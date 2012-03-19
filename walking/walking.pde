import processing.video.*;
import processing.opengl.*;


CSVMap csvMap;

Comparison comparison;
Recording originalRecording;

boolean comparisonMode = false;
boolean render3d = false;
boolean rotateMode = false;

float rotation = 0;

FrameController controller;
ArrayList<GaitPhase> phases; // the working set that gets toggled with comparison
ArrayList<GaitPhase> originalPhases; // the complete results of analysis

void setup() {
  
  
  size(1000, 600, OPENGL);
 
  hint(ENABLE_OPENGL_4X_SMOOTH);
  
  /*  println("loading movie maker");
  mm = new MovieMaker(this, 1000, 600, "walking.mov",
                       60, MovieMaker.ANIMATION, MovieMaker.HIGH);
  println("done");*/
  
  csvMap = new CSVMap("walking_3d.csv");
  csvMap.dataStartRow = 6;
  csvMap.labelRow = 4;
  csvMap.dataStartColumn = 2;
  csvMap.startColumn = 2;

  comparison = new Comparison();

  originalRecording = new Recording(csvMap);
  comparison.addRecording(originalRecording, 0, originalRecording.totalFrames);

  controller = new FrameController(this, comparison, 50, height - 100, width-100);

  originalPhases = originalRecording.detectPhases();
  phases = (ArrayList<GaitPhase>)originalPhases.clone();
  
  println("num phases: " + phases.size());

  for (int i = 0; i < phases.size(); i++) {
    GaitPhase phase = phases.get(i); 
    println("beginning frame: " + phase.startingFrame + " end frame: " + phase.endingFrame +  " type: " + phase.type);
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
  text("Right ankle dX: " + recording.joints.get(3).slopeAtFrame(recording.currentFrame).x, 20, 35);


  fill(255, 0, 0);
  text("Left ankle dX: " + recording.joints.get(9).slopeAtFrame(recording.currentFrame).x, 20, 50);

  if(comparisonMode){
    fill(0);
    text("GAIT CYCLE COMPARISON", width-250, 20);
      Recording recording1 = comparison.recordings.get(0);
    Recording recording2 = comparison.recordings.get(1);
   
    float strideLength1 = recording1.joints.get(9).positionAtFrame(comparison.ranges.get(0).startingFrame).x - recording1.joints.get(9).positionAtFrame(comparison.ranges.get(0).endingFrame).x;
    float strideLength2 = recording2.joints.get(9).positionAtFrame(comparison.ranges.get(1).startingFrame).x - recording2.joints.get(9).positionAtFrame(comparison.ranges.get(1).endingFrame).x;

    fill(comparison.skeletonColors[0]);
    text("Cycle 1 length (m): " + strideLength1, width-250, 35 );
    fill(comparison.skeletonColors[1]);
    text("Cycle 2 length (m): " + strideLength2, width-250, 50 );
    fill(0);
    text("Length difference (m): " + abs(strideLength1 - strideLength2), width-250, 65 );
  } else {
    fill(0);
    text("FULL PLAYBACK", width-250, 20);
    text("Gait phases detected: " + originalPhases.size(), width-250, 35 );
    text("Complete gait cycles detected: " + originalPhases.size()/4, width-250, 50 );

  }


  pushMatrix();
  translate(300, 500, -100);
  scale(200);
  rotateX(radians(90));


  if(rotateMode){
    rotation = map(mouseX, 0, width, -180, 180);
  }
   
    // for some reason this makes things incredibly slow only in 2.0a4
   translate(0,0, 500);
     rotateZ(radians(rotation));
   translate(0,0,-500);

 
   
  comparison.update();
  comparison.draw();
  popMatrix();
  
 // mm.addFrame();
}

void switchToComparisonMode() {
  comparison.clear();
  comparison.addRecording(originalRecording, originalPhases.get(1).startingFrame, originalPhases.get(4).endingFrame);
  comparison.addRecording(originalRecording, originalPhases.get(5).startingFrame, originalPhases.get(8).endingFrame);
    
  phases.clear();
  phases.add(originalPhases.get(1));
  phases.add(originalPhases.get(2));
  phases.add(originalPhases.get(3));
  phases.add(originalPhases.get(4));
  
  comparisonMode = true;
}

void switchToPlaybackMode() {
  comparison.clear();
  comparison.addRecording(originalRecording, 0, originalRecording.totalFrames);
  
  phases.clear();
  phases = (ArrayList<GaitPhase>)originalPhases.clone();

  comparisonMode = false;
}

void mousePressed() {
  controller.mousePressed();
}


void keyPressed() {
  controller.keyPressed();

  if (key == 'c') {
    if (comparisonMode) {
      switchToPlaybackMode();
    } 
    else {
      switchToComparisonMode();
    }
  }
  
  if(key == 'r') {
    rotateMode = !rotateMode;
  }
  
  
  
  if (key == 'd') {
    render3d = !render3d;
  }
}

void mouseDragged() {
  controller.mouseDragged();
}

