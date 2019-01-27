let
  nixpkgsJson  = ./pins/nixpkgs.src-json;
  fetchNixpkgs = import ./fetch-nixpkgs.nix;
in
{ ## 1. Provide pinned Nixpkgs
  nixpkgs        ? fetchNixpkgs nixpkgsJson
  ## 2. Choose a compiler
, compiler       ? import ./default-compiler.nix
, withHoogle     ? false
  ## 3. Choose extra packages
, pkgs           ? import ./default-packages.nix
, trace          ? false
, tracePatches   ? trace
, traceOverrides ? trace
}:
let
  nixpkgs' = import ./nixpkgs.nix
    { inherit compiler nixpkgs trace tracePatches traceOverrides; }; # Patched Nixpkgs with overlays.
  ghc      = nixpkgs'.haskell.packages."${compiler}";                # :: nixpkgs/pkgs/development/haskell-modules/make-package-set.nix
in with ghc;
  shellFor {
    packages    = p: [];
    withHoogle  = withHoogle;
    buildInputs = map (name: ghc."${name}") pkgs;
  }
