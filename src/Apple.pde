class Apple extends Element { 
  float speed = 0.532;
  float radius = 12;
  Apple() {
   super();
  }
  
  void update(int score) {
    this.y += 1.5 + score/9 * speed;
  }
  
   void display() {
    super.display();
    fill(255,0,0);
    ellipse(x, y, radius, radius);
  }
  
}
