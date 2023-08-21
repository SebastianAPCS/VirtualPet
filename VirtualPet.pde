// Processing code is below

ArrayList<Triangle> triangles;
ArrayList<Quadrilateral> quadrilaterals;
Matrix3 transform;
float[] angles = new float[2];

void setup() {
    size(800, 600);
    triangles = new Objects().initializeTriangles();
    quadrilaterals = new Objects().initializeQuadrilaterals();
    angles[0] = 0;
    angles[1] = 0;

    updateTransform();
}
void draw() {
    background(0);
    translate(width / 2, height / 2);
    stroke(255);
    
    /* 
    for (Triangle triangle : triangles) {
        Vertex v1 = transform.transform(triangle.v1);
        Vertex v2 = transform.transform(triangle.v2);
        Vertex v3 = transform.transform(triangle.v3);

        // Draw lines between vertices
        line((float) v1.x, (float) v1.y, (float) v2.x, (float) v2.y);
        line((float) v2.x, (float) v2.y, (float) v3.x, (float) v3.y);
        line((float) v3.x, (float) v3.y, (float) v1.x, (float) v1.y);
    }
    */

    for (Quadrilateral quad : quadrilaterals) {
        Vertex v1 = transform.transform(quad.v1);
        Vertex v2 = transform.transform(quad.v2);
        Vertex v3 = transform.transform(quad.v3);
        Vertex v4 = transform.transform(quad.v4);

        line((float) v1.x, (float) v1.y, (float) v2.x, (float) v2.y);
        line((float) v2.x, (float) v2.y, (float) v3.x, (float) v3.y);
        line((float) v3.x, (float) v3.y, (float) v4.x, (float) v4.y);
        line((float) v4.x, (float) v4.y, (float) v1.x, (float) v1.y);
                
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
    float sensitivity = 0.33; // Adjust this value for higher sensitivity
    float yIncrement = sensitivity * (pmouseY - mouseY);
    float xIncrement = sensitivity * (mouseX - pmouseX);
    angles[0] += xIncrement;
    angles[1] += yIncrement;

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

class Circle {
    Vertex o;
    double r;
    Gradient c;
    Circle(Vertex o, Gradient c, double r) {
        this.o = o;
        this.c = c;
        this.r = r;
    }
}

class Objects {
    ArrayList initializeTriangles() {
        ArrayList t = new ArrayList<>();
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
        return t;
    }
    ArrayList initializeQuadrilaterals() {
        ArrayList q = new ArrayList<>();
                // Define vertices for the 3D rectangle
        Vertex r1 = new Vertex(100, 100, 100);
        Vertex r2 = new Vertex(-100, 100, 100);
        Vertex r3 = new Vertex(-100, -100, 100);
        Vertex r4 = new Vertex(100, -100, 100);
        Vertex r5 = new Vertex(100, 100, -100);
        Vertex r6 = new Vertex(-100, 100, -100);
        Vertex r7 = new Vertex(-100, -100, -100);
        Vertex r8 = new Vertex(100, -100, -100);

        // Create quadrilaterals for the 3D rectangle
        q.add(new Quadrilateral(r1, r2, r3, r4, new Gradient(255, 0, 0, 255, 0, 0)));
        q.add(new Quadrilateral(r5, r6, r7, r8, new Gradient(0, 255, 0, 0, 255, 0)));
        q.add(new Quadrilateral(r1, r2, r6, r5, new Gradient(0, 0, 255, 0, 0, 255)));
        q.add(new Quadrilateral(r2, r3, r7, r6, new Gradient(255, 0, 255, 255, 0, 255)));
        q.add(new Quadrilateral(r3, r4, r8, r7, new Gradient(255, 255, 0, 255, 255, 0)));
        q.add(new Quadrilateral(r1, r4, r8, r5, new Gradient(0, 255, 255, 0, 255, 255)));
        
        return q;
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
    Vertex transform(Vertex in) {
        return new Vertex(
            in.x * values[0] + in.y * values[3] + in.z * values[6],
            in.x * values[1] + in.y * values[4] + in.z * values[7],
            in.x * values[2] + in.y * values[5] + in.z * values[8]
        );
    }
}
