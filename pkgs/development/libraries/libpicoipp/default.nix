{ stdenv, fetchurl, dpkg, autoPatchelfHook, gcc }:

stdenv.mkDerivation rec {
  pname = "libpicoipp";
  version = "1.3.0-4r29";
  src = fetchurl {
    url = "https://labs.picotech.com/debian/pool/main/libp/${pname}/${pname}_${version}_amd64.deb";
    sha256 = "0j5di2sjk0rgc7zx2szws98giqgl81d13hnr2fzgir7yvb24cv5s";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [ (stdenv.lib.getLib gcc.cc) ];
  unpackCmd = ''
    dpkg -x $src unpacked
    sourceRoot=$PWD/unpacked
  '';
  
  installPhase = ''
    mkdir $out
    mv opt/picoscope/* $out/
  '';
}
