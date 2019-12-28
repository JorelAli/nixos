{ stdenv, freetype, xlibs, lib, gtk2, nss, nspr, cairo, expat, alsaLib, cups,
  atk, gdk_pixbuf, fontconfig, gnome2, curl, glib, fetchurl, glibc, systemd, 
  dbus, libpulseaudio, makeWrapper, libXxf86vm, zlib, gtk3-x11, makeDesktopItem }:

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
    url = "https://launcher.mojang.com/download/linux/x86_64/minecraft-launcher_2.1.9618.tar.gz";
    sha256 = "1wk7414i9n6yvhhc0g3cpqjs4ryklmdp2pxgvfdg9zibjdx0avvy";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];

  nativeBuildInputs = [ makeWrapper ];

  mclibPath = stdenv.lib.makeLibraryPath [
    libpulseaudio
    libXxf86vm # Needed only for versions <1.13
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt/minecraft-launcher
    cp -R . $out/opt/minecraft-launcher

    # fix the path in the desktop file
    #substituteInPlace \
    #  $out/share/applications/minecraft-launcher.desktop \
    #  --replace /opt/ $out/opt/

    makeWrapper $out/opt/minecraft-launcher/minecraft-launcher $out/opt/minecraft-launcher/minecraft-launcher-wrapper \
      --suffix LD_LIBRARY_PATH : ${mclibPath}

    ln -s $out/opt/minecraft-launcher/minecraft-launcher-wrapper $out/bin/minecraft-launcher

    #mkdir -pv $out/share/applications
    #ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  dontPatchELF = true; # Needed for local libraries

  preFixup = let
    libPath = lib.makeLibraryPath [ 
      glibc 
      stdenv.cc.cc.lib 
    ];

    liblauncherPath = lib.makeLibraryPath [ 
      curl 
      glibc 
      stdenv.cc.cc.lib 
      xlibs.libX11 

      zlib
      gtk3-x11
      atk
      cairo
      gdk_pixbuf
      glib
      
    ];

    libcefPath = lib.makeLibraryPath [
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
        --set-rpath "${liblauncherPath}:$out/opt/minecraft-launcher" \
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
