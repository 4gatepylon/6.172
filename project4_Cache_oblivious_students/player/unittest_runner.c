/* Unit test runner
 * Intercepts main when UNIT_TEST
 * is defined
 */

#include <stdio.h>
#include <sys/wait.h>  // wtf linux
#include <unistd.h>

#include "unittest.h"

int run_unit_tests(void) {
  int i;

  fprintf(stderr, "Starting %d unit tests.\n", NUM_UNIT_TESTS);
  for (i = 0; i < NUM_UNIT_TESTS; i++) {
    int pid;

    fprintf(stderr, "%s...", test_fn_names[i]);
    pid = fork();

    if (pid < 0) {
      perror("fork");
      return 1;
    } else if (pid == 0) {
      return test_fns[i]();
    } else {
      int ws;
      wait(&ws);

      if (WIFSIGNALED(ws))
        fprintf(stderr, "FAILED: child terminated due to signal %d\n",
                WTERMSIG(ws));
      else if (WIFEXITED(ws)) {
        if (WEXITSTATUS(ws) == UNIT_TEST_SUCCESS)
          fprintf(stderr, "OK\n");
        else
          fprintf(stderr, "FAILED: child exited with status %d\n",
                  WEXITSTATUS(ws));
      } else {
        fprintf(stderr, "FAILED: child met an unknown fate\n");
        return 1;
      }
    }
  }
  return 0;
}
