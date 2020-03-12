import java.lang.Thread;

/**
 * Creates a useful thread.
 * (Compared to processings internal thread method ;D)
 */
class MThread extends Thread {
  
  private int y_from, y_to, x_max, y_max;
  private double frame_x, frame_y, frame_width, frame_height;
  private int[] colors;
  
  private int mandel_steps_max;
  private int mandel_dist_max;
  
  public MThread(int y_from, int y_to,
    int x_max, int y_max,
    double frame_x, double frame_y,
    double frame_width, double frame_height,
    int mandel_steps_max, int mandel_dist_max)
  {
    this.y_from = y_from;
    this.y_to = y_to;
    this.x_max = x_max;
    this.y_max = y_max;
    this.frame_x = frame_x;
    this.frame_y = frame_y;
    this.frame_width = frame_width;
    this.frame_height = frame_height;
    this.mandel_steps_max = mandel_steps_max;
    this.mandel_dist_max = mandel_dist_max;
    this.colors = new int[x_max * y_max];
  }
  
  /* Set start corner position of frame. */
  public void setFramePos(double x, double y) {
    this.frame_x = x;
    this.frame_y = y;
  }
  
  public void setMandelStepsMax(int steps) {
    this.mandel_steps_max = steps;
  }
  
  public void setMandelDistMax(int dist) {
    this.mandel_dist_max = dist;
  }
  
  public int[] getColors() { return this.colors; }
  
  /* Execute thread task. */
  public void run() {
    
    for (int y = y_from; y < y_to; y++) {
      for (int x = 0; x < x_max; x++) {
      
        // x_min comes from main application!
        // create the complex number corresponding to the pixel
        Complex c = new Complex(
          this.frame_x + x / (double) this.x_max * this.frame_width,
          this.frame_y + y / (double) this.y_max * this.frame_height
        );
        
        // get amount of steps for coloring the pixel
        int steps = M(c, this.mandel_steps_max, this.mandel_dist_max);
        
        // do coloring
        int col = color(255);
        if (steps < 0) { col = color(0); }
        else if (steps > 0) {
          float p = steps / float(mandel_steps_max);
          col = color(
            p * 0   + (1-p) * 0,
            p * 255 + (1-p) * 0,
            p * 0   + (1-p) * 255
          );
        }
       
        this.colors[y * this.x_max + x] = col;
      }
    }
  }
}
