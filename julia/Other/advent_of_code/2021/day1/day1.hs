main :: IO ()
main = do
    eachLine <- lines <$> readFile "data1.txt"
    let nums = map read eachLine :: [Int]
    
    let part1Solution = part1 nums
    putStrLn $ "Part 1: " ++ show part1Solution

    let part2Solution = part2 nums
    putStrLn $ "Part 2: " ++ show part2Solution


withLaggedPairs :: Int -> (a -> a -> b) -> [a] -> [b]
withLaggedPairs n f xs = zipWith f xs (drop n xs)

laggedPairs :: Int -> [a] -> [(a,a)]
laggedPairs n = withLaggedPairs n (,)

countTrue p = length . filter p

countIncreases n = countTrue (uncurry (<)) . laggedPairs n


part1 :: [Int] -> Int
-- part1 nums = head [ | i <- nums, j <- nums, i + j == 2020]
part1 = countIncreases 1

part2 :: [Int] -> Int
part2 = countIncreases 3
