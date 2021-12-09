/**
 * Author: Isabel Rosa, isrosa@mit.edu
 **/

#include "render.h"

#include <assert.h>
#include <cilk/cilk.h>
#include <immintrin.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "main.h"
#include "simulate.h"

ray sphereToEye(sphere *s, vector origin) {
  ray sphereToEye;

  vector spherePos = s->pos;
  sphereToEye.origin = spherePos;
  sphereToEye.dir = qsubtract(spherePos, origin);
  sphereToEye.dir =
      scale(1 / qsize(sphereToEye.dir), sphereToEye.dir);  // unit vector
  return sphereToEye;
}

/** Takes a pixel with coordinates (x_coord, y_coord) whose plane is defined by
 * unit vectors u and v. It then returns a ray centered at the origin passed
 *into the function that passes through those particular coordinates provided
 **/
ray eyeToPixel(int height, int width, float x_coord, float y_coord,
               vector origin, vector u, vector v) {
  ray viewingRay;

  // center image frame
  float us = -width / 2 + x_coord;
  float vs = -height / 2 + y_coord;

  viewingRay.origin = origin;
  viewingRay.dir =
      qsubtract(qadd(scale(us, u), scale(vs, v)), viewingRay.origin);
  viewingRay.dir = scale(1 / qsize(viewingRay.dir), viewingRay.dir);

  return viewingRay;
}

// returns 1 if ray and sphere intersect, else 0
int rayToSphereIntersection(ray *r, sphere *s, float *t) {
  vector dist = qsubtract(r->origin, s->pos);
  float a = qdot(r->dir, r->dir);
  float b = 2 * qdot(r->dir, dist);
  float c = (float)((double)qdot(dist, dist) - (double)(s->r * s->r));
  float discr = (float)((double)(b * b) - (double)(4 * a * c));

  if (discr >= 0) {
    // ray hits sphere
    float sqrtdiscr = sqrtf(discr);
    float sol1 = (float)((double)-b + (double)sqrtdiscr) / 2;
    float sol2 = (float)((double)-b - (double)sqrtdiscr) / 2;
    float new_t = min(sol1, sol2);

    // if new_t > 0 and smaller than original t, we
    // found a new, closer ray-sphere intersection
    if (new_t > 0 && new_t < *t) {
      *t = new_t;
      return 1;
    }
  }

  return 0;
}

void renderOrig(float *img, int height, int width, vector e, vector u, vector v,
                int numLights, light *lights) {
  ray r;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      double red = 0;
      double green = 0;
      double blue = 0;

      r = eyeToPixel(height, width, x, y, e, u, v);

      // find closest ray-sphere intersection
      float t = 20000.0Q;  // approx. infinity
      int currentSphere = -1;

      for (int i = 0; i < numSpheres; i++) {
        if (rayToSphereIntersection(&r, &spheres[i], &t)) {
          currentSphere = i;
          break;
        }
      }

      if (currentSphere == -1) goto setpixel;

      material currentMat = spheres[currentSphere].mat;

      vector newOrigin = qadd(r.origin, scale(t, r.dir));

      // normal for new vector at intersection point
      vector n = qsubtract(newOrigin, spheres[currentSphere].pos);
      float n_size = qsize(n);
      if (n_size == 0) goto setpixel;
      n = scale(1 / n_size, n);

      for (int j = 0; j < numLights; j++) {
        light currentLight = lights[j];
        vector dist = qsubtract(currentLight.pos, newOrigin);
        if (qdot(n, dist) <= 0) continue;

        ray lightRay;
        lightRay.origin = newOrigin;
        lightRay.dir = scale(1 / qsize(dist), dist);

        // calculate Lambert diffusion
        float lambert = qdot(lightRay.dir, n);
        red += (double)(currentLight.intensity.red * currentMat.diffuse.red *
                        lambert);
        green += (double)(currentLight.intensity.green *
                          currentMat.diffuse.green * lambert);
        blue += (double)(currentLight.intensity.blue * currentMat.diffuse.blue *
                         lambert);
      }
    setpixel:
      img[(x + y * width) * 3 + 0] = min((float)red, 1.0);
      img[(x + y * width) * 3 + 1] = min((float)green, 1.0);
      img[(x + y * width) * 3 + 2] = min((float)blue, 1.0);
    }
  }
}

