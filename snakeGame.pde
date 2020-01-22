import java.util.List;
import java.util.ArrayList;
import java.util.Random;
static int cellSize=10;
static int speed=10;
Random rand=new Random();
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
         if(nextDirection==1)
                  y+=speed;
         if(nextDirection==2)
                  y-=speed;
         if(nextDirection==3)
                  x+=speed;
         if(nextDirection==4)
                  x-=speed;
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
    public snake(){
      size=1;
      cell tmp=new cell(500,500,1,255,255,255);
      body.add(tmp);
    }
    public snake move(int direction){
         int nextDirection=direction;
         for(cell tmp:body){
               nextDirection=tmp.move(nextDirection);
         }
         System.out.println(body.get(0).getX());
         System.out.println(body.get(0).getY());
         return this;
    }
    public void grow(){
        cell New=new cell(body.get(size-1).getX(),body.get(size-1).getY(),body.get(size-1).getDirection(),255,255,255);
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
}
int Direction=1;
int xSize=1000;
int ySize=1000;
snake s;
cell food;
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
          if(tmp.getX()<0||tmp.getX()>xSize){
                tmp.setX(abs(tmp.getX()-xSize));
          }
          if(tmp.getY()<0||tmp.getY()>ySize){
                tmp.setY(abs(tmp.getY()-ySize));
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
    size(1000,1000);
    s=new snake();
    food=new cell(rand.nextInt(990),rand.nextInt(990),0,0,255,0);
}
void draw(){
  delay(10);
  int speed=s.getSize();
  background(0);
  checkSnake(s);
  s=s.move(Direction);
  drawSnake(s);
  drawCell(food);
  if(checkCollision(s.getBody().get(0),food)){
          food.setX(rand.nextInt(990));
          food.setY(rand.nextInt(990));
          s.grow();
  }
}
void keyPressed(){
        System.out.println("PRESSED");
        if(keyCode==UP){
            Direction=2;
            System.out.println("UP");
        }
        if(keyCode==DOWN){
            Direction=1;
            System.out.println("DOWN");
        }
       if(keyCode==RIGHT){
            Direction=3;
            System.out.println("RIGHT");
        }
        if(keyCode==LEFT){
            Direction=4;
            System.out.println("LEFT");
        }
}
