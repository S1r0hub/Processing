/*
 * To create simple graphs.
 * Pivot is in the top left corner of the graph.
 * Created by github.com/S1r0hub (Jan. 2021)
 *
 * ToDo:
 * [X] Multiple lines in one graph
 * [X] Option to keep or set min/max of y-Axis
 * [ ] Legend (as optional feature)
 * [ ] Some more methods to change specific settings
 * [ ] Make lines editable (methods)
 * [ ] Improve label size and select a font
*/
class UIGraph {

  private PGraphics pg; // base graph layout (only build once)
  private PGraphics pgd; // data drawn to graph
  private boolean update_layout = true, first_draw = true;
  
  private UIGraphSettings settings = new UIGraphSettings();
  private final int[] dim; // pos and size

  // The amount of line entries is always synchronized.
  // This means one can only add/remove an entry to/from all lines.
  private ArrayList<UIGraphLine> lines = new ArrayList<UIGraphLine>();
  
  // ToDo: make usable as settings
  private int show_data_from = -1; // -1 means from [0]
  private int show_data_to = -1; // -1 means to [max]


  // ----------------------------------------------------------------------
  // Constructor
  UIGraph(int x, int y, int w, int h) { this(x, y, w, h, ""); }
  UIGraph(int x, int y, int w, int h, String title) {
    this.dim = new int[]{x, y, w, h};
    settings.title = title;
    pg = createGraphics(w,h);
    pgd = createGraphics(w,h);
  }


  // ----------------------------------------------------------------------
  // Getter
  public int getX() { return this.dim[0]; }
  public int getY() { return this.dim[1]; }
  public int getWidth() { return this.dim[2]; }
  public int getHeight() { return this.dim[3]; }

  public String getTitle() { return this.settings.title; }
  public String getLabelX() { return this.settings.label_x; }
  public String getLabelY() { return this.settings.label_y; }

  public float getStepSize() { return this.settings.step_size; }
  public float getFixedMin() { return this.settings.fixed_min; }
  public float getFixedMax() { return this.settings.fixed_max; }
  
  /** Tells if the min/max on the y-axis is fixed. */
  public boolean isMinFixed() { return this.settings.fix_min; }
  public boolean isMaxFixed() { return this.settings.fix_max; }
  
  /** Tells if the "global" min/max should be used as fixed min/max. */
  public boolean keepMin() { return this.settings.keep_min; }
  public boolean keepMax() { return this.settings.keep_max; }
  
  /** Max items to show on the x-axis. */
  public int getMaxItems() { return this.settings.show_max_items; }
  
  /** Get amount of lines currently added to the graph. */
  public int getLineCount() { return this.lines.size(); }


  // ----------------------------------------------------------------------
  // Setter
  public void setTitle(String title) { this.settings.title = title; }
  public void setLabelX(String label) { this.settings.label_x = label; }
  public void setLabelY(String label) { this.settings.label_y = label; }
  
  /** Set step size on x-axis. */
  public void setStepSize(float step_size) { this.settings.step_size = step_size; }
  
  /** Set max. amount of data points to show. */
  public void setMaxItems(int items) { this.settings.show_max_items = max(2, items); }
  
  /** Fix min/max value on y-axis. */
  public void setFixedMin(float v) { this.settings.fix_min = true; this.settings.fixed_min = v; }
  public void setFixedMax(float v) { this.settings.fix_max = true; this.settings.fixed_max = v; }
  
  /** Updates the fixed min/max to use the last min/max value added. */
  public void setKeepMin(boolean keep) { this.settings.keep_min = keep; }
  public void setKeepMax(boolean keep) { this.settings.keep_max = keep; }


  // ----------------------------------------------------------------------
  // Methods
  
  /** Add a data line to the graph. */
  public void addLine(String caption, color col, int width_) {
    lines.add(new UIGraphLine(caption, col, width_));
  }
  
  /** Adds a value for each line (if multiple lines are given, [0] = for first, [1] = for second and so on). */
  public void add(float ...y) {
    
    if (y.length != lines.size()) {
      println("Failed to add value! Not as many entries as lines given!");
      return;
    }
    
    for (int i = 0; i < lines.size(); i++) {
      UIGraphLine line = lines.get(i);
      line.append(y[i]);
    }
  }
  
  /** Removes this index from all lines. */
  public void remove(int index) {
    for (UIGraphLine line : lines) { line.remove(index); }
  }
  
  /** Remove all data points in this index range. */
  public void removeAll(int from, int to) {
    from = max(0, from);
    to = min(lines.get(0).size(), max(from, to));
    for (int i = from; i < to; i++) { this.remove(i); }
  }

  // Get min and max for x and y in data range
  // [0] min_x, [1] max_x, [2] min_y, [3] max_y
  private float[] getMinMax(int idx_from, int idx_to) {
    
    float[] minmax = new float[]{idx_from, idx_to-1, -1, -1};
    boolean first = true;
    for (UIGraphLine line : lines) {
      for (int i = idx_from; i < idx_to; i++) {
        float y = line.get(i);
        if (first || y < minmax[2]) { minmax[2] = y; }
        if (first || y > minmax[3]) { minmax[3] = y; }
        if (first) { first = false; }
      }
    }
    return minmax;
  }

