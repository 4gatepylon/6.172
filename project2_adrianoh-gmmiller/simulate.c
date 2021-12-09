/**
 * Author: Isabel Rosa, isrosa@mit.edu
 **/

// START `Disable red squiggly marks (check piazza)`
// My understanding is that this fixes the red squigglies by giving
// it a thing to find without having to search inside cilk (because
// vscode is not smart enough to search in there).
#ifndef _CILK_H
#define _CILK_H
#ifdef __cilk
#define cilk_spawn _Cilk_spawn
#define cilk_sync _Cilk_sync
#define cilk_for _Cilk_for
#else
// #define cilk_spawn
// #define cilk_sync (void)0;
// #define cilk_for for
#endif /* __cilk*/
#endif /* _CILK_H */
// END `Disable red squiggly marks (check piazza)`

#include "simulate.h"

#include <assert.h>
#include <cilk/cilk.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "render.h"

// There may be a need to use a bounding box epsilon to deal with round-off
// error... It's also possible that we may find a better way around that, but
// for now we will by default add BB_EPS
#ifndef BB_EPS
#define BB_EPS 0.0f
#endif

#ifndef HEURISTIC_STOP_RATIO
#define HEURISTIC_STOP_RATIO 4
#endif

// Start as null at the beginning of the program
#ifndef NULL_PTR
#define NULL_PTR 0
#endif

double G;
int bodies, numSpheres;
sphere *spheres;

//////////////////////////////////////////////////////////////// SORTING
// Do insertion sort between start and end, inclusive on start and exclusive on
// end.
static inline void insertion_sort(sphere *spheres, int start, int end) {
  sphere key;
  for (int i = start + 1; i < end; i++) {
    key = copySphere(spheres[i]);
    int j = i - 1;

    while (j >= start && spheres[j].eye_face_dist > key.eye_face_dist) {
      spheres[j + 1] = copySphere(spheres[j]);
      j = j - 1;
    }
    spheres[j + 1] = key;
  }
}

// MODIFIED
// Is this possible to efficiently optimize?
void sort(sphere *spheres, int n, vector e) {
  // Cache the distances so that we won't have to re-calculate every time
  for (int i = 0; i < bodies; i++) {
    spheres[i].eye_face_dist = qdist(spheres[i].pos, e) - spheres[i].r;
  }
  insertion_sort(spheres, 0, bodies);
  // Linear time sphere copy
  for (int i = 0; i < bodies; i++) {
    spheres[i + bodies] = copySphere(spheres[i]);
  }
}

//////////////////////////////////////////////////////////////// END SORTING
//////////////////////////////////////////////////////////////// NEW

// Accelerate pairs
inline __attribute__((always_inline)) void updateAccelPair(int i, int j,
                                                           dvector *accels) {
  vector i_minus_j = qsubtract(spheres[i].pos, spheres[j].pos);
  vector j_minus_i = scale(-1, i_minus_j);
  double i_minus_j_size = (double)qsize(i_minus_j);
  vector accel =
      scale(G / (i_minus_j_size * i_minus_j_size * i_minus_j_size), j_minus_i);
  accels[i] = dqadd(accels[i], dscale(spheres[j].mass, vectorToDVector(accel)));
  accels[j] =
      dqsubtract(accels[j], dscale(spheres[i].mass, vectorToDVector(accel)));
}

// When the size of the shape we are trying to update
// accel pairs of is less than SERIAL_THRESHOLD
// we process them in serial rather than in parallel
#define SERIAL_THRESHOLD 32

void updateAccelRectangle(int i_start, int i_end, int j_start, int j_end,
                          dvector *accels) {
  if (j_end - j_start < SERIAL_THRESHOLD) {
    for (int i = i_start; i < i_end; i++) {
      for (int j = j_start; j < j_end; j++) {
        updateAccelPair(i, j, accels);
      }
    }
    return;
  } else {
    int i_split = (i_end + i_start) / 2;
    int j_split = (j_end + j_start) / 2;
    // Figure 5, purple rectangles
    cilk_spawn updateAccelRectangle(i_start, i_split, j_start, j_split, accels);
    updateAccelRectangle(i_split, i_end, j_split, j_end, accels);
    cilk_sync;
    // green rectangles
    cilk_spawn updateAccelRectangle(i_split, i_end, j_start, j_split, accels);
    updateAccelRectangle(i_start, i_split, j_split, j_end, accels);
    cilk_sync;
  }
}

