{ stdenv, fetchFromGitHub, cmake, gfortran, bc, blas, boost, doxygen
, hdf5-mpi, liblapack , matio, netcdf-mpi, openmpi, perl, python3Packages, swig
, xorg, packages ? null }:

stdenv.mkDerivation rec {
  pname = "trilinos";
  version = "release-12-18-1";

  src = fetchFromGitHub {
    owner = "trilinos";
    repo = "Trilinos";
    rev = "${pname}-${version}";
    sha256 = "0fnwlhzsh85qj38cq3igbs8nm1b2jdgr2z734sapmyyzsy21mkgp";
  };

  postPatch = ''
  '';

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [ bc cmake doxygen gfortran ];
  buildInputs = with python3Packages; [ 
    blas
    boost.dev
    hdf5-mpi
    liblapack
    matio
    numpy
    netcdf-mpi
    openmpi
    perl
    python
    swig
    xorg.libX11.dev 
  ];

  # if hdf5 is no enabled explictly, some deps fail to find it
  cmakeFlags = [ 
    "-DBUILD_SHARED_LIBS:BOOL=ON"
    "-DMPI_BASE_DIR:FILEPATH=${openmpi}"
    "-DMPI_EXEC:FILEPATH=${openmpi}/bin/mpiexec"
    "-DTPL_ENABLE_HDF5:BOOl=ON"
    "-DTPL_ENABLE_MPI:BOOL=ON"
  ] ++ stdenv.lib.optionals (packages == null ) [ "-DTrilinos_ENABLE_ALL_PACKAGES:BOOL=ON" ]
  ++ stdenv.lib.optionals (packages != null) (map (p: "Trilinos_ENABLE_${p}:BOOL=ON" ) packages);
  
  meta = with stdenv.lib; {
    description = "Framework for engineering and scientific problems";
    longDescription = ''
      The Trilinos Project is an effort to develop algorithms and enabling
      technologies within an object-oriented software framework for the
      solution of large-scale, complex multi-physics engineering and scientific
      problems. A unique design feature of Trilinos is its focus on packages.
    '';
    homepage = "https://trilinos.github.io/";
    platforms = platforms.all;
    license = with license; [ free ]; # bsd gpl lgpl
  };
}
