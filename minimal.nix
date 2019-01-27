## Minimal Nixpkgs definition with patch overrides from head.hackage,
## basically following https://github.com/hvr/head.hackage/blob/master/scripts/README.md,
## with the minor addition of pinned Nixpkgs.
let
  ## Use pinned nixpkgs:
  nixpkgsJson  = ./pins/nixpkgs.src-json;
  fetchNixpkgs = import ./fetch-nixpkgs.nix;
  nixpkgs      = fetchNixpkgs nixpkgsJson;

  ## Copied nearly verbatim from head.hackage:
  overlay     = self: super:
  {
    # An attribute which contains the head overrides.
    patches = super.callPackage ./head.hackage/scripts/overrides.nix
                { patches = ./head.hackage/patches; };

    # A modified package set intented to be used with ghcHEAD
    ghcHEAD = super.haskell.packages.ghcHEAD.override
    { overrides = sel: sup:
      # The patches from the directory
      ((super.callPackage self.patches {} sel sup)
      # Any more local overrides you want.
      // { mkDerivation = drv: sup.mkDerivation
            ( drv // { jailbreak = true; doHaddock = false; });
            generic-deriving = super.haskell.lib.dontCheck sup.generic-deriving;
      });
    };
  };
in
  import nixpkgs { overlays = [ overlay ]; }
