// Copyright (c) 2021 MIT License by 6.172 Staff

#include "eval.h"

#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "move_gen.h"
#include "tbassert.h"

// -----------------------------------------------------------------------------
// Evaluation
// -----------------------------------------------------------------------------

typedef int32_t ev_score_t;  // Static evaluator uses "hi res" values

int RANDOMIZE;

int PTOUCH_weight;
int PPROX_weight;
int MFACE_weight;
int MCEDE_weight;
int LCOVERAGE_weight;
int PMID_weight;
int MMID_weight;
int NMAT_weight;
int PMAT_weight = PAWN_EV_VALUE;

enum heuristics_t {
  PTOUCH,
  PPROX,
  MFACE,
  MCEDE,
  LCOVERAGE,
  PMID,
  MMID,
  NMAT,
  PMAT,
  NUM_HEURISTICS
};
char* heuristic_strs[NUM_HEURISTICS] = {"PTOUCH", "PPROX",     "MFACE",
                                        "MCEDE",  "LCOVERAGE", "PMID",
                                        "MMID",   "NMAT",      "PMAT"};
// Boolean array for heuristics that scale along floating point values
// (versus those that are directly proportional to pawn values)
bool floating_point_heuristics[NUM_HEURISTICS] = {0, 1, 1, 1, 1, 0, 0, 0, 0};

// inverses of small integers (precomputed for speed)
float inverses[65] = {
    1 / 1.0,  1 / 2.0,  1 / 3.0,  1 / 4.0,  1 / 5.0,  1 / 6.0,  1 / 7.0,
    1 / 8.0,  1 / 9.0,  1 / 10.0, 1 / 11.0, 1 / 12.0, 1 / 13.0, 1 / 14.0,
    1 / 15.0, 1 / 16.0, 1 / 17.0, 1 / 18.0, 1 / 19.0, 1 / 20.0, 1 / 21.0,
    1 / 22.0, 1 / 23.0, 1 / 24.0, 1 / 25.0, 1 / 26.0, 1 / 27.0, 1 / 28.0,
    1 / 29.0, 1 / 30.0, 1 / 31.0, 1 / 32.0, 1 / 33.0, 1 / 34.0, 1 / 35.0,
    1 / 36.0, 1 / 37.0, 1 / 38.0, 1 / 39.0, 1 / 40.0, 1 / 41.0, 1 / 42.0,
    1 / 43.0, 1 / 44.0, 1 / 45.0, 1 / 46.0, 1 / 47.0, 1 / 48.0, 1 / 49.0,
    1 / 50.0, 1 / 51.0, 1 / 52.0, 1 / 53.0, 1 / 54.0, 1 / 55.0, 1 / 56.0,
    1 / 57.0, 1 / 58.0, 1 / 59.0, 1 / 60.0, 1 / 61.0, 1 / 62.0, 1 / 63.0,
    1 / 64.0, 1 / 65.0};

// edge contribution to laser coverage (rewards enemy monarch near edge)
float edge_contributions[BOARD_WIDTH][BOARD_WIDTH] = {
    {3.6952822208, 3.4158563614, 3.3142907619, 3.2780292034, 3.2780294418,
     3.3142905235, 3.4158565998, 3.6952819824},
    {3.4158565998, 3.0451886654, 2.8999719620, 2.8451590538, 2.8451590538,
     2.8999719620, 3.0451889038, 3.4158565998},
    {3.3142902851, 2.8999717236, 2.7340986729, 2.6705558300, 2.6705555916,
     2.7340981960, 2.8999717236, 3.3142902851},
    {3.2780287266, 2.8451583385, 2.6705555916, 2.6033337116, 2.6033337116,
     2.6705553532, 2.8451585770, 3.2780287266},
    {3.2780289650, 2.8451583385, 2.6705553532, 2.6033329964, 2.6033332348,
     2.6705551147, 2.8451583385, 3.2780287266},
    {3.3142905235, 2.8999717236, 2.7340989113, 2.6705555916, 2.6705555916,
     2.7340986729, 2.8999717236, 3.3142905235},
    {3.4158568382, 3.0451886654, 2.8999717236, 2.8451588154, 2.8451590538,
     2.8999719620, 3.0451886654, 3.4158565998},
    {3.6952822208, 3.4158565998, 3.3142905235, 3.2780292034, 3.2780294418,
     3.3142907619, 3.4158565998, 3.6952819824}};

