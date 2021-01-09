// Easy Game Of Life Implementation
// by github.com/S1r0hub (Jan. 2021)

GOL gol = new GOL(128, 128); // should be min 128x128 currently
float wait_frames_ms = 100; // time to wait between steps in ms
int steps_per_frame = 1; // compute x steps per frame


// ------------------ DO NOT CHANGE ------------------ //
int last_time = 0;
boolean stop = false;
int cells_changed_total = 0, cells_changed_last = 0;
float next_wait_time = 1;
UIGraph g1;
// --------------------------------------------------- //


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
  update(3000); // draw initial GOL image and wait 3 seconds
}

void draw() {
  
  if (stop) { return; }
  if (millis() > last_time + int(next_wait_time)) { update(wait_frames_ms); }
}

void update(float delay_ms) {
  
  // draw background and save time of update
  last_time = millis();
  background(color(50,50,50));

  // set next wait time
  if (delay_ms < 0.01) { delay_ms = 0.01; } 
  next_wait_time = delay_ms;

  // set simulation in left corner of window
  final int max_img_w = width < height ? width : height;
  final int max_img_h = height < width ? height : width;
  image(gol.getImage(), 0, 0, max_img_w, max_img_h); // draw image

  // show simulation data on screen
  final int space = 50;
  final int fontHeight = 20;
  int text_x_start = max_img_w + space;
  int text_x = text_x_start;
  int text_y = space;
  text("Iterations: " + gol.getIterations(), text_x, text_y);
  text("Cells", text_x, (text_y += fontHeight * 1.5));
  text("Total: " + gol.getCellsTotal(), (text_x += 20), (text_y += fontHeight));
  text("Alive: " + gol.getCellsAlive() +  " (" + gol.getCellsAlivePerc() + " %)", text_x, (text_y += fontHeight));
  text("Deaths: " + gol.getCellDeaths(), text_x, (text_y += fontHeight));
  text("Births: " + gol.getCellsBorn(), text_x, (text_y += fontHeight));
  text("Birth / Death Ratio:  " + gol.getCellsBornDeathRatio(), text_x, (text_y += fontHeight));
  text_x = text_x_start;

  // create graphs if not done yet
  if (g1 == null) {
    g1 = new UIGraph(text_x, (text_y += fontHeight), width-text_x-space, 200);
    g1.setTitle("Cells Alive");
    g1.setLabelX("Iterations");
    g1.setLabelY("Cells");
  }
  
  // draw graphs
  g1.add(gol.getCellsAlive());
  g1.draw(true);

  // compute x next steps
  int cells_changed = 0;
  steps_per_frame = max(1, steps_per_frame);
  for (int i = 0; i < steps_per_frame; i++) { cells_changed += gol.step(); }
  int iters = gol.getIterations();
  cells_changed_total += cells_changed;
  if (cells_changed < 1) {
    println("End after " + iters + " iterations.");
    stop = true;
  }

  // print iteration information
  if (iters > 0 && iters % 50 == 0) {
    println("Iterations: " + iters + ", cells changed: " + (cells_changed_total-cells_changed_last) +
            ", cells changed total: " + cells_changed_total);
    cells_changed_last = cells_changed_total;
  }
}
