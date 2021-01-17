// Easy Game Of Life Implementation
// by github.com/S1r0hub (Jan. 2021)

GOL gol = new GOL(0, 0, 128, 128); // should be min 128x128 currently
int wait_frames_ms = 100; // time to wait between steps in ms
int steps_per_frame = 1; // compute x steps per frame


// ------------------ DO NOT CHANGE ------------------ //
int last_time = 0;
boolean stop = false;
int cells_changed_total = 0, cells_changed_last = 0;
int next_wait_time = 1;
int max_img_w, max_img_h;
boolean mousePress = false;
int timestamp_mouse = 0;
UIGraph g1, g2;
// --------------------------------------------------- //


void setup() {
  
  size(1200, 600);

  // for GOL image
  max_img_w = width < height ? width : height;
  max_img_h = height < width ? height : width;

  /*
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
  */
  
  // create a block
  gol.setCells(5, 5, 6, 6, true);
  
  // create 3 vertical block lines
  gol.setCells(50, 4, 51, 10, true);
  gol.setCells(50, 12, 51, 30, true);
  gol.setCells(50, 85, 51, 105, true);
  
  // another block on top right
  gol.setCells(90, 5, 92, 25, true);
  gol.setCells(90, 40, 93, 70, true);
  
  // blocks on bottom right
  gol.setCells(85, 85, 90, 90, true);
  gol.setCells(92, 92, 95, 95, true);
  gol.setCells(95, 95, 100, 100, true);
  gol.setCells(100, 100, 110, 110, true);
  gol.setCells(103, 103, 107, 107, false);
  
  // for size > 210
  if (gol.getWidth() > 210 && gol.getHeight() > 210) {
    gol.setCells(150, 150, 200, 200, true);
    gol.setCells(160, 160, 190, 190, false);
    gol.setCells(170, 170, 180, 180, true);
    gol.setCells(174, 174, 176, 176, false);
    gol.setCells(144, 152, 146, 198, true); // line right
    gol.setCells(204, 152, 206, 198, true); // line left
    gol.setCells(152, 144, 198, 146, true); // line above
    gol.setCells(152, 204, 198, 206, true); // line below
  }
  
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
  updateSimulation(3000, false); // draw initial GOL image and wait 3 seconds
}

void draw() {
  
  // check mouse interaction
  if (mousePressed) {
    
    // check that mouse is not "hold" and some time passed
    if (!mousePress) {
      mousePress = true;
      timestamp_mouse = millis();
      if (gol.click(mouseX, mouseY, max_img_w, max_img_h)) {
        updateSimulation(next_wait_time, false);
      }
    }
  }
  else if (millis() >= timestamp_mouse + 200) {
    mousePress = false;
  }

  // simulation update
  if (stop) { updateSimulation(wait_frames_ms, false); }
  if (millis() >= last_time + next_wait_time) {
    updateSimulation(wait_frames_ms, true);
  }
}

void updateSimulation(int delay_ms, boolean compute_steps) {
  
  // save time of update and set next wait time
  last_time = millis();
  if (delay_ms < 1) { delay_ms = 1; } 
  next_wait_time = delay_ms;
  
  // clear screen
  background(color(50,50,50));

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
  text("Deaths: " + gol.getCellsDied(true), text_x, (text_y += fontHeight));
  text("Births: " + gol.getCellsBorn(true), text_x, (text_y += fontHeight));
  text("Birth / Death Ratio:  " + gol.getCellsBornDeathRatio(true), text_x, (text_y += fontHeight));
  text_x = text_x_start;

  // -------------------------------------------------------
  // initialize graphs for the first time
  if (g1 == null) {
    g1 = new UIGraph(text_x, (text_y += fontHeight), width-text_x-space, 140);
    g1.setTitle("Cells Alive");
    g1.setLabelX("Iterations");
    g1.setLabelY("Cells");
    g1.addLine("Cells Alive", color(20, 200, 20), 1);
    g1.setMaxItems(400);
    g1.setFixedMin(0);
    g1.setKeepMax(true);
  }
  
  if (g2 == null) {
    g2 = new UIGraph(text_x, (text_y += 160), width-text_x-space, 140);
    g2.setTitle("Births and Deaths");
    g2.setLabelX("Iterations");
    g2.setLabelY("Cells");
    g2.addLine("Cells Born", color(20, 200, 20), 1);
    g2.addLine("Cells Died", color(190, 30, 30), 1);
    g2.setMaxItems(100);
    g2.setFixedMin(0);
    g2.setKeepMax(true);
  }
  // -------------------------------------------------------

  // compute x next steps
  int cells_changed = 0, cells_born = 0, cells_died = 0;
  steps_per_frame = compute_steps ? max(1, steps_per_frame) : 0;
  for (int i = 0; i < steps_per_frame; i++) {
    cells_changed += gol.step();
    cells_born += gol.getCellsBorn(false);
    cells_died += gol.getCellsDied(false);
  }
  
  int iters = gol.getIterations();
  cells_changed_total += cells_changed;
  if (compute_steps && cells_changed < 1) {
    println("End after " + iters + " iterations.");
    stop = true;
  }

  // update image after simulation step
  image(gol.getImage(), 0, 0, max_img_w, max_img_h); // draw image

  // draw graphs that depend on last iteration data
  g1.add(gol.getCellsAlive());
  if (g1 != null) { g1.draw(true); }
  
  g2.add(cells_born, cells_died);
  if (g2 != null) { g2.draw(true); }

  // print iteration information
  if (iters > 0 && iters % 50 == 0) {
    println("Iterations: " + iters + ", cells changed: " + (cells_changed_total-cells_changed_last) +
            ", cells changed total: " + cells_changed_total);
    cells_changed_last = cells_changed_total;
  }
}
