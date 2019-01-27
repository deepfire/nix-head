pkgs:
with pkgs.haskell.lib; with pkgs.lib; with builtins;
let
  # traceAttrsN        :: Map a b -> Map a b -- Given an attrset, instrument it so its elements self-trace on use.
  traceAttrsN           = depth: attrs: mapAttrs (k: v: traceSeqN depth { "${k}" = v; } v) attrs;
  # maybeTraceAttrs    :: Bool -> Map a b -> Map a b
  maybeTraceAttrs       = bool: xs: if bool then traceAttrsN 5 xs else xs;
  # mergeAttrsWithFunc :: (a -> a -> a) -> Map k a -> Map k a -> Map k a
  mergeAttrsWithFunc    = f: set1: set2:
    fold (n: set: if set1 ? ${n}
                        then setAttr set n (f set1.${n} set2.${n})
                        else set )
           (set2 // set1) (attrNames set2);
  # mergeNestedAttrs2  :: Map k a -> Map k a -> Map k a
  mergeNestedAttrs2     = xs: ys: mergeAttrsWithFunc (x: y: x // y) xs ys;
  # valPath            :: FilePath -> Key -> OverrideKey -> FilePath
  valPath               = path: key: type: (path + "/${key}.${type}");
  # interpSrcJson      :: FilePath -> Repo -> Src
  interpSrcJson         = path: repo: pkgs.fetchgit (removeAttrs (fromJSON (readFile (valPath path repo "src-json"))) ["date"]);
  # interpChdir        :: Bool -> FilePath -> String
  interpChdir           = flag: chdir: if flag then "cd ${chdir}; " else "";
  # listfiles          :: FilePath -> [FilePath]
  listFiles             = path: mapAttrsToList (k: _: k) (filterAttrs (k: v: v == "regular") (readDir path));
  # fileMapAdd         :: Map Attr [OverrideKey] -> FilePath -> Map Attr [OverrideKey]
  fileMapAdd            = bag: x: let destr = splitString "." x; in bag // { "${elemAt destr 0}" = (bag."${elemAt destr 0}" or []) ++ [(elemAt destr 1)]; };
  # allPins            :: FilePath -> Bool -> Map Attr [OverrideKey]
  allPins               = path: tracep: maybeTraceAttrs false (foldl' fileMapAdd {} (listFiles path));
  # interSinglePin     :: FilePath -> Attr -> Map Override OverrideVal -> OverrideKey -> Map Override OverrideVal
  interpSinglePin       = path: attr: acc: overkey: acc //
    (if overkey == "src-json"
     then { pin = true; }
     else { "${overkey}" = import (valPath path attr overkey); });
  # readPackagePinSpecs :: FilePath -> Attr -> [OverrideKey] -> Map Attr (Map Override OverrideVal)
  readPackagePinSpecs   = path: attr: pins: { "${attr}" = (foldl' (interpSinglePin path attr) {} pins); };
  # readPinSpecsFromDir :: FilePath -> Map Attr (Map Override OverrideVal)
  readPinSpecsFromDir   = result: path: tracep: foldl' (acc: x: acc // x) {} (mapAttrsToList (readPackagePinSpecs path) (removeAttrs (allPins path tracep) ["nixpkgs"]));
  # printPinSpecs      :: Map Attr (Map Override OverrideVal) -> IO [Bool]
  printPinSpecs         = pinSpecs: mapAttrsToList (attr: over: traceSeqN 5 { "${attr}" = over; } true) pinSpecs;
  # ppBool             :: Bool -> String
  ppBool                = x: if x then "yes" else "no";
  # over               :: Attr -> Map Override OverrideVal -> Map DrvKey DrvVal -> Map DrvKey DrvVal
  over = super:
         attr:
         { pin ? false
         , repo ? attr, chdir ? null
         , revision ? (!pin)
         , patches ? [], patch ? null
         , jailbreak ? false
         , doHaddock ? true
         , doCheck ? true
         , scope ? null
         }:
         let result = overrideCabal (super."${attr}")
  (drv: {}
    // optionalAttrs pin              {
        src             = interpSrcJson ./pins repo;
        prePatch        = interpChdir (chdir != null) chdir; }
    // optionalAttrs (!revision)      {
        editedCabalFile = null;
        revision        = null; }
    // optionalAttrs jailbreak        { jailbreak   = true; }
    // optionalAttrs (!doHaddock)     { doHaddock   = false; }
    // optionalAttrs (!doCheck)       { doCheck     = false; }
    // optionalAttrs (patch != null)  { patches     = [(pkgs.fetchpatch patch)]; }
    );
    in if scope == null then result
       else result.overrideScope scope;
  attrHasPin = result: attr: pin: result ? "${attr}" && result."${attr}" ? "${pin}";
  patchAttrRepoPin = result: attr: pins: pins // 
    optionalAttrs ((pins.repo or attr) != attr
                 && attrHasPin result pins.repo "pin")
    { pin = true; };
  allPinSpecs = pinsDir: declPinsFile: tracep: self:
                let result =
                  (mergeNestedAttrs2
                   (readPinSpecsFromDir result pinsDir tracep)
                   (mapAttrs (patchAttrRepoPin result) (import declPinsFile self)));
                in result;
  computeOverrides = pinsDir: declPinsFile: tracep: self: super: mapAttrs (over super) (maybeTraceAttrs tracep (allPinSpecs pinsDir declPinsFile tracep self));
  printAllPinSpecs = pinsDir: declPinsFile: self:                printPinSpecs (allPinSpecs pinsDir declPinsFile self);
in {}
// pkgs.lib
// pkgs.haskell.lib
// builtins
// {
  inherit over readPinSpecsFromDir printPinSpecs computeOverrides printAllPinSpecs mergeNestedAttrs2 maybeTraceAttrs;
}
