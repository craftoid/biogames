# Biogames Workshop

Processing sketches for the *[Biogames Workshop](http://www.uni-weimar.de/medien/wiki/Workshop_on_BioGames)*.

## TrackEuglenaSyphonOSC

[TrackEuglenaSyphonOSC](TrackEuglenaSyphonOSC) provides some simple tracking of Euglena gracilis through the EOS camera and microscope. Camera connection based on [EOS Webcam Demo](eos_webcam_demo).

##  EOS Webcam Demo

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
