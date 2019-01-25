{ self, super, pkgs }:

with pkgs.haskell.lib; with self; with pkgs.lib; with builtins;
let
  over = attr:
         { pin ? false, repo ? attr, chdir ? null
         , revision ? (!pin)
         , patches ? [], patch ? null
         , jailbreak ? false
         , doHaddock ? true
         , doCheck ? true
         }:
              overrideCabal (super."${attr}")
  (drv: {}
    // optionalAttrs pin              {
        src             = pkgs.fetchgit (removeAttrs (fromJSON (readFile (./pins + "/${repo}.src.json"))) ["date"]);
        prePatch        = if chdir != null then "cd ${chdir}; " else ""; }
    // optionalAttrs (!revision)      {
        editedCabalFile = null;
        revision        = null; }
    // optionalAttrs jailbreak        { jailbreak   = true; }
    // optionalAttrs doHaddock        { doHaddock   = false; }
    // optionalAttrs (!doCheck)       { doCheck     = false; }
    // optionalAttrs (patch != null)  { patches     = [(pkgs.fetchpatch patch)]; }
    );
in mapAttrs over (import ./extra-overrides.nix self)
