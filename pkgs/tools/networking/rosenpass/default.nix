{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, cmake
, makeWrapper
, pkg-config
, removeReferencesTo
, coreutils
, findutils
, gawk
, wireguard-tools
, bash
, libsodium
}:

let
  rpBinPath = lib.makeBinPath [
    coreutils
    findutils
    gawk
    wireguard-tools
  ];
in
rustPlatform.buildRustPackage rec {
  # metadata and source
  pname = "rosenpass";
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KU/FfiaDqtAxg6/66PrI1zJ3SZBnnVUYOlc24WYJNLY=";
  };

  cargoSha256 = "sha256-s+wuaSEQEAAKemEmEXIkWNsvrk57pZcvdxepsuBMg9c=";

  nativeBuildInputs = [
    cmake # for oqs build in the oqs-sys crate
    makeWrapper # for the rp shellscript
    pkg-config # let libsodium-sys-stable find libsodium
    removeReferencesTo
    rustPlatform.bindgenHook # for C-bindings in the crypto libs
  ];
  buildInputs = [
    bash # for patchShebangs to find it
    libsodium
  ];

  # otherwise pkg-config tries to link non-existent dynamic libs
  # PKG_CONFIG_ALL_STATIC = true;

  # nix defaults to building for aarch64 _without_ the armv8-a
  # crypto extensions, but liboqs depens on these
  preBuild = lib.optionalString (stdenv.targetPlatform == "aarch64-linux")
    ''NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -march=armv8-a+crypto"'';

  preInstall = ''
    install -D rp $out/bin/rp
    wrapProgram $out/bin/rp --prefix PATH : "${ rpBinPath }"
    ls -lah
  '';

  # nix propagates the *.dev outputs of buildInputs for static
  # builds, but that is non-sense for an executables only package
  postFixup = ''
    find -type f -exec remove-references-to -t ${bash.dev} \
      -t ${libsodium.dev} {} \;
  '';

  meta = with lib; {
    description = "Build post-quantum-secure VPNs with WireGuard!";
    homepage = "https://rosenpass.eu/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
