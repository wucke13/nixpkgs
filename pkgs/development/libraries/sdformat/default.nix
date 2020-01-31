{ stdenv, fetchFromBitbucket, cmake, pkg-config, boost, ruby, ignition
, python3Packages, tinyxml }:

stdenv.mkDerivation rec {
  pname = "sdformat";
  version = "9.1.0";

  src = fetchFromBitbucket { 
    owner = "osrf";
    repo = pname;
    rev = pname + builtins.head (builtins.splitVersion version) + "_" + version;
    sha256 = "1jx78j2xaycr4aq1hk1a89rx3kq1ciaz3ayaxjwcys61kx4y1n2y";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ 
    boost.dev
    ignition.cmake
    ignition.math
    ignition.tools
    python3Packages.psutil
    python3Packages.python
    ruby
    tinyxml
  ];

  meta = with stdenv.lib; {
    homepage = "https://sdformat.org/";
    description = ''
      An XML format that describes objects and environments for robot
      simulators, visualization, and control
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
