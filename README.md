# EuglenaTracking

[EuglenaTracking](EuglenaTracking) provides tracking of Euglena via Syphon, Webcam or video file. Broadcasts mean Euglena x/y motion as well as position and ID number of all Euglena via OSC.

### Installation
- Download Processing
- Download github zip (https://github.com/lscherff/biogames/archive/master.zip) 
- In Processing
  - open EuglenaTracking/EuglenaTracking.pde
  - Sketch/Libraries/Import Library.../Add Library...: oscP5, Syphon, Video, controlP5 (and openCV if possible)
- Alternative openCV installation (e.g. on Mac OS): 
  - Download https://github.com/atduskgreg/opencv-processing/releases/download/latest/opencv_processing.zip
  - Place folder from zip in Processing libraries folder (e.g. Documents/Processing/libraries/)
  - Restart(!) Processing
  
# Biogames Workshop

Processing sketches for the *[Biogames Workshop](http://www.uni-weimar.de/medien/wiki/Workshop_on_BioGames)*.

## TrackEuglenaSyphonOSC (old)

[TrackEuglenaSyphonOSC](TrackEuglenaSyphonOSC) provides some simple tracking of Euglena gracilis through the EOS camera and microscope. Camera connection based on [EOS Webcam Demo](eos_webcam_demo).

##  EOS Webcam Demo (old)

The [EOS Webcam Demo](eos_webcam_demo) shows how to get live video from the EOS camera we have mounted on our microscope.  The sketch lets you zoom into a predefined area and process it with OpenCV.

### Usage
Press space to toggle between overview and image processing mode.

### Note
You need the OpenCV and Syphon libraries for this sketch.  
To grab images from our EOS camera please install and run the [camera-live](https://github.com/v002/v002-Camera-Live/releases) syphon server:


### Important
You must change debug to false to get a video from the EOS camera.
Otherwise this sketch will use the builtin isight camera or a regular USB-webcam.

## License

GPL licensed.
