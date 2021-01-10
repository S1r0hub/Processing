/*
 * Holds all the generic graph settings.
 * Created by github.com/S1r0hub (Jan. 2021)
*/
class UIGraphSettings {

  public String title = "";
  
  // max of entries on x-axis (at least 2)
  public int show_max_items = 300;
  
  // fixed min/max on y-axis (otherwise adjusts accordingly)
  public float fixed_min = 0, fixed_max = 1000;
  public boolean fix_min = false, fix_max = false;
  public boolean keep_min = false, keep_max = false;
  
  // Axes
  public String label_x = "";
  public String label_y = "";
  public color axes_line_color = color(20, 20, 20);
  public int axes_width = 1;
  
  // Graph Lines
  public float step_size = 1; // step size on x-axis
  public int line_width = 1;
}
