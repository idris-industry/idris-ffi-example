module Main

-- NOTE: This will segfault in idris 0.9.9.2!
-- It has been fixed in the latest version on git
-- https://github.com/idris-lang/Idris-dev/commit/0d5c5b650bd406411ad8da2f21f68d4a69f14a3e

%include C "testlib.h"
%link C "testlib.o"

constant : IO String
constant = foreign FFI_C "var_wrapper" (IO String)

not_null : IO String
not_null = foreign FFI_C "not_null" (IO String)

null : IO String
null = foreign FFI_C "null" (IO String)

checkNull : String -> IO ()
checkNull s = do isNull <- nullStr s
                 if isNull
                    then putStrLn "The string was null!"
                    else putStrLn "Everything is fine, string was not null"

safeString : IO String -> IO (Maybe String)
safeString s = do s' <- s
                  isNull <- nullStr s'
                  return (toMaybe (not isNull) s')

safe_not_null : IO (Maybe String)
safe_not_null = safeString (foreign FFI_C "not_null" (IO String))

safe_null : IO (Maybe String)
safe_null = safeString (foreign FFI_C "null" (IO String))

next : IO String
next = foreign FFI_C "next" (IO String)

main : IO ()
main = do constant >>= printLn
          x <- not_null
          checkNull x
          y <- null
          checkNull y
          safe_not_null >>= printLn
          safe_null >>= printLn
          next >>= printLn
          next >>= printLn
