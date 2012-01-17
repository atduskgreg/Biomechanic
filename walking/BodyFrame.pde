class Joint {
  String name;
  ArrayList<Frame> frames;
  int radius;

  Joint(String name) {
    this.name = name;
    frames = new ArrayList();
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

