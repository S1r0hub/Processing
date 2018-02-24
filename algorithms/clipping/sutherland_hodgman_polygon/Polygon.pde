class Polygon
{
  private float width = 256.f, height = 256.f, scale = 1.f;
  private float x = 0, y = 0;
  private ArrayList<Pair<Float,Float>> vertices = new ArrayList<Pair<Float,Float>>();
  
  private float edgeSize = 4.f;
  private color edgeColor = color(0);
  
  private float vertexSize = 12.f;
  private color vertexColor = color(0);
  
  private boolean closed = false;  
  
  
  // width and height are the scaling factors along x and y axis
  public Polygon(float x, float y, float width, float height, float scale)
  {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.scale = scale;
  }
  
  public Polygon(float x, float y) { this(x, y, 1.f, 1.f, 1.f); }
  
  // copy constructor
  public Polygon(Polygon polygon)
  {
    this(polygon.getX(), polygon.getY(), polygon.getWidth(), polygon.getHeight(), polygon.getScale());
    this.edgeSize = polygon.getEdgeSize();
    this.edgeColor = polygon.getEdgeColor();
    this.vertexSize = polygon.getVertexSize();
    this.vertexColor = polygon.getVertexColor();
    this.closed = polygon.isClosed();
    for (int i = 0; i < polygon.getVertexCount(); i++)
    { this.addVertex(polygon.getVertex(i)); }
  }
  
  public void addVertex(float x, float y)
  { this.vertices.add(new Pair<Float, Float>(x,y)); }
  
  public void addVertex(Pair<Float, Float> vertex)
  { this.addVertex(vertex.first, vertex.second); }
  
  
  // SETTER
  
  public void setX(float x) { this.x = x; }
  public void setY(float y) { this.y = y; }
  
  // width and height are scale factors on x- or y-axis
  public void setWidth(float width) { this.width = width; }
  public void setHeight(float height) { this.height = height; }
  
  // global scaling factor
  public void setScale(float scale) { this.scale = scale; }
  
  public void setEdgeSize(float size) { this.edgeSize = size; }
  public void setEdgeColor(color c) { this.edgeColor = c; }
  
  public void setVertexSize(float size) { this.vertexSize = size; }
  public void setVertexColor(color c) { this.vertexColor = c; }
  
  // to not connect the last and the first vertex
  public void open() { this.closed = false; }
  
  // will connect the last vertex with the first (create this edge)
  public void close() { this.closed = true; }
  
  
  // GETTER
  
  // origin x- and y-coordinates of the polygon
  public float getX() { return this.x; }
  public float getY() { return this.y; }
  
  public float getWidth() { return this.width; }
  public float getHeight() { return this.height; }
  public float getScale() { return this.scale; }
  
  // get all unmodified vertex coordinates (unscaled)
  public ArrayList<Pair<Float,Float>> getVertices() { return this.vertices; }
  public ArrayList<Pair<Float,Float>> getVerticesScaled()
  {
    ArrayList<Pair<Float,Float>> verticesNew = new ArrayList<Pair<Float,Float>>();
    for (int i = 0; i < this.vertices.size(); i++)
    { verticesNew.add(this.getVertexPos(i)); }
    return verticesNew;
  }
  
  public int getVertexCount() { return this.vertices.size(); }
  public Pair<Float, Float> getVertex(int index) { return this.vertices.get(index); }
  
  // get the vertex position (scaled by global scale factor as well as width and height)
  public Pair<Float, Float> getVertexPos(int index)
  {
    Pair<Float, Float> vertex = getVertex(index);
    float first = getX() + vertex.first * getWidth() * getScale();
    float second = getY() - vertex.second * getHeight() * getScale();
    return new Pair<Float, Float>(first, second);
  }
  
  public color getEdgeColor() { return this.edgeColor; }
  public float getEdgeSize() { return this.edgeSize; }
  
  public color getVertexColor() { return this.vertexColor; }
  public float getVertexSize() { return this.vertexSize; }
 
  // tells whether the last and first vertex will be connected
  public boolean isClosed() { return this.closed; }
 
 
  // FUNCTIONALITY
  
  public void draw(boolean showEdges, boolean showVertices)
  {
    if (showEdges) { drawEdges(this.edgeSize, this.closed); }
    if (showVertices) { drawVertices(this.vertexSize); }
  }
  
  public void draw(boolean showEdges) { draw(showEdges, true); }
  public void draw() { draw(true); }
  
  // removes all the vertices
  public void clearVertices() { this.vertices.clear(); }
  
  public void drawVertices(float size)
  {
    if (this.getVertexCount() <= 0) { return; }
    
    stroke(vertexColor);
    strokeWeight(size);
    
    for (int i = 0; i < getVertexCount(); i++)
    {
      Pair<Float, Float> v = this.getVertexPos(i);
      point(v.first, v.second, 1);
    }
  }
  
  public void drawEdges(float size, boolean close)
  {
    if (this.getVertexCount() < 1) { return; }
    
    stroke(edgeColor);
    strokeWeight(size);
    
    for (int i = 1; i < getVertexCount(); i++)
    {
      Pair<Float, Float> v1 = this.getVertexPos(i-1);
      Pair<Float, Float> v2 = this.getVertexPos(i);
      line(v1.first, v1.second, v2.first, v2.second);
    }
    
    if (close && this.getVertexCount() > 2)
    {
      Pair<Float, Float> v1 = this.getVertexPos(this.getVertexCount()-1);
      Pair<Float, Float> v2 = this.getVertexPos(0);
      line(v1.first, v1.second, v2.first, v2.second);
    }
  }
  
  // prints out the vertex coordinates to the console
  public void printVertices()
  {
    int i = 0;
    for (Pair<Float,Float> v : this.vertices)
    { println("Vertex " + (i++) + " = (" + v.first + " , " + v.second + ")"); }
  }
}