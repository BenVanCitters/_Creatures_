import ddf.minim.*;
Minim minim;
AudioInput in;
PImage logo;
void setup()
{
  size(displayWidth, displayHeight, P3D);
  logo = loadImage("logo.png");
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO,512);
  colorMode(HSB, 255);
}

void draw()
{
  background(0);
  noStroke();
  float samps[] = in.mix.toArray();
  float smpSpc = 3*width*1.f/samps.length;
  float tm = millis()/40.f;
  pushMatrix();
  translate(0,height/2.f);
  beginShape(TRIANGLE_STRIP);
  for(int i = 0; i < samps.length && smpSpc*i < width; i++)
  {
    fill((i/10.f+tm)%255,40,255);
    vertex(smpSpc*i,samps[i]*height-40);
    vertex(smpSpc*i,samps[i]*height+40);
  }
  endShape();
  popMatrix();
  
  translate(width/2.f-logo.width/2,height/2.f-200);
  tint(0);
  image(logo,0,0);
}
