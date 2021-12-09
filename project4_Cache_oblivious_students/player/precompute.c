// standalone file to precompute all distances from enemy monarch to board edges
#include <stdio.h>
#include <stdlib.h>
#define BOARD_WIDTH 8

float mult_dist(int f1, int r1, int f2, int r2) {
  int delta_fil = abs(f1 - f2);
  int delta_rnk = abs(r1 - r2);
  float x = (1.0 / (1 + delta_fil)) * (1.0 / (1 + delta_rnk));
  return x;
}

// f2 and r2 are rank and file of enemy monarch
// f and r are rank and file of perimeter of board
float compute(int f2, int r2) {
  float result = 0;
  int r;
  int f;
  r = -1;
  for (f = -1; f < BOARD_WIDTH + 1; f++) {
    result += mult_dist(f, r, f2, r2);
  }
  // add in bottom row
  r = BOARD_WIDTH;
  for (f = -1; f < BOARD_WIDTH + 1; f++) {
    result += mult_dist(f, r, f2, r2);
  }

  // add in left col (minus top and bottom)
  f = -1;
  for (r = 0; r < BOARD_WIDTH; r++) {
    result += mult_dist(f, r, f2, r2);
  }

  // add in right col (minus top and bottom)
  f = BOARD_WIDTH;
  for (r = 0; r < BOARD_WIDTH; r++) {
    result += mult_dist(f, r, f2, r2);
  }
  return result;
}

// print out distance for each square on board
int main() {
  printf("float edge_contributions [BOARD_WIDTH][BOARD_WIDTH] =\n    {{");
  for (int f2 = 0; f2 < BOARD_WIDTH; f2++) {
    if (f2 > 0) printf("     {");
    for (int r2 = 0; r2 < BOARD_WIDTH; r2++) {
      printf("%.10f", compute(f2, r2));
      if (r2 < BOARD_WIDTH - 1)
        printf(", ");
      else
        printf("}");
    }
    if (f2 < BOARD_WIDTH - 1)
      printf(",\n");
    else
      printf("};\n");
  }
}
