// Sutherland-Hodgman Polygon Clipping Algorithm


Polygon clippingPolygon;
Polygon heart;


void setup()
{
  size(512, 512, P3D);
  
  // example clipping polygon (rectangle)
  clippingPolygon = new Polygon(0, 0, 1.f, 1.f, 50.f);
  
  clippingPolygon.addVertex(-1, -0.8);
  clippingPolygon.addVertex(1, -1);
  clippingPolygon.addVertex(0.5, 1);
  //clippingPolygon.addVertex(-1, 1);
  
  clippingPolygon.setEdgeColor(color(200,50,50));
  //clippingPolygon.close();

  
  // example for a polygon heart
  /*
  heart = new Polygon(0, 0, 1, -1, 20.f);
  
  heart.addVertex(0, 0.6f);
  heart.addVertex(0.4, 1);
  heart.addVertex(0.75, 1);
  heart.addVertex(1, 0.5);
  heart.addVertex(0.8, -0.3);
  heart.addVertex(0, -1);
  heart.addVertex(-0.8, -0.3);
  heart.addVertex(-1, 0.5);
  heart.addVertex(-0.75, 1);
  heart.addVertex(-0.4, 1);
  
  heart.setEdgeColor(color(200,50,50));
  heart.setEdgeSize(2.f);
  heart.open();
  
  
  translate(width/2.f,height/2.f);
  clippingPolygon.draw();
  //heart.draw();
  */
  
  Polygon poly = new Polygon(0,0,1.2f,1.f,50.f);
  poly.addVertex(-0.5f,0);
  poly.addVertex(1,0.1f);
  
  translate(width/2.f,height/2.f);
  
  Polygon clippedPolygon = clipPolygon(poly, clippingPolygon);
  
  clippingPolygon.draw();
  poly.draw();
  clippedPolygon.draw();
  clippedPolygon.printVertices();
}


/*
void draw()
{
  clear();
  background(color(255));
  
  heartPolygonTest(heart);
}
*/


// Clip a polygon against another polygon.
// How the clipping works:
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
Polygon clipPolygon(Polygon poly, Polygon clip)
{
  if (clip.getVertexCount() < 1)
  {
    println("Clipping failed! Clipping polygon does not have enough vertices.");
    return new Polygon(0,0);
  }
  
  
  // input for each edge (vertices of the polygon)
  ArrayList<Pair<Float,Float>> verts_out = new ArrayList<Pair<Float,Float>>(poly.getVerticesScaled());
  
  // iterate over each edge of the clipping polygon
  for (int i = 1; i < clip.getVertexCount(); i++)
  {
    // get clip points (cp)
    Pair<Float, Float> cp1 = clip.getVertexPos(i-1);
    Pair<Float, Float> cp2 = clip.getVertexPos(i);
    
    // build the edge (= v1)
    Pair<Float, Float> edge = new Pair<Float, Float>(cp2.first - cp1.first, cp2.second - cp1.second);
    Pair<Float, Float> v1_norm = normVector(edge);
    
    // Compare each point of the polygon with the edge (if inside or outside) with respect to the 4 cases.
    /*
    1) p1 & p2 out   -> do nothing
    2) p1 out, p2 in -> add P_intersection and p2
    3) p1 in, p2 out -> add P_intersection
    4) p1 & p2 in    -> add p2
    */
    
    ArrayList<Pair<Float,Float>> verts = (ArrayList<Pair<Float,Float>>) verts_out.clone();
    verts_out.clear(); // clear this because we want to add our clipped points to it in the following code
    
    for (int k = 0; k < verts.size(); k++)
    {
      // get polygon points (pp)
      // check last to first vertex edge first 
      Pair<Float, Float> pp1 = verts.get(verts.size()-1);
      Pair<Float, Float> pp2 = verts.get(k);
      
      // every other case
      if (k > 0) { pp1 = verts.get(k-1); }
      
      // check position of p1 and p2
      boolean p1_inside = checkIfInside(pp1, cp1, v1_norm);
      boolean p2_inside = checkIfInside(pp2, cp1, v1_norm);
      
      println("Edge " + i +
              " , P" + (k-1) + " = " + (p1_inside ? "inside" : "outside") +
              " , P" + k + " = " + (p2_inside ? "inside" : "outside"));
      
      if (!p1_inside && !p2_inside) { continue; }    // 1. case: both outside -> nothing
      else if (!p1_inside & p2_inside)               // 2. case: p1 outside, p2 inside -> add intersection and p2
      {
        Line ce = new Line(cp1,cp2); // clipping edge
        Line pe = new Line(pp1,pp2); // polygon edge
        
        Pair<Float,Float> intersectionPoint = getIntersectionPoint(ce,pe);
        
        // add normalized points because our polygons vertex coordinates are in range of -1 to 1
        verts_out.add(normalizePoint(intersectionPoint, poly.getWidth(), poly.getHeight(), poly.getScale()));
        verts_out.add(normalizePoint(pp2, poly.getWidth(), poly.getHeight(), poly.getScale()));
      }
      else if (p1_inside && !p2_inside)              // 3. case: p1 inside, p2 outside -> add intersection
      {
        Line ce = new Line(cp1,cp2); // clipping edge
        Line pe = new Line(pp1,pp2); // polygon edge
        
        Pair<Float,Float> intersectionPoint = getIntersectionPoint(ce,pe);
        
        verts_out.add(normalizePoint(intersectionPoint, poly.getWidth(), poly.getHeight(), poly.getScale()));
      }
      else if (p1_inside && p2_inside)               // 4. case: both inside -> add just p2
      {
        verts_out.add(normalizePoint(pp2, poly.getWidth(), poly.getHeight(), poly.getScale()));
      }
    }
  }
  
  Polygon clippedPolygon = new Polygon(poly);
  clippedPolygon.clearVertices();
  for (Pair<Float,Float> v : verts_out) { clippedPolygon.addVertex(v); }
  clippedPolygon.close();
  
  return clippedPolygon;
}


