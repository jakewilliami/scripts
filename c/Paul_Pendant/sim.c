/*
 * Sim.c: Fuzzy string comparison,
 * Author: Paul Stillman 1998-2008.
 */

static char *Usage =

"\nUsage: Sim [-h] [-H] [-f] [-b] [-w] [-t nn] [-] [string...]"
"\n";

static char *Help [] = {

"Sim reports the similarity of strings on a scale of 0.000 to 1.000.",
"Ranking takes account of successively shorter sub-strings that may",
"be separated by non-matching parts. The final ranking is the count",
"of pairs of ordered characters, divided by the total strings length.",
"There are no patterns or wildcards recognised by the matching.",
"",
"One or more strings may be defined as command line arguments.",
"Strings are also read (one per line) from standard input.",
"Every such string is compared against every argument string.",
"If there is more than one command-line string, each ranking report",
"includes a number 00-99 to indicate the argument to which it relates.",
"",
"Sample output with one argument and two strings:",
"0.543 First String",
"0.712 Second String",
"",
"Sample output with two arguments and two strings:",
"0.543 00 First String",
"0.712 01 First String",
"0.373 00 Second String",
"0.962 01 Second String",
"",
"Options:",
"",
"-h\tUsage statement.",
"-H\tThis Help page.",
"-f\tFolds lower-case letters into upper case.",
"-b\tIgnores leading and trailing blanks (spaces and tabs)",
"\tand treats other strings of blanks as equivalent.",
"-w\tIgnores all blanks (space and tab characters); for",
"\texample, `if ( a == b )' will compare equal to `if(a==b)'.",
"-t nn\tThreshold: minimum similarity to be reported. Format of nn",
"\tis a decimal number <= 1.000. Default is to report all lines.",
"-\tEnd options: useful where argument string starts with -.",
"",
};

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define __XPG4_CHAR_CLASS__ 1
#include <ctype.h>

#define  PUBLIC
#define  LOCAL  static
#define  EMPTY
#define  esac break

LOCAL    FILE *OUT = NULL;
LOCAL    FILE *ERR = NULL;

#define  SZ_BUF 4000

#define  NUL  '\0'
#define  NL   '\n'
#define  DOT  '.'
#define  TAB  '\t'
#define  BLK  ' '

/*----- Local constants. */

LOCAL  char *Prog   = "Sim";
LOCAL  int    fOpt  = 0;
LOCAL  int    bOpt  = 0;
LOCAL  int    wOpt  = 0;
LOCAL  double tOpt	= -0.001;

/*----- Return the longest matching string within two inputs. */

LOCAL int LMS (char **ax, char **bx, char *ap, char *ae, char *bp, char *be)

{
int m = 0; char *am = ap, *bm = bp;
char *aq, *bq, *ar, *br, *af = ae, *bf = be;

	for (aq = ap; aq < af; aq++) {
		for (bq = bp; bq < bf; bq++) {
			for (ar = aq, br = bq; ar < af && br < bf && *ar == *br;
					ar++, br++) EMPTY;
			if (m < ar - aq) {
				m = ar - aq; am = aq; bm = bq; af = ae - m; bf = be - m;
	}	}	}
	*ax = am; *bx = bm; return (m);
}


/*----- Recurse through the entire partitioning. */

LOCAL int RPS (char *ap, char *ae, char *bp, char *be)

{
int n; char *aq, *bq;

	if ((n = LMS (& aq, & bq, ap, ae, bp, be)) > 0) {
		if (aq + n < ae && bq + n < be) n += RPS (aq + n, ae, bq + n, be);
		if (ap     < aq && bp     < bq) n += RPS (ap,     aq, bp,     bq);
	}
	return (n);
}


/*----- Copy a string dropping all or multiple whitespace. ----- */

LOCAL char *wDrop (char *t, char *p)

{
char *z = t; char *e; for (e = p; *e; e++) EMPTY;

	while (p < e && isspace (*p)) p++;
	while (p < e && isspace (*(e - 1))) e--;
	while (p < e)
		if (! isspace (*p)) *t++ = *p++;
		else { if (! wOpt) *t++ = BLK; while (p < e && isspace (*p)) p++; }
	*t++ = NUL; return (z);
}


/*----- Evaluate similarity of two strings. ----- */

LOCAL double Similar (char *ap, char *bp)

{
int n, n1, n2, t; char *ae, *be;
char *p, *q;
char aX [SZ_BUF], bX [SZ_BUF];

	if (bOpt || wOpt) {
		ap = wDrop (aX, ap); if (fOpt) for (q = ap; *q; q++) *q = toupper (*q);
		bp = wDrop (bX, bp); if (fOpt) for (q = bp; *q; q++) *q = toupper (*q);
	} else if (fOpt) {
		p = ap; ap = q = aX; while (*q++ = toupper (*p++)) EMPTY;
		p = bp; bp = q = bX; while (*q++ = toupper (*p++)) EMPTY;
	}
	for (ae = ap; *ae; ae++) EMPTY; for (be = bp; *be; be++) EMPTY;
	n1 = RPS (ap, ae, bp, be); n2 = RPS (bp, be, ap, ae);
	n = (n1 > n2) ? n1 : n2; t = (ae - ap) + (be - bp);
	return ((double) (n + n) / (double) t);
}


/*----- Compare each argument against every input string. */

LOCAL void Comparer (char **p, char **e)

{
int  a, m;
char **q;
char *z; char Buf [SZ_BUF];
double s;

	while (fgets (Buf, sizeof (Buf), stdin) != NULL) {
		for (z = Buf; *z; z++) EMPTY; if (Buf < z && *(--z) == NL) *z = NUL;
		if (p + 1 < e) {
			for (a = 0, q = p; q < e; a++, q++) {
				s = Similar (*q, Buf);
				if (s >= tOpt) printf ("%5.3f %.2d %s\n", s, a, Buf);
			}
		} else if (p < e) {
			s = Similar (*p, Buf);
			if (s >= tOpt) printf ("%5.3f %s\n", s, Buf);
		}
	}
}


/*----- Argument parsing. */

PUBLIC int main (int argc, char **argv)

{
char *s, *e;

	OUT = stdout;
	ERR = stderr;

	argc--; argv++;

	while (argc > 0) {
		if (**argv != '-') break;
		if (**argv == '-' && *((*argv) + 1) == NUL) { argc--; argv++; break; }

		switch (*(*argv + 1)) {
		case 'h':
			fprintf (OUT, "%s\n", Usage); return (2);
		esac;

		case 'H':  { char **hs, **he;
			fprintf (OUT, "%s\n", Usage);
			for (hs = Help, he = Help + sizeof (Help) / sizeof (*Help);
				hs < he; hs++) fprintf (OUT, "%s\n", *hs);
			return (2);
		} esac;

		case 'f': fOpt = 1; argc--; argv++; esac;
		case 'b': bOpt = 1; argc--; argv++; esac;
		case 'w': wOpt = 1; argc--; argv++; esac;

		case 't':
			if (argc < 2) { fprintf (ERR, "%s\n", Usage); return (2); }
			tOpt = atof (*(argv + 1));
			argc -= 2; argv += 2;
		esac;

		default:  {
			fprintf (OUT, "%s\n", Usage); return (2);
		} esac;

		} /* END switch (*(*argv + 1)) */
	} /* END while (argc > 0) */

	Comparer (argv, argv + argc);

	return (0);
}

/* Build with
	HP:   cc -D_HPUX_SOURCE -Aa -o Sim Sim.c -lm 
	DEC:  cc -o Sim Sim.c -lm 
 */