int centralities[8] = {0, 1, 2, 3, 3, 2, 1, 0};

// Heuristics for static evaluation - described in the leiserchess codewalk
// slides

// For PTOUCH heuristic: Does a Pawn touch a neighboring Pawn?
bool p_touch(position_t* p, fil_t f, rnk_t r) {
  square_t sq = square_of(f, r);

  for (int d = 0; d < NUM_DIR; d++) {  // search surrounding square
    square_t curr_sq = sq + dir_of((compass_t)d);
    piece_t curr_piece = p->board[curr_sq];
    if (curr_piece.typ == PAWN && curr_piece.color != NEUTRAL) {
      return true;
    }
  }
  return false;
}

// test routine for do_pawns_touch()
void test_ptouch(position_t* p) {
  char sq_str[MAX_CHARS_IN_MOVE];

  for (fil_t f = 0; f < BOARD_WIDTH; f++) {
    for (rnk_t r = 0; r < BOARD_WIDTH; r++) {
      square_t sq = square_of(f, r);
      piece_t piece = p->board[sq];
      ptype_t piece_type = piece.typ;

      if (piece_type == PAWN) {  // find a Pawn
        square_to_str(sq, sq_str, MAX_CHARS_IN_MOVE);
        printf("info Pawn on %s\n", sq_str);

        for (int d = 0; d < NUM_DIR; d++) {  // search surrounding squares
          square_t curr_sq = sq + dir_of((compass_t)d);
          piece_t curr_piece = p->board[curr_sq];
          if (curr_piece.typ == PAWN) {
            if (do_pawns_touch(piece.pawn_ori, curr_piece.pawn_ori,
                               (compass_t)d)) {
              square_to_str(curr_sq, sq_str, MAX_CHARS_IN_MOVE);
              printf("info ..touches Pawn on %s\n", sq_str);
            }
          }
        }
      }
    }
  }
}

// MFACE heuristic: bonus (or penalty) for Monarch facing toward the other
// Monarch
ev_score_t mface(position_t* p, fil_t f, rnk_t r) {
  square_t sq = square_of(f, r);
  piece_t piece = p->board[sq];
  color_t c = piece.color;
  square_t opp_sq = p->mloc[opp_color(c)];
  int delta_fil = fil_of(opp_sq) - f;
  int delta_rnk = rnk_of(opp_sq) - r;
  int bonus = 0;

  switch (piece.monarch_ori) {
    case NN:
      bonus = delta_rnk;
      break;

    case EE:
      bonus = delta_fil;
      break;

    case SS:
      bonus = -delta_rnk;
      break;

    case WW:
      bonus = -delta_fil;
      break;

    default:
      tbassert(false, "Illegal Monarch orientation.\n");
  }

  return (bonus * PAWN_EV_VALUE) / (abs(delta_rnk) + abs(delta_fil));
}

// MCEDE heuristic: penalty for ceding opp Monarch room to move.
ev_score_t mcede(position_t* p, fil_t f, rnk_t r) {
  piece_t piece = p->board[square_of(f, r)];
  color_t c = piece.color;

  tbassert(piece.typ == MONARCH, "piece.typ = %d\n", piece.typ);

  square_t opp_sq = p->mloc[opp_color(c)];

  int delta_fil = fil_of(opp_sq) - f;
  int delta_rnk = rnk_of(opp_sq) - r;

  int penalty = 0;

  if (delta_fil * EAST >= 0 && delta_rnk * NORTH >= 0) {  // NE quadrant
    penalty = (BOARD_WIDTH - f) * (BOARD_WIDTH - r);
  } else if (delta_fil * EAST >= 0 && delta_rnk * SOUTH >= 0) {  // SE quadrant
    penalty = (BOARD_WIDTH - f) * (r + 1);
  } else if (delta_fil * WEST >= 0 && delta_rnk * SOUTH >= 0) {  // SW quadrant
    penalty = (f + 1) * (r + 1);
  } else if (delta_fil * WEST >= 0 && delta_rnk * NORTH >= 0) {  // NW quadrant
    penalty = (f + 1) * (BOARD_WIDTH - r);
  } else {
    tbassert(false, "You need some direction in life!\n");  // Shouldn't happen.
  }

  return (PAWN_EV_VALUE * penalty) / (BOARD_WIDTH * BOARD_WIDTH);
}

