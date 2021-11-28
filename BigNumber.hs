module BigNumber (BigNumber (..),
scanner, output, somaBN, subBN, mulBN, divBN, safeDivBN, oneBN, zeroBN, fromBigNumber) where

-- Imports

import Data.Char
import Data.Maybe

{-
-> Constructores
  -> EmptyList : Representa quando a lista está vazia ou o fim da lista
  -> Negative BigNumber : Representa os números negativos. Tem o construtor Negative no ínicio seguido do número BigNumber
  -> BN Int BigNumber : Representa os números positivos. Int: valor inteiro do algarismo

-}
data BigNumber = EmptyList | Negative BigNumber | BN Int BigNumber deriving (Show)

{-

-> Scanner -> Estado: Feito
  -> Função que serve para transformar String em BigNumber
  -> scanner "" -> Caso de lista vazia
  -> scanner xs -> Chama uma função auxiliar que nos vai auxiliar

-> scannerHelper -> Estado: Feito
  -> Função auxiliar que tranforma String em BigNumber
  -> scannerHelper "" (BN x bn) -> Caso base: caso nao tenha nada na string
  -> scannerHelper (c: xs) a -> Caso recursivo: Transforma Char -> Int para cada algarismo

-> Teste #1 : scanner "123" = BN 3 (BN 2 (BN 1 EmptyList)) quando usado com "deriving Show"
-> Teste #2 : scanner "-123" = Negative (BN 3 (BN 2 (BN 1 EmptyList)))
-> Teste #3 : scanner "" = EmptyList

-}

scanner :: String -> BigNumber
scanner "" = EmptyList
scanner xs = scannerHelper xs EmptyList

scannerHelper :: String -> BigNumber -> BigNumber
scannerHelper "" (BN x bn) = (BN x bn)
scannerHelper (c: xs) a
        | c == '-' = Negative (scannerHelper xs a)
        | otherwise = scannerHelper xs (BN (ord c - ord '0') a)

{-

-> Output -> Estado: Feito
  -> Função que serve para transformar BigNumber em String
  -> output EmptyList -> Caso de Lista Vazia
  -> output (Negative bn) -> Caso do número negativo, chama a função auxiliar com o valor positivo
  -> output (BN a bn)  ->  Caso do número positivo, chama função auxiliar

-> outputHelper -> Estado: Feito
  -> Funçao auxiliar que transforma BigNumber em String
  -> outputHelper EmptyList str -> Caso base: Lista Vazia
  -> outputHelper (BN a bn) str -> Caso recursivo: Transforma Int -> Char para cada algarismo

-> Teste #1 : output (scanner "123") = "123"
-> Teste #2 : output (scanner "-123") = "-123"
-> Teste #3 : output (EmptyList) = ""

-}

output :: BigNumber -> String
output EmptyList = ""
output (Negative bn) = ('-' : outputHelper bn "")
output (BN a bn) = outputHelper (BN a bn) ""

outputHelper :: BigNumber -> String -> String
outputHelper EmptyList str = str
outputHelper (BN a bn) str = outputHelper bn (chr (a + ord '0') : str)

{-
-> somaBN -> Estado: Feito
  -> Função que soma dois BigNumbers. Reduz sempre a uma das formas mais simples: soma de dois números positivos ou subtração de dois númeors positivos
  -> somaBN EmptyList EmptyList
    -> Caso Lista Acabou
  -> somaBN EmptyList (BN x bn)
  -> somaBN (BN x bn) EmptyList
    -> Caso Lista Acabou e Número Positivo: Dá o número positivo
  -> somaBN (Negative bnx) (Negative bny)
    -> Caso Dois Números Negativos: É o simétrico da soma dos valores absolutos
  -> somaBN (Negative bnx) (BN y bny)
  -> somaBN (BN x bnx) (Negative bny)
    -> Caso Número Negativo e Número Positivo: É a subtração entre os dois números
  -> somaBN (BN x bnx) (BN y bny)
    -> Caso Dois Números Positivos: Soma algarismo a algarismo

-> Teste #1:  output (somaBN (scanner "123") (scanner "123")) = "246"
-> Teste #2:  output (somaBN (scanner "123") (scanner "12")) = "135"
-> Teste #3:  output (somaBN (scanner "123") (scanner "987")) = "1110"
-> Teste #4:  output (somaBN (scanner "-123") (scanner "-987")) = "-1110"
-> Teste #5:  output (somaBN (scanner "-123") (scanner "22")) = "-101"
-> Teste #6:  output (somaBN (scanner "-123") (scanner "222")) = "99"
-> Teste #7:  output (somaBN (scanner "146") (scanner "-242")) = "-96"
-> Teste #8:  output (somaBN (scanner "146") (scanner "-24")) = "122"
-> Teste #10:  output (somaBN (scanner "123") (scanner "-123")) = "0"

-}

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN EmptyList EmptyList = EmptyList
somaBN EmptyList (BN x bn) = removeZeros $ somaBN (BN x bn) EmptyList
somaBN (BN x bn) EmptyList = (BN x bn)
somaBN (Negative bnx) (Negative bny) = removeZeros $ Negative (somaBN bnx bny)
somaBN (Negative bnx) (BN y bny)
  | isGreaterBN bnx (BN y bny) = removeZeros $ Negative (subBN bnx (BN y bny))
  | otherwise = subBN (BN y bny) bnx
