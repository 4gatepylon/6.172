// Copyright (c) 2021 MIT License by 6.172 Staff

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include "eval.h"
#include "fen.h"
#include "move_gen.h"
#include "search.h"
#include "tbassert.h"
#include "util.h"

static const char* color_strs[3] = {"White", "Black", "Neutral"};

const char* color_to_str(color_t c) { return color_strs[c]; }

// -----------------------------------------------------------------------------
// Piece getters and setters (including color, ptype, orientation)
// -----------------------------------------------------------------------------

// which color is moving next
color_t color_to_move_of(position_t* p) {
  if ((p->ply & 1) == 0) {
    return WHITE;
  } else {
    return BLACK;
  }
}

int piece_index(piece_t p) {
  return (((int)p.color) << 4) | (((int)p.typ) << 2) | (int)p.pawn_ori;
}

void rotate_piece(piece_t* p, rot_t rot) {
  p->pawn_ori = (pawn_ori_t)((rot + (int)p->pawn_ori) % NUM_ORI);
}

color_t opp_color(color_t c) {
  if (c == WHITE) {
    return BLACK;
  } else if (c == BLACK) {
    return WHITE;
  } else {
    return NEUTRAL;
  }
}

bool move_eq(move_t a, move_t b) {
  return a.typ == b.typ && a.rot == b.rot && a.from_sq == b.from_sq &&
         a.to_sq == b.to_sq;
}

bool sortable_move_seq(sortable_move_t a, sortable_move_t b) {
  return move_eq(a.mv, b.mv) && a.key == b.key;
}

sortable_move_t make_sortable(move_t mv) {
  sortable_move_t sortable;
  sortable.key = 0;
  sortable.mv = mv;
  return sortable;
}

// -----------------------------------------------------------------------------
// Piece orientation strings
// -----------------------------------------------------------------------------

// Monarch orientations
const char* monarch_ori_to_rep[3][NUM_ORI] = {{"NN", "EE", "SS", "WW"},
                                              {"nn", "ee", "ss", "ww"},
                                              {"$nn", "$ee", "$ss", "$ww"}};

// Pawn orientations
const char* pawn_ori_to_rep[3][NUM_ORI] = {{"NW", "NE", "SE", "SW"},
                                           {"nw", "ne", "se", "sw"},
                                           {"$nw", "$ne", "$se", "$sw"}};

const char* nesw_to_str[NUM_ORI] = {"north", "east", "south", "west"};

// -----------------------------------------------------------------------------
// Board hashing
// -----------------------------------------------------------------------------

// Zobrist hashing
//
// https://www.chessprogramming.org/Zobrist_Hashing
//
// NOTE: Zobrist hashing uses piece_t as an integer index into to the zob table.
// So if you change your piece representation, you'll need to recompute what the
// old piece representation is when indexing into the zob table to get the same
// node counts.
static uint64_t zob[ARR_SIZE][1 << PIECE_INDEX_SIZE];
static uint64_t zob_color;
uint64_t myrand();

uint64_t compute_zob_key(position_t* p) {
  uint64_t key = 0;
  for (fil_t f = 0; f < BOARD_WIDTH; f++) {
    for (rnk_t r = 0; r < BOARD_WIDTH; r++) {
      square_t sq = square_of(f, r);
      key ^= zob[sq][piece_index(p->board[sq])];
    }
  }
  if (color_to_move_of(p) == BLACK) {
    key ^= zob_color;
  }

  return key;
}

void init_zob() {
  for (int i = 0; i < ARR_SIZE; i++) {
    for (int j = 0; j < (1 << PIECE_INDEX_SIZE); j++) {
      zob[i][j] = myrand();
    }
  }
  zob_color = myrand();
}

// -----------------------------------------------------------------------------
// Squares
// -----------------------------------------------------------------------------

// For no square, use 0, which is guaranteed to be off board
square_t square_of(fil_t f, rnk_t r) {
  square_t s = ARR_WIDTH * (FIL_ORIGIN + f) + RNK_ORIGIN + r;
  DEBUG_LOG(1, "Square of (file %d, rank %d) is %d\n", f, r, s);
  tbassert((s >= 0) && ((int)s < ARR_SIZE), "s: %d\n", s);
  return s;
}