float mult_dist(square_t a, square_t b) {
  int delta_fil = abs(fil_of(a) - fil_of(b));
  int delta_rnk = abs(rnk_of(a) - rnk_of(b));
  if (delta_fil == 0 && delta_rnk == 0) {
    return 2;
  }
  float x = inverses[delta_fil] * inverses[delta_rnk];
  return x;
}

// Manhattan distance
int manhattan_dist(square_t a, square_t b) {
  int delta_fil = abs(fil_of(a) - fil_of(b));
  int delta_rnk = abs(rnk_of(a) - rnk_of(b));
  return delta_fil + delta_rnk;
}

// Harmonic-ish distance: 1/(|dx|+1) + 1/(|dy|+1)
float h_dist(square_t a, square_t b) {
  //  printf("a = %d, FIL(a) = %d, RNK(a) = %d\n", a, FIL(a), RNK(a));
  //  printf("b = %d, FIL(b) = %d, RNK(b) = %d\n", b, FIL(b), RNK(b));
  int delta_fil = abs(fil_of(a) - fil_of(b));
  int delta_rnk = abs(rnk_of(a) - rnk_of(b));
  float x = inverses[delta_fil] + inverses[delta_rnk];
  //  printf("max_dist = %d\n\n", x);
  return x;
}

ev_score_t get_centrality(fil_t f, rnk_t r) {
  return centralities[f] + centralities[r];
}

// Marks the path/line-of-sight of the laser until it hits a piece or goes off
// the board.
// Increment for each time you touch a square with the laser
//
// p : Current board state.
// c : Color of monarch shooting laser.
// laser_map : End result will be stored here. Every square on the
//             path of the laser is marked with mark_mask.
// mark_mask : What each square is marked with.
// return result
float add_laser_path(position_t* p, color_t c, ev_score_t score[2][9]) {
  bool laser_map[ARR_SIZE] = {0};
  square_t sq = p->mloc[c];
  square_t monarch_sq = sq;
  square_t opp_monarch_sq = p->mloc[opp_color(c)];
  float result =
      edge_contributions[rnk_of(opp_monarch_sq)][fil_of(opp_monarch_sq)];
  int bdir = (int)p->board[sq].pawn_ori;
  int length = 0;

  tbassert(p->board[sq].typ == MONARCH, "ptype: %d\n", p->board[sq].typ);

  while (true) {
    sq += beam_of(bdir);

    if (p->board[sq].typ == INVALID) return result;

    // set laser map to min
    if (!laser_map[sq]) {
      laser_map[sq] = 1;
      float temp = (manhattan_dist(monarch_sq, sq)) * inverses[length];
      temp *= mult_dist(sq, opp_monarch_sq);
      result += temp;
    }
    length++;

    tbassert((int)sq < ARR_SIZE && sq >= 0, "sq: %d\n", sq);

    switch (p->board[sq].typ) {
      case EMPTY:  // empty square
        break;
      case PAWN:  // Pawn
        bdir = reflect_of(bdir, p->board[sq].pawn_ori);
        if (bdir < 0) {  // Hit back of Pawn
          return result;
        }
        if (p->board[sq].color == NEUTRAL) {
          ev_score_t centrality = get_centrality(fil_of(sq), rnk_of(sq));
          score[c][NMAT] += 1;
          score[c][PMID] += centrality;
        }
        break;
      case MONARCH:     // Monarch
        return result;  // sorry, game over my friend!
        break;
      default:  // Shouldna happen, man!
        tbassert(false, "Not cool, man.  Not cool.\n");
        break;
    }
  }
}

