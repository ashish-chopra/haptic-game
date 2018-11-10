class Paddle {
  
  float x;
  float y;
  float PADDLE_WIDTH = 100;
  float PADDLE_HEIGHT = 15;
  
  int weight = 0;
  int score = 0;
  Paddle() {
    this.x = width/2 - PADDLE_WIDTH/2;
    this.y = height - PADDLE_HEIGHT;
  }
  
  void display() {
    fill(255);
    noStroke();
    rect(this.x, this.y, this.PADDLE_WIDTH, this.PADDLE_HEIGHT); 
  }
  
  void update(float position) {
    
    position = -position;
    
    if (position < 0) {
      this.x = 0;
    }
    else if (position > 1000 - PADDLE_WIDTH) {
      this.x = 1000 - PADDLE_WIDTH;
    } else {
      this.x = position;
    }
  }
  
  boolean collide(Element e) {
  
    if ((e.getYPosition() >= height - PADDLE_HEIGHT && e.getYPosition() <= height) 
    && ( e.getXPosition() >= x && e.getXPosition() <= x + PADDLE_WIDTH)) {
      if (e instanceof Apple) {
         weight += 1;
         myPort.write('i');
      } else {
        score += 1;
      }
     return true;
    } else {
     return false;
   }
   
  }
  
  int getWeight() {
    return this.weight;
  }
  
  int getScore() {
    return this.score;
  }
}