// Finds file of square
fil_t fil_of(square_t sq) {
  fil_t f = ((sq >> FIL_SHIFT) & FIL_MASK) - FIL_ORIGIN;
  DEBUG_LOG(1, "File of square %d is %d\n", sq, f);
  return f;
}

// Finds rank of square
rnk_t rnk_of(square_t sq) {
  rnk_t r = ((sq >> RNK_SHIFT) & RNK_MASK) - RNK_ORIGIN;
  DEBUG_LOG(1, "Rank of square %d is %d\n", sq, r);
  return r;
}

// converts a square to string notation, returns number of characters printed
int square_to_str(square_t sq, char* buf, size_t bufsize) {
  fil_t f = fil_of(sq);
  rnk_t r = rnk_of(sq);
  if (f >= 0) {
    return snprintf(buf, bufsize, "%c%d", 'a' + f, r);
  } else {
    return snprintf(buf, bufsize, "%c%d", 'z' + f + 1, r);
  }
}

// -----------------------------------------------------------------------------
// Board direction and laser direction
// -----------------------------------------------------------------------------

// direction map

int dir_of(compass_t d) {
  tbassert(d >= 0 && d < NUM_DIR, "d: %d\n", d);
  return dir[d];
}

// directions for laser: NN, EE, SS, WW
static int beam[NUM_ORI] = {NORTH, EAST, SOUTH, WEST};

int beam_of(int direction) {
  tbassert(direction >= 0 && direction < NUM_ORI, "dir: %d\n", direction);
  return beam[direction];
}

// reflect[beam_dir][pawn_orientation]
// sentinel -1 indicates back of Pawn
int reflect[NUM_ORI][NUM_ORI] = {
    // NW  NE  SE  SW
    {-1, -1, EE, WW},  // NN
    {NN, -1, -1, SS},  // EE
    {WW, EE, -1, -1},  // SS
    {-1, NN, SS, -1}   // WW
};

int reflect_of(int beam_dir, int pawn_ori) {
  tbassert(beam_dir >= 0 && beam_dir < NUM_ORI, "beam-dir: %d\n", beam_dir);
  tbassert(pawn_ori >= 0 && pawn_ori < NUM_ORI, "pawn-ori: %d\n", pawn_ori);
  return reflect[beam_dir][pawn_ori];
}

// -----------------------------------------------------------------------------
// Move getters and setters
// -----------------------------------------------------------------------------

move_t move_of(ptype_t typ, rot_t rot, square_t from_sq, square_t to_sq) {
  move_t mv;
  mv.typ = typ;
  mv.rot = rot;
  mv.from_sq = from_sq;
  mv.to_sq = to_sq;
  return mv;
}

// converts a move to string notation for FEN
void move_to_str(move_t mv, char* buf, size_t bufsize) {
  square_t f = mv.from_sq;  // from-square
  square_t t = mv.to_sq;    // to-square
  rot_t r = mv.rot;         // rotation
  const char* orig_buf = buf;

  buf += square_to_str(f, buf, bufsize);
  if (f != t) {
    buf += square_to_str(t, buf, bufsize - (buf - orig_buf));
  } else {
    switch (r) {
      case NONE:
        buf += square_to_str(t, buf, bufsize - (buf - orig_buf));
        break;
      case RIGHT:
        buf += snprintf(buf, bufsize - (buf - orig_buf), "R");
        break;
      case UTURN:
        buf += snprintf(buf, bufsize - (buf - orig_buf), "U");
        break;
      case LEFT:
        buf += snprintf(buf, bufsize - (buf - orig_buf), "L");
        break;
      default:
        tbassert(false, "Whoa, now.  Whoa, I say.\n");  // Bad, bad, bad
        break;
    }
  }
}

// -----------------------------------------------------------------------------
// Move generation
// -----------------------------------------------------------------------------

