{ stdenv, freetype, xlibs, lib, gtk2, nss, nspr, cairo, expat, alsaLib, cups,
  atk, gdk_pixbuf, fontconfig, gnome2, curl, glib, fetchurl, glibc, systemd, 
  dbus, libpulseaudio

}:


stdenv.mkDerivation rec {
  name = "minecraft-launcher-${version}";
  version = "2.1.5410";

  src = fetchurl {
    url = "https://launcher.mojang.com/download/Minecraft.deb";
    sha256 = "04p25hb3c88wslikvdkjqpcppzrd5ga6sl5w71ndsbrbqkkawss1";
  };

  sourceRoot = ".";
  unpackCmd = ''
    ar p "$src" data.tar.xz | tar xJ
  '';

  buildPhase = ":";   # nothing to build

  installPhase = ''
    mkdir -p $out/bin
    cp -R usr/share opt $out/

    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/minecraft-launcher.desktop \
      --replace /opt/ $out/opt/

    ln -s $out/opt/minecraft-launcher/minecraft-launcher $out/bin/minecraft-launcher
  '';

  dontPatchELF = true; # Needed for local libraries

  preFixup = let
    libPath = lib.makeLibraryPath [ stdenv.cc.cc.lib glibc ];

    libLibraryPath = lib.makeLibraryPath [ stdenv.cc.cc.lib glibc xlibs.libX11 curl ];

    libcefPath = lib.makeLibraryPath [
      gtk2 
      systemd 
      alsaLib 
      libpulseaudio
      glib nss gdk_pixbuf dbus nspr expat cups
      
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

      fontconfig
      gnome2.pango
      gnome2.GConf
      cairo
      atk
    ];

    in ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}:$out/opt/minecraft-launcher" \
        $out/opt/minecraft-launcher/minecraft-launcher

      patchelf \
        --set-rpath "${libcefPath}" \
        $out/opt/minecraft-launcher/libcef.so

      patchelf \
        --set-rpath "${libLibraryPath}:$out/opt/minecraft-launcher" \
        $out/opt/minecraft-launcher/liblauncher.so
      
    '';

    meta = with stdenv.lib; {
      homepage = https://minecraft.net/;
      description = "Minecraft launcher";
      license = licenses.proprietary;
      platforms = platforms.linux;
      maintainers = [ jorelali ];
    };
  }

  /*

  */
