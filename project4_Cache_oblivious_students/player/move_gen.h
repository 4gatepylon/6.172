// Copyright (c) 2021 MIT License by 6.172 Staff

#ifndef MOVE_GEN_H
#define MOVE_GEN_H

#include <inttypes.h>
#include <stdbool.h>
#include <stddef.h>

#define CHAIN_REACTION false

// The MAX_NUM_MOVES is just an estimate
#define MAX_NUM_MOVES 133      // real number = 12 * (11) + 1 = 133
#define MAX_PLY_IN_SEARCH 100  // up to 100 ply
#define MAX_PLY_IN_GAME 4096   // long game!  ;^)

// Used for debugging and display
#define MAX_CHARS_IN_MOVE 16  // Could be less
#define MAX_CHARS_IN_TOKEN 64

// -----------------------------------------------------------------------------
// Board
// -----------------------------------------------------------------------------

// The board is centered in a ARR_WIDTH x ARR_WIDTH array, with the
// (ample) excess height and width being used for sentinels.
#define ARR_WIDTH 16   // number of ranks
#define ARR_LENGTH 16  // number of files
#define ARR_SIZE (ARR_LENGTH * ARR_WIDTH)

// Board is BOARD_WIDTH x BOARD_WIDTH
#define BOARD_WIDTH 8

typedef uint8_t square_t;
typedef uint8_t rnk_t;
typedef uint8_t fil_t;

#define FIL_ORIGIN ((ARR_LENGTH - BOARD_WIDTH) / 2)
#define RNK_ORIGIN ((ARR_WIDTH - BOARD_WIDTH) / 2)

#define FIL_SHIFT 4
#define FIL_MASK 0xF
#define RNK_SHIFT 0
#define RNK_MASK 0xF

// -----------------------------------------------------------------------------
// Pieces
// -----------------------------------------------------------------------------

#define MAX_PAWNS 3     // maximum number of Pawns removed per move
#define MAX_MONARCHS 1  // maximum number of Monarchs per color

#define PIECE_INDEX_SIZE 6  // Width of index returned by piece_index()

// -----------------------------------------------------------------------------
// Piece types
// -----------------------------------------------------------------------------

typedef enum __attribute__((packed)) { EMPTY, PAWN, MONARCH, INVALID } ptype_t;

// -----------------------------------------------------------------------------
// Colors
// -----------------------------------------------------------------------------

typedef enum __attribute__((packed)) {
  WHITE = 0,
  BLACK = 1,
  NEUTRAL = 2
} color_t;

// -----------------------------------------------------------------------------
// Orientations
// -----------------------------------------------------------------------------

#define NUM_ORI 4

typedef enum __attribute__((packed)) { NN, EE, SS, WW } monarch_ori_t;
typedef enum __attribute__((packed)) { NW, NE, SE, SW } pawn_ori_t;

// -----------------------------------------------------------------------------
// Directions
// -----------------------------------------------------------------------------

typedef enum {
  dirNW,
  dirN,
  dirNE,
  dirE,
  dirSE,
  dirS,
  dirSW,
  dirW,
  NUM_DIR
} compass_t;

#define NORTH 1
#define SOUTH (-1)
#define EAST ARR_WIDTH
#define WEST (-ARR_WIDTH)

static const int dir[NUM_DIR] = {NORTH + WEST, NORTH, NORTH + EAST, EAST,
                                 SOUTH + EAST, SOUTH, SOUTH + WEST, WEST};

// -----------------------------------------------------------------------------
// Moves
// -----------------------------------------------------------------------------

// Rotations
#define NUM_ROT 4

typedef enum __attribute__((packed)) { NONE, RIGHT, UTURN, LEFT } rot_t;

typedef struct __attribute__((packed)) {
  ptype_t typ;
  rot_t rot;
  square_t from_sq;
  square_t to_sq;
} move_t;

#define NULL_MOVE \
  (move_t) { (ptype_t)0, (rot_t)0, (square_t)0, (square_t)0 }

