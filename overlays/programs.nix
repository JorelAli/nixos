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

  minecraft-launcher = super.callPackage ./../extrapackages/minecraft-launcher.nix {};

  ### Breeze Adapta #############################
  # Some cursor inspired by Breeze or something #
  ###############################################

  breeze-adapta = super.callPackage ./../extrapackages/breezeAdaptaCursor.nix {};

}
