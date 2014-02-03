import processing.video.*;

Capture cam;

void setup()
{
//  size(640, 480);
  size(1240,960);
  // Init & Start capturing the images from the camera
  cam = new Capture(this, 640, 480);
  cam.start();
  
}

void draw() 
{
  background(255);
  if (cam.available() == true) 
  {
    cam.read();
  }
//  image(cam, 0, 0);
  cam.loadPixels();
  int numHBars = 480/2;
  int barSegments = 640;
  float hBarSpacing = 2*height * 1.f/numHBars;
  float camToScr[] = new float[]{width*1.f/barSegments,height*1.f/numHBars};
  noFill();
  for(int i = 0; i < numHBars; i++)
  {
    float curT = 0;
    beginShape();
    for(int j = 0; j < barSegments; j++)
    {
      int index = (int)(((i*1.f/numHBars)*cam.height) *cam.width + (j*1.f/barSegments)*cam.width);
      float brt = brightness(cam.pixels[index]);
      curT+= (brt/255.f);
      vertex(j*camToScr[0],i*camToScr[1] + hBarSpacing*sin(curT));
    }
    endShape();
  }
  println("framerate: " + frameRate);
}

