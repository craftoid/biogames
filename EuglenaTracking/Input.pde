private class InputDevice {
  public int width, height;
  public InputDevice() {
  }
  public PImage getNextImage() {
    return null;
  }
  public void stop() {
  }
}

private class CameraInput extends InputDevice {
  Capture camera;
  public CameraInput(PApplet parent, int cwidth, int cheight) {
    println(Capture.list());
    camera = new Capture(parent, cwidth, cheight);
    this.width = cwidth;
    this.height = cheight;
    camera.start();
  }
  public PImage getNextImage() {
      return camera;
  }
  public void stop() {
    camera.stop();
  }
}

private class VideofileInput extends InputDevice {
  Movie video;
  public VideofileInput(PApplet parent, String filename) {
    video = new Movie(parent, filename);
    video.loop();
    this.width = video.width;
    this.height = video.height;
  }
  public PImage getNextImage() {
    if (video.width>0) return video;
    else return null;
  }
  public void stop() {
    video.stop();
  }
}

private class EOSInput extends InputDevice {
  SyphonClient eos;
  public EOSInput(PApplet parent) {
    eos = new SyphonClient(parent, "Camera Live", "Canon EOS 5D Mark II");
    this.width = syphonWidth;
    this.height = syphonHeight;
  }
  public PImage getNextImage() {
    if (eos.newFrame()) {
      return eos.getImage(inputImage);
    } else return null;
  }
}

void movieEvent(Movie m) {
  m.read();
  if (input.width==0) {
    input.width = m.width;
    input.height = m.height;
    println("W&H is "+input.width+", "+input.height);
    opencv = new OpenCV(this, 1920, 1080);
  }
}

void captureEvent(Capture c) {
  c.read();
}