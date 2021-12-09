
// Configurable options for passing via UCI interface.
// These options are used to tune the AI and decide whether or not
// your AI will use some of the builtin techniques we implemented.
// Refer to the Google Doc mentioned in the handout for understanding
// the terminology.

#ifndef OPTIONS_H
#define OPTIONS_H

#include "eval.h"
#define MAX_HASH 4096  // 4 GB

// Options for UCI interface
// flag whether to use opening book or not (defined in lookup.h)
int USE_OB;

// defined in search.c
extern int DRAW;
extern int LMR_R1;
extern int LMR_R2;
extern int HMB;
extern int USE_NMM;
extern int FUT_DEPTH;
extern int TRACE_MOVES;
extern int DETECT_DRAWS;
extern int NMOVES_DRAW;

// defined in eval.c
extern int RANDOMIZE;
extern int PTOUCH_weight;
extern int PPROX_weight;
extern int MFACE_weight;
extern int MCEDE_weight;
extern int LCOVERAGE_weight;
extern int MMID_weight;
extern int PMID_weight;
extern int NMAT_weight;

// defined in tt.c
extern int USE_TT;
extern int HASH;

// flag that can be set via uci setoption command that will reset the rng to
// default
//   seeds. This is useful for running benchmarks for changes that only impact
//   performance.
extern int RESET_RNG;

#ifndef PEDANTIC
// consistency checking flag
// if enabled, and binary is compiled without -DPEDANTIC,
// runs check rep on all data structures as specified by users
extern int CHECK_REP;

#endif /* ! PEDANTIC */

// struct for manipulating options below
typedef struct {
  char name[MAX_CHARS_IN_TOKEN];  // name of options
  int* var;    // pointer to an int variable holding its value
  int dfault;  // default value
  int min;     // lower bound on what we want it to be
  int max;     // upper bound
} int_options;

static int_options iopts[] = {
    // name          variable       default             lower bound  upper bound
    // --------------------------------------------------------------------------
    {"mface", &MFACE_weight, (int)(1.59192 * 0.5 * P_EV_VAL), 0, P_EV_VAL},
    {"lcoverage", &LCOVERAGE_weight, (int)(1.39352 * 0.16 * P_EV_VAL), 0, P_EV_VAL},
    {"ptouch", &PTOUCH_weight, (int)(0 * 0.04 * P_EV_VAL), 0, P_EV_VAL},
    {"mcede", &MCEDE_weight, (int)(1.13986 * 1.0 * P_EV_VAL), 0, (int)(5.0 * P_EV_VAL)},
    {"pprox", &PPROX_weight, (int)(0 * 0.02 * P_EV_VAL), 0, (int)(5.0 * P_EV_VAL)},
    {"mmid", &MMID_weight, (int)(2.30575 * 0.02 * P_EV_VAL), 0, (int)(0.3 * P_EV_VAL)},
    // This weight upper bound had to be doubled
    {"pmid", &PMID_weight, (int)(11.7292 * 0.01 * P_EV_VAL), 0, (int)(0.2 * P_EV_VAL)},
    {"bmat", &NMAT_weight, (int)(15.8071 * 0.03 * P_EV_VAL), 0, (int)(1.0 * P_EV_VAL)},
    {"hash", &HASH, 16, 1, MAX_HASH},
    {"draw", &DRAW, (int)(-0.07 * PAWN_VALUE), -PAWN_VALUE, PAWN_VALUE},
    {"randomize", &RANDOMIZE, 0, 0, P_EV_VAL},
    {"lmr_r1", &LMR_R1, 5, 1, MAX_NUM_MOVES},
    {"lmr_r2", &LMR_R2, 20, 1, MAX_NUM_MOVES},
    {"hmb", &HMB, (int)(0.03 * PAWN_VALUE), 0, PAWN_VALUE},
    {"fut_depth", &FUT_DEPTH, 3, 0, 5},
    // debug options
    {"use_nmm", &USE_NMM, 1, 0, 1},
    {"detect_draws", &DETECT_DRAWS, 1, 0, 1},
    {"use_ob", &USE_OB, 1, 0, 1},
    {"trace_moves", &TRACE_MOVES, 0, 0, 1},
    {"nmoves_draw", &NMOVES_DRAW, 100, 1, 1000 * 1000},
// determinism-related debug options
#ifdef DETERMINISM
    {"use_tt", &USE_TT, 0, 0, 1},
    {"reset_rng", &RESET_RNG, 1, 0, 1},
#else  /* ! DETERMINISM */
    {"use_tt", &USE_TT, 1, 0, 1},
    {"reset_rng", &RESET_RNG, 0, 0, 1},
#endif /* ! DETERMINISM */

// consistency checking related debug options
#ifndef PEDANTIC
    {"check_rep", &CHECK_REP, 0, 0, 1},
#endif /* ! PEDANTIC */

    {"", NULL, 0, 0, 0}};

#endif
