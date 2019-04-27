{stdenv, fetchurl, unzip, runtimeShell, makeDesktopItem, nwjs }:

let
  strippedName = "inav-configurator";
  desktopItem = makeDesktopItem {
    name = strippedName;
    exec = strippedName;
    icon = "${strippedName}-icon.png";
    comment = "INAV configuration tool";
    desktopName = "INAV Configurator";
    genericName = "Flight controller configuration tool";
  };
in
stdenv.mkDerivation rec {
  name = "${strippedName}-${version}";
  version = "2.1.4";
  src = fetchurl {
    url = "https://github.com/iNavFlight/inav-configurator/releases/download/${version}/INAV-Configurator_linux64_${version}.zip";
    sha256 = "0rs3wv3c441ic58z1vnmn8smlryy10d8qfa7z8v8i8jgqcq7nhsk";
  };

  buildInputs = [ unzip ];
  
  installPhase = ''
    mkdir -p $out/bin \
             $out/opt/${strippedName} \
             $out/share/icons
    cp -r . $out/opt/${strippedName}/
    ls 
    cp icon/*_icon_128.png $out/share/icons/${strippedName}-icon.png
    cp -r ${desktopItem}/share/applications $out/share/
    cat >$out/bin/${strippedName}<<EOL
    #!${runtimeShell}
    ${nwjs}/bin/nw $out/opt/${strippedName} 
    EOL
    chmod +x $out/bin/${strippedName}
  '';

  meta = with stdenv.lib; {
    description = "The Betaflight flight control system configuration tool";
    longDescription = ''
      A crossplatform configuration tool for the Betaflight flight control system.
      Various types of aircraft are supported by the tool and by Betaflight, e.g. 
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage    = https://github.com/iNavFlight/inav/wiki;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ wucke13 ];
    platforms   = platforms.linux;
  };
}
