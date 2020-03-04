PFont font;
int totalNum=54;
int[] cardNum=new int[totalNum];
boolean[] flipCard=new boolean[totalNum];
boolean[] showCard=new boolean[totalNum];
int[] cardX=new int[totalNum];
int[] cardY=new int[totalNum];
float[] tilt=new float[totalNum];
int[] dx=new int[totalNum];
int[] dy=new int[totalNum];
String player="ONE";
boolean ready=false;
int animCnt=0;
int previousCard=totalNum-1;
int currentCard=totalNum-2;
String score=" ";
int state=0;
int pts1=0;
int pts2=0;
int miss=0;
boolean gameMode=false;

void setup(){
  size(1024,630);
  font = createFont("ArialMT", 32);
  textFont(font,32);
  rectMode(CENTER);
  textAlign(CENTER);
  smooth();
  noStroke();
  initCard();
  shuffle();
}
void draw(){
  background(255,215,0);
  for(int i=0;i<totalNum;i++){
    int x=50+(i%11)*90+dx[i];
    int y=80+(int(i/11))*120+dy[i];
    pushMatrix();
    translate(x,y);
    rotate(tilt[i]);
    card(cardNum[i],0,0,flipCard[i],showCard[i]);
    popMatrix();
  }
  if(state==0){
    score="CLICK A CARD";
    ready=true;    
  }else if(state==1){
    score="CLICK ANOTHER ONE";
  }else if(state==2){
    int cp=cardNum[previousCard];
    int cc=cardNum[currentCard];
    if((cp<52 && cc<52 && cp%13+1==cc%13+1) || (cc>51 && cp>51)){
      score="MATCHED";
      if(animCnt>40){
        showCard[previousCard]=false;
        showCard[currentCard]=false;
        animCnt=0;
        state=0;
        if(player=="ONE"){
          pts1+=2;
        }else{
          pts2+=2;
        }
        if(pts1+pts2==totalNum){//game over
          state=3;
        }
      }   
    }else{
      score="NOT MATCHED";
      if(animCnt>40){
        flipCard[previousCard]=false;
        flipCard[currentCard]=false;
        animCnt=0;
        state=0;
        if(gameMode){
          if(player=="ONE"){
            player="TWO";
          }else{
            player="ONE";
          }
        }else{
          miss++;
        }
      }
    }
    ready=false;
    animCnt++;
  }else if(state==3){
    score="GAME OVER";
    String s=" ";
    if(gameMode){
      if(pts1>pts2){
        s="PLAYER ONE WIN";
      }else if(pts1<pts2){
        s="PLAYER TWO WIN";
      }else if(pts1==pts2){
        s="DRAW GAME"; 
      }
    }else{
      s="SCORE : "+(pts1-miss)+" POINTS";
    }
    textSize(32);
    text(s,width/2,height/2);
  }
  noStroke();
    fill(0,250,0,100);
  if(player=="ONE"){  
    rect(62,10,124,20);
  }else{
    rect(width-62,10,124,20);
  }
  textSize(12);
  fill(250);
  textAlign(RIGHT);
  text("PLAYER ONE : "+pts1,110,14);
  if(gameMode){
    text("PLAYER TWO : "+pts2,width-12,14);
  }else{
    text("MISTAKE : "+miss,width-24,14);
  }
  textAlign(CENTER);
  text(score,width/2,14);
}
void mousePressed(){
  if(state==3){
    initCard();
    shuffle();
  }
  if(ready){
    for(int i=0;i<totalNum;i++){
      int rectW=75;
      int rectH=105;
      int xx=50+(i%11)*90+dx[i];
      int yy=80+(int(i/11))*120+dy[i];
      float x=(mouseX-xx)*cos(-tilt[i])-(mouseY-yy)*sin(-tilt[i]);
      float y=(mouseX-xx)*sin(-tilt[i])+(mouseY-yy)*cos(-tilt[i]);
      if(flipCard[i]==false && showCard[i]==true){
        if(x>-rectW/2 && x<rectW/2 && y>-rectH/2 && y<rectH/2){
          if(state<2){
            flipCard[i]=true;
            previousCard=currentCard;
            currentCard=i;
            state++;
          }
        }
      }
    }
  }
}
void keyPressed(){
  if(key==CODED){
    if(keyCode==LEFT){
    }
    if(keyCode==RIGHT){
    }
  }
  if(key==' '){
    gameMode=!gameMode;
    initCard();
    shuffle();
  }
}
void initCard(){
  player="ONE";
  ready=false;
  animCnt=0;
  previousCard=totalNum-1;
  currentCard=totalNum-2;
  score=" ";
  state=0;
  pts1=0;
  pts2=0;
  miss=0;
  for(int i=0;i<totalNum;i++){
    cardNum[i]=i;
    tilt[i]=random(-0.2,0.2);
    dx[i]=floor(random(-15,15));
    dy[i]=floor(random(-15,15));
    flipCard[i]=false;
    showCard[i]=true;
  }
}
void shuffle() {
  for(int i=0;i<totalNum;i++) {
    int r=floor(random(totalNum));
    int t=cardNum[r];
    cardNum[r]=cardNum[i];
    cardNum[i]=t;
  }
}
void card(int n, int x, int y, boolean fc, boolean sc) {
  if(sc){
    int s=2;
    int r=8;
    int cw=75;
    int ch=105;
    fill(255);
    ellipse(x-cw/2+r,y-ch/2+r,r*2,r*2);
    ellipse(x+cw/2-r-1,y-ch/2+r,r*2,r*2);
    ellipse(x-cw/2+r,y+ch/2-r-1,r*2,r*2);
    ellipse(x+cw/2-r-1,y+ch/2-r-1,r*2,r*2);
    rect(x,y,cw-r*2,ch-1);
    rect(x,y,cw-1,ch-r*2);
    if(fc==false) {
      fill(255,105,180);
      rect(x,y,cw-r*2,ch-r*2);
    }else{    
      String pt=toSuit(n);
      String num=toNumber(n);
      if(n<52) {
        textSize(32);
        if(pt=="♥" || pt=="♦") {
          fill(255,0,0);
        }else{
          fill(0);
        }
        text(pt,x+cw/2-12,y-ch/2+r*3);
        text(pt,x-cw/2+12,y+ch/2-4);
        textFont(font,36);
        text(num,x,y+13);
      }else {//if joker
        fill(0);
        textSize(20);
        text(num,x,y+9);
      }
    }
  }
}
String toNumber(int n) {
  String s;
  int i=n%13+1;
  if(n<52) {
    if(i==1) {
      s="A";
    }else if(i==11) {
      s="J";
    }else if(i==12) {
      s="Q";
    }else if(i==13) {
      s="K";
    }else {
      s=str(i);
    }
  }else {
    s="JOKER";
  }
  return s;
}
String toSuit(int n) {
  String s;
  int i=int(n/13);
  if(i==0) {
    s="♠";
  }else if(i==1) {
    s="♣";
  }else if(i==2) {
    s="♥";
  }else if(i==3) {
    s="♦";
  }else {
    s=" ";
  }
  return s;
}
