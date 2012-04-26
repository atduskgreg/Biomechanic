class CSVMap {
  HashMap columnLabels;
  int labelRow;
  int dataStartRow;
  int startColumn;
  int dimensions = 3; // default to 3D
  String[] rows;


  CSVMap(String pathToCSV) {
    this.rows = loadStrings(pathToCSV);    
    columnLabels = new HashMap();
    
    String[] filenameParts = split(pathToCSV, '.');
    String configFilename = filenameParts[0] + "." + "bio";
    println(configFilename);
    CSVConfig config = new CSVConfig(configFilename);
    this.labelRow = config.labelRow;
    this.dataStartRow = config.dataStartRow;
    this.startColumn = config.startColumn;
    
  }

  String[] getColumnHeaders() {
    return getRow(labelRow);
  }

  String[] getRow(int rowIndex) {
    return rows[rowIndex].split(",");
  }



  String[] headerOptions() {
    String[] result = new String[7];

    for (int i=0; i < result.length; i++) {
      result[i] = rows[i].split(",")[3];
    }

    return result;
  }
}

class CSVConfig {
  int startColumn;
  int labelRow;
  int dataStartRow;
  
  
  CSVConfig(String pathToConfig) {
    String[] configLines = loadStrings(pathToConfig);
    for (int i = 0; i < configLines.length; i++) {
      String l = configLines[i];
      String[] parts = split(l, ',');
      if(parts[0].equals("startColumn")){
        this.startColumn = int(parts[1]);
      
      }
      
      if(parts[0].equals("labelRow")){
        this.labelRow = int(parts[1]);
      }
      
      if(parts[0].equals("dataStartRow")){
        this.dataStartRow = int(parts[1]);
      }
    }
  }
}

