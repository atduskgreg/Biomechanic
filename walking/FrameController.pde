import java.awt.Rectangle;

class FrameController {
  Comparison comparison;

  Rectangle playhead;
  Rectangle playarea;

  boolean playing = false;


  FrameController(PApplet p, Comparison comparison, int x, int y, int w) {
    this.comparison = comparison;

    playarea = new Rectangle(x,y, w,40);
    playhead = new Rectangle(0, 0, 5, 40);
  }

  void update() {
    if(playing){
      comparison.nextFrame();
    }
        
    float proportion =  float(comparison.currentFrame) / comparison.totalFrames;
    float offset = playarea.width * proportion;

    playhead.x = int(offset);
  }

  void draw() {
    pushMatrix();
    translate(playarea.x, playarea.y);
    //fill(240);
    noFill();
    stroke(100);
    strokeWeight(0.5);
    rect(0, 0, playarea.width, playarea.height);
    
    int offset = phases.get(0).startingFrame;
    
    for (int i = 0; i < phases.size(); i++) {
      GaitPhase phase = phases.get(i); 
      int phaseStartX = frameToX(phase.startingFrame - offset);
      int phaseStopX = frameToX(phase.endingFrame - offset);
      noStroke();
      fill(phase.phaseColor());
      rect(phaseStartX, 0, phaseStopX - phaseStartX, playarea.height);
    }

    fill(100);
    text("0", 0, 55);
    text(comparison.totalFrames-1, playarea.width - 20, 55);

    text(comparison.currentFrame + "/" + (comparison.totalFrames-1), playarea.width/2 - 40, 55);
    fill(190);
    text("Play/Pause - spacebar      Previous Frame - left arrow      Next Frame - right arrow      Toggle 3d - d      Toggle Rotation - r", playarea.width/2 - 360, 90);

    noStroke();
    fill(0);
    rect(playhead.x, playhead.y, playhead.width, playhead.height);


    popMatrix();
  }
  
  int frameToX(int _frame){
      return int(map(_frame, 0, comparison.totalFrames, 0, playarea.width));

  }

  int frameFromX(int _x) {
    return int(map(_x - playarea.x, 0, playarea.width, 0, comparison.totalFrames));
  }

  void mousePressed() {
    if(playarea.contains(mouseX, mouseY)){
      goToFrame(frameFromX(mouseX ));
    }
    
  }

  void mouseDragged(){
    if(playarea.contains(mouseX, mouseY)){
      goToFrame(frameFromX(mouseX));
    }
  }


  void goToFrame(int frame) {
    if(frame >= comparison.totalFrames){
     frame = 0;
    }
    
    if(frame < 0){
      frame = comparison.totalFrames - 1;
    }
    comparison.currentFrame = frame;
  }

  void keyPressed() {
    if (key == CODED) {
      if (keyCode == LEFT) {
        goToFrame(comparison.currentFrame - 1);
      }

      if (keyCode == RIGHT) {
        goToFrame(comparison.currentFrame + 1);
      }
    } 
    
    if(key == ' '){
      playing = !playing;
    }
    
  }


}

