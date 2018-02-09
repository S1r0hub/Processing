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
  
  
  // perform integer DDA
  img.loadPixels();
  integerDDA(p1, p2);
  img.updatePixels();
  
  
  noSmooth(); // dont smooth when scaling the image
  image(img, 0, 0, width, height); // show image
}


public void drawPixel(PImage image, int x, int y, int Color)
{
  int index = (image.height - y - 1) * image.width + x;
  image.pixels[index] = Color;
}


public void integerDDA(Point p1, Point p2)
{
  // integer dda
  int d_x = (p2.x - p1.x);
  int d_y = (p2.y - p1.y);
  int x = p1.x, y = p1.y;
  int rest = 0;
 
  drawPixel(img, x, y, color(0));
  
  for (int i = p1.x; i < p2.x; i++)
  {
    x++;
    rest += d_y;
    
    if (rest >= d_x)
    {
      y++;
      rest -= d_x;
    }
    
    drawPixel(img, x, y, color(0));
  }
}