{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, click, ecdsa, fido2, intelhex, pyserial, pyusb, requests
, black, flake8, isort }:

 buildPythonPackage rec {
  pname = "solo-python";
  version = "0.0.15";
  format = "flit";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "14na9s65hxzx141bdv0j7rx1wi3cv85jzpdivsq1rwp6hdhiazr1";
  };

  propagatedBuildInputs = [
    click
    ecdsa
    fido2
    intelhex
    pyserial
    pyusb
    requests
  ];

  checkInputs = [ black flake8 isort ];
  checkPhase = ''
    make check
  '';

  meta = with lib; {
    description = "Python tool and library for SoloKeys";
    homepage = "https://github.com/solokeys/solo-python";
    maintainers = with maintainers; [ wucke13 ];
    license = with licenses; [ asl20 mit ];
  };
}
