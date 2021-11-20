
-- Imports

import Data.Char


-- Constructor

-- Ideia a pensar: como fazer números negativos
-- Pensei assim: data BigNumber = EmptyList | Negative | BN Int BigNumber e usava Negative na primeira/ultima posiçao
-- Ou entao usava-se na primeira /ultima posiçao um numero negativo
-- Como quiseres 

data BigNumber = EmptyList | BN Int BigNumber



-- Scanner -> Estado: Falta ver números negativos
-- Melhor usar na ordem inversa
--      Quando fizermos as operações, começamos pelo ultimo digito devido ao carry

-- Teste #1 : scanner "123" = BN 3 (BN 2 (BN 1 EmptyList)) quando usado com "deriving Show"


scanner :: String -> BigNumber
scanner "" = EmptyList
scanner xs = scannerHelper xs EmptyList

scannerHelper :: String -> BigNumber -> BigNumber
scannerHelper "" (BN x bn) = BN x bn
scannerHelper (c: xs) a = scannerHelper xs (BN (ord c - ord '0') a)


-- Output -> Estado: Falta ver números negativos

-- Teste #1 : output (scanner "123") = "123"

output :: BigNumber -> String
output EmptyList = ""
output (BN a bn) = outputHelper (BN a bn) ""

outputHelper :: BigNumber -> String -> String
outputHelper EmptyList str = str
outputHelper (BN a bn) str = outputHelper bn (chr (a + ord '0') : str)


-- SomaBN
-- Teste #1:  output (somaBN (scanner "123") (scanner "123")) = "246"
-- Teste #2:  output (somaBN (scanner "123") (scanner "12")) = "135"
-- Teste #3:  output (somaBN (scanner "123") (scanner "987")) = "0:::" --------- Ovbiamente errado

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN EmptyList EmptyList = EmptyList                                          -- Alterar , acho que nao vai ser necessario
somaBN EmptyList (BN x bn) = (BN x (somaBN EmptyList bn))
somaBN (BN x bn) EmptyList = (BN x (somaBN bn EmptyList))
somaBN (BN x bnx) (BN y bny) 
  | ((x + y) < 10 && (x + y) > 0) = (BN (mod (x+y) 10) (somaBN bnx bny))                        -- Soma de dois números positivos com carry 
  | (x + y) >= 10 = (BN (x+y) (somaBN (carry bnx (mod (x+y) 10)) bny))                   -- Soma de dois números positivos sem carry 
  | otherwise = EmptyList




----------------------
-- Helper Functions --
----------------------

-- carry -> Estado: Falta para números negativos 
-- Podiamos ter usado a propria funçao SomaBN
-- Serve para tratar dos carries, decidi fazer em funçao separada mas se quiseres ver de outra maneira estou livre
-- Porque o int e não apenas +1? No caso de multiplicaçoes: 7*7 = 49 em que 4 de carry e 9 era o valor que ficava

-- Teste #1: output (carry (scanner "123") 3) = "126"
-- Teste #2: output (carry (scanner "123") 9) = "132"

carry :: BigNumber -> Int -> BigNumber
carry EmptyList n = (BN n EmptyList)
carry (BN x bn) n
        | (x + n) >= 10 = BN (mod (x+n) 10) (carry bn (div (x+n) 10))
        | otherwise = BN (x+n) bn