square_t fire_gravity_laser(position_t* p, color_t c, bool* arr) {
  square_t sq = p->mloc[c];
  int bdir = (int)p->board[sq].monarch_ori;

  tbassert(p->board[sq].typ == MONARCH, "ptype: %d\n", p->board[sq].typ);

  while (true) {
    sq += beam_of(bdir);
    tbassert((int)sq < ARR_SIZE && sq >= 0, "sq: %d\n", sq);

    switch (p->board[sq].typ) {
      case EMPTY:  // empty square
        break;
      case PAWN:  // Pawn
        bdir = reflect_of(bdir, p->board[sq].pawn_ori);
        if (bdir < 0) {  // Hit back of Pawn
          return sq;
        }
        if (p->board[sq].color == NEUTRAL) {
          arr[sq] = true;
        }
        break;
      case MONARCH:  // Monarch
        return sq;   // sorry, game over my friend!
        break;
      case INVALID:  // Ran off edge of board
        return 0;
        break;
      default:  // Shouldn't happen, man!
        tbassert(false, "Like cookies and cheese.\n");
        break;
    }
  }
}

// Generate all moves from position p.  Returns number of moves.
//
// https://www.chessprogramming.org/Move_Generation
int generate_all(position_t* p, sortable_move_t* sortable_move_list) {
  color_t color_to_move = color_to_move_of(p);
  bool neutral_control[ARR_WIDTH * ARR_WIDTH] = {0};
  fire_gravity_laser(p, color_to_move, neutral_control);

  int move_count = 0;

  for (fil_t f = 0; f < BOARD_WIDTH; f++) {
    for (rnk_t r = 0; r < BOARD_WIDTH; r++) {
      square_t sq = square_of(f, r);
      piece_t piece = p->board[sq];

      ptype_t typ = piece.typ;
      color_t color = piece.color;

      switch (typ) {
        case EMPTY:
          break;
        case PAWN:
        case MONARCH:
          if (color != color_to_move) {  // Wrong color
            if (!neutral_control[sq]) {  // And not a neutral under control
              break;
            }
          }
          // directions
          for (int d = 0; d < (int)NUM_DIR; d++) {
            compass_t dir = (compass_t)d;
            int dest = sq + dir_of(dir);
            if (p->board[dest].typ == INVALID) {
              continue;  // illegal square
            }
            if (p->board[dest].typ == MONARCH) {
              continue;  // cannot move onto a monarch
            }

            WHEN_DEBUG_VERBOSE(char buf[MAX_CHARS_IN_MOVE]);
            WHEN_DEBUG_VERBOSE({
              move_to_str(move_of(typ, (rot_t)0, sq, dest), buf,
                          MAX_CHARS_IN_MOVE);
              DEBUG_LOG(1, "Before: %s ", buf);
            });
            tbassert(move_count < MAX_NUM_MOVES, "move_count: %d\n",
                     move_count);

            move_t mv = move_of(typ, (rot_t)0, sq, dest);
            sortable_move_list[move_count++] = make_sortable(mv);

            WHEN_DEBUG_VERBOSE({
              move_to_str(get_move(sortable_move_list[move_count - 1]), buf,
                          MAX_CHARS_IN_MOVE);
              DEBUG_LOG(1, "After: %s\n", buf);
            });
          }

          // For all non-360-degree rotations (i.e., not rot==0, which is NONE)
          for (int rot = 1; rot < NUM_ROT; ++rot) {
            tbassert(move_count < MAX_NUM_MOVES, "move_count: %d\n",
                     move_count);
            move_t mv = move_of(typ, (rot_t)rot, sq, sq);
            sortable_move_list[move_count++] = make_sortable(mv);
          }

          // null move
          if (typ == MONARCH && fire_laser(p, color) > 0) {
            move_t mv = move_of(typ, (rot_t)0, sq, sq);
            sortable_move_list[move_count++] = make_sortable(mv);
          }

          break;
        case INVALID:
        default:
          tbassert(false, "Bogus, man.\n");  // Couldn't BE more bogus!
      }
    }
  }

  WHEN_DEBUG_VERBOSE({
    DEBUG_LOG(1, "\nGenerated moves: ");
    for (int i = 0; i < move_count; ++i) {
      char buf[MAX_CHARS_IN_MOVE];
      move_to_str(get_move(sortable_move_list[i]), buf, MAX_CHARS_IN_MOVE);
      DEBUG_LOG(1, "%s ", buf);
    }
    DEBUG_LOG(1, "\n");
  });

  return move_count;
}

