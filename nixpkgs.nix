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
    (self: super: {
      patches = super.callPackage
        ./head.hackage/scripts/overrides.nix
        { patches = ./head.hackage/patches; };
      haskell = super.haskell // {
        packages = super.haskell.packages // {
          "${compiler}" = super.haskell.packages."${compiler}".override (oldArgs: {
            overrides = sel: sup:
                      let lib    = import ./lib.nix self;
                      in {}
                      ## 1. Preserve existing overrides
                      // (oldArgs.overrides or (_: _: {})) sel sup
                      // lib.mergeNestedAttrs2
                         ## 2. Apply patches
                         (lib.maybeTraceAttrs tracePatches (super.callPackage self.patches {} sel sup))
                         ## 3. Apply overrides
                         (lib.computeOverrides ./pins ./extra-overrides.nix traceOverrides sel sup);
          });
        };
      };
    })
  ];
in
  import nixpkgs { inherit overlays; }
