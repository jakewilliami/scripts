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


---

comment 1:

Somewhere I have some code (might be shell, awk or C, or some combination of those) which ranks multiple lines for degree of similarity, between 0.000 and 1.000. It looks for the longest common substring between any two targets, and then recursively does the same in what's left.

So "abcde"/"abcde" scores 1.000, "JOKER"/"JOE KERR" scores 0.769, "pit"/"bull" scores 0.000. Obviously, you can lowercase both strings before you start, equalise whitespace, etc.

I suspect the C does a few strings very fast, the awk does a lot of strings more slowly, and the shell organises the options and workload properly. I had to use this to match up 70,000 electrical substation names between two systems, so I know it works. It used to take out matches starting with the definites and impossibles, and then work towards the centre until it didn't like the vagueness level (I think that was an arg).

I will try to find this in my archives today. Can you compile C if you need to?

It should be easy to have it rank strings across all your files, and then tell you which is the best file to start with as a base. It could probably give you the consolidated list too.

Do you know if you have foreign words in the mix? I have something that checks my backups for incremental changes, and language pack names, French song titles etc. are an issue.


comment 2:


Posted 4 articles on PasteBin. https://pastebin.com/u/Paul_Pedant

Sorry it took so long. Post or DM me if you can't find it. There is a note on the algorithm, an awk method with a test package, a C program that just compares strings two at a time, and a ksh script that compares a file of string, two at a time, in all combinations.

This stuff was all written years back, for a 24MB machine, and it is pretty crass. What it needs is for the C code to read all the strings and than check each one against all the others, instead of running it in a loop in another script.

You may have an extra issue with your strings in five files. You don't want to pair things in the same file. For example, if file 1 has "Abba Hits Vol 1" and "Abba Hits Vol 2", you don't want to decide they are the same. But if file 4 has "Abba Greatest Hits", you probably want to pair that up even though is is less like either of the others.

When I did this, I had thousands of names for electrical substations and transmission lines between them, with inconsistent spelling, and I had to link them all up correctly. So I took out the almost-perfect matches, and discarded the can't-be-right matches first, and then kept taking the nearest out of what was left for as long as they looked plausible. I don't have that code, but it made an impossible job (just) possible.


comment; response to `tre-agrep`:

TRE agrep looks good, but it needs embedding in a smart script.

The issue is that you have to supply agrep with the patterns to match. So we will need to pick the data out of some of the files, to use as patterns for the other files, because we don't know what we are searching for until we find some names.

First suggestion is to find which names occur in all 5 files, save that list, and cut them out of (copies of) all the five files. That should reduce the volume of fuzzy matches significantly.

Then find all the names which occur in 4 files. For each name, fuzzy search in the "other file" for that name (using the -k option in case a name contains special characters, and maybe the -w option). You might need to experiment with the approximation settings to get the right values. You need to trim out the names you accept so they don't match again somewhere, which would be ambiguous.

Repeat that for names that occur exactly in 3 files, searching the other 2 for each name.

Then the same for names in 2 files, searching what's left of the 3 others.

You don't need to search for the remaining names, because they would have already have been found if they were like a name from any of the other files.

That sounds like a day of fun. I would probably keep all the lists in awk, and put the reduced name lists out to workfiles, and run each agrep through an awk pipe. Keep all the pain in one place. Or I could use my own comparison algorithm inside the same awk. That would be slower in the matching, but it wouldn't start up hundreds of extra processes.

If you want to post your files on PasteBin or some such, I'm good to experiment with it. I'm going to install agrep anyway to see how it looks.
