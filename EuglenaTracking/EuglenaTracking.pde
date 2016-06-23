/**
 Simple Euglena tracking. 
 Using a video file, webcam or Syphon (for microscope live footage) as input source. (Using https://github.com/craftoid/biogames/tree/master/eos_webcam_demo )
 Sending mean x-/y-motion and positions, speed and size of all Euglena via OSC
 */
import oscP5.*;
import netP5.*;
import codeanticode.syphon.*;
import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;
import java.util.ListIterator;
import controlP5.*;

InputDevice input;
OpenCV opencv;

OscP5 oscP5;
NetAddress oscTargetHost;
String oscTargetIP = "127.0.0.1";

ControlP5 guiControl;

int syphonWidth = 1024;
int syphonHeight = 680;

int webcamWidth = 1920;
int webcamHeight = 1080;

String filename = "Euglena_short.mov";

PImage inputImage;
PGraphics canvas;

ArrayList<Contour> contours;
ArrayList<Euglena> euglenaList;
int euglenaCounter = 0;

int threshold = 128;  // threshold for image processing
float distanceThreshold = 75;  // max distance from frame to frame (greater distances are assumed to be distinct objects)
float minArea = 200;  // minimun area of Euglena bounding box
float maxArea = 7000;  // maximun area of Euglena bounding box
boolean displayInput = true;

float mdx = 0;  // mean x-movement
float mdy = 0;  // mean y-movement

void settings() {
  size(displayWidth, displayHeight, P3D);
  PJOGL.profile = 1;
}

public void setup() {
  surface.setResizable(true);
  input = new VideofileInput(this, filename);
  // uncomment for start without input
  //input = new InputDevice();
  opencv = new OpenCV(this, input.width, input.height);
  euglenaList = new ArrayList<Euglena>();
  oscP5 = new OscP5(this, 8001);
  oscTargetHost = new NetAddress(oscTargetIP, 8000);
  createGUI();
  textSize(20);
}

public void draw() {
  background(0);
  inputImage = input.getNextImage();
  if (inputImage != null && opencv!=null) {
    trackEuglena();
  }
  updateGUILabels();
}

void trackEuglena() {
  opencv.loadImage(inputImage);
  opencv.gray();
  opencv.invert();
  opencv.erode();
  opencv.dilate();
  opencv.threshold(threshold);

  /*
  pushMatrix();
   scale(1,-1);
   image(cam, 0, -height);
   image(cam, 0, 0);
   popMatrix();
   */

  pushMatrix();
  if (inputImage.width < width || inputImage.height < height) {
    translate((width-inputImage.width)/2, (height-inputImage.height)/2);
  }

  if (displayInput) image(inputImage, 0, 0);
  else image(opencv.getOutput(), 0, 0);

  contours = opencv.findContours();

  noFill();
  strokeWeight(3);

  float largest = 0;
  int lp = 0;
  int i=0;
  float mx = 0;
  float my = 0;
  int count = 0;

  for (Contour contour : contours) {
    float a = contour.area();
    Rectangle r = contour.getBoundingBox();
    float wh = float(r.width)/float(r.height);
    if (a > minArea && wh > 0.1 && wh < 10 && a < maxArea) {
      findClosestEuglena(contour);
      //println(euglenaList);
      stroke(0, 255, 0);
      contour.draw();

      float centerX = r.x+r.width/2;
      float centerY = r.y+r.height/2;
      mx = mx + centerX;
      my = my + centerY;
      count++;
      line(centerX-10, centerY, centerX+10, centerY);
      line(centerX, centerY-10, centerX, centerY+10);
      i++;
    }
  }
  checkEuglena();
  popMatrix();

  sendOSCData();
}

void sendOSCData() {
  OscMessage mdxy = new OscMessage("/meand");
  mdxy.add(new float[] { mdx, mdy });
  oscP5.send(mdxy, oscTargetHost);

  for (Euglena e : euglenaList) {
    float[] euglenaOSCdata = new float[7];
    euglenaOSCdata[0] = e.id;
    euglenaOSCdata[1] = e.x / input.width;
    euglenaOSCdata[2] = e.y / input.width;
    euglenaOSCdata[3] = e.width / (float)input.width;  // width of bounding box
    euglenaOSCdata[4] = e.height / (float)input.width;;  // height of bounding box
    euglenaOSCdata[5] = e.dx / input.width;  // dx
    euglenaOSCdata[6] = e.dy / input.width;  // dy
    OscMessage euglenaMSG = new OscMessage("/euglena");
    euglenaMSG.add(euglenaOSCdata);
    oscP5.send(euglenaMSG, oscTargetHost);
  }
}