// Static evaluation.  Returns score
score_t eval(position_t* p, bool verbose) {
  // seed rand_r with a value of 1, as per
  // https://linux.die.net/man/3/rand_r
  static __thread unsigned int seed = 1;
  // verbose = true: print out components of score
  ev_score_t score[2][NUM_HEURISTICS] = {0};
  //  int corner[2][2] = { {INF, INF}, {INF, INF} };
  char sq_str[MAX_CHARS_IN_MOVE];

  float white_lasercov = add_laser_path(p, WHITE, score);

  float black_lasercov = add_laser_path(p, BLACK, score);

  for (int c = 0; c < 2; c++) {
    // MFACE heuristic
    rnk_t r = rnk_of(p->mloc[c]);
    fil_t f = fil_of(p->mloc[c]);
    ev_score_t centrality = get_centrality(f, r);

    ev_score_t kface_bonus = mface(p, f, r);
    score[c][MFACE] += kface_bonus;
    if (verbose) {
      printf("MFACE bonus %d for %s Monarch on %s\n", kface_bonus,
             color_to_str(c), sq_str);
    }

    // MCEDE heuristic
    ev_score_t penalty = mcede(p, f, r);
    score[c][MCEDE] -= penalty;
    if (verbose) {
      printf("MCEDE penalty %d for %s Monarch on %s\n", penalty,
             color_to_str(c), sq_str);
    }

    // MMID heuristic
    score[c][MMID] += centrality;
    if (verbose) {
      printf("MMID bonus %d for %s Monarch on %s\n", centrality,
             color_to_str(c), sq_str);
    }

#pragma unroll 4
    for (int pawn_loc = 0; pawn_loc < MAX_NUM_PAWNS; pawn_loc++) {
      if (p->pawn_locs[c][pawn_loc] != 0) {
        score[c][PMAT]++;
        score[c][PMID] += get_centrality(fil_of(p->pawn_locs[c][pawn_loc]),
                                         rnk_of(p->pawn_locs[c][pawn_loc]));
      }
    }
  }

  // LASER_COVERAGE heuristic
  float w_coverage = PAWN_EV_VALUE * white_lasercov;
  score[WHITE][LCOVERAGE] += w_coverage;
  if (verbose) {
    printf("LCOVERAGE bonus %d for White\n", (int)w_coverage);
  }
  float b_coverage = PAWN_EV_VALUE * black_lasercov;
  score[BLACK][LCOVERAGE] += (int)b_coverage;
  if (verbose) {
    printf("LCOVERAGE bonus %d for Black\n", (int)b_coverage);
  }

  int weights[NUM_HEURISTICS] = {PTOUCH_weight, PPROX_weight,     MFACE_weight,
                                 MCEDE_weight,  LCOVERAGE_weight, PMID_weight,
                                 MMID_weight,   NMAT_weight,      PMAT_weight};
  ev_score_t total_score[2] = {0, 0};

  // #pragma unroll 2
  for (color_t c = 0; c <= 1; c++) {
#pragma unroll NUM_HEURISTICS
    for (int i = 0; i < NUM_HEURISTICS; i++) {
      ev_score_t bonus;
      if (floating_point_heuristics[i]) {
        bonus = score[c][i] * (weights[i] / (float)PAWN_EV_VALUE);
      } else {
        bonus = score[c][i] * weights[i];
      }
      total_score[c] += bonus;
      if (verbose) {
        printf("Total %s contribution of %d for %s\n", heuristic_strs[i], bonus,
               color_to_str(c));
      }
    }
  }

  ev_score_t tot = total_score[WHITE] - total_score[BLACK];

  if (RANDOMIZE) {
    ev_score_t z = rand_r(&seed) % (RANDOMIZE * 2 + 1);
    ev_score_t randomness = z - RANDOMIZE;
    tot = tot + randomness;
    if (verbose) {
      printf("Randomness of %d added\n",
             randomness * (1 - 2 * color_to_move_of(p)));
    }
  }

  if (color_to_move_of(p) == BLACK) {
    tot = -tot;
  }

  return tot / EV_SCORE_RATIO;
}
