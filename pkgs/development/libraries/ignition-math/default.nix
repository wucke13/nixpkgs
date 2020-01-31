{ stdenv, fetchFromBitbucket, cmake, eigen, ignition }:

stdenv.mkDerivation rec {
  pname = "ignition-math";
  version = "6.4.0";

  src = fetchFromBitbucket {
    owner = "ignitionrobotics";
    repo = "ign-" + builtins.toString (builtins.tail (builtins.splitVersion pname));
    rev = pname + builtins.head (builtins.splitVersion version) + "_" + version;
    sha256 = "0b90ccwsxv5fq3b33swr2b8vilaw6kwv2s5sxc1jgyx9gcznd2b1";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen ignition.cmake ];

  meta = with stdenv.lib; {
    homepage = "https://ignitionrobotics.org/libs/math";
    description = ''
      Provides general purpose math classes and functions designed for robotic
      applications.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
