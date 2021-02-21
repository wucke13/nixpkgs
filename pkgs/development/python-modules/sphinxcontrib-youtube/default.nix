{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-youtube";
  version = "unstable-2021-02-21";

  src = fetchFromGitHub {
    rev = "635c8a908e3cac552ce43293c1516e7270cc4ce8";
    owner = "sphinx-contrib";
    repo = "youtube";
    sha256 = "1wkvn0hw807lmyrm3w7ncn5jynm6ygp0qrarl8vj44dp15ypdk3y";
  };

  propagatedBuildInputs = [ sphinx ];

  doCheck = true;

  meta = {
    description = "Embedding youtube video to sphinx";
    homepage = "http://sphinx-doc.org/";
    license = lib.licenses.bsd3;
  };
}
