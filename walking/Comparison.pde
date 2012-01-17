class Comparison {
  ArrayList<Recording> recordings;
  ArrayList<FrameRange> ranges;
  int currentFrame = 0;
  int totalFrames = 0;
  
  Comparison(){
    recordings = new ArrayList();
    ranges = new ArrayList();
  }
  
  void update(){
    for(int i = 0; i < recordings.size(); i++){
      recordings.get(i).currentFrame = currentFrame + ranges.get(i).startingFrame;
    }
  }
  
  void draw(){
    noStroke();
    fill(254);
    beginShape(QUADS);
    vertex(-1.25, -0.5, 0);
    vertex(-1.25, 0.5, 0);
    vertex(3.25, 0.5, 0);
    vertex(3.25, -0.5, 0);
    endShape();
        
    // use the left ankle as the reference point
    PVector referencePoint = recordings.get(0).joints.get(9).positionAtFrame(ranges.get(0).startingFrame);     
        
        
        
    for(int i = 0; i < recordings.size(); i++){

      PVector recordingAnchor = recordings.get(i).joints.get(9).positionAtFrame(ranges.get(i).startingFrame);
     // println("recording: " + i + " pos: " + recordingAnchor);

      PVector offset = PVector.sub(recordingAnchor, referencePoint);
      pushMatrix();
        translate(-offset.x, -offset.y, -offset.z);   
        recordings.get(i).draw();
      popMatrix();
    }
  }
  
  void clear(){
    recordings.clear();
    ranges.clear();
    totalFrames = 0;
    currentFrame = 0;
  }
  
  void addRecording(Recording recording, int fromFrame, int toFrame){
    // have to clone the recordings so we can maintain
    // two seperate sets of state.
    try{
      Recording newRecording = recording.clone();
      recordings.add(newRecording);
    }catch(CloneNotSupportedException error) {
      println(error);
    }
    
    FrameRange range = new FrameRange(fromFrame, toFrame);
    ranges.add(range);
    
    // expand size of comparison to include the longest
    // frame range. will have to deal with diff lengths
    // in playback
    if(range.length() > totalFrames){
      totalFrames = range.length();
    }
  }
  
  void nextFrame() {
    currentFrame++;
    if (currentFrame >= totalFrames) {
      currentFrame = 0;
    }
  }
  
  
}

class FrameRange {
  int startingFrame;
  int endingFrame;
  
  FrameRange(int startingFrame, int endingFrame){
    this.startingFrame = startingFrame;
    this.endingFrame = endingFrame;
  }
  
  int length(){
    return endingFrame - startingFrame;
  }
}
