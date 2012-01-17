import javax.swing.JFileChooser;

JFileChooser chooser = new JFileChooser();
/*
ArrayList<BodyFrame> frames;
int currentFrame = 0;
boolean loaded = false;
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
*/

Recording recording;


import controlP5.*;

ControlP5 controlP5;
Radio titleSelector;
Radio dataSelector;

CSVMap csvMap;
boolean loaded = false;

void setup(){
  size(1000, 600);
  controlP5 = new ControlP5(this);
  titleSelector = controlP5.addRadio("titleRowChosen",100,160);
  titleSelector.deactivateAll();
  
  dataSelector = controlP5.addRadio("dataRowChosen",500,160);
  dataSelector.deactivateAll();
  
  controlP5.addButton("Load",0,100,100,80,19);

}

void draw(){
  if(loaded){}
}

void dataRowChosen(int chosen){
  println("csvMap.dataStartRow = " + chosen);
  csvMap.dataStartRow = chosen;
}

void titleRowChosen(int chosen){
  println("csvMap.labelRow = " + chosen);
  csvMap.labelRow = chosen;
}

void Load(int theValue){
  println("saving");
}

void keyReleased() {
  if (!loaded) {

    chooser.setFileFilter(chooser.getAcceptAllFileFilter());
    int returnVal = chooser.showOpenDialog(null);
    if (returnVal == JFileChooser.APPROVE_OPTION) {
      println("got file");
      csvMap = new CSVMap(chooser.getSelectedFile().getAbsolutePath());
      String[] options = csvMap.headerOptions();
      for(int i =0; i< options.length; i++){
        titleSelector.add(options[i], i);
        dataSelector.add(options[i], i); 
      }
      
      loaded = true;
    }
  }
}

