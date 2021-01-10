/*
 * A line in the graph.
 * Created by github.com/S1r0hub (Jan. 2021)
 * Extends https://processing.org/reference/FloatList.html
*/
class UIGraphLine extends FloatList {
  
  private String caption;
  private color col = color(255);
  private int line_width = 1;
  
  // Constructor
  UIGraphLine(String caption, color col, int width_) {
    
    super(); // initialize list
    this.caption = caption;
    this.col = col;
    this.line_width = width_;
  }
  
  // Getter
  public String getCaption() { return this.caption; }
  public color getColor() { return this.col; }
  public int getWidth() { return this.line_width; }
  
  // Setter
  public void setCaption(String caption) { this.caption = caption; }
  public void setColor(color col) { this.col = col; }
  public void setWidth(int w) {
    if (w < 1) { w = 1; }
    this.line_width = w;
  }
}
