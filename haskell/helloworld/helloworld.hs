-- https://riptutorial.com/haskell/example/898/hello--world-

main::IO() -- type dignature declaring the type of main to be input-output

-- main = putStrLn "Hello, World!" -- this is equivalent to below
main = do {
   putStrLn "Hello, World!" ;
   return ()
   }
