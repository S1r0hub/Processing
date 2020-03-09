// Code by github.com/S1r0hub.
// Created: 07.03.2020
// Processing Version: 3.5.4
//
// The following code shows how to create the sierpinski triangle fractal.
// It is a triangle containing triangles... just look at the image ;D
// This code includes two simple algorithms:
// - sierpinski_v1(..)
//   -> created always 3 new triangles per iteration
//   -> e.g. allows to color each individually (but relatively slow)
// - sierpinski_v2(..)
//   -> creates only a white triangle in the middle
//   -> much faster (used by default)
//
// Please refer to the source of this code when using it or the visualizations generated.
// Thank you!


// show window or write to file
final boolean genImage = false; // set true to generate HQ images

// export to image settings (ratio should be 4:3)
final String filename = "sierpinski";
final int img_width = 4 * 1000;
final int img_height = 3 * 1000;
PGraphics img_pg; // don't modify

// padding from window frame
final int p = 10;

// base triangle
Vertex l, t, r;

// max depth in recursion
// (use max. 8, otherwise set genImage true and export the result)
final int depth_max = 6;


void setup() {

  size(800, 600); // use 4:3 ratio for best results
  
  if (genImage) {
    
    println("Creating image...");
    surface.setVisible(false);
    
    // base triangle
    l = new Vertex(p, img_height-p); // left
    t = new Vertex((img_width-p)*0.5f, p); // top
    r = new Vertex(img_width-p, img_height-p); // right
    
    img_pg = createGraphics(img_width, img_height);
    img_pg.beginDraw();
    img_pg.background(255);
    img_pg.noStroke();
  }
  else {
    
    surface.setTitle("Sierpinski");
    
    // base triangle
    l = new Vertex(p, height-p); // left
    t = new Vertex((width-p)*0.5f, p); // top
    r = new Vertex(width-p, height-p); // right
      
    background(255);
    noStroke();
  }

  //sierpinski_v1(l, t, r, 0);
  sierpinski_v2(l, t, r, 0);
  
  // save to file
  if (genImage) {
    img_pg.endDraw();
    println("Storing image...");
    String img_name = filename + "_w" + String.valueOf(img_width) + "-h" + String.valueOf(img_height) + ".png";
    img_pg.save(img_name);
    println("Saved \"" + img_name + "\" inside sketch folder.");
    exit();
  }
}


/** Draws triangle to screen or graphics. */
void drawTriangle(Vertex p1, Vertex p2, Vertex p3, int fillColor) {
  
  if (genImage) {
    img_pg.fill(fillColor);
    img_pg.triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    return;
  }
  
  fill(fillColor);
  triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
}


/** Sierpinski v1 - drawing 3 new triangles. */
void sierpinski_v1(Vertex l, Vertex t, Vertex r, int depth) {

  if (depth > depth_max) { return; }
  
  // base triangle (in black)
  if (depth == 0) {
    drawTriangle(l, r, t, 0);
    sierpinski_v1(l, r, t, depth+1);
    return;
  }
  
  // top triangle
  Vertex tl = Vertex.half(l, t);
  Vertex tt = Vertex.copy(t);
  Vertex tr = Vertex.half(r, t);
  drawTriangle(tl, tt, tr, 0);
  
  // middle triangle
  Vertex ml = Vertex.copy(tl);
  Vertex mt = Vertex.half(l, r);
  Vertex mr = Vertex.copy(tr);
  drawTriangle(ml, mt, mr, 255);
  
  // left triangle
  Vertex ll = Vertex.copy(l);
  Vertex lt = Vertex.copy(tl);
  Vertex lr = Vertex.copy(mt);
  drawTriangle(ll, lt, lr, 0);
  
  // right triangle
  Vertex rl = Vertex.copy(mt);
  Vertex rt = Vertex.copy(tr);
  Vertex rr = Vertex.copy(r);
  drawTriangle(rl, rt, rr, 0);
  
  // start recursively draw next 3 triangles
  sierpinski_v1(tl, tt, tr, depth+1);
  sierpinski_v1(ll, lt, lr, depth+1);
  sierpinski_v1(rl, rt, rr, depth+1);
}


/** Sierpinski v2 - just drawing a single triangle (white). */
void sierpinski_v2(Vertex l, Vertex t, Vertex r, int depth) {
  
  if (depth > depth_max) { return; }
  
  // base triangle (in black)
  if (depth == 0) {
    drawTriangle(l, r, t, 0);
    sierpinski_v2(l, r, t, depth+1);
    return;
  }
  
  // top triangle
  Vertex lt = Vertex.half(l, t);
  Vertex lr = Vertex.half(l, r);
  Vertex rt = Vertex.half(r, t);
  drawTriangle(lt, lr, rt, 255);
  
  // start recursively draw next 3 triangles
  sierpinski_v2(l, lr, lt, depth+1);
  sierpinski_v2(lt, t, rt, depth+1);
  sierpinski_v2(lr, rt, r, depth+1);
}
