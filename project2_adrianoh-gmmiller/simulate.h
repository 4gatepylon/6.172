/**
 * Author: Isabel Rosa, isrosa@mit.edu
 **/

#include <math.h>
#include <stdio.h>

#ifndef SIMULATION_H
#define SIMULATION_H

typedef struct {
  float x, y, z;
} vector;

typedef struct {
  double x, y, z;
} dvector;

typedef struct {
  int x, y;
} pixel;

typedef struct {
  float red, green, blue;
} color;

typedef struct {
  color diffuse;
  float reflection;
} material;

// Bounding box of a vector is approximately [center + r + eps, center - r -
// eps] in the meaningful direction (i.e. for a plane, we pick parallel
// directions for the box).
typedef struct {
  vector pos;
  vector vel;
  vector accel;
  float r;
  float mass;
  material mat;
  float eye_face_dist;
  float speed;
} sphere;

typedef struct {
  vector origin;
  vector dir;
} ray;

typedef struct {
  vector pos;
  color intensity;
} light;

static inline vector newVector(float x, float y, float z) {
  vector v;
  v.x = x;
  v.y = y;
  v.z = z;
  return v;
}

static inline dvector newDVector(double x, double y, double z) {
  dvector v;
  v.x = x;
  v.y = y;
  v.z = z;
  return v;
}

static inline vector copyVector(vector v1) {
  vector v2;
  v2.x = v1.x;
  v2.y = v1.y;
  v2.z = v1.z;
  return v2;
}

static inline ray newRay(vector origin, vector dir) {
  ray r;
  r.origin = origin;
  r.dir = dir;
  return r;
}

static inline color newColor(float r, float g, float b) {
  color c;
  c.red = r;
  c.green = g;
  c.blue = b;
  return c;
}

static inline color copyColor(color c1) {
  color c2;
  c2.red = c1.red;
  c2.green = c1.green;
  c2.blue = c1.blue;
  return c2;
}

static inline material newMaterial(color diffuse, float reflection) {
  material m;
  m.diffuse = diffuse;
  m.reflection = reflection;
  return m;
}

static inline material copyMat(material m1) {
  material m2;
  m2.diffuse = copyColor(m1.diffuse);
  m2.reflection = m1.reflection;
  return m2;
}

static inline sphere copySphere(sphere s1) {
  sphere s2;
  s2.pos = copyVector(s1.pos);
  s2.vel = copyVector(s1.vel);
  s2.accel = copyVector(s1.accel);
  s2.r = s1.r;
  s2.mass = s1.mass;
  s2.mat = copyMat(s1.mat);
  s2.eye_face_dist = s1.eye_face_dist;
  return s2;
}

static inline light newLight(vector pos, color intensity) {
  light l;
  l.pos = pos;
  l.intensity = intensity;
  return l;
}

static inline vector qsubtract(vector v1, vector v2) {
  vector v;
  v.x = (float)((double)v1.x - (double)v2.x);
  v.y = (float)((double)v1.y - (double)v2.y);
  v.z = (float)((double)v1.z - (double)v2.z);
  return v;
}

static inline float qdot(vector v1, vector v2) {
  float x = v1.x * v2.x;
  float y = v1.y * v2.y;
  float z = v1.z * v2.z;
  return (float)((double)x + (double)y + (double)z);
}

static inline vector qcross(vector v1, vector v2) {
  vector v;
  v.x = (float)((double)(v1.y * v2.z) - (double)(v1.z * v2.y));
  v.y = (float)((double)(v1.z * v2.x) - (double)(v1.x * v2.z));
  v.z = (float)((double)(v1.x * v2.y) - (double)(v1.y * v2.x));
  return v;
}

// Squared distance is easier to copmute than the actual
// distance due to square roots, so we often try to use the
// squared distance instead if possible.
static inline float qsize2(vector v) {
  return (v.x * v.x) + (v.y * v.y) + (v.z * v.z);
}

static inline float qsize(vector v) {
  float x = v.x * v.x;
  float y = v.y * v.y;
  float z = v.z * v.z;
  return sqrt((float)((double)x + (double)y + (double)z));
}

static inline vector scale(float c, vector v1) {
  vector v;
  v.x = v1.x * c;
  v.y = v1.y * c;
  v.z = v1.z * c;
  return v;
}

static inline vector qadd(vector v1, vector v2) {
  vector v;
  v.x = (float)((double)v1.x + (double)v2.x);
  v.y = (float)((double)v1.y + (double)v2.y);
  v.z = (float)((double)v1.z + (double)v2.z);
  return v;
}

static inline float qdist(vector v1, vector v2) {
  double f = ((double)v1.x - (double)v2.x) * ((double)v1.x - (double)v2.x);
  f += ((double)v1.y - (double)v2.y) * ((double)v1.y - (double)v2.y);
  f += ((double)v1.z - (double)v2.z) * ((double)v1.z - (double)v2.z);
  return sqrt((float)f);
}

static inline dvector vectorToDVector(vector v) {
  dvector dv;
  dv.x = (double)v.x;
  dv.y = (double)v.y;
  dv.z = (double)v.z;
  return dv;
}

static inline vector dvectorToVector(dvector v1) {
  vector v;
  v.x = (float)v1.x;
  v.y = (float)v1.y;
  v.z = (float)v1.z;
  return v;
}

static inline dvector dqsubtract(dvector v1, dvector v2) {
  dvector v;
  v.x = v1.x - v2.x;
  v.y = v1.y - v2.y;
  v.z = v1.z - v2.z;
  return v;
}

static inline dvector dqadd(dvector v1, dvector v2) {
  dvector v;
  v.x = v1.x + v2.x;
  v.y = v1.y + v2.y;
  v.z = v1.z + v2.z;
  return v;
}

static inline double dqdot(dvector v1, dvector v2) {
  double x = v1.x * v2.x;
  double y = v1.y * v2.y;
  double z = v1.z * v2.z;
  return x + y + z;
}

static inline dvector dscale(double scalar, dvector v) {
  dvector out;
  out.x = v.x * scalar;
  out.y = v.y * scalar;
  out.z = v.z * scalar;
  return out;
}

static inline double dqsize(dvector v) {
  double x = v.x * v.x;
  double y = v.y * v.y;
  double z = v.z * v.z;
  return sqrt(x + y + z);
}

static inline int equals(vector v1, vector v2) {
  if (v1.x != v2.x) return 0;
  if (v1.y != v2.y) return 0;
  if (v1.z != v2.z) return 0;
  return 1;
}

static inline void printVector(vector v, char *name) {
  printf("%s vector (x,y,z): (%f, %f, %f)\n", name, v.x, v.y, v.z);
}

static inline void printPixel(pixel p, char *name) {
  printf("%s pixel (x,y): (%i, %i)\n", name, p.x, p.y);
}

static inline void printRay(ray r, char *name) {
  printf("Ray %s\n", name);
  printVector(r.origin, "\torigin:");
  printVector(r.dir, "\tdirection:");
}

// bodies info, defined in simulate.c
extern double G;
extern int bodies, numSpheres;
extern sphere *spheres;

void updateAccelSphere(int i);

void updateAccelerations();

void updateVelocities(float t);

void updatePositions(float t);

void doMiniStepWithCollisions(float minCollisionTime, int i, int j);

int checkForCollision(int i, int j, float timeLeft, float *mag);

void sort(sphere *spheres, int n, vector e);

void doTimeStep(float timeStep);

void newDoTimeStep(float timeStep);

void simulateOrig();

void simulate();

#endif
