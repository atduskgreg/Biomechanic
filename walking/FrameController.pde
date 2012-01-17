import java.awt.Rectangle;

class FrameController {
  Recording recording;

  Rectangle playhead;
  Rectangle playarea;

  boolean playing = false;


  FrameController(PApplet p, Recording recording, int x, int y, int w) {
    this.recording = recording;

    playarea = new Rectangle(x,y, w,40);
    

    playhead = new Rectangle(0, 0, 5, 40);
  }

  void update() {
    if(playing){
      recording.nextFrame();
    }
    
    float proportion =  float(recording.currentFrame) / recording.totalFrames;
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
    
    for (int i = 0; i < phases.size(); i++) {
      GaitPhase phase = phases.get(i); 
      int phaseStartX = frameToX(phase.beginningFrame);
      int phaseStopX = frameToX(phase.endingFrame);
      noStroke();
      fill(phase.phaseColor());
      rect(phaseStartX, 0, phaseStopX - phaseStartX, playarea.height);
    }
    

    fill(100);
    text("0", 0, 55);
    text(recording.totalFrames-1, playarea.width - 20, 55);

    text(recording.currentFrame + "/" + (recording.totalFrames-1), playarea.width/2 - 40, 55);
    fill(190);
    text("Play/Pause - spacebar      Previous Frame - left arrow      Next Frame - right arrow", playarea.width/2 - 225, 90);

  

    noStroke();
    fill(0);
    rect(playhead.x, playhead.y, playhead.width, playhead.height);


    popMatrix();
  }
  
  int frameToX(int _frame){
      return int(map(_frame, 0, recording.totalFrames, 0, playarea.width));

  }

  int frameFromX(int _x) {
    return int(map(_x - playarea.x, 0, playarea.width, 0, recording.totalFrames));
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
    if(frame >= recording.totalFrames){
     frame = 0;
    }
    
    if(frame < 0){
      frame = recording.totalFrames - 1;
    }
    recording.currentFrame = frame;
  }

  void keyPressed() {
    if (key == CODED) {
      if (keyCode == LEFT) {
        goToFrame(recording.currentFrame - 1);
      }

      if (keyCode == RIGHT) {
        goToFrame(recording.currentFrame + 1);
      }
    } 
    
    if(key == ' '){
      playing = !playing;
    }
    
  }


}

