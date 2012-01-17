class CSVMap{
  HashMap columnLabels;
  int labelRow;
  int dataStartRow;
  int startColumn;
  int dataStartColumn;
  int dimensions = 3; // default to 3D
  String[] rows;
  
  
  CSVMap(String pathToCSV){
    this.rows = loadStrings(pathToCSV);    
    columnLabels = new HashMap();

  }
  
   String[] getColumnHeaders(){
    return getRow(labelRow);
  }
  
  String[] getRow(int rowIndex){
    return rows[rowIndex].split(",");
  }
  
 
  
  String[] headerOptions(){
    String[] result = new String[7];
    
    for(int i=0; i < result.length; i++){
      result[i] = rows[i].split(",")[3];
    }
    
    return result;
  }
}
