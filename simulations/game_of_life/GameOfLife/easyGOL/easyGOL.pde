// Easy Game Of Life Implementation
// by github.com/S1r0hub (Jan. 2021)

GOL gol = new GOL(128, 128);
float wait_frames = 0.1; // time to wait between steps in ms

int last_time = 0;
boolean stop = false;
int cells_changed_total = 0, cells_changed_last = 0;

void setup() {
  
  size(1024, 512);
  
  // ToDo: improve
  // resize if needed
  final int w_max = 1024 > displayWidth ? displayWidth : 1024;
  final int h_max = 512 > displayHeight ? displayHeight : 512; 
  if (w_max != width || h_max != height) {
    //frame.setResizable(true); // deprecated
    //frame.resize(width=w_max, height=h_max); // deprecated
    println("Resize enabled.");
    PSurface surf = getSurface();
    surf.setResizable(true);
    surf.setSize(w_max, h_max);
  }
  
  // create a block
  gol.setCells(5, 5, 6, 6, true);
  
  // create 3 vertical block lines
  gol.setCells(50, 4, 51, 10, true);
  gol.setCells(50, 12, 51, 30, true);
  gol.setCells(50, 85, 51, 105, true);
  
  // another block on top right
  gol.setCells(90, 5, 92, 25, true);
  gol.setCells(90, 40, 93, 70, true);
  
  // create blinker (short line of 3 active cells)
  gol.setCells(10, 10, 12, 10, true);
  
  // create glider
  gol.setCells(20, 20, 22, 20, true);
  gol.setCell(22, 19, true);
  gol.setCell(21, 18, true);
  
  // create glider
  gol.setCells(20+10, 20+10, 22+10, 20+10, true);
  gol.setCell(22+10, 19+10, true);
  gol.setCell(21+10, 18+10, true);
  
  noSmooth(); // disable smoothing of image
  update(); // draw initial GOL image
  delay(3000); // wait to show initial grid
}

void draw() {
  
  if (stop) { return; }
  if (millis() > last_time + int(wait_frames * 1000)) { update(); }
}

void update() {
  
  last_time = millis();
  background(color(50,50,50));
  
  // set simulation in left corner of window
  final int max_img_w = width < height ? width : height;
  final int max_img_h = height < width ? height : width;
  image(gol.getImage(), 0, 0, max_img_w, max_img_h); // draw image

  // show simulation data on screen
  final int space = 50;
  final int fontHeight = 20;
  int text_x = max_img_w + space;
  int text_y = space;
  text("Iterations: " + gol.getIterations(), text_x, text_y);
  text("Cells", text_x, (text_y += fontHeight * 1.5));
  text("Total: " + gol.getCellsTotal(), (text_x += 20), (text_y += fontHeight));
  text("Alive: " + gol.getCellsAlive() +  " (" + gol.getCellsAlive(true) + " %)", text_x, (text_y += fontHeight));
  text("Dead:  " + gol.getCellsAlive() +  " (" + gol.getCellsDead(true) + " %)", text_x, (text_y += fontHeight));

  int cells_changed = gol.step(); // compute next step
  int iters = gol.getIterations();
  cells_changed_total += cells_changed;
  if (cells_changed == 0) {
    println("End after " + iters + " iterations.");
    stop = true;
  }

  if (iters > 0 && iters % 50 == 0) {
    println("Iterations: " + iters + ", cells changed: " + (cells_changed_total-cells_changed_last) +
            ", cells changed total: " + cells_changed_total);
    cells_changed_last = cells_changed_total;
  }
}
