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
  pkgs     = import ./nixpkgs.nix { inherit compiler nixpkgs; }; # Patched Nixpkgs with overlays.
  ghc      = pkgs.haskell.packages."${compiler}";                # :: nixpkgs/pkgs/development/haskell-modules/make-package-set.nix
  extras   = [
               ghc.cabal-install
             ];
in with ghc;
  shellFor {
    packages    = p: [];
    withHoogle  = true;
    buildInputs = extras;
  }
