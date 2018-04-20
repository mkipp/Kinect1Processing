/**
 * INTERACTION ENGINEERING
 * (c) 2017 Michael Kipp
 * http://interaction.hs-augsburg.de
 *
 * Sketch for KINECT v1 (old version)
 *
 * Record data with Kinect 1.
 *
 * Requires Processing 2 (old version) with library SimpleOpenNI
 */

import SimpleOpenNI.*;

SimpleOpenNI context;

final boolean SHOW_KINECT = false;
boolean showPointCloud = true; // show until person detected
ArrayList<Pose> recording = new ArrayList<Pose>();
boolean isRecording = false;
boolean isPlaying = false;
int playbackFrame = 0;

color colSkeleton = #0DFFF9;

float zoomF =0.5f;
float rotX = radians(180);  
float rotY = radians(0);

void setup()
{
  size(1024, 768, P3D);  
  context = new SimpleOpenNI(this);
  context.setMirror(false);
  context.enableDepth();
  context.enableUser();
  stroke(255);
  smooth();  
  perspective(radians(45), float(width)/float(height), 10, 150000);
}

void draw()
{
  context.update();
  background(0);

  // text info
  textSize(20);
  textAlign(CENTER);
  fill(200);
  text("Kinect 1 Recorder", width/2, 150);
  textSize(12);
  text("space=play/pause    enter=record/stop    backspace=clear", width/2, 170);

  // rec symbol
  if (isRecording) {
    noStroke();
    fill(255, 0, 0);
    ellipse(width-200, 150, 30, 30);
  }

  // play symbol
  if (isPlaying) {
    noStroke();
    fill(#00FF0A);
    triangle(200, 140, 200, 170, 220, 155);
  }

  // scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  translate(0, 0, -1000);  // set the rotation center of the scene 1000 infront of the camera

  if (isPlaying) {
    if (playbackFrame < recording.size()) {
      Pose pose = recording.get(playbackFrame);
      pose.render();
      playbackFrame++;
    } else {
      playbackFrame = 0;
    }
  } else {
    int[] userList = context.getUsers();
    for (int i=0; i<userList.length; i++)
    {
      if (context.isTrackingSkeleton(userList[i]))
        drawSkeleton(userList[i]);

      if (isRecording) {
        recording.add(new Pose(userList[i]));
      }
    }
  }

  if (SHOW_KINECT) 
    context.drawCamFrustum();
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  if (isRecording) {
    stroke(255, 0, 0);
  } else {
    stroke(colSkeleton);
  }
  strokeWeight(3);
  drawBone(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  drawBone(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawBone(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawBone(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  drawBone(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawBone(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawBone(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  drawBone(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawBone(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawBone(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  drawBone(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawBone(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  drawBone(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawBone(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawBone(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

void drawBone(int userId, int jointType1, int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  context.getJointPositionSkeleton(userId, jointType1, jointPos1);
  context.getJointPositionSkeleton(userId, jointType2, jointPos2);
  line(jointPos1.x, jointPos1.y, jointPos1.z, jointPos2.x, jointPos2.y, jointPos2.z);
}

// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  context.startTrackingSkeleton(userId);
  showPointCloud = false;
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  showPointCloud = true;
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
}

void keyPressed()
{
  switch(key)
  {
  case ' ':
    isPlaying = !isPlaying;
    break;
  }

  switch(keyCode)
  {
  case ENTER:
    isRecording = !isRecording;
    break;
  case BACKSPACE:
    println("del");
    recording.clear();
    playbackFrame = 0;
    isPlaying = false;
    isRecording = false;
    break;
  }
}