somaBN (BN x bnx) (Negative bny) = removeZeros $ somaBN (Negative bny) (BN x bnx)
somaBN (BN x bnx) (BN y bny)
  | ((x + y) < 10 && (x + y) >= 0) = removeZeros $ (BN (mod (x+y) 10) (somaBN bnx bny))
  | (x + y) >= 10 = removeZeros $ (BN (mod (x+y) 10) (somaBN (somaBN bnx bny) (BN (div (x+y) 10) EmptyList)))
  | otherwise = EmptyList


{-
-> SubBN -> Estado: Feito
  -> Função que subtrai dois BigNumbers. Reduz sempre a uma das formas mais simples: soma de dois números positivos ou subtração de dois númeors positivos
  -> subBN EmptyList EmptyList
    -> Caso Listas Acabaram
  -> subBN EmptyList (BN x bn)
    -> Caso Lista Acabou e Número Positivo: Simétrico do valor positivo
  -> subBN (BN x bn) EmptyList
    -> Caso Número Positivo e Lista Acabou: Valor positivo
  -> subBN (Negative bnx) (Negative bny)
    -> Caso Dois Números Negativo: Soma do primeiro número com o simétrico do segundo número
  -> subBN (Negative bnx) (BN y bny)
    -> Caso Número Negativo e Número Positivo: Simétrico da soma dos valores absolutos
  -> subBN (BN x bnx) (Negative bny)
    -> Caso Número Positivo e Número Negativo: Soma dos valores absolutos
  -> subBN (BN x bnx) (BN y bny)
    -> Caso Dois Números Positivos: Subtração algarismo a algarismo

-- Teste #1: output (subBN (scanner "255") (scanner "125")) = "130"
-- Teste #2: output (subBN (scanner "100") (scanner "14")) = "86"
-- Teste #3: output (subBN (scanner "5") (scanner "70")) = "-65"
-- Teste #4: output (subBN (scanner "-100") (scanner "-124")) = "24"
-- Teste #5: output (subBN (scanner "-124") (scanner "-76")) = "-48"
-- Teste #6: output (subBN (scanner "100") (scanner "-14")) = "114"
-- Teste #7: output (subBN (scanner "-100") (scanner "14")) = "-114"

-}


subBN :: BigNumber -> BigNumber -> BigNumber
subBN EmptyList EmptyList = EmptyList
subBN EmptyList (BN x bn) = removeZeros $ Negative (BN x bn)
subBN (BN x bn) EmptyList = removeZeros $ (BN x bn)
subBN (Negative bnx) (Negative bny) = removeZeros $ somaBN (Negative bnx) bny
subBN (Negative bnx) (BN y bny) = removeZeros $ Negative (somaBN bnx (BN y bny))
subBN (BN x bnx) (Negative bny) = removeZeros $ somaBN (BN x bnx) bny
subBN (BN x bnx) (BN y bny)
  | isEqualBN (BN x bnx) (BN y bny) = (BN 0 EmptyList)
  | isGreaterBN (BN x bnx) (BN y bny) && x < y = removeZeros $ (BN (mod (x-y) 10) (subBN (subBN bnx (BN 1 EmptyList)) bny))
  | isGreaterBN (BN x bnx) (BN y bny) && x >= y = removeZeros $ (BN (x-y) (subBN bnx bny))
  | otherwise = removeZeros $ Negative (subBN (BN y bny) (BN x bnx))



