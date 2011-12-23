class Joint{
  String name;
  ArrayList<Frame> frames;
  int radius;
}

class Frame{
  float time;  
}


/*
class BodyFrame {
  PVector baseRibCage;
  PVector rightHip;
  PVector rightKnee;
  PVector rightFibula;
  PVector rightAnkle;
  PVector rightHeel;
  PVector rightMetatarsal;

  float time;

  int radius;

  BodyFrame(String csvLine) {
    String[] positions = csvLine.split(",");

    baseRibCage = new PVector(float(positions[2]), float(positions[3]));
    rightHip = new PVector(float(positions[4]), float(positions[5]));
    rightKnee = new PVector(float(positions[6]), float(positions[7]));
    rightFibula = new PVector(float(positions[8]), float(positions[9]));
    rightAnkle = new PVector(float(positions[10]), float(positions[11]));
    rightHeel = new PVector(float(positions[12]), float(positions[13]));
    rightMetatarsal = new PVector(float(positions[14]), float(positions[15]));

    radius = 3;
  }

  void drawJoint(PVector joint, String jointName) {
    drawJoint(joint, jointName, 0, 0);
  }

  void drawJoint(PVector joint, String jointName, int offsetX, int offsetY) {
    ellipse(joint.x, joint.y, radius, radius);
    if (drawText) {
      //textSize(7);

      pushMatrix();
        translate(joint.x, joint.y);
        rotate(radians(180));
        translate(-1 * joint.x, -1 * joint.y);
        translate(joint.x + offsetX + 5, joint.y + offsetY);
        scale(0.6);
        text(jointName,0,0);
      popMatrix();
    }
  }

  void draw() {

    drawJoint(baseRibCage, "Base Rib Cage");
    line(baseRibCage.x, baseRibCage.y, rightHip.x, rightHip.y);

    drawJoint(rightHip, "Right Hip");
    line(rightHip.x, rightHip.y, rightKnee.x, rightKnee.y);
    
    drawJoint(rightKnee, "Right Knee");    
    line(rightKnee.x, rightKnee.y, rightFibula.x, rightFibula.y);
    
    drawJoint(rightFibula, "Right Fibula");    
    line(rightFibula.x, rightFibula.y, rightAnkle.x, rightAnkle.y);
    
    drawJoint(rightAnkle, "Right Ankle", 0, -5);    
    line(rightAnkle.x, rightAnkle.y, rightHeel.x, rightHeel.y);
    
    drawJoint(rightHeel, "Right Heel", 0, 5);    
    line(rightHeel.x, rightHeel.y, rightMetatarsal.x, rightMetatarsal.y);
    
    drawJoint(rightMetatarsal, "Right Metatarsal", -60, 3);
  }
}
*/
