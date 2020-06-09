/*
 * Sim.c: Fuzzy string comparison,
 * Author: Paul Stillman 1998-2020.
 */

static char *Usage =

"\nUsage: Sim [-h] [-H] [-f] [-p] [-b] [-w] [-t nn] [-|file] [-|file]"
"\n";

static char *Help [] = {

"Sim reports the similarity of strings on a scale of 0.000 to 1.000.",
"Ranking takes account of successively shorter sub-strings that may",
"be separated by non-matching parts. The final ranking is the count",
"of pairs of ordered characters, divided by the total strings length.",
"There are no patterns or wildcards recognised by the matching.",
"Output is sorted by Rank, highest first.",
"",
"If two file names are given (one of which may be - for stdin),",
"each line in each file is matched against the other file.",
"If one name is given (or - or no name for stdin), then every line",
"in that file is matched against every other line.",
"",
"Sample output:",
"1.000|Similar|Similar|",
"0.811|socialist tendencies|social tenderness|",
"0.800|TWO|TO|",
"0.800|TOE|TO|",
"0.769|JOKER|JOE KERR|",
"",
"Options:",
"",
"-h\tUsage statement.",
"-H\tThis Help page.",
"-f\tFolds lower-case letters into upper case.",
"-p\tIgnores all punctuation.",
"-b\tIgnores leading and trailing blanks (spaces and tabs)",
"\tand treats other strings of blanks as equivalent.",
"-w\tIgnores all blanks (space and tab characters); for",
"\texample, `if ( a == b )' will compare equal to `if(a==b)'.",
"-t nn\tThreshold: minimum similarity to be reported. Format of nn",
"\tis a decimal number <= 1.000. Default is to report all lines.",
"",
};

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define  PUBLIC
#define  LOCAL  static
#define  EMPTY
#define  esac break

LOCAL    FILE *OUT = NULL;
LOCAL    FILE *ERR = NULL;

#define  SZ_BUF 8000

#define  NUL  '\0'
#define  NL   '\n'
#define  DOT  '.'
#define  TAB  '\t'
#define  BLK  ' '

////.. Local constants.

LOCAL  char *Prog   = "Sim";
LOCAL  int    fOpt  = 0;
LOCAL  int    pOpt  = 0;
LOCAL  int    bOpt  = 0;
LOCAL  int    wOpt  = 0;
LOCAL  double tOpt	= -0.001;

////.. Storage for text lines.

#define INIT_TEXT (16 * 1024)
#define INCR_TEXT (32 * 1024)

struct File_t {		//.. Each file gets its own list of texts.

	char	*fName;		//.. Points back to argv.
	int		fd;

	char	*Text;		//.. malloc: Complete text from input file.
	size_t  nText;		//.. Size of text read.
	size_t  nSize;		//.. Size of allocation.

	char	**Rows;		//.. malloc: Array of pointers to rows.
	size_t  nRows;
};
typedef struct File_t File_t;

LOCAL File_t File_Group [2] = { 0 };

LOCAL File_t *pFileA = & File_Group[0];
LOCAL File_t *pFileB = & File_Group[1];

////.. Storage for results.

struct Out_t {

	char	Rank[8];	//.. As a string.
	char	*A;
	char	*B;
};
typedef struct Out_t Out_t;

struct Results_t {

	size_t	nMax;
	size_t  nUse;
	Out_t	*pOut;
};
typedef struct Results_t Results_t;

LOCAL Results_t Results = { 0 };

LOCAL Results_t *Out = & Results;


////.. Load a file into a File_t list.

LOCAL int fileLoader (File_t *pF, char *fn)

{
struct stat Stat;
ssize_t Init = INIT_TEXT;
ssize_t Incr = INCR_TEXT;
ssize_t rc;

	if (! strcmp (fn, "-")) {
		pF->fName = "stdin"; pF->fd = 0;
	} else {
		pF->fName = fn; pF->fd = open (fn, O_RDONLY);
	}
	if (pF->fd < 0) { perror (pF->fName); exit (1); }
	
	//.. For a regular file, we can find the available size.
	//.. If stdin is a pipe, we have to guess and extend.
	if (! fstat (pF->fd, & Stat) && S_ISREG (Stat.st_mode)) {
		Init = Stat.st_size + 100; Incr = 1024;
	}
	while (1) {
		if (pF->nSize - pF->nText < 80) {
			pF->nSize = (pF->nSize == 0) ? (Init) : (pF->nSize + Incr);
			pF->Text = realloc ((void*) pF->Text, pF->nSize);
		}
		rc = read (pF->fd, (void *) pF->Text + pF->nText,
			pF->nSize - pF->nText - 4);
		if (rc > 0) pF->nText += rc; else break;
	}
	if (pF->fd > 0) close (pF->fd);
	return (0);
}

