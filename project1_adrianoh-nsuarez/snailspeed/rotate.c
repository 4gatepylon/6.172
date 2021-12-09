/**
 * Copyright (c) 2020 MIT License by 6.172 Staff
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Authors: Adriano Hernandez and Natalia Suarez
 **/

#include "../utils/utils.h"

#define ROW_SIZE 64

// Basic numerical and boolean calculations (i.e. for block indices)
#define MULT2(n) ((n) << 1)
#define FLOOR_DIV2(n) ((n) >> 1)
#define CEIL_DIV2(n) ((n) >> 1) + ((n) & 1)
#define EVEN(n) 1 - ((n) & 1)
#define ODD(n) ((n) & 1)
#define NOT(n) (1 - (n))

// Conversions for when dealing with block indices vs bit indices
#define MULT64(n) ((n) << 6)
#define DIV64(n) ((n) >> 6)
#define MULT32(n) ((n) << 5)
#define DIV32(n) ((n) >> 5)
#define DIV8(n) ((n) >> 3)

// Flips the endianess to be able to implement row/column algorithm. This is equivalent to byteswap.
// A is the pointer to a 64x64 bit matrix which we want to flip the endianness for, for each word (64 total).
inline __attribute__ ((always_inline)) void endian_swap(uint64_t* const __restrict_arr __attribute__ ((aligned (64))) A)
{
  uint64_t mask = 0x00000000000000FFull;
  uint64_t mask2 = 0x000000000000FF00ull;
  uint64_t mask3 = 0x0000000000FF0000ull;
  uint64_t mask4 = 0x00000000FF000000ull;
  uint64_t mask5 = 0x000000FF00000000ull;
  uint64_t mask6 = 0x0000FF0000000000ull;
  uint64_t mask7 = 0x00FF000000000000ull;
  uint64_t mask8 = 0xFF00000000000000ull;

  for (uint_fast8_t x = 0; x < 64; x++)
  {
    uint64_t B;
    B = (A[x] & mask) << 56;
    B |= (A[x] & mask2) << 40;
    B |= (A[x] & mask3) << 24;
    B |= (A[x] & mask4) << 8;
    B |= (A[x] & mask5) >> 8;
    B |= (A[x] & mask6) >> 24;
    B |= (A[x] & mask7) >> 40;
    B |= (A[x] & mask8) >> 56;
    A[x] = B;
  }
}

// Rotate down the columns of a 64x64 bit matrix. In this context rotation is effectively
// a bit-shift, but when the number overflows, it comes back around.
// A is an aligned 64x64 bit matrix to do this operation on.
inline __attribute__ ((always_inline)) void rotate_down(uint64_t* const __restrict_arr __attribute__ ((aligned (64))) A) {
  uint64_t B[64];

  uint64_t down_mask = 0xFFFFFFFF00000000ull;
  uint64_t down_mask_half = 0xFFFF0000FFFF0000ull;
  uint64_t down_mask_quarter = 0xFF00FF00FF00FF00ull;
  uint64_t down_mask_eight = 0xF0F0F0F0F0F0F0F0ull;
  uint64_t down_mask_sixteenth = 0xCCCCCCCCCCCCCCCCull;
  uint64_t down_mask_last = 0xAAAAAAAAAAAAAAAAull;
  
  for (uint_fast8_t j = 0; j < 32; j++) {
    B[j] = (A[j] & down_mask) | (A[j + 32] & ~down_mask);
  }
  for (uint_fast8_t j = 32; j < 64; j++) {
    B[j] = (A[j] & down_mask) | (A[j - 32] & ~down_mask);
  }
  // Half
  for (uint_fast8_t j = 0; j < 16; j++){
    A[j] = (B[j] & down_mask_half) | (B[j + 48] & ~down_mask_half);
  }
  for (uint_fast8_t j = 16; j < 64; j++){
    A[j] = (B[j] & down_mask_half) | (B[j - 16] & ~down_mask_half);
  }
  // Quarter
  for (uint_fast8_t j = 0; j < 8; j++)
  {
    B[j] = (A[j] & down_mask_quarter) | (A[j + 56] & ~down_mask_quarter);
  }
  for (uint_fast8_t j = 8; j < 64; j++)
  {
    B[j] = (A[j] & down_mask_quarter) | (A[j - 8] & ~down_mask_quarter);
  }
  // Eighth
  for (uint_fast8_t j = 0; j < 4; j++)
  {
    A[j] = (B[j] & down_mask_eight) | (B[j + 60] & ~down_mask_eight);
  }
  for (uint_fast8_t j = 4; j < 64; j++)
  {
    A[j] = (B[j] & down_mask_eight) | (B[j - 4] & ~down_mask_eight);
  }
  // Sixteenth
  B[0] = (A[0] & down_mask_sixteenth) | (A[62] & ~down_mask_sixteenth);
  B[1] = (A[1] & down_mask_sixteenth) | (A[63] & ~down_mask_sixteenth);
  for (uint_fast8_t j = 2; j < 64; j++)
  {
    B[j] = (A[j] & down_mask_sixteenth) | (A[j - 2] & ~down_mask_sixteenth);
  }
  // Thirty second-th
  A[0] = (B[0] & down_mask_last) | (B[63] & ~down_mask_last);
  for (uint_fast8_t j = 1; j < 64; j++)
  {
    A[j] = (B[j] & down_mask_last) | (B[j - 1] & ~down_mask_last);
  }
}

