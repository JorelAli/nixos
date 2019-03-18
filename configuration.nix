# My glorious all powerful NixOS configuration file
# https://github.com/JorelAli/nixos

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  ### Boot Settings ############################################################

  # Enable exFAT format for USB/External HDD
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Search for other operating systems
  boot.loader.grub.useOSProber = true;

  ### Networking Settings ######################################################

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # If stuck, use the 'nm-connection-editor' command

  ### Regional Settings ########################################################

  time.timeZone = "Europe/London";

  ### Environment Variables ####################################################

  environment.variables = {

    QT_QPA_PLATFORMTHEME = "qt5ct";

    XCURSOR_PATH = [
      "${config.system.path}/share/icons"
      "$HOME/.icons"
      "$HOME/.nix-profile/share/icons"
    ];

    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
   #XDG_DATA_DIRS = "/nix/store/4nbisdmcv7max2h2xjviqg5gbbvpvqyh-gtk+3-3.22.30/share/gsettings-schemas/gtk+3-3.22.30/";

  };

  ### /etc/ Files ##############################################################

  # Settings file for GTK 3
  environment.etc."xdg/gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-icon-theme-name=breeze
      gtk-theme-name=Breeze-gtk
    '';
  };

  # Settings file for GTK 2
  environment.etc."xdg/gtk-2.0/gtkrc" = {
    text = ''
      gtk-icon-theme-name = "breeze"
      gtk-theme-name = "Breeze-gtk"
    '';
  };

  # A failed attempt to enable scroll support for i3status-rust
  #environment.etc."udev/rules.d/backlight.rules" = {
  #  text = ''
  #    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
  #    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
  #  '';
  #};

  ### System Packages ##########################################################

  environment.systemPackages = with pkgs; [

    # Definitely. This. First.
    # By placing this first, I believe this installs the correct version of Qt
    # which prevents conflicts with other programs
    qutebrowser                         # Lightweight minimal browser

    ### Command line utilities #################################################

    fish                                # Friendly Interface SHell

    ## My Fish setup ####################################
    # Color scheme:                                     #
    #   curl -L https://get.oh-my.fish | fish           #
    #   omf install agnoster                            #
    # Highlight Colors:                                 #
    #   set fish_color_search_match --background=d33682 #
    #####################################################

    git                                 # Version control
    gnumake3                            # 'make' command to build executables
    p7zip                               # 7z zip manager
    ranger                              # Terminal file manager
    rofi                                # Window switcher & App launcher
    rtv                                 # Reddit in terminal
    ruby                                # Ruby (Programming language)
    screenfetch                         # Display info about themes to console
    speedtest-cli                       # Speed test in terminal
    tree                                # Print file tree in terminal
    unzip                               # Command to unzip files
    wget                                # Download web files
    youtube-dl                          # YouTube downloader
    zip                                 # Command to zip files

    ### Applications ###########################################################

    arandr                              # Multiple display manager
    ark                                 # Archive manager
    atom                                # Glorified text editor
    chromium                            # Opensource Chrome browser
    deluge                              # Torrent client
    ghostwriter                         # Markdown editor
    gimp                                # Image editor
    gitkraken                           # Version control management software
    google-play-music-desktop-player    # Google Play Music for desktop
    gparted                             # Partition manager
    inkscape                            # Vector artwork
    libreoffice-fresh                   # Documents/Spreadsheets/Presentations
    libsForQt5.vlc                      # Video player (VLC)
    redshift                            # Screen temperature changer
    shutter                             # Screenshot tool
    sqlitebrowser                       # SQLite .db file browser

    # Typora - another markdown editor with fancy features
    # (such as exporting to PDF). This overrides the build
    # script for typora, in particular:
    # --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
    # Which fixes a bug where GTK+ doesn't interact with
    # Typora properly.
    (pkgs.typora.overrideAttrs (oldAttrs: {
      installPhase = ''
        mkdir -p $out/bin $out/share/typora
        {
          cd usr
          mv share/typora/resources/app/* $out/share/typora
          mv share/applications $out/share
          mv share/icons $out/share
          mv share/doc $out/share
        }
        makeWrapper ${electron_3}/bin/electron $out/bin/typora \
          --add-flags $out/share/typora \
          "''${gappsWrapperArgs[@]}" \
          --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
          --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}"
        '';
    }))

    vscode                              # Code editor

    ### System-wide theming ####################################################

    breeze-icons                        # Breeze theme icons
    gnome3.adwaita-icon-theme           # Adwaita theme icons
    hicolor_icon_theme                  # Hicolor theme icons

    lxappearance                        # Program to theme GTK+
    qt5ct                               # Program to theme Qt5 (Fixes dolphin on i3)

    arc-theme                           # Arc theme for GTK+

    i3lock-color
    i3lock-fancy

    (import ./clairvoyance.nix)

    ### Games ##################################################################

    minecraft                           # Minecraft video game
    pacvim                              # Game that teaches you vim
    #steam
    #steam-run
    #steamcontroller
    zeroad                              # 0ad video game - like Age of Empires

    ### Other random stuff #####################################################

    cool-retro-term                     # A retro looking terminal for showing off
    elinks                              # Useless terminal based browser
    sl                                  # Display a steam locomotive in terminal

    ### Programming (Java) #####################################################
    ant                                 # Java building thingy
    eclipses.eclipse-sdk                # Eclipse IDE for Java
    maven                               # Java dependency manager
    openjdk10                           # Java Development Kit for Java 10

    ### Programming (Other) ####################################################

    gcc                                 # C/C++ compiler
    python                              # Python 2.7.15
    python27Packages.debian             # Python 2.7 'debian' package
    python3                             # Python 3.6.8

    ### Programming (Rust) #####################################################

    cargo                               # Rust package manager
    rustc                               # Rust compiler

    ### Programming (Haskell) ##################################################

    cabal-install                       # CLI for Cabal + Hackage (for Haskell)
    ghc                                 # Haskell compiler
    stack                               # Haskell compiler + package manager
    zlib                                # Some zipping library for C?

    haskellPackages.hoogle              # Haskell documentation database
    haskellPackages.container           # Represents Haskell containers (e.g. Monoid)
    haskellPackages.zlib                # Compression library for Haskell

    ### How to get the best Haskell setup ###############################################
    # Install the following system packages: stack cabal-install ghc cachix atom zlib   #
    #                                                                                   #
    # To install hie (Haskell IDE Engine):                                              #
    #   1) "cachix use hie-nix"                                                         #
    #   2) "nix-env -iA hies -f https://github.com/domenkozar/hie-nix/tarball/master"   #
    #                                                                                   #
    # Optional: Install Hasklig font (I use Fira Code Medium)                           #
    #                                                                                   #
    # Install the following packages for atom (using the built in package manager):     #
    #   atom-ide-ui                                                                     #
    #   ide-haskell-hie                                                                 #
    #   language-haskell                                                                #
    #                                                                                   #
    # In atom, Ctrl + , ide-haskell-hie package:                                        #
    #   Settings -> Absolute path to hie executable                                     #
    #   => hie-wrapper                                                                  #
    #                                                                                   #
    # Optional: git clone hie-nix and run the ./update.sh file                          #
    #                                                                                   #
    # In ~/.stack/config.yaml:                                                          #
    #   nix:                                                                            #
    #     enable: true                                                                  #
    #     packages: [zlib.dev, zlib.out]                                                #
    #####################################################################################

    ### GUI/Window Manager #####################################################

    # i3status-rust        coming soon: https://github.com/JorelAli/i3status-rust
    # i3status-rust                     # Better i3 status bar

    ### System tools ###########################################################

    networkmanagerapplet                # GUI for networking
    ntfs3g                              # Access a USB drive

    universal-ctags                     # Tool for browsing source code quickly

    xorg.xbacklight                     # Enable screen backlight adjustments
    xorg.xev                            # Program to find xmodmap key-bindings
    xorg.xmodmap                        # Keyboard key remapping

    ### Nix related stuff ######################################################

    cachix                              # Compiled binary hosting for Nix

    ### Dictionaries ###
    hunspell                            # Dictionary for GhostWriter
    hunspellDicts.en-gb-ise             # English (GB with '-ise' spellings)
    hunspellDicts.en-us                 # English (US)

    ### Vim (with my chosen packages of choice) ################################

    (
        with import <nixpkgs> {};

        vim_configurable.customize {
            # Specifies the vim binary name.
            # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
            # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
            name = "vim";

            # List of stuff that would go in ~/.vimrc

            vimrcConfig.customRC = ''
                syntax enable
                set tabstop=4
                set background=dark
                colorscheme solarized
                set number
                set mouse=a
                let g:airline_powerline_fonts = 1
                let g:NERDTreeWinSize=20
                autocmd VimEnter *.rs TagbarOpen
                set backspace=indent,eol,start

                let g:rbpt_colorpairs = [
                    \ ['brown',       'RoyalBlue3'],
                    \ ['Darkblue',    'SeaGreen3'],
                    \ ['darkgray',    'DarkOrchid3'],
                    \ ['darkgreen',   'firebrick3'],
                    \ ['darkcyan',    'RoyalBlue3'],
                    \ ['darkred',     'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['brown',       'firebrick3'],
                    \ ['gray',        'RoyalBlue3'],
                    \ ['black',       'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['Darkblue',    'firebrick3'],
                    \ ['darkgreen',   'RoyalBlue3'],
                    \ ['darkcyan',    'SeaGreen3'],
                    \ ['darkred',     'DarkOrchid3'],
                    \ ['red',         'firebrick3'],
                    \ ]

                let g:rbpt_max = 16
                let g:rbpt_loadcmd_toggle = 0

                au VimEnter * RainbowParenthesesToggle
                au Syntax * RainbowParenthesesLoadRound
                au Syntax * RainbowParenthesesLoadSquare
                au Syntax * RainbowParenthesesLoadBraces
            '';

            ### Vim plugins (installed via VAM) ################################

            vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
            vimrcConfig.vam.pluginDictionaries = [
                { names = [
                        "Syntastic"                # Fancy syntax errors + status
                        "ctrlp"                    # Fuzzy finder
                        "vim-airline"             # Fancy status bar
                        "vim-airline-themes"      # Fancy status bar themes
                        "nerdtree"                # File tree on the side of vim
                        "youcompleteme"           # Code completer
                        #TODO: This needs to be enabled using install.py!!

                        "solarized"               # Solarized theme
                        "rainbow_parentheses"     # Rainbow brackets for easy brackets
                        "vim-nix"                 # Syntax etc. for .nix files
                        "vim-toml"                # Syntax etc. for .toml files
                        "gitgutter"               # Shows git changes in sidebar
                        "tagbar"                  # Class outline viewer
                        "easymotion"
                ]; }
            ];
        }
    )


  ];

  programs.fish.enable = true;          # Fish shell

  # 'day' and 'night' aliases for redshift
  #programs.fish.shellAliases = {
  #    day = "redshift -x";
  #    night = "redshift -O 4500K";
  #};

  ### Fonts ####################################################################

  fonts.fonts = with pkgs; [

    fira-code-symbols                   # Fancy font with programming ligatures*
    fira-code                           # Fancy font with programming ligatures*
    font-awesome_4                      # Fancy icons font
    siji                                # Iconic bitmap font

    # *This means that -> will look like an actual arrow and
    # >= and <= actually look like less than or equal and greater
    # than or equal symbols, as opposed to what they look like on
    # a computer

  ];

  # Set default monospace font to the fancy ligatures font. Good for programming
  fonts.fontconfig.defaultFonts.monospace = [ "Fira Code Medium" ];

  ### Hardware Settings ########################################################

  # Enable sound. Duh.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Support for 32 bit stuff (for Steam)
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Use fingerprint recognition on the login screen to log
  # in. To add a fingerprint, use the 'fprintd-enroll' command
  # in the terminal, and scan your fingerprint a few times. I
  # disabled this because this can be a bit unreliable sometimes.
  # security.pam.services.login.fprintAuth = true;

  security.sudo.wheelNeedsPassword = false;  # Use 'sudo' without needing password

  ### Services #################################################################

  services = {

    # Adds support for scrolling to change the brightness for i3status-rs
    udev.extraRules = ''  
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    # Enable opacity for inactive programs
    compton = {
        enable = true;
        inactiveOpacity = "0.9";
#        opacityRules = [ "95:class_g = 'konsole'" ];
    };

    gnome3.gnome-disks.enable = true;   # Something something USBs
    udisks2.enable = true;              # Something something USBs

    #fprintd.enable = true;             # Fingerprint reader (Disabled -> unreliable)

    printing.enable = true;             # Printing (You know, to a printer...)
    upower.enable = true;               # Battery info

    xserver = {
      enable = true;                    # GUI for the entire computer
      layout = "gb";                    # Use the GB English keyboard layout

      libinput.enable = true;           # Touchpad support
      synaptics.twoFingerScroll = true; # Two finger scroll for touchpad
      synaptics.horizTwoFingerScroll = true;

      displayManager = {
        sddm.enable = true;             # Login screen manager
        sddm.theme = "clairvoyance";    # Ellis' clairvoyance theme for sddm
        sddm.extraConfig = ''
          [General]
          InputMethod=
          '';

        # Remap keys on start
        sessionCommands = ''
          xmodmap .Xmodmap
        '';
      };

      # Tiling manager to manage windows using keyboard
      # shortcuts instead of dragging and dropping
      windowManager.i3.package = pkgs.i3-gaps;
      windowManager.i3.enable = true;

      # Despite the fact that I don't actually use this desktop manager
      # I keep it installed because it includes the lovely things that
      # I like about KDE, such as Konsole
      desktopManager.plasma5.enable = true;

    };
  };

  ### User Accounts ############################################################

  users.users.jorel = {
    isNormalUser = true;
    home = "/home/jorel";
    description = "C'Taz'M'Kazm";
    extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" ];
    uid = 1000;
    shell = pkgs.fish;                  # Use fish as the default shell
  };

  ### Nix Configuration (Honestly, I have no idea what this is) ################

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];
    trustedUsers = [ "root" "jorel" ];

    # USE WITH CAUTION
    readOnlyStore = false;              # Allows writing access to /nix/store
  };

  ### NixPkgs Configuration ####################################################

  nixpkgs.config = {
    allowUnfree = true;                 # Allow unfree/proprietary packages
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };

  ### NixOS System Version (Do not touch) ######################################

  system.stateVersion = "18.09";

}
