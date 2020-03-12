import java.lang.Thread;

/* Thread manager. */
class ThreadMan extends Thread {

  private MThread[] threads;
  private boolean running = false;
  private double fp_x, fp_y;
  private boolean updateFramePos = false;
  
  public ThreadMan(MThread[] threads) {
    this.threads = threads;
  }
  
  public MThread[] getThreads() {
    return this.threads;
  }
  
  private void startThreads() {
    if (this.running) { return; }
    applyFramePos(); // apply if changed in meantime
    for (MThread t : this.threads) { t.start(); } 
    this.running = true;
  }
  
  public void setFramePos(double x, double y) {
    this.fp_x = x;
    this.fp_y = y;
    this.updateFramePos = true;
  }
  
  /* Call only if threads are not running. */
  private void applyFramePos() {
    if (!this.updateFramePos) { return; }
    for (MThread t : this.threads) { t.setFramePos(this.fp_x, this.fp_y); }
    this.updateFramePos = false;
  }
  
  private void applyMandelSettings() {
    if (this.updateMandel) { return; }
    for (MThread t : this.threads) {
      t.setMandelStepsMax();
      t.setMandelDistMax();
    }
    this.updateMandel = false;
  }
  
  public void run() {
    
    this.startThreads();
    while (true) {
      try {
        
        // check if threads are still running
        boolean anyRunning = false;
        for (MThread t : this.threads) {
          if (t.isAlive()) {
            anyRunning = true;
            break;
          }
        }
        if (!anyRunning) { break; }
        
        // wait another 50 ms
        Thread.sleep(50);
      }
      catch (InterruptedException e) {
        println("Threadman interrupted!");
      }
    }
    
    applyFramePos(); // apply position if changed in meantime
    this.running = false;
  }
  
}