void updateAccelRecursive(int i_start, int i_end, int j_start, int j_end,
                          dvector *accels) {
  if (j_end - j_start < SERIAL_THRESHOLD) {
    for (int i = i_start; i < i_end; i++) {
      for (int j = i + 1; j < j_end; j++) {
        updateAccelPair(i, j, accels);
      }
    }
    return;
  } else {
    int i_split = (i_end + i_start) / 2;
    int j_split = (j_end + j_start) / 2;

    // top triangle:
    // i_start -> split_i
    // j_start -> split_j
    // bottom triangle:
    // i_split -> i_end
    // j_split -> j_end
    // rectange:
    // i_split -> i_end
    // j_start -> j_split
    //
    // Handle triangles first:
    cilk_spawn updateAccelRecursive(i_start, i_split, j_start, j_split, accels);
    updateAccelRecursive(i_split, i_end, j_split, j_end, accels);
    cilk_sync;
    updateAccelRectangle(i_start, i_split, j_split, j_end, accels);
  }
}

// NEW
void updateAccelerationsNew(dvector *accels) {
  updateAccelRecursive(0, bodies, 0, bodies, accels);

  cilk_for(int i = 0; i < bodies; i++) {
    spheres[i + bodies].accel = dvectorToVector(accels[i]);
  }
  cilk_for(int i = 0; i < bodies; i++) { accels[i] = newDVector(0, 0, 0); }
}

// ORIGINAL
void updateVelocities(float t) {
  for (int i = 0; i < bodies; i++) {
    spheres[i + bodies].vel = qadd(spheres[i].vel, scale(t, spheres[i].accel));
  }
}

// NEW
void updateVelocitiesNew(float t) {
  cilk_for(int i = 0; i < bodies; i++) {
    spheres[i + bodies].vel = qadd(spheres[i].vel, scale(t, spheres[i].accel));
  }
}

// ORIGINAL
void updatePositions(float t) {
  for (int i = 0; i < bodies; i++) {
    spheres[i + bodies].pos = qadd(spheres[i].pos, scale(t, spheres[i].vel));
  }
}

// NEW
void updatePositionsNew(float t) {
  cilk_for(int i = 0; i < bodies; i++) {
    spheres[i + bodies].pos = qadd(spheres[i].pos, scale(t, spheres[i].vel));
  }
}

// NEW
void doMiniStepWithCollisionsNew(float minCollisionTime, int i, int j) {
  // Update by finding the next set of sphere values and writing them into a set
  // of spheres in the second half of the array. It is split into [current
  // spheres] [next spheres] in two halves each of length `bodies`.
  // We did accelerations previously
  updateVelocitiesNew(minCollisionTime);
  updatePositionsNew(minCollisionTime);
  for (int k = 0; k < bodies; k++) {
    spheres[k] = copySphere(spheres[k + bodies]);
  }
  // This signals zero collisions
  if (i == -1 || j == -1) {
    return;
  }
  vector distVec = qsubtract(spheres[i].pos, spheres[j].pos);
  float scale1 = 2 * spheres[j].mass /
                 (float)((double)spheres[i].mass + (double)spheres[j].mass);
  float scale2 = 2 * spheres[i].mass /
                 (float)((double)spheres[i].mass + (double)spheres[j].mass);
  float distNorm = qdot(distVec, distVec);
  vector velDiff = qsubtract(spheres[i].vel, spheres[j].vel);
  vector scaledDist = scale(qdot(velDiff, distVec) / distNorm, distVec);
  spheres[i].vel = qsubtract(spheres[i].vel, scale(scale1, scaledDist));
  spheres[j].vel = qsubtract(spheres[j].vel, scale(-1 * scale2, scaledDist));
}

