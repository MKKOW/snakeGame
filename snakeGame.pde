import java.util.List;
import java.util.ArrayList;
import java.util.Random;
import processing.serial.*;
//import cc.arduino.*;
//Arduino arduino=null;
static int cellSize=50;
Random rand=new Random();
int[] Direction;
int Delay=20;
int Width=displayWidth;
int Height=displayHeight;
snake[] s;
cell[] food;
int state=0;
String buffer="";
int n=0;
int isArduino=0;
PFont displayFont;
int foodCount;
static class cell{
    private int x;
    private int y; 
    private int direction;//N-1,S-2,E-3,W-4
    private int red;
    private int green;
    private int blue;
    public cell(int X,int Y,int D,int Red,int Green,int Blue){
        x=X;
        y=Y;
        direction=D;
        red=Red;
        green=Green;
        blue=Blue;
    }
    public int move(int nextDirection){
         if(nextDirection==1){
              
                   y+=cellSize;
         }
         if(nextDirection==2){
           
              y-=cellSize;
         }
         if(nextDirection==3){
           
               x+=cellSize;
         }
         if(nextDirection==4){
               
                 x-=cellSize;
         }
        int tmp=direction;
        direction=nextDirection;
        return tmp;
    }
    public int getRed(){
          return red;
    }
    public int getGreen(){
          return green;
    }
    public int getBlue(){
          return blue;
    }
    public int getX(){
        return x;
    }
     public int getY(){
        return y;
    }
     public int getDirection(){
        return direction;
    }
    public void setX(int X){
          x=X;
    }
    public void setY(int Y){
          y=Y;
    }
    static public boolean checkCollision(cell A, cell B){
      if(A==B)
            return false;
      if(A.getX()>B.getX()&&A.getX()<B.getX()+cellSize&&A.getY()>B.getY()&&A.getY()<B.getY()+cellSize)
            return true;
      if(B.getX()>A.getX()&&B.getX()<A.getX()+cellSize&&B.getY()>A.getY()&&B.getY()<A.getY()+cellSize)
            return true;
      return false;
}
}

