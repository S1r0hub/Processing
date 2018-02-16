// Sutherland-Hodgeman Polygon Clipping Algorithm


Polygon clippingPolygon;
Polygon heart;

void setup()
{
  size(512, 512, P3D);
  
  clippingPolygon = new Polygon(0, 0, 1.2, 1.2, 50.f);
  
  clippingPolygon.addVertex(-1, -1);
  clippingPolygon.addVertex(1, -1);
  clippingPolygon.addVertex(1, 1);
  clippingPolygon.addVertex(-1, 1);
  
  clippingPolygon.setEdgeColor(color(200,50,50));
  clippingPolygon.close();

  
  heart = new Polygon(0, 0, 1, -1, 20.f);
  
  heart.addVertex(0, 0.6f);
  heart.addVertex(0.4, 1);
  heart.addVertex(0.75, 1);
  heart.addVertex(1, 0.5);
  heart.addVertex(0.8, -0.3);
  heart.addVertex(0, -1);/*
  heart.addVertex(-0.8, -0.3);
  heart.addVertex(-1, 0.5);
  heart.addVertex(-0.75, 1);
  heart.addVertex(-0.4, 1);*/
  
  heart.setEdgeColor(color(200,50,50));
  heart.setEdgeSize(2.f);
  heart.open();
}


void draw()
{
  clear();
  background(color(255));
  
  /*
  pushMatrix();
  translate(width/2.f, height/2.f);
  rotateZ(millis() / 1000.f);
  clippingPolygon.draw();  
  popMatrix();
  */
  
  /*
  pushMatrix();
  translate(width/2.f, height/2.f);
  rotateY(-millis() / 1000.f);
  heart.draw(true, false);
  popMatrix();
  */
  
  int hearts = 40;
  for (int i = 0; i < hearts; i++)
  {
    pushMatrix();
    translate(width/2.f, height/2.f);
    //rotateY(millis() / (10.f * ((i+1) / (float) hearts) + 1000));
    rotateY(millis() / (10.f * (i+1) + 50) + 50);
    //rotateZ(millis() / (10.f * (i+1)));
    Polygon heartx = new Polygon(heart);
    //heartx.setScale((i / (float) hearts) * 40.f + 50);
    heartx.setScale(80);
    heartx.draw(true, false);
    popMatrix();
  }
}


// Clipping can work like this:
/*
- Edge E connects 2 points P1 and P2 (aka vertices)
- we get a line, everything right/left to the line is in/outside
  (what is in and outside depends on how we build up our polygon)
  (-> in clockwise direction or against!)
- calculate the vector V1 between P1 and P2
- calculate the vector V2 between P1 and P3 (P3 is the point we want to clip)
- normalize both 2-dimensional vectors V1 and V2
- add 1 more dimension to both vectors (z) and set its value to 0
- calculate the cross-product of the new two 3-dimensional vectors Vcross
- get the z-coordinate of Vcross
- is the value of the z-coordinate <= 0 -> inside (if polygon built clockwise)
  -> otherwise inside
  (if polygon built anti-clockwise -> > 0 inside and <= 0 outside!)
  (in this code we build polygons in clockwise direction!)
*/
void clipPolygon(Polygon poly, Polygon clip)
{
  if (clip.getVertexCount() < 1)
  {
    println("Clipping failed! Clipping polygon does not have enough vertices.");
    return;
  }
  
  
  // input for each edge (vertices of the polygon)
  ArrayList<Pair<Float,Float>> verts_out = new ArrayList<Pair<Float,Float>>(poly.getVertices()); // (ArrayList<Pair<Float,Float>>) poly.getVertices().clone();
  
  // iterate over each edge of the clipping polygon
  for (int i = 1; i < clip.getVertexCount(); i++)
  {
    // get clip points (cp)
    Pair<Float, Float> cp1 = clip.getVertex(i-1);
    Pair<Float, Float> cp2 = clip.getVertex(i-2);
    
    // build the edge (= v1)
    Pair<Float, Float> edge = new Pair<Float, Float>(cp2.first - cp1.first, cp2.second - cp1.second);
    Pair<Float, Float> v1_norm = normVector(edge);
    
    // compare each point of the polygon with the edge (if inside or outside) with the 4 cases:
    /*
    1) p1 & p2 out   -> do nothing
    2) p1 out, p2 in -> add P_intersection and p2
    3) p1 in, p2 out -> add P_intersection
    4) p1 & p2 in    -> add p2
    */
    
    ArrayList<Pair<Float,Float>> verts = new ArrayList<Pair<Float,Float>>(verts_out);
    verts_out.clear(); // clear this because we want to add our clipped points to it in the following code
    
    for (int k = 1; k < verts.size(); k++)
    {
      boolean p1_inside = checkIfInside(verts.get(k-1), cp1, v1_norm);
      boolean p2_inside = checkIfInside(verts.get(k), cp1, v1_norm);
      
      if (!p1_inside && !p2_inside) { continue; }    // both outside -> nothing
      else if (!p1_inside & p2_inside)               // p1 outside, p2 inside -> add intersection and p2
      {
        // TODO
      }
      else if (p1_inside && !p2_inside)              // p1 inside, p2 outside -> add intersection
      {
        // TODO
      }
      else if (p1_inside && p2_inside)               // both inside -> add just p2
      {
        verts_out.add(verts.get(k));
      }
    }
  }
}


Pair<Float, Float> normVector(Pair<Float, Float> vector)
{
    float vecLength = sqrt(pow(vector.first,2) + pow(vector.second,2));
    return new Pair<Float,Float>(vector.first / vecLength, vector.second / vecLength);
}


/*
v = vertex
cp1 = clip point 1 (vertex)
v1_norm = normalized vector v1 (the clipping edge)
*/
boolean checkIfInside(Pair<Float, Float> v, Pair<Float, Float> cp1, Pair<Float, Float> v1_norm)
{
  // build second vector between p1 and another point p3 (= v)
  Pair<Float, Float> v2 = new Pair<Float, Float>(v.first - cp1.first, v.second - cp1.second);
  Pair<Float, Float> v2_norm = normVector(v2);
  
  // calculate cross product between the 2 normalized 2D vectors and get the last (z) coordinate
  // this is equal to:
  float z = v1_norm.first * v2_norm.second - v1_norm.second * v2_norm.first;
  
  if (z <= 0) { return true; }
  return false;
}