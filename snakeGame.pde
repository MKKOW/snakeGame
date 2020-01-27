import java.util.Random;
import cc.arduino.*;
import processing.serial.*;
Arduino arduino=null;
Random rand=new Random();
static int cellSize=cell.getCellSize();
int[] Direction;
int Delay=20;
int Width=displayWidth;
int Height=displayHeight;
snake[] s;
Food[] food;
int state=-1;
String buffer="";
int n=0;
int isArduino=0;
PFont displayFont;
int foodCount;
int ButtonDelay=0;
int COMport=0;
void drawCell(cell c){
  fill(c.getRed(),c.getGreen(),c.getBlue());
  rect(c.getX(),c.getY(),cellSize,cellSize);
}
void drawSnake(snake s){
  for(cell tmp : s.getBody()){
    drawCell(tmp);
  }
}
void checkSnake(snake s){
    for(cell tmp : s.getBody()){
          if(tmp.getX()<0||tmp.getX()>Width){
                tmp.setX(abs(tmp.getX()-Width));
          }
          if(tmp.getY()<0||tmp.getY()>Height){
                tmp.setY(abs(tmp.getY()-Height));
          }
    }
}
void readN(){
    background(0);
    if(n!=0)
        return;
    else{
    //textFont(displayFont);
    textSize(32);
    fill(255,255,255);
    int tmp=0;
    if(buffer!=""){
      tmp=Integer.parseInt(buffer);
    }
    text("How many snakes would you like to play with ?\n"+(tmp!=0?buffer:""),100,100);
    return;
    }
}
int getColor(int i,int c){
    int[] red={255,255,0,255};
    int[] green={0,10,0,255};
    int[] blue={0,100,255,0};
    switch(c){
        case 1:
              return red[i];
        case 2:
              return green[i];
        case 3:
              return blue[i];
        default:
              return 255;
    }
}
void setup(){
    fullScreen();
    displayFont=createFont("DSEG7Classic-Regular.ttf",20);
    Height=displayHeight;
    Width=displayWidth;
    foodCount=64;
    food=new Food[foodCount];
    for(int i=0; i<foodCount;i++)
        food[i]=new Food(rand.nextInt(Width-10),rand.nextInt(Height-10));
    n=4;
    makeSnakes();   

}
void setupArduino(){
    if(arduino==null){
    arduino = new Arduino(this, Arduino.list()[COMport], 57600);
    for (int i = 0; i <= 13; i++)
        arduino.pinMode(i, Arduino.INPUT);
    }
}
void makeSnakes(){
  s=new snake[n];
    Direction=new int[n];
    int[] scoreX={100,Width-100,100,Width-100};
    int[] scoreY={100,100,Height-100,Height-100};
    for(int i=0;i<n;i++){
      s[i]=new snake(getColor(i,1),getColor(i,2),getColor(i,3),scoreX[i],scoreY[i]);
      Direction[i]=1;
    }
}
void runGame(){
  delay(Delay);
      background(0);
      textFont(displayFont);
      textSize(32);
      for(cell f:food)
          drawCell(f);
      for(snake currentSnake:s){
          drawSnake(currentSnake);
          fill(currentSnake.getRed(),currentSnake.getGreen(),currentSnake.getBlue());
          text(Integer.toString(currentSnake.getSize()),currentSnake.getScoreX(),currentSnake.getScoreY());
      }
      int i=0;
      for(snake currentSnake:s){
          cell Head=currentSnake.getHead();
          for(Food f:food){
            if(cell.checkCollision(Head,f)){
                currentSnake.grow(f);
                f.reset(rand.nextInt(Width-10),rand.nextInt(Height-10));
            }
          }
          for(snake otherSnake:s){
              snake.checkCollision(currentSnake,otherSnake);
          }
          currentSnake.move(Direction[i]);
          checkSnake(currentSnake);
          i++;
      }
      if(arduino!=null){
      int offset=160;
      if(arduino.digitalRead(2)==Arduino.HIGH&&ButtonDelay<=0)
      {
        if(Direction[0]==1){
              Direction[0]=4;
        }
        else if(Direction[0]==2){
              Direction[0]=3;
        }
        else if(Direction[0]==3){
              Direction[0]=1;
        }
        else if(Direction[0]==4){
              Direction[0]=2;
        }
        ButtonDelay=offset;
        
      }
      if(arduino.digitalRead(4)==Arduino.HIGH&&ButtonDelay<=0)
      {
        if(Direction[0]==1){
              Direction[0]=3;
        }
        else if(Direction[0]==2){
              Direction[0]=4;
        }
        else if(Direction[0]==3){
              Direction[0]=2;
        }
        else if(Direction[0]==4){
              Direction[0]=1;
        }
        ButtonDelay=offset;
        
      }
  if(ButtonDelay!=0){
        if(Delay!=0)
            ButtonDelay-=Delay;
        else
            ButtonDelay-=10;
  }
  }
}
void readArduino(){
    background(0);
    //textFont(displayFont);
    textSize(32);
    fill(255,255,255);
    int tmp=-1;
    if(buffer!=""){
      tmp=Integer.parseInt(buffer);
    }
    text("Is player 1 playing on Arduino ?(1-YES,0-NO)\n"+(tmp!=-1?buffer:""),100,100);

}
void readCOMPort(){
  background(0);
    //textFont(displayFont);
    textSize(32);
    fill(255,255,255);
    int tmp=-1;
    if(buffer!=""){
      tmp=Integer.parseInt(buffer);
    }
    String disText="Select COM port to which arduino is connected:\n";
    int i=0;
    for(String b:Arduino.list()){
        disText+=String.valueOf(i);
        disText+=" - ";
        disText+=b;
        disText+="\n";
        i++;
    }
    text(disText+"\n"+(tmp!=-1?buffer:""),100,100);
}
void titleScreen(){
      runGame();
      int offset=160;
     if(ButtonDelay<=0){
      for(int i=0;i<n;i++){
          Direction[i]=rand.nextInt(3)+1;
      }
      ButtonDelay=offset;
      }
      if(ButtonDelay!=0){
        if(Delay!=0)
            ButtonDelay-=Delay;
        else
            ButtonDelay-=10;
    }
    PFont titleFont=createFont("DSEG7Classic-Regular.ttf",200);
      
      textSize(100);
      textFont(titleFont);
      fill(255,255,255);
      textAlign(CENTER,CENTER);
      text("5na4e",Width/2,Height/2-100);
      textFont(createFont(PFont.list()[0],50));
      text("A Multiplayer Snake Game by M. Kowalski\nPress ENTER to continue",Width/2,Height/2+100);
      textAlign(LEFT,BOTTOM);
      textFont(createFont(PFont.list()[0],20));
}
void draw(){
  switch(state){
      case -1:
        titleScreen();
        break;
      case 0:
        readN();
        break;
      case 1:
        readArduino();
        break;
      case 2:
      if(isArduino==0){
      state++;
      }else{
         readCOMPort();
      }
      break;
      default:
        runGame();
        break;
  }
      
}
void keyPressed(){
        
        switch(state){
        case -1:
              if (key==ENTER||key==RETURN){
                   state++;
                   for(int i=0;i<n;i++)
                       s[i]=null;
                   s=null;
                   n=0;
                   delay(1000);
              }
              break;
        case 0:
             if (buffer!=""&&(key==ENTER||key==RETURN)){
                   state++;
                   n=Integer.parseInt(buffer);
                   buffer="";
                   makeSnakes();
             }else if(key==DELETE||key==BACKSPACE){
               buffer="";
             }
             else{
                 if(key=='1'||key=='2'||key=='3'||key=='4'){
                   buffer=String.valueOf(key);
                 }
             }
             break;
        case 1:
              if (buffer!=""&&(key==ENTER||key==RETURN)){
                   state++;
                   isArduino=Integer.parseInt(buffer);
                   buffer="";
             }else if(key==DELETE||key==BACKSPACE){
               buffer="";
             }
             else{
                 if(key=='1'||key=='0'){
                   buffer=String.valueOf(key);
                 }
             }
             break;
        case 2:
        if(isArduino==0){
          state++;
        }
        else{
        if (buffer!=""&&(key==ENTER||key==RETURN)){
                   state++;
                   COMport=Integer.parseInt(buffer);
                   buffer="";
                   setupArduino();
             }else if(key==DELETE||key==BACKSPACE){
               buffer="";
             }
             else{
                 if(key=='1'||key=='0'||key=='2'||key=='3'||key=='4'||key=='5'||key=='6'||key=='7'||key=='8'||key=='9'){
                   buffer=String.valueOf(key);
                 }
             }
        }
             break;
        default:
        if(n>0){
         if(key=='w'&&Direction[0]!=1){
            Direction[0]=2;
            System.out.println("UP");
        }
        if(key=='s'&&Direction[0]!=2){
            Direction[0]=1;
            System.out.println("DOWN");
        }
       if(key=='d'&&Direction[0]!=4){
            Direction[0]=3;
            System.out.println("RIGHT");
        }
        if(key=='a'&&Direction[0]!=3){
            Direction[0]=4;
            System.out.println("LEFT");
        }
        }
        if(n>2){
        if(key=='y'&&Direction[2]!=1){
            Direction[2]=2;
            System.out.println("UP");
        }
        if(key=='h'&&Direction[2]!=2){
            Direction[2]=1;
            System.out.println("DOWN");
        }
       if(key=='j'&&Direction[2]!=4){
            Direction[2]=3;
            System.out.println("RIGHT");
        }
        if(key=='g'&&Direction[2]!=3){
            Direction[2]=4;
            System.out.println("LEFT");
        }
        }
        if(n>3){
        if(key=='o'&&Direction[3]!=1){
            Direction[3]=2;
            System.out.println("UP");
        }
        if(key=='l'&&Direction[3]!=2){
            Direction[3]=1;
            System.out.println("DOWN");
        }
       if(key==';'&&Direction[3]!=4){
            Direction[3]=3;
            System.out.println("RIGHT");
        }
        if(key=='k'&&Direction[3]!=3){
            Direction[3]=4;
            System.out.println("LEFT");
        }
        }
                if(n>1){
        if(keyCode==UP&&Direction[1]!=1){
            Direction[1]=2;
            System.out.println("UP");
        }
        if(keyCode==DOWN&&Direction[1]!=2){
            Direction[1]=1;
            System.out.println("DOWN");
        }
       if(keyCode==RIGHT&&Direction[1]!=4){
            Direction[1]=3;
            System.out.println("RIGHT");
        }
        if(keyCode==LEFT&&Direction[1]!=3){
            Direction[1]=4;
            System.out.println("LEFT");
        }
        }
        break;
       }
}
