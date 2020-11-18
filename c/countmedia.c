/*
Name:     countmedia.c
Purpose:  Counts the various media files we have on our home server.
Author:   J. W. Ireland.
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
#include <dirent.h>

/*
  The 'int' before the function (defined 'main') is to denote that the function
returns an integer value.
  The function 'main' is special.  It is there by necessity;
this is the only function that gets called automatically when the program is
executed.
  The parameter 'void' indicates that the function takes no arguments.
*/

int file_count = 0;
DIR * dirp;
struct dirent * entry;

int main(int argc,char* argv[]){
	/* int file_count = 0; */
	/* DIR * dirp; */
	/* struct dirent * entry; */
	dirp = opendir(argv[0]);
	while ((entry = readdir(dirp)) != NULL) {
	    if (entry -> d_type == DT_REG) { /* If the entry is a regular file */
	         file_count++;
	    }
	}
	closedir(dirp);
	printf("You have %s films in your Plex Media Server \n" , file_count);
	return 0;
}

/*
  The statement 'return 0;' has two effects.  It causes the main function to
terminate (thus ending the program), and it indicates that the 'main' function
returns a value of 0.
*/

