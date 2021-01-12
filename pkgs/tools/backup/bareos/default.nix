{ stdenv, fetchFromGitHub, cmake, pkgconfig, libpam-wrapper, nettools, gettext
, flex, python3
, gtest ? null, gmock ? null , readline ? null, openssl ? null, ncurses ? null
, sqlite ? null, postgresql ? null, libmysqlclient ? null , zlib ? null
, lzo ?  null , jansson ? null, acl ? null, glusterfs ? null, libceph ? null
, libcap ?  null
}:

assert sqlite != null || postgresql != null || libmysqlclient != null;

with stdenv.lib;
let
  withGlusterfs = "\${with_glusterfs_directory}";
in
stdenv.mkDerivation rec {
  pname = "bareos";
  version = "20.0.0";

  src = fetchFromGitHub {
    owner = "bareos";
    repo = "bareos";
    rev = "Release/${version}";
    name = "${pname}-${version}-src";
    sha256 = "1wnq8z0y2d4bl8m8240ak4v2yg0180izga8zm3237bcfvrcrjw15";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    python3 

    libpam-wrapper 
    nettools gettext readline openssl ncurses sqlite postgresql
    libmysqlclient zlib lzo jansson acl glusterfs libceph libcap
  ];

  #postPatch = ''
  #  sed -i 's,\(-I${withGlusterfs}/include\),\1/glusterfs,' configure
  #'';
  cmakeFlags = optional (sqlite != null) "-Dsqlite3=yes"
    ++ optional (libmysqlclient != null) "-Dmysql=yes"
    ++ optional (sqlite != null) "-Dsqlite3=yes"
  ;

  #configureFlags = [
  #  "--sysconfdir=/etc"
  #  "--exec-prefix=\${out}"
  #  "--enable-lockmgr"
  #  "--enable-dynamic-storage-backends"
  #  "--with-basename=nixos" # For reproducible builds since it uses the hostname otherwise
  #  "--with-hostname=nixos" # For reproducible builds since it uses the hostname otherwise
  #  "--with-working-dir=/var/lib/bareos"
  #  "--with-bsrdir=/var/lib/bareos"
  #  "--with-logdir=/var/log/bareos"
  #  "--with-pid-dir=/run/bareos"
  #  "--with-subsys-dir=/run/bareos"
  #  "--enable-ndmp"
  #  "--enable-lmdb"
  #  "--enable-batch-insert"
  #  "--enable-dynamic-cats-backends"
  #  "--enable-sql-pooling"
  #  "--enable-scsi-crypto"
  #] ++ optionals (readline != null) [ "--disable-conio" "--enable-readline" "--with-readline=${readline.dev}" ]
  #  ++ optional (python2 != null) "--with-python=${python2}"
  #  ++ optional (openssl != null) "--with-openssl=${openssl.dev}"
  #  ++ optional (sqlite != null) "--with-sqlite3=${sqlite.dev}"
  #  ++ optional (postgresql != null) "--with-postgresql=${postgresql}"
  #  ++ optional (libmysqlclient != null) "--with-mysql=${libmysqlclient}"
  #  ++ optional (zlib != null) "--with-zlib=${zlib.dev}"
  #  ++ optional (lzo != null) "--with-lzo=${lzo}"
  #  ++ optional (jansson != null) "--with-jansson=${jansson}"
  #  ++ optional (acl != null) "--enable-acl"
  #  ++ optional (glusterfs != null) "--with-glusterfs=${glusterfs}"
  #  ++ optional (libceph != null) "--with-cephfs=${libceph}";

  #installFlags = [
  #  "sysconfdir=\${out}/etc"
  #  "confdir=\${out}/etc/bareos"
  #  "scriptdir=\${out}/etc/bareos"
  #  "working_dir=\${TMPDIR}"
  #  "log_dir=\${TMPDIR}"
  #  "sbindir=\${out}/bin"
  #];

  meta = with stdenv.lib; {
    homepage = "http://www.bareos.org/";
    description = "A fork of the bacula project";
    license = licenses.agpl3;
    platforms = platforms.unix;
    broken = false;
  };
}
