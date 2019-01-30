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

lib: self: super: with lib; with self; {
  bytes                = { jailbreak = true; };
  bifunctors           = { jailbreak = true; };
  cabal-install        = { jailbreak = true; repo = "cabal"; chdir = "cabal-install"; scope = self: super: { Cabal = null; }; };
  cabal-doctest        = { jailbreak = true; headCabal = false; };
  code-page            =                   { doHaddock = false; };
  doctest              = { jailbreak = true; };
  ekg                  = { jailbreak = true; };
  exceptions           = { jailbreak = true; };
  fclabels             = { jailbreak = true; };
  generics-sop         = { jailbreak = true; };
  generic-deriving     =                   { headPatch = false; headCabal = false; };
  gtk2hs-buildtools    =                   { doHaddock = false; repo = "gtk2hs"; chdir = "tools"; };
  hackage-security     = { jailbreak = true; doHaddock = false; };
  haskell-gi           =                   { doHaddock = false; };
  haskell-src-exts     = { just = super.haskell-src-exts_1_21_0; doHaddock = false; };
  haskell-src-meta     = { jailbreak = true; };
  haskell-src-util     =                                      { scope = self: super: { haskell-src-exts = dontHaddock super.haskell-src-exts_1_21_0; }; };
  hlint                = { jailbreak = true;                    scope = self: super: { haskell-src-exts = dontHaddock super.haskell-src-exts_1_21_0; }; };
  hoogle               =                                      { scope = self: super: { haskell-src-exts = dontHaddock super.haskell-src-exts_1_21_0; }; };
  io-streams           = { jailbreak = true; };
  iohk-monitoring      =                   { doCheck = false; };
  invariant            = { jailbreak = true; };
  katip                = { jailbreak = true; };
  lambdacube-compiler  =                                      { scope = self: super: { megaparsec = super.megaparsec_6_5_0; }; };
  lambdacube-gl        = { jailbreak = true; };
  lambdacube-ir        = { jailbreak = true; chdir = "lambdacube-ir.haskell"; };
  lens                 = { jailbreak = true; };
  microlens-th         = { jailbreak = true; };
  primitive            = { jailbreak = true; pin = false; };
  pretty-show          =                   { doHaddock = false; };
  reflex               = { jailbreak = true;                    scope = self: super: { haskell-src-exts = dontHaddock super.haskell-src-exts_1_21_0; };
                           extLists  = { libraryHaskellDepends =
                                           [ data-default filemanip hlint lens monad-control monoidal-containers prim-uniq reflection split unbounded-delays ]; }; };
  singletons           = { jailbreak = true; headPatch = false; };
  snap-server          = { jailbreak = true; doHaddock = false; };
  quickcheck-instances = { jailbreak = true; };
  tasty-th             =                                      { scope = self: super: { haskell-src-exts = dontHaddock super.haskell-src-exts; }; };
  terminal-size        =                   { doHaddock = false; };
  text-lens            = { jailbreak = true; };
  th-abstraction       = { jailbreak = true; };
  th-desugar           = { jailbreak = true; headPatch = false; };
  th-expand-syns       = { jailbreak = true; };
  th-lift              = { jailbreak = true; doCheck   = false; };
  th-orphans           = { jailbreak = true; };
  these                = { jailbreak = true; };
  test-framework       = { jailbreak = true; };
  unix-compat          =                   { doHaddock = false; };
}
