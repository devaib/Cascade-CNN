#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int
main(void)
{
  const int N = 2; /* nb. neurons */

  double *w = malloc(N*N*sizeof(*w)); /* weights */
  double *b = malloc(N*sizeof(*w));   /* biases */

  FILE *f = fopen("/Users/wbh/net.bin", "rb");
  assert(fread(w, sizeof(*w), N*N, f) == N*N);
  assert(fread(b, sizeof(*w), N, f) == N);
  fclose(f);

  int i, j;
  for (i = 0; i < N; i++)
    for (j = 0; j < N; j++)
      printf("w[%d,%d] = %f\n", i, j, w[N*i+j]);

  for (i = 0; i < N; i++)
      printf("b[%d] = %f\n", i, b[i]);

  free(w);
  free(b);

  return 0;
}
