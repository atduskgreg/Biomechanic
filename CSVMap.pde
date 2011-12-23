class CSVMap{
  HashMap columnLabels;
  int labelRow;
  int dataStartRow;
  int dataStartColumn;
  int dimenions = 3;
  String[] rows;
  
  CSVMap(String pathToCSV){
    this.rows = loadStrings(pathToCSV);    
    columnLabels = new HashMap();
  }
  
  String[] headerOptions(){
    String[] result = new String[7];
    
    for(int i=0; i < result.length; i++){
      result[i] = rows[i].split(",")[3];
    }
    
    return result;
  }
}
