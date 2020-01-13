{ mkDerivation, fetchFromGitHub, lib, cmake, extra-cmake-modules, qtbase,
  qtdeclarative, qtwayland, qtgraphicaleffects, qtquickcontrols2, qtsvg }:

mkDerivation rec {
  pname = "liri-shell";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lirios";
    repo = "shell";
    rev = "v${version}";
    sha256 = "1k9km4d38ga8217vq6m22c2350vdnxb4yilak4zg15jnw90506ai";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ 
    qtbase 
    qtdeclarative
    qtwayland
    qtgraphicaleffects
    qtquickcontrols2
    qtsvg
  ];

  meta = with lib; {
    description = "Responsive shell for the Liri desktop.";
    homepage = "https://liri.io/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wucke13 ];
  };
}

#gcc >= 4.8 or
#Clang
#
#Qt >= 5.12.0 with at least the following modules is required:
#
#qtbase
#qtdeclarative
#qtwayland
#qtgraphicaleffects
#qtquickcontrols2
#qtsvg
#
#The following modules and their dependencies are required:
#
#cmake >= 3.10.0
#cmake-shared >= 1.0.0
#fluid >= 1.0.0
#qtaccountsservice >= 1.2.0
#qtgsettings >= 1.1.0
#libliri
#liri-wayland
#pam
#polkit-qt5
#solid
#
#Optional dependencies:
#
#qml-xwayland
#
#-DINSTALL_SYSTEMDUSERUNITDIR=/path/to/systemd/user: Path to install systemd user units (default: /usr/local/lib/systemd/user).
#
#0.9.0
