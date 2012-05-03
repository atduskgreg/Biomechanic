class Recording implements Cloneable {
  CSVMap csvMap;
  ArrayList<Joint> joints;
  int totalFrames;
  ArrayList<Limb> limbs;

  color skeletonColor = color(0); // default to black

  int currentFrame = 0;

  Recording(CSVMap csvMap) {
    joints = new ArrayList();
    limbs = new ArrayList();
    this.csvMap = csvMap;
    parse(csvMap);
    configureLimbs();
  }

  void configureLimbs() {
    println(this.csvMap);
    LimbConfig config = new LimbConfig(csvMap.pathToCSV);
    for (int i = 0; i < config.jointPairs.length; i++) {
      limbs.add(new Limb(this, config.jointPairs[i][0], config.jointPairs[i][1]));
    }
  }


  ArrayList<GaitPhase> detectPhases() {
    Joint leftJoint = joints.get(3);
    Joint rightJoint = joints.get(9);

    ArrayList<GaitPhase> results = new ArrayList();


    int prevPhaseType = GaitPhase.DOUBLE_SUPPORT;
    int lastFrameChanged = 0;

    for (int i = 1; i < totalFrames-1; i++) {

      // look for local minima in each limb
      PVector leftSlope = leftJoint.slopeAtFrame(i);
      PVector rightSlope = rightJoint.slopeAtFrame(i);

      boolean leftJointMin = false;
      boolean rightJointMin = false;

      if (abs(leftSlope.x) < 0.01) {// && abs(leftSlope.z) < 0.01) {
        leftJointMin = true;
      }

      if (abs(rightSlope.x) < 0.01) {// && abs(rightSlope.z) < 0.01) {
        rightJointMin = true;
      }

      int phase = -1;
      if (leftJointMin && rightJointMin) {
        phase = GaitPhase.DOUBLE_SUPPORT;
      } 
      else {
        if (leftJointMin) {
          phase = GaitPhase.SINGLE_SUPPORT_LEFT;
        }
        if (rightJointMin) {
          phase = GaitPhase.SINGLE_SUPPORT_RIGHT;
        }
      }

      if (phase != prevPhaseType) {
        results.add(new GaitPhase(lastFrameChanged, i, prevPhaseType));  
        prevPhaseType = phase;
        lastFrameChanged = i;
      }
    }

    // TODO: replace this with actually calculating
    // the phase of the last frame
    GaitPhase lastPhase = new GaitPhase(lastFrameChanged, totalFrames, GaitPhase.DOUBLE_SUPPORT);
    results.add(lastPhase);

    return results;
  }



  void draw() {
    if (comparisonMode) {
      strokeWeight(3);

      stroke(0, 255, 0);
      joints.get(3).drawPath();

      stroke(255, 0, 0);
      joints.get(9).drawPath();

      PVector lpos = joints.get(3).positionAtFrame(currentFrame);
      PVector rpos = joints.get(9).positionAtFrame(currentFrame);


      noStroke();
      pushMatrix();
      translate(lpos.x, lpos.y, lpos.z);
      fill(0, 255, 0);

      ellipse(0, 0, 0.08, 0.08);
      popMatrix();

      pushMatrix();
      translate(rpos.x, rpos.y, rpos.z);
      fill(255, 0, 0);
      ellipse(0, 0, 0.08, 0.08);
      popMatrix();
    }

    // CHANGE STROKE AND FILL SETTINGS HERE
    stroke(skeletonColor);
    fill(skeletonColor);
    strokeWeight(3);
    for (int i = 0; i < limbs.size(); i ++ ) {
      limbs.get(i).drawAtFrame(currentFrame);
    }
  }

  void nextFrame() {
    currentFrame++;
    if (currentFrame >= totalFrames) {
      currentFrame = 0;
    }
  }

  void parse(CSVMap csvMap) {
    // create one joint for each column set
    // (taking into account dimensionality)
    // then populate joint frames from row triplets/pairs

    // get column headers and create joints
    String[] columnHeaders = csvMap.getColumnHeaders();
    for (int i = csvMap.startColumn; i < columnHeaders.length; i += csvMap.dimensions) {
      joints.add(new Joint(columnHeaders[i]));
    }

    // load data into joints

    for (int i = csvMap.dataStartRow; i < csvMap.rows.length; i++ ) {
      String[] dataColumns = csvMap.getRow(i);
      totalFrames++;

      int currentJointIndex = 0;


      for (int j = csvMap.startColumn; j < dataColumns.length; j += csvMap.dimensions) {   

        float x = float(dataColumns[j]);
        float y = float(dataColumns[j+1]);
        float z = 0; // if we're in 2D, default z to 0

          if (csvMap.dimensions == 3) {
          z = float(dataColumns[j+2]);
        } 

        Joint currentJoint = joints.get(currentJointIndex);
        currentJoint.addFrame(new Frame(x, y, z));
        currentJointIndex++;
      }
    }
  }

  Recording clone() throws CloneNotSupportedException {
    return (Recording)super.clone();
  }
}

