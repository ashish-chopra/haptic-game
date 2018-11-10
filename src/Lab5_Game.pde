import processing.serial.*;
import ddf.minim.*;

String serialPortName = "COM6";
int SERIAL_WRITE_LENGTH = 32;
int WIDTH = 1000;
int HEIGHT = 600;

Serial myPort;
Minim minim;
AudioPlayer player, coinSound;
int twiddlerPosition = 0;
float mapTwiddlerPosition;
Element[] elements;
int totalElements = 0;
int releaseDuration = 200;
float maxAllowedWeight = 30;
Timer timerApple, timerCoin;

Paddle paddle;
PImage bg;
boolean initialized = false;

void setup() {
  size(1000, 600); 
  frameRate(30);
  myPort = new Serial(this, serialPortName, 115200);
  randomSeed(millis());
  
  // bg image
  bg = loadImage("star-night.png");
  // for sounds
  minim = new Minim(this);
  player = minim.loadFile("smw_game_over.wav");
  coinSound = minim.loadFile("smw_coin.wav");
  
  elements = new Element[1000];
  timerApple = new Timer(releaseDuration);
  timerCoin = new Timer(releaseDuration + 4);
  timerApple.start();
  timerCoin.start();
  
  paddle = new Paddle();
}

void draw() {
  bg.resize(1000, 600);
  background(bg);
  stroke(0, 0, 255);
  if (initialized) {
    if (!isGameOver()) {  
      ReadTwiddler();
      mapTwiddlerPosition = map(twiddlerPosition, 0, 255, 0, 1000);
      
      if (timerApple.isOff()) {
        createApples();
      }
      if (timerCoin.isOff()) {
        createCoins();
      }
      drawAndMoveElements();
      paddle.update(mapTwiddlerPosition);
      paddle.display();
      updateScore(paddle.getScore(), paddle.getWeight());
    } else {
      
      player.play();
      textSize(48);
      textAlign(CENTER);
      text("Game Over!", width/2, height/3);
      text("Your score is: " + paddle.getScore() , width/2, height/2);
    }
  } else {
    textSize(28);
    textAlign(CENTER);
    text("Welcome to Pirates of Space.", width/2, height/2);
    textSize(20);
    textAlign(CENTER);
    text("Press 'spacebar' key to start the game.", width/2 + 30, height/2 + 30);
  }
}

void keyPressed() {
  
  if (key == ' ') {
    initialized = true;
  }
}

void createApples() {
  elements[totalElements] = new Apple();
  totalElements++;
  if (totalElements > 1000) {
    totalElements = 0;
  }
  
  timerApple.start();
}

void createCoins() {
  elements[totalElements] = new Coin();
  totalElements++;
  if (totalElements >= 1000) {
    totalElements = 0;
  }
  
  timerCoin.start();
}
void drawAndMoveElements() {
  int score = paddle.getScore();
  for (int i =0; i < totalElements; i++) {
    elements[i].update(score);
    elements[i].display();
    
    if(paddle.collide(elements[i])) {
      if (elements[i] instanceof Coin) {
        coinSound.rewind();
        coinSound.play();
      }
      elements[i].collected();
    }
  }
}

boolean isGameOver() {
  if (paddle.getWeight() >= maxAllowedWeight) {
    return true;
  } else {
    return false;
  }
}

void ReadTwiddler()
{
    String inputString = "";
    
    byte input[] = new byte[256];
    while(myPort.available() > 0)
    {
      input = myPort.readBytes();
     }
     if (input != null)
     {
       inputString = new String(input);
       String[] inputStrings = inputString.split("\r\n");
       
       if (inputStrings.length >= 2)
       {
         System.out.println(inputStrings[0] + " " + inputStrings[1]);
         try {
         twiddlerPosition = Integer.parseInt(inputStrings[inputStrings.length-2]);
         } finally {}
       }
     }
}

void updateScore(int coins, int weight) {
  textSize(22);
  textAlign(CENTER);
  text("Pirates of Space", 500, 20);
  
  
  textSize(16);
  textAlign(LEFT);
  text("Coins: " + coins, 0, 18);
  text("Weight: " + weight + "/" + maxAllowedWeight, 0, 40);
}
