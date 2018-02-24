class Line
{
  private Pair<Float,Float> from;
  private Pair<Float,Float> to;
  
  
  public Line(float x1, float y1, float x2, float y2)
  {
    this.from = new Pair<Float,Float>(x1,y1);
    this.to = new Pair<Float,Float>(x2,y2);
  }
  
  public Line(Pair<Float,Float> from, Pair<Float,Float> to)
  {
    this.from = from;
    this.to = to;
  }
  
  
  public Pair<Float,Float> getFrom() { return this.from; }
  public Pair<Float,Float> getTo() { return this.to; }
  
  // y = mx + n
  public float get_m() { return getSlope(); }
  public float getSlope()
  {
    float denominator = to.first - from.first;
    if (equal(denominator,0.f)) { return 0; }
    return (to.second - from.second) / denominator;
  }
  
  public float get_n() { return getYShift(); }
  public float getYShift()
  {
    if (equal(this.from.second,this.to.second)) { return this.from.second; }
    if (equal(this.from.first,this.to.first)) { return 0; }
    return from.second - getSlope() * from.first;
  }
  
  // y0 : distance to origin where line crosses the y-axis (0,y)
  public float getyAxisCut() { return get_n(); }
  
  // x0 : distance to origin where line crosses the x-axis (x,0)
  public float getxAxisCut()
  {
    if (equal(this.from.first,this.to.first)) { return this.from.first; }
    if (equal(this.from.second,this.to.second)) { return 0; }
    return (-get_n()) / get_m();
  }

  // Calculates euclidean intersection point of this line with line 2.
  // This is done by converting them to to homogeneous coordinates,
  // applying the cross product and normalizing the result.
  public Pair<Float,Float> intersect(Line l2)
  {
    // Convert to homogeneous coordinates: (1 / x0, 1 / y0, -1)
    // x and y will be divided by -1 to normalize the homogeneous coordinates.
    // The z value of both lines can then be assumed to equal 1.
    float x1 = 0, y1 = 0, z1 = 1.f; 
    if (this.getxAxisCut() != 0) { x1 = 1.f / this.getxAxisCut() / (-1); }
    if (this.getyAxisCut() != 0) { y1 = 1.f / this.getyAxisCut() / (-1); }
    
    println("L1 m = " + this.get_m() + " , n = " + this.get_n());
    println("L1 x_cut = " + this.getxAxisCut() + " , y_cut = " + this.getyAxisCut());
    println("Homo x1 = " + x1 + " , y1 = " + y1 + " , z1 = " + z1);
    
    float x2 = 0, y2 = 0, z2 = 1.f;
    if (l2.getxAxisCut() != 0) { x2 = 1.f / l2.getxAxisCut() / (-1); }
    if (l2.getyAxisCut() != 0) { y2 = 1.f / l2.getyAxisCut() / (-1); }
    
    println("L2 m = " + l2.get_m() + " , n = " + l2.get_n());
    println("L2 x_cut = " + l2.getxAxisCut() + " , y_cut = " + l2.getyAxisCut());
    println("Homo x2 = " + x2 + " , y2 = " + y2 + " , z2 = " + z2);
    
    // cross product result: (x1,y1,z1) cross (x2,y2,z2)
    // x1 x2
    // y1 y2
    // z1 z2
    // -- --
    // x1 x2
    // y1 y2
    // z1 z2
    // =====
    // y1*z2 - z1*y2
    // z1*x2 - x1*z2
    // x1*y2 - y1*x2
    
    float x = y1*z2 - z1*y2;
    float y = z1*x2 - x1*z2;
    float z = x1*y2 - y1*x2;
    
    if (equal(z,0.f)) { return new Pair<Float,Float>(0.f,0.f); }
    return new Pair<Float,Float>(x/z, y/z);
  }
  
  
  public String toString()
  {
    return "(" + this.from.first + "," + this.from.second + ") - " +
           "(" + this.to.first + "," + this.to.second + ")";
  }
}