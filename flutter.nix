{ pkgs ? import <nixpkgs> {} }:
rec {
  engine = pkgs.stdenv.mkDerivation rec {
    name = "flutter-engine";
    version = "184b6e36e87c3a131e12c125ef492eb28deb5f35";
    src = pkgs.fetchzip {
      url = "https://storage.googleapis.com/flutter_infra/flutter/${version}/dart-sdk-linux-x64.zip";
      sha256 = "0v0bdnn48xzc94d8687zc4zyisfdml16cvj75lr4a18iy6qs5jp4";
    };
    libPath = pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc ];
    dontConfigure = true;
    dontStrip = true;

    installPhase = ''
      mkdir $out
      cp -r . $out
    '';

    postFixup = ''
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $libPath \
        $out/bin/dart
    '';
  };

  flutter =
    let rev = "6c7b6833c928a68650021d90ae9c0b15f4a35946";
    in pkgs.stdenv.mkDerivation rec {
      name = "flutter";
      version = "v1.4.19";
      src = pkgs.fetchgit {
        url = "https://github.com/flutter/flutter.git";
        inherit rev;
        sha256 = "15wsl6rzfxy5pmr077jc5m41k4j2rgpffm0qmvzrz1wrsd6im8sc";
        leaveDotGit = true; # Important: flutter needs this to work...
      };
      dontConfigure = true;
      dontStrip = true;

      # Install engine
      buildPhase = ''
        mkdir -p bin/cache/dart-sdk
    	cp -r ${engine}/* bin/cache/dart-sdk         # $DART_SDK_PATH
        echo ${rev} > bin/cache/flutter_tools.stamp  # $STAMP_PATH

        # ISSUE: .packages doesn't exist...?
        ./bin/cache/dart-sdk/bin/dart \
          --snapshot=bin/cache/flutter_tools.snapshot \
         # --packages=packages/flutter_tools/.packages \
          packages/flutter_tools/bin/flutter_tools.dart

        # Rewrite the flutter script
        echo 'HERE="$(dirname "$(realpath -s $0)")"' > bin/flutter
        echo '"$HERE/cache/dart-sdk/bin/dart" "$HERE/cache/flutter_tools.snapshot" "$@"' >> bin/flutter

        # Not needed
        rm bin/flutter.bat
      '';

      installPhase = ''
    	mkdir $out
    	cp -r . $out
      '';
    };
  }
