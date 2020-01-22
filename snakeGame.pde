import java.util.List;
import java.util.ArrayList;
import java.util.Random;
import processing.serial.*;
import cc.arduino.*;
Arduino arduino=null;
static int cellSize=10;
Random rand=new Random();
int Direction1=1,Direction2=1;
int ButtonDelay=0;
int Width=displayWidth;
int Height=displayHeight;
snake s1,s2;
cell[] food;
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
    public int move(int nextDirection,int speed){
         if(nextDirection==1){
              
                   y+=10;
         }
         if(nextDirection==2){
           
              y-=10;
         }
         if(nextDirection==3){
           
               x+=10;
         }
         if(nextDirection==4){
               
                 x-=10;
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
}

class snake{
    private List<cell> body = new ArrayList<cell>();
    private int size;
    private int red,green,blue;
    public snake(int r,int g,int b){
      size=1;
      red=r;
      green=g;
      blue=b;
      cell tmp=new cell(rand.nextInt(900),rand.nextInt(900),1,r,g,b);
      body.add(tmp);
    }
    public snake move(int direction,int speed){
         int nextDirection=direction;
         for(cell tmp:body){
               nextDirection=tmp.move(nextDirection,speed);
         }
        // System.out.println(body.get(0).getX());
        // System.out.println(body.get(0).getY());
         return this;
    }
    public void grow(){
        cell New=new cell(body.get(size-1).getX(),body.get(size-1).getY(),body.get(size-1).getDirection(),red,green,blue);
        move(body.get(0).getDirection(),10);
        body.add(New);
        size++;
    }
    public List<cell> getBody(){
        return body;
    }
    public int getSize(){
          return size;
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
      if(A.getX()>=B.getX()&&A.getX()<=B.getX()+cellSize&&A.getY()>=B.getY()&&A.getY()<=B.getY()+cellSize)
            return true;
      if(B.getX()>=A.getX()&&B.getX()<=A.getX()+cellSize&&B.getY()>=A.getY()&&B.getY()<=A.getY()+cellSize)
            return true;
      return false;
}
void setup(){
    fullScreen();
    //size(displayWidth,displayHeight);
    s1=new snake(255,0,0);
    s2=new snake(0,0,255);
    Height=displayHeight;
    Width=displayWidth;
    System.out.println(Height);
    System.out.println(Width);
    food=new cell[4];
    for(int i=0; i<4;i++)
        food[i]=new cell(rand.nextInt(Width-10),rand.nextInt(Height-10),0,0,255,0);
    if(arduino==null){
    arduino = new Arduino(this, Arduino.list()[1], 57600);
    for (int i = 0; i <= 13; i++)
        arduino.pinMode(i, Arduino.INPUT);
    }
}
void draw(){
  int Delay=50-(s1.getSize()+s2.getSize());
  int Speed=s1.getSize();
  System.out.println(Direction1);
  if(Delay>=0)
      delay(Delay);
   else
       delay(0);
 
  if(arduino.digitalRead(2)==Arduino.HIGH&&ButtonDelay<=0)
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
  }
  background(0);
   PFont displayFont;
  displayFont=createFont("DSEG7Classic-Regular.ttf",20);
  textFont(displayFont);
  textSize(32);
  fill(255,0,0);
  text(Integer.toString(s1.getSize()),100,100);
  fill(0,0,255);
  text(Integer.toString(s2.getSize()),Width-100,100);
  checkSnake(s1);
  checkSnake(s2);
  s1=s1.move(Direction1,Speed);
  s2=s2.move(Direction2,Speed);
  drawSnake(s1);
  drawSnake(s2);
  for(cell f:food){
      drawCell(f);
  if(checkCollision(s1.getBody().get(0),f)){
          f.setX(rand.nextInt(Width-10));
          f.setY(rand.nextInt(Height-10));
          s1.grow();
  }
  if(checkCollision(s2.getBody().get(0),f)){
          f.setX(rand.nextInt(Width-10));
          f.setY(rand.nextInt(Height-10));
          s2.grow();
  }
  }
  if(checkCollision(s1.getBody().get(0),s2.getBody().get(0))){
            s1=new snake(255,0,0);
            s2=new snake(0,0,255);
   }
  for(cell tmp : s1.getBody()){
        for(cell tmp2:s2.getBody()){
        if(checkCollision(s1.getBody().get(0),tmp)&&tmp!=s1.getBody().get(0)&&tmp!=s1.getBody().get(1)&&tmp!=s1.getBody().get(2))
             { s1=new snake(255,0,0);break;}
        if(checkCollision(s1.getBody().get(0),tmp2))
             { s1=new snake(255,0,0);break;}        
     }
  }
 for(cell tmp : s2.getBody()){
   for(cell tmp2:s1.getBody()){
        if(checkCollision(s2.getBody().get(0),tmp)&&tmp!=s2.getBody().get(0)&&tmp!=s2.getBody().get(1)&&tmp!=s2.getBody().get(2))
              {s2=new snake(0,0,255);break;}
         if(checkCollision(s2.getBody().get(0),tmp2)){
              {s2=new snake(0,0,155);break;}
        }
   }  
}
  
}
void keyPressed(){
        System.out.println("PRESSED");
        if(keyCode==UP&&Direction2!=1){
            Direction2=2;
            System.out.println("UP");
        }
        if(keyCode==DOWN&&Direction2!=2){
            Direction2=1;
            System.out.println("DOWN");
        }
       if(keyCode==RIGHT&&Direction2!=4){
            Direction2=3;
            System.out.println("RIGHT");
        }
        if(keyCode==LEFT&&Direction2!=3){
            Direction2=4;
            System.out.println("LEFT");
        }
}
