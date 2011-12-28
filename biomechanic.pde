import javax.swing.JFileChooser;

ArrayList<LegFrame> frames;


boolean loaded = false;

JFileChooser chooser = new JFileChooser();

int currentFrame = 0;

boolean drawText = true;

void setup() {

  size(800, 400);
  frameRate(70);
  frames = new ArrayList();
  smooth();
  
  textFont(loadFont("Dialog-10.vlw"));
}

void draw() {
  background(255);
  fill(0);
  //textSize(10);
  text("frameRate: " + int(frameRate), 5, 10);
  if (loaded) {
    translate(width - 50, height - 50);
    rotate(radians(180));
    scale(2);
    frames.get(currentFrame).draw();
    currentFrame++;
    if (currentFrame >= frames.size()) {
      currentFrame = 0;
    }
  }
}

void mousePressed(){
  drawText = !drawText;
}


void keyReleased() {
  if (!loaded) {

    chooser.setFileFilter(chooser.getAcceptAllFileFilter());
    int returnVal = chooser.showOpenDialog(null);
    if (returnVal == JFileChooser.APPROVE_OPTION) {
      println(chooser.getSelectedFile().getAbsolutePath());
      
      String[] rows = loadStrings(chooser.getSelectedFile().getAbsolutePath());
      for (int i = 2; i < rows.length; i++) {
        frames.add(new LegFrame(rows[i]));
      }

      loaded = true;
    }
  }
}

