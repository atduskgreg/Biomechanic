import processing.video.*;
import processing.opengl.*;

String dataFilename = "Animation.csv";


CSVMap csvMap;
Comparison comparison;
Recording originalRecording;

boolean comparisonMode = false;
boolean render3d = true;
boolean rotateMode = false;

boolean flipHorizontal = false;

float rotation = 0;

FrameController controller;
ArrayList<GaitPhase> phases; // the working set that gets toggled with comparison
ArrayList<GaitPhase> originalPhases; // the complete results of analysis

int targetFPS = 30;

int millisBetweenFrames = 1000 / targetFPS;
int timeOfLastFrame = 0;

void setup() {
  size(1000, 600, OPENGL);

  hint(ENABLE_OPENGL_4X_SMOOTH);

  /*  println("loading movie maker");
   mm = new MovieMaker(this, 1000, 600, "walking.mov",
   60, MovieMaker.ANIMATION, MovieMaker.HIGH);
   println("done");*/

  csvMap = new CSVMap(dataFilename);

  comparison = new Comparison();

  originalRecording = new Recording(csvMap);
  println("totalFrames parsed: " + originalRecording.totalFrames);

  comparison.addRecording(originalRecording, 0, originalRecording.totalFrames);
  println("comparison totalFrames: " + comparison.totalFrames);

  controller = new FrameController(this, comparison, 50, height - 100, width-100);

  originalPhases = originalRecording.detectPhases();
  phases = (ArrayList<GaitPhase>)originalPhases.clone();

  println("num phases: " + phases.size());

  for (int i = 0; i < phases.size(); i++) {
    GaitPhase phase = phases.get(i); 
    println("beginning frame: " + phase.startingFrame + " end frame: " + phase.endingFrame +  " type: " + phase.type);
  }
  timeOfLastFrame = millis();
}

void draw() {
  background(255);
  lights();
  stroke(0);
  fill(0);  

  controller.draw();

  text("APP FPS: " + int(frameRate) + "\nPLABACK FPS: " + targetFPS, 20, 20);

  Recording recording = comparison.recordings.get(0);

  /*fill(0, 255, 0);
   text("Right ankle dX: " + recording.joints.get(3).slopeAtFrame(recording.currentFrame).x, 20, 35);
   
   
   fill(255, 0, 0);
   text("Left ankle dX: " + recording.joints.get(9).slopeAtFrame(recording.currentFrame).x, 20, 50);
   */

  if (comparisonMode) {
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
  } 
  /*else {
   fill(0);
   text("FULL PLAYBACK", width-250, 20);
   text("Gait phases detected: " + originalPhases.size(), width-250, 35 );
   text("Complete gait cycles detected: " + originalPhases.size()/4, width-250, 50 );
   }*/



  // for some reason this makes things incredibly slow only in 2.0a4

  // enforce playback rate of animation
  millisBetweenFrames = 1000 / targetFPS;
  if (millis() - timeOfLastFrame >= millisBetweenFrames) {
    timeOfLastFrame = millis();
    controller.update();
    comparison.update();
  }

  pushMatrix();

  
  translate(300, 500, -100);
  scale(200);

  if (rotateMode) {
    rotation = map(mouseX, 0, width, -180, 180);
  }

  fill(254);
  pushMatrix();
  rotateX(radians(90));
  translate(0, 0, 500);
  rotateZ(radians(rotation));
  translate(0, 0, -500);


  beginShape(QUADS);
  vertex(-1.25, -0.5, 0);
  vertex(-1.25, 0.5, 0);
  vertex(3.25, 0.5, 0);
  vertex(3.25, -0.5, 0);
  endShape();

  popMatrix();

  translate(0, 0, 500);
  rotateZ(radians(rotation));
  translate(0, 0, -500);  

 
  comparison.draw();
  popMatrix();



  // mm.addFrame();
}

void switchToComparisonMode() {
  if (originalPhases.size() > 2) {
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

  if (key == 'r') {
    rotateMode = !rotateMode;
  }



  if (key == 'd') {
    render3d = !render3d;
  }

  if (key == '=' ) {
    targetFPS++;
  }  

  if (key == '-') {
    targetFPS--;
    if (targetFPS < 1) {
      targetFPS = 1;
    }
  }

  if (key == 'f') {
    flipHorizontal = !flipHorizontal;
  }
}

void mouseDragged() {
  controller.mouseDragged();
}

