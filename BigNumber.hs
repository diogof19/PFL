
-- Imports

import Data.Char


-- Constructor

-- Ideia a pensar: como fazer números negativos
-- Pensei assim: data BigNumber = EmptyList | Negative BigNumber | BN Int BigNumber e usava Negative na primeira/ultima posiçao
-- Ou entao usava-se na primeira /ultima posiçao um numero negativo
-- Como quiseres 

data BigNumber = EmptyList | Negative BigNumber | BN Int BigNumber deriving Show

-- Scanner -> Estado: Feito
-- Melhor usar na ordem inversa
--      Quando fizermos as operações, começamos pelo ultimo digito devido ao carry

-- Teste #1 : scanner "123" = BN 3 (BN 2 (BN 1 EmptyList)) quando usado com "deriving Show"
-- Teste #2 : scanner "-123" = Negative (BN 3 (BN 2 (BN 1 EmptyList)))

scanner :: String -> BigNumber
scanner "" = EmptyList
scanner xs = scannerHelper xs EmptyList

scannerHelper :: String -> BigNumber -> BigNumber
scannerHelper "" (BN x bn) = BN x bn
scannerHelper (c: xs) a
        | c == '-' = Negative (scannerHelper xs a)
        | otherwise = scannerHelper xs (BN (ord c - ord '0') a)

-- Output -> Estado: Feito

-- Teste #1 : output (scanner "123") = "123"
-- Teste #2 : output (scanner "-123") = "-123"

output :: BigNumber -> String
output EmptyList = ""
output (Negative bn) = ('-' : outputHelper bn "")
output (BN a bn) = outputHelper (BN a bn) ""

outputHelper :: BigNumber -> String -> String
outputHelper EmptyList str = str
outputHelper (BN a bn) str = outputHelper bn (chr (a + ord '0') : str)


-- SomaBN
-- Teste #1:  output (somaBN (scanner "123") (scanner "123")) = "246"
-- Teste #2:  output (somaBN (scanner "123") (scanner "12")) = "135"
-- Teste #3:  output (somaBN (scanner "123") (scanner "987")) = "1110"

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN EmptyList EmptyList = EmptyList
somaBN EmptyList (BN x bn) = (BN x (somaBN EmptyList bn))
somaBN (BN x bn) EmptyList = (BN x (somaBN bn EmptyList))
somaBN (BN x bnx) (BN y bny) 
  | ((x + y) < 10 && (x + y) > 0) = (BN (mod (x+y) 10) (somaBN bnx bny))                                      -- Soma de dois números positivos com carry 
  | (x + y) >= 10 = (BN (mod (x+y) 10) (somaBN (somaBN bnx bny) (BN (div (x+y) 10) EmptyList)))               -- Soma de dois números positivos sem carry 
  | otherwise = EmptyList


----------------------
-- Helper Functions --
----------------------

-- absBN -> Estado: Feito
--      Gives the absolute number of BigNumber

-- Teste #1: output(absBN(scanner("123"))) = "123"
-- Teste #2: output(absBN(scanner("-123"))) = "123"

absBN :: BigNumber -> BigNumber
absBN EmptyList = EmptyList
absBN (Negative bn) = bn
absBN bn = bn


-- isNegativeBN -> Estado: Feito
--       Return True if it is Negative, false otherwise


-- Teste #1: isNegativeBN(scanner("-123")) = True
-- Teste #2: isNegativeBN(scanner("123")) = False
-- Teste #3: isNegativeBN(EmptyList) = False

isNegativeBN :: BigNumber -> Bool
isNegativeBN (Negative bn) = True
isNegativeBN _ = False
