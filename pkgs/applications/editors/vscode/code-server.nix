{ stdenv, callPackage, fetchurl }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x86_64";
    x86_64-darwin = "darwin-x86_64";
  }.${system};

  sha256 = {
    x86_64-linux = "1qwlj8bqykm9dpz2crg37c6l6457jg4ag53jhzrpx7r2bpz0p3f5";
    x86_64-darwin = "05m8rza9sh9j475qwg3f2cwbwhw4j59586rprnjq9ym530qxv84r";
  }.${system};

  sourceRoot = {
    x86_64-linux = ".";
    x86_64-darwin = "";
  }.${system};
in
  callPackage ./generic.nix rec {
    inherit sourceRoot;
    # The update script doesn't correctly change the hash for darwin, so please:
    # nixpkgs-update: no auto update

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "3.4.0";
    pname = "code-server";

    executableName = "code-server";
    longName = "Code-Server";
    shortName = "code-server";

    src = fetchurl {
      url = "https://github.com/cdr/code-server/releases/download/v${version}/${pname}-${version}-${plat}.tar.gz";
      inherit sha256;
    };

    meta = with stdenv.lib; {
      description = ''
        Run VS Code on any machine anywhere and access it in the browser
      '';
      homepage = "https://github.com/cdr/code-server";
      downloadPage = "https://github.com/cdr/code-server/releases";
      license = licenses.mit;
      maintainers = with maintainers; [ wucke13 ];
      platforms = [ "x86_64-linux" "x86_64-darwin" ];
    };
  }
