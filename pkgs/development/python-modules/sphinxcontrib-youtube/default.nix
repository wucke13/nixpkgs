{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, urllib3
, six
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-youtube";
  version = "0.2";

  src = fetchPypi {
    inherit version;
    pname = "sphinxcontrib.youtube";
    sha256 = "11463fziaqshywrij1qcz979i9szvq7zql83xzk6d7syjfgy0i70";
  };

  propagatedBuildInputs = [ sphinx urllib3 ];

  doCheck = true;

  meta = {
    description = "Embedding youtube video to sphinx";
    homepage = "http://sphinx-doc.org/";
    license = lib.licenses.lgpl3;
  };
}