{-
-> mulBN -> Estado: Feito
  -> Funcão que multiplica 2 BigNumbers.
     Reduz-se a multiplicação de 2 BigNumbers a uma série consecutiva de somas, sendo que cada argumento
     é calculado a partir da multiplicação de apenas um algorismo de um dos BigNumbers pelo outro BigNumber.
     De forma a efetuar estes cálculos, utilizam-se 2 funções auxiliares: mulBNAux e mulBNHelper.
     -> mulBN EmptyList EmptyList = EmptyList
      -> Caso de 2 EmptyList's
     -> mulBN (BN x bnx) EmptyList = removeZeros $ BN x bnx
      -> Caso de multiplicação de BigNumber por EmptyList: BigNumber inicial
     -> mulBN EmptyList (BN x bnx) = removeZeros $ BN x bnx
      -> Caso de multiplicação de EmptyList por BigNumber: BigNumber inicial
     -> mulBN (Negative bnx) (Negative bny) = mulBN bnx bny
      -> Caso de multiplicação de 2 BigNumbers negativos: Multiplicação do valor absoluto dos 2 BigNumbers
     -> mulBN (Negative bnx) (BN y bny) = Negative (mulBN bnx (BN y bny))
      -> Caso de multiplicação de BigNumber negativo por positvo: Simétrico da multiplicação do valor absoluto dos 2 BigNumbers
     -> mulBN (BN x bnx) (Negative bny) = Negative (mulBN (BN x bnx) bny)
      -> Caso de multiplicação de BigNumber positivo por negativo: Simétrico da multiplicação do valor absoluto dos 2 BigNumbers
     -> mulBN (BN x bnx) (BN y bny) = removeZeros $ mulBNAux (BN x bnx) 0 (BN y bny)
      -> Caso de multiplicação de 2 BigNumbers positivos: Multiplicação efetuada por mulBNAux com i = 0

  -> mulBNAux
     Recebe os 2 BigNumbers necessários para a multiplicação e um valor Int que representa a posição do algorismo
     do primeiro BigNumber, visto que, antes de se efetuar a soma, é necessário efetuar multiplicações por 10 dependentes
     da posição do algorismo.
     Esta função realiza a soma, chamando a mulBNHelper para calcular um dos argumentos e chamando-se a si própria, de forma recursiva,
     para os argumentos seguintes.
     -> mulBNAux EmptyList i (BN y bny) = EmptyList
      -> Caso final
     -> mulBNAux (BN x bnx) i (BN y bny) = somaBN (mulBNHelper x i (BN y bny) 0) (mulBNAux bnx (i+1) (BN y bny))
      -> Caso 2 BigNumbers positivos com i >= 0: Soma de 2 elementos: resultado de mulBNHelper com carry inicial de 0
                                                 e chamada recursiva com i incrementado por 1

  -> mulBNHelper
     Recebe 3 Int's, que representam, sucessivamente, um digito de um BigNumber, a sua posição relativamente a esse BigNumber,
     e o carry entre multiplicações. Além disso, recebe o segundo BigNumber da multiplicação passado para mulBN.
     Esta função calcula cada valor individual para a soma realizada em mulBNAux, chamando-se a si própria de forma recursiva,
     até ter terminado a multiplicação do digito individual passado para a função pelo BigNumber.
     -> mulBNHelper _ _ EmptyList c
       -> Caso final: EmptyList se não existir carry ou um BigNumber com o valor de carry
     -> mulBNHelper x i (BN y bny) c
      -> Caso normal: 2 possibilidades
        -> Se i > 0, ou seja, a posição de x em relação ao BigNumber inicial de mulBN não é a primeira:
           Adicionam-se 0 ao inicio do BigNumber, o equivalente à multiplicação do BigNumber por 10, chamando-se a função recursivamente
           diminuindo o i até atingit o valor de 0.
        -> Se i = 0: Realiza-se a multiplicação de x por cada digito do BigNumber recebido, não se alterando o i,
                     e calculando o carry necessário para cada chamada recursiva necessária.

    mulBN
-- Teste #2: output (mulBN (scanner "1") (scanner "0")) = "0"
-- Teste #3: output (mulBN (scanner "12") (scanner "0")) = "0"
-- Teste #4: output (mulBN (scanner "123") (scanner "123")) = "15129"
-- Teste #5: output (mulBN (scanner "-123") (scanner "123")) = "-15129"
-- Teste #6: output (mulBN (scanner "-999") (scanner "-999")) = "998001"

    mulBNHelper
-- Teste #1: output (somaBN (mulBNHelper 5 0 (scanner "123") 0) (mulBNHelper 4 1 (scanner "123") 0)) = "5535"
-}

mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN EmptyList EmptyList = EmptyList
mulBN (BN x bnx) EmptyList = removeZeros $ BN x bnx
mulBN EmptyList (BN x bnx) = removeZeros $ BN x bnx
mulBN (Negative bnx) (Negative bny) = mulBN bnx bny
mulBN (Negative bnx) (BN y bny) = Negative (mulBN bnx (BN y bny))
mulBN (BN x bnx) (Negative bny) = Negative (mulBN (BN x bnx) bny)
mulBN (BN x bnx) (BN y bny) = removeZeros $ mulBNAux (BN x bnx) 0 (BN y bny)

mulBNAux :: BigNumber -> Int -> BigNumber -> BigNumber
mulBNAux EmptyList i (BN y bny) = EmptyList
mulBNAux (BN x bnx) i (BN y bny) = somaBN (mulBNHelper x i (BN y bny) 0) (mulBNAux bnx (i+1) (BN y bny))

mulBNHelper :: Int -> Int -> BigNumber -> Int -> BigNumber
mulBNHelper _ _ EmptyList c
  | c == 0 = EmptyList
  | otherwise = (BN c EmptyList)
mulBNHelper x i (BN y bny) c
  | (i > 0) = (BN 0 (mulBNHelper x (i-1) (BN y bny) c))
  | otherwise = (BN ((mod (x*y) 10) + c) (mulBNHelper x i bny (div (x*y) 10)))


-- divBN (scanner "123456") (scanner "12") = (BN 8 (BN 8 (BN 2 (BN 0 (BN 1 EmptyList)))),BN 0 EmptyList)
-- outputDiv (divBN (scanner "123456") (scanner "12")) = ("10288","0")
-- outputDiv (divBN (scanner "123456") (scanner "13")) = ("9496","8")
-- outputDiv (divBN (scanner "12") (scanner "16")) = ("0","12")

{-
  divBN -> Estado: Feito
    -> Função que divide dois BigNumbers Positivos e retorna (quociente, resto)
    -> divBN _ (BN 0 EmptyList) 
      -> Caso da divisão por zero: retorna um erro
    -> divBN (BN x bnx) (BN y bny)
      -> Caso De dois números positivos: Chama uma função auxiliar divBNHelper

  -> divBNHelper -> Estado: Feito
    -> divBNHelper EmptyList (BN y bny) (BN q bnq) (BN r bnr)
      -> Caso Base: Retirar algarismos do dividendo ate ficar acabar o número, caso o número acabe acabar a divisao
    -> divBNHelper (BN x bnx) (BN y bny) (BN q bnq) (BN r bnr)
      -> Caso recursivo: Retirar algarismo do dividendo, somar com o resto * 10 e dividir pelo divisor, dando assim o quociente e o resto


  -> divBNinitial -> Estado: Feito
    -> Faz a divisão de dois BigNumber simples. Por exemplo, 43/7 = (6, 1) fazendo o calculo algarismo a algarismo.
    -> divBNinitial (BN x bnx) (BN i bni) (BN y bny)
      -> Caso Dois Números Positivos: procura a multiplicação mais alta antes do número pedido
        -> Por exemplo, para encontrar o 43:  7*1 = 7, 7*2 = 14,  .... ,  7*6=42 -> Guarda o numero 6 e calcua o resto
    
    -> Teste #1: divBNinitial (scanner "7") (scanner "1") (scanner "43") = (BN 6 EmptyList,BN 1 EmptyList)
    -> Teste #2: divBNinitial (scanner "12") (scanner "1") (scanner "115") = (BN 9 EmptyList,BN 7 EmptyList)
-}
divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN _ (BN 0 EmptyList) = error "Division 0"
divBN (BN x bnx) (BN y bny) = divBNHelper (flipBN (BN x bnx)) (BN y bny) (BN 0 EmptyList) (BN 0 EmptyList)