// Rotates a 64x64bit block in two dimensions. The goal of our design is to rotate blocks
// of 64x64 bits and then move them around the image to their corresponding locations. This function
// does the rotation of the blocks themselves. A is one such block.
inline __attribute__ ((always_inline)) void rotate_inside(uint64_t* const __restrict_arr __attribute__ ((aligned (64))) A) {
  endian_swap(A);

  //shift rows to the left r
  for (uint_fast8_t r = 1; r < ROW_SIZE; r++) {
    A[r] = (A[r] << r) | (A[r] >> (ROW_SIZE - r));
  }

  // Rotate columns using a linearithmic-time divide and conquer algorithm
  rotate_down(A);

  //shift rows to the left r + 1
  for (uint_fast8_t r = 0; r < ROW_SIZE - 1; r++) {
    A[r] = (A[r] << (r + 1)) | (A[r] >> (ROW_SIZE - 1 - r));
  }
  endian_swap(A);
}

// Write from the block with the top left hand corner bit at x, y to tmp (indices by bits).
// N is the side length of the bit matrix mat (in bits) while x and y are the location of
// the top left corner (as coordinates) of the block in the matrix. The buffer tmp is the
// block buffer we'll use to rotate that block.
inline __attribute__ ((always_inline)) void matrix_to_block(
  uint64_t* const __restrict_arr mat, const bits_t N,
  const uint32_t x, const uint32_t y,
  uint64_t* const __restrict_arr tmp
  )
{
  #pragma clang loop unroll(enable)
  for (uint32_t i = 0; i < 64; i++) {
    tmp[i] = mat[(y + i) * (N / 64) + (x / 64)];
  }
}

// Write from tmp to the block with the top left hand corner bit at x, y (indices by bits).
// N is the side length of the bit matrix mat (in bits) while x and y are the location of
// the top left corner (as coordinates) of the block in the matrix. The buffer tmp is the block
// buffer we've used to rotate that block.
inline __attribute__ ((always_inline)) void block_to_matrix(
  uint64_t*__restrict_arr mat, const bits_t N,
  const uint32_t x, const uint32_t y,
  uint64_t* const __restrict_arr tmp
  )
{
  #pragma clang loop unroll(enable)
  for (uint32_t i = 0; i < 64; i++) {
    mat[(y + i) * (N / 64) + (x / 64)] = tmp[i];
  }
}

// Rotates outside matrix by taking 64 bit blocks and rotating them
// individually then placing them where they belong. img is an aligned
// bitmap while N is the side-length of the bit matrix. left, top, right, and bot
// define an exclusive to inclusive (left to right, top to bottom) bounding box
// for the sub-rectangle of the image to rotate blocks for.
//
// Because we rotate the corresponding three other blocks in the three other corners
// for any block we move, we only rotate for blocks in the top left quadrant and their
// corresponding blocks in the other three quadrants.
inline __attribute__ ((always_inline)) void rotate_outside(
  uint8_t* const __restrict_arr __attribute__ ((aligned (64))) img,
  const bits_t N, 
  uint32_t left, uint32_t top, 
  uint32_t right, uint32_t bot
  )
{
  uint64_t tmp1[64];
  uint64_t tmp2[64];
  uint64_t tmp3[64];
  uint64_t tmp4[64];

  uint64_t* mat = (uint64_t*)img;

  uint32_t x_top_right, y_top_right;
  uint32_t x_bot_right, y_bot_right;
  uint32_t x_bot_left, y_bot_left;

  for (uint32_t y_top_left = top; y_top_left < bot; y_top_left+=64) {
    for (uint32_t x_top_left = left; x_top_left < right; x_top_left+=64) {
      // Calculate the coordinates of the bits
      x_top_right = N - 64 - y_top_left;
      y_top_right = x_top_left;

      x_bot_right = N - 64 - x_top_left;
      y_bot_right = N - 64 - y_top_left;

      x_bot_left = y_top_left;
      y_bot_left = N - 64 - x_top_left;

      matrix_to_block(mat, N, x_top_left, y_top_left, tmp1);
      matrix_to_block(mat, N, x_top_right, y_top_right, tmp2);

      matrix_to_block(mat, N, x_bot_left, y_bot_left, tmp4);
      matrix_to_block(mat, N, x_bot_right, y_bot_right, tmp3);
      
      // Rotate batch
      rotate_inside(tmp1);
      rotate_inside(tmp2);
      rotate_inside(tmp3);
      rotate_inside(tmp4);

      // Write in a cache-friendly order
      block_to_matrix(mat, N, x_bot_left, y_bot_left, tmp3);
      block_to_matrix(mat, N, x_bot_right, y_bot_right, tmp2);

      block_to_matrix(mat, N, x_top_left, y_top_left, tmp4);
      block_to_matrix(mat, N, x_top_right, y_top_right, tmp1);
    }
  }
}

// Rotate a bit matrix by rotating the internal blocks. N is the size in bits of a side
// of the matrix. img is the matrix representing the image we want to rotate (as a bitmap).
void rotate_bit_matrix(uint8_t* const __restrict_arr __attribute__ ((aligned (64))) img, const bits_t N) {
  rotate_outside(img, N, 0, 0, FLOOR_DIV2(N), FLOOR_DIV2(N) - 32);

  // If the number of blocks per side is odd, there will be a leftover block in the middle
  // and we need to independently rotate it
  if(ODD(DIV64(N))) {
    uint64_t buff[64];
    matrix_to_block((uint64_t*)img, N, FLOOR_DIV2(N) - 32, FLOOR_DIV2(N) - 32, buff);
    rotate_inside(buff);
    block_to_matrix((uint64_t*)img, N, FLOOR_DIV2(N) - 32, FLOOR_DIV2(N) - 32, buff);
  }
}