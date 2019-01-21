{stdenv, fetchFromGitHub, dmd, dub}:

stdenv.mkDerivation rec {
  name = "dlangide-${version}";
  version = "0.8.17";
  version-dlangui = "0.9.182";
  version-dsymbol = "0.4.8";
  version-dcd = "0.9.13";
  src = fetchFromGitHub {
    owner = "buggins";
    repo = "dlangide";
    rev = "v${version}";
    sha256 = "1p5385c9yp259p8rlsqjy38ak8kw36v3kzmzlhlwlbhi5pckdcqx";
  };
  dlangui = fetchFromGitHub {
    owner = "buggins";
    repo = "dlangui";
    rev = "v${version-dlangui}";
    sha256 = "1p5385c9yp259p8rlsqjy38ak8kw36v3kzmzlhlwlbhi5pckdcqx";
  };
  dsymbol = fetchFromGitHub {
    owner = "dlang-community";
    repo = "dsymbol";
    rev = "v${version-dsymbol}";
    sha256 = "1p5385c9yp259p8rlsqjy38ak8kw36v3kzmzlhlwlbhi5pckdcqx";
  };
  dcd = fetchFromGitHub {
    owner = "dlang-community";
    repo = "dcd";
    rev = "v${version-dcd}";
    sha256 = "1p5385c9yp259p8rlsqjy38ak8kw36v3kzmzlhlwlbhi5pckdcqx";
  };


  nativeBuildInputs = [dmd dub];

  configurePhase = ''
    ls
    dub add-local ${dlangui}
    dub add-local ${dsymbol}
    dub add-local ${dcd}
  '';

  installPhase = "dub build --build=release dlangide";

  meta = with stdenv.lib; {
    description = "Ancillary tools for the D programming language compiler";
    homepage = https://github.com/dlang/tools;
    license = lib.licenses.boost;
    maintainers = with maintainers; [ ThomasMader ];
    platforms = stdenv.lib.platforms.unix;
  };
}
