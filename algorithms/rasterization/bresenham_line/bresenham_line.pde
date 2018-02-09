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
  
  
  // the points that the line connects
  Point p1 = new Point(10,10);
  Point p2 = new Point(img.width-10,50);
  
  
  // perform bresenham line rasterization
  img.loadPixels();
  bresenhamLine(p1, p2);
  img.updatePixels();
  
  
  noSmooth(); // dont smooth when scaling the image
  image(img, 0, 0, width, height); // show image
}


public void drawPixel(PImage image, int x, int y, int Color)
{
  int index = (image.height - y - 1) * image.width + x;
  image.pixels[index] = Color;
}


public void bresenhamLine(Point p1, Point p2)
{
  int dx = p2.x - p1.x;
  int dy = p2.y - p1.y;
  
  int d = 2 * dy - dx;
  int dE = 2 * dy;
  int dNE = 2 * (dy - dx);
  
  println("dx = " + dx + " , dy = " + dy + "\nd = " + d + " , dE = " + dE + " , dNE = " + dNE);
    
  int x = p1.x;
  int xend = p2.x;
  int y = p1.y;
  
  int error = d;
  
  if (xend < x) { int t = xend; xend = x; x = t; } // swap x and xend
  
  if (dx >= dy)
  {
    while (x < xend)
    {
      x++; // step in fast direction
      
      if (error <= 0) { error += dE; }
      else { y++; error += dNE; } // step in slow direction
      
      drawPixel(img, x, y, color(0));
    }
  }
  else
  {
    // the algorithm working the other direction
    println("dx < dy");
    
    d = 2 * dx - dy;
    dE = 2 * dx;
    dNE = 2 * (dx - dy);
    error = d;
    
    while (x < xend)
    {
      y++; // step in fast direction
      
      if (error <= 0) { error += dE; }
      else { x++; error += dNE; } // step in slow direction
      
      drawPixel(img, x, y, color(0));
    }
  }
}