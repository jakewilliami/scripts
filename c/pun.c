/*
Name:     pun.c
Purpose:  Prints a bad pun.
Author:   J. W. Ireland, directed by K. N. King
*/

/*
  'include' is one of many things we call 'directives'.  This particular
directive tells the compiler to include whatever follows it (in this case,
include 'stdio').  This is necessary because, unlike other programming languages,
C does not have a built-in method of reading and writing, so we need to call
the 'standard input/output' "header" from C's standard library.
  Directives, by default, only span one line.  Hence, there is no need for a
succeeding semicolon to tell the computer when the line is over.
*/

#include <stdio.h>
#include <math.h>

/*
  The 'int' before the function (defined 'main') is to denote that the function
returns an integer value.
  The function 'main' is special.  It is there by necessity;
this is the only function that gets called automatically when the program is
executed.
  The parameter 'void' indicates that the function takes no arguments.
*/

int main(void)
{
 int height;
 float profit, volume;

 height = 8;
 profit = 2150.48f;

 volume = pow(10, (height * profit * 0.5));

 printf("To C, or not to C: that is the question.\n");
 printf("volume = ", volume, "\n");

 return 0;
}

// int main() {
//     double base, exp, result;
//     printf("Enter a base number: ");
//     scanf("%lf", &base);
//     printf("Enter an exponent: ");
//     scanf("%lf", &exp);
//
//     // calculates the power
//     result = pow(base, exp);
//
//     printf("%.1lf^%.1lf = %.2lf", base, exp, result);
//     return 0;
// }

/*
  The statement 'return 0;' has two effects.  It causes the main function to
terminate (thus ending the program), and it indicates that the 'main' function
returns a value of 0.
*/
