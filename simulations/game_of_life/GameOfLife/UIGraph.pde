/*
 * To create simple graphs.
 * Pivot is in the top left corner of the graph.
 * Created by github.com/S1r0hub (Jan. 2021)
*/
class UIGraph {

  private PGraphics pg; // base graph layout (only build once)
  private PGraphics pgd; // data drawn to graph
  private boolean update_layout = true;
  
  private UIGraphSettings settings = new UIGraphSettings();
  private final int[] dim; // pos and size

  // https://processing.org/reference/FloatList.html
  private FloatList data_x = new FloatList();
  private FloatList data_y = new FloatList();

  // ToDo: add as setting methods
  private int show_max_items = 400; // max of entries on x-axis (at least 2)
  
  // ToDo: make usable xD
  private int show_data_from = -1; // -1 means from [0]
  private int show_data_to = -1; // -1 means to [max]


  // Constructor
  UIGraph(int x, int y, int w, int h) { this(x, y, w, h, ""); }
  UIGraph(int x, int y, int w, int h, String title) {
    this.dim = new int[]{x, y, w, h};
    settings.title = title;
    pg = createGraphics(w,h);
    pgd = createGraphics(w,h);
  }


  // Getter
  public int getX() { return this.dim[0]; }
  public int getY() { return this.dim[1]; }
  public int getWidth() { return this.dim[2]; }
  public int getHeight() { return this.dim[3]; }

  public String getTitle() { return this.settings.title; }
  public String getLabelX() { return this.settings.label_x; }
  public String getLabelY() { return this.settings.label_y; }


  // Setter
  public void setTitle(String title) { this.settings.title = title; }
  public void setLabelX(String label) { this.settings.label_x = label; }
  public void setLabelY(String label) { this.settings.label_y = label; }


  // Methods
  public void add(float y) { this.add(data_x.size()+1, y); }
  public void add(float x, float y) { data_x.append(x); data_y.append(y); }
  
  public void remove(int index) { data_x.remove(index); data_y.remove(index); }
  public void removeAll(int from, int to) {
    from = max(0, from);
    to = min(data_x.size(), max(from, to));
    for (int i = from; i < to; i++) { this.remove(i); }
  }

  // Get min and max for x and y in data range
  // [0] min_x, [1] max_x, [2] min_y, [3] max_y
  private float[] getMinMax(int idx_from, int idx_to) {
    
    float[] minmax = new float[4];
    boolean first = true;
    for (int i = idx_from; i < idx_to; i++) {
      float x = data_x.get(i), y = data_y.get(i);
      if (first || x < minmax[0]) { minmax[0] = x; }
      if (first || x > minmax[1]) { minmax[1] = x; }
      if (first || y < minmax[2]) { minmax[2] = y; }
      if (first || y > minmax[3]) { minmax[3] = y; }
      if (first) { first = false; }
    }
    return minmax;
  }


  // Require to update the graph layout on next draw call.
  // You must use this after changing settings like the title.
  public void updateLayout() { update_layout = true; }

  // Creates the graph.
  // ToDo: improve label size and select a font
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
    if (data_x.size() > 0) {
      pgd.beginDraw();
      pgd.clear();
  
      // index range of data to use
      int dta_from = min(show_data_from, data_x.size());
      int dta_to = show_data_to;
      if (dta_from < 0) { dta_from = 0; }
      if (dta_to < 0) { dta_to = data_x.size(); }
      if (dta_to < dta_from) { dta_to = dta_from; }
      int dta_range = dta_to - dta_from;
      
      // show only these many entries/items
      if (show_max_items > 1 && dta_range > show_max_items) {
        dta_from = dta_to - show_max_items;
      }
      
      // min/max of x and y in index range
      float[] dta_mm = getMinMax(dta_from, dta_to);
      float x_min = dta_mm[0], x_max = dta_mm[1];
      float y_min = dta_mm[2], y_max = dta_mm[3];
      float x_range = x_max-x_min, y_range = y_max-y_min;
  
      // pixel area ranges
      int px_x_from = offset_x + this.settings.axes_width;
      int px_x_to = getWidth()-1;
      int px_x_range = px_x_to - px_x_from;
      int px_y_from = title_spacing;
      int px_y_to = getHeight()-1 - offset_y - this.settings.axes_width;
      int px_y_range = px_y_to - px_y_from;
  
      pgd.stroke(this.settings.line_color);
      pgd.strokeWeight(this.settings.line_width);
      
      // draw the lines
      int last_x = 0, last_y = 0;
      for (int i = dta_from; i < dta_to; i++) {
        int x = px_x_from + floor((data_x.get(i) - x_min) / x_range * px_x_range);
        int y = px_y_to - floor((data_y.get(i) - y_min) / y_range * px_y_range);
        if (i > dta_from) { pgd.line(last_x, last_y, x, y); }
        last_x = x; last_y = y;
      }
      
      pgd.endDraw();
    }

    if (show) { show(); }
  }
  
  // Draws to screen.
  public void show() {
    image(pg, getX(), getY(), getWidth(), getHeight()); // base
    image(pgd, getX(), getY(), getWidth(), getHeight()); // data
  }
}