divBNHelper :: BigNumber -> BigNumber -> BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBNHelper EmptyList (BN y bny) (BN q bnq) (BN r bnr)
  | isGreaterBN (BN y bny) (BN r bnr)  = ((BN q bnq), (BN r bnr))
  | otherwise = ( removeZeros $ somaBN (exp10BN (BN q bnq) 1) quoc, removeZeros rest)
  where (quoc, rest) = divBNinitial (BN y bny) oneBN (BN r bnr)
divBNHelper (BN x bnx) (BN y bny) (BN q bnq) (BN r bnr) =
  divBNHelper bnx (BN y bny) (removeZeros $ somaBN quoc (exp10BN (BN q bnq) 1)) (removeZeros $ somaBN (exp10BN rest 1) (BN x EmptyList))
  where (quoc, rest) = divBNinitial (BN y bny) oneBN (BN r bnr)


divBNinitial :: BigNumber -> BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBNinitial (BN x bnx) (BN i bni) (BN y bny)
  | isEqualBN multi (BN y bny) = ((BN i bni), subBN (BN y bny) multi)
  | isGreaterBN multi (BN y bny) = ((subBN (BN i bni) oneBN), (subBN (BN y bny) (mulBN (BN x bnx) (subBN (BN i bni) oneBN))))
  | otherwise = divBNinitial (BN x bnx) (somaBN (BN i bni) oneBN) (BN y bny)
  where multi = mulBN (BN x bnx) (BN i bni)


-- safeDivBN (com deriving Show)

{-

-> safeDivBN -> Estado: Feito
  -> Divisao que retorna o valor do divisão ou nada caso divida por zero


  -> Teste #1: safeDivBN (scanner "17") (scanner "5") = Just (BN 3 EmptyList,BN 2 EmptyList)
  -> Teste #2: safeDivBN (scanner "17") (scanner "0") = Nothing
-}

safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN (BN x bnx) (BN 0 EmptyList) = Nothing
safeDivBN (BN x bnx) (BN y bny) = Just $ divBN (BN x bnx) (BN y bny)



----------------------
-- Helper Functions --
----------------------


-- zeroBN -> Representação do valor 0 em BigNumber

zeroBN :: BigNumber
zeroBN = (BN 0 EmptyList)

-- oneBN -> Representação do valor 1 em BigNumber

oneBN :: BigNumber
oneBN = (BN 1 EmptyList)



exp10BN :: BigNumber -> Int -> BigNumber
exp10BN (BN x bnx) 0 = (BN x bnx)
exp10BN (Negative bn) i = Negative (exp10BN bn i)
exp10BN (BN x bnx) i = exp10BN (BN 0 (BN x bnx)) (i-1)

outputDiv :: (BigNumber, BigNumber) -> (String, String)
outputDiv ((BN x bnx), (BN y bny)) = (output (BN x bnx), output (BN y bny))

-- isEqualBN

-- Teste #1: isEqualBN (scanner "123") (scanner "123") = True
-- Teste #2: isEqualBN (scanner "-123") (scanner "-123") = True
-- Teste #3: isEqualBN (scanner "") (scanner "") = True
-- Teste #4: isEqualBN (scanner "123") (scanner "-123") = False
-- Teste #5: isEqualBN (scanner "123") (scanner "12") = False

isEqualBN :: BigNumber -> BigNumber -> Bool
-- Caso - Lista acabou
isEqualBN EmptyList EmptyList = True
-- Caso - Dois numeros negativos
isEqualBN (Negative bnx) (Negative bny) = isEqualBN bnx bny
-- Caso - Dois numeros positivos
isEqualBN (BN x bnx) (BN y bny) = (x == y) && (isEqualBN bnx bny)
-- Resto - Falso
isEqualBN _ _ = False


-- isGreaterBN -> Estado: Feito
--    Return true if first argument is greater than the second, false otherwise

-- Teste #1: isGreaterBN (scanner "123") (scanner "123") = False
-- Teste #2: isGreaterBN (scanner "123") (scanner "12") = True
-- Teste #3: isGreaterBN (scanner "12") (scanner "123") = False
-- Teste #4: isGreaterBN (scanner "") (scanner "") = False
-- Teste #5: isGreaterBN (scanner "-123") (scanner "123") = False
-- Teste #6: isGreaterBN (scanner "123") (scanner "-123") = True
-- Teste #7: isGreaterBN (scanner "123") (scanner "") = True
-- Teste #8: isGreaterBN (scanner "") (scanner "123") = False
-- Teste #9: isGreaterBN (scanner "255") (scanner "225") = True

