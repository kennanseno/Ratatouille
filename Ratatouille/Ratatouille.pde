ArrayList<Player> players = new ArrayList<Player>();
ArrayList<GameObject> objects = new ArrayList<GameObject>();
boolean[] keys = new boolean[526];
PFont font;
PImage design1;
String[] line;
int gameState = 0;
void setup(){
  size(600, 600);
  font = loadFont("copperplate.vlw");
  design1 = loadImage("");
  setUpPlayerControllers();
  objects.add(new Spatula(200,200));
  objects.add(new Spatula(400,200));
  
  loadHighScore();
}

void draw(){
  background(255);
  
  switch(gameState){
    case 0:
      gameMenu();
      break;
    case 1:
      playTagGame();
      break;
    case 3:
      highScore();
      break;
  }
}

void gameMenu(){
  fill(16,136,240);
  ellipse(width/2,150,550,150);
  
  for(Player player:players){
    player.update();
    player.display();
  }
    
  fill(0);
  textFont(font);
  textSize(60);
  textAlign(CENTER,CENTER);
  text("Ratatouille",width/2,150);
  
  textSize(16);
  text("(By: Kennan Lyle Seno)",width/2,200);
  
  textSize(24); 
  text("Play Tag",width/2,300);
  text("Play Survival",width/2,350);
  text("Highscore",width/2,400);
  text("Exit",width/2,450);
  
  if(mousePressed){
    if((mouseX > 240 && mouseX < 360) && (mouseY > 280 && mouseY < 320)){
      gameState = 1;
    }else if((mouseX > 230 && mouseX < 320) && (mouseY > 390 && mouseY < 410)){
      gameState = 3;
    }else if((mouseX > 275 && mouseX < 325) && (mouseY > 440 && mouseY < 460)){
      exit();
    }
  }
  
  /*
  stroke(0,255,0);
  for(int i = 0; i < 12; i++){
    line(0,50*i,width,50*i);
    line(50*i,0,50*i,height);    
  }
  */
}

void playTagGame(){
  gameFloor();
  
  for(Player player:players){
    if(player.life > 0){
      player.update();
      player.display();
    }
  }
  
  statInterface();
}

boolean checkKey(char theKey){
  return keys[Character.toUpperCase(theKey)];
}

char buttonNameToKey(XML xml, String buttonName){
  String value =  xml.getChild(buttonName).getContent();
  if ("LEFT".equalsIgnoreCase(value)) {
    return LEFT;
  }
  if ("RIGHT".equalsIgnoreCase(value)) {
    return RIGHT;
  }
  if ("UP".equalsIgnoreCase(value)) {
    return UP;
  }
  if ("DOWN".equalsIgnoreCase(value)) {
    return DOWN;
  }
  //.. Others to follow
  return value.charAt(0);  
}

void setUpPlayerControllers(){
  XML xml = loadXML("arcade.xml");
  XML[] children = xml.getChildren("player");
  int gap = width / (children.length + 1);
  
  for(int i = 0 ; i < children.length ; i ++)  {
    XML playerXML = children[i];
    Player p = new Player(
            i
            , color(random(0, 255), random(0, 255), random(0, 255))
            , playerXML);
    int x = (i + 1) * gap;
    p.pos.x = x;
    p.pos.y = 300;
    players.add(p);         
  }
}

void highScore(){
  
}

String[] name;
int[] tag;

void loadHighScore(){
  line = loadStrings("tag.csv");
  name = new String[line.length];
  tag = new int[line.length];  
  
  for(int i = 0; i < line.length; i++){
    String[] data = split(line[i],",");
    name[i] = data[0];
    tag[i] = parseInt(data[1]);
  }
}

void gameFloor(){
  fill(0);
  int gap = 50;
   
  //make blocks with grey and white colours
  stroke(128,128,128);
  for(int i = 0; i <= 12; i++){
    for(int j = 1; j <= 12; j++){
      if(i % 2 == 0){
        if(j % 2 == 1) fill(216,216,216);
        else fill(255,51,51);        
      }else{
        if(j % 2 == 0) fill(216,216,216);
        else fill(255,51,51);   
      }
       rect(i*gap,j*gap,gap,gap);
    }
  }
  //create black diamond on the floor  
  noStroke();
  fill(0);
  for(int i = 0; i <= 12; i++){
    for(int j = 1; j <= 12; j++){
      quad((gap*i)-15,(gap*j),(gap*i),(gap*j)-15,(gap*i)+15,(gap*j),(gap*i),(gap*j)+15);    
    }
  } 
  
}

void statInterface(){
  fill(255);
  stroke(0);
  rect(0,0,width,50);
  
  textSize(16);
  textAlign(LEFT); 
  
  fill(players.get(0).colour);
  text("Life: " + parseInt(players.get(0).life),10,20);
  fill(players.get(1).colour);
  text("Life: " + parseInt(players.get(1).life),535,20);  
  
}

void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
}

