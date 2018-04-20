interface InteractiveThing {
  void draw();
  void update(List<PVector> points);
}

class InteractiveRect implements InteractiveThing {

  int rx = 0;
  int ry = 0;
  int rwidth;
  int rheight;
  boolean selected = false;

  InteractiveRect(int x, int y, int w, int h) {
    rx = x;
    ry = y;
    rwidth = w;
    rheight = h;
  }

  void draw() {
    noStroke();
    if (selected)
      fill(255, 0, 0);
    else
      fill(100);
    rect(rx, ry, rwidth, rheight);
  }

  void update(List<PVector> points) {
    selected = false;
    for (PVector v: points) {
      if ((rx <= v.x && v.x <= rx + rwidth &&
      ry <= v.y && v.y <= ry + rheight))
        selected = true;
    }
  }
}

class InteractiveCircle implements InteractiveThing {

  int cx = 0;
  int cy = 0;
  int diameter;
  boolean selected = false;

  InteractiveCircle(int x, int y, int d) {
    cx = x;
    cy = y;
    diameter = d;
  }

  void draw() {
    noStroke();
    if (selected)
      fill(255, 0, 0);
    else
      fill(255);
    ellipse(cx, cy, diameter, diameter);
  }

  void update(List<PVector> points) {
    selected = false;
    for (PVector v: points) {
      if (dist(v.x, v.y, cx, cy) < diameter/2)
        selected = true;
    }
  }
}
