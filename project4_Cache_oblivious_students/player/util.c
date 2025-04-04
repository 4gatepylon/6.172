// Copyright (c) 2021 MIT License by 6.172 Staff

#include "util.h"

#include <stdarg.h>
#include <stdio.h>

#include "consistencytest.h"
#include "unittest.h"

#ifndef MACPORT
#include <sys/time.h>
#endif

#include <stdint.h>
#include <stdlib.h>

int RESET_RNG;

/* sample unit tests */
UNIT_TEST_FN(test_unit_tests) {
  return UNIT_TEST_SUCCESS;
  /* return UNIT_TEST_FAILURE */
}

/* UNIT_TEST_FN(test_unit_test_failure) { return UNIT_TEST_FAILURE; } */

/* sample consistency check */
CHECK_REP(myrand) {
  if (RESET_RNG == 1) {
    return CHECK_REP_FAILURE;
  }
  printf("info checkrep for myrand went through w no problems\n");
  return CHECK_REP_SUCCESS;
}

/* sample dumpds */
DUMP_DS(myrand) { printf("info RESET_RNG = %d\n", RESET_RNG); }

void debug_log(int log_level, const char* errstr, ...) {
  if (log_level >= DEBUG_LOG_THRESH) {
    va_list arg_list;
    va_start(arg_list, errstr);
    vfprintf(stderr, errstr, arg_list);
    va_end(arg_list);
    fprintf(stderr, "\n");
  }
}

double milliseconds() {
#if MACPORT
  static mach_timebase_info_data_t timebase;
  int r __attribute__((unused));
  r = mach_timebase_info(&timebase);
  fasttime_t t = gettime();
  double ns = (double)t * timebase.numer / timebase.denom;
  return ns * 1e-6;
#else
  struct timespec mtime;
  clock_gettime(CLOCK_MONOTONIC, &mtime);
  double result = 1000.0 * mtime.tv_sec;
  result += mtime.tv_nsec / 1000000.0;
  return result;
#endif
}

// Public domain code for JLKISS64 RNG - long period KISS RNG producing
// 64-bit results
uint64_t myrand() {
#ifdef DEBUG
  static int first_time = 0;
#else
  static int first_time = 1;
#endif

  // Seed variables
  static uint64_t x = 123456789123ULL, y = 987654321987ULL;
  static unsigned int z1 = 43219876, c1 = 6543217, z2 = 21987643,
                      c2 = 1732654;  // Seed variables
  static uint64_t t;

  if (first_time) {
    int i;
    FILE* f = fopen("/dev/urandom", "r");
    for (i = 0; i < 64; i += 8) {
      x = x ^ getc(f) << i;
      y = y ^ getc(f) << i;
    }

    fclose(f);
    first_time = 0;
  }

  // This resets the RNG in response to a UCI command.
  //   useful for running deterministic tests.
  if (RESET_RNG) {
    printf("Resetting RNG due to setoption command.\n");
    x = 123456789123ULL;
    y = 987654321987ULL;
    z1 = 43219876;
    c1 = 6543217;
    z2 = 21987643;
    c2 = 1732654;
    RESET_RNG = 0;
  }

  x = 1490024343005336237ULL * x + 123456789;

  y ^= y << 21;
  y ^= y >> 17;
  y ^= y << 30;  // Do not set y=0!

  t = 4294584393ULL * z1 + c1;
  c1 = t >> 32;
  z1 = t;

  t = 4246477509ULL * z2 + c2;
  c2 = t >> 32;
  z2 = t;

  SHOULD_CHECK_REP(myrand);
  return x + y + z1 + ((uint64_t)z2 << 32);  // Return 64-bit result
}
