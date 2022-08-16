{ lib, stdenv
, writeScriptBin
, fetchFromGitHub
, pkg-config
, go
, busybox
, dump1090
}:

let
  fakegit = writeScriptBin "git" ''
     #! ${stdenv.shell} -e
     if [ "$1" = "describe" ]; then
       [ -r .rev ] && cat .rev || true
     fi
   '';
in
stdenv.mkDerivation rec {
  pname = "stratux";
  version = "1.6r1-eu028";

  src = fetchFromGitHub {
    owner = "b3nn0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KpvmJq/DvXBpuar7OsVRWE00LwxwbMWR56z7gwx4TtA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config fakegit busybox go ] ++ dump1090.nativeBuildInputs;

  buildInputs = [
  ] ++ dump1090.buildInputs;

  #NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
  #  "-Wno-implicit-function-declaration -Wno-int-conversion";

  #buildFlags = [ "dump1090" "view1090" ];

  doCheck = true;

  # installPhase = ''
  #   runHook preInstall

  #   mkdir -p $out/bin $out/share
  #   cp -v dump1090 view1090 $out/bin
  #   cp -vr public_html $out/share/dump1090

  #   runHook postInstall
  # '';

  meta = with lib; {
    description = "Aviation weather and traffic receiver based on RTL-SDR.";
    homepage = "https://github.com/cyoung/stratux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wucke13 ];
  };
}