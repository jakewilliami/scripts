import AOC

main = interact $ f . map read

f (x:xs) = if (2020 - x) `elem` xs then x * (2020 - x) else f xs

-- f l = head [i*j*k | i<-l, j<-l, let z=2020-i-j, z `elem` l]

--------------------

-- main :: IO ()
-- main = do
    -- inputs <- lines <$> readFile "1.input" 
    -- let nums = map read inputs :: [Int]
    -- let answer = head [i*j | i <- nums, j <- nums, i + j == 2020]
    -- print answer
