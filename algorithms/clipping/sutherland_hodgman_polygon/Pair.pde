class Pair<T,F>
{
  public T first;
  public F second;
  
  public Pair(T first, F second)
  {
    this.first = first;
    this.second = second;
  }
  
  public String toString()
  { return "(" + this.first + "," +  this.second + ")"; }
}