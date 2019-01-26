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
  cabal-install        = { pin = true; jailbreak = true; repo = "cabal"; chdir = "cabal-install"; scope = self: super: { Cabal = null; }; };
  exceptions           =             { jailbreak = true; };
  hackage-security     =             { jailbreak = true; doHaddock = false; };
  jailbreak-cabal      = { pin = true; };
  primitive            = { pin = true; jailbreak = true; };
  tagged               = { pin = true; };
  tar                  = { pin = true; };
  test-framework       =             { jailbreak = true; };
}
