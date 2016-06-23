Textlabel xyLabel;

void createGUI() {
  guiControl = new ControlP5(this);
  guiControl.begin(guiControl.addBackground("GUI"));
  guiControl.addToggle("displayInput")
    .setLabel("Display video image")
    .setPosition(20, 30)
    .setSize(20, 20);
  guiControl.addLabel("Tracking")
    .setPosition(20, 80)
    .setColor(color(255, 255, 0));
  guiControl.addSlider("threshold")
    .setLabel("OpenCV threshold")
    .setPosition(20, 100)
    .setRange(0, 255)
    .setSize(100, 20);
  guiControl.addSlider("distanceThreshold")
    .setLabel("Distance threshold (max speed)")
    .setPosition(20, 130)
    .setRange(0, 255)
    .setSize(100, 20);
  guiControl.addSlider("minArea")
    .setLabel("Minimum Euglena size")
    .setPosition(20, 160)
    .setRange(0, 1000)
    .setSize(100, 20);
  guiControl.addSlider("maxArea")
    .setLabel("Maximum Euglena size")
    .setPosition(20, 190)
    .setRange(0, 10000)
    .setSize(100, 20);
  xyLabel = guiControl.addLabel("Mean x/y motion: "+mdx+" "+mdy)
    .setPosition(20, 220);
  guiControl.addLabel("Input")
    .setPosition(20, 250)
    .setColor(color(255, 255, 0));
  guiControl.addRadioButton("inputSelector")
    .setPosition(20, 270)
    .setSize(40, 20)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(1)
    .setSpacingColumn(50)
    .setNoneSelectedAllowed(false)
    .addItem("File: "+filename, 0)
    .addItem("Webcam", 1)
    .addItem("Syphon", 2);
  /*
  guiControl.addNumberbox("syphonWidth")
    .setPosition(20, 390)
    .setSize(60, 20)
    .setScrollSensitivity(1.1)
    .setLabel("Syphon width");
  guiControl.addNumberbox("syphonHeight")
    .setPosition(100, 390)
    .setSize(60, 20)
    .setScrollSensitivity(1.1)
    .setLabel("Syphon height");
    */
  guiControl.addNumberbox("webcamWidth")
    .setPosition(20, 350)
    .setSize(60, 20)
    .setScrollSensitivity(1.1)
    .setLabel("Webcam width");
  guiControl.addNumberbox("webcamHeight")
    .setPosition(100, 350)
    .setSize(60, 20)
    .setScrollSensitivity(1.1)
    .setLabel("Webcam height");
  guiControl.addLabel("OSC")
    .setPosition(20, 450)
    .setColor(color(255, 255, 0));
  guiControl.addTextfield("setOscTargetIP")
    .setPosition(20, 470)
    .setSize(200, 40)
    .setFont(createFont("arial", 20))
    .setAutoClear(false)
    .setText(oscTargetIP)
    .setLabel("OSC target IP");
  guiControl.addLabel("[H]ide GUI")
    .setPosition(20, 550)
    .setColor(color(255, 255, 0));
  guiControl.end();
}

boolean fileDialogTrigger = false;

void inputSelector(int a) {
  switch (a) {
  case 0:
    fileDialogTrigger= true; 
    break;
  case 1:
    input.stop();
    input = new CameraInput(this, webcamWidth, webcamHeight);
    opencv = new OpenCV(this, input.width, input.height);
    
    background(0);
    break;
  case 2:
    input.stop();
    input = new EOSInput(this);
    opencv = new OpenCV(this, input.width, input.height);
    break;
  }
}

/** Necessary because inputSelector is called again on next click if no mouseReleased has been registered -- which happens when a file dialog is directly opened by inputSelector :( */
void mouseReleased() {
  if (fileDialogTrigger) {
    fileDialogTrigger = false;
    selectInput("Select video file:", "fileSelected");
  }
}

void updateGUILabels() {
  xyLabel.setValue("Mean x/y motion: "+nfs(mdx,2,4)+" "+nfs(mdy,2,4));
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    input.stop();
    filename = selection.getAbsolutePath();
    input = new VideofileInput(this, filename);
    println("OH: "+input.width);
    guiControl.get(RadioButton.class, "inputSelector").getItem(0).setLabel("File: "+selection.getName());
  }
}

void setOscTargetIP(String theText) {
  oscTargetIP = theText;
  oscP5 = new OscP5(this, 8001);
  oscTargetHost = new NetAddress(oscTargetIP, 8000);
}

void keyPressed() {
  if (key=='h') {
    guiControl.setVisible(!guiControl.isVisible());
  }
}