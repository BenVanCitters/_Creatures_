import processing.video.*;

Capture cam;

void setup() {
//  size(displayWidth, displayHeight,OPENGL);
size(640, 480,OPENGL);
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    cam.start();
  }
}

void draw() {
background(0);
noStroke();
stroke(255);
  if (cam.available() == true) {
    cam.read();
  }
  cam.loadPixels();
  int numLines = 50;
  float maxLineHt = 20;
  int numLineSegments = 100;
  float vertLineSpacing = height*1.f/numLines;
  float segSpacing = width*1.f/numLineSegments;
  float tm = millis()/1000.f;
  int vertCount = 0;
  float maxOffset = 55*sin(tm/2+3);
  int cusionLines = (int)(1.5+abs(maxOffset)/vertLineSpacing);
  if(cam.pixels.length > 0)
  {
    for(int i = -cusionLines; i< numLines+cusionLines; i++)
    {
      beginShape(TRIANGLE_STRIP);
      for(int j = 0; j < numLineSegments+1; j++)
      {
        float vertOffset = vertLineSpacing*(tm%1.f)+ maxOffset*sin(tm/1+j/5.f);
        int cx = (int)((segSpacing * j)*cam.width/width);
        int cy = (int)((vertLineSpacing * i+vertOffset)*cam.height/height);
        int curCamPixelIndex = cx+cy  *cam.width;
  //      print("  ,  " + cx + "+" + cy );
        curCamPixelIndex = max(0,min(cam.pixels.length-1,curCamPixelIndex));
//        float curBrightness = brightness(cam.pixels[curCamPixelIndex]); 
        float curBrightness = ((cam.pixels[curCamPixelIndex] >> 16) & 0xFF) + 
                              ((cam.pixels[curCamPixelIndex] >> 8) & 0xFF) + 
                              ((cam.pixels[curCamPixelIndex]) & 0xFF); 
        curBrightness /= (3.f);
        float ht = 2.f/3*curBrightness*vertLineSpacing/255;
//        fill(0xFF<<((j%3)*8)  | 0xFF000000);
//        stroke(0xFF<<((j%3)*8)  | 0xFF000000);
        vertex(segSpacing * j, vertOffset+vertLineSpacing*i-ht/2);
        vertex(segSpacing * j, vertOffset+vertLineSpacing*i+ht/2);
        vertCount += 2;
//        rect(segSpacing * j, vertLineSpacing*i-ht/2, segSpacing, ht);
      }
      endShape();
    }
  }
  println("frameRate: " + frameRate + " vertcount: " + vertCount);
}

