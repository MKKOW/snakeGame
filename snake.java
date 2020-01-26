import java.util.List;
import java.util.ArrayList;
import java.util.Random;
class snake{
    static private Random rand=new Random();
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
    public void grow(Food food){
      if(food.getPoints()==-1){
          if(size==1){
              reset();
              return;
          }
          size--;
          body.remove(size);
      }
      else{
        System.out.println("HERE");
        int points=food.getPoints();
        for(int i=0;i<points;i++){
        cell New=new cell(body.get(size-1).getX(),body.get(size-1).getY(),body.get(size-1).getDirection(),red,green,blue);
        move(body.get(0).getDirection());
        body.add(New);
        size++;
        }
    }
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
    static public void checkCollision(snake A, snake B){
    if(A==B){
        for(cell tmp:A.getBody()){
                if(tmp!=A.getBody().get(0)&&tmp!=A.getBody().get(1)&&tmp!=A.getBody().get(2)&&cell.checkCollision(A.getBody().get(0),tmp)){
                      A.reset();
                      return;
                }
        }
    }
    else{
    cell HeadA=A.getHead();
    cell HeadB=B.getHead();
    if(cell.checkCollision(HeadA,HeadB)){
          A.reset();
          B.reset();
      }else{
        for(cell tmp:B.getBody()){
            if(cell.checkCollision(HeadA,tmp)){
                A.reset();
                return;
            }
        }
        for(cell tmp:A.getBody()){
            if(cell.checkCollision(HeadB,tmp)){
                B.reset();
                return;
            }
        }
    }
    }
}
}
