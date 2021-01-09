// Code by github.com/S1r0hub
// Created: 08.03.2020
// Processing Version: 3.5.4
//
// This code creates the famous mandelbrot set.
// Interaction is possible using the following keys:
// [RIGHT] - move right
// [LEFT] - move left
// [UP] - move up
// [DOWN] - move down
// [W] - zoom in
// [S] - zoom out
// [M] - increase maximum steps until decision "in/out of set" is made
// [N] - reduce max. steps
// [SPACE] - pause/continue rendering
// 
// The following is a first version.
// There are lots of possibilities to improve code and result.
// This code should just give an idea how the creation works.
//
// If you use it or any of the results generated by it,
// please reference this project as the source.
// Thanks.


// number of pixels to draw per frame
final int pNum = 50000;

int mandel_steps_max = 30;
float mandel_dist_max = 4;

// zoom, frame zoom and position
double zoom = 0, fzoom = 0;
double pos_x = 0, pos_y = 0;

// base frame around mandelbrot set
double bx_min = -2, bx_max = 1;
double by_min = -1, by_max = 1;

// changing values for frame positioning
double x_min = bx_min, x_max = bx_max;
double y_min = by_min, y_max = by_max;

// iteration step size per axis
double frame_width, frame_height;
boolean paused = false;
PGraphics pg;

// x and y counter for drawing (do not modify!)
int x = 0;
int y = 0;


void setup() {
  
  // setup window
  size(900, 600);
  surface.setTitle("Mandelbrot");
  frameRate(30);
  background(255);
  pg = createGraphics(width, height);
  
  // apply zoom and position
  applyZoomAndPos();
}


// restart drawing
void restart() {
  x = y = 0;
  paused = false;
  applyZoomAndPos();
  clear();
  pg.clear();
  background(255);
}


// apply zoom and position settings
void applyZoomAndPos() {
  
  x_min = (bx_min - fzoom) * (1 / (zoom + 1)) + pos_x;
  x_max = (bx_max + fzoom) * (1 / (zoom + 1)) + pos_x;
  y_min = (by_min - fzoom) * (1 / (zoom + 1)) - pos_y;
  y_max = (by_max + fzoom) * (1 / (zoom + 1)) - pos_y;

  frame_width = x_max - x_min;
  frame_height = y_max - y_min;
}


void draw() {
  
  keyCheck();
  
  if (y >= height || paused) { return; }
  
  pg.beginDraw();
  for (int i = 0; i < pNum; i++) {
    
    // create the complex number corresponding to the pixel
    Complex c = new Complex(
      x_min + x / float(width) * frame_width,
      y_min + y / float(height) * frame_height
    );
    
    // get amount of steps for coloring the pixel
    int steps = M(c, mandel_steps_max, mandel_dist_max);
    
    int col = color(255);
    if (steps < 0) { col = color(0); }
    else if (steps > 0) {
      float p = steps / float(mandel_steps_max);
      col = color(
        p * 0   + (1-p) * 0,
        p * 255 + (1-p) * 0,
        p * 0   + (1-p) * 255
      );
    }
    
    // apply pixel color
    pg.set(x, y, col);
    
    x++;
    if (x >= width) { x = 0; y++; }
    if (y >= height) { break; }
  }
  pg.endDraw();
  
  image(pg, 0, 0);
}


/**
 * Returns -1 if inside mandelbrot set,
 * otherwise steps until > dist_max (default 2 or 4).
 */
int M(Complex c, int steps_max, float dist_max) {
  
  Complex prev_z = new Complex(0, 0);
  for (int i = 0; i < steps_max; i++) {
    prev_z = f(prev_z, c);
    if (prev_z.distanceToZero() > dist_max) { return i; }
  }
  
  return -1;
}

Complex f(Complex z, Complex c) {
  return Complex.add(Complex.mul(z,z), c);
}


void keyCheck() {
  
  if (keyPressed) {
    if (key == ' ') { paused = !paused; }
    else if (key == 'r') { restart(); }
    else if (keyCode == LEFT) {
      pos_x -= frame_width * 0.01f; restart();
    }
    else if (keyCode == RIGHT) {
      pos_x += frame_width * 0.01f; restart();
    }
    else if (keyCode == UP) {
      pos_y += frame_height * 0.01f; restart();
    }
    else if (keyCode == DOWN) {
      pos_y -= frame_height * 0.01f; restart();
    }
    else if (key == 'w') {
      if (zoom == 0) { zoom = 1; }
      else { zoom *= 2; }
      restart();
    }
    else if (key == 's') {
      if (zoom < 0) { return; }
      if (zoom > 0 && zoom < 1.5) { zoom = 0; }
      else { zoom /= 2; }
      restart();
    }
    else if (key == 'm') {
      mandel_steps_max += 1; restart();
    }
    else if (key == 'n') {
      if (mandel_steps_max <= 5) { return; }
      mandel_steps_max -= 1; restart();
    }
  }
}