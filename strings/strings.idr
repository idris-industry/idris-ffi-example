module Main

-- NOTE: This will segfault in idris 0.9.9.2!
-- It has been fixed in the latest version on git
-- https://github.com/idris-lang/Idris-dev/commit/0d5c5b650bd406411ad8da2f21f68d4a69f14a3e

%include C "testlib.h"
%link C "testlib.o"

not_null : IO String
not_null = mkForeign (FFun "not_null" [] FString)

null : IO String
null = mkForeign (FFun "null" [] FString)

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
safe_not_null = safeString (mkForeign (FFun "not_null" [] FString))

safe_null : IO (Maybe String)
safe_null = safeString (mkForeign (FFun "null" [] FString))

main : IO ()
main = do x <- not_null
          checkNull x
          y <- null
          checkNull y
          safe_not_null >>= print
          safe_null >>= print
