
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n - 1) + fibRec (n - 2)

fibLista :: (Integral a) => a -> a
fibLista n = fibListaAux n 0 1

fibListaAux 0 x y = x
fibListaAux n x y = fibListaAux (n-1) (y) (x+y)


fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = fib !! fromIntegral n
  where fib = 0 : 1 : zipWith(+) fib (tail fib)
