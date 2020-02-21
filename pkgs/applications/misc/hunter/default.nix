{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "rabite0";
    repo = "hunter";
    rev = "v${version}";
    sha256 = "0z28ymz0kr726zjsrksipy7jz7y1kmqlxigyqkh3pyh154b38cis";
  };

  cargoSha256 = "0qcmm2gnbifr65agxmly33slks16x4ggrx0nijh9syg7clbrk2gw";

  meta = with stdenv.lib; {
    description = "A fast and lag-free file browser/manager for the terminal.";
    longDescription = ''
      It features a heavily asynchronous and multi-threaded design and all disk
      IO happens off the main thread in a non-blocking fashion, so that hunter
      will always stay responsive, even under heavy load on a slow spinning
      rust disk, even with all the previews enabled.
    '';
    homepage = "https://github.com/rabite0/hunter";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
