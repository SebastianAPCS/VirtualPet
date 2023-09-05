/*
Created by Sebastian Dowell in 2023 for Mr. Chan's APCS Virtual Pet assignment.

Inspiration taken from https://www.alibabacloud.com/blog/construct-a-simple-3d-rendering-engine-with-java_599599
*/

// Necessary Imports
import cc.arduino.*;
import org.firmata.*;
import processing.serial.Serial;

// Processing code resides below

// Initial global declarations
Matrix3 transform;
float[] angles = new float[2];
Arduino arduino = new Arduino(this, Arduino.list()[2], 57600);

int r;
int g;
int b;

int s = 50; // Jumping strength

boolean jumpState;
double x;
double tRef;
double v0 = 10;
double ac = -20; // Controls gravity that influences jumping

float y;
boolean o;
int i = 1;
long lastClickTime = 0;
long debounceDelay = 1000;

ArrayList<Quadrilateral> quad1 = new Objects().initializeQuadrilateral(1, 1);
ArrayList<Quadrilateral> quad2 = new Objects().initializeQuadrilateral(2, 1.5);
ArrayList<Quadrilateral> quad3 = new Objects().initializeQuadrilateral(3, 3);
ArrayList<Quadrilateral> quad4 = new Objects().initializeQuadrilateral(4, 3);
ArrayList<Quadrilateral> quad5 = new Objects().initializeQuadrilateral(5, 3);
ArrayList<Quadrilateral> quad6 = new Objects().initializeQuadrilateral(6, 3);
ArrayList<Quadrilateral> quad7 = new Objects().initializeQuadrilateral(7, 3);
ArrayList<Quadrilateral> quad8 = new Objects().initializeQuadrilateral(8, 3);
ArrayList<Quadrilateral> quad9 = new Objects().initializeQuadrilateral(9, 3);
ArrayList<Quadrilateral> quad10 = new Objects().initializeQuadrilateral(10, 3);
ArrayList<Quadrilateral> quad11 = new Objects().initializeQuadrilateral(11, 3);
ArrayList<Quadrilateral> quad12 = new Objects().initializeQuadrilateral(12, 3);
ArrayList<Quadrilateral> quad13 = new Objects().initializeQuadrilateral(13, 3);
ArrayList<Triangle> tri1 = new Objects().initializeTriangle(1);
ArrayList<Sphere> s1 = new Objects().initializeSpheres(1);

public void setup() {
    size(1200, 900);
    strokeWeight(2);
    
    
    angles[0] = 0;
    angles[1] = 0;
    
    jumpState = false;
    x = 0;
    tRef = 0;

    updateTransform();
}

