/*
 * Manages the Game Of Life Instance
 * Created by github.com/S1r0hub (Jan. 2021)
*/
class GOL {
  
  private final int x, y, w, h;
  private boolean[][] grid; // holds current cell states
  private boolean[][] neighbours; // holds neighbour counts
  private PImage img; // image to draw (we could use this as grid as well)
  private int iterations = 0;
  private int cells_alive = 0, cells_born = 0, cells_died = 0;
  private int cells_born_last = 0, cells_died_last = 0;
  
  // [0] holds the state in case that 0 neighbours are alive, ...
  int[] rules = new int[9];
  
  // Create GOL instance and set default rules.
  public GOL(int pos_x, int pos_y, int rows, int columns) {
    this.grid = new boolean[rows][columns];
    this.neighbours = new boolean[rows][columns];
    this.x = pos_x; this.y = pos_y;
    this.h = rows; this.w = columns;
    this.img = createImage(w, h, RGB);
    this.setDefaultRules();
  }
  
  // Default rules defined by Conway.
  public void setDefaultRules() {
    rules = new int[]{
      -1, -1, 0,
      1, -1, -1,
      -1, -1, -1
    };
  }
  
  public int getX() { return x; }
  public int getY() { return y; }
  public int getWidth() { return w; }
  public int getHeight() { return h; }
  
  // Get current grid as image.
  public PImage getImage() { return img; }
  public int getIterations() { return iterations; }
  public int getCellsTotal() { return w*h; }
  
  public int getCellsAlive() { return cells_alive; }
  public float getCellsAlivePerc() { return getPerc(cells_alive / (float) getCellsTotal(), 2, 100); }
  
  public int getCellsDead() { return getCellsTotal() - getCellsAlive(); }
  public float getCellsDeadPerc() { return getPerc(getCellsDead() / (float) getCellsTotal(), 2, 100); }
  
  public int getCellsDied(boolean total) { return total ? cells_died : cells_died_last; }
  public int getCellsBorn(boolean total) { return total ? cells_born : cells_born_last; }
  public float getCellsBornDeathRatio(boolean total) { return getPerc(getCellsBorn(total) / (float) getCellsDied(total), 4, 1); }
  
  // Get rounded percentage (e.g. for 0.155 => 15,50 %) 
  public float getPerc(float perc, int digits, float multiplier) {
    if (digits < 1) { return round(perc * 100); }
    float dfac = pow(10, digits);
    return round(perc * dfac * multiplier) / dfac;
  }
  
  // Set rules for active neighbours 0-8.
  // state_change: -1 = kill cell, 0 = stay (alive or dead), 1 = set alive
  public void setRule(int active_neighbours, int state_change) {
    if (active_neighbours < 0 || active_neighbours >= rules.length) { return; }
    rules[active_neighbours] = state_change;
  }

  // apply modulo like in python to keep value in bounds
  private int applyMod(int v, int m) {
    int out = v % m;
    if (out < 0) { return m + out; }
    return out;
  }

  // Retuns "alive" state of the cell.
  // Always in bounds of the grid.
  // This means always x mod width and y mod height.
  public boolean getCell(int x, int y) {
    if (x < 0 || x > w) { x = applyMod(x, w-1); }
    if (y < 0 || y > h) { y = applyMod(y, h-1); }
    return grid[y][x];
  }

  // Set cell state to be alive or dead.
  public void setCell(int x, int y, boolean alive) {
    grid[y][x] = alive;
    neighbours[y][x] = alive;
    img.set(x, y, getColor(alive, false)); 
  }
  
  // Set state of a block of cells.
  public void setCells(int x_from, int y_from, int x_to, int y_to, boolean alive) {
    for (int y = y_from; y <= y_to; y++) {
      for (int x = x_from; x <= x_to; x++) {
        setCell(x, y, alive);
      }
    }
  }
  
  // Returns the color for given cell state and its previous state.
  // This way, we can color born cells green and cells that died red.
  public color getColor(boolean alive_state, boolean previous_state) {
    if (alive_state == previous_state) { return alive_state ? color(255) : color(0); }
    if (alive_state == true && previous_state == false) { return color(100,255,100); } // green for cell born
    return color(80,10,10); // red for cell died
  }
  
  // Process a single step of the simulation.
  // Returns how many cells changed their state.
  public int step() {
    
    int changed = 0, c_alive = 0, deaths = 0, born = 0;
    
    // Get next state for all cells
    // ToDo: parallelization
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        
        int n_active = getNeighboursActive(x,y);
        boolean alive_prev = grid[y][x];
        boolean cell_alive = applyRules(alive_prev, n_active);
        neighbours[y][x] = cell_alive;
        
        if (cell_alive) { c_alive++; }
        if (cell_alive != alive_prev) {
          changed++;
          if (alive_prev && !cell_alive) { deaths++; }
          else { born++; }
        }
        //println("[" + x + ", " + y + "] n=" + n_active + ", a=" + grid[y][x] + " => " + neighbours[y][x]);
      }
    }
    
    // update returned alive count
    cells_alive = c_alive;
    cells_born += (cells_born_last = born);
    cells_died += (cells_died_last = deaths);
    
    // Apply the computed state (make it the current one).
    // Updates the image and sets the colors.
    img.loadPixels();
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        img.pixels[y * w + x] = getColor(neighbours[y][x], grid[y][x]);
        grid[y][x] = neighbours[y][x];
      }
    }
    img.updatePixels();

    iterations++;
    return changed;
  }

  // Counts active neighbours of the given cell.
  public int getNeighboursActive(int cell_x, int cell_y) {
    
    // count active neighbour cells
    int active = 0;
    for (int y = -1; y <= 1; y++) {
      int idx_y = applyMod(cell_y+y, h);
      for (int x = -1; x <= 1; x++) {
        if (x == 0 && y == 0) { continue; } // skip this cell
        int idx_x = applyMod(cell_x+x, w);
        if (grid[idx_y][idx_x]) { active++; }
      }
    }
    return active;
  }

  // Returns the state of the cell considering its current state,
  // and the active neighbours count applied to the rules.
  public boolean applyRules(boolean cell_alive, int active_neighbours) { 
    switch (rules[active_neighbours]) {
      case -1: return false;
      case 1: return true;
    }
    return cell_alive;
  }


  // ----------------------------------------------------------------------
  // INTERACTIVITY
  
  // Checks if the mouse click was on a cell.
  // Changes the cells state accordingly to its current state.
  public boolean click(int mouse_x, int mouse_y, int img_width, int img_height) {

    if (mouse_x < this.getX() || mouse_y < this.getY()) { return false; }
    if (mouse_x >= this.getX() + img_width) { return false; }
    if (mouse_y >= this.getY() + img_height) { return false; }
    
    // map values to cell index
    int x = floor((mouse_x - this.getX()) / (float) img_width * getWidth());
    int y = floor((mouse_y - this.getY()) / (float) img_height * getHeight());
    
    println("Click inside: cell: x="+x+", y="+y);
    setCell(x, y, !getCell(x,y));
    return true;
  }
}
