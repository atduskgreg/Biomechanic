class GaitPhase {
  int beginningFrame;
  int endingFrame;
  int type;
  
  static final int SINGLE_SUPPORT_LEFT = 0;
  static final int SINGLE_SUPPORT_RIGHT = 1;
  static final int DOUBLE_SUPPORT = 2;
  
  
  
  GaitPhase(int beginningFrame, int type){
    this.beginningFrame = beginningFrame;
    this.type = type;
  }
  
  
}
