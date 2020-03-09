public static class Vertex {

  public float x, y;
  
  public Vertex(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public static Vertex copy(Vertex v) {
    return new Vertex(v.x, v.y);
  }
  
  public static Vertex add(Vertex v1, Vertex v2) {
    return new Vertex(v1.x + v2.x, v1.y + v2.y);
  }
  
  public static Vertex sub(Vertex v1, Vertex v2) {
    return new Vertex(v1.x - v2.x, v1.y - v2.y);
  }
  
  public static Vertex mul(Vertex v1, Vertex v2) {
    return new Vertex(v1.x * v2.x, v1.y * v2.y);
  }
  
  public static Vertex mul(Vertex v, float f) {
    return new Vertex(v.x * f, v.y * f);
  }
  
  public static float dist(Vertex v1, Vertex v2) {
    return sqrt(pow(v1.x + v2.x, 2) + pow(v1.y + v2.y, 2));
  }
  
  /** Returns vertex in middle of both v1 and v2. */
  public static Vertex half(Vertex v1, Vertex v2) {
    return Vertex.add(v1, Vertex.mul(Vertex.sub(v2, v1), 0.5f));
  }
}