////.. Index the rows in a file.

LOCAL int fileIndex (File_t *pF)

{
char *p, *q, *r, *e;
size_t nRow = 0;

	p = pF->Text; e = p + pF->nText;

	if (*(e - 1) != NL) {
		*e++ = NL;
		printf ("Last line needs newline\n");
	}
	*e = NUL;

	//.. Count the rows in the data.
	for (q = p; q < e; q++) if (*q == NL) ++nRow;

	pF->Rows = malloc ((nRow + 2) * sizeof (pF->Rows));

	//.. Make each input line a null-terminated string, and keep its address.
	for (q = p; q < e; q = r) {
		for (r = q; r < e; r++) {
			if (*r == NL) {
				*(pF->Rows + pF->nRows++) = q;
				*r++ = NUL; break;
			}
		}
	}
}

////.. Return the longest matching string within two inputs.

LOCAL int strMatch (char **ax, char **bx, char *ap, char *ae, char *bp, char *be)

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

////.. Recurse through the entire partitioning.

LOCAL int strPart (char *ap, char *ae, char *bp, char *be)

{
int n; char *aq, *bq;

	//.. Partition at the longest matching string.
	if ((n = strMatch (& aq, & bq, ap, ae, bp, be)) > 0) {
		//.. Repeat on the right-hand remnant.
		if (aq + n < ae && bq + n < be) n += strPart (aq + n, ae, bq + n, be);
		//.. Repeat on the left-hand remnant.
		if (ap     < aq && bp     < bq) n += strPart (ap,     aq, bp,     bq);
	}
	return (n);
}

////.. Copy a string, discarding all or multiple whitespace.

LOCAL inline void wDrop (char *t, char *p)

{
char *e; for (e = p; *e; e++) EMPTY;

	while (p < e && isspace (*p)) p++;
	while (p < e && isspace (*(e - 1))) e--;
	while (p < e)
		if (! isspace (*p)) *t++ = *p++;
		else { if (! wOpt) *t++ = BLK; while (p < e && isspace (*p)) p++; }
	*t++ = NUL;
}

////.. Discard punctuation from a string in-situ.

LOCAL inline void pDrop (char *tx)

{
char *p, *q;

	for (p = tx, q = p; *p; p++) if (! ispunct (*p)) *q++ = *p;
	*q++ = NUL;
}

////.. Fold lowercase into uppercase in situ.

LOCAL inline void cFold (char *tx)

{
char *p;

	for (p = tx; *p; p++) *p = toupper (*p);
}

////.. Evaluate similarity of two strings.

LOCAL double Similar (char *aStr, char *bStr)

{
char aX [SZ_BUF], bX [SZ_BUF];
int n, n1, n2, t;
char *ap = aX, *bp = bX;
char *ae, *be;

	//.. Copy original lines to buffers, applying options.
	if (bOpt || wOpt) { wDrop (ap, aStr); wDrop (bp, bStr); }
	if (pOpt) { pDrop (ap); pDrop (bp); }
	if (fOpt) { cFold (ap); cFold (bp); }
	//.. Make pointers to initial terminators.
	for (ae = ap; *ae; ae++) EMPTY; for (be = bp; *be; be++) EMPTY;

	//.. Test both ways round, and return the best outcome.
	n1 = strPart (ap, ae, bp, be); n2 = strPart (bp, be, ap, ae);
	n = (n1 > n2) ? n1 : n2; t = (ae - ap) + (be - bp);
	return ((double) (n + n) / (double) t);
}

////.. Compare n rows from one file, 2 at a time. (n-C-r)

LOCAL void doOneFile (File_t *fA)