int generate_all_with_color(position_t* p, sortable_move_t* sortable_move_list,
                            color_t color) {
  color_t color_to_move = color_to_move_of(p);
  if (color_to_move != color) {
    p->ply++;
  }

  int num_moves = generate_all(p, sortable_move_list);

  if (color_to_move != color) {
    p->ply--;
  }

  return num_moves;
}

// -----------------------------------------------------------------------------
// Move execution
// -----------------------------------------------------------------------------

// Returns the square of piece that would be zapped by the laser if fired once,
// or 0 if no such piece exists.
//
// p : Current board state.
// c : Color of monarch shooting laser.
square_t fire_laser(position_t* p, color_t c) {
  square_t sq = p->mloc[c];
  int bdir = (int)p->board[sq].monarch_ori;

  tbassert(p->board[sq].typ == MONARCH, "ptype: %d\n", p->board[sq].typ);

  while (true) {
    sq += beam_of(bdir);
    tbassert((int)sq < ARR_SIZE && sq >= 0, "sq: %d\n", sq);

    switch (p->board[sq].typ) {
      case EMPTY:  // empty square
        break;
      case PAWN:  // Pawn
        bdir = reflect_of(bdir, p->board[sq].pawn_ori);
        if (bdir < 0) {  // Hit back of Pawn
          return sq;
        }
        break;
      case MONARCH:  // Monarch
        return sq;   // sorry, game over my friend!
        break;
      case INVALID:  // Ran off edge of board
        return 0;
        break;
      default:  // Shouldn't happen, man!
        tbassert(false, "Like porkchops and whipped cream.\n");
        break;
    }
  }
}

