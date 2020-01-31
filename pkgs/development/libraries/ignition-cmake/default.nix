{ stdenv, fetchFromBitbucket, cmake }:

stdenv.mkDerivation rec {
  pname = "ignition-cmake";
  version = "2.1.1";
  src = fetchFromBitbucket {
    owner = "ignitionrobotics";
    repo = "ign-" + builtins.toString (builtins.tail (builtins.splitVersion pname));
    rev = pname + builtins.head (builtins.splitVersion version) + "_" + version;
    sha256 = "0c1y3dz70bn2y2x49xviisvcp8hk061m4wsrdjr3bnda89qy2f76";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://ignitionrobotics.org/libs/cmake";
    description = ''
      Provides a set of cmake modules that are used by the C++-based ignition
      projects. These modules help to control the quality and consistency of
      the ignition projects' build systems.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
