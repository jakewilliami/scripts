#! /bin/bash

LC_ALL="C"

#### Ranking pairs of strings for similarity.

function Ranking {

	local AWK='''
BEGIN { FS = "/"; Db = 0; }
#- Given pair of substrings, return length of common initial string.
function nSimil (ta, tb, Local, n, am, bm) {
	am = length (ta); bm = length (tb);
	for (n = 1; n <= am  &&  n <= bm; n++)
		if (substr (ta, n, 1) != substr (tb, n, 1)) break;
	return (n - 1);
}
#- Given pair of strings, return longest exact match included.
function vSimil (ta, tb, Local, s, k, n, na, nb, a, b) {
	if (Db) printf ("/%s/%s/\n", ta, tb);
	n = 0; for (a = 1; length (ta) > n; a++) {
		s = tb; for (b = 0; length (ta) > n  &&  length (s) > n; b += k) {
			if ((k = index (s, substr (ta, 1, n + 1))) == 0) break;
			n += 1 + nSimil( substr (ta, n + 2), substr (s, k + n + 1));
			na = a; nb = b + k; s = substr (s, k + 1);
		}
		ta = substr (ta, 2);
	}
	if (Db) printf ("%.4d%.4d%.4d\n", n, na, nb);
	return (sprintf ("%.4d%.4d%.4d", n, na, nb));
}
#- Given a pair of outer strings, recursively hunt for matches.
function rSimil (ta, tb, Local, tn, q, n, a, b) {
	q = vSimil( ta, tb); if (0 + substr (q, 1, 4) == 0) return (tn);
	n = 0 + substr (q, 1, 4); tn += n;
	a = 0 + substr (q, 5, 4); b = 0 + substr (q, 9, 4);
	if (a > 1  ||  b > 1)
		tn += rSimil( substr (ta, 1, a - 1), substr (tb, 1, b - 1));
	if (a + n < length (ta)  ||  b + n < length (tb))
		tn += rSimil( substr (ta, a + n), substr (tb, b + n));
	return (tn);
}
#- Action a comparison.
function Similar (a, b, Local, n, m) {
	n = (a == b) ? length (a) : rSimil( a, b);
	m = length (a) + length (b);
	return ((m > 0) ? (n + n) / m : 1.00);
}
#- Process the input strings.
{ printf ("%.3f%s%s%s%s\n", Similar( $1, $2), FS, $1, FS, $2); }
'''
	awk -f <( echo "${AWK}" )
}

#### Script Body Starts Here.

	{
		echo 'Similar/Similar'
		echo 'r/barry'
		echo '/'
		echo 'One/'
		echo '/Two'
		echo 'supersciliously/pernicious'
		echo 'JOE KERR/JOKER'
		echo 'TOE/TO'
		echo 'TO/TWO'
		echo 'TWO/TOE'
		echo "Many of my friends have social tenderness/\
Man of my fiends have socialist tendencies"
	} | Ranking