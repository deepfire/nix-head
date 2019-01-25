##
## Provide a Nixpkgs with the specified Haskell package set overridden as follows:
##
##  1. Patches from local head.hackage submodule applied,
##  2. ./extra-overrides.nix applied on top of that
##

let
  nixpkgsJson  = ./pins/nixpkgs-src.json;
  fetchNixpkgs = import ./fetch-nixpkgs.nix;
in
{ ## 1. Provide pinned Nixpkgs
  nixpkgs     ? fetchNixpkgs nixpkgsJson
  ## 2. Choose a compiler
, compiler    ? import ./default-compiler.nix
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
                      let parent = (oldArgs.overrides or (_: _: {})) sel sup;
                          patchOvers = super.callPackage self.patches {} sel sup;
                      in
                      ## 1. Preserve existing overrides
                      parent
                      ## 2. Apply patches
                      // patchOvers
                      ## 3. Extras
                      // import ./parse-extra-overrides.nix { self = sel; super = sup; pkgs = self; };
          });
        };
      };
    })
  ];
in
  import nixpkgs { inherit overlays; }