void draw() {
    background(0);
    translate(width / 2, height / 2);
    
    // Redraw verticies with (possibly) updated positions
    ArrayList<Quadrilateral> quad2 = new Objects().initializeQuadrilateral(2, 1.5);
    ArrayList<Quadrilateral> quad3 = new Objects().initializeQuadrilateral(3, 3);
    ArrayList<Quadrilateral> quad4 = new Objects().initializeQuadrilateral(4, 3);
    ArrayList<Quadrilateral> quad5 = new Objects().initializeQuadrilateral(5, 3);
    ArrayList<Quadrilateral> quad6 = new Objects().initializeQuadrilateral(6, 3);
    ArrayList<Quadrilateral> quad7 = new Objects().initializeQuadrilateral(7, 3);
    ArrayList<Quadrilateral> quad8 = new Objects().initializeQuadrilateral(8, 3);
    ArrayList<Quadrilateral> quad9 = new Objects().initializeQuadrilateral(9, 3);
    ArrayList<Quadrilateral> quad10 = new Objects().initializeQuadrilateral(10, 3);
    ArrayList<Quadrilateral> quad11 = new Objects().initializeQuadrilateral(11, 3);
    ArrayList<Quadrilateral> quad12 = new Objects().initializeQuadrilateral(12, 3);
    ArrayList<Quadrilateral> quad13 = new Objects().initializeQuadrilateral(13, 3);
    
    float angle = radians(angles[0]);
    r = (int) (127 + 127 * cos(angle));
    g = (int) (127 + 127 * cos(angle + TWO_PI / 3));
    b = (int) (127 + 127 * cos(angle + 2 * TWO_PI / 3));
    
    y = arduino.analogRead(5);
    y = (float)Math.log(2*y)*25;
    
    if (y < 75) {
        y = 75;
    } else  if (y > 125) {
        y = 125;
    }
    
    a a = new a();
    if (a.e() == true) {
        System.out.println("Registered Click: #" + i);
        i++;
        if (!jumpState) {
          jumpState = true;
          tRef = millis();
         }
    }
    
    if (jumpState) {
      double t = (millis() - tRef) / 1000.0;
      x = ac * t * t + v0 * t;
      
      System.out.println("T: " + t);
      System.out.println("X: " + x);
      
      if (x < 0) {
        x = 0;
        jumpState = false;
      }
    }
    
    // Render box
    renderQuadrilateral(quad2, false, r, g, b, 2);
    // Render green eyes
    renderQuadrilateral(quad13, false, 0, 255, 0, 1);
    renderQuadrilateral(quad12, false, 0, 255, 0, 1);
    // Render red wattles
    renderQuadrilateral(quad6, false, 255, 0, 0, 1);
    // Render red beak
    renderQuadrilateral(quad5, false, 255, 100, 0, 1);
    // Render red comb
    renderQuadrilateral(quad4, false, 255, 0, 0, 1);
    // Render orange legs
    renderQuadrilateral(quad8, false, 255, 100, 0, 1);
    renderQuadrilateral(quad9, false, 255, 100, 0, 1);
    // Render orange feet
    renderQuadrilateral(quad10, false, 255, 100, 0, 1);
    renderQuadrilateral(quad11, false, 255, 100, 0, 1);
    // Render white body
    renderQuadrilateral(quad3, false, 255, 255, 255, 1);
    renderQuadrilateral(quad7, false, 255, 255, 255, 1);
}

/*
void mousePressed() {
  if (!jumpState) {
    jumpState = true;
    tRef = millis();
  }
}
*/

class a {
    protected boolean x;
    boolean e() {
        long currentTime = millis();
        if (currentTime - lastClickTime > debounceDelay) {
          x = false;
          if (y != 75 && o == true) {
              lastClickTime = currentTime;
              x = true;
          }
        }
        return x;
    }
    public a() {
        if (y < 90) {
            o = true;
        } else {
            o = false;
        }
    }
}

void renderQuadrilateral(ArrayList<Quadrilateral> quads, boolean cb, int rc, int bc, int gc, float w) {
    for (Quadrilateral quad : quads) {
        // v1, v2, v3, v4, and c must be defined

        Vertex v1 = transform.transform(quad.v1);
        Vertex v2 = transform.transform(quad.v2);
        Vertex v3 = transform.transform(quad.v3);
        Vertex v4 = transform.transform(quad.v4);
        
        stroke(rc, bc, gc);
        strokeWeight(w);
    
        line((float) v1.x, (float) v1.y, (float) v2.x, (float) v2.y);
        line((float) v2.x, (float) v2.y, (float) v3.x, (float) v3.y);
        line((float) v3.x, (float) v3.y, (float) v4.x, (float) v4.y);
        line((float) v4.x, (float) v4.y, (float) v1.x, (float) v1.y);
        
        if (cb==true) {
            Gradient c = quad.c;
            beginShape();
            fill(c.sR, c.sG, c.sB);
            vertex((float) v1.x, (float) v1.y);
            vertex((float) v2.x, (float) v2.y);
            vertex((float) v3.x, (float) v3.y);
            vertex((float) v4.x, (float) v4.y);
            endShape(CLOSE); 
        }
    }  
}

