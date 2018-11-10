abstract class Element {
  
  float x;
  float y;

  Element() {
     this.x = random(0, width);
     this.y = 0;
  }
  
  void collected() {
    this.x = -width;
    this.y = -height;
  }
  
  void display() {
    noStroke();
  }
  
  float getXPosition() {
    return x;
  }
  
  float getYPosition() {
    return y;
  }
  
  abstract void update(int score);

}