isGreaterBN :: BigNumber -> BigNumber -> Bool
-- Caso - Lista acabou
isGreaterBN EmptyList EmptyList = False
-- Caso - Numero e Lista que acabou
isGreaterBN EmptyList bn = False
isGreaterBN bn EmptyList = True
-- Caso - Numero Negativo e Numero Positivo
isGreaterBN (Negative bnx) (BN x bny) = False
isGreaterBN (BN x bnx) (Negative bny) = True
-- Caso - Numero Negativo e Numero Negativo
isGreaterBN (Negative bnx) (Negative bny) = isGreaterBN bny bnx
-- Caso - Numero Positivo e Numero Positivo
isGreaterBN (BN x bnx) (BN y bny)
  | ((isEqualBN bnx EmptyList) && (isEqualBN bny EmptyList) || (isEqualBN bnx bny)) && (x > y) = True
  | ((isEqualBN bnx EmptyList) && (isEqualBN bny EmptyList) || (isEqualBN bnx bny)) && (x < y) = False
  | otherwise = isGreaterBN bnx bny

-- lengthBN -> Estado: Feito
--    Return the length of the BigNumber

-- Teste #1: lengthBN (scanner "-123") = "3"
-- Teste #2: lengthBN (scanner "1123") = "4"
-- Teste #3: lengthBN (scanner "0") = "1"
-- Teste #4: lengthBN (scanner "") = "0"

lengthBN :: BigNumber -> Int
lengthBN EmptyList = 0
lengthBN (Negative bn) = lengthBNHelper bn 0
lengthBN (BN x bn) = lengthBNHelper (BN x bn) 0


lengthBNHelper :: BigNumber -> Int -> Int
lengthBNHelper EmptyList n = n
lengthBNHelper (BN v bn) n = lengthBNHelper bn (n+1)

-- flipBN -> Estado: Feito

-- Teste #1: flipBN(scanner "123") = BN 1 (BN 2 (BN 3 EmptyList))
-- Teste #2: flipBN(scanner "-123") = Negative (BN 1 (BN 2 (BN 3 EmptyList)))

flipBN :: BigNumber -> BigNumber
flipBN EmptyList = EmptyList
flipBN (Negative bn) = (Negative (flipBNHelper bn EmptyList))
flipBN (BN n bn) = flipBNHelper (BN n bn) EmptyList

flipBNHelper :: BigNumber -> BigNumber -> BigNumber
flipBNHelper EmptyList bn = bn
flipBNHelper (BN x bnx) EmptyList = flipBNHelper bnx (BN x EmptyList)
flipBNHelper (BN x bnx) (BN y EmptyList) = flipBNHelper bnx (BN x (BN y EmptyList))
flipBNHelper (BN x bnx) (BN y bny) = flipBNHelper bnx (BN x (BN y bny))

-- removeZeros -> Estado:
-- Return BigNumber without unnecessary zeros

-- Teste #1: output (removeZeros (scanner "0")) = "0"
-- Teste #2 output (removeZeros (scanner "0123")) = "123"
-- Teste #3 output (removeZeros (scanner "000123")) = "123"

removeZeros :: BigNumber -> BigNumber
removeZeros EmptyList = EmptyList
removeZeros (Negative bn) = Negative (removeZeros bn)
removeZeros (BN x bnx)
  | (lengthBN (BN x bnx) > 1) = flipBN (removeZerosAux (flipBN (BN x bnx)))
  | otherwise = (BN x bnx)

removeZerosAux :: BigNumber -> BigNumber
removeZerosAux EmptyList = EmptyList
removeZerosAux (BN x bnx)
  | (x == 0 && lengthBN(BN x bnx) > 1) = removeZerosAux bnx
  | otherwise = BN x bnx




fromBigNumber :: BigNumber -> Int
fromBigNumber (BN x bnx) = fromBigNumberHelper (flipBN (BN x bnx))

fromBigNumberHelper :: BigNumber -> Int
fromBigNumberHelper (BN x EmptyList) = x
fromBigNumberHelper (BN x bnx) = x * (10 ^ (lengthBN bnx)) + fromBigNumberHelper bnx
