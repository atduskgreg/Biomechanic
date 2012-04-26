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
  
  void drawTruncated(float x, float y, float z){}

  void drawAtFrame(int frame) {
    PVector joint1Position = joint1.positionAtFrame(frame);
    PVector joint2Position = joint2.positionAtFrame(frame);
    
    if(render3d){
    
    PVector limbDirection = new PVector(joint1Position.x,joint1Position.y,joint1Position.z );
    
    // calculate the "limb" vector between j1 and j2
    limbDirection.sub(joint2Position);
    
    PVector limbDifference = new PVector(limbDirection.x, limbDirection.y, limbDirection.z);
    
    // capture length of limb
    float limbLength = limbDifference.mag();
    
    limbDirection.normalize();
    
    // define model orientation (0,1,0)
    PVector modelOrientation = new PVector(0,1,0);
    
    float angle = acos(modelOrientation.dot(limbDirection)); 
    PVector axis = modelOrientation.cross(limbDirection); 
    
    pushMatrix();
    pushStyle();
    translate((joint1Position.x + joint2Position.x)/2, (joint1Position.y + joint2Position.y)/2, (joint1Position.z + joint2Position.z)/2 );
     //noStroke();
     stroke(150, 0, 0);
    // rotate angle amount around axis
    rotate(angle, axis.x, axis.y, axis.z);

    box(0.05, limbLength, 0.05);
    popStyle();
    popMatrix();
    } else {
    
      line(joint1Position.x, joint1Position.y, joint1Position.z, joint2Position.x, joint2Position.y, joint2Position.z);
    }
  }
}

class Frame {
  float time;
  PVector position;

  Frame(float x, float y, float z) {
    this.position = new PVector(x, y, z);
  }
}

