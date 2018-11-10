class Coin extends Element {
 
  float speed = 0.332;
  float radius = 9;
  Coin() {
   super();
  }
  
  void update(int score) {
    this.y += 1.2 + score/12 * speed;
  }
  
  void display() {
    super.display();
    fill(218,165,132);
    ellipse(x, y, radius, radius);
  }
  
  
  
}