void low_level_make_move(position_t* old, position_t* p, move_t mv) {
  tbassert(!move_eq(mv, NULL_MOVE), "mv was zero.\n");

  WHEN_DEBUG_VERBOSE(char buf[MAX_CHARS_IN_MOVE]);
  WHEN_DEBUG_VERBOSE({
    move_to_str(mv, buf, MAX_CHARS_IN_MOVE);
    DEBUG_LOG(1, "low_level_make_move: %s\n", buf);
  });

  tbassert(old->key == compute_zob_key(old),
           "old->key: %" PRIu64 ", zob-key: %" PRIu64 "\n", old->key,
           compute_zob_key(old));

  WHEN_DEBUG_VERBOSE({
    fprintf(stderr, "Before:\n");
    display(old);
  });

  square_t from_sq = mv.from_sq;
  square_t to_sq = mv.to_sq;
  rot_t rot = mv.rot;

  WHEN_DEBUG_VERBOSE({
    DEBUG_LOG(1, "low_level_make_move 2:\n");
    square_to_str(from_sq, buf, MAX_CHARS_IN_MOVE);
    DEBUG_LOG(1, "from_sq: %s\n", buf);
    square_to_str(to_sq, buf, MAX_CHARS_IN_MOVE);
    DEBUG_LOG(1, "to_sq: %s\n", buf);
    switch (rot) {
      case NONE:
        DEBUG_LOG(1, "rot: none\n");
        break;
      case RIGHT:
        DEBUG_LOG(1, "rot: R\n");
        break;
      case UTURN:
        DEBUG_LOG(1, "rot: U\n");
        break;
      case LEFT:
        DEBUG_LOG(1, "rot: L\n");
        break;
      default:
        tbassert(false, "Not like a boss at all.\n");  // Bad, bad, bad
        break;
    }
  });

  *p = *old;

  p->history = old;
  p->last_move = mv;

  tbassert((int)from_sq < ARR_SIZE && from_sq > 0, "from_sq: %d\n", from_sq);
  tbassert(piece_index(p->board[from_sq]) < (1 << PIECE_INDEX_SIZE) &&
               piece_index(p->board[from_sq]) >= 0,
           "p->board[from_sq]: %d\n", piece_index(p->board[from_sq]));
  tbassert((int)to_sq < ARR_SIZE && to_sq > 0, "to_sq: %d\n", to_sq);
  tbassert(piece_index(p->board[to_sq]) < (1 << PIECE_INDEX_SIZE) &&
               piece_index(p->board[to_sq]) >= 0,
           "p->board[to_sq]: %d\n", piece_index(p->board[to_sq]));

  p->key ^= zob_color;  // swap color to move

  piece_t from_piece = p->board[from_sq];
  piece_t to_piece = p->board[to_sq];

  if (to_sq != from_sq) {  // move, not rotation
                           // Note: if pawn, remove from from_sq, put in to_sq
                           // This just moves pawns around.
    if (from_piece.color < 2) {
// Update our pawn quick ref.
#pragma unroll MAX_NUM_PAWNS
      for (int i = 0; i < MAX_NUM_PAWNS; i++) {
        if (from_sq == p->pawn_locs[from_piece.color][i]) {
          p->pawn_locs[from_piece.color][i] = to_sq;
          break;
        }
      }
    }
    // Hash key updates
    p->key ^= zob[from_sq]
                 [piece_index(from_piece)];  // remove from_piece from from_sq
    p->key ^= zob[to_sq][piece_index(to_piece)];  // remove to_piece from to_sq

    p->board[from_sq] = NULL_PIECE;
    // TODO: Set pawn map.
    p->key ^= zob[from_sq][0];

    if (to_piece.typ == PAWN && from_piece.typ != MONARCH) {
      p->board[to_sq] = NULL_PIECE;
      p->key ^= zob[to_sq][0];
      if (to_piece.color < 2) {
// Update our pawn quick ref. Mutual kill.
#pragma unroll MAX_NUM_PAWNS
        for (int i = 0; i < MAX_NUM_PAWNS; i++) {
          if (to_sq == p->pawn_locs[to_piece.color][i]) {
            p->pawn_locs[to_piece.color][i] = 0;
            break;
          }
        }
      }
      if (from_piece.color < 2) {
        // Update our pawn quick ref. Mutual kill.
#pragma unroll MAX_NUM_PAWNS
        for (int i = 0; i < MAX_NUM_PAWNS; i++) {
          if (to_sq == p->pawn_locs[from_piece.color][i]) {
            p->pawn_locs[from_piece.color][i] = 0;
            break;
          }
        }
      }
    } else {
      if (from_piece.typ == MONARCH && to_piece.color < 2) {
// Update our pawn quick ref. Monarch kill.
#pragma unroll MAX_NUM_PAWNS
        for (int i = 0; i < MAX_NUM_PAWNS; i++) {
          if (to_sq == p->pawn_locs[to_piece.color][i]) {
            p->pawn_locs[to_piece.color][i] = 0;
            break;
          }
        }
      }
      p->board[to_sq] = from_piece;
      p->key ^= zob[to_sq][piece_index(from_piece)];
    }

    // Update Monarch locations if necessary
    if (from_piece.typ == MONARCH) {
      p->mloc[from_piece.color] = to_sq;
    }

  } else {  // rotation
    // remove from_piece from from_sq in hash
    p->key ^= zob[from_sq][piece_index(from_piece)];
    rotate_piece(&from_piece, rot);  // rotate from_piece
    p->board[from_sq] = from_piece;  // place rotated piece on board
    p->key ^= zob[from_sq][piece_index(from_piece)];  // ... and in hash
  }

  // Increment ply
  p->ply++;

  tbassert(p->key == compute_zob_key(p),
           "p->key: %" PRIu64 ", zob-key: %" PRIu64 "\n", p->key,
           compute_zob_key(p));

  WHEN_DEBUG_VERBOSE({
    fprintf(stderr, "After:\n");
    display(p);
  });
}