{
char **pA, **eA;
char **pB;
double s;
Out_t *pOut;

	Out->nMax = (fA->nRows * fA->nRows / 2);
	Out->pOut = malloc (Out->nMax * sizeof (Out_t));

	for (pA = fA->Rows, eA = pA + fA->nRows; pA < eA; pA++) {
		for (pB = fA->Rows; pB < pA; pB++) {
			s = Similar (*pA, *pB);
			if (s >= tOpt) {
				pOut = Out->pOut + Out->nUse++;
				sprintf (pOut->Rank, "%5.3f", s);
				pOut->A = *pA; pOut->B = *pB;
			}
		}
	}
}

////.. Compare m rows from one file with n rows from another (m x n).

LOCAL void doTwoFiles (File_t *fA, File_t *fB)

{
char **pA, **eA;
char **pB, **eB;
double s;
Out_t *pOut;

	Out->nMax = (fA->nRows * fB->nRows);
	Out->pOut = malloc (Out->nMax * sizeof (Out_t));

	for (pA = fA->Rows, eA = pA + fA->nRows; pA < eA; pA++) {
		for (pB = fB->Rows, eB = pB + fB->nRows; pB < eB; pB++) {
			s = Similar (*pA, *pB);
			if (s >= tOpt) {
				pOut = Out->pOut + Out->nUse++;
				sprintf (pOut->Rank, "%5.3f", s);
				pOut->A = *pA; pOut->B = *pB;
			}
		}
	}
}

////.. Output result compare function, as per qsort interface.

LOCAL int compareOut (const void *p, const void *q)

{
Out_t *P = (Out_t *) p; Out_t *Q = (Out_t *) q;
int r;

	r = strcmp (Q->Rank, P->Rank); if (r) return (r);
	r = strcmp (P->A, Q->A); if (r) return (r);
	return (strcmp (P->B, Q->B));
}

////.. Process one or two files.

LOCAL int FileNames (char *fnA, char *fnB)

{
Out_t *p, *e;

	if (fnA != NULL) {
		fileLoader (pFileA, fnA);
		fileIndex (pFileA);
	}
	if (fnB != NULL) {
		fileLoader (pFileB, fnB);
		fileIndex (pFileB);
	}
	if (pFileA->nRows > 0 && pFileB->nRows == 0) doOneFile  (pFileA);
	if (pFileA->nRows > 0 && pFileB->nRows > 0)  doTwoFiles (pFileA, pFileB);

	qsort ((void *) Out->pOut, Out->nUse, sizeof (Out_t), compareOut);
	for (p = Out->pOut, e = p + Out->nUse; p < e; p++) {
		printf ("%s|%s|%s|\n", p->Rank, p->A, p->B);
	}
	return (0);
}

////.. Argument parsing.

PUBLIC int main (int argc, char **argv)

{
char *s, *e;

	OUT = stdout;
	ERR = stderr;

	argc--; argv++;

	while (argc > 0) {
		if (**argv != '-') break;
		if (**argv == '-' && *(*argv + 1) == NUL) break;

		switch (*(*argv + 1)) {
		case 'h':
			fprintf (ERR, "%s\n", Usage); return (2);
		esac;

		case 'H':  { char **hs, **he;
			fprintf (OUT, "%s\n", Usage);
			for (hs = Help, he = Help + sizeof (Help) / sizeof (*Help);
				hs < he; hs++) fprintf (OUT, "%s\n", *hs);
			return (2);
		} esac;

		case 'f': fOpt = 1; argc--; argv++; esac;
		case 'p': pOpt = 1; argc--; argv++; esac;
		case 'b': bOpt = 1; argc--; argv++; esac;
		case 'w': wOpt = 1; argc--; argv++; esac;

		case 't':
			if (argc < 2) { fprintf (ERR, "%s\n", Usage); return (2); }
			tOpt = atof (*(argv + 1));
			argc -= 2; argv += 2;
		esac;

		default:  {
			fprintf (ERR, "%s\n", Usage); return (2);
		} esac;

		} //.. END switch (*(*argv + 1))
	} //.. END while (argc > 0)

	if (argc == 0) return (FileNames ("-", NULL));
	if (argc == 1) return (FileNames (*(argv + 0), NULL));
	if (argc == 2) return (FileNames (*(argv + 0), *(argv + 1)));

	fprintf (ERR, "%s\n", Usage); return (2);
}

////.. Build with: cc -o Sim Sim.c -lm