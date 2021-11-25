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


fibRecBN :: BigNumber -> BigNumber
fibRecBN (BN 0 EmptyList) = (BN 0 EmptyList)
fibRecBN (BN 1 EmptyList) = (BN 1 EmptyList)
fibRecBN (BN x bnx) =  somaBN (fibRecBN $ subBN (BN x bnx) oneBN) (fibRecBN $ subBN (BN x bnx) (BN 2 EmptyList))



fibListaBN :: BigNumber -> BigNumber
fibListaBN (BN x bnx) = fibListaAuxBN (BN x bnx) zeroBN oneBN

fibListaAuxBN :: BigNumber -> BigNumber -> BigNumber -> BigNumber
fibListaAuxBN (BN 0 EmptyList) (BN x bnx) _ = (BN x bnx)
fibListaAuxBN (BN n bnn) (BN x bnx) (BN y bny) = 
  fibListaAuxBN (subBN (BN n bnn) oneBN) (BN y bny) (somaBN (BN x bnx) (BN y bny))

fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN (BN x bnx) = fib !! fromBigNumber (BN x bnx)
  where fib = zeroBN : oneBN : zipWith(somaBN) fib (tail fib)