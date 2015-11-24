/**
 Keeping Euglena in a list. 
 Identity of contours is maintained from frame to frame based on proximity.
 */
void findClosestEuglena(Contour c) {
  Rectangle r = c.getBoundingBox();
  float mindist = distanceThreshold;
  Euglena closest = null;
  if (euglenaList.size() > 0) {
    mindist = dist(euglenaList.get(0).x, euglenaList.get(0).y, r.x, r.y);
    closest = euglenaList.get(0);
  }
  for (Euglena e : euglenaList) {
    float d = dist(e.x, e.y, r.x, r.y);
    if (d < mindist) {
      mindist = d;
      closest = e;
    }
  }
  if (mindist < distanceThreshold) {
    closest.found = true;
    closest.dx = closest.x - r.x;
    closest.dy = closest.y - r.y;
    closest.x = r.x;
    closest.y = r.y;
  } else {
    euglenaList.add(new Euglena(r.x, r.y, ++euglenaCounter));
    //print(euglenaCounter+", ");
  }
}

void checkEuglena() {
  ListIterator<Euglena> iter = euglenaList.listIterator();
  float newmdx = 0;
  float newmdy = 0;
  while (iter.hasNext()) {
    Euglena e = iter.next();
    if (e.found==false) iter.remove();
    else {
      e.found = false;
      newmdx = newmdx + e.dx;
      newmdy = newmdy + e.dy;
      text(e.id+"", e.x, e.y);
    }
  }
  if (euglenaList.size() > 0) {
    newmdx = newmdx / euglenaList.size();
    newmdy = newmdy / euglenaList.size();
  } else {
    newmdx = 0;
    newmdy = 0;
  }
  mdx += (newmdx - mdx)*0.01;
  mdy += (newmdy - mdy)*0.01;
}

class Euglena {
  public Euglena(float x, float y, int id) {
    this.x = x;
    this.y = y;
    this.id = id;
  }
  float x;
  float y;
  float dx;
  float dy;
  int id;
  boolean found = true;
  public String toString() {
    return "("+x+","+y+")";
  }
}