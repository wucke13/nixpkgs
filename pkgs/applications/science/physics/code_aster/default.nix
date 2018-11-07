{ stdenv, fetchurl, gfortran, pythonPackages, blas, liblapack, openmpi }:

stdenv.mkDerivation rec {
  name = "code_aster-${version}";
  version = "13.6.0-1";
  # src = fetchhg {
  #   url = "https://bitbucket.org/code_aster/codeaster-src";
  #   rev = "${version}";
  #   sha256 = "0glp6fvg023jrjqfryl9mrvgzpjwmdclgrkzwbbjkk3f0clwxv3m";
  # };
  src = fetchurl {
    url = "https://www.code-aster.org/FICHIERS/aster-full-src-${version}.noarch.tar.gz";
    sha256 = "1857mrfm8hcxmj16as7przkmij2bba791fcplznnnl39k4kvlkkf"; 
  };

  buildInputs = [ gfortran pythonPackages.python pythonPackages.numpy blas liblapack openmpi ];
  patchPhase = "patchShebangs .";

  configurePhase = ''
    ./waf configure
  '';

  buildPhase = ''
 #   ./waf build -p
  '';

  installPhase = ''
  #  ./waf install --prefix=$out
  '';

  enableParallelBuilding = true;

  meta = {
    description = "";
    longDescription = ''
    '';
    homepage = https://www.code-aster.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wucke13 ];
  };
}
