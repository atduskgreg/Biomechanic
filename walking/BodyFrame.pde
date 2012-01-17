class Joint {
  String name;
  ArrayList<Frame> frames;
  int radius;

  Joint(String name) {
    this.name = name;
    frames = new ArrayList();
  }
  
  void drawPath(){
    beginShape(LINE);
    for(int i = 0; i < frames.size(); i++){
      PVector position = frames.get(i).position;
      vertex(position.x, position.y, position.z);
    }
    endShape();
  }
  
  PVector slopeAtFrame(int f){
    PVector result = new PVector(0,0,0);
    
    Frame thisFrame = frames.get(f);
    if(f > 0){
      Frame prevFrame = frames.get(f - 1);
      result.x = thisFrame.position.x - prevFrame.position.x;
      result.y = thisFrame.position.y - prevFrame.position.y;
      result.z = thisFrame.position.z - prevFrame.position.z;
      
    } 
    
    return result;
  }

  void addFrame(Frame frame) {
    frames.add(frame);
  }

  PVector positionAtFrame(int frameNum) {
    return frames.get(frameNum).position;
  }
}

class Limb {
  Joint joint1;
  Joint joint2;

  Limb(Recording recording, int joint1Num, int joint2Num) {
    this.joint1 = recording.joints.get(joint1Num);
    this.joint2 = recording.joints.get(joint2Num);
  }

  void drawAtFrame(int frame) {
    PVector joint1Position = joint1.positionAtFrame(frame);
    PVector joint2Position = joint2.positionAtFrame(frame);
    
    line(joint1Position.x, joint1Position.y, joint1Position.z, joint2Position.x, joint2Position.y, joint2Position.z);
  }
}

class Frame {
  float time;
  PVector position;

  Frame(float x, float y, float z) {
    this.position = new PVector(x, y, z);
  }
}

