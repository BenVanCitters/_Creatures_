import processing.video.*;
import ddf.minim.*;

Minim minim;
AudioInput in;

PGraphics creatureTex;
Capture cam;

void setup()
{
  
  size(displayWidth,displayHeight,P2D);
  
  noCursor();
  
  // Init & Start capturing the images from the camera
  cam = new Capture(this, 640, 480);
  cam.start();
  
  //image stuff
  PImage creatureLogo = loadImage("logo_inv1.png");
  creatureTex = createGraphics(width,height,P2D);
  creatureTex.beginDraw();
  creatureTex.image(creatureLogo,0,0,creatureTex.width,creatureTex.height);
  creatureTex.endDraw();
  
  //init audio
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO,512);
}

void draw() 
{
  float lvl = in.mix.level();//getMaxSamp(in.mix.toArray());
  println("lvl: " + lvl);
  float tm = millis()/1000.f;
  background(0);
  if (cam.available() == true) 
  {
    cam.read();
  }
//  image(cam, 0, 0);
  stroke(255);
  strokeWeight(.4);
  creatureTex.loadPixels();
  cam.loadPixels();
  
  float camLogoSweep = (cos(tm/15.f)+1.f)/2.f;
  float brtFreqScale = .5+(cos(2+tm/4.f)+1.f)/2.f;
  int numHBars = 480/3;
  int barSegments = 640;
  float hBarSpacing = 260*lvl + 2*height * 1.f/numHBars;
  float camToScr[] = new float[]{width*1.f/barSegments,height*1.f/numHBars};
  noFill();
  for(int i = 0; i < numHBars; i++)
  {
    float curT = tm*10;
    beginShape();
    for(int j = 0; j < barSegments; j++)
    {
      int logoIndex = (int)(((i*1.f/numHBars)*creatureTex.height) *creatureTex.width + (j*1.f/barSegments)*creatureTex.width);
      int camIndex = (int)(((i*1.f/numHBars)*cam.height) *cam.width + (j*1.f/barSegments)*cam.width);
      float lbrt = brightness(creatureTex.pixels[logoIndex]);
      float cbrt = brightness(cam.pixels[camIndex]);
      float brt = camLogoSweep * cbrt + (1-camLogoSweep)*lbrt;
      curT+= brtFreqScale*(brt/255.f);
      vertex(j*camToScr[0],i*camToScr[1] + hBarSpacing*sin(curT));
    }
    endShape();
  }
//  println("framerate: " + frameRate);
}

float getMaxSamp(float[] samples)
{
  float maxAmp = -5;
  for(int i = 0; i < samples.length; i++)
  {
    maxAmp = max(maxAmp,abs(samples[i]));
  }
  return maxAmp;
}