void renderTriangle(ArrayList<Triangle> tr, boolean cb, int rc, int bc, int gc) {
     for (Triangle triangle : tr) {
         // v1, v2, v3, and c must be defined
          Vertex v1 = transform.transform(triangle.v1);
          Vertex v2 = transform.transform(triangle.v2);
          Vertex v3 = transform.transform(triangle.v3);
          
          stroke(rc, bc, gc);
  
          line((float) v1.x, (float) v1.y, (float) v2.x, (float) v2.y);
          line((float) v2.x, (float) v2.y, (float) v3.x, (float) v3.y);
          line((float) v3.x, (float) v3.y, (float) v1.x, (float) v1.y);
          if (cb==true) {
              Gradient c = triangle.c;
              beginShape();
              fill(c.sR, c.sG, c.sB);
              vertex((float) v1.x, (float) v1.y);
              vertex((float) v2.x, (float) v2.y);
              vertex((float) v3.x, (float) v3.y);
              endShape(CLOSE); 
          }
      }
}

void renderSphere(ArrayList<Sphere> spheres, boolean cb, int rc, int bc, int gc) {
    for (Sphere sphere : spheres) {
        Vertex center = transform.transform(sphere.o);
        float radius = (float) sphere.r;

        stroke(rc, bc, gc);
        noFill();
        ellipse((float) center.x, (float) center.y, radius * 2, radius * 2);

        if (cb) {
            Gradient c = sphere.c;
            fill(c.sR, c.sG, c.sB);
            ellipse((float) center.x, (float) center.y, radius * 2, radius * 2);
        }
    }
}

void updateTransform() {
    float heading = radians(angles[0]);
    Matrix3 headingTransform = new Matrix3(new double[]{
        cos(heading), 0, -sin(heading),
        0, 1, 0,
        sin(heading), 0, cos(heading)
    });

    float pitch = radians(angles[1]);
    Matrix3 pitchTransform = new Matrix3(new double[]{
        1, 0, 0,
        0, cos(pitch), sin(pitch),
        0, -sin(pitch), cos(pitch)
    });

    transform = headingTransform.multiply(pitchTransform);
}

void mouseDragged() {
    float sensitivity = 0.33; // Adjustable Value
    float yIncrement = sensitivity * (pmouseY - mouseY);
    float xIncrement = sensitivity * (mouseX - pmouseX);
    angles[0] += xIncrement;
    angles[1] += yIncrement;
    redraw();

    updateTransform();
}

class Path {
    ArrayList<PVector> points;

    Path() {
        points = new ArrayList<PVector>();
    }

    void moveTo(float x, float y) {
        points.add(new PVector(x, y));
    }
    
    void lineTo(float x, float y) {
        points.add(new PVector(x, y));
    }
    
    void closePath() {
        if (points.size() > 0) {
            PVector first = points.get(0);
            points.add(first);
        }
    }
}

class Vertex {
    double x;
    double y;
    double z;
    Vertex(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}

class Gradient {
    int sR;
    int sG;
    int sB;
    int eR;
    int eG;
    int eB;

    Gradient(int sR, int sG, int sB, int eR, int eG, int eB) {
        this.sR = sR;
        this.sG = sG;
        this.sB = sB;
        this.eR = eR;
        this.eG = eG;
        this.eB = eB;
    }

