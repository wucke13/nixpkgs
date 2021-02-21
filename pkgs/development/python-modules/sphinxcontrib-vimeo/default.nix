{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-vimeo";
  version = "unstable-2021-02-21";

  src = fetchFromGitHub {
    rev = "d5511ef6e0976fd1f22f3f518317b7e088e4270f";
    owner = "ArduPilot";
    repo = "sphinxcontrib.vimeo";
    sha256 = "0bs0x37h8zp48hxhgpsmp4pk9pqlkn9py2pac9741kswg6c8r22c";
  };

  propagatedBuildInputs = [ sphinx ];

  doCheck = true;

  meta = {
    description = "Embedding vimeo video to sphinx";
    homepage = "https://github.com/sphinx-contrib";
    license = lib.licenses.bsd3;
  };
}
