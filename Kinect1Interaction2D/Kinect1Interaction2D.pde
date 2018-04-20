/**
 * INTERACTION ENGINEERING
 * (c) 2017 Michael Kipp
 * http://interaction.hs-augsburg.de
 *
 * Example for Kinect 1 interaction with 2D objects
 *
 * Requires Processing 2 (old version) with library SimpleOpenNI
 */

import SimpleOpenNI.*;
import java.util.*;

List<InteractiveThing> things = new ArrayList<InteractiveThing>();
List points = new ArrayList();
SimpleOpenNI context;

void setup()
{
  context = new SimpleOpenNI(this);

  context.enableDepth(); // Tiefenbild ein
  context.enableUser(); // Skeletterkennung ein
  context.setMirror(true); // funktioniert derzeit nicht

  size(context.depthWidth(), context.depthHeight());

  things.add(new InteractiveRect(50, 50, 140, 100));
  things.add(new InteractiveRect(50, 300, 140, 100));
  things.add(new InteractiveRect(450, 50, 140, 100));
  things.add(new InteractiveRect(450, 300, 140, 100));
  things.add(new InteractiveCircle(150, 240, 100));
  things.add(new InteractiveCircle(520, 250, 80));
}

void draw()
{
  background(200);

  context.update();

  for (int i=1; i<=10; i++)
  {
    if (context.isTrackingSkeleton(i))
    {
      points.clear();
      drawSkeleton(i);   
      highlightJoint(i, SimpleOpenNI.SKEL_HEAD, color(#FFBE43), 250);
      points.add(highlightJoint(i, SimpleOpenNI.SKEL_LEFT_HAND, color(#FF3C1A), 100));
      points.add(highlightJoint(i, SimpleOpenNI.SKEL_RIGHT_HAND, color(#3EFF45), 100));
      for (InteractiveThing thing: things) {
        thing.update(points);
      }
    }
  }

  // Alle objekte zeichnen
  for (InteractiveThing thing: things) {
    thing.draw();
  }
}

PVector highlightJoint(int userId, int limbID, color col, float size)
{
  stroke(0);
  strokeWeight(2);
  // get 3D position of a joint
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId, limbID, jointPos);

  // convert real world point to projective space
  PVector jointPos_Proj = new PVector();
  context.convertRealWorldToProjective(jointPos, jointPos_Proj);

  // create a distance scalar related to the depth (z dimension)
  float distanceScalar = (500 / jointPos_Proj.z);

  // set the fill colour to make the circle green
  fill(col);

  // draw the circle at the position of the head with the head size scaled by the distance scalar
  ellipse(jointPos_Proj.x, jointPos_Proj.y, distanceScalar*size, distanceScalar*size);

  return jointPos_Proj;
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{  
  stroke(0);
  strokeWeight(2);
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
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

