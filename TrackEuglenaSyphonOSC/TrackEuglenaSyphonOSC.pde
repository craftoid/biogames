/**
Quick and dirty Euglena tracking via Syphon (for microscope live footage). Using https://github.com/craftoid/biogames/tree/master/eos_webcam_demo
Sending mean x-/y-motion of all Euglena via OSC

threshold for image processing is set via mouse (left-right). 

Other parameters:
debug -- use webcam/syphon (true/false)
distanceThreshold -- max distance from frame to frame (greater distances are assumed to be distinct objects)
minArea -- minimun area of Euglena bounding box
maxArea -- maximun area of Euglena bounding box
oscTargetIP -- IP of target host for OSC
*/

import oscP5.*;
import netP5.*;

import codeanticode.syphon.*;
import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;
import java.util.ListIterator;

boolean debug = true;

SyphonClient eos;
Capture webcam;
OpenCV opencv;

OscP5 oscP5;
NetAddress oscTargetHost;
String oscTargetIP = "141.54.53.212";

int camWidth = 1024;
int camHeight = 680;

PImage cam;
PGraphics canvas;

ArrayList<Contour> contours;
ArrayList<Euglena> euglenaList;

int threshold;  // threshold for image processing
float distanceThreshold = 20;  // max distance from frame to frame (greater distances are assumed to be distinct objects)
float minArea = 200;  // minimun area of Euglena bounding box
float maxArea = 4000;  // maximun area of Euglena bounding box

float mdx = 0;  // mean x-movement
float mdy = 0;  // mean y-movement

public void setup() {
  size(camWidth, camHeight, P3D);

  if (!debug) {
    // use the eos webcam
    eos = new SyphonClient(this, "Camera Live", "Canon EOS 5D Mark II");
    println(eos);
  } else {
    // use a standard webcam / isight
    println(Capture.list());
    camWidth = 640;
    camHeight = 480;
    webcam = new Capture(this, camWidth, camHeight);
    webcam.start();
  }
  
  opencv = new OpenCV(this, camWidth, camHeight);
  
  euglenaList = new ArrayList<Euglena>();
  oscP5 = new OscP5(this, 8001);
  oscTargetHost = new NetAddress(oscTargetIP, 8000);
  
  background(0);
}


public void draw() {
  if (!debug) {
    if (eos.available()) {
      cam = eos.getImage(cam);
    } else return;
  } else {
    if (webcam.available()) {
      webcam.read();
      cam = webcam;
    }
  }

  if (cam != null) {
    opencv.loadImage(cam);

    opencv.gray();
    opencv.invert();
    
    opencv.erode();
    opencv.dilate();
    
    threshold = int(map(mouseX,0,width,0,255));
    opencv.threshold(threshold);

    /*
    pushMatrix();
    scale(1,-1);
    image(cam, 0, -height);
    image(cam, 0, 0);
    popMatrix();
    */
    image(opencv.getOutput(), 0, 0);
    fill(0,255,0);
    textSize(44);
    text("Threshold: "+threshold, 20, 50);
    noFill();

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
        checkEuglena(contour);
        stroke(0, 255, 0);
        contour.draw();
        
        float centerX = r.x+r.width/2;
        float centerY = r.y+r.height/2;
        mx = mx + centerX;
        my = my + centerY;
        count++;
        line(centerX-10,centerY,centerX+10,centerY);
        line(centerX,centerY-10,centerX,centerY+10);
        i++;
      }
    }

  }
  deleteEuglena();
  fill(0, 255,0);
  textSize(44);
  text("Left/right: "+nfc(mdx,2), 20, 100);
  text("Up/down: "+nfc(mdy,2), 20, 150);
  noFill();
  sendOSCData();
}

void keyPressed() {
  saveFrame();
}

void sendOSCData() {
  println("Sending delta x,y as "+mdx+", "+mdy);
  OscMessage myMessage = new OscMessage("/meand");
  myMessage.add(new float[] { mdx, mdx });
  oscP5.send(myMessage, oscTargetHost);
}