    int calculateGradientColor(float p) {
        int r = (int) (sR + (eR - sR) * p);
        int g = (int) (sG + (eG - sG) * p);
        int b = (int) (sB + (eB - sB) * p);
        return color(r, g, b);
    }
}

class Triangle {
    Vertex v1;
    Vertex v2;
    Vertex v3;
    Gradient c;
    Triangle(Vertex v1, Vertex v2, Vertex v3, Gradient c) {
        this.v1 = v1;
        this.v2 = v2;
        this.v3 = v3;
        this.c = c;
    }
}

class Quadrilateral {
    Vertex v1;
    Vertex v2;
    Vertex v3;
    Vertex v4;
    Gradient c;
    Quadrilateral(Vertex v1, Vertex v2, Vertex v3, Vertex v4, Gradient c) {
        this.v1 = v1;
        this.v2 = v2;
        this.v3 = v3;
        this.v4 = v4;
        this.c = c;
    }
}

class Sphere {
    Vertex o;
    double r;
    Gradient c;
    Sphere(Vertex o, double r, Gradient c) {
        this.o = o;
        this.r = r;
        this.c = c;
    }
}

class Objects {
    ArrayList initializeTriangle(int n) {
        ArrayList<Triangle> t = new ArrayList<Triangle>();
        if (n==1) {
            t.add(new Triangle(new Vertex(100, 100, 100),
                new Vertex(-100, -100, 100),
                new Vertex(-100, 100, -100),
                new Gradient(255, 0, 0, 255, 0, 0)));
            t.add(new Triangle(new Vertex(100, 100, 100),
                            new Vertex(-100, -100, 100),
                            new Vertex(100, -100, -100),
                            new Gradient(0, 255, 0, 0, 255, 0)));
            t.add(new Triangle(new Vertex(-100, 100, -100),
                            new Vertex(100, -100, -100),
                            new Vertex(100, 100, 100),
                            new Gradient(0, 0, 255, 0, 0, 255)));
            t.add(new Triangle(new Vertex(-100, 100, -100),
                            new Vertex(100, -100, -100),
                            new Vertex(-100, -100, 100),
                            new Gradient(255, 0, 255, 255, 0, 255)));
        }
        if (n>1) {
            exit();
        }
        return t;
    }
    
