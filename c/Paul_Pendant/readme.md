These are some tools for Fuzzy Matching of strings, prompted by a Reddit post.

They are from about 25 years back, and look horrible, so I should rewrite them if I get time. Originally written for Solaris SunOS 1.10, for ksh and nawk, and in a hurry, and for a system with 24MB RAM. The inner algorithm was originally in BASIC on a Sinclair Spectrum.

The Algorithm

The algorithm is recursive, and works on a pair of strings. At every level, it finds the longest common substring, and then repeats on the substring before that match, and the substring after it.

For example, how similar are 'JOE KERR' and 'JOKER'? (Indentation means recursion level.)
The longest common string is 'KER'.
    The left sides are now 'JOE ' and 'JO', so we find 'JO'.
        The left sides are both empty, no common string.
        The right sides are 'E ' and '', no common string.
    The right sides are 'R' and '', no common string.

We score that as 0.769 similar: count 2 for each character matched, and divide by the total length of both strings. (5 + 5) / 13.

Reason for Ranking Value.

I want to rank on a range between 0 and 1, the same as we normally express probability. 0.0 means no characters in common, and 1.0 means identical strings. Why?

Consider comparing TO, TOE and TWO. They each match T and O. But TO/TOE and TO/TWO each have one mismatch letter, and TOE/TWO have two mismatched letters, which is "more wrong". So we want to take into account all letters in both words.

For identical strings like YES/YES, there are 3 matches and a total length of 6, so we need to count each match twice to get 1.000. What we are really counting down is the proportion of characters in both strings that don't match.

The code comes in three pieces:

(1) Similar.

This is a ksh + awk implementation to test the algorithm. It is very nasty code. The issue is that every substring has to be extracted explicitly for the recursion, and it returns multiple values as three integers within one string. (I also found a logic bug which has been in there for 25 years.)

It includes some test cases, and the output looks like this:

Paul--) ./Similar | more
1.000/Similar/Similar
0.333/r/barry
1.000//
0.000/One/
0.000//Two
0.640/supersciliously/pernicious
0.769/JOE KERR/JOKER
0.800/TOE/TO
0.800/TO/TWO
0.667/TWO/TOE
0.892/Many of my friends have social tenderness/Man of my fiends have socialist tendencies
Paul--) 

(2) Sim.c

This is an implementation in C, and compiles with: cc -o Sim Sim.c
It has a man page built in: ./Sim -H
It has some options (similar to diff) that affect white-space and upper/lower case comparisons.

It has a nasty interface. It will do a comparison between all members of one group of strings against another group, but one group goes in as args and the other on stdin, and it is very clunky to correlate the results.

It is fast, though. It does not need to extract substrings for the recursion. As soon as it gets a string it makes a pointer to the terminating null, and then it just recurses by passing in adjusted start/end pointers into the original string.

With more memory available, this should store all the strings in memory, and pair them up for the m x n combinations. As it stands now, this is done externally in the SimFile script.

(3) Simfile

This is a ksh script. It has a man page built in: ./SimFile -H
It just fixes things up so Sim.c is not so hard to use.
It takes most of the options that Sim.c has, and passes them in.

It reads a set of strings from stdin (which has to be a file, not a pipe).
It sends each string in turn to Sim.c as the primary string to match, and then all the other strings to compare it with. So the final results are a comparison of every string with every other.

It is slow for large sets of data, because of the n * m requirement, and it runs an external process for each input string. On a 430-line C source, it takes 8 seconds and makes 46,000 comparisons.