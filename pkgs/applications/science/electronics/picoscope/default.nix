{ stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, gcc, mono6, glib
, gtk-sharp-2_0, gtk2-x11, libpicoipp, libusb, zlib }:

let 
  arch = "amd64"; # TODO add support for armhf
  drivers = [
    { 
      name = "libpl1000";
      version = "2.0.40-1r2131";
      sha256 = "0qhp5lk7ly9hm9hxvhaxkzbi3dg7zczlibq3n609aimycas7a6nd";
    }
    { 
      name = "libplcm3";
      version = "2.0.17-1r1441";
      sha256 = "0czgbxdkph13cwqrkfkbvbaikqq5p2lr82536k86nqlkypqsbxid";
    }
    { 
      name = "libps2000";
      version = "3.0.40-3r2131";
      sha256 = "0qgs9lj27s37zs2x3614aq0a8y8k9a00sajka67kwkbhb2g5vhb8";
    }
    { 
      name = "libps2000a";
      version = "2.1.40-5r2131";
      sha256 = "1k4q1bbkn8wsrjq1xwxvn2bn3i5kcmmxsqbrx6wmyfg485bid7wy";
    }
    { 
      name = "libps3000";
      version = "4.0.40-3r2131";
      sha256 = "0kafdqd28slwb6rcfj6h6z83rmys2rsx45gwdgjilzl5k6sac74z";
    }
    { 
      name = "libps3000a";
      version = "2.1.40-6r2131";
      sha256 = "187bgpdvpmsxh9j9j4i2dg9rjrmn8qcmvskzfdb8w4r8r8jqgm3i";
    }
    { 
      name = "libps4000";
      version = "2.1.40-2r2131";
      sha256 = "1s1jx797xswx6swk0f2zi8vnb9nfiw5bpf648wqampqnfwvdcn80";
    }
    { 
      name = "libps4000a";
      version = "2.1.40-2r2131";
      sha256 = "1pwrm4fk91n7sfz42a7w5w9pv881099ilggsmv86bbq4941kifkx";
    }
    { 
      name = "libps5000";
      version = "2.1.40-3r2131";
      sha256 = "1qn2v2qqiqa22ak9jr9w9bl402p7s2sziiw80c6vy9ykrrvr3kv9";
    }
    { 
      name = "libps5000a";
      version = "2.1.40-5r2131";
      sha256 = "0c98q816db3b4s0r4lmxhajbfw8xvlkdygffsxfjbqfqlhhm6d5g";
    }
    { 
      name = "libps6000";
      version = "2.1.40-6r2131";
      sha256 = "1j7bxpyscf4fxd8pkmqgzwg78phxyd02kal39g0cw2vjsn94svms";
    }
    { 
      name = "libps6000a";
      version = "1.0.40-0r2131";
      sha256 = "0i66sgnc7p813jqsw0mcz3sck5s7584hd0jpazx94hfhwr3hn1hp";
    }
  ];
in stdenv.mkDerivation rec {
  pname = "picoscope";
  version = "6.14.23-4r580";

  srcs = [ 
    (fetchurl {
      url = "https://labs.picotech.com/debian/pool/main/p/${pname}/${pname}_${version}_all.deb";
      sha256 = "14k4fj8zlnrkaqz1igji1jx21dxsbbdg7gf38c5s104k5cnc85lq";
    }) 
  ] ++ map (args: fetchurl {
    url = "https://labs.picotech.com/debian/pool/main/libp/${args.name}/${args.name}_${args.version}_${arch}.deb";
    sha256 = args.sha256;
  }) drivers;

  nativeBuildInputs = [ dpkg autoPatchelfHook makeWrapper ];
  buildInputs = [ (stdenv.lib.getLib gcc.cc) libusb zlib ];

  unpackCmd = ''
    dpkg -x $curSrc unpacked
    sourceRoot=$PWD/unpacked
  '';

  installPhase = ''
    mkdir $out
    mv opt/picoscope/* $out/
    mv usr/share/applications $out/share/
  '';

  preFixup = ''
    MPATH="$out/lib:${gtk-sharp-2_0}/lib/mono/gtk-sharp-2.0:${glib.out}/lib:${gtk2-x11}/lib:${gtk-sharp-2_0}/lib:${libpicoipp}/lib"
    makeWrapper ${mono6}/bin/mono $out/bin/picoscope \
      --prefix MONO_PATH : "$MPATH" \
      --prefix LD_LIBRARY_PATH : "$MPATH" \
      --add-flags $out/lib/PicoScope.GTK.exe
    '';
}
