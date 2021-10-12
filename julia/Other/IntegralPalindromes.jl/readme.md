# IntegralPalindromes

This problem came about when I saw the [fourth Euler problem](https://projecteuler.net/problem=4):
> A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
> Find the largest palindrome made from the product of two 3-digit numbers.

The solution was obvious to me: get all combinations of two 3-digit numbers, sort them by their product, and choose the first one which is a palindrome.  (And checking for a palindrome is relatively trivial).  

However, the problem became more complex when I realised this solution was not feasible for finding the largest palindrome made from m n-digit numbers.  I.e., when m is larger than about 6 or 7, my solution falls apart somewhat, as it has to load _all_ of those combinations into memory in order to sort them&mdash;and even so, we will be taking one of the first values we find, as surely it doesn't take _that_ long to find a solution.

Hence, I began work on constructing an iterator to find the solution to this problem more generally.  At time of writing, I have just completed the iterator for the case where we don't yet need one!  The case where m = 2.  However, now that we have this basis, we can hopefully extend this iterator so that the solution is efficient for the general case.
