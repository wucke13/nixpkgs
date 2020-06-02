{ stdenv, fetchurl, unzip, cmake, gfortran, hdf5 }:

stdenv.mkDerivation rec {
  pname = "gidpost";
  version = "2.7";

  src = fetchurl {
    url = "https://www.gidhome.com/archive/Tools/gidpost/gidpost-${version}.zip";
    sha256 = "1lr20ig460pfyx6h1jfxnk4646prhbacya4bys4n9wxb1261j11w";
  };

  patches = [ ./CMakeLists.txt.patch ];
  buildInputs = [ hdf5.dev ];

  nativeBuildInputs = [ unzip cmake gfortran ];

  meta = with stdenv.lib; {
    description = ''
      A library for writing postprocess results for GiD in ASCII or binary
      format
    '';
    homepage = "https://www.gidhome.com/gid-plus/tools/476/gidpost/";
    platforms = [ "x86_64-linux" ];
    license = licenses.bsd2;
  };
}
