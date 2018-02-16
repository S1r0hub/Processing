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
  
  public void setWidth(float width) { this.width = width; }
  public void setHeight(float height) { this.height = height; }
  
  public void setScale(float scale) { this.scale = scale; }
  
  public void setEdgeSize(float size) { this.edgeSize = size; }
  public void setEdgeColor(color c) { this.edgeColor = c; }
  
  public void setVertexSize(float size) { this.vertexSize = size; }
  public void setVertexColor(color c) { this.vertexColor = c; }
  
  public void open() { this.closed = false; }
  public void close() { this.closed = true; }
  
  
  // GETTER
  
  public float getX() { return this.x; }
  public float getY() { return this.y; }
  
  public float getWidth() { return this.width; }
  public float getHeight() { return this.height; }
  public float getScale() { return this.scale; }
  
  public ArrayList<Pair<Float,Float>> getVertices() { return this.vertices; }
  public int getVertexCount() { return this.vertices.size(); }  
  public Pair<Float, Float> getVertex(int index) { return this.vertices.get(index); }
  public Pair<Float, Float> getVertexPos(int index)
  {
    Pair<Float, Float> vertex = getVertex(index);
    float first = vertex.first * getWidth() * getScale();
    float second = vertex.second * getHeight() * getScale();
    return new Pair<Float, Float>(first, second);
  }
  
  public color getEdgeColor() { return this.edgeColor; }
  public float getEdgeSize() { return this.edgeSize; }
  
  public color getVertexColor() { return this.vertexColor; }
  public float getVertexSize() { return this.vertexSize; }
 
  public boolean isClosed() { return this.closed; }
 
 
  // FUNCTIONALITY
  
  public void draw(boolean showEdges, boolean showVertices)
  {
    if (showEdges) { drawEdges(this.edgeSize, this.closed); }
    if (showVertices) { drawVertices(this.vertexSize); }
  }
  
  public void draw(boolean showEdges) { draw(showEdges, true); }
  public void draw() { draw(true); }
  
  public void drawVertices(float size)
  {
    if (this.getVertexCount() <= 0) { return; }
    
    stroke(vertexColor);
    strokeWeight(size);
    
    for (int i = 0; i < getVertexCount(); i++)
    {
      Pair<Float, Float> v = this.getVertexPos(i);
      point(getX() + v.first, getY() + v.second, 1);
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
      line(getX() + v1.first, getY() + v1.second, getX() + v2.first, getY() + v2.second);
    }
    
    if (close && this.getVertexCount() > 2)
    {
      Pair<Float, Float> v1 = this.getVertexPos(this.getVertexCount()-1);
      Pair<Float, Float> v2 = this.getVertexPos(0);
      line(getX() + v1.first, getY() + v1.second, getX() + v2.first, getY() + v2.second);
    }
  }
}