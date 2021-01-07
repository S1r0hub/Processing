/*
 * Manages the Game Of Life Instance
 * Created by github.com/S1r0hub (Jan. 2021)
*/
class GOL {
  
  private final int w, h;
  private boolean[][] grid; // holds current cell states
  private boolean[][] neighbours; // holds neighbour counts
  private PImage img; // image to draw (we could use this as grid as well)
  private int iterations = 0;
  
  // [0] holds the state in case that 0 neighbours are alive, ...
  int[] rules = new int[9];
  
  // Create GOL instance and set default rules.
  public GOL(int rows, int columns) {
    grid = new boolean[rows][columns];
    neighbours = new boolean[rows][columns];
    h = rows; w = columns;
    img = createImage(w, h, RGB);
    setDefaultRules();
  }
  
  // Default rules defined by Conway.
  public void setDefaultRules() {
    rules = new int[]{
      -1, -1, 0,
      1, -1, -1,
      -1, -1, -1
    };
  }
  
  // Get current grid as image.
  public PImage getImage() { return img; }
  
  public int getIterations() { return iterations; }
  
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
    
    // Get next state for all cells
    // ToDo: parallelization
    int changed = 0;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        int n_active = getNeighboursActive(x,y);        
        neighbours[y][x] = applyRules(grid[y][x], n_active);
        if (neighbours[y][x] != grid[y][x]) { changed++; }
        //println("[" + x + ", " + y + "] n=" + n_active + ", a=" + grid[y][x] + " => " + neighbours[y][x]);
      }
    }
    
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
}