bool do_pawns_touch(pawn_ori_t ori_p1, pawn_ori_t ori_p2, compass_t dir) {
  tbassert((0 <= ori_p1) && (ori_p1 < NUM_ORI), "Bad p1 orientation! %d\n",
           ori_p1);
  tbassert((0 <= ori_p2) && (ori_p2 < NUM_ORI), "Bad p2 orientation! %d\n",
           ori_p2);
  tbassert((0 <= dir) && (dir < NUM_DIR), "Bad direction! %d\n", dir);

  switch (dir) {
    case dirNW:
      return ori_p1 != NW && ori_p2 != SE;
    case dirNE:
      return ori_p1 != NE && ori_p2 != SW;
    case dirN:
      return !((ori_p1 == NW && ori_p2 == SE) ||
               (ori_p1 == NE && ori_p2 == SW));
    case dirW:
      return !((ori_p1 == NW && ori_p2 == SE) ||
               (ori_p1 == SW && ori_p2 == NE));
    case dirE:
      return do_pawns_touch(ori_p2, ori_p1, dirW);
    case dirSW:
      return do_pawns_touch(ori_p2, ori_p1, dirNE);
    case dirS:
      return do_pawns_touch(ori_p2, ori_p1, dirN);
    case dirSE:
      return do_pawns_touch(ori_p2, ori_p1, dirNW);

    default:
      tbassert(false, "Lost your sense of direction, eh?");
      return false;
  }
}

void update_victim(position_t* p, square_t sq) {
  piece_t piece = p->board[sq];
  // remove victim
  p->victims.zapped[p->victims.zapped_count++] = piece;
  p->key ^= zob[sq][piece_index(piece)];
  if (piece.color < 2 && piece.typ != MONARCH) {
#pragma unroll MAX_NUM_PAWNS
    for (int i = 0; i < MAX_NUM_PAWNS; i++) {
      if (sq == p->pawn_locs[piece.color][i]) {
        p->pawn_locs[piece.color][i] = 0;
        break;
      }
    }
  }

  p->board[sq] = NULL_PIECE;
  p->key ^= zob[sq][0];
  tbassert(p->key == compute_zob_key(p),
           "p->key: %" PRIu64 ", zob-key: %" PRIu64 "\n", p->key,
           compute_zob_key(p));

  WHEN_DEBUG_VERBOSE({
    square_to_str(sq, buf, MAX_CHARS_IN_MOVE);
    DEBUG_LOG(1, "Piece on %s destroyed.\n", buf);
  });
}

// returns victim pieces (does not mark position as actually played)
victims_t make_move(position_t* old, position_t* p, move_t mv) {
  tbassert(!move_eq(mv, NULL_MOVE), "mv was zero.\n");

  WHEN_DEBUG_VERBOSE(char buf[MAX_CHARS_IN_MOVE]);

  // move phase 1 - moving a piece
  low_level_make_move(old, p, mv);

  // move phase 2 - shooting the laser
  square_t victim_sq = 0;
  p->victims.zapped_count = 0;

  if ((victim_sq = fire_laser(p, color_to_move_of(old)))) {
    WHEN_DEBUG_VERBOSE({
      square_to_str(victim_sq, buf, MAX_CHARS_IN_MOVE);
      DEBUG_LOG(1, "Zapping piece on %s\n", buf);
    });

    // We definitely hit something with the laser.  Remove it from the board.
    update_victim(p, victim_sq);
  }

  if (mv.from_sq != mv.to_sq) {
    if (old->board[mv.to_sq].typ == PAWN) {
      p->victims.zapped[p->victims.zapped_count++] = old->board[mv.to_sq];
      if (old->board[mv.from_sq].typ != MONARCH) {
        p->victims.zapped[p->victims.zapped_count++] = old->board[mv.from_sq];
      }
    }
  }

  if (p->victims.zapped_count == 0) {
    // increment ply counter since last victim
    p->nply_since_victim = old->nply_since_victim + 1;
  } else {
    // reset ply counter since last victim
    p->nply_since_victim = 0;
  }

  // mark position as not played (yet)
  p->was_played = false;

  return p->victims;
}

// returns victim pieces and marks position as actually played
victims_t actually_make_move(position_t* old, position_t* p, move_t mv) {
  make_move(old, p, mv);
  p->was_played = true;
  return p->victims;
}

