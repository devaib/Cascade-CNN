#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int
main(void)
{
  const int N = 16; /* nb. neurons */
    const int M = 9;

  float *w = malloc(N*M*sizeof(*w)); /* weights */
  float *b = malloc(M*sizeof(*b));   /* biases */

  FILE *f = fopen("/Users/wbh/test.bin", "rb");
  assert(fread(w, sizeof(*w), N*M, f) == N*M);
  assert(fread(b, sizeof(*b), M, f) == M);
  fclose(f);

  int i, j;
  for (i = 0; i < N; i++)
    for (j = 0; j < M; j++)
      printf("w[%d,%d] = %f\n", i, j, w[N*i+j]);

  for (i = 0; i < M; i++)
      printf("b[%d] = %f\n", i, b[i]);

  free(w);
  free(b);

  return 0;
}
