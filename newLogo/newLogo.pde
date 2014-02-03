import ddf.minim.*;
import processing.video.*;

Capture cam;
PImage tex;
Minim minim;
AudioInput in;
PImage logo_inv;

void setup()
{
  size(displayWidth,displayHeight,P2D);
  background(0);
  noCursor();
  textureMode(NORMAL);
  imageMode(CENTER);
  noStroke();
  
  //init camera
  int camW = 640;
  int camH = 480;
  cam = new Capture(this, camW, camH);
  cam.start();
  
  //init images/surfaces
  tex = createImage(camW,camH,RGB);
  logo_inv = loadImage("logo_inv_big.png");
  
  //init audio
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO,512);
}

//per-pixel camera image inversion
//passes inverted pixel values over to the 'tex' image
//inverting the pixels in place on 'cam' has unpredictable
//results
void invertAndApplyTex(float tm)
{
  float sn = cos(tm);
  tex.loadPixels();
  cam.loadPixels();
  
  for(int i = 0; i < cam.pixels.length; i++)
  {
    int x = i%cam.width;
    int y = i/cam.width;
    int newindex = (cam.width-x-1)+y*cam.width;
    float r = red(cam.pixels[newindex]);
    r = (r-128)*sn + 128;
    float g = green(cam.pixels[newindex]);
    g = (g-128)*sn + 128;
    float b = blue(cam.pixels[newindex]);  
    b = (b-128)*sn + 128;
    tex.pixels[i] = color(r,g,b);
  }
  tex.updatePixels();
}

void draw()
{
  float samps[] = in.mix.toArray();
  float tm = millis()/3000.f;
  if (cam.available() == true) 
  {
    cam.read();
    invertAndApplyTex(tm);
  }
  
  //positoin and render the webcam image...
  pushMatrix();
    translate(width/2,height/2);
  //  scale(2.23);//size for big monitor
    float s = 3.3;//mouseY * 5.f/height;
    println("s: " + s);
    scale(s);//size for laptop monitor 1.7
    //3.3 for big monitor
    tint(255);
    image(tex,0,0);
  popMatrix();
  
  //render the 'glitched' creature logo
  int foreTint = color(255.f*(cos(PI+tm)+1)/2.f);
  int curTintC = color(random(255),random(255),random(255));
  
  beginShape(TRIANGLE_STRIP);
  texture(logo_inv);
  tint(foreTint);
  int sampL = samps.length;
  for(int i = 0; i < sampL; i++)
  {
    //set color based on the particular sample's loudness 
    tint( lerpColor(foreTint,curTintC, abs(samps[i])) );
    float disp = samps[i]*140.f;
    vertex(disp,i*height*1.f/(sampL-1)
      ,0,i*1.f/(sampL-1));
    vertex(width+disp,i*height*1.f/(sampL-1)
      ,1,i*1.f/(sampL-1));
  }
  endShape();
  println("frameRate: " + frameRate);
}
