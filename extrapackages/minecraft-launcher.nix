{ stdenv, freetype, xlibs, lib, gtk2, nss, nspr, cairo, expat, alsaLib, cups,
  atk, gdk_pixbuf, fontconfig, gnome2, curl, glib, fetchurl, glibc, systemd, 
  dbus, libpulseaudio, makeWrapper, libXxf86vm, makeDesktopItem

}:

/*
IMPORTANT NOTE on how to get sound working:

You need to put libpulseaudio in the LD_LIBRARY_PATH. To do this,
use:

stdenv.lib.makeLibraryPath [ libpulseaudio ] (While you're at it, 
probs include xorg.libXxf86vm for previous versions of Minecraft)

And somehow, probably using the makeWrapper command, turn Minecraft
into a wrapper with the new LD_LIBRARY_PATH or somethng.
*/

let
  desktopItem = makeDesktopItem {
    name = "minecraftlauncher";
    comment = "Official Minecraft Launcher";
    exec = "minecraft-launcher";
    icon = "minecraft-launcher";
    categories = "Application;Game;";
    desktopName = "Minecraft Launcher";
  };
in stdenv.mkDerivation rec {
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

  nativeBuildInputs = [ makeWrapper ];

  mclibPath = stdenv.lib.makeLibraryPath [
    libpulseaudio
    libXxf86vm # Needed only for versions <1.13
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -R usr/share opt $out/

    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/minecraft-launcher.desktop \
      --replace /opt/ $out/opt/

    makeWrapper $out/opt/minecraft-launcher/minecraft-launcher $out/opt/minecraft-launcher/minecraft-launcher-wrapper \
      --suffix LD_LIBRARY_PATH : ${mclibPath}

    ln -s $out/opt/minecraft-launcher/minecraft-launcher-wrapper $out/bin/minecraft-launcher

    mkdir -pv $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
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
