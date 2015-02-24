module Main

%include C "testlib.h"
%link C "testlib.o"

not_null : IO String
not_null = foreign FFI_C "not_null" (IO String)

null : IO String
null = foreign FFI_C "null" (IO String)

main : IO ()
main = do x <- not_null
          putStrLn x
          y <- null
          putStrLn y
