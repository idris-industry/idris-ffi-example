module Main

%include C "testlib.h"
%link C "testlib.o"

not_null : IO String
not_null = mkForeign (FFun "not_null" [] FString)

null : IO String
null = mkForeign (FFun "null" [] FString)

main : IO ()
main = do x <- not_null
          putStrLn x
          y <- null
          putStrLn y
