/**
Even quicker and dirtier: Keeping Euglena in a list. 
Identity of contours is maintained from frame to frame based on proximity.
*/
void checkEuglena(Contour c) {
  boolean found = false;
  Rectangle r = c.getBoundingBox();
  for (Euglena e : euglenaList) {
    if (dist(e.x, e.y, r.x, r.y) < distanceThreshold) {
      e.dx = e.x - r.x;
      e.dy = e.y - r.y;
      e.x = r.x;
      e.y = r.y;
      e.found = true;
      found = true;
      break;
    }
  }
  if (!found) {
    euglenaList.add(new Euglena(r.x, r.y));
  }
}

void deleteEuglena() {
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
  public Euglena(float x, float y) {
    this.x = x;
    this.y = y;
  }
  float x;
  float y;
  float dx;
  float dy;
  boolean found = true;
}
