{ stdenv, fetchurl, makeWrapper, makeDesktopItem
, jdk, perl, python, unzip, which
}:

let
  desktopItem = makeDesktopItem {
    name = "netbeans";
    exec = "netbeans";
    comment = "Integrated Development Environment";
    desktopName = "Netbeans IDE";
    genericName = "Integrated Development Environment";
    categories = "Application;Development;";
  };
in
stdenv.mkDerivation {
  name = "netbeans-9.0";
  src = fetchurl {
    url = http://www-eu.apache.org/dist/incubator/netbeans/incubating-netbeans-java/incubating-9.0/incubating-netbeans-java-9.0-bin.zip;
    sha256 = "18y3202ai0n2h1yp1i4jxd1q5xq47kh20pbn3wr6sfpa9svsbhpm";
  };

  buildCommand = ''
    # Unpack and perform some path patching.
    unzip $src
    patchShebangs .

    # Copy to installation directory and create a wrapper capable of starting
    # it.
    mkdir -p $out/bin
    cp -a netbeans $out
    makeWrapper $out/netbeans/bin/netbeans $out/bin/netbeans \
      --prefix PATH : ${stdenv.lib.makeBinPath [ jdk which ]} \
      --prefix JAVA_HOME : ${jdk.home} \
      --add-flags "--jdkhome ${jdk.home}"

    # Create desktop item, so we can pick it from the KDE/GNOME menu
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  buildInputs = [ makeWrapper perl python unzip ];

  meta = {
    description = "An integrated development environment for Java, C, C++ and PHP";
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