    ArrayList initializeQuadrilateral(int n, double p) {
        ArrayList<Quadrilateral> q = new ArrayList<Quadrilateral>();
        // Define arrays for the 3D constructions
        if (n==1) {
            Vertex r1 = new Vertex((int)(100*p), (int)(100*p) - (int)x*s, (int)(100*p));
            Vertex r2 = new Vertex((int)(-100*p), (int)(100*p) - (int)x*s, (int)(100*p));
            Vertex r3 = new Vertex((int)(-100*p), (int)(-100*p) - (int)x*s, (int)(100*p));
            Vertex r4 = new Vertex((int)(100*p), (int)(-100*p) - (int)x*s, (int)(100*p));
            Vertex r5 = new Vertex((int)(100*p), (int)(100*p) - (int)x*s, (int)(-100*p));
            Vertex r6 = new Vertex((int)(-100*p), (int)(100*p) - (int)x*s, (int)(-100*p));
            Vertex r7 = new Vertex((int)(-100*p), (int)(-100*p) - (int)x*s, (int)(-100*p));
            Vertex r8 = new Vertex((int)(100*p), (int)(-100*p) - (int)x*s, (int)(-100*p));

            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 0, 0, 255, 0, 0)));
        } else if (n==2) {
            Vertex r1 = new Vertex((int)(200*p), (int)(200*p), (int)(200*p));
            Vertex r2 = new Vertex((int)(-200*p), (int)(200*p), (int)(200*p));
            Vertex r3 = new Vertex((int)(-200*p), (int)(-200*p), (int)(200*p));
            Vertex r4 = new Vertex((int)(200*p), (int)(-200*p), (int)(200*p));
            Vertex r5 = new Vertex((int)(200*p), (int)(200*p), (int)(-200*p));
            Vertex r6 = new Vertex((int)(-200*p), (int)(200*p), (int)(-200*p));
            Vertex r7 = new Vertex((int)(-200*p), (int)(-200*p), (int)(-200*p));
            Vertex r8 = new Vertex((int)(200*p), (int)(-200*p), (int)(-200*p));

            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 0, 0, 255, 0, 0)));
        } else if (n==3) {
            Vertex r1 = new Vertex((int)(30*p), (int)(60*p) - (int)(x*s), (int)(25*p));
            Vertex r2 = new Vertex((int)(-30*p), (int)(60*p) - (int)(x*s), (int)(25*p));
            Vertex r3 = new Vertex((int)(-30*p), (int)(-60*p) - (int)(x*s), (int)(25*p));
            Vertex r4 = new Vertex((int)(30*p), (int)(-60*p) - (int)(x*s), (int)(25*p));
            Vertex r5 = new Vertex((int)(30*p), (int)(60*p) - (int)(x*s), (int)(-25*p));
            Vertex r6 = new Vertex((int)(-30*p), (int)(60*p) - (int)(x*s), (int)(-25*p));
            Vertex r7 = new Vertex((int)(-30*p), (int)(-60*p) - (int)(x*s), (int)(-25*p));
            Vertex r8 = new Vertex((int)(30*p), (int)(-60*p) - (int)(x*s), (int)(-25*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==4) {
            Vertex r1 = new Vertex((int)(10*p), (int)(-75*p) - (int)(x*s), (int)(15*p));
            Vertex r2 = new Vertex((int)(-10*p), (int)(-75*p) - (int)(x*s), (int)(15*p));
            Vertex r3 = new Vertex((int)(-10*p), (int)(-60*p) - (int)(x*s), (int)(15*p));
            Vertex r4 = new Vertex((int)(10*p), (int)(-60*p) - (int)(x*s), (int)(15*p));
            Vertex r5 = new Vertex((int)(10*p), (int)(-75*p) - (int)(x*s), (int)(-15*p));
            Vertex r6 = new Vertex((int)(-10*p), (int)(-75*p) - (int)(x*s), (int)(-15*p));
            Vertex r7 = new Vertex((int)(-10*p), (int)(-60*p) - (int)(x*s), (int)(-15*p));
            Vertex r8 = new Vertex((int)(10*p), (int)(-60*p) - (int)(x*s), (int)(-15*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==5) {
            Vertex r1 = new Vertex((int)(10*p), (int)(-50*p) - (int)(x*s), (int)(25*p));
            Vertex r2 = new Vertex((int)(-10*p), (int)(-50*p) - (int)(x*s), (int)(25*p));
            Vertex r3 = new Vertex((int)(-10*p), (int)(-30*p) - (int)(x*s), (int)(25*p));
            Vertex r4 = new Vertex((int)(10*p), (int)(-30*p) - (int)(x*s), (int)(25*p));
            Vertex r5 = new Vertex((int)(10*p), (int)(-50*p) - (int)(x*s), (int)(60*p));
            Vertex r6 = new Vertex((int)(-10*p), (int)(-50*p) - (int)(x*s), (int)(60*p));
            Vertex r7 = new Vertex((int)(-10*p), (int)(-30*p) - (int)(x*s), (int)(60*p));
            Vertex r8 = new Vertex((int)(10*p), (int)(-30*p) - (int)(x*s), (int)(60*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==6) {
            Vertex r1 = new Vertex((int)(10*p), (int)(-30*p) - (int)(x*s), (int)(25*p));
            Vertex r2 = new Vertex((int)(-10*p), (int)(-30*p) - (int)(x*s), (int)(25*p));
            Vertex r3 = new Vertex((int)(-10*p), (int)(-10*p) - (int)(x*s), (int)(25*p));
            Vertex r4 = new Vertex((int)(10*p), (int)(-10*p) - (int)(x*s), (int)(25*p));
            Vertex r5 = new Vertex((int)(10*p), (int)(-30*p) - (int)(x*s), (int)(45*p));
            Vertex r6 = new Vertex((int)(-10*p), (int)(-30*p) - (int)(x*s), (int)(45*p));
            Vertex r7 = new Vertex((int)(-10*p), (int)(-10*p) - (int)(x*s), (int)(45*p));
            Vertex r8 = new Vertex((int)(10*p), (int)(-10*p) - (int)(x*s), (int)(45*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==7) {
            Vertex r1 = new Vertex((int)(30*p), (int)(60*p) - (int)(x*s), (int)(25*p));
            Vertex r2 = new Vertex((int)(-30*p), (int)(60*p) - (int)(x*s), (int)(25*p));
            Vertex r3 = new Vertex((int)(-30*p), (int)(20*p) - (int)(x*s), (int)(25*p));
            Vertex r4 = new Vertex((int)(30*p), (int)(20*p) - (int)(x*s), (int)(25*p));
            Vertex r5 = new Vertex((int)(30*p), (int)(60*p) - (int)(x*s), (int)(-60*p));
            Vertex r6 = new Vertex((int)(-30*p), (int)(60*p) - (int)(x*s), (int)(-60*p));
            Vertex r7 = new Vertex((int)(-30*p), (int)(20*p) - (int)(x*s), (int)(-60*p));
            Vertex r8 = new Vertex((int)(30*p), (int)(20*p) - (int)(x*s), (int)(-60*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==8) {
            Vertex r1 = new Vertex((int)(25*p), (int)(60*p) - (int)(x*s), (int)(-15*p));
            Vertex r2 = new Vertex((int)(15*p), (int)(60*p) - (int)(x*s), (int)(-15*p));
            Vertex r3 = new Vertex((int)(15*p), (int)(80*p) - (int)(x*s), (int)(-15*p));
            Vertex r4 = new Vertex((int)(25*p), (int)(80*p) - (int)(x*s), (int)(-15*p));
            Vertex r5 = new Vertex((int)(25*p), (int)(60*p) - (int)(x*s), (int)(-25*p));
            Vertex r6 = new Vertex((int)(15*p), (int)(60*p) - (int)(x*s), (int)(-25*p));
            Vertex r7 = new Vertex((int)(15*p), (int)(80*p) - (int)(x*s), (int)(-25*p));
            Vertex r8 = new Vertex((int)(25*p), (int)(80*p) - (int)(x*s), (int)(-25*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==9) {
            Vertex r1 = new Vertex((int)(-25*p), (int)(60*p) - (int)(x*s), (int)(-15*p));
            Vertex r2 = new Vertex((int)(-15*p), (int)(60*p) - (int)(x*s), (int)(-15*p));
            Vertex r3 = new Vertex((int)(-15*p), (int)(80*p) - (int)(x*s), (int)(-15*p));
            Vertex r4 = new Vertex((int)(-25*p), (int)(80*p) - (int)(x*s), (int)(-15*p));
            Vertex r5 = new Vertex((int)(-25*p), (int)(60*p) - (int)(x*s), (int)(-25*p));
            Vertex r6 = new Vertex((int)(-15*p), (int)(60*p) - (int)(x*s), (int)(-25*p));
            Vertex r7 = new Vertex((int)(-15*p), (int)(80*p) - (int)(x*s), (int)(-25*p));
            Vertex r8 = new Vertex((int)(-25*p), (int)(80*p) - (int)(x*s), (int)(-25*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==10) {
            Vertex r1 = new Vertex((int)(-30*p), (int)(80*p) - (int)(x*s), 0);
            Vertex r2 = new Vertex((int)(-10*p), (int)(80*p) - (int)(x*s), 0);
            Vertex r3 = new Vertex((int)(-10*p), (int)(90*p) - (int)(x*s), 0);
            Vertex r4 = new Vertex((int)(-30*p), (int)(90*p) - (int)(x*s), 0);
            Vertex r5 = new Vertex((int)(-30*p), (int)(80*p) - (int)(x*s), (int)(-30*p));
            Vertex r6 = new Vertex((int)(-10*p), (int)(80*p) - (int)(x*s), (int)(-30*p));
            Vertex r7 = new Vertex((int)(-10*p), (int)(90*p) - (int)(x*s), (int)(-30*p));
            Vertex r8 = new Vertex((int)(-30*p), (int)(90*p) - (int)(x*s), (int)(-30*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==11) {
            Vertex r1 = new Vertex((int)(30*p), (int)(80*p) - (int)(x*s), 0);
            Vertex r2 = new Vertex((int)(10*p), (int)(80*p) - (int)(x*s), 0);
            Vertex r3 = new Vertex((int)(10*p), (int)(90*p) - (int)(x*s), 0);
            Vertex r4 = new Vertex((int)(30*p), (int)(90*p) - (int)(x*s), 0);
            Vertex r5 = new Vertex((int)(30*p), (int)(80*p) - (int)(x*s), (int)(-30*p));
            Vertex r6 = new Vertex((int)(10*p), (int)(80*p) - (int)(x*s), (int)(-30*p));
            Vertex r7 = new Vertex((int)(10*p), (int)(90*p) - (int)(x*s), (int)(-30*p));
            Vertex r8 = new Vertex((int)(30*p), (int)(90*p) - (int)(x*s), (int)(-30*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==12) {
            Vertex r1 = new Vertex((int)(30*p), (int)(-50*p) - (int)(x*s), (int)(15*p));
            Vertex r2 = new Vertex((int)(20*p), (int)(-50*p) - (int)(x*s), (int)(15*p));
            Vertex r3 = new Vertex((int)(20*p), (int)(-40*p) - (int)(x*s), (int)(15*p));
            Vertex r4 = new Vertex((int)(30*p), (int)(-40*p) - (int)(x*s), (int)(15*p));
            Vertex r5 = new Vertex((int)(30*p), (int)(-50*p) - (int)(x*s), (int)(5*p));
            Vertex r6 = new Vertex((int)(20*p), (int)(-50*p) - (int)(x*s), (int)(5*p));
            Vertex r7 = new Vertex((int)(20*p), (int)(-40*p) - (int)(x*s), (int)(5*p));
            Vertex r8 = new Vertex((int)(30*p), (int)(-40*p) - (int)(x*s), (int)(5*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else if (n==13) {
            Vertex r1 = new Vertex((int)(-30*p), (int)(-50*p) - (int)(x*s), (int)(15*p));
            Vertex r2 = new Vertex((int)(-20*p), (int)(-50*p) - (int)(x*s), (int)(15*p));
            Vertex r3 = new Vertex((int)(-20*p), (int)(-40*p) - (int)(x*s), (int)(15*p));
            Vertex r4 = new Vertex((int)(-30*p), (int)(-40*p) - (int)(x*s), (int)(15*p));
            Vertex r5 = new Vertex((int)(-30*p), (int)(-50*p) - (int)(x*s), (int)(5*p));
            Vertex r6 = new Vertex((int)(-20*p), (int)(-50*p) - (int)(x*s), (int)(5*p));
            Vertex r7 = new Vertex((int)(-20*p), (int)(-40*p) - (int)(x*s), (int)(5*p));
            Vertex r8 = new Vertex((int)(-30*p), (int)(-40*p) - (int)(x*s), (int)(5*p));
            
            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 255, 255, 255, 255)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 255, 255, 255, 255, 255)));
        } else {
            exit();
        }
        return q;
    }
    
    ArrayList initializeSpheres(int n) {
        ArrayList<Sphere> s = new ArrayList<Sphere>();
        
        if (n==1) {
            Vertex center1 = new Vertex(-200, 0, 0);
            double radius1 = 50;
            s.add(new Sphere(center1, radius1, new Gradient(255, 0, 0, 255, 0, 0)));
        }
        
        if (n==2) {
            Vertex center2 = new Vertex(200, 0, 0);
            double radius2 = 70;
            s.add(new Sphere(center2, radius2, new Gradient(0, 255, 0, 0, 255, 0)));
        }
        
        if (n>2) {
            exit();
        }
        return s;
    }
}

class Matrix3 {
    double[] values;
    Matrix3(double[] values) {
        this.values = values;
    }
    Matrix3 multiply(Matrix3 other) {
        double[] result = new double[9];
        for (int row = 0; row < 3; row++) {
            for (int col = 0; col < 3; col++) {
                for (int i = 0; i < 3; i++) {
                    result[row * 3 + col] +=
                        this.values[row * 3 + i] * other.values[i * 3 + col];
                }
            }
        }
        return new Matrix3(result);
    }
    Vertex transform(Vertex vinput) {
        return new Vertex(
            vinput.x * values[0] + vinput.y * values[3] + vinput.z * values[6],
            vinput.x * values[1] + vinput.y * values[4] + vinput.z * values[7],
            vinput.x * values[2] + vinput.y * values[5] + vinput.z * values[8]
        );
    }
}
