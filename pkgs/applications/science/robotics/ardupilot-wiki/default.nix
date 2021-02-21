{ stdenv, fetchFromGitHub, python3Packages, rsync }:

stdenv.mkDerivation {
  pname = "ardupilot-wiki";
  version = "unstable-2020-12-04";

  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = "ardupilot_wiki";
    rev = "834c95ff5e31167c7140406dc4975b7a2a7e2e11";
    sha256 = "0kh4irqs8lr1hcc6qjm1jqf1nw8m1cm7r6kpwgl348nfxza9bvc5";
  };

  nativeBuildInputs = [ 
    python3Packages.sphinx 
    python3Packages.sphinx_rtd_theme
    python3Packages.sphinxcontrib-vimeo
    python3Packages.sphinxcontrib-youtube
    rsync 
  ];

  enableParallelBuilding = true;

  ALL_WIKIS= [ 
    "copter" 
    "plane" 
    "rover" 
    "antennatracker" 
    "dev" 
    "planner"
    "planner2" 
    "ardupilot" 
    "mavproxy" 
  ];

  buildPhase = ''
    mkdir -p $out
    for wiki in $ALL_WIKIS
    do
      cd $wiki
      make html
      mv build/html $out/$wiki
      cd ..
    done
  '';

  meta = with stdenv.lib; {
    description = "The complete ArduPilot wiki";
    homepage = "https://ardupilot.org/ardupilot/";
    license = licenses.cc-by-sa-30;
    maintainers = [ maintainers.wucke13 ];
  };
}
