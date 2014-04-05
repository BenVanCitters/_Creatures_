class Sunset
{
  PGraphics sunset;
  float x, y;
  float y1, y2;
  float h, s, b, a;
  float sw;

  public Sunset()
  {
    createSunset();
  }

  void createSunset()
  {
    sunset = createGraphics(900,600,P2D);
    sunset.beginDraw();
    sunset.colorMode(HSB);
    sunset.background(#025BA7);
   
    sunset.ellipseMode(CENTER);
    sunset.endDraw(); 
  }
  void drawSunset()
  {
    sunset.beginDraw();
    //sky
    sunset.noStroke();
    sunset.fill(y/sunset.height*255, 128, 64, 2);
    sunset.rect(0, 0, sunset.width, sunset.height*.17);
   
    // sun
    sunset.fill(4, 196, 255, 16);
    sunset.noStroke();
    //stroke(255,1);
    sunset.ellipse(sunset.width*.5+random(-5, 5), sunset.height*.1+random(-5, 5), random(sunset.height*.07, sunset.height*.11), random(sunset.height*.07, sunset.height*.11));
   
    // sun reflection
    sunset.fill(4, 196, 255, 8);
    sunset.noStroke();
    sunset.ellipse(sunset.width*.5+random(-22, 22), sunset.height*.55+random(-5, 5), random(sunset.height*.044, sunset.height*.077), random(sunset.height*.77, sunset.height*.88));
   
   
    // sun bursts
    sunset.noStroke();
   
    a = map(y, 0, sunset.height, 3, 2) + random(-1, 1);
    s = 211;
   
    h = map(y, 0, sunset.height, 16, 8) + random(-5, 5);
    b = 128;
   
    sunset.fill(h, s, 255, a*.5);
    sunset.ellipse(sunset.width*.5, sunset.height*.17+random(-5, 5), sunset.width*1.4, y*.17);
   
    a *= .5;
    s *=.4;
    sunset.fill(255-h, s, b, a);
    sunset.ellipse(sunset.width*.5, sunset.height*.1, sunset.width*2, y*4);
   
    horzLine(77, .17);
   
    // horizon
    sunset.stroke(4, 196, 255, random(1, 11));
    sunset.line(0, sunset.height*.17+random(-33, 33), sunset.width, sunset.height*.15+random(-33, 33) );
   
   
    y+=.4;
    if (y>sunset.height) y=0;
    sunset.endDraw(); 
  }
  
 void horzLine(int amount, float topY) {
   for (int i=0; i<amount; i++) {
      
    y1 = random(sunset.height*topY, sunset.height);
 
    h = map(y1, 0, sunset.height, 96, 8); //random(96, 128);
    s = map(y1, 0, sunset.height, 8, 255); // random(22, 255);
    b = map(y1, 0, sunset.height, 64, 196); // random(22, 255);
    a =  map(y1, 0, sunset.height, 44, 11);
 
    sunset.stroke(h, s, b, a);
 
    x = random(sunset.width);
 
   // y2 = random(height*topY, height*1.5);
 
    //line(x, y1 , x+random(-10,10), y2 );
 
    sunset.strokeWeight(random(8));
    sunset.line(0, y1+random(-33,33), sunset.width, y1+random(-33,33));
  }
 }
  public void draw()
  {
    drawSunset();
    image(sunset,0,0); 
  }
}
