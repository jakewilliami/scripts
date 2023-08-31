\ This is a comment!
\ And this is a function for a hello world programme
: HELLO_WORLD ." Hello, World!" CR ;
( -- )

\ CR is carriage return (new line)
\ You can also write strings like .( Hello, World!)

\ We now call the hello world function
HELLO_WORLD


\ =========================

\ This probe file contains some very basic Forth testing

\ Reference: the Forth book:
\ https://www.forth.com/wp-content/uploads/2018/01/Starting-FORTH.pdf
\ See also: Gforth manual:
\ https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/

\ =========================


\ We can print a character by its code
: ASTERISK 42 EMIT ;
( -- )

\ Print multiple stars in a loop
\ The limit of the loop is on the top of the stack:
: ASTERISKS 1 DO ASTERISK LOOP CR ; 
( n -- )
14 ASTERISKS

\ Note that functions/subroutines are compiles, and
\ LOOP is compile-time-only (not interpreted)

\ Do some arithmetic!

\ Add four to top of stack
: FOUR_MORE 4 + ;
( n -- n + 4 )

." 34 + 35 = " 31 FOUR_MORE 34 + . CR
." 60 × 7 = " 60 7 * . CR

\ Some stack operations:
\ SWAP     (n1 n2    -- n2 n1)        Reverses the top two stack items
\ DUP      (n        -- n n)          Duplicats the top stack item
\ OVER     (n1 n2    -- n1 n2 n1)     Makes a copy of the second item and pushes it on top
\ ROT      (n1 n2 n3 -- n2 n3 n1)     Rotates the third item to the top
\ DROP     (n        -- )             Discards the top stack item

: 2. . . ;
35 34 2DUP 2. SWAP ." (SWAP)-> " 2.

\ Note: 2DUP and OVER OVER are functionally equivalent