// NEW
// check if the spheres at indices i and j collide in the next
// timeLeft timesteps
// modifies mag to contain the frame-of-reference-adjusted velocity
// of sphere j in sphere i's frame of reference
int checkForCollisionOpt(int i, int j, float timeLeft, float *mag) {
  vector distVec = qsubtract(spheres[i].pos, spheres[j].pos);
  float distSq = qdot(distVec, distVec);
  float sumRadii = (float)((double)spheres[i].r + (double)spheres[j].r);

  // Shift frame of reference to act like sphere i is stationary
  vector movevec = scale(
      timeLeft,
      qsubtract(qadd(spheres[j].vel, scale(0.5 * timeLeft, spheres[j].accel)),
                qadd(spheres[i].vel, scale(0.5 * timeLeft, spheres[j].accel))));

  // Break if the length the sphere moves in timeLeft time is less than
  // distance between the centers of these spheres minus their radii
  // TODO movevecSq may cause floating point errors
  float movevecSq = qdot(movevec, movevec);
  float movevecSize = sqrt(movevecSq);
  float sumRadiiSquared = sumRadii * sumRadii;
  if (movevecSq + 2 * movevecSize * sumRadii + sumRadiiSquared <
          (double)distSq ||
      (movevec.x == 0 && movevec.y == 0 && movevec.z == 0)) {
    return 0;
  }

  vector unitMovevec = scale(1 / movevecSize, movevec);

  // distAlongMovevec = ||distVec|| * cos(angle between unitMovevec and distVec)
  float distAlongMovevec = qdot(unitMovevec, distVec);

  // Check that sphere j is moving towards sphere i
  if (distAlongMovevec <= 0) {
    return 0;
  }

  float jToMovevecDistSq =
      (float)((double)(distSq) - (double)(distAlongMovevec * distAlongMovevec));

  // Break if the closest that sphere j will get to sphere i is more than
  // the sum of their radii
  if (jToMovevecDistSq >= sumRadiiSquared) {
    return 0;
  }

  // We now have jToMovevecDistSq and sumRadii, two sides of a right triangle.
  // Use these to find the third side, sqrt(T)
  float extraDist = (float)((double)sumRadiiSquared - (double)jToMovevecDistSq);

  if (extraDist < 0) {
    return 0;
  }

  // Draw out the spheres to check why this is the distance sphere j moves
  // before hitting sphere i;)
  float distance = (float)((double)distAlongMovevec - (double)sqrt(extraDist));

  // Break if the distance sphere j has to move to touch sphere i is too big
  *mag = movevecSize;
  if (*mag < distance) {
    return 0;
  }

  return 1;
}

// NEW
int checkForCollisionNew(int i, int j, float timeLeft, float *mag) {
  return checkForCollisionOpt(i, j, timeLeft, mag);
}

// SHARED
#define TIME_LEFT_EPS 0.000001