// -----------------------------------------------------------------------------
// Move path enumeration (perft)
// -----------------------------------------------------------------------------

// Helper function for do_perft() (for root call, use ply 0).
static uint64_t perft_search(position_t* p, int depth, int ply) {
  uint64_t node_count = 0;
  position_t np;
  sortable_move_t lst[MAX_NUM_MOVES];
  int num_moves;
  int i;

  if (depth == 0) {
    return 1;
  }

  num_moves = generate_all(p, lst);

  if (depth == 1) {
    return num_moves;
  }

  for (i = 0; i < num_moves; i++) {
    move_t mv = get_move(lst[i]);
    make_move(p, &np, mv);

    if (np.victims.zapped_count > 0 && np.victims.zapped[0].typ == MONARCH) {
      // do not expand further: hit a Monarch
      node_count++;
      continue;
    }

    uint64_t partialcount = perft_search(&np, depth - 1, ply + 1);
    node_count += partialcount;
  }

  return node_count;
}

// Debugging function to perform a sanity check that the move generator is
// working correctly.  Not a thorough test, but quick.
//
// https://www.chessprogramming.org/Perft
void do_perft(position_t* gme, int depth) {
  for (int d = 0; d <= depth; d++) {
    printf("info perft %2d ", d);
    uint64_t j = perft_search(gme, d, 0);
    printf("%" PRIu64 "\n", j);
  }
}

// -----------------------------------------------------------------------------
// Position display
// -----------------------------------------------------------------------------

void display(position_t* p) {
  char buf[MAX_CHARS_IN_MOVE];

  printf("info Ply: %d\n", p->ply);
  printf("info Color to move: %s\n", color_to_str(color_to_move_of(p)));

  square_to_str(p->mloc[WHITE], buf, MAX_CHARS_IN_MOVE);
  printf("info White Monarch: %s\n", buf);
  square_to_str(p->mloc[BLACK], buf, MAX_CHARS_IN_MOVE);
  printf("info Black Monarch: %s\n", buf);

  for (int r = BOARD_WIDTH - 1; r >= 0;
       --r) {  // Don't use rnk_t, unsigned >= 0 comp.
    printf("\ninfo %1d ", r);
    for (fil_t f = 0; f < BOARD_WIDTH; ++f) {
      square_t sq = square_of(f, r);

      tbassert(p->board[sq].typ != INVALID, "p->board[sq].typ: %d\n",
               p->board[sq].typ);
      if (p->board[sq].typ == EMPTY) {  // empty square
        printf(" --");
        continue;
      }

      color_t c = p->board[sq].color;

      if (p->board[sq].typ == MONARCH) {
        int ori = (int)p->board[sq].monarch_ori;
        printf(" %2s", monarch_ori_to_rep[c][ori]);
        continue;
      }

      if (p->board[sq].typ == PAWN) {
        int ori = (int)p->board[sq].pawn_ori;
        if (p->board[sq].color == NEUTRAL) {
          printf("%3s", pawn_ori_to_rep[c][ori]);
        } else {
          printf(" %2s", pawn_ori_to_rep[c][ori]);
        }
        continue;
      }
    }
  }

  printf("\ninfo    ");
  for (fil_t f = 0; f < BOARD_WIDTH; ++f) {
    printf(" %c ", 'a' + f);
  }
  printf("\n");
  printf("DoneDisplay\n");  // DO NOT DELETE THIS LINE!!! It is needed for the
                            // autotester.
  printf("\n");
}

// -----------------------------------------------------------------------------
// Illegal move signalling
// -----------------------------------------------------------------------------

victims_t ILLEGAL() {
  victims_t v;
  v.zapped_count = ILLEGAL_ZAPPED;
  // memset(&v.zapped, 0, sizeof(v.zapped));
  return v;
}

bool is_ILLEGAL(victims_t victims) {
  return (victims.zapped_count == ILLEGAL_ZAPPED);
}

bool zero_victims(victims_t victims) { return (victims.zapped_count == 0); }

bool victim_exists(victims_t victims) { return (victims.zapped_count > 0); }
