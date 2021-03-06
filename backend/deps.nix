# generated by clj2nix-1.0.8
{ pkgs }:

let repos = [
        "https://repo1.maven.org/maven2/"
        "https://repo.clojars.org/" ];

  in rec {
      fetchmaven = pkgs.callPackage (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/681d93ece85b69b38a796464425e69b757f5a18f/pkgs/build-support/fetchmavenartifact/default.nix";
        sha512 = "sha512-O2HDUL3iT8suMn8g96o8RUOAMzmGPjMSgji7huQqHXXveOttx1VUBO/FbGvp4AI8a4djiUbHuzFuAttLOjZKUQ==";
      }) {};
      makePaths = {extraClasspaths ? null}:
        (pkgs.lib.concatMap
          (dep:
            builtins.map
            (path:
              if builtins.isString path then
                path
              else if builtins.hasAttr "jar" path then
                path.jar
              else if builtins.hasAttr "outPath" path then
                path.outPath
              else
                path
                )
            dep.paths)
          packages)
        ++ (if extraClasspaths != null then [ extraClasspaths ] else []);
      makeClasspaths = {extraClasspaths ? null}: builtins.concatStringsSep ":" (makePaths {inherit extraClasspaths;});
      packageSources = builtins.map (dep: dep.src) packages;
      packages = [
  rec {
    name = "clojure/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "clojure";
      groupId = "org.clojure";
      sha512 = "4bb567b9262d998f554f44e677a8628b96e919bc8bcfb28ab2e80d9810f8adf8f13a8898142425d92f3515e58c57b16782cff12ba1b5ffb38b7d0ccd13d99bbc";
      version = "1.10.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "commons-codec/commons-codec";
    src = fetchmaven {
      inherit repos;
      artifactId = "commons-codec";
      groupId = "commons-codec";
      sha512 = "da30a716770795fce390e4dd340a8b728f220c6572383ffef55bd5839655d5611fcc06128b2144f6cdcb36f53072a12ec80b04afee787665e7ad0b6e888a6787";
      version = "1.15";
      
    };
    paths = [ src ];
  }

  rec {
    name = "core.specs.alpha/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "core.specs.alpha";
      groupId = "org.clojure";
      sha512 = "c1d2a740963896d97cd6b9a8c3dcdcc84459ea66b44170c05b8923e5fbb731b4b292b217ed3447bbc9e744c9a496552f77a6c38aea232e5e69f8faa627dea4b5";
      version = "0.2.56";
      
    };
    paths = [ src ];
  }

  rec {
    name = "spec.alpha/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "spec.alpha";
      groupId = "org.clojure";
      sha512 = "0740dc3a755530f52e32d27139a9ebfd7cbdb8d4351c820de8d510fe2d52a98acd6e4dfc004566ede3d426e52ec98accdca1156965218f269e60dd1cd4242a73";
      version = "0.2.194";
      
    };
    paths = [ src ];
  }

  rec {
    name = "tools.cli/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.cli";
      groupId = "org.clojure";
      sha512 = "1d88aa03eb6a664bf2c0ce22c45e7296d54d716e29b11904115be80ea1661623cf3e81fc222d164047058239010eb678af92ffedc7c3006475cceb59f3b21265";
      version = "1.0.206";
      
    };
    paths = [ src ];
  }

  rec {
    name = "compojure/compojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "compojure";
      groupId = "compojure";
      sha512 = "1f4ba1354bd95772963a4ef0e129dde59d16f4f9fac0f89f2505a1d5de3b4527e45073219c0478e0b3285da46793e7c145ec5a55a9dae2fca6b77dc8d67b4db6";
      version = "1.6.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "commons-fileupload/commons-fileupload";
    src = fetchmaven {
      inherit repos;
      artifactId = "commons-fileupload";
      groupId = "commons-fileupload";
      sha512 = "a8780b7dd7ab68f9e1df38e77a5207c45ff50ec53d8b1476570d069edc8f59e52fb1d0fc534d7e513ac5a01b385ba73c320794c82369a72bd6d817a3b3b21f39";
      version = "1.4";
      
    };
    paths = [ src ];
  }

  rec {
    name = "tools.macro/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.macro";
      groupId = "org.clojure";
      sha512 = "65ce5e29379620ac458274c53cd9926e4b764fcaebb1a2b3bc8aef86bbe10c79e654b028bc4328905d2495a680fa90f5002cf5c47885f6449fad43a04a594b26";
      version = "0.1.5";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jackson-dataformat-cbor/com.fasterxml.jackson.dataformat";
    src = fetchmaven {
      inherit repos;
      artifactId = "jackson-dataformat-cbor";
      groupId = "com.fasterxml.jackson.dataformat";
      sha512 = "575a00fec1760571403aaadbe0aa6c74f8bb01f40feae00741df6604e7c2bf199ac739a789bbd5d83af75ec6d9fcc55f5a1515b05aef33e0d3cc3046acad9e89";
      version = "2.10.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "ring-json/ring";
    src = fetchmaven {
      inherit repos;
      artifactId = "ring-json";
      groupId = "ring";
      sha512 = "1ecd3629fa35606ec0de31f11492031d354b2119549275bad374b73e29f809150edaa949ced6c14f125cad362b5a1195a4b26d2e85d88fd6dc07885b4562220a";
      version = "0.5.1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "commons-io/commons-io";
    src = fetchmaven {
      inherit repos;
      artifactId = "commons-io";
      groupId = "commons-io";
      sha512 = "4de22e2a50711f756a5542474395d8619dca0a8be0407b722605005a1167f8c306bc5eef7f0b8252f5508c817c1ceb759171e4e18d4eb9697dfdd809ac39673f";
      version = "2.6";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jackson-core/com.fasterxml.jackson.core";
    src = fetchmaven {
      inherit repos;
      artifactId = "jackson-core";
      groupId = "com.fasterxml.jackson.core";
      sha512 = "5055943790cea2c3abbacbe91e63634e6d2e977cd59b08ce102c0ee7d859995eb5d150d530da3848235b2b1b751a8df55cff2c33d43da695659248187ddf1bff";
      version = "2.10.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "instaparse/instaparse";
    src = fetchmaven {
      inherit repos;
      artifactId = "instaparse";
      groupId = "instaparse";
      sha512 = "ec2fcf4a09319a8fa9489b08fd9c9a5fe6e63155dde74d096f947fabc4f68d3d1bf68faf21e175e80eaee785f563a1903d30c550f93fb13a16a240609e3dfa2e";
      version = "1.4.8";
      
    };
    paths = [ src ];
  }

  rec {
    name = "clout/clout";
    src = fetchmaven {
      inherit repos;
      artifactId = "clout";
      groupId = "clout";
      sha512 = "99d6e1a8c5726ca4e5d12b280a39e6d1182d734922600f27d588d3d65fbc830c5e03f9e0421ff25c819deee4d1f389fd3906222716ace1eb17ce70ef9c5e8f4b";
      version = "2.2.1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "crypto-random/crypto-random";
    src = fetchmaven {
      inherit repos;
      artifactId = "crypto-random";
      groupId = "crypto-random";
      sha512 = "0551fba1c86871b1e70fe80679d78f11bec678ccad07f7b40cc7de1e97a3ec11f7df43dd86508869765cb1a6b2b5aa5cac6d10a5d319a26df8f513ec2bfa29e8";
      version = "1.2.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "ring-codec/ring";
    src = fetchmaven {
      inherit repos;
      artifactId = "ring-codec";
      groupId = "ring";
      sha512 = "38b9775a794831b8afd8d66991a75aa5910cd50952c9035866bf9cc01353810aedafbc3f35d8f9e56981ebf9e5c37c00b968759ed087d2855348b3f46d8d0487";
      version = "1.1.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "crypto-equality/crypto-equality";
    src = fetchmaven {
      inherit repos;
      artifactId = "crypto-equality";
      groupId = "crypto-equality";
      sha512 = "54cf3bd28f633665962bf6b41f5ccbf2634d0db210a739e10a7b12f635e13c7ef532efe1d5d8c0120bb46478bbd08000b179f4c2dd52123242dab79fea97d6a6";
      version = "1.0.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "cheshire/cheshire";
    src = fetchmaven {
      inherit repos;
      artifactId = "cheshire";
      groupId = "cheshire";
      sha512 = "5b2a339f8d90951a80105729a080b841e0de671f576bfa164a78bccc08691d548cff6a7124224444f7b3a267c9aca69c18e347657f1d66e407167c9b5b8b52cb";
      version = "5.10.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "tigris/tigris";
    src = fetchmaven {
      inherit repos;
      artifactId = "tigris";
      groupId = "tigris";
      sha512 = "fdff4ef5e7175a973aaef98de4f37dee8e125fc711c495382e280aaf3e11341fe8925d52567ca60f3f1795511ade11bc23461c88959632dfae3cf50374d02bf6";
      version = "0.1.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "ring-core/ring";
    src = fetchmaven {
      inherit repos;
      artifactId = "ring-core";
      groupId = "ring";
      sha512 = "307c101d24fc73bedbdd90b9bcf5a718d22bddb6ef6dd8baba9adc13e2ff59ffd661737f04e77badb2f35413f304e129dc7a626fab87c1eec3ae388282cae191";
      version = "1.9.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "medley/medley";
    src = fetchmaven {
      inherit repos;
      artifactId = "medley";
      groupId = "medley";
      sha512 = "749ef43b5ea2cae7dc96db871cdd15c7b3c9cfbd96828c20ab08e67d39a5e938357d15994d8d413bc68678285d6c666f2a7296fbf305706d03b3007254e3c55c";
      version = "1.3.0";
      
    };
    paths = [ src ];
  }

  rec {
    name = "jackson-dataformat-smile/com.fasterxml.jackson.dataformat";
    src = fetchmaven {
      inherit repos;
      artifactId = "jackson-dataformat-smile";
      groupId = "com.fasterxml.jackson.dataformat";
      sha512 = "8998346f7039df868f3387d219efa0c04fc022a948d098296f3d7ac3f7a9a82bde6ec4a8f83b11994ad50318b5aca37781faacb1f20a65ba2ecc6d6d6eb9468e";
      version = "2.10.2";
      
    };
    paths = [ src ];
  }

  rec {
    name = "http-kit/http-kit";
    src = fetchmaven {
      inherit repos;
      artifactId = "http-kit";
      groupId = "http-kit";
      sha512 = "4186a2429984745e18730aa8fd545f1fc1812083819ebf77aecfc04e0d31585358a5e25a308c7f21d81359418bbc72390c281f5ed91ae116cf1af79860ba22c3";
      version = "2.5.3";
      
    };
    paths = [ src ];
  }

  ];
  }
  