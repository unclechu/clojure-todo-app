let sources = import nix/sources.nix; in
{ pkgs ? import sources.nixpkgs {}
, lib ? pkgs.lib
, callPackage ? pkgs.callPackage
, writeTextFile ? pkgs.writeTextFile
, esc ? lib.escapeShellArg
, mkShell ? pkgs.mkShell

, dash ? pkgs.dash
, findutils ? pkgs.findutils
, jdk ? pkgs.jdk
, clojure ? pkgs.clojure
, clojure-lsp ? pkgs.clojure-lsp
, clj-kondo ? pkgs.clj-kondo

, clj2nix ? callPackage sources.clj2nix {}

, backend-cljdeps ? import backend/deps.nix { inherit pkgs; }
, backend-classpaths ? backend-cljdeps.makeClasspaths {}

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

  name = "clojure-todo-app";
  backendSrc = src backend-path;
  backendMainClass = "clojure_todo_app.main";

  e = builtins.mapAttrs (n: v: "${v}/bin/${n}") {
    inherit dash;
    java = jdk;
  };

  checkExecutables = lib.pipe e [
    (lib.mapAttrsToList (_: v: ''
      if [[ ! -f ${esc v} ]] || [[ ! -r ${esc v} ]] || [[ ! -x ${esc v} ]]
      then
        >&2 printf 'File “%s” is not executable or/and not readable!\n' ${esc v}
        exit 1
      fi
    ''))
    (builtins.concatStringsSep "\n")
  ];

  backendBuiltClasses = pkgs.stdenv.mkDerivation {
    name = "${name}-built-classes";
    src = backendSrc;

    nativeBuildInputs = [
      findutils
      jdk
    ];

    buildInputs = [];

    checkPhase = ''
      java -cp ${esc backend-classpaths}:build \
        ${esc backendMainClass} smoke-test
    '';

    buildPhase = ''
      mkdir build

      (
        set -eu || exit
        FILES=$(cd src && find * -name '*.clj')
        readarray -t MODULES <<< "$FILES"

        for module in "''${MODULES[@]}"; do
          module=''${module%.clj}
          module=''${module//'/'/.}
          module=''${module//_/-}

          java -cp ${esc backend-classpaths}:"$src"/src \
            -Dclojure.compile.path=build \
            clojure.lang.Compile \
            "$module"
        done
      )

      eval -- "$checkPhase"
    '';

    installPhase = ''
      mkdir -p -- "$out"
      cp -r build/* -- "$out"
    '';
  };

  backendRunScript = let n = "${name}-backend"; in writeTextFile {
    name = n;
    executable = true;
    destination = "/bin/${n}";
    checkPhase = checkExecutables;
    text = ''
      #! ${e.dash}
      exec ${esc e.java} \
        -cp ${esc backend-classpaths}:${backendBuiltClasses} \
        ${esc backendMainClass} "$@"
    '';
  };
in

backendRunScript // rec {
  inherit clj2nix;

  env = pkgs.buildEnv {
    name = "${name}-env";
    paths = shell.buildInputs;
  };

  shell = mkShell {
    buildInputs =
      [ clojure jdk ]
      ++ backendBuiltClasses.nativeBuildInputs
      ++ backendBuiltClasses.buildInputs
      ++ lib.optional with-clojure-lsp clojure-lsp
      ++ lib.optional with-clj-kondo clj-kondo;
  };
}
