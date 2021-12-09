#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include <getopt.h>
#include <cilk/cilk.h>
#include <cilk/cilkscale.h>

#define BASE_LIMIT 20

enum Mode{SERIAL, PARALLEL, DIV_CONQ};

typedef int64_t DIST;

static inline DIST min(DIST a, DIST b) {
    return (a < b) ? a : b;
}


bool between(int x, int y0, int y1) {
    return (y0 <= x && x < y1);
}

/* TRUE if the ranges [x0,x1) and [y0,y1) overlap */
bool overlaps(int x0, int x1, int y0, int y1) {
    return between(x0, y0, y1) || between(y0, x0, x1);
}

void floyd(DIST* A, int N,
    int i0, int i1,
    int j0, int j1,
    int k0, int k1) {
    /* DO NOT CHANGE THIS FUNCTION */
    for (int k = k0; k < k1; ++k) {
        for (int i = i0; i < i1; ++i) {
            for (int j = j0; j < j1; ++j) {
                A[N * i + j] = min(A[N * i + j], A[N * i + k] + A[N * k + j]);
            }
        }
    }
}

void floyd_parallel(DIST* A, int N,
    int i0, int i1,
    int j0, int j1,
    int k0, int k1) {
    // TODO: PARALLELIZE THIS FUNCTION
    for (int k = k0; k < k1; ++k) {
        for (int i = i0; i < i1; ++i) {
            for (int j = j0; j < j1; ++j) {
                A[N * i + j] = min(A[N * i + j], A[N * i + k] + A[N * k + j]);
            }
        }
    }
}

/* this is Matteo's idea of how the all-pairs shortest path problem
   should be solved in Cilk */
void fw_divide_and_conquer(DIST* A, int N,
    int i0, int i1,
    int j0, int j1,
    int k0, int k1) {
        
    int di = i1 - i0, dj = j1 - j0, dk = k1 - k0;

    if (di >= dj && di >= dk && di > 1) {
        int im = (i0 + i1) / 2;
        if (overlaps(i0, im, k0, k1)) {
            if (overlaps(im, i1, k0, k1)) {
                /* cannot cut i */
            } else {
                fw_divide_and_conquer(A, N, i0, im, j0, j1, k0, k1);
                fw_divide_and_conquer(A, N, im, i1, j0, j1, k0, k1);
                return;
            }
        } else {
            cilk_spawn fw_divide_and_conquer(A, N, im, i1, j0, j1, k0, k1);
            if (overlaps(im, i1, k0, k1))
                cilk_sync;
            fw_divide_and_conquer(A, N, i0, im, j0, j1, k0, k1);
            return;
        }
    }

    if (dj >= dk && dj > 1) {
        int jm = (j0 + j1) / 2;
        if (overlaps(j0, jm, k0, k1)) {
            if (overlaps(jm, j1, k0, k1)) {
                /* cannot cut j */
            } else {
                fw_divide_and_conquer(A, N, i0, i1, j0, jm, k0, k1);
                fw_divide_and_conquer(A, N, i0, i1, jm, j1, k0, k1);
                return;
            }
        } else {
            cilk_spawn fw_divide_and_conquer(A, N, i0, i1, jm, j1, k0, k1);
            if (overlaps(jm, j1, k0, k1))
                cilk_sync;
            fw_divide_and_conquer(A, N, i0, i1, j0, jm, k0, k1);
            return;
        }
    }

    if (dk > BASE_LIMIT) {
        int km = (k0 + k1) / 2;
        fw_divide_and_conquer(A, N, i0, i1, j0, j1, k0, km);
        fw_divide_and_conquer(A, N, i0, i1, j0, j1, km, k1);
        return;
    }

    /* base case: */
    floyd(A, N, i0, i1, j0, j1, k0, k1);
}

void test(int N, const bool correctness, const enum Mode mode) {

    DIST* A0 = NULL;
    // allocating memory to hold expected result
    if ( correctness )
        A0 = (DIST*) malloc(sizeof(DIST) * N * N);
    DIST* A1 = (DIST*) malloc(sizeof(DIST) * N * N);
    
    int i, j, r;

    // populating matrices
    for (i = 0; i < N; ++i) {
        for (j = 0; j < N; ++j) {
            DIST infinity = 1ull << 60; // supposed to hold largish distance
            if (sizeof(DIST) >= 16) {
                infinity = (infinity << 64);
            }
            if ( correctness )
                A0[i * N + j] = infinity;
            A1[i * N + j] = infinity;
        }
    }

    for (r = 0; r < 5 * N; ++r) {
        i = rand() % N;
        j = rand() % N;
        DIST dist = (DIST) (rand() % N);
        if ( correctness )
            A0[i * N + j] = dist;
        A1[i * N + j] = dist;
    }

    // Running Floyd-Warshall

    // wsp_t start_wsp = wsp_getworkspan(); // uncomment when using cilkscale
    switch (mode) {
        case SERIAL:
           floyd(A1, N, 0, N, 0, N, 0, N);
           break;
        case PARALLEL:
           floyd_parallel(A1, N, 0, N, 0, N, 0, N);
           break;
        case DIV_CONQ:
           fw_divide_and_conquer(A1, N, 0, N, 0, N, 0, N);
           break;
        default:
           abort();
    }
    // wsp_t stop_wsp = wsp_getworkspan(); // uncomment when using cilkscale
    // wsp_dump(wsp_sub(stop_wsp, start_wsp), "test"); // uncomment when using cilkscale

    // Checking for correctness
    if (correctness) {
        floyd(A0, N, 0, N, 0, N, 0, N);
        for (i = 0; i < N; ++i) {
            for (j = 0; j < N; ++j) {
                assert(A0[i * N + j] == A1[i * N + j]);
            }
        }
        printf("%d PASS\n", N);
        free(A0);
    }
    
    free(A1);
}

void print_menu(){
    fprintf (stderr, "Options: \n");
    fprintf (stderr, "-s run serial Floyd-Warshall.\n");
    fprintf (stderr, "-p run parallel Floyd-Warshall.\n");
    fprintf (stderr, "-d run divide-and-conquer Floyd-Warshall.\n");
    fprintf (stderr, "-c test for correctness.\n");
    fprintf (stderr, "-m set min number of points.\n");
    fprintf (stderr, "-n number of iterations where each iteration increments N.\n");
}

int main(int argc, char* argv[]) {
    bool correctness = false;
    int min_N = 1, N_count = 1;
    srand(10);
    enum Mode mode = SERIAL; // 0 is serial, 1 is parallel, 2 is divide and conquer
    int c;
    if (argc == 1) {
        print_menu();
        return 1;
    }
    while ((c = getopt (argc, argv, "spdcm:n:")) != -1) {
        switch (c) {
          case 's':
            mode = SERIAL;
            break;
          case 'p':
            mode = PARALLEL;
            break;
          case 'd':
            mode = DIV_CONQ;
            break;
          case 'c':
            correctness = true;
            min_N = 1;
            N_count = 100;
            break;
          case 'm':
            min_N = atoi(optarg);
            break;
          case 'n':
            N_count = atoi(optarg);
            break;
          default:
            print_menu();
            return 1;
        }
    }
    
    if (correctness) {
        printf("Running correctness on Mode: %d\n", mode);
    } else {
        printf("Running Mode: %d\n", mode);
    }
    for (int N = min_N; N < min_N + N_count; ++N) {
        test(N, correctness, mode);
    }
    return 0;
}
