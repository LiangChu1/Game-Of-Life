int blocksize = 10; //larger cells = 20; smaller cells = 5
int cols; //number of blocks
int rows;
boolean [][] currentgrid;
boolean [][] nextgrid;
int fps;
int stage;
int rotateValue;
boolean running;
boolean insertMode;
String [] keyButtons = {"r = Random Grid", "c = Clear Grid", "p = Pause/UnPause", "n = Next", "i = Insert Pattern", "e + Insert Pattern = rotate Pattern", "1-4 + Insert Pattern = different patterns"};
String [] patterns = {"010,001,111", "011,110,010", "0011100011100,0000000000000,1000010100001,1000010100001,1000010100001,0011100011100,0000000000000,0011100011100,1000010100001,1000010100001,1000010100001,0000000000000,0011100011100", "000000000000000000000000100000000000000,000000000000000000000010100000000000000,000000000000110000001100000000000011000,000000000001000100001100000000000011000,110000000010000010001100000000000000000,110000000010001011000010100000000000000,000000000010000010000000100000000000000,000000000001000100000000000000000000000,000000000000110000000000000000000000000"};
String pattern = patterns[0];




//rotates string shape clockwise
//Precondition: sahpe is a string with 1s and 0s separated by commas ','
//all substrings between commas are of equal length
String rotatePattern(String shape){
    String temp = "";
    String [] shaperow = split(shape,',');
    
    for(int c = 0; c < shaperow[0].length(); c++){
      for(int r = shaperow.length-1; r >= 0; r--){
         temp = temp + shaperow[r].charAt(c);
      }
      temp = temp + ',';
    }
    
    temp = temp.substring(0, temp.length()-1);
    System.out.println(temp);
    return temp;
}



//inserts the pattern(Global) of 1s and 0s in to the grid starting at block (x.y)
void addshape(String shape, int x, int y){
  String [] shaperow = split(shape,',');
  for(int i = 0; i < shaperow.length; i++){
    for(int j = 0; j < shaperow[0].length(); j++){
      if(shaperow[i].charAt(j) == '1'){
         currentgrid[x+j][y+i] = true; 
      }
      if(shaperow[i].charAt(j) == '0'){
         currentgrid[x+j][y+i] = false; 
      }
    }
  }
}

void clearGrid(boolean [][] currentgrid){
  for(int i = 0; i < cols; i++){
   for(int j = 0; j < rows; j++){
      currentgrid[i][j] = false;
   }
  }
}

void randomGrid(boolean [][] currentgrid){
  for(int i = 0; i < cols; i++){
   for(int j = 0; j < rows; j++){
      currentgrid[i][j] = Math.random() < .5;
   }
  }
}

int countliveneighbors(boolean[][] currentgrid, int x, int y){
 int sum = 0;
 int nbCol, nbRow;
  for(int i = -1; i < 2; i++){
   for(int j = -1; j < 2; j++){
     nbCol = (x+i+cols) % cols;
     nbRow = (y+j+rows) % rows;
     if(currentgrid[nbCol][nbRow] == true){
       sum++;
     }
  }
  }
  
  if(currentgrid[x][y])
    sum--;
  
  return sum;
}


boolean [][]getnextgen(boolean [][] currentgrid){
 boolean [][]tempGrid = new boolean [cols][rows];
 int nCount;
 for(int i = 0; i < cols; i++){
   for(int j = 0; j < rows; j++){
        nCount = countliveneighbors(currentgrid, i, j);
        if(currentgrid[i][j] && (nCount < 2 || nCount > 3)){
          tempGrid[i][j] = false;
        }
        else if(currentgrid[i][j] && nCount >= 2){
           tempGrid[i][j] = true; 
        }
        else if(!currentgrid[i][j] && nCount == 3){
            tempGrid[i][j] = true; 
        }
   }
 }
 
 return tempGrid;
}

