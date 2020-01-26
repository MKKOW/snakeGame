
public class cell{
    static private int cellSize=10;
    static int Width;
    static int Height;
    private int x;
    private int y; 
    private int direction;//N-1,S-2,E-3,W-4
    private int red;
    private int green;
    private int blue;
    public cell(){
        x=0;
        y=0;
        direction=0;
        red=0;
        green=0;
        blue=0;
    }
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
    public void setRed(int X){
          red=X;
    }
    public void setGreen(int Y){
          green=Y;
    }
    public void setBlue(int X){
          blue=X;
    }
    static public boolean checkCollision(cell A, cell B){
      if(A==B)
            return false;
      if(A.getX()>=B.getX()&&A.getX()<=B.getX()+cellSize&&A.getY()>=B.getY()&&A.getY()<=B.getY()+cellSize)
            return true;
      if(B.getX()>=A.getX()&&B.getX()<=A.getX()+cellSize&&B.getY()>=A.getY()&&B.getY()<=A.getY()+cellSize)
            return true;
      return false;
  }
  static public int getCellSize(){
         return cellSize;
  }
  static public void setWidth(int w){
        Width=w;
  }
  static public void setHeight(int w){
        Height=w;
  }
}