// NEW
void newDoTimeStep(float timeStep) {
  float timeLeft = timeStep;
  dvector *accels = (dvector *)calloc(bodies, sizeof(dvector));

  // If collisions are getting too frequent, we cut time step early
  // This allows for smoother rendering without losing accuracy
  while (timeLeft > TIME_LEFT_EPS) {
    // We do this at the beginning to have the right speeds so that we can see
    // if things can collide on the eye to ball ray axis.
    updateAccelerationsNew(accels);
    cilk_for(int i = 0; i < bodies; i++) {
      spheres[i].speed = qsize(spheres[i].vel);
    }

    float minCollisionTime = timeLeft;
    int indexCollider1 = -1;
    int indexCollider2 = -1;

    // Iterate through the spheres and decrease timestep every time that there
    // is a collision between the two timesteps This code is not correct, but
    // theirs isn't either :)
    for (int i = 0; i < bodies; i++) {
      int j = i + 1;
      float back_face_dist = spheres[i].eye_face_dist + 2 * spheres[i].r;
      // Heuristic early stop that might not work for super quickly accelerating
      // spheres The assumption is that if both move at most at the max of their
      // respective velocities in that same axis in the minimum time then they
      // will just barely touch, but otherwise not really. We ignore the
      // instantaneous acceleration since it's probably not a lot in that
      // direction.
      assert(HEURISTIC_STOP_RATIO > 1);
      while (j < bodies &&
             (spheres[j].eye_face_dist -
              (minCollisionTime * (spheres[i].speed + spheres[j].speed)) *
                  HEURISTIC_STOP_RATIO) < back_face_dist) {
        float refFrameAdjustedVelMag;
        if (checkForCollisionNew(i, j, timeLeft, &refFrameAdjustedVelMag)) {
          vector movevec =
              qadd(spheres[j].vel, scale(0.5 * timeLeft, spheres[j].accel));
          float touchTimePct =
              timeLeft * qsize(movevec) / refFrameAdjustedVelMag;

          if (touchTimePct > 1) {
            touchTimePct = 1 / touchTimePct;
          }
          if ((touchTimePct * timeLeft) < minCollisionTime) {
            minCollisionTime = touchTimePct * timeLeft;
            indexCollider1 = i;
            indexCollider2 = j;
          }
        }  // END COLL DET
        j++;
      }
    }  // END OUTER LOOP
    doMiniStepWithCollisionsNew(minCollisionTime, indexCollider1,
                                indexCollider2);
    timeLeft = timeLeft - minCollisionTime;
  }  // END WHILE
  // END FUNC

  free(accels);
}
// NEW
void simulate() { newDoTimeStep(1 / log(bodies)); }

//////////////////////////////////////////////////////////////// END NEW
//////////////////////////////////////////////////////////////// OLD/ORIGINAL

// ORIGINAL
void updateAccelSphere(int i) {
  double rx = 0;
  double ry = 0;
  double rz = 0;

  spheres[i + bodies].accel = newVector(0, 0, 0);
  for (int j = 0; j < bodies; j++) {
    if (i != j) {
      vector i_minus_j = qsubtract(spheres[i].pos, spheres[j].pos);
      vector j_minus_i = scale(-1, i_minus_j);
      vector force =
          scale(G * spheres[j].mass / pow(qsize(i_minus_j), 3), j_minus_i);
      rx += (double)force.x;
      ry += (double)force.y;
      rz += (double)force.z;
    }
  }
  spheres[i + bodies].accel = newVector((float)rx, (float)ry, (float)rz);
}

// ORIGINAL
void updateAccelerations() {
  for (int i = 0; i < bodies; i++) {
    updateAccelSphere(i);
  }
}

// ORIGINAL
// runs simulation for minCollisionTime timesteps
// perform collision between spheres at indices i and j
void doMiniStepWithCollisions(float minCollisionTime, int i, int j) {
  updateAccelerations();
  updateVelocities(minCollisionTime);
  updatePositions(minCollisionTime);

  for (int k = 0; k < bodies; k++) {
    spheres[k] = copySphere(spheres[k + bodies]);
  }
  if (i == -1 || j == -1) {
    return;
  }
  // Do a collision
  vector distVec = qsubtract(spheres[i].pos, spheres[j].pos);
  float scale1 = 2 * spheres[j].mass /
                 (float)((double)spheres[i].mass + (double)spheres[j].mass);
  float scale2 = 2 * spheres[i].mass /
                 (float)((double)spheres[i].mass + (double)spheres[j].mass);
  float distNorm = qdot(distVec, distVec);
  vector velDiff = qsubtract(spheres[i].vel, spheres[j].vel);
  vector scaledDist = scale(qdot(velDiff, distVec) / distNorm, distVec);
  spheres[i].vel = qsubtract(spheres[i].vel, scale(scale1, scaledDist));
  spheres[j].vel = qsubtract(spheres[j].vel, scale(-1 * scale2, scaledDist));
}