typedef uint32_t sort_key_t;
typedef struct {
  sort_key_t key;
  move_t mv;
} sortable_move_t;

typedef struct __attribute__((packed)) {
  color_t color;
  ptype_t typ;
  union {
    pawn_ori_t pawn_ori;
    monarch_ori_t monarch_ori;
  };
} piece_t;

#define NULL_PIECE                            \
  (piece_t) {                                 \
    (color_t)0, (ptype_t)0, { (pawn_ori_t)0 } \
  }

typedef struct victims_t {
  int zapped_count;
  piece_t zapped[MAX_PAWNS];  //
} victims_t;

// returned by make move in illegal situation
#define ILLEGAL_ZAPPED -1

// -----------------------------------------------------------------------------
// Position
// -----------------------------------------------------------------------------

// Board representation is square-centric with sentinels.
//
// https://www.chessprogramming.org/Board_Representation
// https://www.chessprogramming.org/Mailbox
// https://www.chessprogramming.org/10x12_Board

#define MAX_NUM_PAWNS 4
typedef struct __attribute__((packed)) position {
  piece_t board[ARR_SIZE];
  square_t pawn_locs[2]
                    [MAX_NUM_PAWNS];  // Pawn locations, white at 0, black at 1.
  struct position* history;           // history of position
  uint64_t key;                       // hash key
  int ply;                // ply since beginning of game (even=White, odd=Black)
  int nply_since_victim;  // number of ply since last capture
  move_t last_move;       // move that led to this position
  victims_t victims;      // pieces destroyed by shooter
  square_t mloc[2];       // location of monarchs
  bool was_played;        // TRUE: position was actually played;
                          // FALSE: position is being considered in search
} position_t;

// -----------------------------------------------------------------------------
// Function prototypes
// -----------------------------------------------------------------------------

int piece_index(piece_t p);
void rotate_piece(piece_t* p, rot_t rot);
const char* color_to_str(color_t c);
color_t color_to_move_of(position_t* p);
color_t opp_color(color_t c);

void init_zob();
uint64_t compute_zob_key(position_t* p);

square_t square_of(fil_t f, rnk_t r);
fil_t fil_of(square_t sq);
rnk_t rnk_of(square_t sq);
int square_to_str(square_t sq, char* buf, size_t bufsize);

int dir_of(compass_t d);
int beam_of(int direction);
int reflect_of(int beam_dir, int pawn_ori);

move_t move_of(ptype_t typ, rot_t rot, square_t from_sq, square_t to_sq);
void move_to_str(move_t mv, char* buf, size_t bufsize);
bool move_eq(move_t a, move_t b);
bool sortable_move_seq(sortable_move_t a, sortable_move_t b);
sortable_move_t make_sortable(move_t mv);

square_t fire_laser(position_t* p, color_t c);
square_t fire_gravity_laser(position_t* p, color_t c, bool* arr);

int generate_all(position_t* p, sortable_move_t* sortable_move_list);
int generate_all_with_color(position_t* p, sortable_move_t* sortable_move_list,
                            color_t color_to_move);
void do_perft(position_t* gme, int depth);
void low_level_make_move(position_t* old, position_t* p, move_t mv);
piece_t edit_position(position_t* p, move_t mv);
victims_t make_move(position_t* old, position_t* p, move_t mv);
victims_t actually_make_move(position_t* old, position_t* p, move_t mv);
void display(position_t* p);

victims_t ILLEGAL();

bool is_ILLEGAL(victims_t victims);
bool zero_victims(victims_t victims);
bool victim_exists(victims_t victims);

// void get_coordinates_of_pawn(square_t sq, int ori, int* curr_coords);
// bool points_collide(int* coords1, int* coords2);

bool do_pawns_touch(pawn_ori_t ori_p1, pawn_ori_t ori_p2, compass_t dir);
void update_victim(position_t* p, square_t victim_sq);

#endif  // MOVE_GEN_H
