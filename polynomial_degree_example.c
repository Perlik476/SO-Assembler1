#include <stddef.h>
#include <stdio.h>
#include <assert.h>

// Testowana funkcja w asemblerze
int polynomial_degree(int const *y, size_t n);

static const int poly0[] = {-9, 0, 9, 18, 27};
static const int degree0 = 1;

static const int poly1[] = {1, 4, 9, 16, 25, 36, 49, 64, 81};
static const int degree1 = 2;

static const int poly2[] = {777};
static const int degree2 = 0;

static const int poly3[] = {5, 5};
static const int degree3 = 0;

static const int poly4[] = {0};
static const int degree4 = -1;

static const int poly5[] = {0, 0, 0, 0};
static const int degree5 = -1;

static const int poly6[] = {
  1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1,
  1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1,
  1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1,
  1, -1, 1, -1, 1, -1};
static const int degree6 = 65;

#define test(n, ans, y...) { \
	int tab[n] = y; \
  printf("result: %d, expected: %d\n", polynomial_degree(tab, n), ans); \
}

#define TEST(t) {poly##t, SIZE(poly##t), degree##t}
#define SIZE(x) (sizeof (x) / sizeof (x)[0])

typedef struct {
  int const *y;
  size_t    n;
  int       d;
} test_data_t;

static const test_data_t test_data[] = {
  TEST(0),
  TEST(1),
  TEST(2),
  TEST(3),
  TEST(4),
  TEST(5),
  TEST(6),
};

int main() {
  for (size_t test = 0; test < SIZE(test_data); ++test) {
    int d = polynomial_degree(test_data[test].y, test_data[test].n);
    if (d == test_data[test].d)
      printf("test %zu passed\n", test);
    else
      printf("test %zu failed with result %d\n", test, d);
  }

  // test(35, 13, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 14, 105, 560, 2380, 8568, 27132, 77520, 203490, 497420, 1144066, 2496144, 5200300, 10400600, 20058300, 37442160, 67863915, 119759850, 206253075, 347373600, 573166440, 927983760, 1476337800});
  test(32, 18, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 19, 190, 1330, 7315, 33649, 134596, 480700, 1562275, 4686825, 13123110, 34597290, 86493225, 206253075, 471435600, 1037158320});
  test(32, 20, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 21, 231, 1771, 10626, 53130, 230230, 888030, 3108105, 10015005, 30045015, 84672315, 225792840, 573166440, 1391975640})
}