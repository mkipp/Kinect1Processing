/**
 * Stores a single pose.
 */

class Pose {
  PVector[] data = new PVector[20];

  Pose(int userId) {
    fillData(userId, SimpleOpenNI.SKEL_HEAD);
    fillData(userId, SimpleOpenNI.SKEL_NECK);
    fillData(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    fillData(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
    fillData(userId, SimpleOpenNI.SKEL_LEFT_HAND);
    fillData(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    fillData(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    fillData(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
    fillData(userId, SimpleOpenNI.SKEL_TORSO);
    fillData(userId, SimpleOpenNI.SKEL_LEFT_HIP);
    fillData(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
    fillData(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
    fillData(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
    fillData(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
    fillData(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
  }

  void fillData(int userId, int jointType) {
    data[jointType] = new PVector();
    context.getJointPositionSkeleton(userId, jointType, data[jointType]);
  }

  void render() {
    stroke(#00FF0A);
    strokeWeight(3);
    drawBone(SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
    drawBone(SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    drawBone(SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    drawBone(SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
    drawBone(SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    drawBone(SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    drawBone(SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
    drawBone(SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    drawBone(SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    drawBone(SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    drawBone(SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    drawBone(SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
    drawBone(SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    drawBone(SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    drawBone(SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  }

  void drawBone(int jointType1, int jointType2)
  {
    PVector jointPos1 = data[jointType1];
    PVector jointPos2 = data[jointType2];
    line(jointPos1.x, jointPos1.y, jointPos1.z, jointPos2.x, jointPos2.y, jointPos2.z);
  }
}

