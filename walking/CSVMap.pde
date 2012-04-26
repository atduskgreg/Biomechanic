class CSVMap {
  HashMap columnLabels;
  int labelRow;
  int dataStartRow;
  int startColumn;
  int dimensions = 3; // default to 3D
  String[] rows;
  String pathToCSV;
  String upAxis;

  CSVMap(String pathToCSV) {
    this.pathToCSV = pathToCSV;
    this.rows = loadStrings(pathToCSV);    
    columnLabels = new HashMap();

    String[] filenameParts = split(pathToCSV, '.');
    String configFilename = filenameParts[0] + "." + "bio";
    CSVConfig config = new CSVConfig(configFilename);
    this.labelRow = config.labelRow;
    this.dataStartRow = config.dataStartRow;
    this.startColumn = config.startColumn;
    this.upAxis = config.upAxis;
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
  String upAxis; // "x", "y", or "z"

  CSVConfig(String pathToConfig) {
    String[] configLines = loadStrings(pathToConfig);
    for (int i = 0; i < configLines.length; i++) {
      String l = configLines[i];
      String[] parts = split(l, ',');
      if (parts[0].equals("startColumn")) {
        this.startColumn = int(parts[1]);
      }

      if (parts[0].equals("labelRow")) {
        this.labelRow = int(parts[1]);
      }

      if (parts[0].equals("dataStartRow")) {
        this.dataStartRow = int(parts[1]);
      }
      
      if (parts[0].equals("upAxis")) {
        this.upAxis = parts[1];
      }
    }
  }
}

class LimbConfig {
  int[][] jointPairs;
  
   LimbConfig(String pathToCSV) {
    String[] filenameParts = split(pathToCSV, '.');
    String pathToConfig = filenameParts[0] + "." + "limbs";
    println(pathToConfig);
    
    String[] configLines = loadStrings(pathToConfig);
    jointPairs = new int[configLines.length][2];
    
    for (int i = 0; i < configLines.length; i++) {
      String l = configLines[i];
      String[] parts = split(l, ',');
      jointPairs[i][0] = int(parts[0]);
      jointPairs[i][1] = int(parts[1]);
    }
  }

 
}

