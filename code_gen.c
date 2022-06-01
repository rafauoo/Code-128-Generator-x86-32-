#include "image.h"
#include "codes.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* write_code(const char* code, int length, int start_pixel, char* pImg);

char* extend_line(char* pImg, int line_number);

const char* widen_code(const char* code, int width)
{
  char* new_code;
  new_code = malloc(strlen(code) * width + 1);
  if (new_code == NULL)
    return NULL;
  for (int i = 0; i < strlen(code) * width; i++)
  {
    new_code[i] = code[i / width];
  }
  new_code[strlen(code) * width] = '\0';
  const char* ret_code = new_code;
  return ret_code;
}

unsigned int control_sum(const char* str) {
  int sum = 0;
  int sign = 0;
  for (int i = 0; str[i] != '\0'; i++)
  {
    sign = str[i] - 32;
    sign *= i + 1;
    sum += sign;
  }
  sum += 104;
  sum %= 103;
  return sum;
}

int main () {
  ImageInfo info;

  //#######################
  const char* str = "password"; // STRING THAT WILL BE CODED
  const int width = 2; // BASE WIDTH OF STRIP IN PIXELS
  int pixel = 60; // QUIET ZONE AT THE START IN PIXELS
  //########################

  pixel *= 3;

  ImageInfo* pInfo = &info;
  pInfo = readBmp("src/white.bmp");
  int length = strlen(str);
  int c_sum = control_sum(str);

  // WRITE START
  const char* code = widen_code(codes[104], width);
  pInfo->pImg = write_code(code, strlen(code), pixel, pInfo->pImg);
  pixel += 33 * width;

  // WRITE STRING
  for (int i = 0; str[i] != '\0'; i++)
  {
    code = widen_code(codes[(int)str[i] - 32], width);
    pInfo->pImg = write_code(code, strlen(code), pixel, pInfo->pImg);
    pixel += 33 * width;
  }

  // WRITE CHECKSUM
  code = widen_code(codes[c_sum], width);
  pInfo->pImg = write_code(code, strlen(code), pixel, pInfo->pImg);
  pixel += 33 * width;

  //  WRITE STOP
  code = widen_code(codes[108], width);
  pInfo->pImg = write_code(code, strlen(code), pixel, pInfo->pImg);
  pixel += 39 * width;

  if (pixel >= 2304) {
    printf("ERROR: Too long code!\n");
    return -1;
  }

  // EXTEND CODE
  for (int i = 0; i < 64; i++)
    pInfo->pImg = extend_line(pInfo->pImg, i);

  printf("%d %d\n", length, c_sum);
	saveBmp("Generated_Code/result.bmp", pInfo);
}