class snake{
    private List<cell> body = new ArrayList<cell>();
    private int size;
    private int red,green,blue;
    private int ScoreX,ScoreY;
    public snake(int r,int g,int b,int scoreX,int scoreY){
      size=1;
      red=r;
      green=g;
      blue=b;
      ScoreX=scoreX;
      ScoreY=scoreY;
      cell tmp=new cell(rand.nextInt(900),rand.nextInt(900),1,r,g,b);
      body.add(tmp);
    }
    public snake(snake A){
      size=1;
      red=A.getRed();
      green=A.getGreen();
      blue=A.getBlue();
      ScoreX=A.getScoreX();
      ScoreY=A.getScoreY();
      cell tmp=new cell(rand.nextInt(900),rand.nextInt(900),1,red,green,blue);
      body.add(tmp);
    }
    public void move(int direction){
         int nextDirection=direction;
         for(cell tmp:body){
               nextDirection=tmp.move(nextDirection);
         }
        // System.out.println(body.get(0).getX());
        // System.out.println(body.get(0).getY());
    }
    public void grow(){
        cell New=new cell(body.get(size-1).getX(),body.get(size-1).getY(),body.get(size-1).getDirection(),red,green,blue);
        move(body.get(0).getDirection());
        body.add(New);
        size++;
    }
    public List<cell> getBody(){
        return body;
    }
    public int getSize(){
          return size;
    }
    public cell getHead(){
          return body.get(0);
    }
    public int getRed(){
          return red;
    }
    public int getGreen(){
          return green;
    }
    public int getBlue(){
          return blue;
    }
    public int getScoreX(){
          return ScoreX;
    }
    public int getScoreY(){
          return ScoreY;
    }
    public void reset(){
      size=1;
      body.clear();
      cell tmp=new cell(rand.nextInt(900),rand.nextInt(900),1,red,green,blue);
      body.add(tmp);
    }
    void checkCollision(snake B){
    if(this==B){
        for(cell tmp:body){
                if(tmp!=body.get(0)&&tmp!=body.get(1)&&cell.checkCollision(body.get(0),tmp)){
                      this.reset();
                      return;
                }
        }
    }
    cell HeadA=this.getHead();
    cell HeadB=B.getHead();
    if(cell.checkCollision(HeadA,HeadB)){
          this.reset();
          B.reset();
      }else{
        for(cell tmp:B.getBody()){
            if(cell.checkCollision(HeadA,tmp)){
                this.reset();
                return;
            }
        }
        for(cell tmp:this.getBody()){
            if(cell.checkCollision(HeadB,tmp)){
                B.reset();
                return;
            }
        }
  }
}
}
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
boolean checkCollision(cell A, cell B){
      if(A==B)
            return false;
      if(A.getX()>=B.getX()&&A.getX()<=B.getX()+cellSize&&A.getY()>=B.getY()&&A.getY()<=B.getY()+cellSize)
            return true;
      if(B.getX()>=A.getX()&&B.getX()<=A.getX()+cellSize&&B.getY()>=A.getY()&&B.getY()<=A.getY()+cellSize)
            return true;
      return false;
}
void checkCollision(snake A,snake B){
  if(A==B)
      return;
  cell HeadA=A.getHead();
  cell HeadB=B.getHead();
  if(checkCollision(HeadA,HeadB)){
        A=new snake(A);
        B=new snake(B);
  }else{
        for(cell tmp:B.getBody()){
            if(checkCollision(HeadA,tmp)){
                A=new snake(A);
                return;
            }
        }
        for(cell tmp:A.getBody()){
            if(checkCollision(HeadB,tmp)){
                B=new snake(B);
                return;
            }
        }
  }
}
boolean checkCollision(snake A,cell B){
    cell Head=A.getBody().get(0);
    return checkCollision(Head,B);
}
boolean checkCollision(cell A,snake B){
    return checkCollision(B,A); 
}
boolean readN(){
    background(0);
    if(n!=0)
        return false;
    else{
    textFont(displayFont);
    textSize(32);
    fill(255,255,255);
    text("How many snakes would you like to play with ?\n"+(n!=0?String.valueOf(n):""),100,100);
    return true;
    }
}
int getColor(int i,int c){
    int[] red={255,255,255,255};
    int[] green={0,10,255,255};
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
    boolean loop=true;
    //while(loop){
    //loop=readN();
    //}
    n=2;
    s=new snake[n];
    Direction=new int[n];
    int[] scoreX={100,Width-100,100,Width-100};
    int[] scoreY={100,100,Height-100,Height-100};
    for(int i=0;i<n;i++){
      s[i]=new snake(getColor(i,1),getColor(i,2),getColor(i,3),scoreX[i],scoreY[i]);
      Direction[i]=1;
    }
    foodCount=100;
    food=new cell[foodCount];
    for(int i=0; i<foodCount;i++)
        food[i]=new cell(rand.nextInt(Width-10),rand.nextInt(Height-10),0,0,255,0);
    /*if(arduino==null){
    arduino = new Arduino(this, Arduino.list()[1], 57600);
    for (int i = 0; i <= 13; i++)
        arduino.pinMode(i, Arduino.INPUT);
    }
    */
}
void draw(){
  /*if(arduino.digitalRead(2)==Arduino.HIGH&&ButtonDelay<=0)
      {
        if(Direction1==1){
              Direction1=4;
        }
        else if(Direction1==2){
              Direction1=3;
        }
        else if(Direction1==3){
              Direction1=1;
        }
        else if(Direction1==4){
              Direction1=2;
        }
        ButtonDelay=80;
        
      }
      if(arduino.digitalRead(4)==Arduino.HIGH&&ButtonDelay<=0)
      {
        if(Direction1==1){
              Direction1=3;
        }
        else if(Direction1==2){
              Direction1=4;
        }
        else if(Direction1==3){
              Direction1=2;
        }
        else if(Direction1==4){
              Direction1=1;
        }
        ButtonDelay=80;
        
      }
  if(ButtonDelay!=0){
        if(Delay!=0)
            ButtonDelay-=Delay;
        else
            ButtonDelay-=10;
  }*/
  delay(10);
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
  for(int i=0;i<n;i++){
      s[i].move(Direction[i]);
      checkSnake(s[i]);
      for(int j=0;j<foodCount;j++){
          if(checkCollision(food[j],s[i])){
                s[i].grow();
                food[j]=new cell(rand.nextInt(Width-10),rand.nextInt(Height-10),0,0,255,0);
          }
      }
      for(int k=0;k<n ;k++){
          s[i].checkCollision(s[k]);
      }
  }
}
void keyPressed(){
        
        switch(state){
        case 0:
             if (key==ENTER||key==RETURN){
                   state++;
                   n=Integer.parseInt(buffer);
                   buffer="";
             }else if(key==DELETE||key==BACKSPACE){
               buffer="";
             }
             else{
                 if(key=='1'||key=='2'||key=='3'||key=='4'){
                   buffer=String.valueOf(key);
                 }
             }
        case 1:
              if (key==ENTER||key==RETURN){
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
        case 2:
            if(isArduino==0){
                  state++;
            }
        default:
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
}
