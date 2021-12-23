<<<<<<< HEAD:Haskell/Fib.hs
import BigNumber


-- fibRec
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n - 1) + fibRec (n - 2)

-- fibLista
fibLista :: (Integral a) => a -> a
fibLista n = fibListaAux n 0 1

fibListaAux 0 x y = x
fibListaAux n x y = fibListaAux (n-1) (y) (x+y)

-- fibListaInfinita
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = fib !! fromIntegral n
  where fib = 0 : 1 : zipWith(+) fib (tail fib)

-- fibRecBN
fibRecBN :: BigNumber -> BigNumber
fibRecBN (Negative bnx) = error "Negative number"
fibRecBN (BN 0 EmptyList) = (BN 0 EmptyList)
fibRecBN (BN 1 EmptyList) = (BN 1 EmptyList)
fibRecBN (BN x bnx) =  somaBN (fibRecBN $ subBN (BN x bnx) oneBN) (fibRecBN $ subBN (BN x bnx) (BN 2 EmptyList))

-- fibListaBN
fibListaBN :: BigNumber -> BigNumber
fibListaBN (Negative bnx) = error "Negative number"
fibListaBN (BN x bnx) = fibListaAuxBN (BN x bnx) zeroBN oneBN

fibListaAuxBN :: BigNumber -> BigNumber -> BigNumber -> BigNumber
fibListaAuxBN (BN 0 EmptyList) (BN x bnx) _ = (BN x bnx)
fibListaAuxBN (BN n bnn) (BN x bnx) (BN y bny) =
  fibListaAuxBN (subBN (BN n bnn) oneBN) (BN y bny) (somaBN (BN x bnx) (BN y bny))

-- fibListaInfinitaBN
fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN (Negative bnx) = error "Negative number"
fibListaInfinitaBN (BN x bnx) = fib !! fromBigNumber (BN x bnx)
  where fib = zeroBN : oneBN : zipWith(somaBN) fib (tail fib)
=======
import BigNumber


-- fibRec
-- Função recursiva simples para calculo de número de Fibonacci
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n - 1) + fibRec (n - 2)

-- fibLista
-- Função recursiva com armazenamento parcial de resultados anteriores
fibLista :: (Integral a) => a -> a
fibLista n = fibListaAux n 0 1

fibListaAux 0 x y = x
fibListaAux n x y = fibListaAux (n-1) (y) (x+y)

-- fibListaInfinita
-- Função com uso de lista infinita
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = fib !! fromIntegral n
  where fib = 0 : 1 : zipWith(+) fib (tail fib)

-- fibRecBN
-- Função recursiva simples para calculo de número de Fibonacci
fibRecBN :: BigNumber -> BigNumber
fibRecBN (Negative bnx) = error "Negative number"
fibRecBN (BN 0 EmptyList) = (BN 0 EmptyList)
fibRecBN (BN 1 EmptyList) = (BN 1 EmptyList)
fibRecBN (BN x bnx) =  somaBN (fibRecBN $ subBN (BN x bnx) oneBN) (fibRecBN $ subBN (BN x bnx) (BN 2 EmptyList))

-- fibListaBN
-- Função recursiva com armazenamento parcial de resultados anteriores
fibListaBN :: BigNumber -> BigNumber
fibListaBN (Negative bnx) = error "Negative number"
fibListaBN (BN x bnx) = fibListaAuxBN (BN x bnx) zeroBN oneBN

fibListaAuxBN :: BigNumber -> BigNumber -> BigNumber -> BigNumber
fibListaAuxBN (BN 0 EmptyList) (BN x bnx) _ = (BN x bnx)
fibListaAuxBN (BN n bnn) (BN x bnx) (BN y bny) =
  fibListaAuxBN (subBN (BN n bnn) oneBN) (BN y bny) (somaBN (BN x bnx) (BN y bny))

-- fibListaInfinitaBN
-- Função com uso de lista infinita
fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN (Negative bnx) = error "Negative number"
fibListaInfinitaBN (BN x bnx) = fib !! fromBigNumber (BN x bnx)
  where fib = zeroBN : oneBN : zipWith(somaBN) fib (tail fib)
>>>>>>> d114141eabbd15f630fe0ea94b30a03bf210b9ed:Fib.hs
