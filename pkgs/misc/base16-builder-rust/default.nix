{ lib, stdenv, fetchFromGitLab, rustPlatform, openssl, pkg-config #makeWrapper, perf, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "base16-builder-rust";
  version = "unstable-2021-07-11";

  src = fetchFromGitLab {
    owner = "ilpianista";
    repo = "base16-builder-rust";
    rev = "9eae803c23e93a6a52e5a0f9ee2f46e2336fb94e";
    sha256 = "sha256-NvJBI+ag+U84OMHA+AJ2fLVvtuAP9MvXDD1dAq/MvxY=";
  };

  cargoSha256 = "sha256-w8NyvrsuEBYDtuSb3OLFzTMaMqhKM9nNIokq2uTTfuw==";

  nativeBuildInputs = [ pkg-config ];#lib.optionals stdenv.isLinux [ makeWrapper ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Rust implementation of a base16 builder ";
    homepage = "https://gitlab.com/ilpianista/base16-builder-rust";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ wucke13 ];
  };
}
