#! /bin/ksh
#! Author: Paul Stillman. Copyright (2008) Pipe Dreams Ltd.

Usage () { expand -4 <<'[][]'

Usage:	SimFile [-d x] [-r] [-f] [-b] [-w] [-t nn]
		SimFile [-h] [-H]

[][]
}
Help () { Usage; expand -4 <<'[][]'
SimFile reports the similarity between every combination (two at a time)
of text lines read from standard input, on a scale of 0.000 to 1.000.
Blank and duplicate lines are omitted from the comparisons.
Each report line is e.g. "0.778|This line|That line"

Caution: n lines take 0.5 x n x (n - 1) comparisons.

Options:
-h	Usage statement.
-H	This Help page.
-d	Delimiter for data pairs in report. May need quoting. Default is "|".
-r	Rank: sorts output with best matches first. Default is unsorted.
-f	Folds lower-case letters into upper case.
-b	Ignores leading and trailing blanks (spaces and tabs)
	and treats other strings of blanks as equivalent.
-w	Ignores all blanks (space and tab characters); for
	example, `if ( a == b )' will compare equal to `if(a==b)'.
-t	Threshold: minimum similarity to be reported. Format of nn
	is a decimal number <= 1.000. Default is to report all lines.

See Also: Sim -H

[][]
}

#### Shell Variables.

Sim="./Sim"

#### Do a comparison between all unique non-empty elements.

function Rank {		#:: (dOpt, fOpt, bOpt, wOpt, tOpt) < strings

	typeset D="${1}" F="${2}" B="${3}" W="${4}" T="${5}"
	typeset X="$( awk '! /^[ \011]*$/' | sort | uniq )"
	typeset N=1 A LC; print - "${X}" | wc -l | read LC

	typeset NAWK='
BEGIN { D = "'"${D}"'"; }
$1 == 9.999 { A = substr ($0, 7); next; }
{ printf ("%5s%s%s%s%s\n", substr ($0, 1, 5), D, A, D, substr ($0, 7)); }
'
	while [[ N -lt LC ]]; do
		A="$( print - "${X}" | tail -n "+${N}" | head -n 1 )"
		print - "9.999 ${A}"
		N=$(( 1 + N ))
		print - "${X}" | tail -n "+${N}" |
			"${Sim}" ${F} ${B} ${W} -t "${T}" - "${A}"
	done | awk "${NAWK}"
}


#### Script Body Starts here.

	typeset dOpt="|" rOpt fOpt bOpt wOpt tOpt="-0.001"

	while [[ "${#}" -gt 0 ]]; do case "${1}" in
	(-h) Usage; exit 2;; (-H) Help; exit 2;;
	(-d)	shift; dOpt="${1:-|}"; [[ "${#}" -gt 0 ]] && shift 1;;
	(-r)	shift; rOpt=rOpt;;
	(-f)	shift; fOpt="-f";;
	(-b)	shift; bOpt="-b";;
	(-w)	shift; wOpt="-w";;
	(-t)	shift; tOpt="${1:--0.001}"; [[ "${#}" -gt 0 ]] && shift 1;;
	(*)		print -u2 - "Unknown option ${1}"; exit 1;;
	esac; done

	case "${rOpt}" in
	(rOpt)	Rank "${dOpt}" "${fOpt}" "${bOpt}" "${wOpt}" "${tOpt}" | sort -r;;
	(*)		Rank "${dOpt}" "${fOpt}" "${bOpt}" "${wOpt}" "${tOpt}";;
	esac