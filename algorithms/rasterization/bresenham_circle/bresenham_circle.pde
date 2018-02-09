PImage img = new PImage(256,256);

void setup()
{
  size(512,512);
  
  // fill image with color
  img.loadPixels();
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int index = y * img.width + x;
      img.pixels[index] = color(210, 210, 255);
    }
  }
  img.updatePixels();
  
  
  // perform bresenham circle (midpoint algorithm)
  bresenhamCircle(img.width-1);
  
  noSmooth(); // dont smooth when scaling the image
  image(img, 0, 0, width, height); // show image
}


public void drawPixel(PImage image, int x, int y, int Color)
{
  int index = (image.height - y - 1) * image.width + x;
  image.pixels[index] = Color;
}


// draws first octant of the circle
public void bresenhamCircle(int radius)
{
  float d = 5/4 - radius;
  
  int x = 0;
  int y = radius;
  
  while (x < y)
  {
    if (d < 0) { d += 2*x     + 3; x++; }
    else       { d += 2*(x-y) + 5; x++; y--; }
    //println("Drawing at x = " + x + " , y = " + y);
    drawPixel(img, x, y, color(0)); 
  }
}