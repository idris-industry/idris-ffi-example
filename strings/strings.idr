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

-- Dependent magic
interpFTy' : FTy -> Type
interpFTy' FString = Maybe String
interpFTy' t = interpFTy t

safeForeignTy : List FTy -> FTy -> Type
safeForeignTy Nil rt = IO (interpFTy' rt)
safeForeignTy (t::ts) rt = interpFTy t -> safeForeignTy ts rt

mkSafeString : (args : List FTy) -> (rt : FTy) -> ForeignTy args rt -> safeForeignTy args rt
mkSafeString [] rt f = f' rt f where
  total
  f' : (rt : FTy) -> (World -> PrimIO (interpFTy rt)) -> IO (interpFTy' rt)
  f' FString f = safeString (liftPrimIO f) -- safeString : IO String -> IO (Maybe String)
  -- Unfortunately it seems I have to specify the other cases in order to 
  -- convince the typechecker that the argument isn't FString.
  f' (FIntT _) f = liftPrimIO f
  f' (FAny _) f = liftPrimIO f
  f' FFloat f = liftPrimIO f
  f' FPtr f = liftPrimIO f
  f' FUnit f = liftPrimIO f
  f' (FFunction _ _) f = liftPrimIO f
mkSafeString (t::ts) (rt) f = \x : interpFTy t => mkSafeString ts rt (f x)

mkSafe : String -> (args : List FTy) -> (rt : FTy) -> safeForeignTy args rt
mkSafe fun args rt = mkSafeString args rt f where
  f' : Foreign (ForeignTy args rt)
  f' = FFun fun args rt
  f : ForeignTy args rt
  f = mkForeignPrim f'

safe_not_null' : IO (Maybe String)
safe_not_null' = mkSafe "not_null" [] FString

safe_null' : IO (Maybe String)
safe_null' = mkSafe "null" [] FString

main : IO ()
main = do x <- not_null
          checkNull x
          y <- null
          checkNull y
          safe_not_null >>= print
          safe_null >>= print
          safe_not_null' >>= print
          safe_null' >>= print
