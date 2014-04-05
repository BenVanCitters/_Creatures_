import processing.video.*;
import ddf.minim.*;

Minim minim;
AudioInput in;

PGraphics creatureTex;
Capture cam;

void setup()
{
  
  size(displayWidth,displayHeight);
  smooth();  
  noCursor();
  
  // Init & Start capturing the images from the camera
  cam = new Capture(this, 640, 480);
  cam.start();
  
  //image stuff
  PImage creatureLogo = loadImage("logo_inv1.png");
  creatureTex = createGraphics(width,height);
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
//  println("lvl: " + lvl);
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
  float brtFreqScale = 0.5+(cos(2+tm/4.f)+1.f)/2.f;
  int numHBars = 480/3;
  int barSegments = 400;
  float hBarAmplitude = 100*lvl + 2*height * 1.f/numHBars;
  float camToScr[] = new float[]{width*1.f/barSegments,height*1.f/numHBars};
  noFill();
  for(int i = 0; i < numHBars; i++)
  {
    float curT = tm*10;
    stroke(255,0,0);
    beginShape();
    for(int j = 0; j < barSegments; j++)
    {
      float xNorm = (j*1.f/barSegments);
      float yNorm = (i*1.f/numHBars);
      int logoIndex = (int)((int)(yNorm*creatureTex.height)*creatureTex.width + (xNorm*creatureTex.width));
      int camIndex = (int)((yNorm*cam.height) *cam.width + xNorm*cam.width);
      float lbrt = brightness(creatureTex.pixels[logoIndex]);
      float cbrt = red(cam.pixels[camIndex]);
      float brt = camLogoSweep * cbrt + (1-camLogoSweep)*lbrt;
      curT+= brtFreqScale*(brt/255.f);
      vertex(j*camToScr[0],i*camToScr[1] + hBarAmplitude*sin(curT));
    }
    endShape();
    pushMatrix();
    translate(0,(height*1.f/numHBars)/3.f);
    stroke(0,255,0);
    beginShape();
    for(int j = 0; j < barSegments; j++)
    {
      float xNorm = (j*1.f/barSegments);
      float yNorm = (i*1.f/numHBars);
      int logoIndex = (int)((int)(yNorm*creatureTex.height)*creatureTex.width + (xNorm*creatureTex.width));
      int camIndex = (int)((yNorm*cam.height) *cam.width + xNorm*cam.width);
      float lbrt = brightness(creatureTex.pixels[logoIndex]);
      float cbrt = green(cam.pixels[camIndex]);
      float brt = camLogoSweep * cbrt + (1-camLogoSweep)*lbrt;
      curT+= brtFreqScale*(brt/255.f);
      vertex(j*camToScr[0],i*camToScr[1] + hBarAmplitude*sin(curT));
    }
    endShape();
    
    translate(0,(height*1.f/numHBars)/3.f);
    stroke(0,0,255);
    beginShape();
    for(int j = 0; j < barSegments; j++)
    {
      float xNorm = (j*1.f/barSegments);
      float yNorm = (i*1.f/numHBars);
      int logoIndex = (int)((int)(yNorm*creatureTex.height)*creatureTex.width + (xNorm*creatureTex.width));
      int camIndex = (int)((yNorm*cam.height) *cam.width + xNorm*cam.width);
      float lbrt = brightness(creatureTex.pixels[logoIndex]);
      float cbrt = blue(cam.pixels[camIndex]);
      float brt = camLogoSweep * cbrt + (1-camLogoSweep)*lbrt;
      curT+= brtFreqScale*(brt/255.f);
      vertex(j*camToScr[0],i*camToScr[1] + hBarAmplitude*sin(curT));
    }
    endShape();
    popMatrix();
  }
  println("framerate: " + frameRate);
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

