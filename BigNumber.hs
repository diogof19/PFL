
type BigNumber = [Int]

scanner :: String -> BigNumber
--scanner str = map (read.pure::Char -> Int) str
scanner str = [ (read.pure::Char -> Int) n | n <- str]

output :: BigNumber -> String
--output num = concat [ show n | n <- num]
output num = concat (map show num)
