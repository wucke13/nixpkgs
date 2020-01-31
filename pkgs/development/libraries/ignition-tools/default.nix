{ stdenv, fetchFromBitbucket, cmake, eigen, ignition, ruby }:

stdenv.mkDerivation rec {
  pname = "ignition-tools";
  version = "1.0.0";

  src = fetchFromBitbucket {
    owner = "ignitionrobotics";
    repo = "ign-" + builtins.toString (builtins.tail (builtins.splitVersion pname));
    rev = pname + "_" + version;
    sha256 = "17s5anzv6702ybh8j4nvmf6wzbzjwl0qxx3vqqp5blcfixac3573";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen ignition.cmake ruby ];

  meta = with stdenv.lib; {
    homepage = "https://ignitionrobotics.org/";
    description = ''
      Entry point for using all the suite of ignition tools
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
