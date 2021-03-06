##
## Provide a Nixpkgs with the specified Haskell package set overridden as follows:
##
##  1. Patches from local head.hackage submodule applied,
##  2. ./extra-overrides.nix applied on top of that
##

let
  nixpkgsJson  = ./pins/nixpkgs.src-json;
  fetchNixpkgs = import ./fetch-nixpkgs.nix;
in
{ ## 1. Provide pinned Nixpkgs
  nixpkgs        ? fetchNixpkgs nixpkgsJson
  ## 2. Choose a compiler
, compiler       ? import ./default-compiler.nix
, trace          ? false
, tracePatches   ? trace
, traceOverrides ? trace
}:
let
  overlays = [
    (self: super:
    let lib     = import ./lib.nix self;
        patches = super.callPackage ./head.hackage/scripts/overrides.nix
                        { patches = ./head.hackage/patches; };
    in {
      patches = builtins.trace "patches.nix: ${patches.outPath}" patches;
      haskell = super.haskell // {
        packages = super.haskell.packages // {
          "${compiler}" =
            super.haskell.packages."${compiler}".override (oldArgs: {
              overrides = let overSpecs = import ./extra-overrides.nix super.haskell.lib self super;
                              suppressedCabals  = lib.suppressedCabals  overSpecs;
                              suppressedPatches = lib.suppressedPatches overSpecs;
                          in
                          super.lib.composeExtensions
                          (sel: sup: lib.computeOverrides ./pins ./extra-overrides.nix traceOverrides sel sup)
                          (sel: sup: lib.maybeTraceAttrs tracePatches (self.callPackage self.patches { inherit suppressedCabals suppressedPatches; } sel sup));
            });
        };
      };
    })
  ];
in
  import nixpkgs { inherit overlays; }
