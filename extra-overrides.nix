##
## Override spec syntax:
##
# { pin ? false         :: Bool            ## Override the repo/commit from pins/${x}-src.json; see ./pin.sh
# , just ? null         :: Deriv           ## Use a derivation value directly
# , repo ? attr         :: String          ## When repository name != attribute name
# , chdir ? null        :: Filepath        ## When package's cabal file is in subdir of repository
# , dontRevise ? pin    :: Bool            ## Disable edited cabal file & revision
# , patch ? null        :: Maybe PatchSpec ## Argument to fetchpatch
# , jailbreak ? false   :: Bool
# , doHaddock ? true    :: Bool
# , doCheck ? true      :: Bool
# , scope ? null        :: Maybe (HaskPkgs -> HaskPkgs -> HaskPkgs)
# , headPatch ? true    :: Bool            ## Suppress head.hackage's patch
# , headCabal ? true    :: Bool            ## Suppress head.hackage's cabal file
# , extAttrs ? {}       :: Map AttrName (Map AttrName Any) ## Extend arbitrary haskell derivation attribute of type attrset
# , extLists ? {}       :: Map AttrName [Any]              ## Extend arbitrary haskell derivation attribute of type list
# , extStrs  ? {}       :: Map AttrName (String -> String) ## Modify arbitrary haskell derivation attribute of type string
# }

self: {
  cabal-install        = { jailbreak = true; repo = "cabal"; chdir = "cabal-install"; scope = self: super: { Cabal = null; }; };
  exceptions           = { jailbreak = true; };
  hackage-security     = { jailbreak = true; doHaddock = false; };
  primitive            = { jailbreak = true; };
  test-framework       = { jailbreak = true; };
}