/**
 * With the assumption that u & v = -y & z, we can simplify the problem
 * to simply ask where the vector from the sphere intersects with the plane x=0
 * To do this, we parameterize the line from the sphere to the eye,
 * set the x equation to 0 and solve for the time
 *
 * The parameterized line is:
 * x = s_x + (e_x - s_x) * t
 * y = s_y + (e_y - s_y) * t
 * z = s_z + (e_z - s_z) * t
 * where s is the sphere and e is the eye
 **/
inline float findIntersectionTimestep(vector s, vector e) {
  return s.x / (s.x - e.x);
}

inline pixel findIntersectingPixel(int height, int width, vector s, vector e) {
  float timestep = findIntersectionTimestep(s, e);
  float y = s.y + (e.y - s.y) * timestep;
  float z = s.z + (e.z - s.z) * timestep;

  pixel location;
  location.x = (int)-y;
  location.y = (int)z;
  return location;
}

inline void setPixel(float *img, int width, int x, int y, float red,
                     float green, float blue) {
  img[(x + y * width) * 3 + 0] = min((float)red, 1.0);
  img[(x + y * width) * 3 + 1] = min((float)green, 1.0);
  img[(x + y * width) * 3 + 2] = min((float)blue, 1.0);
}

/**
 * Instead of finding an exact projection of the sphere onto the plane,
 * we project a cube of side length 2 * radius onto the image plane
 * To do find the binding box, we simply iterate through all 8
 * corners of the cube.
 **/
void initializeBoundingBox(sphere *s, vector *boundingBox) {
  boundingBox[0] = newVector(s->pos.x + s->r, s->pos.y + s->r, s->pos.z + s->r);
  boundingBox[1] = newVector(s->pos.x + s->r, s->pos.y + s->r, s->pos.z - s->r);
  boundingBox[2] = newVector(s->pos.x + s->r, s->pos.y - s->r, s->pos.z + s->r);
  boundingBox[3] = newVector(s->pos.x + s->r, s->pos.y - s->r, s->pos.z - s->r);
  boundingBox[4] = newVector(s->pos.x - s->r, s->pos.y + s->r, s->pos.z + s->r);
  boundingBox[5] = newVector(s->pos.x - s->r, s->pos.y + s->r, s->pos.z - s->r);
  boundingBox[6] = newVector(s->pos.x - s->r, s->pos.y - s->r, s->pos.z + s->r);
  boundingBox[7] = newVector(s->pos.x - s->r, s->pos.y - s->r, s->pos.z - s->r);
}

#define CLOSE_ENOUGH_TO_ZERO 0.00001