void writeKeyMenu(){
    textSize(25);
    textAlign(LEFT);
    fill(255, 255, 255);
    text("Key Menu:", 50, 675, 1);
    textSize(15);
    text(keyButtons[0], 25, 720, 1);
    text(keyButtons[1], 165, 720, 1);
    text(keyButtons[2], 280, 720, 1);
    text(keyButtons[3], 440, 720, 1);
    text(keyButtons[4], 520, 720, 1);
    text(keyButtons[5], 665, 690, 1);
    text(keyButtons[6], 665, 740, 1);
}


void setup(){
  size(1000, 750);
  cols = width / blocksize;
  rows = (height / blocksize) - 10;
  background(0);
  currentgrid = new boolean [cols][rows];
  nextgrid = new boolean [cols][rows];
  stage = 1;
  fps = 24;
  rotateValue = 0;
  running = true;
  insertMode = false;
}


void draw(){
  frameRate(fps);
  
  if(stage == 1){
     textSize(50);
     textAlign(CENTER);
     text("The Game Of Life", 500, 375);
     textSize(25);
     text("Press ENTER to continue...", 500, 400);
     if(key == ENTER){
       stage += 1;
     }
  }
  
  if(stage == 2){
    for(int i = 0; i < cols; i++){
       for(int j = 0; j < rows; j++){
            
           int x = i * blocksize;
           int y = j * blocksize;
           
            if(currentgrid[i][j] == true){
              fill(0);
            }
            else{
             fill(255); 
            }
            
            rect(x,y,blocksize,blocksize);
       }
    }
    
    writeKeyMenu();
    
    if(running){
    nextgrid = getnextgen(currentgrid);
    currentgrid = nextgrid;
    }
    
    
    if(insertMode){
      textSize(30);
      textAlign(LEFT);
      fill(0,0,255);
      text("Insert Mode:" + rotateValue + "°", 25, 50);
    }
    
  }
  
}


void mousePressed(){
 
  int mx = mouseX / blocksize;
  int my = mouseY / blocksize;
  
  if(mouseX < 0 || mouseX >= width){
    mx = 0;
  }
  if(mouseY < 0 || mouseY >= (height-100)){
    my = 0;
  }
  
  if(mouseButton == LEFT){
    if(insertMode){
       addshape(pattern, mx, my); 
    }
    else
      currentgrid[mx][my] = true;
    
  }
  if(mouseButton == RIGHT){
    currentgrid[mx][my] = false;
  }
}



void mouseDragged(){
  int mx = mouseX / blocksize;
  int my = mouseY / blocksize;
  
  if(mouseX < 0 || mouseX >= width){
    mx = 0;
  }
  if(mouseY < 0 || mouseY >= (height-100)){
    my = 0;
  }
  
  if(mouseButton == LEFT && (!insertMode)){
    currentgrid[mx][my] = true;
    
  }
  if(mouseButton == RIGHT){
    currentgrid[mx][my] = false;
    
  }
}



void keyPressed(){
  
 if(key == 'p'){
    String temp;
    running = !running;
    
    textSize(50);
    textAlign(CENTER);
    fill(0,0,255);
    if(!running){
       temp = "pause";
    }
    else{
       temp = "unpause"; 
    }
    text(temp, 500, 375);
 }
 
 if(key == 'c'){
    clearGrid(currentgrid); 
 }
 
 if(key == 'r'){
    randomGrid(currentgrid); 
 }
 
 if(key == 'n'){
    running = true;
    draw();
    running = false;
 }
 
 if(key == 'i'){
   insertMode = !insertMode;
 }
 if(key == 'e' && insertMode){
      pattern = rotatePattern(pattern);
      rotateValue += 90;
      if(rotateValue == 360){
         rotateValue = 0;
      }
  }
  
  if((key == '1' || key == '2' || key == '3' || key == '4') && insertMode){ 
    int index = key - 49;
    pattern = patterns[index];
  }
}
