import java.util.Random;
public class Food extends cell{
    static private Random rand=new Random();
    private int points;
   public Food(int X,int Y){
     super(X,Y,0,0,0,0);
     points=randPoint();
          if(points==1)
          {
              super.setGreen(255);
          }
          if(points==3){
              super.setBlue(255);
          }
          if(points==5){
              super.setRed(255);
              super.setGreen(255);
          }
          if(points==-1){
              super.setRed(255);
          }
    }
    public int getPoints(){
          return points;
    }
    public void reset(int X,int Y){
          super.setX(X);
          super.setY(Y);
          points=randPoint();
          if(points==1)
          {
              super.setRed(0);
              super.setGreen(255);
              super.setBlue(0);
          }
          if(points==3){
            super.setRed(0);
              super.setGreen(0);
              super.setBlue(255);
          }
          if(points==5){
              super.setRed(255);
              super.setGreen(255);
              super.setBlue(0);
          }
          if(points==-1){
              super.setRed(255);
               super.setGreen(0);
              super.setBlue(0);
          }
    }
    static private int randPoint(){
            int tmp=rand.nextInt();
            if(tmp%7==0)
                return 3;
            if(tmp%11==0)
                return 5;
            if(tmp%13==0)
                return -1;
            return 1;
    }
}
