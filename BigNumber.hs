
-- Imports

import Data.Char


-- Constructor

-- Ideia a pensar: como fazer números negativos
-- Pensei assim: data BigNumber = EmptyList | Negative BigNumber | BN Int BigNumber e usava Negative na primeira/ultima posiçao
-- Ou entao usava-se na primeira /ultima posiçao um numero negativo
-- Como quiseres

data BigNumber = EmptyList | Negative BigNumber | BN Int BigNumber deriving (Show)

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
-- Teste #4:  output (somaBN (scanner "-123") (scanner "-123")) = "-246"
-- Teste #5:  output (somaBN (scanner "-123") (scanner "22")) = "-101"
-- Teste #6: output (somaBN (scanner "123") (scanner "-24")) = "099"


-- TO DO: Negative + BN

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN EmptyList EmptyList = EmptyList
somaBN EmptyList (BN x bn) = (BN x (somaBN EmptyList bn))
somaBN (BN x bn) EmptyList = (BN x (somaBN bn EmptyList))
somaBN (Negative bnx) (Negative bny) = Negative (somaBN bnx bny)
somaBN (Negative bnx) (BN y bny) = Negative (subBN bnx (BN y bny))
somaBN (BN x bnx) (Negative bny) = subBN (BN x bnx) bny
somaBN (BN x bnx) (BN y bny)
  | ((x + y) < 10 && (x + y) > 0) = (BN (mod (x+y) 10) (somaBN bnx bny))                                      -- Soma de dois números positivos com carry
  | (x + y) >= 10 = (BN (mod (x+y) 10) (somaBN (somaBN bnx bny) (BN (div (x+y) 10) EmptyList)))               -- Soma de dois números positivos sem carry
  | otherwise = EmptyList


-- subBn
-- Teste #1: output (subBN (scanner "255") (scanner "125")) = "130"
-- Teste #2: output (subBN (scanner "32") (scanner "14")) = "18"

-- NOT WORKING: output (subBN (scanner "5") (scanner "70"))

subBN :: BigNumber -> BigNumber -> BigNumber
subBN EmptyList EmptyList = EmptyList
subBN EmptyList (BN x bn) = (BN x (subBN EmptyList bn)) -- "" - "123" = "-123" ou "123"
subBN (BN x bn) EmptyList = (BN x (subBN bn EmptyList))
subBN (Negative bnx) (Negative bny) = somaBN (Negative bnx) bny
subBN (Negative bnx) (BN y bny) = Negative (somaBN bnx (BN y bny))
subBN (BN x bnx) (Negative bny) = somaBN (BN x bnx) bny
subBN (BN x bnx) (BN y bny)
  | (isEqual bnx EmptyList) == True = Negative (subBN (BN y bny) (BN x bnx))
  | (x >= y) = (BN (x-y) (subBN bnx bny))
  | (x < y) = (BN (mod (x-y) 10) (subBN (subBN bnx (BN 1 EmptyList)) bny))
  | otherwise = EmptyList

-- | ((x < y) && ((isEqual bnx EmptyList) == True)) = Negative (subBN (BN y bny) (BN x bnx))
-- | ((x >= y) && ((isEqual bnx EmptyList) == True)) = Negative (sub)

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


-- /=

isEqual :: BigNumber -> BigNumber -> Bool
isEqual EmptyList EmptyList = True
isEqual (BN x bnx) (BN y bny) = (x == y) && (isEqual bnx bny)
isEqual (Negative bnx) (Negative bny) = isEqual bnx bny
isEqual _ _ = False
