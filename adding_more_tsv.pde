/*from Visualizing Data by Ben Fry*/


// introduce table data and objects
FloatTable data;
float dataMin, dataMax;

// plot=location??
float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

//global variables
int rowCount;
int columnCount;
int currentColumn = 0;

int yearMin, yearMax;
int[] years;

int yearInterval = 10; //create spacing between year range
int volumeInterval = 10;
int volumeIntervalMinor = 5;

// define table properties

float[] tabLeft, tabRight;
float tabTop, tabBottom;
float tabPad = 10;

//call tintegrator class
Integrator[] interpolators;

PFont plotFont;

void setup() {
  size(720, 405);
  data = new FloatTable("milk-tea-coffee.tsv");
  rowCount = data.getRowCount();
  columnCount = data.getColumnCount();
//assign table to objects
  //assign years to table

  years = int(data.getRowNames());
  yearMin = years[0];
  yearMax = years[years.length-1];
  //set years to zero for lowest number
  
  dataMin = 0;
  dataMax = ceil(data.getTableMax() / volumeInterval) * volumeInterval;
// limit numbers from floattable.tsv and store values in varables
  interpolators = new Integrator[rowCount];
  for (int row = 0; row<rowCount; row++) {
    float initialValue = data.getFloat(row, 0);
    interpolators[row] = new Integrator(initialValue);
    interpolators[row].attraction = .1;
    //counts number of rows and assigns varables to those rows
  }
// assign location to varables, plotting the location of the box
  plotX1 = 120;
  plotX2 = width-80;
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY = height-25;
//assiging the font and text size
  plotFont = createFont("SansSerif",20);
  textFont(plotFont);
//makes font more clear
  smooth();
}
// draw the background color and size
void draw() {
  background(225);
  //show the plot area as white box
  fill(203,233,240);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2); //draw the graph call the coordinants from the table

  drawTitleTabs(); //create labels for tabs 
  drawAxisLabels();

  for (int row = 0; row<rowCount; row++) {
    interpolators[row].update();
  }

  drawYearLabels(); // create labels for x y axisis
  drawVolumeLabels(); //creates tag to add value for grap

  noStroke();
  fill(#FFB3B3);
  drawDataArea(currentColumn);
}
//write title tabs, format text
void drawTitleTabs() {
  rectMode(CORNERS);
  noStroke();
  textSize(20);
  textAlign(LEFT);
  //onthe first use of this method allocate space for an array
  //to store the values for the left and right edges of the tabs
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];
  }
    //draw background box around title tabs
  float runningX = plotX1;
  tabTop = plotY1 - textAscent() - 15;
  tabBottom = plotY1;

  for (int col = 0; col<columnCount; col++) {
    String title = data.getColumnName(col);
    tabLeft[col] = runningX;
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad +titleWidth + tabPad;

    // if the current tab sets its bg white, otherwise use grey
    fill(col ==currentColumn ? 255:224);
    rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
    //if the current tab, use black for the text, otherwise grey
    fill(col == currentColumn?0:64);
    text(title, runningX+tabPad, plotY1-10);
    runningX = tabRight[col];
  }
}
//when mouse is pressed make box white and go to next tab
void mousePressed() {
  if (mouseY>tabTop && mouseY<tabBottom) {
    for (int col = 0; col<columnCount; col++) {
      if (mouseX>tabLeft[col] && mouseX<tabRight[col]) {
        setColumn(col);
      }
    }
  }
}
// create column varable 
void setColumn(int col) {
  currentColumn = col;
  for (int row = 0; row<rowCount; row++) {
    interpolators[row].target(data.getFloat(row, col));
  }
}
// writing text for collumn and formatting text
void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);

  textAlign(CENTER, CENTER);
  text("Quantity\nconsumed", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Year", (plotX1+plotX2)/2, labelY);
}

void drawYearLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER);

  //grid
  stroke(224);
  strokeWeight(1);

  for (int row = 0; row<rowCount; row++) {
    if (years[row]% yearInterval ==0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      text(years[row],x, plotY2+textAscent()+10);
      line(x, plotY1, x, plotY2);
    }
  }
}

void drawVolumeLabels() {
  fill(0);
  textSize(10);
  textAlign(RIGHT);

  stroke(128);
  strokeWeight(1);

  for (float v = dataMin; v<dataMax; v+= volumeIntervalMinor) {
    if (v%volumeIntervalMinor ==0) {
      float y = map(v, dataMin, dataMax, plotY2, plotY1);
      if (v%volumeInterval == 0) {
        float textOffset = textAscent()/2;
        if (v == dataMin) {
          textOffset = 0;
        } else if (v == dataMax) {
          textOffset = textAscent();
        }
        text(floor(v), plotX1-10, y+textOffset);
        line(plotX1-4, y, plotX1, y);
      } else {
        //line...
      }
    }
  }
}
//collecting and plotting data from year row and category 
void drawDataArea(int col) {
  beginShape();
  for (int row=0; row<rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = interpolators[row].value;
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2); // initial value is the yearMin and yearMax, plot data from year row table on x axis
      float y = map(value, dataMin, dataMax, plotY2, plotY1); // inital value is the data max and dataMin, plot data from Milk,Tea,Coffee and juice rows on y axis
      vertex(x, y);
    }
  }
  vertex(plotX2, plotY2);
  vertex(plotX1, plotY2);
  endShape(CLOSE);
}