  // Require to update the graph layout on next draw call.
  // You must use this after changing settings like the title.
  public void updateLayout() { update_layout = true; }

  /** Creates the graph and makes it ready to show. */
  public void draw(boolean show) {

    String title = this.settings.title;
    String label_x = this.settings.label_x;
    String label_y = this.settings.label_y; 
    
    int textHeight = 5;
    int title_size = 12;
    int offset_x = label_y.length() > 0 ? 30 : 15;
    int offset_y = label_x.length() > 0 ? 30 : 15;
    int title_spacing = title.length() > 0 ? 20 : 0; // on y-axis
    int center_x = getWidth() / 2;

    // create graph layout
    if (update_layout) {
      update_layout = false;

      // ---------------------------------------------------------------------
      // draw title and labels
      pg.beginDraw();
      pg.clear();
      
      pg.textSize(title_size);
      if (title.length() > 0) { pg.text(title, center_x - textWidth(title) / 2, title_size); }
      
      pg.textSize(10);
      if (label_x.length() > 0) { pg.text(label_x, offset_x/2 + center_x - textWidth(label_x) / 2, getHeight() - 1 - textHeight); }
      if (label_y.length() > 0) {
        pg.pushMatrix();
        pg.translate(0, title_spacing + (getHeight() - title_spacing - offset_y) / 2 - textWidth(label_y) / 2 + 5);
        pg.rotate(HALF_PI);
        pg.text(label_y, 0, 0);
        pg.popMatrix();
      }
  
      // ---------------------------------------------------------------------
      // draw x and y axes
      pg.strokeWeight(this.settings.axes_width);
      pg.stroke(this.settings.axes_line_color);
      pg.line(offset_x, getHeight()-1-offset_y+2, offset_x, title_spacing); // vertical (y)
      pg.stroke(color(200,0,0));
      pg.line(offset_x-2, getHeight()-1-offset_y, getWidth()-1, getHeight()-1-offset_y); // horizontal (x)
      
      // end drawing process and show if desired
      pg.endDraw();
    }

    // ---------------------------------------------------------------------
    // draw the data graph
    if (lines.size() > 0 && lines.get(0).size() > 0) {
      pgd.beginDraw();
      pgd.clear();
  
      // get the index range of the data to use for drawing lines
      int dta_entries = lines.get(0).size();
      int dta_from = min(this.show_data_from, dta_entries);
      int dta_to = this.show_data_to;
      if (dta_from < 0) { dta_from = 0; }
      if (dta_to < 0 || dta_to > dta_entries) { dta_to = dta_entries; }
      if (dta_to < dta_from) { dta_to = dta_from; }
      int dta_range = dta_to - dta_from;
      
      // show only these many entries/items
      if (this.getMaxItems() > 1 && dta_range > this.getMaxItems()) {
        dta_from = dta_to - this.getMaxItems();
      }
      
      // get min/max of x and y in index range
      float[] dta_mm = this.getMinMax(dta_from, dta_to);
      float x_min = dta_mm[0], x_max = dta_mm[1];
      float y_min = dta_mm[2], y_max = dta_mm[3];
      
      // update fixed min/max if total min/max should be kept
      if (this.keepMin() && (y_min < this.getFixedMin() || first_draw)) { this.setFixedMin(y_min); }
      if (this.keepMax() && (y_max > this.getFixedMax() || first_draw)) { this.setFixedMax(y_max); }
      
      // update y min/max to use fixed min/max
      if (this.isMinFixed()) { y_min = this.getFixedMin(); }
      if (this.isMaxFixed()) { y_max = this.getFixedMax(); }
      float x_range = x_max-x_min, y_range = y_max-y_min;
  
      // compute pixel area ranges
      int px_x_from = offset_x + this.settings.axes_width;
      int px_x_to = getWidth()-1;
      int px_x_range = px_x_to - px_x_from;
      int px_y_from = title_spacing;
      int px_y_to = getHeight()-1 - offset_y - this.settings.axes_width;
      int px_y_range = px_y_to - px_y_from;
      
      // draw the lines
      for (int l = 0; l < lines.size(); l++) {
        
        UIGraphLine line = lines.get(l);
        pgd.stroke(line.getColor());
        pgd.strokeWeight(line.getWidth());
        
        int last_x = 0, last_y = 0;
        for (int i = dta_from; i < dta_to; i++) {
          int x = px_x_from + floor((i - x_min) / x_range * px_x_range);
          int y = px_y_to - floor((line.get(i) - y_min) / y_range * px_y_range);
          if (i > dta_from) { pgd.line(last_x, last_y, x, y); }
          last_x = x; last_y = y;
        }
      }
      
      pgd.endDraw();
    }

    if (first_draw) { first_draw = false; }
    if (show) { show(); }
  }
  
  /** Draws the graph to screen. */
  public void show() {
    image(pg, getX(), getY(), getWidth(), getHeight()); // base
    image(pgd, getX(), getY(), getWidth(), getHeight()); // data
  }
}
