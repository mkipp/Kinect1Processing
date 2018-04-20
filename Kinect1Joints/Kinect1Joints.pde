/**
 * INTERACTION ENGINEERING
 * (c) 2017 Michael Kipp
 * http://interaction.hs-augsburg.de
 *
 * Sketch for KINECT v1 (old version)
 *
 * Shows skeleton joints.
 *
 * Requires Processing 2 (old version) with library SimpleOpenNI
 */

import SimpleOpenNI.*;
import java.util.*;

SimpleOpenNI context;
boolean mirror = true;

void setup()
{
  context = new SimpleOpenNI(this);
  context.enableDepth(); // Tiefenbild ein
  context.enableUser(); // Skeletterkennung ein
  size(context.depthWidth(), context.depthHeight());
}

void draw()
{
  background(200);
  context.update();
  for (int i=1; i<=10; i++)
  {
    if (context.isTrackingSkeleton(i))
    {
      drawJoint(i, SimpleOpenNI.SKEL_LEFT_HAND, color(#FF3C1A), 100);
      drawJoint(i, SimpleOpenNI.SKEL_RIGHT_HAND, color(#3EFF45), 100);
      drawJoint(i, SimpleOpenNI.SKEL_HEAD, color(150), 50);
      drawJoint(i, SimpleOpenNI.SKEL_NECK, color(150), 50);
      drawJoint(i, SimpleOpenNI.SKEL_LEFT_SHOULDER, color(150), 50);
      drawJoint(i, SimpleOpenNI.SKEL_LEFT_ELBOW, color(150), 50);
      drawJoint(i, SimpleOpenNI.SKEL_RIGHT_SHOULDER, color(150), 50);
      drawJoint(i, SimpleOpenNI.SKEL_RIGHT_ELBOW, color(150), 50);
    }
  }
}

void drawJoint(int userId, int limbID, color col, float size)
{
  stroke(0);
  strokeWeight(2);
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId, limbID, jointPos);

  // convert real world point to projective space
  PVector jointPos_Proj = new PVector();
  context.convertRealWorldToProjective(jointPos, jointPos_Proj);

  // mirror x coord
  if (mirror) {
    jointPos_Proj.x = context.depthWidth() - jointPos_Proj.x;
  }

  // create a distance scalar related to the depth (z dimension)
  float distanceScalar = (500 / jointPos_Proj.z);
  fill(col);
  ellipse(jointPos_Proj.x, jointPos_Proj.y, distanceScalar*size, distanceScalar*size);
}

// Event-based Methods

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("New user id = " + userId);
  context.startTrackingSkeleton(userId);
}

void onLostUser(int userId)
{
  println("User lost id = " + userId);
}

