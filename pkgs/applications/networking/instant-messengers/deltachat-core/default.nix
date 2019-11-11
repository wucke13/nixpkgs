{stdenv, fetchFromGitHub, rustPlatform}:

rustPlatform.buildRustPackage rec {
  pname = "deltachat-core";
  version = "1.0.0-beta.7";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = "${version}";
    sha256 = "0y5d1n6hkw85jb3rblcxqas2fp82h3nghssa4xqrhqnz25l799p0";
  };

  cargoSha256 = "0q68qyl2h6i0qsz82z840myxlnjay8p1w5z7hfyr8fqp7wgwa9c0";

  meta = with stdenv.lib; {
    description = ''
      Delta Chat core library (pure Rust), used by ios/android/desktop apps
    '';
    homepage = "https://delta.chat";
    license = licenses.mpl20;
    maintainers = [ maintainers.wucke13 ];
    platforms = platforms.all;
  };
}
