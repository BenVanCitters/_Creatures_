import ddf.minim.*;
Minim minim;
AudioInput in;
PImage gradient;
PImage logo_inv;

void setup()
{
  size(displayWidth, displayHeight, P2D);
  gradient = loadImage("gradient.png");
  logo_inv = loadImage("logo_inv.png");
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO,512);
  colorMode(HSB, 255);
  textureMode(NORMAL);
}

void draw()
{ 
  pushMatrix();
  scale(.58);
  translate(-350,-280);
  tint(0);
  image(logo_inv,
  0,0);
  popMatrix();
  //fill(255,255,255,4);//hsb
//  fill(228,0,43,4);//red
  fill(0,0,0,4);
  rect(0,0,width,height);
//  background(0);
  noStroke();
  float samps[] = in.mix.toArray();
  float smpSpc = 3*width*1.f/samps.length;
  float tm = millis()/40.f;
  pushMatrix();
  colorMode(RGB, 255);
  translate(0,height/2.f);
//  fill(gradient.get(0,(int)(tm%gradient.height)));
  tint(255);
  beginShape(TRIANGLE_STRIP);
  texture(gradient);
  for(int i = 0; i < samps.length && smpSpc*i < width; i++)
  {
//    fill(225,184,127);//purple
//    fill((i/10.f+tm)%255,40,255);
    vertex(smpSpc*i,samps[i]*height-40,
    0,0
    );
    vertex(smpSpc*i,samps[i]*height+40,
    0,1
    );
  }
  endShape();
  popMatrix();
  
//  translate(width/2.f-logo.width/2,height/2.f-200);
//  tint(0);
//  image(logo,0,0);
}
