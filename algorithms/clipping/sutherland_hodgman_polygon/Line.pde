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
    if (denominator == 0) { return 0; }
    return (to.second - from.second);
  }
  
  public float get_n() { return getYShift(); }
  public float getYShift() { return from.second - getSlope() * from.first; }
  
  // y0 : distance to origin where line crosses the y-axis (0,y)
  public float getyAxisCut() { return get_n(); }
  
  // x0 : distance to origin where line crosses the x-axis (x,0)
  public float getxAxisCut() { return (-get_m()) / get_n(); }

  // Calculates euclidean intersection point of this line with line 2.
  // This is done by converting them to to homogeneous coordinates,
  // applying the cross product and normalizing the result.
  public Pair<Float,Float> intersect(Line l2)
  {
    // Convert to homogeneous coordinates: (1 / x0, 1 / y0, -1)
    // x and y will be divided by -1 to normalize the homogeneous coordinates.
    // The z value of both lines can then be assumed to equal 1.
    float x1 = 1.f / getxAxisCut() / (-1);
    float y1 = 1.f / getyAxisCut() / (-1);
    float z1 = 1.f;
    
    float x2 = 1.f / l2.getxAxisCut() / (-1);
    float y2 = 1.f / l2.getyAxisCut() / (-1);
    float z2 = 1.f;
    
    // cross product result: (x1,y1,z1) cross (x2,y2,z2)
    float x = y1*z2 - z1*y2;
    float y = z1*x2 - x1*z2;
    float z = x1*y1 - y1*x2;
    
    if (z == 0) { return new Pair<Float,Float>(0.f,0.f); }
    return new Pair<Float,Float>(x/z, y/z);
  }
}