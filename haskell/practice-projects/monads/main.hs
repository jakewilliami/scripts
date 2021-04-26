-- we want to create a kind of eval function

-- new datatype for the kinds of expressions we are going to be evaluating
-- this new data type is defined for 'Expr' (the name of the type)
-- it can be two things; an integer value (Val Int) OR it can be the division of two sub-expressions
-- this gives the new datatype Expr two constructors in our datatype
-- to reiterate: we are declaring a new datatype called 'Expr', and it's got two new constructors; one called 'Val' which takes an integer (Int) parameter, and one called 'Div', which takes two sub-expressions as parameters
data Expr = Val Int | Div Expr Expr

-- examples of values of this data type:
-----------------------------------------------------
--      Maths          |      Haskell
------------------------------------------------------
--      1              |      Val 1
--      6 ÷ 2          |      Div (Val 6) (Val 2)
------------------------------------------------------

-- now we want to write a programme to evaluate these expressions
-- we are going to write an evaluator ('eval') as a function that takes an expression as input ('Expr') and it returns an integer value ('Int')
eval :: Expr -> Int
-- we are going to need two cases here
-- we are going to need a case for values:
eval (Val n) = n
-- and then we have a case for division
-- this is recursive because it evaluates each input and divides them
-- BUT this programme may crash, if y is zero, so we have to define a safe division for this and use it here
eval (Div x y) = eval x ÷ eval y

-- we define a function called 'safediv' and it is going to take a couple of integers and return maybe an integer
-- 'Maybe' is the way we can deal with things that can possibly fail in Haskell
safediv :: Int -> Int -> Maybe Int
-- to actually define safediv, we take two integers (n and m), and need to check if m is zero (in which case something would go wrong
-- if m is not zero, then we give back 'Just' the division of the two; Just is another constructor in the 'Maybe' type (which only has two constructors: Nothing (which represents things that have gone wrong), and Just, where things have gone fine
safediv (n m) = if m == 0 then
                    Nothing
                else
                    Just (n ÷ m)

-- so now we need to change up our eval function
-- this safeeval won't crash!
safeeval :: Expr -> Maybe Int
-- must return a Maybe Int, so need to add Just!
safeeval (Val n) = Just n
-- We actually need to eval x (which may fail), eval y (which may fail) and then evaluate the expression (which may fail)
-- we need to do a case analysis on the result of evaluating x
-- this could be one of two things: it could be Nothing, and Just
-- In the first case, if evaluation of x fails, we should sensibly say that the evaluation of the whole thing fails, so we should just return nothing.  In the second case, we then need to evaluate the second parameter, y, so we do *another* case analysis, this time on y
-- Of course, if we fail evaluating y, we return nothing again.  However, if y succeeds, we then need to evaluate the actual division expression, using our safediv function!
safeeval (Div x y) = case eval x of
                         Nothing -> Nothing
                         Just n -> case eval y of
                             Nothing -> Nothing
                             Just m -> safediv n m

-- Now we have a working evaluator!
-- This programme works and never crashes... BUT, it is quite verbose, due to all of this management of failure
-- We can look at this programme and think: how can we make this programme better, and more like the simple original programme, but working well?
-- Well, we can observe a common pattern.  We do a case analysis on the result evaluating x, and a case analysis on the result evaluating y.  You see the pattern.
-- Commonly in computing, if you see the same things multiple times, you extract them out, and have them as a definition, so that you avoid repeated code!  And that's what we can do here.

-- Abstracting the above pattern, we see the following:
-- case m of
--     Nothing -> Nothing
--     Just x -> func x
-- this is the pattern
-- to help define this in an abstract way, we want to define an operator
-- We define some maybe value m feeding into (or "in sequence with") some function f (so the operator we are defining is » [was ⤜]) and perform a case analysis on m, doing the above
m » f = case m of
             Nothing -> Nothing
             Just x -> f x

-- Now we can use this definition to make our programme simpler!

safeevalAbstr :: Expr -> Maybe Int
-- this is a little side-definition, that says return of n is the same as Just of n
safeevalAbstr (Val n) = return n
-- the lambda symbol means it takes the result of eval 
safeevalAbstr (Div x y) = eval x » (λn ->
                          eval y » (λm ->
                          safediv n m))

-- This above programe is actually equivalent to the one we wrote above, but it's all been absstracted away now, which is quite nice!
-- However, we're still using this operator we defined, and this funny lambda notation.  Maybe I can make it even simpler to read.

safeevalMonad :: Expr -> Maybe Int
safeevalMonad (Val n) = return n
safeevalMonad (Div x y) = do n <- eval x
                             m <- eval y
                             savediv n m

-- All the failure management is being handled by the do notation
-- This is a Maybe Monad
-- This has two cases
--     return     ::  a -> Maybe a
--     return »=  ::  Maybe a -> (a -> Maybe b) -> Maybe b
-- A monad is simply some kind of type constructor
