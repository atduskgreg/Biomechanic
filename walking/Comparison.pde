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
      recordings.get(i).currentFrame = currentFrame;
    }
  }
  
  void draw(){
    for(int i = 0; i < recordings.size(); i++){
      recordings.get(i).draw();
    }
  }
  
  void clear(){
    recordings.clear();
    ranges.clear();
    totalFrames = 0;
    currentFrame = 0;
  }
  
  void addRecording(Recording recording, int fromFrame, int toFrame){
    recordings.add(recording);
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
