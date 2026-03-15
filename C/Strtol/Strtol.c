#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*#define DEBUG*/

int convert_digit(char sym)
{
  if(sym >= 'A' && sym <= 'Z')
    return sym - 'A' + 10;
  if(sym >= 'a' && sym <= 'z')
    return sym - 'a' + 10;
  if(sym >= '0' && sym <= '9')
    return sym - '0';
  return -1;
}

/* ===== check every symbol type ==== */
/* check if sympol is a octal number */
int is_num(char sym, int radix)
{
  int res = convert_digit(sym);
  if(res == -1)
    return 0;
  return res < radix;
}

/* ======  ====== */
long get_num(const char **endpos, int radix)
{
  long res = 0;
  while (is_num(**endpos, radix)) {
    res *= radix;
    res += convert_digit(**endpos);
    (*endpos)++;
  }
  return res;
}

/* check what numerical system number is */
int get_num_type(const char **endpos, int radix)
{
  if(**endpos == '0' || radix == 8 || radix == 16) {
    (*endpos)++;
    if(**endpos == 'x' || **endpos == 'X' || radix == 16) {
      (*endpos)++;
      return 16;
    }
    else
      return 8;
  }
  return 10;
}

long str_to_long(const char *str, const char **endpos, int radix)
{
  if((radix != 0) && (radix < 2 || radix > 36))
    return 0;
#ifdef DEBUG
  printf("%s - with spaces\n", str);
#endif
  *endpos = str;
  while(**endpos == ' ') {
    (*endpos)++;
  }
#ifdef DEBUG
  printf("%s - without spaces\n", *endpos);
#endif
  radix = get_num_type(endpos, radix);

  return get_num(endpos, radix);
}

int main(int args, char **argv)
{
  const char *endpos = NULL;
  long num;
  int radix = 0;
  if(args < 2 || args > 3) {
    printf("Should be just one or two arguments\n");
    return 1;
  }
  if(args == 3)
    radix = str_to_long(argv[2], &endpos, 10);
  printf("%d\n", radix);
  num = str_to_long(argv[1], &endpos, radix);

  printf("%lo - resulting octal long type number\n", num);
  printf("%ld - resulting decimal long type number\n", num);
  printf("%lx - resulting hexadecimal long type number\n", num);
  printf("%s - resulting endpos string\n", endpos);
 
  return 0;
}
