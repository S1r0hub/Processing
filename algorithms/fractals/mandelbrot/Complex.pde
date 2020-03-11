/**
 * Class for complex numbers.
 * Code by github.com/S1r0hub
 */
public static class Complex {

  public double a, b;
  
  public Complex(double real, double imaginary) {
    this.a = real;
    this.b = imaginary;
  }
  
  /** Distance to origin (0, 0). */
  public double distanceToZero() {
    return sqrt((float) (a*a + b*b));
  }
  
  public Complex mul(double f) {
    a *= f;
    b *= f;
    return this;
  }
  
  // --------------------------------------
  
  public static boolean equal(Complex c1, Complex c2) {
    return c1.a == c2.a && c1.b == c2.b;
  }
  
  public static Complex copy(Complex c) {
    return new Complex(c.a, c.b);
  }
  
  public static Complex add(Complex c1, Complex c2) {
    return new Complex(c1.a + c2.a, c1.b + c2.b);
  }
  
  public static Complex sub(Complex c1, Complex c2) {
    return new Complex(c1.a - c2.a, c1.b - c2.b);
  }
  
  public static Complex mul(Complex c1, Complex c2) {
    return new Complex(
      c1.a * c2.a - c1.b * c2.b,
      c1.a * c2.b + c1.b * c2.a
    );
  }
}