void renderRaytrace(float *img, int height, int width, vector e, vector u,
                    vector v, int numLights, light *lights, bool *colored) {
  assert(width % 2 == 0);
  assert(height % 2 == 0);
  // u => -y unit vector (0, -1, 0)
  assert(u.x <= CLOSE_ENOUGH_TO_ZERO);
  assert(u.y + 1 <= CLOSE_ENOUGH_TO_ZERO);
  assert(u.z <= CLOSE_ENOUGH_TO_ZERO);
  // v => z unit vector (0, 0, 1)
  assert(v.x <= CLOSE_ENOUGH_TO_ZERO);
  assert(v.y <= CLOSE_ENOUGH_TO_ZERO);
  assert(v.z - 1 <= CLOSE_ENOUGH_TO_ZERO);
  // assuming spheres are sorted

  const int numCorners = 8;

  const int halfHeight = height / 2;
  const int halfWidth = width / 2;
  int max_x;
  int min_x;
  int max_y;
  int min_y;

  // bool *colored = (bool *)calloc(width * height, sizeof(bool));
  // bool *colored = (bool *) malloc(width * height * sizeof(bool));
  cilk_for(int x = 0; x < width * height; x++) { colored[x] = false; }
  cilk_for(int i = 0; i < width * height * 3; i++) { img[i] = 0; }
  for (int i = 0; i < numSpheres; i++) {
    sphere *s = &(spheres[i]);

    vector boundingBox[numCorners];
    initializeBoundingBox(s, boundingBox);

    pixel pixelMaps[numCorners];
    for (uint_fast8_t i = 0; i < numCorners; i++) {
      pixelMaps[i] = findIntersectingPixel(height, width, boundingBox[i], e);
    }
    max_x = pixelMaps[0].x;
    min_x = pixelMaps[0].x;
    max_y = pixelMaps[0].y;
    min_y = pixelMaps[0].y;
    for (uint_fast8_t i = 1; i < 8; i++) {
      max_x = max(pixelMaps[i].x, max_x);
      min_x = min(pixelMaps[i].x, min_x);
      max_y = max(pixelMaps[i].y, max_y);
      min_y = min(pixelMaps[i].y, min_y);
    }
    assert(min_x <= max_x);
    assert(min_y <= max_y);

    // Precompute the colors for the current sphere
    // as the material times the light source does not
    // change from pixel to pixel
    // only the lambert diffusion changes
    material currentMat = spheres[i].mat;
    float colorXLight[3 * numLights];
    for (uint_fast8_t j = 0; j < numLights; j++) {
      light currentLight = lights[j];
      colorXLight[3 * j] =
          (currentLight.intensity.red * currentMat.diffuse.red);
      colorXLight[3 * j + 1] =
          (currentLight.intensity.green * currentMat.diffuse.green);
      colorXLight[3 * j + 2] =
          (currentLight.intensity.blue * currentMat.diffuse.blue);
    }

    cilk_for(int x = max(0, min_x + halfWidth);
             x < min(width, max_x + halfWidth + 1); x++) {
      cilk_for(int y = max(0, min_y + halfHeight);
               y < min(height, max_y + halfHeight + 1); y++) {
        if (colored[x + y * width]) continue;
        float t = 20000.0Q;  // approx. infinity
        ray r = eyeToPixel(height, width, x, y, e, u, v);
        // Check if this ray intersects with the sphere
        if (!rayToSphereIntersection(&r, s, &t)) continue;

        colored[x + y * width] = true;
        double red = 0;
        double green = 0;
        double blue = 0;

        // r.origin = eye, adding a vector that r.dir * t that
        // should make the newOrigin the location of the intersection
        // closest to the plane
        vector newOrigin = qadd(r.origin, scale(t, r.dir));

        // normal for new vector at intersection point
        vector n = qsubtract(newOrigin, s->pos);
        float n_size = qsize(n);

        if (n_size == 0) {
          setPixel(img, width, x, y, red, green, blue);
        }
        n = scale(1 / n_size, n);

        for (int j = 0; j < numLights; j++) {
          light currentLight = lights[j];
          vector dist = qsubtract(currentLight.pos, newOrigin);

          if (qdot(n, dist) <= 0) continue;

          ray lightRay;
          lightRay.origin = newOrigin;
          lightRay.dir = scale(1 / qsize(dist), dist);

          // calculate Lambert diffusion
          float lambert = qdot(lightRay.dir, n);
          red += (double)(colorXLight[3 * j] * lambert);
          green += (double)(colorXLight[3 * j + 1] * lambert);
          blue += (double)(colorXLight[3 * j + 2] * lambert);
        }  // END LIGHTS LOOP
        setPixel(img, width, x, y, red, green, blue);
      }  // END Y SWEEP
    }    // END X SWEEP
  }      // END SPHERES LOOP
  // free(colored);
}  // END FUNC

// This allows us to make sure that we only define the boolean
// mask `colored` at most twice and avoid memory leaks.
#ifndef NULL_PTR
#define NULL_PTR 0
#endif
#define NUM_TIER_FRAMES 3
static bool *colored = NULL;
static int frame = 0;
void render(float *img, int height, int width, vector e, vector u, vector v,
            int numLights, light *lights) {
  // So we only initialize once
  frame++;
  if (colored == NULL_PTR) {
    colored = (bool *)malloc(width * height * sizeof(bool));
  }

  // Do our inlined raytrace
  renderRaytrace(img, height, width, e, u, v, numLights, lights, colored);

  // So we only initialize once
  if (frame == numFrames || currFrames == numFrames ||
      frame == NUM_TIER_FRAMES) {
    frame = 0;
    free(colored);
    colored = NULL_PTR;
  }
}