//Emanuel Brici
//4/16/2015

#include <stdio.h>
#include <stdlib.h>

extern int stringgt(char* s1,char* s2);

int main(int argc, char* argv[]) {
  char s1[32];
  char s2[32];
  //first string
  printf("Enter first string:");
  fgets(s1,32,stdin);
  //second string
  printf("Enter second string:");
  fgets(s2,32,stdin);
  //run asm program	
  int i = stringgt(s1,s2);
	
  if (i == 0){
    printf("FALSE \n");
  }
  else{
    printf("TRUE \n" );
  }
  return 0;
}