// returns the normalized vector of the passed one
Pair<Float, Float> normVector(Pair<Float, Float> vector)
{
    float vecLength = sqrt(pow(vector.first,2) + pow(vector.second,2));
    return new Pair<Float,Float>(vector.first / vecLength, vector.second / vecLength);
}


/*
v = vertex
cp1 = clip point 1 (vertex)
v1_norm = normalized vector v1 (the clipping edge)

Checks if a vertex is inside or outside of the polygon-edge (left/right of it).

For a better understanding why this works, check out my geogebra visualization:
https://github.com/S1r0hub/Processing/geogebra/clipping/inside-outside-test.ggb
*/
boolean checkIfInside(Pair<Float, Float> v, Pair<Float, Float> cp1, Pair<Float, Float> v1_norm)
{
  // build second vector between p1 and another point p3 (= v)
  Pair<Float, Float> v2 = new Pair<Float, Float>(v.first - cp1.first, v.second - cp1.second);
  Pair<Float, Float> v2_norm = normVector(v2);
  
  // calculate cross product between the 2 normalized 2D vectors and get the last (z) coordinate
  // this is equal to:
  float z = v1_norm.first * v2_norm.second - v1_norm.second * v2_norm.first;
  
  // if clipping polygon built clockwise -> z <= 0 => true, else z > 0 => true
  if (z >= 0) { return true; }
  return false;
}


/*
ce = clipping edge [Line]
pe = polygon edge [Line]

Computes the intersection point of the two lines using homogeneous coordinates.
Will return the euclidean 2-dimensional coordinates of the intersection point.
*/
Pair<Float,Float> getIntersectionPoint(Line ce, Line pe) { return ce.intersect(pe); }


// normalize the point according to width, height and scale
Pair<Float,Float> normalizePoint(Pair<Float,Float> point, float width, float height, float scale)
{
  point.first = point.first / width / scale;
  point.second = point.second / height / scale;
  return point;
}


// ########################################################################################
// TEST SECTION (can be removed - but then also remove the call in main loop (draw)!)

// just for testing the polygon heart in different rotations
void heartPolygonTest(Polygon heart)
{
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