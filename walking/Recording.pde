class Recording {
  CSVMap csvMap;
  ArrayList<Joint> joints;
  int totalFrames;
  ArrayList<Limb> limbs;

  int currentFrame = 0;

  Recording(CSVMap csvMap) {
    joints = new ArrayList();
    limbs = new ArrayList();
    parse(csvMap);
    configureLimbs();
  }

  void configureLimbs() {
    limbs.add(new Limb(this, 2, 0));
    limbs.add(new Limb(this, 0, 1));
    limbs.add(new Limb(this, 1, 7));
    limbs.add(new Limb(this, 1, 11));
    limbs.add(new Limb(this, 5, 11));
    limbs.add(new Limb(this, 5, 4));
    limbs.add(new Limb(this, 4, 3));
    limbs.add(new Limb(this, 7, 5));
    limbs.add(new Limb(this, 7, 6));
    limbs.add(new Limb(this, 6, 8));
    limbs.add(new Limb(this, 11, 10));
    limbs.add(new Limb(this, 10, 9));
  }

  void draw() {
    noStroke();
    fill(254);
    beginShape(QUADS);
    vertex(-1.25,-0.5,0);
    vertex(-1.25,0.5,0);
    vertex(3.25,0.5,0);
    vertex(3.25,-0.5,0);
    endShape();
    
    
    stroke(0);
    strokeWeight(2);
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


      for (int j = csvMap.dataStartColumn; j < dataColumns.length; j += csvMap.dimensions) {   

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
}

