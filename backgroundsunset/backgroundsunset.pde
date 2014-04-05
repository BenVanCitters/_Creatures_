
Sunset s;
void setup() {
  size(900, 600,P2D);
  s = new Sunset();
  noCursor();
}

void draw() {
  s.draw();
  println("framerate: " + frameRate);  
}
 

