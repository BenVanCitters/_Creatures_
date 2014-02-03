import ddf.minim.*;
Minim minim;
AudioInput in;
PImage logo_inv;
void setup()
{
  size(displayWidth, displayHeight, P3D);
  noCursor();
  logo_inv = loadImage("logo_inv.png");
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO,512);
  colorMode(HSB, 255);
}

void draw()
{
  pushMatrix();
  scale(1.18);
  translate(-350,-280+280*mouseY/height);
  tint(0);
  image(logo_inv,
  0,0);
  popMatrix();
    fill(0,0,0,20);
  rect(0,0,width,height);
  noStroke();
  float samps[] = in.mix.toArray();
  float smpSpc = (1.f+mouseX*45.f/width)*width*1.f/samps.length;
  
  float tm = millis()/40.f;
  
  float sampScale = 2.f*height-mouseX*800.f/width;//mouseY*2.f;
  pushMatrix();
  translate(0,mouseY);
  beginShape(TRIANGLE_STRIP);
  for(int i = 0; i < samps.length && smpSpc*i < width; i++)
  {
    fill((i/10.f+tm)%255,40,255);
    vertex(smpSpc*i,samps[i]*sampScale-30);
    vertex(smpSpc*i,samps[i]*sampScale+30);
  }
  endShape();
  popMatrix();
  
//  translate(width/2.f-logo.width/2,height/2.f-200);
//  tint(0);
//  image(logo,0,0);
}
