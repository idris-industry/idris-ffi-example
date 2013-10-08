module Main

%include C "testlib.h"
%link C "testlib.o"
foo : Int -> IO Int
foo x = mkForeign (FFun "foo" [FInt] FInt) x

main : IO ()
main = do x <- foo 42
          putStrLn ("foo 42 ---> " ++ show x)
