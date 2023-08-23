/*
Created by Sebastian Dowell in 2023 for Mr. Chan's APCS Virtual Pet assignment.

Inspiration taken from https://www.alibabacloud.com/blog/construct-a-simple-3d-rendering-engine-with-java_599599
*/

// Processing code resides below

// Initial global declarations
ArrayList<Triangle> triangles;
ArrayList<Quadrilateral> quadrilaterals;
Matrix3 transform;
float[] angles = new float[2];

int r = 255; // (int) (255 * Math.random());;
int g = 255; // (int) (255 * Math.random());;
int b = 0; // (int) (255 * Math.random());;

ArrayList<Quadrilateral> quad1 = new Objects().initializeQuadrilateral(1);
ArrayList<Quadrilateral> quad2 = new Objects().initializeQuadrilateral(2);
ArrayList<Triangle> tri1 = new Objects().initializeTriangle(1);
ArrayList<Sphere> s1 = new Objects().initializeSpheres(1);

public void setup() {
    size(800, 600);
    strokeWeight(10);
    
    angles[0] = 0;
    angles[1] = 0;

    updateTransform();
}

void draw() {
    background(0);
    translate(width / 2, height / 2);
    
    renderQuadrilateral(quad1, false, r, g, b);
    renderQuadrilateral(quad2, false, r, g, b);
    renderTriangle(tri1, false, r, g, b);
    renderSphere(s1, false, r, g, b);
}

void renderQuadrilateral(ArrayList<Quadrilateral> quads, boolean cb, int rc, int bc, int gc) {
    for (Quadrilateral quad : quads) {
        // v1, v2, v3, v4, and c must be defined

        Vertex v1 = transform.transform(quad.v1);
        Vertex v2 = transform.transform(quad.v2);
        Vertex v3 = transform.transform(quad.v3);
        Vertex v4 = transform.transform(quad.v4);
        
        stroke(rc, bc, gc);
    
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
    
    ArrayList initializeQuadrilateral(int n) {
        ArrayList<Quadrilateral> q = new ArrayList<Quadrilateral>();
        // Define arrays for the 3D constructions
        if (n==1) {
            Vertex r1 = new Vertex(100, 100, 100);
            Vertex r2 = new Vertex(-100, 100, 100);
            Vertex r3 = new Vertex(-100, -100, 100);
            Vertex r4 = new Vertex(100, -100, 100);
            Vertex r5 = new Vertex(100, 100, -100);
            Vertex r6 = new Vertex(-100, 100, -100);
            Vertex r7 = new Vertex(-100, -100, -100);
            Vertex r8 = new Vertex(100, -100, -100);

            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 0, 0, 255, 0, 0)));
        }
        if (n==2) {
            Vertex r1 = new Vertex(200, 200, 200);
            Vertex r2 = new Vertex(-200, 200, 200);
            Vertex r3 = new Vertex(-200, -200, 200);
            Vertex r4 = new Vertex(200, -200, 200);
            Vertex r5 = new Vertex(200, 200, -200);
            Vertex r6 = new Vertex(-200, 200, -200);
            Vertex r7 = new Vertex(-200, -200, -200);
            Vertex r8 = new Vertex(200, -200, -200);

            q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 0, 0, 255, 0, 0)));
            q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(255, 0, 0, 255, 0, 0)));
        }
        if (n>2) {
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