// ORIGINAL
// check if the spheres at indices i and j collide in the next
// timeLeft timesteps
// modifies mag to contain the frame-of-reference-adjusted velocity
// of sphere j in sphere i's frame of reference
int checkForCollision(int i, int j, float timeLeft, float *mag) {
  vector distVec = qsubtract(spheres[i].pos, spheres[j].pos);
  float dist = qsize(distVec);
  float sumRadii = (float)((double)spheres[i].r + (double)spheres[j].r);

  // Shift frame of reference to act like sphere i is stationary
  vector movevec = scale(
      timeLeft,
      qsubtract(qadd(spheres[j].vel, scale(0.5 * timeLeft, spheres[j].accel)),
                qadd(spheres[i].vel, scale(0.5 * timeLeft, spheres[j].accel))));

  // Break if the length the sphere moves in timeLeft time is less than
  // distance between the centers of these spheres minus their radii
  if (qsize(movevec) < (double)dist - sumRadii ||
      (movevec.x == 0 && movevec.y == 0 && movevec.z == 0)) {
    return 0;
  }

  vector unitMovevec = scale(1 / qsize(movevec), movevec);

  // distAlongMovevec = ||distVec|| * cos(angle between unitMovevec and distVec)
  float distAlongMovevec = qdot(unitMovevec, distVec);

  // Check that sphere j is moving towards sphere i
  if (distAlongMovevec <= 0) {
    return 0;
  }

  float jToMovevecDistSq =
      (float)((double)(dist * dist) -
              (double)(distAlongMovevec * distAlongMovevec));

  // Break if the closest that sphere j will get to sphere i is more than
  // the sum of their radii
  float sumRadiiSquared = sumRadii * sumRadii;
  if (jToMovevecDistSq >= sumRadiiSquared) {
    return 0;
  }

  // We now have jToMovevecDistSq and sumRadii, two sides of a right triangle.
  // Use these to find the third side, sqrt(T)
  float extraDist = (float)((double)sumRadiiSquared - (double)jToMovevecDistSq);

  if (extraDist < 0) {
    return 0;
  }

  // Draw out the spheres to check why this is the distance sphere j moves
  // before hitting sphere i;)
  float distance = (float)((double)distAlongMovevec - (double)sqrt(extraDist));

  // Break if the distance sphere j has to move to touch sphere i is too big
  *mag = qsize(movevec);
  if (*mag < distance) {
    return 0;
  }

  return 1;
}

// ORIGINAL
void doTimeStep(float timeStep) {
  float timeLeft = timeStep;

  // If collisions are getting too frequent, we cut time step early
  // This allows for smoother rendering without losing accuracy
  while (timeLeft > TIME_LEFT_EPS) {
    float minCollisionTime = timeLeft;
    int indexCollider1 = -1;
    int indexCollider2 = -1;

    // Iterate through the spheres
    for (int i = 0; i < bodies; i++) {
      for (int j = i + 1; j < bodies; j++) {
        // If two spheres collide, set a mini-timestep so that it will be the
        // value at which the two colliding spheres just touch... NOTE that
        float refFrameAdjustedVelMag;
        if (checkForCollision(i, j, timeLeft, &refFrameAdjustedVelMag)) {
          // Set the time step so that the spheres will just touch
          vector movevec =
              qadd(spheres[j].vel, scale(0.5 * timeLeft, spheres[j].accel));
          float touchTimePct =
              timeLeft * qsize(movevec) / refFrameAdjustedVelMag;

          if (touchTimePct > 1) {
            touchTimePct = 1 / touchTimePct;
          }

          if ((touchTimePct * timeLeft) < minCollisionTime) {
            minCollisionTime = touchTimePct * timeLeft;
            indexCollider1 = i;
            indexCollider2 = j;
          }
        }
      }
    }

    doMiniStepWithCollisions(minCollisionTime, indexCollider1, indexCollider2);

    timeLeft = timeLeft - minCollisionTime;
  }
}

// ORIGINAL
void simulateOrig() { doTimeStep(1 / log(bodies)); }
