self: super: {

  ### Clairvoyance SDDM Theme ###########################
  # Custom nix derivation for the Clairvoyance SDDM     #
  # theme by eayus:                                     #
  #   https://github.com/eayus/sddm-theme-clairvoyance  #
  #######################################################

  clairvoyance = super.callPackage ./../extrapackages/clairvoyance.nix {
    autoFocusPassword = true;
    backgroundURL = "https://wallpapercave.com/wp/wp1860715.jpg";
  };

  ### Typora Markdown Editor ###############################
  # Typora - another markdown editor with fancy features   #
  # (such as exporting to PDF). This overrides the build   #
  # script for typora, in particular:                      #
  #   --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \ #
  # Which fixes a bug where GTK+ doesn't interact with     #
  # Typora properly.                                       #
  ##########################################################

  typora = super.typora.overrideAttrs (oldAttrs: {
    postFixup = (builtins.substring 0 (builtins.stringLength oldAttrs.postFixup - 1)) 
      oldAttrs.postFixup + 
      " \\\n --prefix XDG_DATA_DIRS : \"$GSETTINGS_SCHEMAS_PATH\"\n";
  });

  ### Google Play Music Desktop Player #####################
  # Fixes a bug (similar to Typora) where the file chooser #
  # doesn't open properly because it's not linked properly #
  ##########################################################

  google-play-music-desktop-player = super.google-play-music-desktop-player.overrideAttrs (oldAttrs: {
    installPhase = (builtins.substring 0 (builtins.stringLength oldAttrs.installPhase - 1)) 
      oldAttrs.installPhase + 
      " \\\n --prefix XDG_DATA_DIRS : \"$GSETTINGS_SCHEMAS_PATH\"\n";

    buildInputs = oldAttrs.buildInputs ++ [ self.gtk3 ];

  });

  ### Mahjong ###########################################
  # I don't want my mahjong "postmodern" theme showing  #
  # the gnome icon, so I changed it to the Nix icon     #
  # (Inspired by ubuntu's mahjongg which has the ubuntu #
  # icon instead of the gnome icon)                     #
  #######################################################

  mahjong = super.gnome3.gnome-mahjongg.overrideAttrs (oldAttrs: {
    postInstall = ''
      mkdir -p $out/share/gnome-mahjongg/themes/
      cp -f ${builtins.fetchurl "file:///etc/nixos/programconfigs/postmodern.svg"} $out/share/gnome-mahjongg/themes/postmodern.svg
    '';
  });

  ### LXAppearance - GTK Themer  ########################
  # Version 0.6.2 has support for BOTH GTK2 and GTK3.   #
  # The latest version on NixOS' stable channel doesn't #
  # support both GTK2 and GTK3, it only supports GTK3.  #
  #######################################################
  
  lxappearance-062 = super.lxappearance.overrideAttrs(old: rec {
      name = "lxappearance-0.6.2";
      src = self.fetchurl {
        url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
        sha256 = "07r0xbi6504zjnbpan7zrn7gi4j0kbsqqfpj8v2x94gr05p16qj4";
      };
  });

  ### Minecraft Launcher ####################
  # The new Minecraft Launcher (executable) #
  # as opposed to the Java-based launcher   #
  ###########################################

  minecraft-launcher = super.callPackage ./../extrapackages/minecraft-launcher2.nix {};

  ### Freetube ################
  # An alternative to YouTube #
  #############################
  
  freetube = import ./../extrapackages/freetube.nix ;

  ### VSCode ###############
  # VSCode with extensions #
  ##########################

  code = super.vscode-with-extensions.override {
    vscode = super.vscodium;
    # When the extension is already available in the default extensions set.
    vscodeExtensions = with super.vscode-extensions; [
        ms-vscode.cpptools
        ms-python.python
#        vscodevim.vim
        skyapps.fish-vscode
        redhat.vscode-yaml
        llvm-org.lldb-vscode

        # Elm support
        
        (super.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "elm";
              publisher = "sbrink";
              version = "0.25.0";
              sha256 = "1djsif15s13k762f1yyffiprlsm18p4b8fmc8cxs5w5z8xfb2wp8";
            };
            meta = {
              license = self.stdenv.lib.licenses.mit;
            };
          })

        # Elm support
        #(super.vscode-utils.buildVscodeMarketplaceExtension {
        #    mktplcRef = {
        #      name = "elm-ls-vscode";
        #      publisher = "Elmtooling";
        #      version = "0.9.4";
        #      sha256 = "12w3nmjvzg6740q2y3diw7s2q9vs50wiahwh9915r389ngyb020r";
        #    };
        #    meta = {
        #      license = stdenv.lib.licenses.mit;
        #    };
        #  })

        # Pico-8 support
        (super.vscode-utils.buildVscodeMarketplaceExtension {
           mktplcRef = {
             name = "pico8vscodeeditor";
             publisher = "Grumpydev";
             version = "0.2.3";
             sha256 = "0xaaxddljcv2jf47nriwkrmdb4v26qi9lh5yvd0947sg0b0sqm32";
           };
           meta = {
             license = self.stdenv.lib.licenses.mit;
           };
         })
        
        # Git Graph
        (super.vscode-utils.buildVscodeMarketplaceExtension {
           mktplcRef = {
             name = "git-graph";
             publisher = "mhutchie";
             version = "1.21.0";
             sha256 = "0prj1ymv5f9gwm838jwdi2gbqh40gc0ndpi17yysngcyz9fzym98";
           };
           meta = {
             license = self.stdenv.lib.licenses.mit;
           };
         })
    ];
  };

}
