class CamHalfTone
{
  Capture cam;
  Movie cMovie;
  PGraphics surface;
  int numLines = 50;
  float maxLineHt = 20;
  int numLineSegments = 100;
  float vertLineSpacing;
  float segSpacing;
  
  public CamHalfTone(PApplet t)
  {
  //
    surface = createGraphics(640, 480, P2D);
    cMovie = new Movie(t, "is-this-good-enough-for-you-king-ben.mov");
    cMovie.loop();
    initCamera(t);
    segSpacing = surface.width*1.f/numLineSegments;
  }
  void initCamera(PApplet t)
  {
    println("setting up capture...");
    cam = new Capture(t, 640, 480);
//    print("listing capture devices...");
//    String[] cameras = Capture.list();
//    print("beginning to find capture devices...");
//    if (cameras == null) {
//      println("Failed to retrieve the list of available cameras, will try the default...");
//      cam = new Capture(t, 640, 480);
//    } 
//    if (cameras.length == 0) {
//      println("There are no cameras available for capture.");
//      exit();
//    } 
//    else {
//      println("Available cameras:");
//      for (int i = 0; i < cameras.length; i++) {
//        println(cameras[i]);
//      }
//      cam = new Capture(t, cameras[0]);
//      cam.start();
//      println("...completed to finding capture devices");
//    }
    cam.start();
      println("...completed to finding capture devices");
  }
  void update() 
  {
     
    surface.beginDraw();
    surface.clear();
//    surface.image(cMovie,0,213,320,268);
    float tm = millis()/1000.f;
    float cVideoFade = (sin(tm/5)+1)/2;
    float cCamFade = 1-cVideoFade;
    
    numLines = (int)(50 + 20*sin(tm/25));
    vertLineSpacing = surface.height*1.f/numLines;
    
    float whiteFade = sin(tm/11);//(sin(tm)+1)/2;

    surface.noStroke();

    if (cam.available() == true) 
    {
      cam.read();
    }
    cam.loadPixels();
    cMovie.loadPixels();

    surface.stroke(whiteFade*128+127);
    surface.fill(whiteFade*128+127);
    //    int vertCount = 0;
    float maxOffset = 55*sin(tm/2+3);
    int cusionLines = (int)(1.5+abs(maxOffset)/vertLineSpacing);

    if (cam.pixels.length > 0)
    {
      for (int i = -cusionLines; i< numLines+cusionLines; i++)
      {
        surface.beginShape(TRIANGLE_STRIP);
        for (int j = 0; j < numLineSegments+1; j++)
        {
          float vertOffset = vertLineSpacing*((tm*5)%1.f)+ maxOffset*sin(tm/1+j/5.f);
          
          int cx = (int)((segSpacing * j)*cam.width/surface.width);
          int cy = (int)((vertLineSpacing * i+vertOffset)*cam.height/surface.height);
          int curCamPixelIndex = cx+cy*cam.width;
          
          curCamPixelIndex = max(0, min(cam.pixels.length-1, curCamPixelIndex));
          float curCBrightness = ((cam.pixels[curCamPixelIndex] >> 16) & 0xFF) + 
                                 ((cam.pixels[curCamPixelIndex] >> 8) & 0xFF) + 
                                 ((cam.pixels[curCamPixelIndex]) & 0xFF); 
          curCBrightness /= (3.f);
          curCBrightness *= whiteFade;
          
          int vx = (int)((segSpacing * j)*cMovie.width/surface.width);
          int vy = (int)((vertLineSpacing * i+vertOffset)*cMovie.height/surface.height);
          int curVidPixelIndex = vx+vy*cMovie.width;
          
          curVidPixelIndex = max(0, min(cMovie.pixels.length-1, curVidPixelIndex));
          float curVBrightness = ((cMovie.pixels[curVidPixelIndex] >> 16) & 0xFF) + 
                                 ((cMovie.pixels[curVidPixelIndex] >> 8) & 0xFF) + 
                                 ((cMovie.pixels[curVidPixelIndex]) & 0xFF); 
          curVBrightness /= (3.f);
          curVBrightness *= whiteFade;
          
          float totalBright = curVBrightness*cVideoFade + curCBrightness*cCamFade;
          
          float ht = 2.f/3*((-128*whiteFade+128)+totalBright)*vertLineSpacing/255;
//          float ht = 2.f/3*(curBrightness)*vertLineSpacing/255;
          //        surface.fill(0xFF<<((j%3)*8)  | 0xFF000000);
          //        surface.stroke(0xFF<<((j%3)*8)  | 0xFF000000);
          surface.vertex(segSpacing * j, vertOffset+vertLineSpacing*i-ht/2);
          surface.vertex(segSpacing * j, vertOffset+vertLineSpacing*i+ht/2);
          //          vertCount += 2;
          //        rect(segSpacing * j, vertLineSpacing*i-ht/2, segSpacing, ht);
        }
        surface.endShape();
      }
    }
//    surface.loadPixels();
//    for(int i = 0; i < cMovie.width;i++)
//        for(int j = 0; j < cMovie.height; j++)
//         surface.pixels[i+j*cMovie.width] = cMovie.get(i,j);
//    surface.updatePixels();
    //    println("frameRate: " + frameRate + " vertcount: " + vertCount);
    
    surface.endDraw();
    
    println("cMovie: " + cMovie.pixels.length + "x" + cMovie.pixels.length/cMovie.width + "cam: " + cam.width + "x" + cam.height);
  }

  void draw()
  {
    
    image(surface, 0, 0, width, height);
    
//    image(cMovie,mouseX,mouseY);
println("cMovie: " +mouseX + ", " + mouseY);
  }
}

