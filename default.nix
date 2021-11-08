let sources = import nix/sources.nix; in
{ pkgs ? import sources.nixpkgs {}
, lib ? pkgs.lib
, callPackage ? pkgs.callPackage
, writeTextFile ? pkgs.writeTextFile
, esc ? lib.escapeShellArg
, makeWrapper ? pkgs.makeWrapper
, symlinkJoin ? pkgs.symlinkJoin

, dash ? pkgs.dash
, clojure ? pkgs.clojure
, clojure-lsp ? pkgs.clojure-lsp
, clj-kondo ? pkgs.clj-kondo

, clj2nix ? callPackage sources.clj2nix {}

, cljdeps ? import ./deps.nix { inherit pkgs; }
, classpaths ? cljdeps.makeClasspaths {}

, backend-path ? ./backend
, frontend-path ? ./frontend

, with-clojure-lsp ? true
, with-clj-kondo ? true
}:

let
  getRelativeFileName = prefix: fileName:
    # +1 and -1 for the slash after the prefix
    builtins.substring
      (builtins.stringLength prefix + 1)
      (builtins.stringLength fileName - builtins.stringLength prefix - 1)
      fileName;

  src = path: let
    filter = prefix: fileName: fileType:
      let relativeFileName = getRelativeFileName prefix fileName; in
      (
        (fileType == "directory") &&
        (builtins.match "^src(/.+)?$" relativeFileName != null)
      )
      ||
      (
        (fileType == "regular") &&
        (builtins.match "^src/.+\.(clj)$" relativeFileName != null)
      );
  in
    assert builtins.isPath path;
    builtins.filterSource (filter (toString path)) path;

  backendSrc = src backend-path;

  name = "clojure-todo-app";

  executables = {
    inherit dash clojure;
  };

  mkE = builtins.mapAttrs (n: v: "${v}/bin/${n}");
  e = mkE executables;

  mkChecker = x: lib.pipe x [
    (lib.mapAttrsToList (_: v: ''
      if [[ ! -f ${esc v} ]] || [[ ! -r ${esc v} ]] || [[ ! -x ${esc v} ]]
      then
        >&2 printf 'File “%s” is not executable or/and not readable!\n' ${esc v}
        exit 1
      fi
    ''))
    (builtins.concatStringsSep "\n")
  ];

  backendRunScript = let n = "${name}-run-backend"; in writeTextFile {
    name = n;
    executable = true;
    destination = "/bin/${n}";
    checkPhase = mkChecker e;
    text = ''
      #! ${e.dash}
      ${esc e.clojure} -Scp ${classpaths} -M src/main.clj "$@"
    '';
  };

  wrappedBackendRunScript = symlinkJoin {
    name = lib.getName backendRunScript;
    paths = [ backendRunScript ];
    nativeBuildInputs = [ makeWrapper ];

    postBuild = ''
      wrapProgram "$out"/bin/${esc (lib.getName backendRunScript)} \
        --run ${esc "cd -- ${esc backendSrc}"}
    '';
  };

  mainDerivation =
    let
      e = mkE {
        ${lib.getName wrappedBackendRunScript} = wrappedBackendRunScript;
      };

      runBackend = e.${lib.getName wrappedBackendRunScript};
    in
    pkgs.stdenv.mkDerivation rec {
      inherit name;
      src = backendSrc;

      nativeBuildInputs =
        lib.optional with-clojure-lsp clojure-lsp
        ++ lib.optional with-clj-kondo clj-kondo;

      checkPhase = ''
        ${mkChecker e}
        mkdir tmp
        HOME="$PWD"/tmp ${esc runBackend} smoke-test
      '';

      buildInputs = [
        clojure
      ];

      buildPhase = ''
        eval -- "$checkPhase"
      '';

      installPhase = ''
        mkdir -p -- "$out"/bin
        ln -s -- ${esc runBackend} "$out"/bin
      '';
    };
in

mainDerivation // {
  inherit clj2nix;

  env = pkgs.buildEnv {
    name = "${name}-env";

    paths =
      mainDerivation.nativeBuildInputs
      ++ mainDerivation.buildInputs
      ++ [ clj2nix ];
  };
}
