{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, dbus, libGL, python3,
  libxkbcommon, x11, xorg }:

rustPlatform.buildRustPackage rec {
  pname = "screenruster";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "meh";
    repo = pname;
    rev = "f1704d09db29c87d90c6883393a9ef76b0117238";
    sha256 = "1fg6c76592z6zdivmh91yaay1ayks62yfkk5ybnmf5kdlxfqnkmd";
    fetchSubmodules = true;
  };

  #prePatch = "chmod +w -R ../saver"; # TODO: remove ASAP
  #patchFlags = [ "--directory=../saver" "-p1" ]; # TODO: remove ASAP
  cargoPatches = [ 
    ./cargo-toml.patch # TODO: remove ASAP
    ./cargo-lock.patch
  ]; 
  cargoSha256 = "1h181gpgrvwdw1jrbds54qgdirkzn3ly9mfcnzdsa1gda2p8d9j8";

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [
    dbus.dev
    libxkbcommon.dev
    xorg.libxcb.dev
  ];

  meta = with stdenv.lib; {
    description = "An X11 screen saver and locker written in Rust.";
    homepage = "https://github.com/meh/screenruster";
    license = with licenses; [ gpl-3 ];
    maintainers = with maintainers; [ wucke13 ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
