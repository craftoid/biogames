
//////////////////////////////////////////////////////////////////
//                                                              //
//                      EOS Webcam Demo                         //
//                                                              //
//////////////////////////////////////////////////////////////////

// This sketch shows how to get live video from the EOS camera we have mounted on our microscope.
// The sketch lets you zoom into a predefined area and process it with OpenCV.

// USAGE:
// Press space to toggle between overview and image processing mode.

// NOTE:
// You need the OpenCV and Syphon libraries for this sketch.
// To grab images from our EOS camera please install and run the camera-live syphon server
// https://github.com/v002/v002-Camera-Live/releases

// IMPORTANT:
// You must change debug to false to get a video from the EOS camera.
// Otherwise this sketch will use the builtin isight camera or a regular USB-webcam.

boolean debug = true;

import codeanticode.syphon.*;
import processing.video.*;
import gab.opencv.*;

SyphonClient eos;
Capture webcam;
OpenCV opencv;

int camWidth = 1024;
int camHeight = 680;
float aspect = float(camWidth) / camHeight;

int zoomWidth = 600;
int zoomHeight = int(zoomWidth / aspect);
int zoomX, zoomY;

float zoomFactor = float(camWidth) / zoomWidth;

PImage cam;
PGraphics canvas;
boolean overview = true;


public void setup() {

  size(camWidth, camHeight);

  if (!debug) {
    // use the eos webcam
    eos = new SyphonClient(this, "Camera Live", "Canon EOS 5D Mark II");
    println(eos);
  } else {
    // use a standard webcam / isight
    webcam = new Capture(this, camWidth, camHeight);
    webcam.start();
  }
  
  zoomX = (camWidth - zoomWidth) / 2;
  zoomY = (camHeight - zoomHeight) / 2;
  opencv = new OpenCV(this, zoomWidth, zoomHeight);
  
  background(0);

}


public void draw() {

  // capture an image
  if (!debug) {
    if (eos.available()) {
      cam = eos.getImage(cam);
    }
  } else {
    if (webcam.available()) {
      webcam.read();
      cam = webcam;
    }
  }

  // do something with the image
  if (cam != null) {

    if (overview) {
      
      // Camera view with a white rectangle showing the zoom area
      image(cam, 0, 0);
      stroke(255);
      fill(255, 50);
      rect(zoomX, zoomY, zoomWidth, zoomHeight);

    } else {
      
      // zoom in
      PImage img = cam.get(zoomX, zoomY, zoomWidth, zoomHeight);
      // do some image processing with OpenCV ...
      img = processImage(img);
      // draw the result
      image(img, 0, 0, camWidth, camHeight);

    }

  }
}


// do some image processing with OpenCV
PImage processImage(PImage img) {
  opencv.loadImage(img);
  opencv.threshold(80);
  return opencv.getSnapshot();
}


// Press any key to toggle zoom mode
void keyPressed() {
  overview = !overview;
}


// drag the zoom area
void mouseDragged() {

  if(overview) {
    // draggin the rectangle in overview mode
    zoomX += mouseX - pmouseX;
    zoomY += mouseY - pmouseY;
  } else {
    // dragging the canvas in zoom mode
    zoomX -= int((mouseX - pmouseX) / zoomFactor);
    zoomY -= int((mouseY - pmouseY) / zoomFactor);
  }
  
}

