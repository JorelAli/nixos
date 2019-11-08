# TODO: Sort out this import
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "FreeTube";
  version = "0.1";
  
  src = fetchurl {
    url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v0.7.1-beta/FreeTube-0.7.1-linux.tar.xz";
    sha256 = "06zn624wvffpl5a7dh8c5dx6aml5dd1rlnazba86xcjc0vkagjw6";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [ makeWrapper ];

  mclibPath = stdenv.lib.makeLibraryPath [
    libpulseaudio
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt/freetube
    cp -R . $out/opt/freetube

    makeWrapper $out/opt/freetube/freetube $out/opt/freetube/freetube-wrapper \
      --suffix LD_LIBRARY_PATH : ${mclibPath} \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

    ln -s $out/opt/freetube/freetube-wrapper $out/bin/freetube
  '';

  dontPatchELF = true; # Needed for local libraries

  # TODO: Clean up this list
  preFixup = let
    libPath = lib.makeLibraryPath [ 
      glibc 
      stdenv.cc.cc.lib 
      libuuid

      alsaLib 
      atk
      cairo
      cups
      dbus 
      expat 
      fontconfig
      gdk_pixbuf 
      glib 
      gnome2.pango
      gnome2.GConf
      gtk2 
      libpulseaudio
      nspr 
      nss 
      systemd 
      xlibs.libX11
      xlibs.libxcb
      xlibs.libXcomposite
      xlibs.libXcursor
      xlibs.libXdamage
      xlibs.libXext
      xlibs.libXfixes
      xlibs.libXi
      xlibs.libXrender
      xlibs.libXtst
      xlibs.libXScrnSaver
      xlibs.libXrandr

      gtk3-x11
      at_spi2_atk
      at_spi2_core

    ];

    in ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}:$out/opt/freetube" \
        $out/opt/freetube/freetube

    '';
      #patchelf \
      #  --set-rpath "${libcefPath}" \
      #  $out/opt/freetube/libcef.so

      #patchelf \
      #  --set-rpath "${liblauncherPath}:$out/opt/freetube" \
      #  $out/opt/freetube/liblauncher.so

  meta = with stdenv.lib; {
    homepage = https://freetubeapp.io/;
    description = "Minecraft launcher";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ jorelali ];
  };
}
