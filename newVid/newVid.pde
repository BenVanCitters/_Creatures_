import processing.video.*;


PImage grad;
Sunset s;
CamHalfTone c;

void setup() 
{
  size(displayWidth, displayHeight,OPENGL);
//  size(640, 480,OPENGL);
  s = new Sunset();
  grad = loadImage("creature-gradient-1.jpg");
  c = new CamHalfTone(this);
  
}



void drawTextureBackground()
{
  float tm = millis()/1000.f;
  //background(0);
  //image(grad,0,0,width,height);
  noStroke();
  textureMode(NORMAL);
  float uvs[][] = new float[][] {{0,(sin(tm/10)+1)/2},{0,.5}};
  beginShape(TRIANGLE_STRIP);
  texture(grad);
  vertex(0,0,uvs[0][0],uvs[0][1]);
  vertex(0,height,uvs[1][0],uvs[1][1]);
  vertex(width,0,uvs[0][0],uvs[0][1]);
  vertex(width,height,uvs[1][0],uvs[1][1]);
  endShape();
  
}

void draw() 
{
  
  drawTextureBackground();
//  s.draw();
  c.update();
  c.draw(); 
println("frameRate: " + frameRate);
}

