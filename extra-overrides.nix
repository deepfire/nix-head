##
## Override spec syntax:
##
# { pin ? false        :: Bool            ## Override the repo/commit from pins/${x}-src.json; see ./pin.sh
# , repo ? attr        :: String          ## When repository name != attribute name
# , chdir ? null       :: Filepath        ## When package's cabal file is in subdir of repository
# , revision ? (!pin)  :: Bool            ## Set to false to disable edited cabal file & revision
# , patch ? null       :: Maybe PatchSpec ## Argument to fetchpatch
# , jailbreak ? false  :: Bool
# , doHaddock ? true   :: Bool
# , doCheck ? true     :: Bool
# }

self: {
  # cabal-install        = { pin = true; repo = "cabal"; jailbreak = true; };
  # tar                  = { jailbreak = true; };
  # test-framework       = { jailbreak = true; };
}
