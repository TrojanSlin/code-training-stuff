#include <stdlib.h>
#include <stdio.h>

enum {bufsize = 128};

/*#define DEBUG*/

/* ========= COMMON OPERATIONS PART ======== */
int count_word_lenght(char *str)
{
  int i;
  for(i = 1; *(str+i) != ' ' && *(str+i) != '\0'; i++)
    {}
  return i;
}

int get_word(char **str, int *len)
{
  while(**str) {
    if(**str != ' ') {
      *len = count_word_lenght(*str);
      return 1;
    }
    (*str)++;
  }
  *len = 0;
  *str = NULL;
  return 0;
}

char *read_string()
{
  static char buf[bufsize];
  int buf_used = 0;
  int sym;

  while((sym = getchar()) != EOF) {
    if(buf_used == bufsize - 1 || sym == '\n')
      break;
    buf[buf_used] = sym;
    buf_used++;
  }
  buf[buf_used] = '\0';
  if(buf_used == 0 && sym == EOF)
    return NULL;
  return buf;
}

/* ========= TASKS PART =========== */
int words_amount(char *str)
{
  int cnt = 0, len = 0;
  while(get_word(&str, &len)) {
    str += len;
    cnt++;
  }
  return cnt;
}

int odd_words(char *str)
{
  int res = 0, len = 0;
  while(get_word(&str, &len)) {
    str += len;
    if((len % 2) != 0)
      res++;
  }
  return res;
}

int even_words(char *str)
{
  int res = 0, len = 0;
  while(get_word(&str, &len)) {
    str += len;
    if((len % 2) == 0)
      res++;
  }
  return res;
}

int more_then2_words(char *str)
{
  int res = 0, len = 0;
  while(get_word(&str, &len)) {
    str += len;
    if(len > 2)
      res++;
  }
  return res;
}

int more_then7_words(char *str)
{
  int res = 0, len = 0;
  while(get_word(&str, &len)) {
    str += len;
    if(len > 7)
      res++;
  }
  return res;
}

int az_words(char *str)
{
  int res = 0, len = 0;
  while(get_word(&str, &len)) {
    if(*str == 'A' && *(str+len-1) == 'z')
      res++;
    str += len;
  }
  return res;
}

int max_words(char *str)
{
  int len = 0, res = 0;
  get_word(&str, &len);
  res = len;
  while(get_word(&str, &len)) {
    str += len;
    if(len > res)
      res = len;
  }
  return res;
}

int min_words(char *str)
{
  int len = 0, res = 0;
  get_word(&str, &len);
  res = len;
  while(get_word(&str, &len)) {
    str += len;
    if(len < res)
      res = len;
  }
  return res;
}

int biggest_space(char *str)
{
  char *prev;
  int len = 0, res = 0;
  while(get_word(&str, &len)) {
    prev = str + len - sizeof(char);
    str += len;
    if(get_word(&str, &len)) {
      if((str - prev) > res)
        res = str - prev;
    }
  }
  return res;
}

int balance_words(char *str)
{
  int len = 0, res = 0;
  while(get_word(&str, &len)) {
    for(int i = 0; i < len; i++) {
      if(str[i] == '(')
        res++;
      if(str[i] == ')')
        res--;
    }
    str += len;
  }
  return res == 0;
}

int straight_brackets_words(char *str)
{
  int len = 0, res = 0;
  while(get_word(&str, &len)) {
    for(int i = 0; i < len; i++) {
      if(str[i] == '(') {
        if(str[i+1] == ')')
          res++;
      }
    }
    str += len;
  }
  return res;
}

void get_string_params()
{
  char *str;
  while((str = read_string())) {
    printf("%s\n", str);
    printf("a)\tAmount of words - %d\n\n", words_amount(str));
    printf("b)\tAmount of words with odd length - %d\n", odd_words(str));
    printf("\tAmount of words with even length - %d\n\n", even_words(str));
    printf("c)\tAmount of words with more then 2 letters - %d\n",
           more_then2_words(str));
    printf("\tAmount of words with more then 7 letters - %d\n\n",
           more_then7_words(str));
    printf("d)\tAmount of words with first letter A and last one z - %d\n\n",
           az_words(str));
    printf("e)\tLegth of biggst word - %d\n", max_words(str));
    printf("\tLength of smallest word - %d\n\n", min_words(str));
    printf("f)\tLegth of biggest space - %d\n", biggest_space(str));
    if(balance_words(str))
      printf("g)\tBrackets balanced out\n\n");
    else
      printf("g)\tBrackets are not balanced out\n\n");
    printf("h)\tAmount of () combintations - %d\n",
           straight_brackets_words(str));
  }
}

int main()
{
  get_string_params();
  return 0;
}
